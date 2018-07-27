create or replace
TRIGGER SC_GROUPS_GroupId_TGR before INSERT ON SC_GROUPS FOR EACH row
  BEGIN
    IF inserting THEN
      select current_timestamp into :new.CREATED_TIMESTAMP from dual;
      IF :NEW.GroupId IS NULL THEN
        SELECT SC_GROUPS_SEQ.nextval INTO :NEW.GroupId FROM dual;
      END IF;
    END IF;
  END;
  /