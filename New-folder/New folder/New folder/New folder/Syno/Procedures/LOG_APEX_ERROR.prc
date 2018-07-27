create or replace
PROCEDURE           "LOG_APEX_ERROR" 
  -- Program name - LOG_APEX_ERROR
  -- Created 9-20-2011 R Benzell
  -- Logs error to common file for usage across multiple applications
  --
  -- Typical Usage - add to Procedures just before final END;
  --   EXCEPTION WHEN OTHERS THEN LOG_APEX_ERROR(123,'TEST ACTION','optional addl debug info');
/*** to Test    
  begin
    LOG_APEX_ERROR(123,'test action','Error happened here');
  end;
***/
  -- Update History: 
  --  9-22-2011 - Allow passing of SessionID from external sessions
           (
            p_ACTIONID   in NUMBER   default NULL,  
            P_ACTIONNAME in VARCHAR2 default NULL,
            P_CONTENT    IN VARCHAR2 default NULL,
            P_USERNAME   IN VARCHAR2 default NULL,
            P_SESSION_ID in NUMBER   default NULL,
            P_HANDLE     IN VARCHAR  default NULL   -- How to handle/alert error
            )
         IS
 
   
         v_Message varchar2(32000);
         BEGIN
       
         --- Generate message with Standard oracle trace info
             v_MESSAGE:= SUBSTR(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
                              CHR(13) || 
                              SQLERRM,1,4000);
         Insert into ERRORLOG
          (
           MESSAGE,
           CONTENT,
           USERNAME,
           SCREENNAME,
           ACTIONID,
           ACTIONNAME,
           SESSIONID ,
           CREATED_TIMESTAMP
           )
        values
          (
           v_Message,
           P_CONTENT,
              nvl(P_USERNAME,v('DISPLAY_USER')),
           'A' || v('APP_ID') || '-' || 'P' || v('APP_PAGE_ID'),
           P_ACTIONID,
           P_ACTIONNAME,
           nvl(v('APP_SESSION'),P_SESSION_ID),   -- Need to Change from APEX to Global Session ID
           systimestamp
           );
         --COMMIT;
         
       If P_HANDLE is NOT NULL then
          htp.p(P_CONTENT);
          htp.p(v_MESSAGE);
       END IF;
       END;
/