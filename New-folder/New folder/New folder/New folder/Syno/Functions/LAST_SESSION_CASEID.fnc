--------------------------------------------------------
--  DDL for Function LAST_SESSION_CASEID
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SNX_IWS2"."LAST_SESSION_CASEID" 
    (P_USERID NUMBER default 0,
     P_SESSIONID NUMBER default 0,    -- IWS uses SessionID into Log
     P_APEXSESSIONID NUMBER default 0 -- Apex uses apexSessionID
    )   
    
    
    -- Created 11-13-2012 R Benzell
    -- Returns the last active CaseId from the AUDITLOG for a Session,
    -- regardless if APEX or IWS activity
    
    -- to test:  SELECT LAST_SESSION_STAGEID(5,12540,2746134078406990) from dual
    --    SELECT LAST_SESSION_STAGEID(4,12724, 8613951154071948) from dual
    
    
        RETURN NUMBER
    
        IS
    
       v_Return  number;

        BEGIN
            

            Select CASEID into v_Return
            From AuditLog
            where LOGID = (Select max(LOGID)
                           From AUDITLOG 
                           WHERE (SESSIONID = P_SESSIONID OR   SESSIONID  = P_APEXSESSIONID)
                            AND USERID = P_USERID
                            AND CASEID IS NOT NULL);
            



         return v_Return;

       EXCEPTION WHEN OTHERS THEN 
            return NULL;
       END;
 

/

