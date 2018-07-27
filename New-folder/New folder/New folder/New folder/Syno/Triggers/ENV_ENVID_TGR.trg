create or replace
TRIGGER "ENV_ENVID_TGR" before INSERT ON ENV_SETTINGS FOR EACH row
  BEGIN
    IF inserting THEN
      --select systimestamp into :new.CREATED_TIMESTAMP from dual;
      IF :NEW.ENV_ID IS NULL THEN
        SELECT ENV_SEQ.nextval INTO :NEW.ENV_ID FROM dual;
      END IF;
    END IF;
  END;
  /