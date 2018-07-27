--------------------------------------------------------
--  DDL for Procedure EMAIL_TEST
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "SNX_IWS2"."EMAIL_TEST" 
is
--DECLARE
l_id NUMBER;
BEGIN
l_id := APEX_MAIL.SEND(
p_to => 'rbenzell@synodex.com',
p_from => 'rbenzell@synodex.com',
p_subj => 'APEX_MAIL with attachment222',
p_body => 'Please review the attachment.',
p_body_html => 'Please review the You have received this mail from DEV APEX ');
APEX_MAIL.PUSH_QUEUE;
/****
FOR c1 IN (SELECT filename, blob_content, mime_type
  FROM APEX_APPLICATION_FILES
   WHERE ID IN (123,456)) LOOP
   APEX_MAIL.ADD_ATTACHMENT(
    p_mail_id => l_id,
    p_attachment => c1.blob_content,
    p_filename => c1.filename,
    p_mime_type => c1.mime_type);
END LOOP;
*/
--COMMIT;
END;

/

