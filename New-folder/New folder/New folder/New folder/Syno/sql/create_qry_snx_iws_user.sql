-- USER SQL
CREATE USER qry_snx_iws IDENTIFIED BY vagabond 
DEFAULT TABLESPACE "SNX_IWS"
TEMPORARY TABLESPACE "TEMP";
-- ROLES
GRANT "CONNECT" TO qry_snx_iws ;
-- Object Privileges
grant select on SNX_IWS2.CASES to qry_snx_iws;
grant select on SNX_IWS2.clients to qry_snx_iws;
grant select on SNX_IWS2.CASEHISTORYSUM to qry_snx_iws;
grant select on SNX_IWS2.stages to qry_snx_iws;
 

