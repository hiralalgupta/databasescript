--------------------------------------------------------
--  DDL for Procedure GENERATE_TOKEN
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "SNX_IWS2"."GENERATE_TOKEN" 
    -- Created 9-19-2011 R Benzell
    -- obtains a token from either Proprietary or RSA alogithims
    -- Inserts TOKEN into SESSIONS table
    -- Update History
    --    
          
    /** unit test:
      declare
       v_token number;
      begin
          GENERATE_TOKEN('RBENZELL','12345',v_token);
          htp.p(v_token);  
       end;
     **/     
              
    
    (P_USERNAME in VARCHAR2,
     P_SESSIONID in NUMBER,
     P_SEED in NUMBER,
     P_TOKEN out NUMBER)
  
 AS   
    v_token NUMBER;
    v_currentdatetime timestamp;
        
BEGIN
        
   ---- internal random number for now, RSA later 
   ---  don't send seed with Oracle Token routine
   ---  results in the same result over and over
    P_TOKEN := get_token();
    v_currentdatetime := systimestamp;
    insert into SESSIONS
        ( USERID,
         APEXSESSIONID,
         TOKEN,
         LOGINTIMESTAMP,
         CREATED_TIMESTAMP,
         IP)
        values
         (USERNAME_TO_USERID(P_USERNAME),
          P_SESSIONID,
          P_TOKEN,
          v_currentdatetime, 
          v_currentdatetime, 
          CURRENT_USER_IP());
        
 COMMIT;
  LOG_APEX_ACTION(
      P_ACTIONID => 3,  -- token Generated
      P_USERID => USERNAME_TO_USERID(P_USERNAME),
      P_RESULTS => 'TOKEN GENERATED',
      P_ORIGINALVALUE => P_TOKEN);
  EXCEPTION WHEN OTHERS THEN LOG_APEX_ERROR(3,'GENERATE_TOKEN',
        'username='||P_USERNAME);
END;

/

