CREATE OR REPLACE FORCE VIEW "SNX_IWS2"."CASEHISTSUM_ASSIGNSTG_NODUP_V" ("STAGEID", "CASEID", "ASSIGN_USERID",FILE_SEGMENT)
-- 12-7-2013 - Updated to include FILE_SEGMENT for 2.8
AS
  SELECT Stageid,
    Caseid,
    Assign_Userid,
    FILE_SEGMENT
  FROM Casehistorysum_Assignstage_V
  GROUP BY Stageid,
    Caseid,
    Assign_Userid,
    FILE_SEGMENT
    ;

