--------------------------------------------------------
--  DDL for View PARALLEL_STAGE_THREAD_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "SNX_IWS2"."PARALLEL_STAGE_THREAD_V" ("CLIENTID", "STAGEID", "THREADNUM") AS 
  Select clientid, nextstageid as stageid, 
ROW_NUMBER() OVER (PARTITION BY clientid ORDER BY sequence) AS threadnum
From Workflows
Where Condition='PARALLEL';
