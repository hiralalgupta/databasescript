create or replace
TRIGGER "ROLESTAGES_RSID_TGR" before INSERT ON ROLESTAGES FOR EACH row
  BEGIN
    IF inserting THEN
      select current_timestamp into :new.CREATED_TIMESTAMP from dual;
      IF :NEW.RSID IS NULL THEN
        SELECT ROLESTAGES_SEQ.nextval INTO :NEW.RSID FROM dual;
      END IF;
    END IF;
  END;
  /