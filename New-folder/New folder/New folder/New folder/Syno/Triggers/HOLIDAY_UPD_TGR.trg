create or replace
TRIGGER  "HOLIDAY_UPD_TGR" before
  UPDATE ON HOLIDAY FOR EACH row BEGIN
  select current_timestamp into :new.UPDATED_TIMESTAMP FROM dual;
  SELECT V('USERID') INTO :new.updated_userid FROM dual;
END;
/