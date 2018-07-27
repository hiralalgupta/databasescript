--------------------------------------------------------
--  DDL for Procedure GET_NEXT_CASE_NEW
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "SNX_IWS2"."GET_NEXT_CASE_NEW" 
  -- Program name - GET_NEXT_CASE
  -- Created 9-22-2011 R Benzell
  -- Pulls the Next CASEID from the WorkQueue
    
            (
               P_USERID  IN NUMBER,
               P_ROLE    IN VARCHAR2,
               P_CASEID  OUT NUMBER)
               
   
  --
  -- Typical Usage - add to Procedures just before final END;
  --   EXCEPTION WHEN OTHERS THEN LOG_APEX_ERROR(123,'TEST ACTION','optional addl debug info');
    
  -- Update History
  -- 3-9-2012 R Benzell - check if user limit has been exceeded  
    
/***
    declare
      v_result number default 3;
    begin
      GET_NEXT_CASE(P_USERID  => 3,
                    P_ROLE    => 'QA',
                    P_CASEID  => v_result);
       htp.p('Next Case=' ||v_result);
     end;
***/
  -- Update History: 
  -- 

    IS
 
        v_CaseId number;
        v_StageId number;

        v_max_case_cnt number;  
        v_current_case_cnt number;  -- current OP or QA cases this person has

       BEGIN
           
--- Get count of Cases matching the current role request           
   IF P_ROLE = 'OP'
       then
           v_max_case_cnt := IWS_APP_UTILS.GETCONFIGSWITCHVALUE('', 'MAX_CASES_PER_OP') ;
           select count(*) into v_current_case_cnt
           from CASES
           where USERID = P_USERID
           and STAGEID in (4,6,8,10);
   END IF;

   IF P_ROLE = 'QA'
       then
          v_max_case_cnt := IWS_APP_UTILS.GETCONFIGSWITCHVALUE('', 'MAX_CASES_PER_QA') ;
           select count(*) into v_current_case_cnt
           from CASES
           where USERID = P_USERID
           and STAGEID in (5,7,9,11);
   END IF;

    
   --- Get next available case
    CASE
    WHEN P_ROLE = 'OP' and v_current_case_cnt < v_max_case_cnt
       then
       select min(CASEID)
          INTO  v_CaseId
          from CASES
          WHERE USERID is null
            and STAGEID in (select stageid from USER_ROLES_STAGES where userid=P_USERID)
            and STAGEID in (4,6,8,10);
  
    WHEN P_ROLE = 'QA' and v_current_case_cnt < v_max_case_cnt
       then
       select min(CASEID)
          INTO  v_CaseId
          from CASES
          WHERE USERID is null
            and STAGEID in (select stageid from USER_ROLES_STAGES where userid=P_USERID)
            and STAGEID in (5,7,9,11);
   

     --- If here, exceeded OP limit
     WHEN P_ROLE = 'OP' or P_ROLE= 'QA'
         then
           LOG_APEX_ACTION(
           P_ACTIONID => 0,
           P_OBJECTTYPE => 'GET_NEXT_' || P_ROLE,
           P_RESULTS =>  'Limit Exceeded',
           P_ORIGINALVALUE => v_current_case_cnt,
           P_MODIFIEDVALUE =>  v_max_case_cnt,
           P_USERID =>  P_USERID,
           P_CASEID => P_CASEID
        );
     
  
         
     ELSE null;

     END CASE;


    --- Update the Case table
      If v_CaseId is not null
        then
         
         --- Find out what the StageId is 
          select STAGEID INTO  v_StageId
          from CASES 
          WHERE CASEID = v_CaseId;
          
          
          
          UPDATE CASES
          SET USERID = P_USERID,
               UPDATED_TIMESTAMP = SYSTIMESTAMP,
               ASSIGNMENTTIMESTAMP = SYSTIMESTAMP,
               UPDATED_USERID = P_USERID,
               ASSIGNEDBY = P_USERID
          WHERE CASEID = v_Caseid
                and USERID IS NULL
                 and STAGEID in (select stageid from USER_ROLES_STAGES where userid=P_USERID); 


      --- Add to the History Table
        INSERT INTO CASEHISTORY
         (
             CASEID,
             STAGEID, 
             USERID,
             STAGESTARTTIMESTAMP,  
             ASSIGNMENTTIMESTAMP ,
             CREATED_TIMESTAMP,
             CREATED_USERID,
             ASSIGNEDBY
         )
            values
            (
                v_CASEID,
                v_STAGEID,      
                P_USERID,
                SYSTIMESTAMP,
                SYSTIMESTAMP,
                SYSTIMESTAMP,
                P_USERID,
                P_USERID
            );
         

        COMMIT;

       END IF;

        P_CASEID := v_Caseid;
             
         -- select CASEID INTO  v_CaseId
         -- from CASES
         -- WHERE     
         --    caseid,userid from cases where caseid = 2 for update of userid
         --    where id =
           
             
         
     -- LOG_APEX_ACTION(
     --    P_ACTIONID => 15,  
     --    P_RESULTS =>  '',
     --    P_USERID =>  P_USERID,
     --    P_STAGEID => P_STAGEID,
     --    P_CASEID => P_CASEID
      --  );
         
       EXCEPTION WHEN OTHERS THEN LOG_APEX_ERROR(15);
             
   END;


/

