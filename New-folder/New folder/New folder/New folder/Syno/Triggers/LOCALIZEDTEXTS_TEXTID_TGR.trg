create or replace
TRIGGER "LOCALIZEDTEXTS_TEXTID_TGR" before INSERT ON LOCALIZEDTEXTS FOR EACH row
  BEGIN
    IF inserting THEN
      select current_timestamp into :new.CREATED_TIMESTAMP from dual;
      IF :NEW.TEXTID IS NULL THEN
        SELECT LOCALIZEDTEXTS_SEQ.nextval INTO :NEW.TEXTID FROM dual;
      END IF;
    END IF;
  END;
  /