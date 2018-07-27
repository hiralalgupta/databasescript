create or replace
TRIGGER "SESSIONS_SESSIONID_TGR" before INSERT ON SESSIONS FOR EACH row
  BEGIN
    IF inserting THEN
      select current_timestamp into :new.CREATED_TIMESTAMP from dual;
      IF :NEW.SESSIONID IS NULL THEN
        SELECT SESSIONS_SEQ.nextval INTO :NEW.SESSIONID FROM dual;
      END IF;
    END IF;
  END;
  /