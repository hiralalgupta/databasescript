create or replace
TRIGGER PARALLELCASESTATUS_S_PCSID_TGR before INSERT ON PARALLELCASESTATUS_STAGE FOR EACH row
  BEGIN
    IF inserting THEN
      select current_timestamp into :new.CREATED_TIMESTAMP from dual;
      IF :NEW.PCSID IS NULL THEN
        SELECT PARALLELCASESTATUS_S_SEQ.nextval INTO :NEW.PCSID FROM dual;
      END IF;
    END IF;
  END;
  /