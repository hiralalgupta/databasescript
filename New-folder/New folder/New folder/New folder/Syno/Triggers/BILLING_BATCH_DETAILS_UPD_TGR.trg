create or replace
TRIGGER "BILLING_BATCH_DETAILS_UPD_TGR" before
  UPDATE ON BILLING_BATCH_DETAILS FOR EACH row BEGIN
  select current_timestamp into :new.UPDATED_TIMESTAMP FROM dual;
  SELECT V('USERID') INTO :new.updated_userid FROM dual;
END;
/
