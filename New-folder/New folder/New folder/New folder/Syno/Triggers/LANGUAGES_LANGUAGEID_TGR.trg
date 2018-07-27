create or replace
TRIGGER "LANGUAGES_LANGUAGEID_TGR" before INSERT ON LANGUAGES FOR EACH row
  BEGIN
    IF inserting THEN
      select current_timestamp into :new.CREATED_TIMESTAMP from dual;
      IF :NEW.LANGUAGEID IS NULL THEN
        SELECT LANGUAGES_SEQ.nextval INTO :NEW.LANGUAGEID FROM dual;
      END IF;
    END IF;
  END;
  /