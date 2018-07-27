create or replace
TRIGGER "DPCATEGORIES_DPCATEGORYID_TGR" before INSERT ON DPCATEGORIES FOR EACH row
  BEGIN
    IF inserting THEN
      select current_timestamp into :new.CREATED_TIMESTAMP from dual;
      IF :NEW.DPCATEGORYID IS NULL THEN
        SELECT DPCATEGORIES_SEQ.nextval INTO :NEW.DPCATEGORYID FROM dual;
      END IF;
    END IF;
  END;
  /