--------------------------------------------------------
--  DDL for Procedure GET_NEXT_CASE
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "SNX_IWS2"."GET_NEXT_CASE" 
  -- Program name - GET_NEXT_CASE
  -- Created 9-22-2011 R Benzell
  -- Pulls the Next CASEID from the WorkQueue
  -- maximum limits of OP and QA files per user controlled by 
  -- CONFIG_SWITCHES values of MAX_CASES_PER_OP  MAX_CASES_PER_QA
  -- Record results in AUDIT_LOG
  --   62 - Failed to GetNext File
  --   64 - Obtained GetNext File
  --   65 - No File Available
    
            (
               P_USERID  IN NUMBER,
               P_ROLE    IN VARCHAR2,
               P_CLIENTID IN VARCHAR2,
               P_CASEID  OUT NUMBER,
               P_RESULT  OUT VARCHAR2)
               
   
  --
  -- Typical Usage - add to Procedures just before final END;
  --   EXCEPTION WHEN OTHERS THEN LOG_APEX_ERROR(123,'TEST ACTION','optional addl debug info');
    
  -- Update History
  -- 3-9-2012 R Benzell - check if user limit has been exceeded, and log results 
  -- 3-15-2012 R Benzell - optionally limit case selection to specific client.
  --                       Also store CASEID in AUDITLOG
  -- 5-2-2012 R Benzell - Removed update of CASEHISTORYSUM, since that is updated by CASES trigger
  -- 6-8-2012 R Benzell - Consider Client STATUS to only retrieve cases from ACTIVE clients 
  -- 6-11-2012 R Benzell - Improved wording on messages for clarity to users
  -- 6-12-2012 R Benzell - Added Next TR Case functionality
  -- 8-17-2012 R Benzell - QA gets QC2 step files
  -- 9-21-2012 R Benzell - Add get next FV task files   
  -- 10-8-2012 R Benzell - Corrected missed QC2 gets
  -- 10-9-2012 R Benzell - Corrected missed FV task files 
  -- 11-12-2012 R Benzell - Added FV-QC and FV-OP, and   Step-2-RX Step-2-NS and Step-2-DR
  -- 02-05-2013 R Benzell - For Parallelism STEP2-POP 71, added PRIORITY consideration
    
/***
    declare
      v_result number default 3;
    begin
      GET_NEXT_CASE(P_USERID  => 3,
                    P_ROLE    => 'QA',
                    P_CLIENTID  => 4,   --'QA',
                    P_CASEID  => v_result);
       htp.p('Next Case=' ||v_result);
     end;
***/
  -- Update History: 
  -- 

    IS
 
        v_CaseId number;
        v_StageId number;
        v_Result varchar2(80);

        v_max_case_cnt number default 0;  
        v_current_case_cnt number default 0;  -- current OP or QA cases this person has
        v_modified_case_cnt number default 0;  -- current OP or QA cases this person has
		--v_POP_case_cnt number default 0;  -- number of parallel cases open


       BEGIN
           
      
----------------------------------------------------------------------------           
--- Get count of Cases matching the current role request.  Only active client files count           
  IF P_ROLE = 'FV-OP'
       then
           v_max_case_cnt := IWS_APP_UTILS.GETCONFIGSWITCHVALUE('', 'MAX_CASES_PER_FV_OP') ;
           select count(*) into v_current_case_cnt
           from CASES
           where USERID = P_USERID
           and CLIENTID in (select clientid from CLIENTS where status='ACTIVE' )    
           and STAGEID in (52);
   END IF;

  IF P_ROLE = 'FV-QA'
       then
           v_max_case_cnt := IWS_APP_UTILS.GETCONFIGSWITCHVALUE('', 'MAX_CASES_PER_FV_QA') ;
           select count(*) into v_current_case_cnt
           from CASES
           where USERID = P_USERID
           and CLIENTID in (select clientid from CLIENTS where status='ACTIVE' )    
           and STAGEID in (69);
   END IF;

           
   IF P_ROLE = 'OP'
       then
           v_max_case_cnt := IWS_APP_UTILS.GETCONFIGSWITCHVALUE('', 'MAX_CASES_PER_OP') ;
           select count(*) into v_current_case_cnt
           from CASES
           where USERID = P_USERID
           and CLIENTID in (select clientid from CLIENTS where status='ACTIVE' )    
           and STAGEID in (4,6,8,10,66,67,68,71);
   END IF;

   IF P_ROLE = 'QA'
       then
          v_max_case_cnt := IWS_APP_UTILS.GETCONFIGSWITCHVALUE('', 'MAX_CASES_PER_QA') ;
           select count(*) into v_current_case_cnt
           from CASES
           where USERID = P_USERID
           and CLIENTID in (select clientid from CLIENTS where status='ACTIVE' )
           and STAGEID in (5,7,9,11,48);
   END IF;

   IF P_ROLE = 'TR'
       then
          v_max_case_cnt := IWS_APP_UTILS.GETCONFIGSWITCHVALUE('', 'MAX_CASES_PER_TR') ;           select count(*) into v_current_case_cnt
           from CASES
           where USERID = P_USERID
           and CLIENTID in (select clientid from CLIENTS where status='ACTIVE' )
           and STAGEID = 49;
   END IF;

-----------------------------------------------------------------------
  

   --- Get next available case, if within limits
   --- IF a clientID is passed, limit selection based on that Client
   --- If no clientId, grab any client
    CASE
        
------ FV-OP  ----------------------------------------------------------------------       
     --- Grab any FV Client  (include plain FV for backward compatabiltiy with FV-OP 
       WHEN (P_ROLE = 'FV-OP' or P_ROLE = 'FV')
          and v_current_case_cnt < v_max_case_cnt and P_CLIENTID = '%'
       then
       select min(CASEID)
          INTO  v_CaseId
          from CASES
          WHERE USERID is null
            and STAGEID in (select stageid from USER_ROLES_STAGES where userid=P_USERID)
            and CLIENTID in (select clientid from CLIENTS where status='ACTIVE' )
            and STAGEID in (52);
         if v_CaseId is not null
           then
               v_Result := v_result || 'Assigned FV Case';
               v_modified_case_cnt := v_current_case_cnt+1;
           else 
                if v_current_case_cnt >= v_max_case_cnt
                  then v_Result := v_Result || 'FV Case Assignment Limit Reached.';
                  else v_Result := v_Result || 'No FV Case Available for Assignment.';
                end if;
         end if;
   
  --- Grab specific FV Client.  Only ACTIVE clients would be passed as P_CLIENTID anyway
     WHEN (P_ROLE = 'FV-OP' or P_ROLE = 'FV') 
        and v_current_case_cnt < v_max_case_cnt
       then
       select min(CASEID)
          INTO  v_CaseId
          from CASES
          WHERE USERID is null
            and STAGEID in (select stageid from USER_ROLES_STAGES where userid=P_USERID)
            and CLIENTID in (select clientid from CLIENTS where status='ACTIVE' )
            and STAGEID in (52)
            and CLIENTID = P_CLIENTID;
         if v_CaseId is not null
           then
               v_Result := v_result || 'Assigned FV Case';
               v_modified_case_cnt := v_current_case_cnt+1;
           else 
                if v_current_case_cnt >= v_max_case_cnt
                  then v_Result := v_Result || 'FV Case Assignment Limit Reached.';
                  else v_Result := v_Result || 'No FV Case Available for Assignment.';
                end if;
         end if;
      
  
------ FV-QA  ----------------------------------------------------------------------       
     --- Grab any FV Client  (include plain FV for backward compatabiltiy with FV-OP 
       WHEN P_ROLE = 'FV-QA' and v_current_case_cnt < v_max_case_cnt and P_CLIENTID = '%'
       then
       select min(CASEID)
          INTO  v_CaseId
          from CASES
          WHERE USERID is null
            and STAGEID in (select stageid from USER_ROLES_STAGES where userid=P_USERID)
            and CLIENTID in (select clientid from CLIENTS where status='ACTIVE' )
            and STAGEID in (69);
         if v_CaseId is not null
           then
               v_Result := v_result || 'Assigned FV Case';
               v_modified_case_cnt := v_current_case_cnt+1;
           else 
                if v_current_case_cnt >= v_max_case_cnt
                  then v_Result := v_Result || 'FV Case Assignment Limit Reached.';
                  else v_Result := v_Result || 'No FV Case Available for Assignment.';
                end if;
         end if;
   
  --- Grab specific FV Client.  Only ACTIVE clients would be passed as P_CLIENTID anyway
     WHEN P_ROLE = 'FV-QA' and v_current_case_cnt < v_max_case_cnt
       then
       select min(CASEID)
          INTO  v_CaseId
          from CASES
          WHERE USERID is null
            and STAGEID in (select stageid from USER_ROLES_STAGES where userid=P_USERID)
            and CLIENTID in (select clientid from CLIENTS where status='ACTIVE' )
            and STAGEID in (69)
            and CLIENTID = P_CLIENTID;
         if v_CaseId is not null
           then
               v_Result := v_result || 'Assigned FV Case';
               v_modified_case_cnt := v_current_case_cnt+1;
           else 
                if v_current_case_cnt >= v_max_case_cnt
                  then v_Result := v_Result || 'FV Case Assignment Limit Reached.';
                  else v_Result := v_Result || 'No FV Case Available for Assignment.';
                end if;
         end if;
      
      
--- See if there are any Open POP cases that this person is qualified for
   -- Based on USERROLES, ROLESTAGES, and STAGES tables, find out which stages the user can be assigned cases, in PRIORITY ascending order
   -- For each stage, find available case to assign
   -- If the stage is parallelized, find out which roles of that stage the user belongs to, in PRIORITY ascending order. And for each role, find available case to assign by checking PARALLELCASESTATUS table for rows without USERID value
   -- If the stage is non-parallelized, follow regular case assignment logic
   -- When there are multiple cases available, use queue prioritization logic to assign the most urgent one
        
	--  WHEN P_ROLE = 'OP' and v_current_case_cnt < v_max_case_cnt and P_CLIENTID = '%'	
	--   AND xxxx
        
        
 ------ OP ----------------------------------------------------------------------       
     --- Grab any OP Client   
       WHEN P_ROLE = 'OP' and v_current_case_cnt < v_max_case_cnt and P_CLIENTID = '%'
       then
       select min(CASEID)
          INTO  v_CaseId
          from CASES
          WHERE USERID is null
            and STAGEID in (select stageid from USER_ROLES_STAGES where userid=P_USERID)
            and CLIENTID in (select clientid from CLIENTS where status='ACTIVE' )
            and STAGEID in (4,6,8,10,66,67,68);
         if v_CaseId is not null
           then
               v_Result := v_result || 'Assigned OP Case';
               v_modified_case_cnt := v_current_case_cnt+1;
           else 
                if v_current_case_cnt >= v_max_case_cnt
                  then v_Result := v_Result || 'OP Case Assignment Limit Reached.';
                  else v_Result := v_Result || 'No OP Case Available for Assignment.';
                end if;
         end if;
   
  --- Grab specific OP Client.  Only ACTIVE clients would be passed as P_CLIENTID anyway
    WHEN P_ROLE = 'OP' and v_current_case_cnt < v_max_case_cnt
       then
       select min(CASEID)
          INTO  v_CaseId
          from CASES
          WHERE USERID is null
            and STAGEID in (select stageid from USER_ROLES_STAGES where userid=P_USERID)
            and CLIENTID in (select clientid from CLIENTS where status='ACTIVE' )
            and STAGEID in (4,6,8,10,66,67,68)
            and CLIENTID = P_CLIENTID;
         if v_CaseId is not null
           then
               v_Result := v_result || 'Assigned OP Case';
               v_modified_case_cnt := v_current_case_cnt+1;
           else 
                if v_current_case_cnt >= v_max_case_cnt
                  then v_Result := v_Result || 'OP Case Assignment Limit Reached.';
                  else v_Result := v_Result || 'No OP Case Available for Assignment.';
                end if;
         end if;
      

------ TR ----------------------------------------------------------------------        
--- Grab any TR Client   
    WHEN P_ROLE = 'TR' and v_current_case_cnt < v_max_case_cnt and P_CLIENTID = '%'
       then
       select min(CASEID)
          INTO  v_CaseId
          from CASES
          WHERE USERID is null
            and STAGEID in (select stageid from USER_ROLES_STAGES where userid=P_USERID)
            and CLIENTID in (select clientid from CLIENTS where status='ACTIVE' )
            and STAGEID in (49);
         if v_CaseId is not null
           then v_Result := v_result || 'Assigned TR Case';
                v_modified_case_cnt := v_current_case_cnt+1;
           else 
                if v_current_case_cnt >= v_max_case_cnt
                  then v_Result := v_Result || 'TR Case Assignment Limit Reached.';
                  else v_Result := v_Result || 'No TR Case Available for Assignment.';
                end if;
          end if;
  


  --- Grab specific TR Client  Only ACTIVE clients would be passed as P_CLIENTID anyway
    WHEN P_ROLE = 'TR' and v_current_case_cnt < v_max_case_cnt
       then
       select min(CASEID)
          INTO  v_CaseId
          from CASES
          WHERE USERID is null
            and STAGEID in (select stageid from USER_ROLES_STAGES where userid=P_USERID)
            and CLIENTID in (select clientid from CLIENTS where status='ACTIVE' )
            and STAGEID in (49)
            and CLIENTID = P_CLIENTID;
         if v_CaseId is not null
           then v_Result := v_result || 'Assigned TR Case';
                v_modified_case_cnt := v_current_case_cnt+1;
            else 
                if v_current_case_cnt >= v_max_case_cnt
                  then v_Result := v_Result || 'TR Case Assignment Limit Reached.';
                  else v_Result := v_Result || 'No TR Case Available for Assignment.';
                end if;
         end if;
   

------ QA ----------------------------------------------------------------------       
     --- Grab any QA Client   
    WHEN P_ROLE = 'QA' and v_current_case_cnt < v_max_case_cnt and P_CLIENTID = '%'
       then
       select min(CASEID)
          INTO  v_CaseId
          from CASES
          WHERE USERID is null
            and STAGEID in (select stageid from USER_ROLES_STAGES where userid=P_USERID)
            and CLIENTID in (select clientid from CLIENTS where status='ACTIVE' )
            and STAGEID in (5,7,9,11,48);
         if v_CaseId is not null
           then v_Result := v_result || 'Assigned QA Case';
                v_modified_case_cnt := v_current_case_cnt+1;
           else 
                if v_current_case_cnt >= v_max_case_cnt
                  then v_Result := v_Result || 'QA Case Assignment Limit Reached.';
                  else v_Result := v_Result || 'No QA Case Available for Assignment.';
                end if;
          end if;
  


  --- Grab specific QA Client  Only ACTIVE clients would be passed as P_CLIENTID anyway
    WHEN P_ROLE = 'QA' and v_current_case_cnt < v_max_case_cnt
       then
       select min(CASEID)
          INTO  v_CaseId
          from CASES
          WHERE USERID is null
            and STAGEID in (select stageid from USER_ROLES_STAGES where userid=P_USERID)
            and CLIENTID in (select clientid from CLIENTS where status='ACTIVE' )
            and STAGEID in (5,7,9,11,48)
            and CLIENTID = P_CLIENTID;
         if v_CaseId is not null
           then v_Result := v_result || 'Assigned QA Case';
                v_modified_case_cnt := v_current_case_cnt+1;
            else 
                if v_current_case_cnt >= v_max_case_cnt
                  then v_Result := v_Result || 'QA Case Assignment Limit Reached.';
                  else v_Result := v_Result || 'No QA Case Available for Assignment.';
                end if;
         end if;
   


     --- If here, exceeded Limit
     ELSE 
       v_Result := v_Result || 'Case Assignment Limit Reached.'; 
           LOG_APEX_ACTION(
           P_ACTIONID => 62,
           P_OBJECTTYPE => 'GET_NEXT_' || P_ROLE,
           P_RESULTS =>  'Case Assignment Limit Reached.',
           P_ORIGINALVALUE => v_current_case_cnt,
           P_MODIFIEDVALUE =>  v_current_case_cnt,
           P_USERID =>  P_USERID,
           P_CASEID => P_CASEID
        );
       
   
     END CASE;

       --htp.p('xxxcur='|| v_current_case_cnt);
       --htp.p('xxxmax='|| v_max_case_cnt);

       --    P_MODIFIEDVALUE =>  v_max_case_cnt,P_ORIGINALVALUE => v_current_case_cnt,
       --    P_MODIFIEDVALUE =>  v_max_case_cnt,

     P_CASEID := v_Caseid;

    --- Update the Case table
      If v_CaseId is not null
        then

         --- Find out what the StageId is 
          select STAGEID INTO  v_StageId
          from CASES 
          WHERE CASEID = v_CaseId;
          
           LOG_APEX_ACTION(
           P_ACTIONID => 64,
           P_OBJECTTYPE => 'GET_NEXT_' || P_ROLE,
           P_RESULTS =>  'Assigned File',
           P_ORIGINALVALUE => v_current_case_cnt,
           P_MODIFIEDVALUE =>   v_modified_case_cnt,
           P_USERID =>  P_USERID,
           P_CASEID => P_CASEID);
          
          UPDATE CASES
          SET  USERID = P_USERID,
               STAGEID = STAGEID,
               UPDATED_TIMESTAMP = SYSTIMESTAMP,
               ASSIGNMENTTIMESTAMP = SYSTIMESTAMP,
               UPDATED_USERID = P_USERID,
               ASSIGNEDBY = P_USERID
          WHERE CASEID = v_Caseid
                and USERID IS NULL
                 and STAGEID in (select stageid from USER_ROLES_STAGES where userid=P_USERID); 
        COMMIT;




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
                

     ELSE
      --v_Result := v_result || 'No Cases Available for Assignment.';    
       IF v_Result IS NULL then
      --IF P_CASEID IS NULL then
           LOG_APEX_ACTION(
           P_ACTIONID => 65,
           P_OBJECTTYPE => 'GET_NEXT_' || P_ROLE,
           P_RESULTS =>  'No Cases Available for Assignment.',
           P_ORIGINALVALUE => v_current_case_cnt,
           P_MODIFIEDVALUE =>  v_current_case_cnt,
           P_USERID =>  P_USERID,
           P_CASEID => P_CASEID);
        
                
        END IF;

       END IF;

    --- Catcheall no-assignment message
      If v_Result IS Null 
          Then v_result := 'No Cases Assigned.'; 
      END IF;

      apex_application.g_print_success_message :=  'Result Was: ' || v_Result; 
      P_RESULT := v_RESULT;
                
       EXCEPTION WHEN OTHERS THEN LOG_APEX_ERROR(15);
             
   END;

/

