create or replace
PROCEDURE           "LOG_APEX_ACTION" 
  -- Program name - LOG_APEX_ACTION
  -- Created 9-20-2011 R Benzell
  -- Common Routine to consistenty write user Apex actions
  --
  -- Typical Usage - add to Procedures just before final END;
  --   EXCEPTION WHEN OTHERS THEN LOG_APEX_ERROR(123,'TEST ACTION','optional addl debug info');
/*** to Test    
  begin
    LOG_APEX_ACTION();
 
   LOG_APEX_ACTION(
      P_ACTIONID => 7,  
      P_RESULTS => :P10_IMAGEID,
      P_USERNAME => :DISPLAY_USER
      );
     
    end;
***/
  -- Update History: 
  -- 9-22-2011 R Benzell - Added APEXSESSIONID to SESSION ID logging
  -- 9-21-2012 R Benzell - Added substr(P_RESULT) to avoid  ORA-12899: value too large 
  -- 3-18-2013 R Benzell - Added P_OBJECTID option
           (
               P_USERID  IN NUMBER default NULL,
               P_USERNAME IN VARCHAR2 default NULL ,
               P_TIMESTAMP  IN TIMESTAMP default NULL,
               P_SESSIONID IN  VARCHAR2 default NULL,
               P_APEXSESSIONID IN NUMBER  default NULL,
               P_STAGEID   IN NUMBER  default NULL,
               P_ACTIONID  IN NUMBER   default NULL,
               P_RESULTS  IN  VARCHAR2 default NULL,
               P_CASEID    IN NUMBER default NULL,
               P_PAGEID    IN NUMBER default NULL,
               P_SECTIONNUMBER  IN NUMBER   default NULL,
               P_DPENTRYID   IN NUMBER  default NULL,
               P_OBJECTTYPE  IN  VARCHAR2 default NULL,
               P_ORIGINALVALUE  IN VARCHAR2  default NULL,
               P_MODIFIEDVALUE  IN VARCHAR2  default NULL,
               P_ORIGINALUSERID  IN NUMBER   default NULL,
               P_ORIGINALTIMESTAMP  IN TIMESTAMP default NULL,
               P_ORIGINALSTAGEID   IN NUMBER  default NULL,
               P_CREATED_TIMESTAMP  IN TIMESTAMP default NULL,
               P_CREATED_USERID   IN NUMBER  default NULL,
               P_CREATED_STAGEID   IN NUMBER  default NULL,
               P_UPDATED_TIMESTAMP  IN TIMESTAMP default NULL,
               P_UPDATED_USERID   IN NUMBER  default NULL,
               P_UPDATED_STAGEID   IN NUMBER  default NULL,
               P_OBJECTID IN NUMBER default NULL)
               
  
         IS
 
        v_TIMESTAMP TIMESTAMP; 
        v_USERID VARCHAR2(100); 
        v_sessionid number;
         BEGIN
        --- Grab current once for consistency     
         v_TIMESTAMP := systimestamp;  
        
        --- FUTURE HOOK - determine USERID from USERNAME when you can
         CASE
             WHEN P_USERID is not null then v_USERID := P_USERID;
             WHEN P_USERID is NULL then v_USERID := v('USERID');
             ELSE v_USERID := NULL;
         END CASE;
       -- Determine  SESSIONID when you can and need to
          IF P_APEXSESSIONID IS NOT NULL AND P_SESSIONID IS NULL 
              THEN v_SessionID := APEX_SESSION_TO_SESSIONID(P_APEXSESSIONID);
              ELSE v_SessionID :=P_SESSIONID;
          END IF;    
 
         Insert into AUDITLOG
          (
              USERID   ,
              --USERNAME,
              TIMESTAMP,
              SESSIONID,
              STAGEID    ,
              ACTIONID    ,
              RESULTS    ,
              CASEID    ,
              --PAGEID    ,
              --SECTIONNUMBER    ,
              --DPENTRYID    ,
              OBJECTTYPE  ,
              OBJECTID  ,
              ORIGINALVALUE     ,
              MODIFIEDVALUE     ,
              ORIGINALUSERID    ,
              ORIGINALTIMESTAMP   ,
              ORIGINALSTAGEID    ,
              CREATED_TIMESTAMP   ,
              CREATED_USERID    ,
              CREATED_STAGEID    ,
              UPDATED_TIMESTAMP   ,
              UPDATED_USERID    , 
              UPDATED_STAGEID       
             )
        values
         (
              --nvl(P_USERID ,USERNAME_TO_USERID(v('DISLAY_USER'))),
              v_USERID ,
              --P_USERNAME,
              nvl(P_TIMESTAMP,v_TIMESTAMP)  ,
              v_SessionID,  --nvl(P_SESSIONID, APEX_SESSION_TO_SESSIONID(P_APEXSESSIONID)),
              P_STAGEID   ,
              nvl(P_ACTIONID,1)    ,  -- 1=Uncategorized
              substr(P_RESULTS,1,20)    ,
              P_CASEID   ,
              --P_PAGEID,
              --P_SECTIONNUMBER,
              --P_DPENTRYID,
              nvl(P_OBJECTTYPE,CURRENT_APP_AND_PAGE_ID())  ,
              P_OBJECTID,
              P_ORIGINALVALUE     ,
              P_MODIFIEDVALUE     ,
              v_USERID   ,
              nvl(P_ORIGINALTIMESTAMP,v_TIMESTAMP)   ,
              P_ORIGINALSTAGEID    ,
              nvl(P_CREATED_TIMESTAMP,v_TIMESTAMP)   ,
              v_USERID    ,
              P_CREATED_STAGEID,
              nvl(P_UPDATED_TIMESTAMP,v_TIMESTAMP)   ,
              v_USERID   ,
              P_UPDATED_STAGEID    
           
           );
         --COMMIT;
       --- Update Sessions table with Activity if possible
        IF v_SESSIONID is NOT NULL then
          UPDATE SESSIONS
            set LASTACTIVITYTIMESTAMP = systimestamp
            WHERE SESSIONID = v_SESSIONID;
        END IF;
         
       EXCEPTION WHEN OTHERS THEN LOG_APEX_ERROR(P_ACTIONID);
             
       END;
/