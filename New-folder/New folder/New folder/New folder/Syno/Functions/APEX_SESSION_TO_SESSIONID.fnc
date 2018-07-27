--------------------------------------------------------
--  DDL for Function APEX_SESSION_TO_SESSIONID
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SNX_IWS2"."APEX_SESSION_TO_SESSIONID" 
    (P_APEXSESSIONID NUMBER)
    
    -- Created 9-20-2011 R Benzell
    -- Retrieve the Global SessionID based on the most recent APEX Session ID
    -- to test:  select  APEX_SESSION_TO_SESSIONID(3870423830468526) from dual;
    -- Update History
    -- 
      RETURN number
    
      IS
         v_SESSIONID number;
        
       BEGIN
        BEGIN 
           select max(SESSIONID) into v_SESSIONID 
          from SESSIONS
                 where APEXSESSIONID = P_APEXSESSIONID;
        EXCEPTION
           WHEN OTHERS THEN v_SESSIONID := -1;
        END;
        
        return v_SESSIONID;
       
      END;

/

