create or replace
TRIGGER "ROLES_ROLEID_TGR" before INSERT ON ROLES FOR EACH row
  BEGIN
    IF inserting THEN
      select current_timestamp into :new.CREATED_TIMESTAMP from dual;
      IF :NEW.ROLEID IS NULL THEN
        SELECT ROLES_SEQ.nextval INTO :NEW.ROLEID FROM dual;
      END IF;
    END IF;
  END;
  /