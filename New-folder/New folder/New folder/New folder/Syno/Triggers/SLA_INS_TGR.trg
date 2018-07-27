create or replace
TRIGGER  "SLA_INS_TGR" before
  INSERT ON SLA FOR EACH row BEGIN IF inserting THEN
  select current_timestamp into :new.CREATED_TIMESTAMP FROM dual;
  SELECT V('USERID') INTO :new.created_userid FROM dual;
  IF :NEW.SLA_ID IS NULL THEN
    SELECT SLA_SEQ.nextval INTO :NEW.SLA_ID FROM dual;
  END IF;
END IF;
END;
/