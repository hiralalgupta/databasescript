--------------------------------------------------------
--  DDL for Procedure DISPLAY_IMAGE
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "SNX_IWS2"."DISPLAY_IMAGE" 
     ( P_IMAGEID NUMBER, 
       P_USERNAME VARCHAR2 default null,
       P_APEXSESSION NUMBER default null,
       P_APP NUMBER default null,
       P_PAGE NUMBER default null
       )
    -- Created 9-19-2011 R Benzell
    -- Display a binary image on a screen
    -- invoke from report line URL like so:
     -- #OWNER#.DISPLAY_IMAGE?P_IMAGEID=#IMAGE_VIEW#&P_APEXSESSION=&APP_SESSION.&P_USERNAME=&DISPLAY_USER.&P_APP=&APP_ID.&P_PAGE=&APP_PAGE_ID.
    
    -- system setup steps:
    -- issue "GRANT EXECUTE ON {proc name} TO  PUBLIC" 
    -- Add this Proc name to APEX_04000.wwv_flow_epg_include_mod_local
    
    -- Update History
    -- 9-21-2011 - use correct file_name   
    -- 9-22-2011 - added audit logging and error trapping
    -- 12-14-2011 improve commend documentations
    
    
    AS
    
 s_mime_type VARCHAR2(48);
 n_length NUMBER;
 s_filename VARCHAR2(400);
 lob_image BLOB;
 v_message varchar2(32000);
BEGIN
    
  -- GRANT execute ON display_image TO public;
  /*    to test   
    https://iws-dev.synodex.com:8080/pls/apex/SNX_APEX_DEV.DISPLAY_IMAGE?P_IMAGEID=27&P_APEXSESSION=3929040116295472&P_USERNAME=RBENZELL&P_APP=185&P_PAGE=21
    begin
      DISPLAY_IMAGE(2);
   end;
 */
     
     
  --IF  IS_SESSION_VALID(USERNAME_TO_USERID(P_USERNAME),null,P_APEXSESSION)
  IF  IS_SESSION_VALID(null,P_USERNAME,P_APEXSESSION)
  
  
     THEN
        SELECT 'application/octet', dbms_lob.getlength( image_content ),FILE_NAME, image_content
          INTO s_mime_type, n_length, s_filename, lob_image
       FROM images
      WHERE imageid = p_IMAGEID;
 
-- Set the size so the browser knows how much it will be downloading.
  owa_util.mime_header(NVL( s_mime_type, 'application/octet' ), FALSE );
  htp.p( 'Content-length: ' || n_length );

  -- The filename will be used by the browser if the users does a "Save as"
  htp.p( 'Content-Disposition: filename="' || s_filename || '"' );
  owa_util.http_header_close;

-- Download the BLOB
  wpg_docload.download_file( lob_image );

--- Log activity
  LOG_APEX_ACTION( P_ACTIONID => 14,
                   P_RESULTS => P_IMAGEID,
                   P_APEXSESSIONID => P_APEXSESSION,
                   P_USERNAME => P_USERNAME,
                   P_USERID => USERNAME_TO_USERID(P_USERNAME),
                   P_OBJECTTYPE =>  CURRENT_APP_AND_PAGE_ID(P_APP,P_PAGE)
                 );
 ELSE
     
  htp.p('INVALID ACCESS ATTEMPT<br> ' || 
      'username: ' || P_USERNAME || '<br>' || 
      'apex sess:' || P_APEXSESSION);
      
  --select USER_NAME || '-' || APEX_SESSION_ID into v_message
  --    from APEX_WORKSPACE_SESSIONS
  --where rownum=1;  --APEX_SESSION_ID =  P_APEXSESSION;
      select count(*) into v_message from APEX_WORKSPACE_SESSIONS;
  --htp.p('xxx'||v_message);

  --- Log invalid access attempt
  LOG_APEX_ACTION( P_ACTIONID => 14,
                   P_RESULTS => P_IMAGEID,
                   P_APEXSESSIONID => P_APEXSESSION,
                   P_USERNAME => P_USERNAME,
                   P_USERID => USERNAME_TO_USERID(P_USERNAME),
                   P_OBJECTTYPE =>  CURRENT_APP_AND_PAGE_ID(P_APP,P_PAGE),
                   P_ORIGINALVALUE => 'INVALID ACCESS ATTEMPT by ' || P_APEXSESSION
                 );
 END IF;
  --- Log error and image it occurred with
  EXCEPTION WHEN OTHERS THEN LOG_APEX_ERROR(14,null,P_IMAGEID);
END;

/

