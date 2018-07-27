--------------------------------------------------------
--  DDL for Function CURRENT_USER_IP
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SNX_IWS2"."CURRENT_USER_IP" 
    -- Created 9-15-2011 R Benzell
    -- use this instead of directly calling OWA_UTIL.GET_CGI_ENV to handle 
    -- the more complex IP interragotory in needed in different DMZ environments
    -- to test: select CURRENT_USER_IP from dual;
    -- Updated 9-19-2011 - R Benzell
    --    Check 'X-Forwarded-For' variable first.
    --   requires "PlsqlCGIEnvironmentList X-Forwarded-For" being defined in
    --   the ../config/OHS/ohs1/mod_plsql/dads.conf file
     
     
               RETURN VARCHAR2
           IS
    
      --v_IP_ADDR varchar2(500);
             BEGIN
     --In Most proxy-based access the 'X-Forwarded-For' will contain the most applicable
     --IP information.  In some local environments, the 'X-Forwarded-For' will
     --be blank, and you must reference the 'REMOTE_ADDR' value
    return  nvl(OWA_UTIL.GET_CGI_ENV('X-Forwarded-For'),
                OWA_UTIL.GET_CGI_ENV('REMOTE_ADDR'));
       
      END;

/

