set define off

DROP TABLE PARALLELCASESTATUS_STAGE CASCADE CONSTRAINTS;
CREATE TABLE PARALLELCASESTATUS_STAGE 
    ( 
     PCSID INTEGER  NOT NULL , 
     CASEID INTEGER ,
     STAGEID INTEGER ,
     COMPLETIONCOUNT INTEGER, 
     CREATED_TIMESTAMP TIMESTAMP (4) WITH TIME ZONE,
     UPDATED_TIMESTAMP TIMESTAMP (4) WITH TIME ZONE
    ) 
;
ALTER TABLE PARALLELCASESTATUS_STAGE 
    ADD CONSTRAINT PARALLELCASESTATUS_S_PK PRIMARY KEY ( PCSID ) using index tablespace snx_iws_inx;
CREATE UNIQUE INDEX PARALLELCASESTATUS_S_UK1 ON PARALLELCASESTATUS_STAGE 
    (CASEID, STAGEID) tablespace snx_iws_inx;

DROP SEQUENCE PARALLELCASESTATUS_S_SEQ;
--Create Sequence
CREATE SEQUENCE PARALLELCASESTATUS_S_SEQ MINVALUE 1 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER NOCYCLE;

--Create Trigger
CREATE OR REPLACE TRIGGER PARALLELCASESTATUS_S_PCSID_TGR before INSERT ON PARALLELCASESTATUS_STAGE FOR EACH row
  BEGIN
    IF inserting THEN
      select current_timestamp into :new.CREATED_TIMESTAMP from dual;
      IF :NEW.PCSID IS NULL THEN
        SELECT PARALLELCASESTATUS_S_SEQ.nextval INTO :NEW.PCSID FROM dual;
      END IF;
    END IF;
  END;
/
