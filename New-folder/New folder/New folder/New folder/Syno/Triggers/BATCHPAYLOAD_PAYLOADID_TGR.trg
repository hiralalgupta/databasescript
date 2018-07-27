create or replace
TRIGGER BATCHPAYLOAD_PAYLOADID_TGR before INSERT ON BATCHPAYLOAD FOR EACH row
  BEGIN
    IF inserting THEN
      select current_timestamp into :new.CREATED_TIMESTAMP from dual;
      IF :NEW.PAYLOADID IS NULL THEN
        SELECT BATCHPAYLOAD_SEQ.nextval INTO :NEW.PAYLOADID FROM dual;
      END IF;
    END IF;
  END;
/