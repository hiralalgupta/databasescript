create or replace
TRIGGER ROLECATEGORIES_RCID_TGR before INSERT ON ROLECATEGORIES FOR EACH row
  BEGIN
    IF inserting THEN
      select current_timestamp into :new.CREATED_TIMESTAMP from dual;
      IF :NEW.RCID IS NULL THEN
        SELECT ROLECATEGORIES_SEQ.nextval INTO :NEW.RCID FROM dual;
      END IF;
    END IF;
  END;
  /