create or replace
TRIGGER  SNX_IWS2.CASEHISTORYSUM_CHID_TGR before INSERT ON CASEHISTORYSUM FOR EACH row
  BEGIN
    IF inserting THEN
      select current_timestamp into :new.CREATED_TIMESTAMP from dual;
      IF :NEW.CHID IS NULL THEN
        SELECT CASEHISTORYSUM_SEQ.nextval INTO :NEW.CHID FROM dual;
      END IF;
    END IF;
  END;
/