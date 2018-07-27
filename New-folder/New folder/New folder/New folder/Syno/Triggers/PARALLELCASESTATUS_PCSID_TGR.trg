create or replace
TRIGGER PARALLELCASESTATUS_PCSID_TGR before INSERT ON PARALLELCASESTATUS FOR EACH row
  BEGIN
    IF inserting THEN
      select current_timestamp into :new.CREATED_TIMESTAMP from dual;
      IF :NEW.PCSID IS NULL THEN
        SELECT PARALLELCASESTATUS_SEQ.nextval INTO :NEW.PCSID FROM dual;
      END IF;
    END IF;
  END;
  /