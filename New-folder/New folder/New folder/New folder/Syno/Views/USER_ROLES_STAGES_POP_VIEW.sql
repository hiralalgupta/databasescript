  CREATE OR REPLACE FORCE VIEW "SNX_IWS2"."USER_ROLES_STAGES_POP_VIEW" ("STAGENAME", "PARALLELISM", "STAGEID", "USERNAME", "USERID", "ROLENAME", "ROLEID", "PRIORITY","USER_FUNCTION_GROUP")
AS
  SELECT S.stagename,
    S.parallelism,
    RS.stageid,
    A.USERNAME,
    U.USERID,
    R.ROLENAME,
    U.ROLEID,
    U.priority,
    S.USER_FUNCTION_GROUP
  FROM userroles U,
    roles R ,
    Users A,
    stages S,
    rolestages RS
  WHERE R.ROLEID = U.ROLEID
  AND A.USERID   = U.USERID
  AND RS.roleid  = R.roleid
  AND S.stageid  = RS.stageid;