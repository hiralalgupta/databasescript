create or replace
TRIGGER "USERS_USERID_TGR" before INSERT ON USERS FOR EACH row
  BEGIN
    IF inserting THEN
      select current_timestamp into :new.CREATED_TIMESTAMP from dual;
      IF :new.CREATED_USERID IS NULL THEN
        select v('USERID') into :new.CREATED_USERID from dual;
      END IF;
      IF :NEW.EFFECTIVEDATE IS NULL THEN
        select current_timestamp into :new.EFFECTIVEDATE from dual;
      END IF;
      IF :NEW.USERID IS NULL THEN
        SELECT USERS_SEQ.nextval INTO :NEW.USERID FROM dual;
      END IF;
    END IF;
  END;
  /