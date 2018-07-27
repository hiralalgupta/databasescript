create or replace
TRIGGER IDIS_CAPRELSA_ICID_TGR before INSERT ON IDIS_CAPRELSA FOR EACH row
  BEGIN
    IF inserting THEN
      select current_timestamp into :new.CREATED_TIMESTAMP from dual;
      IF :NEW.ICID IS NULL THEN
        SELECT IDIS_CAPRELSA_SEQ.nextval INTO :NEW.ICID FROM dual;
      END IF;
    END IF;
  END;
  /