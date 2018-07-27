create or replace
TRIGGER "TEAMS_TEAMID_TGR" before INSERT ON TEAMS FOR EACH row
  BEGIN
    IF inserting THEN
      select current_timestamp into :new.CREATED_TIMESTAMP from dual;
      IF :NEW.TEAMID IS NULL THEN
        SELECT TEAMS_SEQ.nextval INTO :NEW.TEAMID FROM dual;
      END IF;
    END IF;
  END;
  /