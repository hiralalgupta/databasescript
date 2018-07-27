--------------------------------------------------------
--  DDL for Procedure REQUEST_VALIDITY_CHECK
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "SNX_IWS2"."REQUEST_VALIDITY_CHECK" 
     ( P_SESSION NUMBER default null, 
       P_APEXSESSION NUMBER default null,
       P_JAVASESSION NUMBER default null,
       P_CASEID NUMBER default null,
       P_STAGEID NUMBER default null,
       P_USERID NUMBER default null
       )
    -- Created 9-28-2011 R Benzell
    -- primaryily invoked as a URL by IWS Java workflow
    -- validates Request, and returns XML with Status
    -- to activate
     -- GRANT execute ON REQUEST_VALIDITY_CHECK TO public;
     -- add to APEX_04000.WWV_FLOW_EPG_INCLUDE_MODE_LOCAL for authorization
     -- also, add to 
     -- #OWNER#.REQUEST_VALIDITY_CHECK?P_SESSION=#IMAGE_VIEW#&P_APEXSESSION=&APP_SESSION.&P_USERNAME=&DISPLAY_USER.&P_APP=&APP_ID.&P_PAGE=&APP_PAGE_ID.
     -- sample format of XML response
/****
   27
   3929040116295472
   1111111111
   185
   2
   
   NO
   10-11-2011 09:56:20.071 am
   Global and Apex Session Ids are NOT Valid
   
   
****/
    
     -- Update History
     -- 10-11-2011 R Benzell
     --   Elaborated on invocation as stored procedure
   
   /*    to test  
    select * from sessions order by sessionid desc
    https://iws-dev.synodex.com:8080/pls/apex/SNX_APEX_DEV.REQUEST_VALIDITY_CHECK?P_SESSION=27&P_APEXSESSION=3929040116295472&P_JAVASESSION=1111111111&P_CASEID=185&P_STAGEID=2
    begin
      REQUEST_VALIDITY_CHECK(1,2,3,4,5,6);
      REQUEST_VALIDITY_CHECK( 
                        P_SESSION => 27
                        P_APEXSESSION => 3929040116295472
                        P_JAVASESSION => 1111111111
                        P_CASEID => 185
                        P_STAGEID => 1
          P_USERID => )
      )
   end;
 */
    
    -- Update History
    -- 
    
    
    AS
    
    v_xml varchar2(4000);
    v_nl varchar2(5);
    v_userid number;
    v_username varchar2(30);
    v_validity_flag boolean;
    v_validity  varchar2(5);
    v_now timestamp;
    v_message varchar2(200);
BEGIN
    v_nl := chr(10);
    v_now := systimestamp;
   v_validity_flag := IS_SESSION_VALID(
                     P_APEXSESSION => P_APEXSESSION,
                     P_SESSION =>P_SESSION );
   if v_validity_flag
      then 
           v_message := 'Global and Apex Session Ids are Valid';
           v_Validity := 'YES';
      else 
           v_message := 'Global and Apex Session Ids are NOT Valid';
           v_Validity := 'NO';
   end if;
 
  v_xml := '' ||v_nl ||
           ''               || v_nl ||
           ''             || v_nl ||
              '   '     || P_SESSION     || ''      || v_nl ||   
              '   ' || P_APEXSESSION || '' || v_nl || 
              '   ' || P_JAVASESSION || '' || v_nl || 
              '   '      || P_CASEID      || ''     || v_nl ||  
              '   '     || P_STAGEID     || ''     || v_nl || 
              '   '      || P_USERID      || ''      || v_nl || 
           ''            || v_nl ||
           ''            || v_nl ||
             '   '          || v_Validity    || ''      || v_nl ||
             '   '       || to_char(v_now,'MM-DD-YYYY HH:MI:SS.FF3 pm')      
                                                     || ''     || v_nl ||        
              '   '       || v_message      || ''      || v_nl || 
              '   '        || v_UserId       || ''       || v_nl || 
              '   '      || v_UserName     || ''     || v_nl || 
           ''           || v_nl ||
           '' ;
      
  htp.p(v_xml);
  --- Log validity check/result
  LOG_APEX_ACTION( P_ACTIONID => 14,
                   --P_RESULTS => P_IMAGEID,
                   P_APEXSESSIONID => P_APEXSESSION,
                   --P_USERNAME => P_USERNAME,
                  --P_USERID => USERNAME_TO_USERID(P_USERNAME),
                   --P_OBJECTTYPE =>  CURRENT_APP_AND_PAGE_ID(P_APP,P_PAGE),
                   P_ORIGINALVALUE => 'INVALID ACCESS ATTEMPT by ' || P_APEXSESSION
                 );
 --END IF;
  --- Log error and image it occurred with
  EXCEPTION WHEN OTHERS THEN LOG_APEX_ERROR(14,null,P_SESSION);
END;

/

