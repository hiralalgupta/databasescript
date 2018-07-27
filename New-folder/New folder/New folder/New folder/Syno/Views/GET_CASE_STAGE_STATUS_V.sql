CREATE OR REPLACE FORCE VIEW "SNX_IWS2"."GET_CASE_STAGE_STATUS_V" ("ASSIGN_CHID", "STAGEID", "CASEID", "STAGE_CHID", "USERID", "FILE_SEGMENT", "ISCOMPLETED")
                AS
  SELECT A.chid AS assign_chid,
    s.Stageid,
    s.Caseid,
    S.Chid AS Stage_Chid,
    A.Userid,
    NULL FILE_SEGMENT,
    'N' iscompleted
  FROM Casehistorysum A,
    CASEHISTORYSUM S,
    Stages st
  WHERE A.assignmentstarttimestamp    IS NOT NULL
  AND A.Assignmentcompletiontimestamp IS NULL
  AND S.Caseid                         =A.Caseid
  AND S.Stageid                        =A.Stageid
  AND S.Stagestarttimestamp           IS NOT NULL
  AND S.stagecompletiontimestamp      IS NULL
  AND s.Stageid                        = st.stageid
  AND st.PARALLELISM                  != 9999
  UNION ALL
  --open non-segmented stages with no assignments
  SELECT NULL assign_chid,
    s.Stageid,
    s.Caseid,
    S.Chid AS Stage_Chid,
    NULL userid,
    NULL FILE_SEGMENT,
    'N' iscompleted
  FROM Casehistorysum S,
    Stages st
  WHERE S.Stagestarttimestamp    IS NOT NULL
  AND S.stagecompletiontimestamp IS NULL
  AND s.Stageid                   = st.stageid
  AND st.PARALLELISM             != 9999
  AND NOT EXISTS
    (SELECT chid
    FROM Casehistorysum A
    WHERE a.stageid                      =s.stageid
    AND a.caseid                         =s.caseid
    AND A.assignmentstarttimestamp      IS NOT NULL
    AND A.Assignmentcompletiontimestamp IS NULL
    )
  UNION ALL
  --open segmented stages
  SELECT NULL AS assign_chid,
    s.Stageid,
    s.Caseid,
    S.Chid AS Stage_Chid,
    A.Userid,
    a.FILE_SEGMENT,
    a.iscompleted
  FROM parallelcasestatus A,
    CASEHISTORYSUM S,
    Stages st
  WHERE S.Caseid                  =A.Caseid
  AND S.Stageid                   =A.Stageid
  AND S.Stagestarttimestamp      IS NOT NULL
  AND S.stagecompletiontimestamp IS NULL
  AND s.Stageid                   = st.stageid
  AND st.PARALLELISM              = 9999;