CREATE OR REPLACE FORCE VIEW "SNX_IWS2"."CASEHISTORYSUM_ASSIGNSTAGE_V" ("ASSIGN_CHID", "STAGEID", "CASEID", "STAGE_CHID", "ASSIGN_USERID",FILE_SEGMENT)
-- 12-7-2013 - Updated to include FILE_SEGMENT for 2.8
                AS
  SELECT A.chid AS assign_chid,
    s.Stageid,
    s.Caseid,
    S.Chid AS Stage_Chid,
    A.Userid,
    A.FILE_SEGMENT
  FROM Casehistorysum A,
    CASEHISTORYSUM S
  WHERE A.assignmentstarttimestamp    IS NOT NULL
  AND A.Assignmentcompletiontimestamp IS NULL
  AND S.Caseid                         =A.Caseid
  AND S.Stageid                        =A.Stageid
  --AND S.FILE_SEGMENT                   =A.FIle_segment
  AND S.Stagestarttimestamp           IS NOT NULL
  AND S.stagecompletiontimestamp      IS NULL
  UNION
  SELECT NULL assign_chid,
    s.Stageid,
    s.Caseid,
    S.Chid AS Stage_Chid,
    NULL userid,
  S.FILE_SEGMENT
  FROM Casehistorysum S
  WHERE S.Stagestarttimestamp    IS NOT NULL
  AND S.stagecompletiontimestamp IS NULL
  AND NOT EXISTS
    (SELECT chid
    FROM Casehistorysum A
    WHERE a.stageid                      =s.stageid
    AND a.caseid                         =s.caseid
    AND A.assignmentstarttimestamp      IS NOT NULL
    AND A.Assignmentcompletiontimestamp IS NULL
    );

