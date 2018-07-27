create or replace
TRIGGER "MASTERCODES_CODEID_TGR" before INSERT ON MASTERCODES FOR EACH row
  BEGIN
    IF inserting THEN
      select current_timestamp into :new.CREATED_TIMESTAMP from dual;
      IF :NEW.CODEID IS NULL THEN
        SELECT MASTERCODES_SEQ.nextval INTO :NEW.CODEID FROM dual;
      END IF;
    END IF;
  END;
  /