create or replace
TRIGGER "DIVISIONS_DIVISIONID_TGR" before INSERT ON DIVISIONS FOR EACH row
  BEGIN
    IF inserting THEN
      select current_timestamp into :new.CREATED_TIMESTAMP from dual;
      IF :NEW.DIVISIONID IS NULL THEN
        SELECT DIVISIONS_SEQ.nextval INTO :NEW.DIVISIONID FROM dual;
      END IF;
    END IF;
  END;
  /