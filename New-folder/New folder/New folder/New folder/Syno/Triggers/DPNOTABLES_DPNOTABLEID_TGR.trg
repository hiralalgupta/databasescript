create or replace
TRIGGER "DPNOTABLES_DPNOTABLEID_TGR" before INSERT ON DPNOTABLES FOR EACH row
  BEGIN
    IF inserting THEN
      select current_timestamp into :new.CREATED_TIMESTAMP from dual;
      IF :NEW.DPNOTABLEID IS NULL THEN
        SELECT DPNOTABLES_SEQ.nextval INTO :NEW.DPNOTABLEID FROM dual;
      END IF;
    END IF;
  END;
  /