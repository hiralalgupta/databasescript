create or replace
TRIGGER ROLEDOCTYPES_RDID_TGR before INSERT ON ROLEDOCTYPES FOR EACH row
  BEGIN
    IF inserting THEN
      select current_timestamp into :new.CREATED_TIMESTAMP from dual;
      IF :NEW.RDID IS NULL THEN
        SELECT ROLEDOCTYPES_SEQ.nextval INTO :NEW.RDID FROM dual;
      END IF;
    END IF;
  END;
  /