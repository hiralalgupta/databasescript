create or replace
TRIGGER SC_FORWARDING_AUTH_ID_TGR before INSERT ON SC_FORWARDING_AUTH FOR EACH row
  BEGIN
    IF inserting THEN
      select current_timestamp into :new.CREATED_ON from dual;
      IF :NEW.FORWARD_AUTH_ID IS NULL THEN
        SELECT SC_FORWARDING_AUTH_SEQ.nextval INTO :NEW.FORWARD_AUTH_ID FROM dual;
      END IF;
    END IF;
  END;
  /