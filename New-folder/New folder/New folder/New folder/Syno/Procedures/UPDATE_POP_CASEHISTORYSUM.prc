create or replace
PROCEDURE     UPDATE_POP_CASEHISTORYSUM
  -- Program name - UPDATE_POP_CASEHISTORYSUM
  -- Created 3-14-2013 Based on UPDATE_POP_CASEHISTORYSUM, but only handles POP sub-steps
  -- Typical invocations:  
  --  Manual:
  --    User changes POP status on screen 233 =>
  --    This updates the PARALLELCASESTATUS table =>
  --    This invokes the PARALLELCASESTATUS_UPD_TGR trigger =>
  --    Which then calls this UPDATE_POP_CASEHISTORYSUM procedure
  --
  -- IWS:
  --    User completes IWS screen for the POP step =>
  --    IWS updates the PARALLELCASESTATUS table =>
  --    This invokes the PARALLELCASESTATUS_UPD_TGR trigger =>
  --    Which then calls this UPDATE_POP_CASEHISTORYSUM procedure
  -- 
  -- Update History
  -- 3-18-2013 R Benzell - addressed reopened scenarios
  -- 3-19-2013 R Benzell - disable dbms.output debug statements
    
      (
       P_CASEID IN NUMBER default null,
       P_STAGEID IN NUMBER default null,
       P_ROLEID IN NUMBER default null,
       P_PREV_USERID IN NUMBER default null,
       P_New_Userid In Number default null,
       P_Prev_Iscompleted In Varchar2 default null,
       P_NEW_ISCOMPLETED IN VARCHAR2 default null,
       P_DATE IN DATE default null
      )
  
       IS
       
  /**
  to test:
   set serveroutput on
   BEGIN
    UPDATE_POP_CASEHISTORYSUM (
       P_CASEID => 2505,
       P_STAGEID => 71,
       P_ROLEID => 106,
       P_PREV_USERID => 4,
       P_New_Userid => 3,
       P_Prev_Iscompleted => 'Y',
       P_NEW_ISCOMPLETED => 'N',
       P_DATE => sysdate
      );
    END;
  */    
  
    
  --v_last_chid number;
   I number default 1;
   v_now TIMESTAMP(4) WITH TIME ZONE;
   V_App_Msg Varchar2(4000);
   v_CHANGE_FLAG varchar2(1);  -- Y or N - means ....?

   v_Prev_Assign_chid number;

   PREV_ASSIGNSUM CASEHISTORYSUM%ROWTYPE;
   NEW_ASSIGNSUM  CASEHISTORYSUM%ROWTYPE;
  
 
 
  Begin
  
  ---- Dbms_Output.Put_Line('Invoked  pUsr=' || P_Prev_Userid || ' pIsComp= >>'|| P_Prev_Iscompleted || '<<');
  ---- Dbms_Output.put_line('         nUsr=' || P_NEW_USERID || ' nIsComp= >>'|| P_New_IsCompleted  || '<<');

  --- make note of this momement so all actions can have identical timestamps   
     IF P_DATE IS NULL
       then v_now := systimestamp;
       else v_now := P_DATE;
     END IF;
   

 --- Determine previous Assign Change History entry that is open for this user
   select max(chid) into v_Prev_Assign_chid
   From Casehistorysum
   WHERE caseid = P_CASEID AND POP_ROLEID = P_ROLEID  AND STAGEID = P_STAGEID;
     --AND ASSIGN_CHG_FLAG = 'Y'
  --v_app_msg :=  v_app_msg  || ' AsnCHID=' || v_Prev_ASSIGN_CHID;
  -- -- Dbms_Output.Put_Line('v_Prev_Assign_chid=' || v_Prev_Assign_chid);

-- Save the previous ASSIGN history record for comparisons (if exists)
  IF v_Prev_ASSIGN_chid IS NOT NULL THEN
   SELECT * INTO PREV_ASSIGNSUM  FROM CASEHISTORYSUM
     WHERE CHID = v_Prev_ASSIGN_chid;
  END IF;



---- Dbms_Output.Put_Line('------------------------------------------');
---- Dbms_Output.Put_Line(' v_Prev_Assign_chid='||V_Prev_Assign_Chid  );
---- Dbms_Output.Put_Line(' iscomp='||P_Prev_Iscompleted  || '/' ||  P_New_Iscompleted ||'<<');
---- Dbms_Output.Put_Line(' user='||P_Prev_Userid  || '/' ||  P_New_Userid||'<<' );
---- Dbms_Output.Put_Line('------------------------------------------');

CASE


---------------------------------------
--- No Change in status - do nothing except trap and record
--- Only invocable in testing.  In Apex, no-change does not update the PARALLELCASESTATUS table
--  so UPDATE_POP_CASEHISTORYSUM never gets invoked
-----------------------------------------
    When (P_Prev_Userid = P_New_Userid) 
          AND (P_PREV_ISCOMPLETED =  P_NEW_ISCOMPLETED )
      Then 
       ---- Dbms_Output.Put_Line('No Change' );
       v_app_msg :=  v_app_msg  || ' No Change.' ;

---- enable for debugging
         LOG_APEX_ACTION(
           P_ACTIONID => 65,
           P_Objecttype => 'UPDATE_POP_CASEHISTORYSUM' ,
           P_Objectid =>   V_Prev_Assign_Chid,
           P_Results =>   'No Status Change',
           P_ORIGINALVALUE =>  ' pUsr=' || P_PREV_USERID || ' pIsComp='|| P_Prev_Iscompleted, 
           P_MODIFIEDVALUE =>  ' | nUsr=' || P_NEW_USERID || ' nIsComp='|| P_New_Iscompleted,
           P_Userid =>  P_New_Userid,
           P_CASEID => P_CASEID);



---------------------------------------
--- Newly Assigned
-----------------------------------------
    When ( P_Prev_Userid Is Null AND P_New_Userid Is Not Null )
    
      Then 
      -- Dbms_Output.Put_Line('Newly Assigned' );
      v_app_msg :=  v_app_msg  || ' Newly Assigned.'; 


      NEW_AssignSUM.CASEID   := P_CASEID;     
      New_Assignsum.Stageid := P_Stageid;
      New_Assignsum.Pop_Roleid := P_Roleid;
      New_Assignsum.Pop_UserId := P_New_Userid;

      New_Assignsum.Assign_Chg_Flag  := 'Y';
      New_Assignsum.POP_ISCOMPLETE  := P_NEW_ISCOMPLETED;
      New_Assignsum.POP_ASSIGNMENT_START_ON := V_Now;

      NEW_AssignSUM.CREATED_TIMESTAMP := v_Now;
      NEW_AssignSUM.UPDATED_TIMESTAMP := v_Now;
      New_Assignsum.AssignedBy    := v('USERID') ;
      New_Assignsum.Updated_Userid := v('USERID') ;
      New_Assignsum.Created_Userid := v('USERID') ;
    
      New_Assignsum.Pop_Start_On := V_Now;
      
     If  v_Prev_ASSIGN_CHID is not null then
        --- Update the Existing ASSIGN Record IF something was changed and previous record exists
         Update Casehistorysum  Set Row = New_Assignsum Where Chid = V_Prev_Assign_Chid;
         COMMIT;
      else
       INSERT into CASEHISTORYSUM values NEW_AssignSUM;
       COMMIT;
       NEW_AssignSUM := NULL;
        select max(chid) into v_Prev_assign_chid
        from CASEHISTORYSUM
        WHERE  caseid = P_CASEID AND POP_ROLEID = P_ROLEID  AND STAGEID = P_STAGEID;
      END IF;  
    

      
---- enable for debugging
         LOG_APEX_ACTION(
           P_ACTIONID => 65,
           P_Objecttype => 'UPDATE_POP_CASEHISTORYSUM' ,
           P_Objectid =>   V_Prev_Assign_Chid,
           P_Results =>   'Newly Assigned ',
           P_ORIGINALVALUE =>  'pUsr=' || P_PREV_USERID || ' pIsComp='|| P_Prev_Iscompleted, 
           P_MODIFIEDVALUE =>  ' | nUsr=' || P_NEW_USERID || ' nIsComp='|| P_New_Iscompleted,
           P_USERID =>  P_NEW_USERID,
           P_CASEID => P_CASEID);
      
       
---------------------------------------------------
--- Newly Completed
------------------------------------------------------
    WHEN ( P_PREV_ISCOMPLETED = 'N' AND P_NEW_ISCOMPLETED = 'Y' )
        Then 
     -- Dbms_Output.Put_Line('Completed' );
     v_app_msg :=  v_app_msg  || ' Completed.' ;
     v_CHANGE_FLAG := 'Y';
     
     --- make a few updates into the previous Row and Update
      Prev_Assignsum.Assign_Chg_Flag  := 'N';
      Prev_Assignsum.POP_ISCOMPLETE  := P_NEW_ISCOMPLETED;
      Prev_Assignsum.POP_ASSIGNMENT_COMPLETE_ON := V_Now;
      Prev_Assignsum.Pop_Complete_On := V_Now;
      Prev_AssignSUM.UPDATED_TIMESTAMP := v_Now;
      Prev_Assignsum.Updated_Userid := v('USERID') ;
   
    --- Update the Existing ASSIGN Record IF something was changed and previous record exists
        UPDATE CASEHISTORYSUM  SET ROW = PREV_ASSIGNSUM WHERE CHID = v_Prev_ASSIGN_CHID;
        COMMIT;
        
-- enable for debugging
         LOG_APEX_ACTION(
           P_ACTIONID => 65,
           P_Objecttype => 'UPDATE_POP_CASEHISTORYSUM' ,
           P_Objectid =>   V_Prev_Assign_Chid,
           P_Results =>   'Completed',
           P_ORIGINALVALUE =>  ' pUsr=' || P_PREV_USERID || ' pIsComp='|| P_Prev_Iscompleted, 
           P_MODIFIEDVALUE =>  ' | nUsr=' || P_NEW_USERID || ' nIsComp='|| P_New_Iscompleted,
           P_USERID =>  P_NEW_USERID,
           P_CASEID => P_CASEID);


       
---------------------------------------------------
--- Reopened - same user
------------------------------------------------------
    When (   P_Prev_Iscompleted = 'Y' And P_New_Iscompleted = 'N' 
          AND P_New_Userid =  P_Prev_Userid )
        Then 

    -- Dbms_Output.Put_Line('Reopened - same user' );
     v_CHANGE_FLAG := 'Y';
     
     --- make a few updates into the previous Row and Update
      Prev_Assignsum.Assign_Chg_Flag  := 'N';
      Prev_Assignsum.POP_ISCOMPLETE  := P_NEW_ISCOMPLETED;
      Prev_Assignsum.POP_ASSIGNMENT_COMPLETE_ON := V_Now;
      Prev_Assignsum.Pop_Complete_On := V_Now;
      Prev_AssignSUM.UPDATED_TIMESTAMP := v_Now;
      Prev_Assignsum.Updated_Userid := v('USERID') ;
   
    --- Update the Existing ASSIGN Record IF something was changed and previous record exists
        UPDATE CASEHISTORYSUM  SET ROW = PREV_ASSIGNSUM WHERE CHID = v_Prev_ASSIGN_CHID;
        COMMIT;
        
-- enable for debugging
         LOG_APEX_ACTION(
           P_ACTIONID => 65,
           P_OBJECTTYPE => 'UPDATE_POP_CASEHISTORYSUM' ,
           P_Objectid =>   V_Prev_Assign_Chid,
           P_Results =>   'Reopened - Same User',           
           P_ORIGINALVALUE =>  'pUsr=' || P_PREV_USERID || ' pIsComp='|| P_Prev_Iscompleted, 
           P_MODIFIEDVALUE =>  ' | nUsr=' || P_NEW_USERID || ' nIsComp='|| P_New_Iscompleted,
           P_USERID =>  P_NEW_USERID,
           P_CASEID => P_CASEID);





-----------------------------------------------------
--- Newly ReOpened new user
---------------------------------------------------
    When ( P_Prev_Iscompleted = 'Y' And P_New_Iscompleted = 'N'
          and P_Prev_Userid <> P_New_Userid)
        Then 
      -- Dbms_Output.Put_Line('Reopened - New user' );
      v_app_msg :=  v_app_msg  || ' Reopened - New user.' ;
     
   v_CHANGE_FLAG := 'Y';
    -- PREV_ASSIGNSUM.ASSIGNMENTCOMPLETIONTIMESTAMP := v_now;

      NEW_AssignSUM.CASEID   := P_CASEID;     
      New_Assignsum.Stageid := P_Stageid;
      New_Assignsum.Pop_Roleid := P_Roleid;
      New_Assignsum.Pop_Userid := P_new_Userid;

      New_Assignsum.Assign_Chg_Flag  := 'Y';
      New_Assignsum.POP_ISCOMPLETE  := P_NEW_ISCOMPLETED;
      New_Assignsum.POP_ASSIGNMENT_START_ON := V_Now;

      NEW_AssignSUM.CREATED_TIMESTAMP := v_Now;
      NEW_AssignSUM.UPDATED_TIMESTAMP := v_Now;
      New_Assignsum.AssignedBy    := v('USERID') ;
      New_Assignsum.Updated_Userid := v('USERID') ;
      New_Assignsum.Created_Userid := v('USERID') ;
    
      New_Assignsum.Pop_Start_On := V_Now;

      
      Insert Into Casehistorysum Values New_Assignsum;
      COMMIT;


      select max(chid) into v_Prev_assign_chid
      from CASEHISTORYSUM
      WHERE  caseid = P_CASEID AND POP_ROLEID = P_ROLEID  AND STAGEID = P_STAGEID;
      
        
-- enable for debugging
         LOG_APEX_ACTION(
           P_ACTIONID => 65,
           P_OBJECTTYPE => 'UPDATE_POP_CASEHISTORYSUM' ,
           P_Objectid =>   V_Prev_Assign_Chid,
           P_Results =>   'Reopened - New user',           
           P_ORIGINALVALUE =>  'pUsr=' || P_PREV_USERID || ' pIsComp='|| P_Prev_Iscompleted, 
           P_MODIFIEDVALUE =>  ' | nUsr=' || P_NEW_USERID || ' nIsComp='|| P_New_Iscompleted,
           P_USERID =>  P_NEW_USERID,
           P_CASEID => P_CASEID);




-----------------------------------------------------
---  ReOpened Same user
---------------------------------------------------
    When ( P_Prev_Iscompleted = 'N' And P_New_Iscompleted = 'Y'
           and P_Prev_Userid = P_New_Userid)
        Then 
     -- Dbms_Output.Put_Line('Reopened - Same User' );
     v_app_msg :=  v_app_msg  || '  Reopened - Same User.';
     
    --v_CHANGE_FLAG := 'Y';
    -- PREV_ASSIGNSUM.ASSIGNMENTCOMPLETIONTIMESTAMP := v_now;

      NEW_AssignSUM.CASEID   := P_CASEID;     
      New_Assignsum.Stageid := P_Stageid;
      New_Assignsum.Pop_Roleid := P_Roleid;

      New_Assignsum.Assign_Chg_Flag  := 'Y';
      New_Assignsum.POP_ISCOMPLETE  := P_NEW_ISCOMPLETED;
      New_Assignsum.POP_ASSIGNMENT_START_ON := V_Now;

      NEW_AssignSUM.CREATED_TIMESTAMP := v_Now;
      New_Assignsum.Updated_Timestamp := V_Now;
      New_Assignsum.AssignedBy     := v('USERID') ;
      New_Assignsum.Updated_Userid := v('USERID') ;
      New_Assignsum.Created_Userid := v('USERID') ;
    
      New_Assignsum.Pop_Start_On := V_Now;
      
      
      INSERT into CASEHISTORYSUM values NEW_AssignSUM;
      Commit;
      --NEW_AssignSUM := NULL;

      select max(chid) into v_Prev_assign_chid
      from CASEHISTORYSUM
      WHERE  caseid = P_CASEID AND POP_ROLEID = P_ROLEID  AND STAGEID = P_STAGEID;
      
      -- enable for debugging
         LOG_APEX_ACTION(
           P_ACTIONID => 65,
           P_OBJECTTYPE => 'UPDATE_POP_CASEHISTORYSUM' ,
           P_Objectid =>   V_Prev_Assign_Chid,
           P_Results =>   'Reopened Same User',           
           P_ORIGINALVALUE =>  'pUsr=' || P_PREV_USERID || ' pIsComp='|| P_Prev_Iscompleted, 
           P_MODIFIEDVALUE =>  ' | nUsr=' || P_NEW_USERID || ' nIsComp='|| P_New_Iscompleted,
           P_USERID =>  P_NEW_USERID,
           P_Caseid => P_Caseid);

      
      


-----------------------------------------------------
---  Switch Users While Open
--- close previous, create new
---------------------------------------------------
    When ( P_Prev_Iscompleted = 'N' And P_New_Iscompleted = 'N'
           and P_Prev_Userid <> P_New_Userid)
        Then 
     -- Dbms_Output.Put_Line('Switch users while open' );
     v_app_msg :=  v_app_msg  || 'Switch users while open.';
     
   ---------------------------------------
   --- Complete Prev Users POP Log
   ---------------------------------------
     --- make a few updates into the previous Row and Update
      Prev_Assignsum.Assign_Chg_Flag  := 'N';
      --Prev_Assignsum.POP_ISCOMPLETE  := P_NEW_ISCOMPLETED;
      Prev_Assignsum.Pop_Assignment_Complete_On := V_Now;
      --Prev_Assignsum.Pop_Complete_On := V_Now;  -- Not complete
      Prev_AssignSUM.UPDATED_TIMESTAMP := v_Now;
      Prev_Assignsum.Updated_Userid := v('USERID') ;
   
    --- Update the Existing ASSIGN Record IF something was changed and previous record exists
        UPDATE CASEHISTORYSUM  SET ROW = PREV_ASSIGNSUM WHERE CHID = v_Prev_ASSIGN_CHID;
        Commit;

   ---------------------------------------
   --- Begin New Users POP  Entry     
   ---------------------------------------
     --v_CHANGE_FLAG := 'Y';

      NEW_AssignSUM.CASEID   := P_CASEID;     
      New_Assignsum.Stageid := P_Stageid;
      New_Assignsum.Pop_Roleid := P_Roleid;
      New_Assignsum.Pop_Userid := P_New_Userid;

      New_Assignsum.Assign_Chg_Flag  := 'Y';
      New_Assignsum.POP_ISCOMPLETE  := P_NEW_ISCOMPLETED;
      New_Assignsum.POP_ASSIGNMENT_START_ON := V_Now;

      NEW_AssignSUM.CREATED_TIMESTAMP := v_Now;
      New_Assignsum.Updated_Timestamp := V_Now;
      New_Assignsum.AssignedBy     := v('USERID') ;
      New_Assignsum.Updated_Userid := v('USERID') ;
      New_Assignsum.Created_Userid := v('USERID') ;
    
      New_Assignsum.Pop_Start_On := V_Now;
      
      
      INSERT into CASEHISTORYSUM values NEW_AssignSUM;
      Commit;
      --NEW_AssignSUM := NULL;

      select max(chid) into v_Prev_assign_chid
      from CASEHISTORYSUM
      WHERE  caseid = P_CASEID AND POP_ROLEID = P_ROLEID  AND STAGEID = P_STAGEID;
      
      
      -- enable for debugging
         LOG_APEX_ACTION(
           P_ACTIONID => 65,
           P_OBJECTTYPE => 'UPDATE_POP_CASEHISTORYSUM' ,
           P_Objectid =>   V_Prev_Assign_Chid,
           P_Results =>   'Switch users while open',           
           P_ORIGINALVALUE =>  'pUsr=' || P_PREV_USERID || ' pIsComp='|| P_Prev_Iscompleted, 
           P_MODIFIEDVALUE =>  ' | nUsr=' || P_NEW_USERID || ' nIsComp='|| P_New_Iscompleted,
           P_USERID =>  P_NEW_USERID,
           P_Caseid => P_Caseid);

      
-----------------------------------------------------
--- Should not end up here.  But trap just in case
-----------------------------------------------------
ELSE
     V_Change_Flag := 'N';
      -- Dbms_Output.Put_Line('ELSE - should not end up here. ' );
      v_app_msg :=  v_app_msg  || 'ELSE - should not end up here. ';
            
-- enable for debugging
         LOG_APEX_ACTION(
           P_ACTIONID => 65,
           P_OBJECTTYPE => 'UPDATE_POP_CASEHISTORYSUM' ,
           P_Objectid =>   V_Prev_Assign_Chid,
           P_Results =>   'End Case - Exception',           
           P_ORIGINALVALUE =>  ' pUsr=' || P_PREV_USERID || ' pIsComp='|| P_Prev_Iscompleted, 
           P_MODIFIEDVALUE =>  ' | nUsr=' || P_NEW_USERID || ' nIsComp='|| P_New_Iscompleted,
           P_USERID =>  P_NEW_USERID,
           P_CASEID => P_CASEID);
  
END CASE;


 COMMIT;
 apex_application.g_print_success_message :=  'OK ' || v_app_msg;
 
   
             
       EXCEPTION WHEN OTHERS THEN
           BEGIN
             LOG_APEX_ERROR();
             apex_application.g_print_success_message :=  ' ERROR' || v_app_msg  ;
           END;
             
       END;