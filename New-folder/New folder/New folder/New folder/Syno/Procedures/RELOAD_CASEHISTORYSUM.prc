--------------------------------------------------------
--  DDL for Procedure RELOAD_CASEHISTORYSUM
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "SNX_IWS2"."RELOAD_CASEHISTORYSUM" 
  -- Program name - RELOAD_CASEHISTORYSUM
  -- Created 5-3-2012 to reload the RELOAD_CASEHISTORYSUM with data from the older format CASEHSTORY table.
      --(
       --P_CASEID IN NUMBER default NULL,
       --P_BEG_DATE IN DATE default NULL,
       --P_END_DATE IN DATE default NULL
     -- )
  
       IS
    
/***
 BEGIN
     RELOAD_CASEHISTORYSUM;
 END;
    
***/    
    
  --v_last_chid number;
   I number default 1;
  -- v_now TIMESTAMP(4) WITH TIME ZONE;

   v_Prev_CaseId  number;
   v_Prev_StageID number;
   v_Prev_UserId  number;
  
   --PREV_STAGESUM  CASEHISTORYSUM%ROWTYPE;
   --PREV_ASSIGNSUM CASEHISTORYSUM%ROWTYPE;
   --NEW_STAGESUM   CASEHISTORYSUM%ROWTYPE;
   --NEW_ASSIGNSUM  CASEHISTORYSUM%ROWTYPE;
  
 
 
  BEGIN
    
   I := 0;   

   for A in
      (
      SELECT
        CASEID,
        USERID,
         STAGEID,
         STAGESTARTTIMESTAMP,
         STAGECOMPLETIONTIMESTAMP,
         ASSIGNEDBY,
         CHID,
         CREATED_TIMESTAMP,
         CREATED_USERID,
          CREATED_STAGEID,
          UPDATED_TIMESTAMP,
          UPDATED_USERID,
          UPDATED_STAGEID,
          ASSIGNMENTTIMESTAMP
        FROM CASEHISTORY
      --  WHERE CASEID>=1534 AND CASEID<= 1802          ---1803    
       -- WHERE CASEID>=1358 AND CASEID<= 1446          ---1803
       --WHERE CASEID>=1804 AND CASEID<= 1825            
       -- WHERE CASEID>=1826 AND CASEID<= 1900
       --  WHERE CASEID>=1901 AND CASEID<= 1910
       --    WHERE CASEID>=1911 AND CASEID<= 1927
           WHERE CASEID >= 1928
       ORDER BY CASEID ASC, CREATED_TIMESTAMP ASC
      )  
        
    LOOP
   
     -- htp.p( to_char(A.CREATED_TIMESTAMP) );
 
    
    IF v_prev_CaseID  = A.CASEID
     THEN    
       I := I+1;
       UPDATE_CASEHISTORYSUM
       (P_CASEID => A.CASEID,
        P_PREV_STAGEID =>  v_PREV_STAGEID,
        P_PREV_USERID => v_PREV_USERID,
        P_NEW_STAGEID => A.STAGEID,
        P_NEW_USERID => A.USERID,
        P_USERID => A.ASSIGNEDBY,
        P_DATE => A.CREATED_TIMESTAMP);
     ELSE
          htp.p(v_prev_Caseid || ' - ' || I || ' ' || systimestamp );
          I := 0;
     END IF;
       
    --- Update for next loop
     v_Prev_CaseId := A.CASEID;
     v_Prev_StageId := A.STAGEID;
     v_Prev_UserId := A.USERID;


    END LOOP;
     
    --- Note last record processed
      htp.p(v_prev_Caseid || ' - ' || I || ' ' || systimestamp );
             
       EXCEPTION WHEN OTHERS THEN
           BEGIN
             LOG_APEX_ERROR();
           END;
             
       END;

/

