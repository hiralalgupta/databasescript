create or replace
TRIGGER "WORKFLOWS_ID_UPD_TGR" before
  UPDATE ON WORKFLOWS FOR EACH row BEGIN
  select current_timestamp into :new.UPDATED_TIMESTAMP FROM dual;
  SELECT V('USERID') INTO :new.updated_userid FROM dual;
END;
/