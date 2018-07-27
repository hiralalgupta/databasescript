--------------------------------------------------------
--  DDL for Table LOOKUP_VALUES
--------------------------------------------------------

  CREATE TABLE "SNX_IWS2"."LOOKUP_VALUES" 
   (	"LVID" NUMBER, 
	"LABEL" VARCHAR2(500 BYTE), 
	"INPUT1" VARCHAR2(200 BYTE), 
	"INPUT2" VARCHAR2(200 BYTE), 
	"INPUT3" VARCHAR2(200 BYTE), 
	"INPUT4" VARCHAR2(200 BYTE), 
	"OUTPUT" VARCHAR2(200 BYTE)
   ) TABLESPACE "SNX_IWS" ;

--------------------------------------------------------
--  DDL for Index LOOKUP_VALUES_UK1
--------------------------------------------------------

  CREATE INDEX "SNX_IWS2"."LOOKUP_VALUES_UK1" ON "SNX_IWS2"."LOOKUP_VALUES" ("LABEL", "INPUT1", "INPUT2", "INPUT3", "INPUT4") TABLESPACE "SNX_IWS_INX" ;

  --------------------------------------------------------
--  Constraints for Table LOOKUP_VALUES
--------------------------------------------------------

  ALTER TABLE "SNX_IWS2"."LOOKUP_VALUES" ADD CONSTRAINT "LOOKUP_VALUES_PK" PRIMARY KEY ("LVID")
  USING INDEX TABLESPACE "SNX_IWS_INX";

DROP SEQUENCE SNX_IWS2.LOOKUP_VALUES_SEQ;
--Create Sequence
CREATE SEQUENCE SNX_IWS2.LOOKUP_VALUES_SEQ MINVALUE 1 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER NOCYCLE;

--Create Trigger
CREATE OR REPLACE TRIGGER LOOKUP_VALUES_LVID_TGR before INSERT ON SNX_IWS2.LOOKUP_VALUES FOR EACH row
  BEGIN
    IF inserting THEN
      IF :NEW.LVID IS NULL THEN
        SELECT SNX_IWS2.LOOKUP_VALUES_SEQ.nextval INTO :NEW.LVID FROM dual;
      END IF;
    END IF;
  END;
/