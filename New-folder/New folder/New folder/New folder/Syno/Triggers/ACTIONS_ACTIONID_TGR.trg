create or replace
TRIGGER "ACTIONS_ACTIONID_TGR" before INSERT ON ACTIONS FOR EACH row
  BEGIN
    IF inserting THEN
      select current_timestamp into :new.CREATED_TIMESTAMP from dual;
      IF :NEW.ACTIONID IS NULL THEN
        SELECT ACTIONS_SEQ.nextval INTO :NEW.ACTIONID FROM dual;
      END IF;
    END IF;
  END;
/