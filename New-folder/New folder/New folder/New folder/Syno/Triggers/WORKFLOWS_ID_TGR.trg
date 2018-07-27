create or replace
TRIGGER "WORKFLOWS_ID_TGR" before
  INSERT ON WORKFLOWS FOR EACH row BEGIN IF inserting THEN
  select current_timestamp into :new.CREATED_TIMESTAMP FROM dual;
  SELECT V('USERID') INTO :new.created_userid FROM dual;
  IF :NEW.ID IS NULL THEN
    SELECT WORKFLOW_SEQ.nextval INTO :NEW.ID FROM dual;
  END IF;
END IF;
END;
/