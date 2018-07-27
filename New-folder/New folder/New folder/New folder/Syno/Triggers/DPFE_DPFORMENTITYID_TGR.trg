create or replace
TRIGGER "DPFE_DPFORMENTITYID_TGR" before INSERT ON DPFORMENTITIES FOR EACH row
  BEGIN
    IF inserting THEN
      select current_timestamp into :new.CREATED_TIMESTAMP from dual;
      IF :NEW.DPFORMENTITYID IS NULL THEN
        SELECT DPFORMENTITIES_SEQ.nextval INTO :NEW.DPFORMENTITYID FROM dual;
      END IF;
    END IF;
  END;
  /