create or replace
TRIGGER SC_CLIENTS_CLIENTID_TGR before INSERT ON SC_CLIENTS FOR EACH row
  BEGIN
    IF inserting THEN
      select current_timestamp into :new.CREATED_TIMESTAMP from dual;
      IF :NEW.CLIENTID IS NULL THEN
        SELECT SC_CLIENTS_SEQ.nextval INTO :NEW.CLIENTID FROM dual;
      END IF;
    END IF;
  END;
  /