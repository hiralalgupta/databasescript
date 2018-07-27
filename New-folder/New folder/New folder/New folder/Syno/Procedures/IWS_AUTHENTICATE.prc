--------------------------------------------------------
--  DDL for Procedure IWS_AUTHENTICATE
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "SNX_IWS2"."IWS_AUTHENTICATE" (pApexSessionId IN varchar2 default null, pUserId IN OUT number) 

    -- Created 10-23-2011 R Benzell based on TeamInformatics Parameters
    -- provides a reponse indicating if a User is Authenticated and allowed to access the systemorized to perform an action
    -- If autheicated, and pUserId >= 1 is returned
    -- if not, p_userid = -1 is returned
    
    -- to test:
/***
    declare
      v_result number default 3;
    begin
      IWS_AUTHENTICATE(pApexSessionId => '1811697618315344',
                       pUserId => v_result);
       htp.p('Auth Result=' ||v_result);
     end;
***/
    -- Update History:
    -- 10-25-2011 - improved error trapping and reporting for Null Inbound parameters
    --   Further Code Optimization to reduce redundant calls should be made
    -- 12-5-2011 - since P_userid is normally null as an input parameter, disable tracking
    --             of null calls as an Error action
    -- 12-14-2011 - corrected bug where every invocation was being logged into the ErrorLog.
    --              enhanced messaging.
    
    
    IS
    
    v_validflag boolean;
 
    BEGIN  
  
   --- Catch invocations attempts with no data
    IF pApexSessionId IS NULL 
       then
        LOG_APEX_ERROR(p_ACTIONID => 1,
                          P_ACTIONNAME => 'proc IWS_AUTHENTICATE',
                          P_CONTENT =>
                         --'Missing Expected SessionID Parameter. ' ||
                         ' pApexSessionId = >>>' || pApexSessionId || '<<<' ||
                         ' pUserId = >>>' || pUserId || '<<<' );
    END IF;

    
    v_validflag :=   IS_SESSION_VALID(P_APEXSESSION => pApexSessionId);
       
     --P_USERNAME VARCHAR default null,
     --P_SESSION  NUMBER default null,
     --P_WLSSESSION NUMBER default null  

   if v_ValidFlag
      then 
          select USERID into pUserId
              from  SESSIONS
              where  APEXSESSIONID = pApexSessionId;
      else pUserId := -1;
   end if; 
   -- hack to bypass auth pUserId := 4; 
    
   EXCEPTION WHEN OTHERS THEN LOG_APEX_ERROR(
                           p_ACTIONID => 1,
                           P_ACTIONNAME => 'proc IWS_AUTHENTICATE',
                          P_CONTENT =>
                         'Failure in IWS_AUTHENTICATE ' ||
                         ' pApexSessionId = >>>' || pApexSessionId || '<<<' ||
                         ' pUserId = >>>' || pUserId || '<<<' );
   -- hack to bypas auth pUserId := 4;                         

   END;

/

