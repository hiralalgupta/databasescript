create or replace
TRIGGER "AUDITLOG_LOGID_TGR" before INSERT ON AUDITLOG FOR EACH row
  BEGIN
    IF inserting THEN
      select current_timestamp into :new.CREATED_TIMESTAMP from dual;
      IF :NEW.LOGID IS NULL THEN
        SELECT AUDITLOG_SEQ.nextval INTO :NEW.LOGID FROM dual;
      END IF;
    END IF;
  END;
/