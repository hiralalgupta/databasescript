--------------------------------------------------------
--  DDL for Procedure VALIDITY_CHECK
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "SNX_IWS2"."VALIDITY_CHECK" 
     ( P_SESSION in NUMBER   default null,
       P_APEXSESSION in NUMBER default null,
       P_JAVASESSION in NUMBER default null,
       P_CASEID in NUMBER default null,
       P_STAGEID in NUMBER default null,
       P_USERID in out NUMBER ,
       P_VALIDITY out VARCHAR2 ,
       P_MESSAGE out VARCHAR2 ,
       P_USERNAME out VARCHAR2
       )
    -- Created 10-14-2011 R Benzell
    -- Core Logic of Validity check Called by REQUEST_VALIDITY_CHECK as URL
    -- or invoked by EXT_VALIDITY_CHECK as a stored procedure
/****
****/
    
     -- Update History
     -- 10-11-2011 R Benzell
     --   Elaborated on invocation as stored procedure
   
   /*    to test  
    select * from sessions order by sessionid desc
    https://iws-dev.synodex.com:8080/pls/apex/SNX_APEX_DEV.REQUEST_VALIDITY_CHECK?P_SESSION=27&P_APEXSESSION=3929040116295472&P_JAVASESSION=1111111111&P_CASEID=185&P_STAGEID=2
    begin
      REQUEST_VALIDITY_CHECK(1,2,3,4,5,6);
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

   begin
    select USERNAME into P_USERNAME
       from USERS
       where USERID = P_USERID;
    EXCEPTION WHEN OTHERS THEN P_USERNAME := NULL;
   END;

   if v_validity_flag
      then
           P_message := 'Global and Apex Session Ids are Valid';
           P_Validity := 'YES';
      else
           P_message := 'Global and Apex Session Ids are NOT Valid';
           P_Validity := 'NO';
   end if;
 

      


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

