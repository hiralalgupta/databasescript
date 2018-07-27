create or replace
TRIGGER "CASES_CASEID_TGR" before INSERT ON CASES FOR EACH row
  BEGIN
    IF inserting THEN
      select current_timestamp into :new.CREATED_TIMESTAMP from dual;
      IF :NEW.CASEID IS NULL THEN
        SELECT CASES_SEQ.nextval INTO :NEW.CASEID FROM dual;
      END IF;
    END IF;
  END;
/