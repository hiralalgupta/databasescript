--------------------------------------------------------
--  DDL for Function IS_SESSION_VALID
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SNX_IWS2"."IS_SESSION_VALID" 
    (P_USERID   NUMBER default null,
     P_USERNAME VARCHAR default null,
     P_APEXSESSION VARCHAR2 default null,
     P_SESSION  NUMBER default null,
     P_WLSSESSION NUMBER default null   
    )
    
    -- Created 9-22-2011 R Benzell
    -- Determine if a combination of User and Session info is valid
    /*** to test: select IS_SESSION_VALID('RBENZELL',392904011629547) from dual;
     begin
     if IS_SESSION_VALID(3,null,2313578140712473)
       then htp.p('VALID');
       else htp.p('BAD');
     end if;
     if IS_SESSION_VALID(null,null,'6591009772027461',49)
       then htp.p('VALID');
       else htp.p('BAD');
     if IS_SESSION_VALID(null,null,'6591009772027461')
       then htp.p('VALID');
       else htp.p('BAD');
     end if;
     end;
     ***/
    -- Update History
    -- 9-28-2011 R Benzell
    -- Separate validty checks based on comination of paramters
    -- 10-24-2011 R Benzell - case option to validate solely based on ApexSessionId
    -- 1-18-2012 R Benzell.  Changed Timeout to 1200 seconds (20 minutes)
    
    
        RETURN BOOLEAN
    
        IS
    
        v_last_activity_on timestamp;
        v_elapsed_seconds number default 0;
        v_old_timestamp timestamp;
        v_return boolean;
        
        BEGIN
            
            v_old_timestamp := to_date('01-01-1900','MM-DD-YYYY');  --systimestamp-100000;     
            
       CASE
          --- Validate on ApexSessionId only 
           WHEN  P_USERID IS NULL AND P_APEXSESSION IS NOT NULL 
           then
              select max(LASTACTIVITYTIMESTAMP) into v_last_activity_on
              from  SESSIONS
              where  APEXSESSIONID =  P_APEXSESSION;
           
          --- Validate on both ApexSessionId and Userid 
           WHEN  P_USERID IS NOT NULL AND P_APEXSESSION IS NOT NULL 
           then
              select max(LASTACTIVITYTIMESTAMP) into v_last_activity_on
              from  SESSIONS
              where USERID  = P_USERID and
              APEXSESSIONID =  P_APEXSESSION;
             -- htp.p('checking with userid and apex session');
           
          --- Validate on both ApexSessionId and globalSessionid
           WHEN  P_SESSION IS NOT NULL AND P_APEXSESSION IS NOT NULL 
           then
              select max(LASTACTIVITYTIMESTAMP) into v_last_activity_on
              from  SESSIONS
              where SESSIONID  = P_SESSION and
              APEXSESSIONID =  P_APEXSESSION;
             --  htp.p('checking with session and apex session');

          ELSE 
              v_last_activity_on :=  v_old_timestamp;
              --    htp.p('invalid parameters for checking');

       END CASE;
       --- If no timestamp, use "old" value
       if v_last_activity_on IS NULL 
        then
         v_last_activity_on :=  v_old_timestamp;
       end if;            
    
       -- select count(*) into v_active_sessions
       -- from  APEX_WORKSPACE_SESSIONS
       -- where USER_NAME = P_USERNAME and
       --       APEX_SESSION_ID =  P_APEXSESSION;
       v_elapsed_seconds := SECONDS_BETWEEN_TIMESTAMPS(v_last_activity_on,systimestamp);
       --htp.p('last='||to_char(v_last_activity_on,'MM-DD-YYYY HH:MI:SSpm'));
       --htp.p('elapsed='||v_elapsed_seconds);
    
        IF  v_elapsed_seconds < 1200 --  20 min * 60 secs/min  = 1200 seconds
           then v_return := TRUE;  -- 'VALID';
           else v_return := FALSE; --'NOTVALID' ;
        END IF;
    --- ### hack to bypass validation ###
    --v_return := TRUE; 
    
    Return v_return;
       
      END;

/

