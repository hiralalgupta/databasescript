CREATE TABLE SC_CLIENTS 
(
CLIENTID number(38) NOT NULL,
ADDRESS1 varchar(255) DEFAULT NULL,
ADDRESS2 varchar(255) DEFAULT NULL,
ADDRESS3 varchar(255) DEFAULT NULL,
CITY varchar(255) DEFAULT NULL,
CLIENTNAME varchar(30) NOT NULL,
COUNTRY varchar(255) DEFAULT NULL,
DEFAULTDATEFORMAT varchar(50) DEFAULT NULL,
FAX varchar(30) DEFAULT NULL,
NOTES varchar(4000) DEFAULT NULL,
PHONE varchar(30) DEFAULT NULL,
POSTALCODE varchar(50) DEFAULT NULL,
STATE_PROVINCE varchar(255) DEFAULT NULL,
CREATED_BY NUMBER DEFAULT NULL,
CREATED_TIMESTAMP TIMESTAMP(4) WITH TIME ZONE DEFAULT NULL,
UPDATED_BY NUMBER DEFAULT NULL,
UPDATED_TIMESTAMP TIMESTAMP(4) WITH TIME ZONE DEFAULT NULL
)
tablespace snx_iws;

ALTER TABLE SC_CLIENTS 
    ADD CONSTRAINT SC_CLIENTS_PK PRIMARY KEY (CLIENTID) using index tablespace snx_iws_inx;

CREATE SEQUENCE SC_CLIENTS_SEQ MINVALUE 1 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER NOCYCLE;

CREATE OR REPLACE TRIGGER SC_CLIENTS_CLIENTID_TGR before INSERT ON SC_CLIENTS FOR EACH row
  BEGIN
    IF inserting THEN
      select current_timestamp into :new.CREATED_TIMESTAMP from dual;
      IF :NEW.CLIENTID IS NULL THEN
        SELECT SC_CLIENTS_SEQ.nextval INTO :NEW.CLIENTID FROM dual;
      END IF;
    END IF;
  END;
/