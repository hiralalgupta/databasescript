
CREATE TABLE SC_FORWARDING_AUTH (
FORWARD_AUTH_ID number NOT NULL,
SENDER_ID number DEFAULT NULL,
RECEPIENT_ID number DEFAULT NULL,
RELATION_TYPE varchar2(50) DEFAULT NULL,
STATUS char(1) DEFAULT 'A',
CREATED_ON TIMESTAMP(4) WITH TIME ZONE DEFAULT NULL,
CREATED_BY number DEFAULT NULL,
UPDATED_ON TIMESTAMP(4) WITH TIME ZONE DEFAULT NULL,
UPDATED_BY NUMBER DEFAULT NULL
) tablespace snx_iws;

ALTER TABLE SC_FORWARDING_AUTH
    ADD CONSTRAINT SC_FORWARDING_AUTH_PK PRIMARY KEY (FORWARD_AUTH_ID) using index tablespace snx_iws_inx;

CREATE SEQUENCE SC_FORWARDING_AUTH_SEQ MINVALUE 1 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER NOCYCLE;

CREATE OR REPLACE TRIGGER SC_FORWARDING_AUTH_ID_TGR before INSERT ON SC_FORWARDING_AUTH FOR EACH row
  BEGIN
    IF inserting THEN
      select current_timestamp into :new.CREATED_ON from dual;
      IF :NEW.FORWARD_AUTH_ID IS NULL THEN
        SELECT SC_FORWARDING_AUTH_SEQ.nextval INTO :NEW.FORWARD_AUTH_ID FROM dual;
      END IF;
    END IF;
  END;
/