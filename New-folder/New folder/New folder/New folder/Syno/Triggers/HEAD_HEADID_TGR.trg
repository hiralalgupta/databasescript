create or replace
TRIGGER "HEAD_HEADID_TGR" before INSERT ON HEAD FOR EACH row
  BEGIN
    IF inserting THEN
      select current_timestamp into :new.CREATED_TIMESTAMP from dual;
      IF :NEW.HEADID IS NULL THEN
        SELECT HEAD_SEQ.nextval INTO :NEW.HEADID FROM dual;
      END IF;
    END IF;
  END;
  /