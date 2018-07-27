create or replace
TRIGGER APS_XSLT_TEMPLATES_TID_TGR before INSERT ON APS_XSLT_TEMPLATES FOR EACH row
  BEGIN
    IF inserting THEN
      select current_timestamp into :new.CREATED_TIMESTAMP from dual;
      IF :NEW.TID IS NULL THEN
        SELECT APS_XSLT_TEMPLATES_SEQ.nextval INTO :NEW.TID FROM dual;
      END IF;
    END IF;
  END;
/