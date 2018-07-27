create or replace
TRIGGER "DOCUMENTTYPEGROUPS_DTGID_TGR" before INSERT ON DOCUMENTTYPEGROUPS FOR EACH row
  BEGIN
    IF inserting THEN
      select current_timestamp into :new.CREATED_TIMESTAMP from dual;
      IF :NEW.DTGID IS NULL THEN
        SELECT DOCUMENTTYPEGROUPS_SEQ.nextval INTO :NEW.DTGID FROM dual;
      END IF;
    END IF;
  END;
  /