create or replace
TRIGGER "MESSAGES_MESSAGEID_TGR" before INSERT ON MESSAGES FOR EACH row
  BEGIN
    IF inserting THEN
      select current_timestamp into :new.CREATED_TIMESTAMP from dual;
      IF :NEW.MESSAGEID IS NULL THEN
        SELECT MESSAGES_SEQ.nextval INTO :NEW.MESSAGEID FROM dual;
      END IF;
    END IF;
  END;
  /