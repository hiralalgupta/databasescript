create or replace
TRIGGER SC_GROUPS_CLIENTS_TGR before INSERT ON SC_GROUPS_CLIENTS FOR EACH row
  BEGIN
  
  IF :NEW.SC_GROUPS_CLIENTS_ID IS NULL THEN
  
  SELECT SEQ_SC_GROUPS_CLIENTS.NEXTVAL INTO :NEW.SC_GROUPS_CLIENTS_ID FROM DUAL;
  
  END IF ;
  END;
  /