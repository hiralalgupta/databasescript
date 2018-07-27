create or replace
TRIGGER "DPCATEGORYGROUPS_DPCGID_TGR" before INSERT ON DPCATEGORYGROUPS FOR EACH row
  BEGIN
    IF inserting THEN
      select current_timestamp into :new.CREATED_TIMESTAMP from dual;
      IF :NEW.DPCGID IS NULL THEN
        SELECT DPCATEGORYGROUPS_SEQ.nextval INTO :NEW.DPCGID FROM dual;
      END IF;
    END IF;
  END;
  /