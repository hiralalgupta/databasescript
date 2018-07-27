create or replace
TRIGGER  "TRANSLATIONS_TID_TGR" before INSERT ON TRANSLATIONS FOR EACH row
  BEGIN
    IF inserting THEN
      select current_timestamp into :new.CREATED_TIMESTAMP from dual;
      IF :NEW.TID IS NULL THEN
        SELECT TRANSLATIONS_SEQ.nextval INTO :NEW.TID FROM dual;
      END IF;
    END IF;
  END;
  /