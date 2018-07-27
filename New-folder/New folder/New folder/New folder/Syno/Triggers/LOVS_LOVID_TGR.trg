create or replace
TRIGGER "LOVS_LOVID_TGR" before INSERT ON LOVS FOR EACH row
  BEGIN
    IF inserting THEN
      select current_timestamp into :new.CREATED_TIMESTAMP from dual;
      IF :NEW.LOVID IS NULL THEN
        SELECT LOVS_SEQ.nextval INTO :NEW.LOVID FROM dual;
      END IF;
    END IF;
  END;
  /