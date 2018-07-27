create or replace
TRIGGER  "USERROLES_UPD_TGR" before UPDATE ON USERROLES FOR EACH row
  BEGIN
      select current_timestamp into :new.UPDATED_TIMESTAMP from dual;
      select v('USERID') into :new.UPDATED_USERID from dual;
  END;
  /