create or replace
TRIGGER  "HOLIDAY_INS_TGR" before
  INSERT ON HOLIDAY FOR EACH row BEGIN IF inserting THEN
  select current_timestamp into :new.CREATED_TIMESTAMP FROM dual;
  SELECT V('USERID') INTO :new.created_userid FROM dual;
  IF :NEW.HOLIDAY_ID IS NULL THEN
    SELECT HOLIDAY_SEQ.nextval INTO :NEW.HOLIDAY_ID FROM dual;
  END IF;
End If;
END;
/