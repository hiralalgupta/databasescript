create or replace
TRIGGER  "HOLIDAY_CALENDAR_INS_TGR" before
  INSERT ON HOLIDAY_CALENDAR FOR EACH row BEGIN IF inserting THEN
  select current_timestamp into :new.CREATED_TIMESTAMP FROM dual;
  SELECT V('USERID') INTO :new.created_userid FROM dual;
  IF :NEW.HOLIDAY_CALENDAR_ID IS NULL THEN
    SELECT HOLIDAY_CALENDAR_SEQ.nextval INTO :NEW.HOLIDAY_CALENDAR_ID FROM dual;
  END IF;
End If;
END;
/