create or replace
FUNCTION   "BUILD_IWS_URL"
    (P_CASEID          number   default null,   
     P_STAGEID         number   default null,
     P_USERID          number   default null,  
     P_ENV             varchar2 default 'AUTODETECT',
     P_GLOBALSESSIONID number   default null,
     P_APEXSESSIONID   number   default null,   
     P_FORMAT          varchar2 default null)
    
    -- Created 10-12-2011 R Benzell
    -- Generated the full URL necessary to invoke the IWS screen
    -- Updated
    -- 10-13-2011 R Benzell
    -- to Test:  select BUILD_IWS_URL(1,4,3,'DEV') from dual
    --    select BUILD_IWS_URL(1,4,3,'AUTODETECT') from dual
    --    select BUILD_IWS_URL(1,4,3,'INT') from dual
    -- 10-17-2011 R Benzell
    -- Designated 3 environments: DEV-EXT-SSL,DEV-INT-SSL,DEV-INT-NONSSL
    -- 10-20-2011 R Benzell
    -- Added Domain, Port and SSL parameters.  Altered App parameters to CamelHump format
    -- 10-21-2011 R Benzell
    -- Added DEV-CITRIX-SSL, and AUTODETECT
    -- 10-23-2011 R Benzell
    -- Added Stage and role parameter to output
    -- 10-25-2011 R Benzell
    -- Disabled Stage and role from output based on updated requirements
    -- 10-26-2011 R Benzell
    -- Reactivated Stage and role from output based on updated requirements
    -- Also, deactivated non-camel format AppScreen and AppId
    -- 11-1-2011 R Benzell
    -- Added Trap for no Sessions found to avoid the following error when no Session info was found
    --   'ORA-06503: PL/SQL: Function returned without value'
    -- 11-11-2011 R Benzell.  Added "&debug=pi" for debug testing  
    -- 12-5-2011 R Benzell - derive "debug=" flag based on table USER field DEBUG value
    -- 12-7-2011 R Benzell - Use system debug value if no user value indicated
    -- 5-8-2012 R Benzell - removed unused global Session id from URL
    --          added Cookie return info
    -- 6-12-2012 R Benzell - added TR step invocation
    -- 6-15-2012 R Benzell - Added LOCAL PC Debug option, for DEV environment only
    --                 removed unused  cookieName, cookiePath  and cookieDomain info
    -- 6-28-2012 R Benzell - added CX/OP2 Step invocation
    -- 8-18-2012 R Benzell support dual IWS versions based on UAT role
    --                    Better mismatched Host debug info  
    -- 11-14-2012 R Benzell - support for RX, DR and NS Step2 
    -- 3-19-2013 R Benzell - support for POP
    
    -- final format should be something like
    -- /synodex/step1.jsp?caseId=123&globalSessionId=27&apexSessionId=3929040116295472
    -- /synodex/step2.jsp?caseId=123&globalSessionId=27&apexSessionId=3929040116295472
    -- /synodex/step3.jsp?caseId=123&globalSessionId=27&apexSessionId=3929040116295472
    -- /synodex/step4.jsp?caseId=123&globalSessionId=27&apexSessionId=3929040116295472
    

    
        RETURN VARCHAR2
    
        IS
    

       v_URL_HEADER varchar2(255) default null;
       v_ENV varchar2(15);
       v_STEP varchar2(15);
       v_Return varchar2(400) default null;

      --- parameters for IWS returning control to Apex 
      v_Domain varchar2(100);
      v_Port varchar2(10);
      v_SSL varchar2(10);
      v_Role varchar2(2);

      --- Dubugger control
      v_Debug varchar2(10);

 
       --Env Lookup
       v_Org_ENV varchar2(30);
       --v_match_split_pos number;
       

      --- cookie lookup
        v_cookie_name varchar2(256);
        v_cookie_path varchar2(256);
        v_cookie_domain varchar2(256);
        v_secure boolean;
        


        BEGIN
        
         v_ENV := P_ENV;

        --v_debug := P_FORMAT;

       --execute immediate 'insert into errorlog (ACTIONID,ACTIONNAME) values (1,''eeeddddd'') ';   
         
      --- Set proper URL header based on the Environment
      --- DEV-EXT-SSL,DEV-INT-SSL,DEV-INT-NONSSL
       CASE
           WHEN v_ENV = 'AUTODETECT'
              then 
                --- Get Original Connection type from SESSIONS Tables
               BEGIN
                 Select CONN_ENV into v_Org_ENV
                 from SESSIONS
                  where APEXSESSIONID = v('APP_SESSION');
               EXCEPTION WHEN OTHERS THEN
                    BEGIN
                      v_URL_HEADER := 'NO AUTODETECT SESSION FOUND for: >>>' || v('APP_SESSION') || '<<<';
                    END;
               END;
           
             --- On original proxy invocation, this field contains the source Domain
            --  v_match_str := owa_util.get_cgi_env('HTTP_REFERER');
            --  if v_match_str IS NULL
            --    then 
            --      htp.p(SHOW_CGI_INFO());   -- show error for debug
            --      v_match_str := owa_util.get_cgi_env('HTTP_HOST');
            --  end if;
     
            --  v_match_split_pos := instr(v_match_str,'/pls/apex/f');
            --  v_match_str := lower(substr(v_match_str,1,v_match_split_pos-1));


               BEGIN
                  select 
                    IWS_URL_PREFIX,
                    SSL,
                    DOMAIN,
                    PORT
                  into  
                    v_URL_HEADER,
                    v_SSL,
                    v_Domain,
                    v_Port
                  from ENV_SETTINGS
                  where ENV = v_Org_ENV
                   and IWS_REL = v('IWS_REL')
                   and  SEQUENCE > 0;
                  EXCEPTION WHEN OTHERS THEN
                       v_URL_HEADER := 
                          'no AUTODETECT APEX_HOST_MATCH entry for: >>>' || v_Org_ENV || '<<<';
               END;
              --htp.p('match:' ||v_Match_Str);
              --htp.p('service path: ' ||OWA_UTIL.GET_OWA_SERVICE_PATH);

       --- Local PC Debug testing - only available on DEV
           WHEN v_ENV = 'LOCAL' 
              then
                 v_URL_HEADER := 'http://localhost:8080';
                 v_SSL := 'true';
                 v_Domain := 'virnwjhpv04clnx.newjersey.innodata.net';   --'10.155.1.17';
                 v_Port := '7788';

          

            WHEN v_ENV = 'DEV-EXT-SSL' or
                v_ENV = 'EXTDEV' or
                v_ENV = 'EXT'
              then
                 v_URL_HEADER := 'https://iws-dev.synodex.com:8080/synodex';
                 v_SSL := 'true';
                 v_Domain := 'iws-dev.synodex.com';
                 v_Port := '8080';
                

           WHEN
             v_ENV = 'DEV-INT-NONSSL' 
               then 
                 v_URL_HEADER := 'http://10.150.0.232:16300/synodex';
                 v_SSL := 'false';
                 v_Domain := '10.155.1.17';
                 v_Port := '7787';
                 

           WHEN
               v_ENV = 'DEV-INT-SSL' or
               v_ENV = 'INT'
              then 
                 v_URL_HEADER := 'https://10.150.0.232:16301/synodex';
                 v_SSL := 'true';
                 v_Domain := '10.155.1.17';
                 v_Port := '7788';

           WHEN
               v_ENV = 'DEV-CITRIX-SSL' 
              then
                 v_URL_HEADER := 'https://192.168.158.242:16301/synodex';
                 v_SSL := 'true';
                 v_Domain := '192.168.158.243';
                 v_Port := '7788';
                           
 
           ELSE
             --v_URL_HEADER := 'https://10.150.0.232:16301/synodex';
             v_URL_HEADER := 'http://unknown-' || v_ENV;
       END CASE;

        
       CASE
         --- Step 1  
           WHEN P_STAGEID = 4  then
             v_STEP := '/step1?';
             v_Role := 'OP';
       
           WHEN P_STAGEID = 5 then
             v_STEP := '/step1?';
             v_Role := 'QA';


          --- Step 2
           When P_Stageid = 6  Or P_Stageid  = 66  -- 2-OP, RX
             Or P_Stageid = 67 Or P_Stageid  = 68  -- 2-LT, 2-DR
             OR P_STAGEID = 71  then   --Step2-POP
             v_STEP := '/step2?';
             v_Role := 'OP';
        
           WHEN P_STAGEID  = 7 then
             v_STEP := '/step2?';
               v_Role := 'QA';

           WHEN P_STAGEID  = 48 then
             v_STEP := '/step2?';
               v_Role := 'CX';


           WHEN P_STAGEID  = 49 then
             v_STEP := '/step2?';
               v_Role := 'TR';


         --- Step 3  
           WHEN P_STAGEID = 8  then
             v_STEP := '/step3?';
             v_Role := 'OP';

           WHEN P_STAGEID = 9 then
             v_STEP := '/step3?';
             v_Role := 'QA';


          --- Step 4
           WHEN P_STAGEID = 10  then
             v_STEP := '/step4?';
             v_Role := 'OP';

           WHEN P_STAGEID = 11 then
             v_STEP := '/step4?';
             v_Role := 'QA';

          --- QA Review 
           WHEN P_STAGEID = 50 then
             v_STEP := '/step2?';
             v_Role := 'QA';


          ELSE
             v_STEP := '/step1?';
           v_Role := 'OP'; 
       END CASE;   


     --- Determine Performance Debug Parameters to send to IWS
     --- See if we have a User specific value that will take precedence
     --- 
        Select DEBUG into v_DEBUG
           FROM USERS
         WHERE USERID = P_USERID;

     --  If no User specific value, use the System Default  value
         IF v_Debug is NULL
           Then v_DEBUG :=
                  IWS_APP_Utils.getConfigSwitchValue(null,'IWS_PERF_DEBUG');
       END IF;

      --- Get cookie info
       APEX_CUSTOM_AUTH.GET_COOKIE_PROPS(
          p_app_id =>  v('APP_ID'),
          p_cookie_name => v_cookie_name,
          p_cookie_path => v_cookie_path,
          p_cookie_domain => v_cookie_domain,
          p_secure => v_secure);

      --- String it all together
         v_Return := v_URL_HEADER || v_Step           ||
              'caseId='           || P_CASEID         ||
              '&apexSessionId='   || v('APP_SESSION') ||
              '&appId='           || v('APP_ID')      ||
              '&appScreen='       || v('APP_PAGE_ID') ||
              '&ssl='              || nvl(v_SSL,' ')   ||
              '&domain='          || nvl(v_Domain,' ')||
              '&port='            || nvl(v_Port,' ')  ||
              '&stageId='         || P_STAGEID        ||
              '&debug='           || v_Debug          ;   -- added 11-11-11
              --'&cookieName='      || v_cookie_name    ||       -- added 5-8-12
              --'&cookiePath='      || v_cookie_path    ||       -- added 5-8-12
              --'&cookieDomain='    || v_cookie_domain  ;       -- added 5-8-12
              --'&role='            || v_Role         ;  -- disabled 10-25-2011

      RETURN v_Return;
       
       EXCEPTION WHEN OTHERS THEN
            v_Return := SUBSTR(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
                              CHR(13) ||
                              SQLERRM,1,4000); 
           
       END;