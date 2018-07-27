create or replace
TRIGGER "DOCTYPES_DOCTYPEID_TGR" before INSERT ON DOCUMENTTYPES FOR EACH row
  BEGIN
    IF inserting THEN
      select current_timestamp into :new.CREATED_TIMESTAMP from dual;
      IF :NEW.DOCUMENTTYPEID IS NULL THEN
        SELECT DOCUMENTTYPES_SEQ.nextval INTO :NEW.DOCUMENTTYPEID FROM dual;
      END IF;
    END IF;
  END;
  /