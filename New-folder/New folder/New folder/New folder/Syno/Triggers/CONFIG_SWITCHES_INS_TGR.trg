create or replace
TRIGGER "CONFIG_SWITCHES_INS_TGR" before
  INSERT ON CONFIG_SWITCHES FOR EACH row BEGIN IF inserting THEN
  select current_timestamp into :new.CREATED_TIMESTAMP FROM dual;
  SELECT V('USERID') INTO :new.created_userid FROM dual;
  IF :NEW.SWITCHID IS NULL THEN
    SELECT SWITCHID_SEQ.nextval INTO :NEW.SWITCHID FROM dual;
  END IF;
END IF;
END;
/