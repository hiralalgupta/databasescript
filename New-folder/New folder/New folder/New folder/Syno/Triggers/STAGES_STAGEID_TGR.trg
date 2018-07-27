create or replace
TRIGGER "STAGES_STAGEID_TGR" before INSERT ON STAGES FOR EACH row
  BEGIN
    IF inserting THEN
      select current_timestamp into :new.CREATED_TIMESTAMP from dual;
      IF :NEW.STAGEID IS NULL THEN
        SELECT STAGES_SEQ.nextval INTO :NEW.STAGEID FROM dual;
      END IF;
    END IF;
  END;
  /