--------------------------------------------------------
--  File created - Monday-March-14-2016   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Trigger TRI_USER_DEFAULT_ROLE
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "SNX_DASHBOARD"."TRI_USER_DEFAULT_ROLE" 
BEFORE INSERT ON USER_DEFAULT_ROLE 
FOR EACH ROW 
BEGIN 
IF :NEW.PID IS NULL THEN
SELECT USER_DEFAULT_ROLE_SEQ.NEXTVAL INTO :NEW.PID FROM DUAL;
END IF;
END;
/
ALTER TRIGGER "SNX_DASHBOARD"."TRI_USER_DEFAULT_ROLE" ENABLE;
