create or replace
TRIGGER INFOPATHDATA_IPID_TGR before INSERT ON INFOPATHDATA FOR EACH row
  BEGIN
    IF inserting THEN
      select current_timestamp into :new.CREATED_TIMESTAMP from dual;
      IF :NEW.IPID IS NULL THEN
        SELECT INFOPATHDATA_SEQ.nextval INTO :NEW.IPID FROM dual;
      END IF;
    END IF;
  END;
  /