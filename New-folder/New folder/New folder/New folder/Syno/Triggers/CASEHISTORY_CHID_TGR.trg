create or replace
TRIGGER "CASEHISTORY_CHID_TGR" before INSERT ON CASEHISTORY FOR EACH row
  BEGIN
    IF inserting THEN
      select current_timestamp into :new.CREATED_TIMESTAMP from dual;
      IF :NEW.CHID IS NULL THEN
        SELECT CASEHISTORY_SEQ.nextval INTO :NEW.CHID FROM dual;
      END IF;
    END IF;
  END;
/