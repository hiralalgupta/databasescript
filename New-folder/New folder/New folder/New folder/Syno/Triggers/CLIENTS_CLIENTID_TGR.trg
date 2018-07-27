create or replace
TRIGGER "CLIENTS_CLIENTID_TGR" before INSERT ON CLIENTS FOR EACH row
  BEGIN
    IF inserting THEN
      select current_timestamp into :new.CREATED_TIMESTAMP from dual;
      IF :NEW.CLIENTID IS NULL THEN
        SELECT CLIENTS_SEQ.nextval INTO :NEW.CLIENTID FROM dual;
      END IF;
    END IF;
  END;
/