--------------------------------------------------------
--  DDL for Function LAST_SESSION_ACTIVITY
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SNX_IWS2"."LAST_SESSION_ACTIVITY" 
    (P_USERID NUMBER default 0,
     P_SESSIONID NUMBER default 0,    -- IWS uses SessionID into Log
     P_APEXSESSIONID NUMBER default 0 -- Apex uses apexSessionID
    )   
    
    
    -- Created 11-13-2012 R Benzell
    -- Returns the last activity datetime from the AUDITLOG for a Session,
    -- regardless if APEX or IWS activity
    
    -- to test:  SELECT LAST_SESSION_ACTIVITY(5,12540,2746134078406990) from dual
   
    
    
        RETURN TIMESTAMP
    
        IS
    
       v_Return  TimeStamp;

        BEGIN
            

            Select max(TIMESTAMP) into v_Return
            From AUDITLOG
            WHERE (SESSIONID = P_SESSIONID
                OR   SESSIONID  = P_APEXSESSIONID)
                AND USERID = P_USERID
                AND TIMESTAMP IS NOT NULL;



         return v_Return;

       EXCEPTION WHEN OTHERS THEN 
            v_Return := NULL;
       END;
 

/

