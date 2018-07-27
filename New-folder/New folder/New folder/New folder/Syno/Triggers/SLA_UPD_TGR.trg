create or replace
TRIGGER  "SLA_UPD_TGR" before
  UPDATE ON SLA FOR EACH row BEGIN
  select current_timestamp into :new.UPDATED_TIMESTAMP FROM dual;
  SELECT V('USERID') INTO :new.updated_userid FROM dual;
END;
/