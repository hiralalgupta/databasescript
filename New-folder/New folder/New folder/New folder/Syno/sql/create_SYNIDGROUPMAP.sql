Drop table "SNX_IWS2"."SYNIDGROUPMAP";
CREATE TABLE "SNX_IWS2"."SYNIDGROUPMAP"
(
  CASEID NUMBER
, SYNID VARCHAR2(200)
, GROUPID VARCHAR2(20)
, GROUPNAME VARCHAR2(500) 
, ISSUPPORTING VARCHAR2(1) 
, CREATED_BY NUMBER
, CREATED_TIMESTAMP TIMESTAMP (4) WITH TIME ZONE
, UPDATED_BY NUMBER
, UPDATED_TIMESTAMP TIMESTAMP (4) WITH TIME ZONE
) 
TABLESPACE "SNX_IWS";

CREATE UNIQUE INDEX SYNIDGROUPMAP_INDEX1 ON SYNIDGROUPMAP (CASEID, SYNID, GROUPNAME, ISSUPPORTING) 
TABLESPACE "SNX_IWS_INX";
