create or replace
TRIGGER "CONFIG_SWITCHES_UPD_TGR" before
  UPDATE ON CONFIG_SWITCHES FOR EACH row BEGIN
  select current_timestamp into :new.UPDATED_TIMESTAMP FROM dual;
  SELECT V('USERID') INTO :new.updated_userid FROM dual;
END;
/