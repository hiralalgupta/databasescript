--------------------------------------------------------
--  DDL for Table LOOKUP_DEFINITION
--------------------------------------------------------

  CREATE TABLE "SNX_IWS2"."LOOKUP_DEFINITION" 
   (	"LDID" NUMBER, 
	"TABLE_NAME" VARCHAR2(200 BYTE), 
	"INPUT_POSITION" NUMBER, 
	"INPUT_LABEL" VARCHAR2(500 BYTE), 
	"INPUT_TYPE" VARCHAR2(20 BYTE)
   ) TABLESPACE "SNX_IWS" ;

   --------------------------------------------------------
--  DDL for Index LOOKUP_DEFINITION_UK1
--------------------------------------------------------

  CREATE INDEX "SNX_IWS2"."LOOKUP_DEFINITION_UK1" ON "SNX_IWS2"."LOOKUP_DEFINITION" ("TABLE_NAME", "INPUT_POSITION") TABLESPACE "SNX_IWS_INX" ;
--------------------------------------------------------
--  Constraints for Table LOOKUP_DEFINITION
--------------------------------------------------------

  ALTER TABLE "SNX_IWS2"."LOOKUP_DEFINITION" ADD CONSTRAINT "LOOKUP_DEFINITION_PK" PRIMARY KEY ("LDID")
  USING INDEX TABLESPACE "SNX_IWS_INX";

