create or replace
TRIGGER "DPSUBCATEGORIES_DPSUBCATID_TGR" before INSERT ON DPSUBCATEGORIES FOR EACH row
  BEGIN
    IF inserting THEN
      select current_timestamp into :new.CREATED_TIMESTAMP from dual;
      IF :NEW.DPSUBCATID IS NULL THEN
        SELECT DPSUBCATEGORIES_SEQ.nextval INTO :NEW.DPSUBCATID FROM dual;
      END IF;
    END IF;
  END;
  /