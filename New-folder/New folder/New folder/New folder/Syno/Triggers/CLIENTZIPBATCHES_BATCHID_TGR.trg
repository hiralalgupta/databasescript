create or replace
TRIGGER CLIENTZIPBATCHES_BATCHID_TGR before INSERT ON CLIENTZIPBATCHES FOR EACH row
  BEGIN
    IF inserting THEN
      select current_timestamp into :new.CREATED_TIMESTAMP from dual;
      IF :NEW.BATCHID IS NULL THEN
        SELECT CLIENTZIPBATCHES_SEQ.nextval INTO :NEW.BATCHID FROM dual;
      END IF;
    END IF;
  END;
/