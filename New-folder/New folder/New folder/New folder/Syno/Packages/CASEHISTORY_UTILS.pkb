create or replace
package body CASEHISTORY_UTILS
as

	/* Stage starts when a case is placed at that stage.
	   This function creates an entry in CASEHISTORYSUM for the case and stage,
	   and populates STAGESTARTTIMESTAMP. p_userID should be CREATED_USERID.
	   It returns the CHID of the new entry.
	 */
	Function startStage(
					    p_caseID IN NUMBER,
					    p_stageID IN NUMBER,
					    p_userID IN NUMBER   
					   ) return Number
	Is
		PRAGMA AUTONOMOUS_TRANSACTION;
		v_chid Number;
		v_ts CASEHISTORYSUM.STAGESTARTTIMESTAMP%TYPE;
		v_return Number;
		v_code NUMBER;
   		v_errm VARCHAR2(512);
	Begin
		select CASEHISTORYSUM_SEQ.nextval into v_chid from dual;
		select current_timestamp into v_ts from dual;
		--start the stage
		INSERT INTO CASEHISTORYSUM
		  (
			CHID,
			CASEID,
			STAGEID,
			THREAD_NUM,
			STAGESTARTTIMESTAMP,
			CREATED_TIMESTAMP,
			CREATED_USERID,
			CREATED_STAGEID
		  ) VALUES (v_chid, p_caseID, p_stageID,
		    casehistory_utils.GetThreadNumByCaseStage(P_caseid,p_stageid),
		   v_ts, v_ts, p_userID, p_stageID);
		v_return := v_chid;
		commit;
		DBMS_OUTPUT.PUT_LINE('Stage start recorded for case ' || p_caseID || ', stage ' || p_stageID);  
		return v_return;
	EXCEPTION
	WHEN OTHERS THEN
		v_code := SQLCODE;
        v_errm := SUBSTR(SQLERRM, 1 , 512);
        DBMS_OUTPUT.PUT_LINE('Error code ' || v_code || ': ' || v_errm);
		
		ROLLBACK;
		raise; --raise_application_error(-20001, '');
	End startStage;
					   
	/* Stage completes when a case is moved out of that stage.
	   This procedure populates STAGECOMPLETIONTIMESTAMP of the open stage entry in CASEHISTORYSUM,
	   looks up the open assignment entry for the current stage, and if found, populates ASSIGNMENTCOMPLETIONTIMESTAMP.
	   p_userID is to be used to populate UPDATED_USERID.
	 */
	Procedure completeStage(
					    p_caseID IN NUMBER,
					    p_stageID IN NUMBER,
					    p_userID IN NUMBER,
              			p_reason IN VARCHAR2
					   )
	Is
		--PRAGMA AUTONOMOUS_TRANSACTION;
		v_ts CASEHISTORYSUM.STAGESTARTTIMESTAMP%TYPE;
		v_return Number;
		v_code NUMBER;
   		v_errm VARCHAR2(512);
		v_rowcount Number;
	Begin
		select current_timestamp into v_ts from dual;
		--complete the current stage
    if p_reason is not null then
             update CASEHISTORYSUM
             set STAGECOMPLETIONTIMESTAMP = v_ts,
              UPDATED_TIMESTAMP = v_ts,
              UPDATED_USERID = p_userID,
              UPDATED_STAGEID = p_stageID,
              ASSIGNMENT_REASON = p_reason
              where caseid = p_caseID and stageid = p_stageID and STAGESTARTTIMESTAMP is not null and STAGECOMPLETIONTIMESTAMP is null;
       else
             update CASEHISTORYSUM
             set STAGECOMPLETIONTIMESTAMP = v_ts,
              UPDATED_TIMESTAMP = v_ts,
              UPDATED_USERID = p_userID,
              UPDATED_STAGEID = p_stageID
             --   ASSIGNMENT_REASON =null
                where caseid = p_caseID and stageid = p_stageID and STAGESTARTTIMESTAMP is not null and STAGECOMPLETIONTIMESTAMP is null;
              
      end if;
       
		v_rowcount := SQL%ROWCOUNT;
		if (v_rowcount > 0) then
			DBMS_OUTPUT.PUT_LINE('Stage complete recorded for case ' || p_caseID || ', stage ' || p_stageID);
		else
			DBMS_OUTPUT.PUT_LINE('Stage was already marked complete for case ' || p_caseID || ', stage ' || p_stageID);
		end if;
		
		--complete the current assignment
    
              select current_timestamp into v_ts from dual;
        if p_reason is not  null then
              update CASEHISTORYSUM
              set ASSIGNMENTCOMPLETIONTIMESTAMP = v_ts,
                UPDATED_TIMESTAMP = v_ts,
                UPDATED_USERID = p_userID,
                UPDATED_STAGEID = p_stageID,
                ASSIGNMENT_REASON = p_reason
              where caseid = p_caseID and stageid = p_stageID and ASSIGNMENTSTARTTIMESTAMP is not null and ASSIGNMENTCOMPLETIONTIMESTAMP is null;
        else
              update CASEHISTORYSUM
              set ASSIGNMENTCOMPLETIONTIMESTAMP = v_ts,
                UPDATED_TIMESTAMP = v_ts,
                UPDATED_USERID = p_userID,
                UPDATED_STAGEID = P_STAGEID
              --  ASSIGNMENT_REASON =null
                where caseid = p_caseID and stageid = p_stageID and ASSIGNMENTSTARTTIMESTAMP is not null and ASSIGNMENTCOMPLETIONTIMESTAMP is null;
       
       end if;   
		v_rowcount := SQL%ROWCOUNT;
		if (v_rowcount > 0) then
			DBMS_OUTPUT.PUT_LINE('Assignment complete recorded for case ' || p_caseID || ', stage ' || p_stageID);
		else
			DBMS_OUTPUT.PUT_LINE('Assignment was already marked complete for case ' || p_caseID || ', stage ' || p_stageID);
		end if;
		
		commit;
	EXCEPTION
	WHEN OTHERS THEN
		v_code := SQLCODE;
        v_errm := SUBSTR(SQLERRM, 1 , 512);
        DBMS_OUTPUT.PUT_LINE('Error code ' || v_code || ': ' || v_errm);
		
		ROLLBACK;
		raise; --raise_application_error(-20001, '');
	End completeStage;

	Procedure completeStage(
					    p_caseID IN NUMBER,
					    p_stageID IN NUMBER,
					    p_userID IN NUMBER   
					   )
	Is
	Begin
		completeStage(p_caseID, p_stageID, p_userID, null);
	End completeStage;
					   
	/* This function looks up open assignment entry for the current stage,
	   if no entry exists, it will create a new entry with USERID and ASSIGNMENTSTARTTIMESTAMP;
	   if an entry exists but not for the assignee, it will populate ASSIGNMENTCOMPLETIONTIMESTAMP for that entry 
	   and then create a new entry with USERID and ASSIGNMENTSTARTTIMESTAMP;
	   if an entry exists for the assignee, it won't do anything.
	   It returns the CHID of the new entry or the existing entry for the assignee.
	 */
	Function assignStageToUser(
					    p_caseID IN NUMBER,
					    p_stageID IN NUMBER,
					    p_assigned_to IN NUMBER,
						p_assigned_by IN NUMBER,
						p_assignment_reason IN VARCHAR2,
						p_notes IN VARCHAR2
					   ) return Number
	Is
		PRAGMA AUTONOMOUS_TRANSACTION;
		v_chid Number;
		v_ts CASEHISTORYSUM.STAGESTARTTIMESTAMP%TYPE;
		v_return Number;
		v_code NUMBER;
   		v_errm VARCHAR2(512);
		v_rowcount Number;
	Begin
		select current_timestamp into v_ts from dual;
		--if the stage is assigned to another user, complete that assignment
		update CASEHISTORYSUM
		set ASSIGNMENTCOMPLETIONTIMESTAMP = v_ts,
			UPDATED_TIMESTAMP = v_ts,
			UPDATED_USERID = p_assigned_by,
			UPDATED_STAGEID = p_stageID
		where userid != p_assigned_to and caseid = p_caseID and stageid = p_stageID and ASSIGNMENTSTARTTIMESTAMP is not null and ASSIGNMENTCOMPLETIONTIMESTAMP is null;
		v_rowcount := SQL%ROWCOUNT;
		if (v_rowcount > 0) then
			DBMS_OUTPUT.PUT_LINE('Stage was assigned to someone else; completed that assignment for case ' || p_caseID || ', stage ' || p_stageID);
		else
			DBMS_OUTPUT.PUT_LINE('Stage was not assigned to anyone else for case ' || p_caseID || ', stage ' || p_stageID);
		end if;
		
		Begin
			--is the stage assigned to this user already?
			select chid into v_chid from CASEHISTORYSUM
			where userid = p_assigned_to and caseid = p_caseID and stageid = p_stageID and ASSIGNMENTSTARTTIMESTAMP is not null and ASSIGNMENTCOMPLETIONTIMESTAMP is null;
			v_return := v_chid;
			DBMS_OUTPUT.PUT_LINE('Stage was already assigned to user ' || p_assigned_to || ' for case ' || p_caseID || ', stage ' || p_stageID);
		EXCEPTION
		WHEN no_data_found THEN
			select CASEHISTORYSUM_SEQ.nextval into v_chid from dual;
			select current_timestamp into v_ts from dual;
			--assign the stage to this user
			INSERT INTO CASEHISTORYSUM
			  (
				CHID,
				CASEID,
				USERID,
				STAGEID,
				THREAD_NUM,
				ASSIGNMENTSTARTTIMESTAMP,
				ASSIGNEDBY,
				CREATED_TIMESTAMP,
				CREATED_USERID,
				CREATED_STAGEID,
				ASSIGNMENT_REASON,
				NOTES
			  )   VALUES (v_chid, p_caseID, p_assigned_to, p_stageID,
			      casehistory_utils.GetThreadNumByCaseStage(P_caseid,p_stageid),
			       v_ts, p_assigned_by, v_ts, p_assigned_by, p_stageID, p_assignment_reason, p_notes);
			v_return := v_chid;
			commit;
			DBMS_OUTPUT.PUT_LINE('Stage assigned to user ' || p_assigned_to || ' for case ' || p_caseID || ', stage ' || p_stageID);
		End;
	commit;	
		  
	return v_return;
	EXCEPTION
	WHEN OTHERS THEN
		v_code := SQLCODE;
        v_errm := SUBSTR(SQLERRM, 1 , 512);
        DBMS_OUTPUT.PUT_LINE('Error code ' || v_code || ': ' || v_errm);
		
		ROLLBACK;
		raise; --raise_application_error(-20001, '');
	End assignStageToUser;





	/* Similar to assignStageToUser but simplier.
	   Is called only when other processed have determined there is no open assignment
	   it will create a new entry with USERID and ASSIGNMENTSTARTTIMESTAMP;
	   It returns the CHID of the new entry or the existing entry for the assignee.
	 */
	Function assignUser(
					    p_caseID IN NUMBER,
					    p_stageID IN NUMBER,
					    p_assigned_to IN NUMBER,
						p_assigned_by IN NUMBER,
						p_assignment_reason IN VARCHAR2,
						p_notes IN VARCHAR2
					   ) return Number
	Is
		PRAGMA AUTONOMOUS_TRANSACTION;
		v_chid Number;
		v_ts CASEHISTORYSUM.STAGESTARTTIMESTAMP%TYPE;
		v_return Number;
		v_code NUMBER;
   		v_errm VARCHAR2(512);
		v_rowcount Number;
	Begin
		
		
			select CASEHISTORYSUM_SEQ.nextval into v_chid from dual;
			select current_timestamp into v_ts from dual;
			--assign the stage to this user
			INSERT INTO CASEHISTORYSUM
			  (
				CHID,
				CASEID,
				USERID,
				STAGEID,
				THREAD_NUM,
				ASSIGNMENTSTARTTIMESTAMP,
				ASSIGNEDBY,
				CREATED_TIMESTAMP,
				CREATED_USERID,
				CREATED_STAGEID,
				ASSIGNMENT_REASON,
				NOTES
			  )   VALUES (v_chid, p_caseID, p_assigned_to, p_stageID,
			      casehistory_utils.GetThreadNumByCaseStage(P_caseid,p_stageid),
			   v_ts, p_assigned_by, v_ts, p_assigned_by, p_stageID, p_assignment_reason, p_notes);
			v_return := v_chid;
			commit;
			DBMS_OUTPUT.PUT_LINE('Stage assigned to user ' || p_assigned_to || ' for case ' || p_caseID || ', stage ' || p_stageID);
		
	commit;	
		  
	return v_return;
	EXCEPTION
	WHEN OTHERS THEN
		v_code := SQLCODE;
        v_errm := SUBSTR(SQLERRM, 1 , 512);
        DBMS_OUTPUT.PUT_LINE('Error code ' || v_code || ': ' || v_errm);
		
		ROLLBACK;
		raise; --raise_application_error(-20001, '');
	End assignUser;


	
	/* Helper procedure to manually move a case to the specified stage, and optionally assign it to the specified user.
	   It will complete the current stage(s) and start the new stage.
	   If the case is already at the stage, no stage movement will happen.
	   If the case is already assigned to the user, no assignment change will happen.
	   p_userID is for auditing.
	 */
/*** to Test in SQL					   
Begin
  CASEHISTORY_UTILS.Stagehop(
					    P_Caseid => 2845,
					    P_Stageid => 4,
					    P_Userid => 3,   
					    P_Assigned_To => 3,
						P_Assignment_Reason => 'test',
						p_notes => 'test' 
					   );
end;	
***/	 
	Procedure stageHop( p_caseID IN NUMBER,
					    p_stageID IN NUMBER,
					    p_userID IN NUMBER,   
					    p_assigned_to IN NUMBER default null,
						p_assignment_reason IN VARCHAR2 default null,
						p_notes IN VARCHAR2 default null
					   )

				   
	Is
		v_chid Number;
		v_code NUMBER;
   		v_errm VARCHAR2(512);
		v_dummy Number;
		
		--a case can be at multiple stages
		cursor c_stages is 
			select stageid from CASEHISTORYSUM where caseid=p_caseID
			and STAGESTARTTIMESTAMP is not null and STAGECOMPLETIONTIMESTAMP is null;
	Begin
		

		
		--If the case is already at the stage, no stage movement will happen.
		Begin
			select chid into v_chid from CASEHISTORYSUM
			where caseid=p_caseID and stageid=p_stageID
			and STAGESTARTTIMESTAMP is not null and STAGECOMPLETIONTIMESTAMP is null
			and rownum=1 order by chid desc;
			DBMS_OUTPUT.PUT_LINE('Case ' || p_caseID || ' already at stage ' || p_stageID);
		Exception
		When No_data_found Then
			--complete current stage(s)
			for r_stage in c_stages loop
				completeStage(p_caseid, 
							  r_stage.stageid, 
							  p_userid);
			End loop;
			--start new stage
			v_dummy := startStage(p_caseid, 
							      p_stageid, 
								  p_userid);
		end;
	
		if (p_assigned_to is not null) Then
			--If the case is already assigned to the user, no assignment change will happen.
			Begin
				select chid into v_chid from CASEHISTORYSUM
				where caseid=p_caseID and stageid=p_stageID and userid=p_assigned_to
				and ASSIGNMENTSTARTTIMESTAMP is not null and ASSIGNMENTCOMPLETIONTIMESTAMP is null
				and rownum=1 order by chid desc;
				DBMS_OUTPUT.PUT_LINE('Stage was already assigned to user ' || p_assigned_to || ' for case ' || p_caseID || ', stage ' || p_stageID);
			Exception
			When No_data_found Then
				--assign user to new stage
				v_dummy := assignStageToUser(p_caseID,
											 p_stageID,
											 p_assigned_to,
											 p_userID,
											 p_assignment_reason,
											 p_notes);
			end;
		end if;
	commit;	
		
	EXCEPTION
	WHEN OTHERS THEN
		v_code := SQLCODE;
        v_errm := SUBSTR(SQLERRM, 1 , 512);
        DBMS_OUTPUT.PUT_LINE('Error code ' || v_code || ': ' || v_errm);
		
		ROLLBACK;
		raise; --raise_application_error(-20001, '');
	End stageHop;
					   


	



------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------

	 
	Procedure stageAssignHandler(
					    p_caseID IN NUMBER,
				        P_Thread in Number default null,
					    p_new_stageID IN NUMBER,
					    p_new_assigned_to IN NUMBER default null,
						p_assignment_reason IN VARCHAR2 default null, 
						p_notes IN VARCHAR2 default null,
						p_userID IN NUMBER,   -- for auditing	
			            P_message in out varchar2					
					   )


	/* ---------------------------------------------------------------------------------------
	   Comprehensive procedure to move a case to the specified stage, and optionally assign it to the specified user.
	   It will complete the current stage(s) and start the new stage.
	   If the case is already at the stage, no stage movement will happen.
	   If the case is already assigned to the user, no assignment change will happen.
	   p_userID is for auditing.
	   If the new stage is parallel, it will not close other parallel stages
	   If Assigned_to and StageId are null, no action to be taken  
	   
	   Approach
	   -- single thread
	   -- close all open multi-threads
	   -- close 
	   
	   
	 */
/*** to test in SQL	 
set serveroutput on ;
declare
	v_message varchar2(8000);
Begin
  CASEHISTORY_UTILS.stageAssignHandler(
					    P_Caseid => 2845,
						P_thread => 1,
					    P_new_Stageid => 101,
                        P_new_Assigned_To => 1,
					    P_Userid => 3,   
						P_Assignment_Reason => 'test',
						p_notes => 'test' ,
						p_message => v_message
					   );
  dbms_output.put_line (v_message);			
  Dbms_Output.Put_Line (Iws_App_Utils.Show_Assign_Status(2845));	
  dbms_output.put_line (iws_app_utils.Show_stage_Status(2845));		   
end;
***/

	Is
		v_chid Number;
		v_code NUMBER;
   		v_errm VARCHAR2(512);
		v_dummy Number;
		v_clientid number;
		v_lf varchar2(10);
		v_now timestamp;
		v_count number;
		I number;
		
		v_OpenAssignCount number;
		v_OpenStageCount number;
	    v_parallelism number;
		
		v_CUR_stageid number;
		v_CUR_assigned_to number;

	Begin
	
	--v_lf := '. ' || chr(10);	
	v_lf := '. <br>';
	select clientid into v_clientid from CASES where CASEID = P_CASEID;
	
	v_now := systimestamp;   -- Static currenttimestamp to use consistently within LUW
	
	P_Message := P_Message || ' Thread=' || P_Thread ||
	                          ' Stage=' || P_NEW_stageid ||    
							  ' Assigned=' || P_NEW_assigned_to ||
							  ' Reason=' || P_assignment_reason ||
							  ' Notes=' || P_Notes ||
							  ' by=' || P_userid ||
							  v_lf;


  --- Fix any missing THREADNUMS in CASEHISTORYSUM
  --- Until QCAI and IWS stage completions are updated to populate thread_NUM, 
  --- do them for this case now.
	 Update Casehistorysum
     Set Thread_num = Casehistory_Utils.GetThreadnumByCasestage(P_Caseid,P_NEW_Stageid)
	 where CASEID = P_CASEID
           and thread_num is null;
     commit;						  
					
					
							  

     --- Find and Close any multiple Open Assigns for this case-thread
	 --- that differ from the requested Assignee
     Select count(*) into v_OpenAssignCount
	  from CASEHISTORYSUM
	  where CASEID = P_CASEID
	    and THREAD_NUM = P_THREAD 
		and USERID <> P_NEW_assigned_to
        and ASSIGNMENTSTARTTIMESTAMP IS NOT NULL AND ASSIGNMENTCOMPLETIONTIMESTAMP IS NULL;

	   IF v_OpenAssignCount > 1
     	   THEN 
		  --- Close all open Assigns that are NOT for this USER for this case and thread
		  --- don't need to close 
		  FOR A IN (SELECT CHID,STAGEID,USERID 
		    from   CASEHISTORYSUM 
			where CASEID=P_CASEID and ASSIGNMENTSTARTTIMESTAMP IS NOT NULL AND ASSIGNMENTCOMPLETIONTIMESTAMP is NULL -- open stages
			      and THREAD_NUM = P_THREAD 
			      and USERID <> P_NEW_assigned_to
			order by chid)
		  LOOP	
			 P_Message := P_Message || 'Closing Extra Open Assign in this Thread (x1) '  || A.STAGEID || ' '  || P_THREAD || ' ' || A.USERID || ' ' || A.CHID || v_lf;
		     UPDATE CASEHISTORYSUM set ASSIGNMENTCOMPLETIONTIMESTAMP = v_now,
			                           ASSIGNMENT_REASON = P_ASSIGNMENT_REASON,
					                   NOTES = P_NOTES			 
			                    where CHID=A.CHID; 
		END LOOP;	
		--P_Message := P_Message || 'Multiple Assignments are open for this thread.  (x1) ' || P_Thread || ' ' || v_count || v_lf;   
		END IF;   
	  



     --- Find and Close any multiple Open Stages for this case-thread
	 --- that differ from the requested Stage
	  Select count(*) into v_OpenStageCount
	  from CASEHISTORYSUM
	  where CASEID = P_CASEID
	    and THREAD_NUM = P_THREAD 
		and STAGEID <> P_NEW_STAGEID
        and STAGESTARTTIMESTAMP IS NOT NULL AND STAGECOMPLETIONTIMESTAMP IS NULL;	
	  	
	   IF v_OpenStageCount > 1
     	   THEN
		 --- Close all open Stages for this Thread that are NOT the desired STAGE 
		  FOR A IN (SELECT CHID,STAGEID,USERID 
		    from   CASEHISTORYSUM 
			where CASEID=P_CASEID and STAGESTARTTIMESTAMP IS NOT NULL AND STAGECOMPLETIONTIMESTAMP is NULL -- open stages
		    	and THREAD_NUM = P_THREAD
			    and STAGEID <> P_NEW_STAGEID
			order by chid)
		  LOOP	
			 P_Message := P_Message || 'Closing Extra Open Stage in this Thread (x2) ' || A.STAGEID || ' '  || P_THREAD || ' ' || A.USERID || ' ' || A.CHID || v_lf;
		     UPDATE CASEHISTORYSUM set STAGECOMPLETIONTIMESTAMP = v_now,
			                           ASSIGNMENT_REASON = P_ASSIGNMENT_REASON,
					                   NOTES = P_NOTES			 
			                    where CHID=A.CHID; 
		END LOOP;	
		--P_Message := P_Message || 'Multiple Stages are open for this thread.  (x2) ' || P_Thread || ' ' || v_count || v_lf;
		END IF;   


							  

     --- Find and Close any multiple Open Assigns for this case-thread
	 --- that differ from the requested Assignee
     Select count(*) into v_OpenAssignCount
	  from CASEHISTORYSUM
	  where CASEID = P_CASEID
	    and THREAD_NUM = P_THREAD 
		and (USERID = P_NEW_assigned_to OR USERID is NULL)
        and ASSIGNMENTSTARTTIMESTAMP IS NOT NULL AND ASSIGNMENTCOMPLETIONTIMESTAMP IS NULL;

	   IF v_OpenAssignCount > 1
     	   THEN 
		   I := 1;
		  --- Close all open Assigns that are NOT for this USER for this case and thread
		  --- don't need to close
		  FOR A IN (SELECT CHID,STAGEID,USERID 
		    from   CASEHISTORYSUM 
			where CASEID=P_CASEID 
			      and THREAD_NUM = P_THREAD 
			      and (USERID = P_NEW_assigned_to OR USERID IS NULL)
				  and ASSIGNMENTSTARTTIMESTAMP IS NOT NULL AND ASSIGNMENTCOMPLETIONTIMESTAMP is NULL -- open stages
			order by chid)
		  LOOP
		  	 IF I >= 2 THEN	
			    P_Message := P_Message || 'Closing Redundant Open Assign in this Thread (x3) '  || A.STAGEID || ' '  || P_THREAD || ' ' || A.USERID || ' ' || A.CHID || v_lf;
		        UPDATE CASEHISTORYSUM set ASSIGNMENTCOMPLETIONTIMESTAMP = v_now,
			                           ASSIGNMENT_REASON = P_ASSIGNMENT_REASON,
					                   NOTES = P_NOTES			 
			                    where CHID=A.CHID;
			 ELSE
			  null;	
			  --P_Message := P_Message || 'Left Primary Open Assignment in this Thread (x4) ' || A.STAGEID || ' '  || P_THREAD || ' ' || A.USERID || ' ' || A.CHID || v_lf;
								
			END IF;
			I := I + 1;					 
		END LOOP;	
	    --P_Message := P_Message || 'Redundant Assignments are open for this user thread.  (x5) ' || P_Thread || ' ' || v_count || v_lf;
		   
		END IF;   
	  






     --- Find and Close all But the Oldest of any multiple Open Stages for this case-thread
	 --- that are redundant to the requested Stage
	  Select count(*) into v_OpenStageCount
	  from CASEHISTORYSUM
	  where CASEID = P_CASEID
	    and THREAD_NUM = P_THREAD 
		and STAGEID = P_NEW_STAGEID
        and STAGESTARTTIMESTAMP IS NOT NULL AND STAGECOMPLETIONTIMESTAMP IS NULL;	
	  	
	   IF v_OpenStageCount >= 2
     	   THEN
		 --- Close all open Stages for this Thread that are NOT the desired STAGE 
		  I := 1;
		  FOR A IN (SELECT CHID,STAGEID,USERID 
		    from   CASEHISTORYSUM 
			where CASEID=P_CASEID
			    and THREAD_NUM = P_THREAD
				and STAGEID = P_NEW_STAGEID 
			    and STAGESTARTTIMESTAMP IS NOT NULL AND STAGECOMPLETIONTIMESTAMP is NULL -- open stages
			order by chid)
		  LOOP	
		  	 IF I >= 2 THEN   --- leave the oldest CHID OPEN
    			 P_Message := P_Message || 'Closing Redundant Open Stage in this Thread (x7) ' || A.STAGEID || ' '  || P_THREAD || ' ' || A.USERID || ' ' || A.CHID || v_lf;
	    	     UPDATE CASEHISTORYSUM set STAGECOMPLETIONTIMESTAMP = v_now,
			                           ASSIGNMENT_REASON = P_ASSIGNMENT_REASON,
					                   NOTES = P_NOTES			 
			                    where CHID=A.CHID;
			  ELSE
			  	null;
			  	--P_Message := P_Message || 'Left Primary Open Stage in this Thread (x8) ' || A.STAGEID || ' '  || P_THREAD || ' ' || A.USERID || ' ' || A.CHID || v_lf;
			END IF;
			I := I+1;					 
		  END LOOP;
  		  --P_Message := P_Message || 'Redundant Stages are open for this thread.  (x9) ' || P_Thread || ' ' || v_count || v_lf;
      END IF;   





     --- If 2 differnt stages in the Same thread are both Open, Close all but the Oldest One
	  Select count(*) into v_OpenStageCount
	  from CASEHISTORYSUM
	  where CASEID = P_CASEID
	    and THREAD_NUM = P_THREAD 
        and STAGESTARTTIMESTAMP IS NOT NULL AND STAGECOMPLETIONTIMESTAMP IS NULL;	
	  	
	   IF v_OpenStageCount >= 2
     	   THEN
		 --- Close all but the Oldest Multiple Stages for this Thread  
		  I := 1;
		  FOR A IN (SELECT CHID,STAGEID,USERID 
		    from   CASEHISTORYSUM 
			where CASEID=P_CASEID
			    and THREAD_NUM = P_THREAD
			    and STAGESTARTTIMESTAMP IS NOT NULL AND STAGECOMPLETIONTIMESTAMP is NULL -- open stages
			order by chid)
		  LOOP	
		  	 IF I >= 2 THEN   --- leave the oldest CHID OPEN
    			 P_Message := P_Message || 'Closing Conflicting Open Stage in this Thread (x10) ' || A.STAGEID || ' '  || P_THREAD || ' ' || A.USERID || ' ' || A.CHID || v_lf;
	    	     UPDATE CASEHISTORYSUM set STAGECOMPLETIONTIMESTAMP = v_now,
			                           ASSIGNMENT_REASON = P_ASSIGNMENT_REASON,
					                   NOTES = P_NOTES			 
			                    where CHID=A.CHID;
			  ELSE
			  	null;
			  	--P_Message := P_Message || 'Left Primary Open Stage in this Thread (x8) ' || A.STAGEID || ' '  || P_THREAD || ' ' || A.USERID || ' ' || A.CHID || v_lf;
			END IF;
			I := I+1;					 
		  END LOOP;
  		  --P_Message := P_Message || 'Redundant Stages are open for this thread.  (x9) ' || P_Thread || ' ' || v_count || v_lf;
      END IF;   






     --- If 2 differnt Assigns or Null assigns in the Same thread are both Open, Close the Null Assign





 		
   --- See if this assignee  is already in the table
     Select count(*) into v_count
	  from CASEHISTORYSUM
	  where CASEID = P_CASEID
	    and STAGEID in (select STAGEID from Workflows_By_Thread  where CLIENTID=v_clientid and THREADNUM = P_THREAD) 
		and STAGEID =  P_NEW_stageid
		and USERID = P_NEW_assigned_to
        and ASSIGNMENTSTARTTIMESTAMP IS NOT NULL AND ASSIGNMENTCOMPLETIONTIMESTAMP IS NULL;

     
	  CASE
	  --- ****No Change request passed	
	   WHEN  p_new_assigned_to IS NULL AND p_new_stageID IS NULL
     	   THEN P_Message := P_Message || 'No change requested for thread (aa) ' || P_Thread || v_lf;


	  --- Passed values match existing values (occurs if screen is not cleared and existing values are resaved	
	   WHEN  v_count = 1
     	   THEN P_Message := P_Message || 'Passed values are already present.  No changes (ab) ' || P_Thread || ' ' || v_count || v_lf;

	  --- Passed values match existing values (occurs if screen is not cleared and existing values are resaved	
	   WHEN  v_count >= 2
     	   THEN P_Message := P_Message || 'Passed values are present but Redundant. (ac) ' || P_Thread || ' ' || v_count || v_lf;


      --- **** Working on single Threaded 
	   WHEN  P_THREAD = 0
     	   THEN 
		   			   
		 --- Close all open Multi-threaded Assignments for this case
		 FOR A IN (SELECT CHID,STAGEID,USERID 
		    from   CASEHISTORYSUM 
			where CASEID=P_CASEID and ASSIGNMENTSTARTTIMESTAMP IS NOT NULL AND ASSIGNMENTCOMPLETIONTIMESTAMP is NULL -- open assigns
			and STAGEID in (select STAGEID from Workflows_By_Thread  where CLIENTID=v_clientid and THREADNUM >= 1)   -- multi-thread
			order by chid)
		  LOOP	
			 P_Message := P_Message || 'Completing Multi-Threaded Assignment (0b) ' || A.STAGEID || ' ' || A.USERID || ' ' || A.CHID || v_lf;
		     UPDATE CASEHISTORYSUM set ASSIGNMENTCOMPLETIONTIMESTAMP = v_now,
			          ASSIGNMENT_REASON = P_ASSIGNMENT_REASON, 
					  NOTES = P_NOTES
			   where CHID=A.CHID; 
		END LOOP;	
			
		    
		 --- Close all open Multi-threaded Stages for this case
		 FOR A IN (SELECT CHID,STAGEID,USERID 
		    from   CASEHISTORYSUM 
			where CASEID=P_CASEID and STAGESTARTTIMESTAMP IS NOT NULL AND STAGECOMPLETIONTIMESTAMP is NULL -- open stages
			and STAGEID in (select STAGEID from Workflows_By_Thread  where CLIENTID=v_clientid and THREADNUM >= 1)   -- multi-thread
			order by chid)
		  LOOP	
			 P_Message := P_Message || 'Completing Multi-Threaded Stage (0c) ' || A.STAGEID || ' ' || A.USERID || ' ' || A.CHID || v_lf;
		     UPDATE CASEHISTORYSUM set STAGECOMPLETIONTIMESTAMP = v_now,
			          ASSIGNMENT_REASON = P_ASSIGNMENT_REASON,
					  NOTES = P_NOTES
					  where CHID=A.CHID; 
		END LOOP;	


		 --- Close all open Single-threaded Assignments that are NOT for this ASSIGNEE for this case
	   IF P_USERID IS NOT NULL THEN
		 FOR A IN (SELECT CHID,STAGEID,USERID 
		    from   CASEHISTORYSUM 
			where CASEID=P_CASEID and ASSIGNMENTSTARTTIMESTAMP IS NOT NULL AND ASSIGNMENTCOMPLETIONTIMESTAMP is NULL -- open assigns
			and STAGEID in (select STAGEID from Workflows_By_Thread  where CLIENTID=v_clientid and THREADNUM = 0)   -- single-thread
			and USERID <> P_USERID --- dont close nulls, might be assigned momentarily
			order by chid)
		  LOOP	
			 P_Message := P_Message || 'Completing Single-Threaded Assignment (0d) ' || A.STAGEID || ' ' || A.USERID || ' ' || A.CHID || v_lf;
		     UPDATE CASEHISTORYSUM set ASSIGNMENTCOMPLETIONTIMESTAMP = v_now,
			                           ASSIGNMENT_REASON = P_ASSIGNMENT_REASON,
					                   NOTES = P_NOTES
			  where CHID=A.CHID; 
		END LOOP;
	 END IF;	
	  		

	 --- Close all open Single-threaded Assignments that are NOT for this ASSIGNEE for this case, 
	 -- and this is New Stage
	   IF P_NEW_STAGEID IS NOT NULL THEN
		 FOR A IN (SELECT CHID,STAGEID,USERID 
		    from   CASEHISTORYSUM 
			where CASEID=P_CASEID and ASSIGNMENTSTARTTIMESTAMP IS NOT NULL AND ASSIGNMENTCOMPLETIONTIMESTAMP is NULL -- open assigns
			and STAGEID in (select STAGEID from Workflows_By_Thread  where CLIENTID=v_clientid and THREADNUM = 0)   -- single-thread
			--and (USERID <> P_USERID OR USERID IS NULL) 
			order by chid)
		  LOOP	
			 P_Message := P_Message || 'Completing Single-Threaded Assignment (0e) ' || A.STAGEID || ' ' || A.USERID || ' ' || A.CHID || v_lf;
		     UPDATE CASEHISTORYSUM set ASSIGNMENTCOMPLETIONTIMESTAMP = v_now,
			                           ASSIGNMENT_REASON = P_ASSIGNMENT_REASON,
					                   NOTES = P_NOTES
									   where CHID=A.CHID; 
		END LOOP;
	 END IF;	
		
		
		 --- Close all open Single-threaded Stages that are NOT for this STAGE for this case
		  FOR A IN (SELECT CHID,STAGEID,USERID 
		    from   CASEHISTORYSUM 
			where CASEID=P_CASEID and STAGESTARTTIMESTAMP IS NOT NULL AND STAGECOMPLETIONTIMESTAMP is NULL -- open stages
			and STAGEID in (select STAGEID from Workflows_By_Thread  where CLIENTID=v_clientid and THREADNUM = 0)   -- single-thread
			and STAGEID <> P_NEW_STAGEID
			order by chid)
		  LOOP	
			 P_Message := P_Message || 'Completing Single-Threaded Stage (0f) ' || A.STAGEID || ' ' || A.USERID || ' ' || A.CHID || v_lf;
		     UPDATE CASEHISTORYSUM set STAGECOMPLETIONTIMESTAMP = v_now,
			 			               ASSIGNMENT_REASON = P_ASSIGNMENT_REASON,
					                   NOTES = P_NOTES
			                        where CHID=A.CHID; 
		END LOOP;	
		
		
		--- Now do the stage requested, if ncessary
		IF p_new_stageID IS NOT NULL 
		  then
		 	--- See if this stage is already Open
		  Select count(*) into v_count 
		    from   CASEHISTORYSUM 
			where CASEID=P_CASEID and STAGESTARTTIMESTAMP IS NOT NULL AND STAGECOMPLETIONTIMESTAMP is NULL -- open stages
			and STAGEID in (select STAGEID from Workflows_By_Thread  where CLIENTID=v_clientid and THREADNUM = 0)   -- single-thread
			and STAGEID =  P_NEW_STAGEID;
		 
		    IF v_count = 0 then	
		      P_message := p_message || 'Case ' || p_caseID || ' Started Stage (0g) ' ||  p_new_stageID || v_lf;
		      v_dummy := startStage(   p_caseID ,   p_new_stageID ,   p_userID  );
		    END IF;  -- v_count  
						 
		 END IF;				
				--check stage is segmented 	   
		 SELECT PARALLELISM into v_parallelism  FROM workflows_by_thread 
	                 where clientid=v_clientid 
                      and threadnum=P_THREAD and STAGEID=p_new_stageID;		   
		 
		--- Now do the assignment requested
		IF p_new_assigned_to IS NOT NULL and v_parallelism = 0
		 THEN
		    P_message := p_message || 'Case ' || p_caseID || ' assign Stage ToUser (0h) ' ||  p_new_assigned_to || v_lf;
		     v_dummy := assignUser(p_caseID,
							    	 p_new_stageID,
									 p_new_assigned_to,
									 p_userID,
									 p_assignment_reason,
									 p_notes);
	   END IF;											 
        --- end WHEN ----
 
 
      ---- **** Now working on Multi-Threaded
	   WHEN  P_THREAD >= 1
     	   THEN null; 
		 --- Close all open Single-threaded Assignments 
		 FOR A IN (SELECT CHID,STAGEID,USERID 
		    from   CASEHISTORYSUM 
			where CASEID=P_CASEID and ASSIGNMENTSTARTTIMESTAMP IS NOT NULL AND ASSIGNMENTCOMPLETIONTIMESTAMP is NULL -- open assigns
			and STAGEID in (select STAGEID from Workflows_By_Thread  where CLIENTID=v_clientid and THREADNUM = 0)   -- single-thread
			order by chid)
		  LOOP	
			 P_Message := P_Message || 'Completing Single-Threaded Assignment (1b) ' || A.STAGEID || ' ' || A.USERID || ' ' || A.CHID || v_lf;
		     UPDATE CASEHISTORYSUM set ASSIGNMENTCOMPLETIONTIMESTAMP = v_now,
			                           ASSIGNMENT_REASON = P_ASSIGNMENT_REASON,
					                   NOTES = P_NOTES			 
			                       where CHID=A.CHID; 
		END LOOP;	
			
		    
		 --- Close all open Single-threaded Stages 
		 FOR A IN (SELECT CHID,STAGEID,USERID 
		    from   CASEHISTORYSUM 
			where CASEID=P_CASEID and STAGESTARTTIMESTAMP IS NOT NULL AND STAGECOMPLETIONTIMESTAMP is NULL -- open stages
			and STAGEID in (select STAGEID from Workflows_By_Thread  where CLIENTID=v_clientid and THREADNUM = 0)   -- single-thread
			order by chid)
		  LOOP	
			 P_Message := P_Message || 'Completing Single-Threaded Stage (1c) ' || A.STAGEID || ' ' || A.USERID || ' ' || A.CHID || v_lf;
		     UPDATE CASEHISTORYSUM set STAGECOMPLETIONTIMESTAMP = v_now,
			 			               ASSIGNMENT_REASON = P_ASSIGNMENT_REASON,
					                   NOTES = P_NOTES
			                      where CHID=A.CHID; 
		END LOOP;	


----

	--- Close all open Multi-threaded Assignments that are NOT for this ASSIGNEE for this case and Thread
	   IF P_USERID IS NOT NULL THEN
		 FOR A IN (SELECT CHID,STAGEID,USERID 
		    from   CASEHISTORYSUM 
			where CASEID=P_CASEID and ASSIGNMENTSTARTTIMESTAMP IS NOT NULL AND ASSIGNMENTCOMPLETIONTIMESTAMP is NULL -- open assigns
			and STAGEID in (select STAGEID from Workflows_By_Thread  where CLIENTID=v_clientid and THREADNUM = P_THREAD)   -- single-thread
			and USERID <> P_USERID --- dont close nulls, might be assigned momentarily
			order by chid)
		  LOOP	
			 P_Message := P_Message || 'Completing Single-Threaded Assignment (1d) ' || A.STAGEID || ' ' || P_THREAD || ' ' || A.USERID || ' ' || A.CHID || v_lf;
		     UPDATE CASEHISTORYSUM set ASSIGNMENTCOMPLETIONTIMESTAMP = v_now,
			 			               ASSIGNMENT_REASON = P_ASSIGNMENT_REASON,
					                   NOTES = P_NOTES
			  where CHID=A.CHID; 
		END LOOP;
	 END IF;	
	  		

	 --- Close all open Multi-threaded Assignments that are NOT for this ASSIGNEE for this case and Thread 
	 -- and this is New Stage
	   IF P_NEW_STAGEID IS NOT NULL THEN
		 FOR A IN (SELECT CHID,STAGEID,USERID 
		    from   CASEHISTORYSUM 
			where CASEID=P_CASEID and ASSIGNMENTSTARTTIMESTAMP IS NOT NULL AND ASSIGNMENTCOMPLETIONTIMESTAMP is NULL -- open assigns
			and STAGEID in (select STAGEID from Workflows_By_Thread  where CLIENTID=v_clientid and THREADNUM = P_THREAD)   -- single-thread
			--and (USERID <> P_USERID OR USERID IS NULL) 
			order by chid)
		  LOOP	
			 P_Message := P_Message || 'Completing Multi-Threaded Assignment (1e) ' || A.STAGEID || ' ' || P_THREAD || ' ' || A.USERID || ' ' || A.CHID || v_lf;
		     UPDATE CASEHISTORYSUM set ASSIGNMENTCOMPLETIONTIMESTAMP = v_now,
			                           ASSIGNMENT_REASON = P_ASSIGNMENT_REASON,
					                   NOTES = P_NOTES			 
			                   where CHID=A.CHID; 
		END LOOP;
	 END IF;	
		
		
		 --- Close all open Multi-threaded Stages that are NOT for this STAGE for this case and thread
		  FOR A IN (SELECT CHID,STAGEID,USERID 
		    from   CASEHISTORYSUM 
			where CASEID=P_CASEID and STAGESTARTTIMESTAMP IS NOT NULL AND STAGECOMPLETIONTIMESTAMP is NULL -- open stages
			and STAGEID in (select STAGEID from Workflows_By_Thread  where CLIENTID=v_clientid and THREADNUM = P_THREAD )   -- single-thread
			and STAGEID <> P_NEW_STAGEID
			order by chid)
		  LOOP	
			 P_Message := P_Message || 'Completing Multi-Threaded Stage (1f) ' || A.STAGEID || ' '  || P_THREAD || ' ' || A.USERID || ' ' || A.CHID || v_lf;
		     UPDATE CASEHISTORYSUM set STAGECOMPLETIONTIMESTAMP = v_now,
			                           ASSIGNMENT_REASON = P_ASSIGNMENT_REASON,
					                   NOTES = P_NOTES			 
			                    where CHID=A.CHID; 
		END LOOP;	
		
		
		--- Now do the stage requested, if necessary
		IF p_new_stageID IS NOT NULL 
		  then
		 	--- See if this stage is already Open
		  Select count(*) into v_count 
		    from   CASEHISTORYSUM 
			where CASEID=P_CASEID and STAGESTARTTIMESTAMP IS NOT NULL AND STAGECOMPLETIONTIMESTAMP is NULL -- open stages
			and STAGEID in (select STAGEID from Workflows_By_Thread  where CLIENTID=v_clientid and THREADNUM = P_THREAD)   -- single-thread
			and STAGEID =  P_NEW_STAGEID;
		 
		    IF v_count = 0 then	
		      P_message := p_message || 'Case ' || p_caseID || ' Started Stage (1g) ' ||  p_new_stageID || ' ' || P_THREAD || v_lf;
		      v_dummy := startStage(   p_caseID ,   p_new_stageID ,   p_userID  );
		    END IF;  -- v_count  
						 
		 END IF;				
					--check stage is segmented 	   
		 SELECT PARALLELISM into v_parallelism  FROM workflows_by_thread 
	                 where clientid=v_clientid 
                      and threadnum=P_THREAD and STAGEID=p_new_stageID;				 

		
		--- Now do the assignment requested 
		If p_new_assigned_to IS NOT NULL  and v_parallelism = 0  --- Per IWN-1042, do not perform "blank" assignments-- 
		  then
		    P_message := p_message || 'Case ' || p_caseID || ' Assign Multi-Thread Stage To User (1h)' ||  p_new_assigned_to || v_lf;
	     	v_dummy := assignUser(p_caseID,
											 p_new_stageID,
											 p_new_assigned_to,
											 p_userID,
											 p_assignment_reason,
											 p_notes);
        end if;		   

    ELSE P_Message := P_Message || 'Invalid Thread';
		
	END CASE;
	
	--- Check for Duplicate Open assignments in the same Thread and close them
	
	-- Log request and results 
      LOG_APEX_ACTION(
           P_ACTIONID => 94,
           P_OBJECTTYPE => 'StageAssignHandler',
           --P_RESULTS =>  P_MESSAGE,
           P_ORIGINALVALUE => P_MESSAGE,
           --P_MODIFIEDVALUE =>   ,
           P_USERID =>  P_USERID,
           P_CASEID => P_CASEID);  		

		
	commit;

		
	EXCEPTION
	WHEN OTHERS THEN
		v_code := SQLCODE;
        v_errm := SUBSTR(SQLERRM, 1 , 512);
        P_message := substr('Error code ' || v_code || ': ' || v_errm || ' => ' || p_message,1,3500);
		LOG_APEX_ERROR(15,'Manually Assign Case',P_Message);
				
		ROLLBACK;
		raise; --raise_application_error(-20001, '');
		
		
	End stageAssignHandler;
------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------


	/* Get the ThreadNum for a ClientsStage		 */
	Function GetThreadNumByClientStage(
					    p_ClientID IN NUMBER,
					    p_stageID IN NUMBER
					   )
	    return Number

	Is
		v_ThreadNum Number;
	
	Begin
		
		Begin
		  select THREADNUM into v_THREADNUM 
		  from WORKFLOWS_BY_THREAD
		  where CLIENTID = P_CLIENTID
		  and STAGEID = P_STAGEID;
		
		EXCEPTION
		WHEN no_data_found
		  --- Assume single threaded if not found 
		   THEN v_THREADNUM := 0;
		End;
		  
  	return v_threadnum;
	
	End GetThreadNumByClientStage;



	/* Get the ThreadNum for a ClientsStage		 */
	Function GetThreadNumByCaseStage(
					    p_CaseID IN NUMBER,
					    p_stageID IN NUMBER
					   )
	    return Number

	Is
		v_ClientId Number;
		v_ThreadNum Number;
	
	Begin
		
		select clientid into v_clientid
		from cases 
		where caseid = p_CASEID;
		
		v_threadnum := GetThreadNumByClientStage(v_clientid,p_stageid);
		
		  
  	return v_threadnum;
	
	End GetThreadNumByCaseStage;




end CASEHISTORY_UTILS;
/