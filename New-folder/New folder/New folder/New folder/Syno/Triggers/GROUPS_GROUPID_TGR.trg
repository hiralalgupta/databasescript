create or replace
TRIGGER "GROUPS_GROUPID_TGR" before INSERT ON GROUPS FOR EACH row
  BEGIN
    IF inserting THEN
      select current_timestamp into :new.CREATED_TIMESTAMP from dual;
      IF :NEW.GROUPID IS NULL THEN
        SELECT GROUPS_SEQ.nextval INTO :NEW.GROUPID FROM dual;
      END IF;
    END IF;
  END;
  /