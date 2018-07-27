create or replace
TRIGGER "PAGES_PAGEID_TGR" before INSERT ON PAGES FOR EACH row
  BEGIN
    IF inserting THEN
      select current_timestamp into :new.CREATED_TIMESTAMP from dual;
      IF :NEW.PAGEID IS NULL THEN
        SELECT PAGES_SEQ.nextval INTO :NEW.PAGEID FROM dual;
      END IF;
      --JHC-10: Populate ORIGINALPAGENUMBER_APS at ingestion
      :NEW.ORIGINALPAGENUMBER_APS := :NEW.ORIGINALPAGENUMBER;
    END IF;
  END;
/  