create or replace
TRIGGER "BILLING_BATCH_INS_TGR" before
  INSERT ON BILLING_BATCH FOR EACH row BEGIN IF inserting THEN
  select current_timestamp into :new.CREATED_TIMESTAMP FROM dual;
  SELECT V('USERID') INTO :new.created_userid FROM dual;
  IF :NEW.BATCHID IS NULL THEN
    SELECT BILLING_BATCH_SEQ.nextval INTO :NEW.BATCHID FROM dual;
  END IF;
END IF;
END;
/
