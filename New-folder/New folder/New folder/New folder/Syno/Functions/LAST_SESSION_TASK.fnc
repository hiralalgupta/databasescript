--------------------------------------------------------
--  DDL for Function LAST_SESSION_TASK
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SNX_IWS2"."LAST_SESSION_TASK" 
    (P_USERID NUMBER default 0,
     P_SESSIONID NUMBER default 0,    -- IWS uses SessionID into Log
     P_APEXSESSIONID NUMBER default 0 -- Apex uses apexSessionID
    )   
    
    
    -- Created 11-13-2012 R Benzell
    -- Returns the last activity datetime from the AUDITLOG for a Session,
    -- regardless if APEX or IWS activity
    
    -- to test:  SELECT LAST_SESSION_TASK(5,12540,2746134078406990) from dual
    
    
        RETURN NUMBER
    
        IS
    
       v_Return  number;

        BEGIN
            

            Select STAGEID into v_Return
            From AuditLog
            where LOGID = (Select max(LOGID)
                           From AUDITLOG 
                           WHERE (SESSIONID = P_SESSIONID OR   SESSIONID  = P_APEXSESSIONID)
                            AND USERID = P_USERID
                            AND STAGEID IS NOT NULL);
            



         return v_Return;

       EXCEPTION WHEN OTHERS THEN 
            v_Return := NULL;
       END;
 

/

