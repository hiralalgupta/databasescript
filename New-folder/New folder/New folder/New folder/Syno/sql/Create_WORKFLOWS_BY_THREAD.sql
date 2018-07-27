--------------------------------------------------------
--  DDL for Table WORKFLOWS_BY_THREAD
--------------------------------------------------------

  CREATE TABLE "SNX_IWS2"."WORKFLOWS_BY_THREAD" 
   (	"CLIENTID" NUMBER, 
	"STAGEID" NUMBER(*,0), 
	"STAGENAME" VARCHAR2(20 CHAR), 
	"SEQUENCE" NUMBER(*,0), 
	"THREADNUM" NUMBER, 
	"THREADSEQ" NUMBER, 
	"ISERRORSTAGE" CHAR(1 BYTE), 
	"USER_FUNCTION_GROUP" VARCHAR2(20 BYTE), 
	"PARALLEL_GROUP" VARCHAR2(100 BYTE)
   ) TABLESPACE "SNX_IWS" ;
--------------------------------------------------------
--  DDL for Index WORKFLOWS_BY_THREAD_UK1
--------------------------------------------------------

  CREATE UNIQUE INDEX "SNX_IWS2"."WORKFLOWS_BY_THREAD_UK1" ON "SNX_IWS2"."WORKFLOWS_BY_THREAD" ("CLIENTID", "STAGEID") 
  TABLESPACE "SNX_IWS_INX" ;

--IWN-1103: Add parallelism column to workflows_by_thread table
Alter Table WORKFLOWS_BY_THREAD add (parallelism Integer);
