create or replace
TRIGGER  "USERROLES_URID_TGR" before INSERT ON USERROLES FOR EACH row
  BEGIN
    IF inserting THEN
      select current_timestamp into :new.CREATED_TIMESTAMP from dual;
      select v('USERID') into :new.CREATED_USERID from dual;
      IF :NEW.URID IS NULL THEN
        SELECT USERROLES_SEQ.nextval INTO :NEW.URID FROM dual;
      END IF;
    END IF;
  END;
  /