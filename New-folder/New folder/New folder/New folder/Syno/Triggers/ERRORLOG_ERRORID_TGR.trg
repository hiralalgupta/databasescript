create or replace
TRIGGER "ERRORLOG_ERRORID_TGR" before INSERT ON ERRORLOG FOR EACH row
  BEGIN
    IF inserting THEN
      select current_timestamp into :new.CREATED_TIMESTAMP from dual;
      IF :NEW.ERRORID IS NULL THEN
        SELECT ERRORLOG_SEQ.nextval INTO :NEW.ERRORID FROM dual;
      END IF;
    END IF;
  END;
  /