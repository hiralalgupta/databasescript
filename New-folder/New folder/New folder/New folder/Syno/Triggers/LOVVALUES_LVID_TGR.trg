create or replace
TRIGGER "LOVVALUES_LVID_TGR" before INSERT ON LOVVALUES FOR EACH row
  BEGIN
    IF inserting THEN
      select current_timestamp into :new.CREATED_TIMESTAMP from dual;
      IF :NEW.LVID IS NULL THEN
        SELECT LOVVALUES_SEQ.nextval INTO :NEW.LVID FROM dual;
      END IF;
    END IF;
  END;
  /