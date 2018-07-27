create or replace PROCEDURE           "POST_AUTH_PROCESS" 
    -- Created 10-21-2011 R Benzell
    -- Logs the action and creates a Session Entry
    -- Also determines and records the Connection_Environment
    -- Usually called from Post-Authentication Process in Apex Authetication setup
    -- Update History
    --  11-01-2011 R Benzell
    -- Increased size of v_Match_Str variable to resolve errors of:
    --      ORA-06502: PL/SQL: numeric or value error: character string buffer too small
    --  added full CGI info capture if error
    -- 8-18-2012 R Benzell support dual IWS versions based on UAT role
    -- 1-24-2012 R Benzell - Capture USERID into Auditlog
    
    /** unit test:
      begin
          POST_AUTH_PROCESS();
       end;
     **/     
              
    
    --(--P_USERNAME in VARCHAR2,
     --P_SESSIONID in NUMBER,
     --P_SEED in NUMBER,
     --P_TOKEN out NUMBER
     --)
  
 AS   
    v_token NUMBER;
    v_currentdatetime timestamp;

 
       --Env Lookup
       v_env varchar2(30);
 
       v_Match_Str varchar2(1000);
       v_match_split_pos number;

        
BEGIN
    
    -- Grap date/time for consistency
    EXECUTE IMMEDIATE 'alter session set time_zone=''America/New_York''';
    v_currentdatetime := current_timestamp ;


    --- Determine the Connection Environment
         --- On original proxy invocation, this field contains the source Domain
           v_match_str := owa_util.get_cgi_env('HTTP_REFERER');
           if v_match_str IS NULL
                then 
                  htp.p(SHOW_CGI_INFO());   -- show error for debug
                  LOG_APEX_ERROR(6,'POST-AUTH-PROCESS',
                    substr(SHOW_CGI_INFO(),1,4000) );
                  v_match_str := owa_util.get_cgi_env('HTTP_HOST');
              end if;
     
              v_match_split_pos := instr(v_match_str,'/pls/apex/f');
              v_match_str := lower(substr(v_match_str,1,v_match_split_pos-1));


               BEGIN
                  select
                    ENV into v_ENV
                  from ENV_SETTINGS
                  where APEX_HOST_MATCH = v_Match_Str
                     and IWS_REL = v('IWS_REL')
                     and  SEQUENCE > 0;
                  EXCEPTION WHEN OTHERS THEN
                      LOG_APEX_ERROR(6,'POST-AUTH-PROCESS',
                          'no APEX_HOST_MATCH entry for: >>>' || v_Match_Str || '<<<');
               END;


    insert into SESSIONS
        ( USERID,
         CREATED_USERID,
         CONN_ENV,
         APEXSESSIONID,
         LOGINTIMESTAMP,
         CREATED_TIMESTAMP,
         LASTACTIVITYTIMESTAMP,
         IP)
        values
          (USERNAME_TO_USERID(v('DISPLAY_USER')),
          USERNAME_TO_USERID(v('DISPLAY_USER')), 
          v_ENV,    
          v('APP_SESSION'),
          v_currentdatetime,
          v_currentdatetime,
          v_currentdatetime,
          CURRENT_USER_IP());
   COMMIT;
        

 LOG_APEX_ACTION(
      P_USERID => USERNAME_TO_USERID(v('DISPLAY_USER')),
      P_ACTIONID => 6,  -- Login succeeded attempt login
      P_RESULTS => 'Login Sess OK',
      P_USERNAME => v('DISPLAY_USER'),
      P_APEXSESSIONID => v('APP_SESSION')
    );


  
  EXCEPTION WHEN OTHERS THEN LOG_APEX_ERROR(6,'POST-AUTH-PROCESS',
        'username='||v('DISPLAY_USER')|| substr(SHOW_CGI_INFO(),1,3900) );
END;​
