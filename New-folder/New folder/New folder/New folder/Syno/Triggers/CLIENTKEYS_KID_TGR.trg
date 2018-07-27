create or replace
TRIGGER CLIENTKEYS_KID_TGR before INSERT ON CLIENTKEYS FOR EACH row
  BEGIN
    IF inserting THEN
      select current_timestamp into :new.CREATED_TIMESTAMP from dual;
      IF :NEW.KID IS NULL THEN
        SELECT CLIENTKEYS_SEQ.nextval INTO :NEW.KID FROM dual;
      END IF;
    END IF;
  END;
/