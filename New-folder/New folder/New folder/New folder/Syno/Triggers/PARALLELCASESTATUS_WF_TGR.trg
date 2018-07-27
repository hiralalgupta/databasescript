create or replace
TRIGGER PARALLELCASESTATUS_WF_TGR After UPDATE OF IsCompleted, Userid ON PARALLELCASESTATUS FOR EACH ROW 
  DECLARE 
  	PRAGMA AUTONOMOUS_TRANSACTION;
	v_dummy INTEGER;
	v_nextstageid Integer;
	v_parallelism INTEGER;
	v_chid Number;
	v_ts CASEHISTORYSUM.STAGESTARTTIMESTAMP%TYPE;
	err_code Varchar2(50);
	err_msg Varchar2(2000);
  BEGIN
	--get parallelism of the stage
	select parallelism into v_parallelism from stages where stageid=:NEW.Stageid;

	/*for segmented stages, the logic to populate CASEHISTORYSUM table:
	
		if (:NEW.Userid is not null and :OLD.Userid is null) then
		  open new assignment
		  if (:NEW.IsCompleted = 'Y') then
			complete new assignment
		  end if
		elsif (:NEW.Userid is null and :OLD.Userid is not null and :OLD.IsCompleted = 'N') then
		  complete old assignment
		elsif (:NEW.Userid is not null and :OLD.Userid is not null and :NEW.Userid <> :OLD.Userid) then
		  if (:OLD.IsCompleted = 'N') then
			complete old assignment, open new assignment
		  elsif (:OLD.IsCompleted = 'Y') then
			open new assignment
		  end if
		  if (:NEW.IsCompleted = 'Y') then
			complete new assigment
		  end if
		elsif (:NEW.Userid is not null and :OLD.Userid is not null and :NEW.Userid = :OLD.Userid) then
		  if (:NEW.IsCompleted = 'Y' and :OLD.IsCompleted = 'N') then
			complete old assignment
		  elsif (:NEW.IsCompleted = 'N' and :OLD.IsCompleted = 'Y') then
			open new assignment
		  end if
		end if
	*/	
	if v_parallelism = 9999 then
		if (:NEW.Userid is not null and :OLD.Userid is null) then
			--open new assignment
			select CASEHISTORYSUM_SEQ.nextval into v_chid from dual;
			select current_timestamp into v_ts from dual;
	
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
				NOTES,
				FILE_SEGMENT
			  )   VALUES (v_chid, :NEW.CaseId, :NEW.Userid, :NEW.Stageid, casehistory_utils.GetThreadNumByCaseStage(:NEW.CaseId, :NEW.Stageid),
			  			  v_ts, 127, v_ts, 127, :NEW.Stageid, :NEW.ASSIGNMENT_REASON, :NEW.NOTES, :NEW.FILE_SEGMENT);
			if (:NEW.IsCompleted = 'Y') then
				--complete new assignment
				select current_timestamp into v_ts from dual;
				update CASEHISTORYSUM
				set ASSIGNMENTCOMPLETIONTIMESTAMP = v_ts,
					UPDATED_TIMESTAMP = v_ts,
					UPDATED_USERID = 127,
					UPDATED_STAGEID = :NEW.Stageid
				where caseid = :NEW.CaseId and stageid = :NEW.Stageid and FILE_SEGMENT = :NEW.FILE_SEGMENT
				and ASSIGNMENTSTARTTIMESTAMP is not null and ASSIGNMENTCOMPLETIONTIMESTAMP is null;
			end if;

		elsif (:NEW.Userid is null and :OLD.Userid is not null and :OLD.IsCompleted = 'N') then
			--complete old assignment
			select current_timestamp into v_ts from dual;
			update CASEHISTORYSUM
			set ASSIGNMENTCOMPLETIONTIMESTAMP = v_ts,
				UPDATED_TIMESTAMP = v_ts,
				UPDATED_USERID = 127,
				UPDATED_STAGEID = :NEW.Stageid
			where caseid = :NEW.CaseId and stageid = :NEW.Stageid and FILE_SEGMENT = :NEW.FILE_SEGMENT
			and ASSIGNMENTSTARTTIMESTAMP is not null and ASSIGNMENTCOMPLETIONTIMESTAMP is null;
	
		elsif (:NEW.Userid is not null and :OLD.Userid is not null and :NEW.Userid <> :OLD.Userid) then
			--
			if (:OLD.IsCompleted = 'N') then
				--complete old assignment, open new assignment
				select current_timestamp into v_ts from dual;
				update CASEHISTORYSUM
				set ASSIGNMENTCOMPLETIONTIMESTAMP = v_ts,
					UPDATED_TIMESTAMP = v_ts,
					UPDATED_USERID = 127,
					UPDATED_STAGEID = :NEW.Stageid
				where caseid = :NEW.CaseId and stageid = :NEW.Stageid and FILE_SEGMENT = :NEW.FILE_SEGMENT
				and ASSIGNMENTSTARTTIMESTAMP is not null and ASSIGNMENTCOMPLETIONTIMESTAMP is null;

				select CASEHISTORYSUM_SEQ.nextval into v_chid from dual;
				select current_timestamp into v_ts from dual;
		
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
					NOTES,
					FILE_SEGMENT
				  )   VALUES (v_chid, :NEW.CaseId, :NEW.Userid, :NEW.Stageid, casehistory_utils.GetThreadNumByCaseStage(:NEW.CaseId, :NEW.Stageid),
							  v_ts, 127, v_ts, 127, :NEW.Stageid, :NEW.ASSIGNMENT_REASON, :NEW.NOTES, :NEW.FILE_SEGMENT);
			elsif (:OLD.IsCompleted = 'Y') then
				--open new assignment
				select CASEHISTORYSUM_SEQ.nextval into v_chid from dual;
				select current_timestamp into v_ts from dual;
		
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
					NOTES,
					FILE_SEGMENT
				  )   VALUES (v_chid, :NEW.CaseId, :NEW.Userid, :NEW.Stageid, casehistory_utils.GetThreadNumByCaseStage(:NEW.CaseId, :NEW.Stageid),
							  v_ts, 127, v_ts, 127, :NEW.Stageid, :NEW.ASSIGNMENT_REASON, :NEW.NOTES, :NEW.FILE_SEGMENT);
			end if;
  			if (:NEW.IsCompleted = 'Y') then
				--complete new assigment
				select current_timestamp into v_ts from dual;
				update CASEHISTORYSUM
				set ASSIGNMENTCOMPLETIONTIMESTAMP = v_ts,
					UPDATED_TIMESTAMP = v_ts,
					UPDATED_USERID = 127,
					UPDATED_STAGEID = :NEW.Stageid
				where caseid = :NEW.CaseId and stageid = :NEW.Stageid and FILE_SEGMENT = :NEW.FILE_SEGMENT
				and ASSIGNMENTSTARTTIMESTAMP is not null and ASSIGNMENTCOMPLETIONTIMESTAMP is null;
			end if;
			
		elsif (:NEW.Userid is not null and :OLD.Userid is not null and :NEW.Userid = :OLD.Userid) then
			--
			if (:NEW.IsCompleted = 'Y' and :OLD.IsCompleted = 'N') then
				--complete old assignment
				select current_timestamp into v_ts from dual;
				update CASEHISTORYSUM
				set ASSIGNMENTCOMPLETIONTIMESTAMP = v_ts,
					UPDATED_TIMESTAMP = v_ts,
					UPDATED_USERID = 127,
					UPDATED_STAGEID = :NEW.Stageid
				where caseid = :NEW.CaseId and stageid = :NEW.Stageid and FILE_SEGMENT = :NEW.FILE_SEGMENT
				and ASSIGNMENTSTARTTIMESTAMP is not null and ASSIGNMENTCOMPLETIONTIMESTAMP is null;

			elsif (:NEW.IsCompleted = 'N' and :OLD.IsCompleted = 'Y') then
				--open new assignment
				select CASEHISTORYSUM_SEQ.nextval into v_chid from dual;
				select current_timestamp into v_ts from dual;
		
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
					NOTES,
					FILE_SEGMENT
				  )   VALUES (v_chid, :NEW.CaseId, :NEW.Userid, :NEW.Stageid, casehistory_utils.GetThreadNumByCaseStage(:NEW.CaseId, :NEW.Stageid),
							  v_ts, 127, v_ts, 127, :NEW.Stageid, :NEW.ASSIGNMENT_REASON, :NEW.NOTES, :NEW.FILE_SEGMENT);
			end if;
		end if;
		commit;
	end if;
	
    if (:NEW.IsCompleted = 'Y' and :OLD.IsCompleted = 'N') then
    	--a slot is marked completed
		update PARALLELCASESTATUS_STAGE
			set COMPLETIONCOUNT=COMPLETIONCOUNT+1
			where caseid = :NEW.CaseId and stageid = :NEW.Stageid;
		commit;
	elsif (:NEW.IsCompleted = 'N' and :OLD.IsCompleted = 'Y') then
		--a slot is marked incomplete
		update PARALLELCASESTATUS_STAGE
			set COMPLETIONCOUNT=COMPLETIONCOUNT-1
			where caseid = :NEW.CaseId and stageid = :NEW.Stageid;
		commit;
	end if;
  Exception
    When others Then
	  rollback;
      err_code := SQLCODE;
      err_msg := substr(SQLERRM, 1, 2000);
  	  insert into errorlog (actionid, actionname, message, content, CREATED_STAGEID, CREATED_TIMESTAMP, CREATED_USERID) 
        values (87, 'IWS Step Completed', err_code ||' raised from PARALLELCASESTATUS_WF_TGR', err_msg, :NEW.Stageid, current_timestamp, :NEW.userid);
	  commit;
  End;
  /