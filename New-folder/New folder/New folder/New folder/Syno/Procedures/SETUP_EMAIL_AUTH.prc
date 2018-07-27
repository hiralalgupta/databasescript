--------------------------------------------------------
--  DDL for Procedure SETUP_EMAIL_AUTH
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "SNX_IWS2"."SETUP_EMAIL_AUTH" 
    
    AS
    
--DECLARE
    
ACL_PATH VARCHAR2(4000);
ACL_ID RAW(16);
BEGIN
-- Look for the ACL currently assigned to '*' and give APEX_040000
-- the "connect" privilege if APEX_040000 does not have the privilege yet.
SELECT ACL INTO ACL_PATH FROM DBA_NETWORK_ACLS
WHERE HOST = '*' AND LOWER_PORT IS NULL AND UPPER_PORT IS NULL;
-- Before checking the privilege, make sure that the ACL is valid
-- (for example, does not contain stale references to dropped users).
-- If it does, the following exception will be raised:
--
-- ORA-44416: Invalid ACL: Unresolved principal 'APEX_040000'
--Tip: To run the examples described in this section, the compatible
--initialization parameter of the database must be set to at least
--11.1.0.0.0. By default an 11g database will have the parameter set
--properly, but a database upgraded to 11g from a prior version may
--not. See "Creating and Configuring an Oracle Database" in Oracle
--Database Administrator's Guide for information about changing
--database initialization parameters.
--Understanding Administrator Security Best Practices
--13-6 Oracle Application Express Application Builder User's Guide
-- ORA-06512: at "XDB.DBMS_XDBZ", line ...
--
SELECT SYS_OP_R2O(extractValue(P.RES, '/Resource/XMLRef')) INTO ACL_ID
FROM XDB.XDB$ACL A, PATH_VIEW P
WHERE extractValue(P.RES, '/Resource/XMLRef') = REF(A) AND
EQUALS_PATH(P.RES, ACL_PATH) = 1;
DBMS_XDBZ.ValidateACL(ACL_ID);
IF DBMS_NETWORK_ACL_ADMIN.CHECK_PRIVILEGE(ACL_PATH, 'APEX_040000',
'connect') IS NULL THEN
DBMS_NETWORK_ACL_ADMIN.ADD_PRIVILEGE(ACL_PATH,
'APEX_040000', TRUE, 'connect');
END IF;
EXCEPTION
-- When no ACL has been assigned to '*'.
WHEN NO_DATA_FOUND THEN
DBMS_NETWORK_ACL_ADMIN.CREATE_ACL('power_users.xml',
'ACL that lets power users to connect to everywhere',
'APEX_040000', TRUE, 'connect');
DBMS_NETWORK_ACL_ADMIN.ASSIGN_ACL('power_users.xml','*');
END;

/

