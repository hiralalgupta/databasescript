create or replace
TRIGGER QCAICODES_QCID_TGR before INSERT ON QCAICODES FOR EACH row
  BEGIN
    IF inserting THEN
      select current_timestamp into :new.CREATED_TIMESTAMP from dual;
      IF :NEW.QCID IS NULL THEN
        SELECT QCAICODES_SEQ.nextval INTO :NEW.QCID FROM dual;
      END IF;
    END IF;
  END;
  /