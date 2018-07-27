-- USER SQL
CREATE USER SNX_IWS2 IDENTIFIED BY "XXXXXX" 
DEFAULT TABLESPACE "SNX_IWS"
TEMPORARY TABLESPACE "TEMP";
-- QUOTAS
ALTER USER SNX_IWS2 QUOTA UNLIMITED ON SNX_IWS;
ALTER USER SNX_IWS2 QUOTA UNLIMITED ON SNX_IWS_INX;
-- ROLES
GRANT "RESOURCE" TO SNX_IWS2 ;
GRANT "CONNECT" TO SNX_IWS2 ;
-- SYSTEM PRIVILEGES
GRANT CREATE VIEW TO SNX_IWS2 ;
GRANT CREATE MATERIALIZED VIEW TO SNX_IWS2 ;
-- Object privileges
grant select on snx_ocs.docmeta to snx_iws2;
grant select on snx_ocs.documents to snx_iws2;
grant select on snx_ocs.filestorage to snx_iws2;
grant select on snx_ocs.revisions to snx_iws2;

-- SNX_BB2 user for blackbox
CREATE USER SNX_BB2 IDENTIFIED BY xxxxxx 
DEFAULT TABLESPACE "SNX_IWS"
TEMPORARY TABLESPACE "TEMP";
-- QUOTAS
ALTER USER SNX_BB2 QUOTA UNLIMITED ON SNX_IWS;
-- ROLES
GRANT "RESOURCE" TO SNX_BB2 ;
GRANT "CONNECT" TO SNX_BB2 ;
-- SYSTEM PRIVILEGES
GRANT CREATE VIEW TO SNX_BB2 ;
grant create synonym to SNX_BB2;
-- Object privileges
grant all on SNX_IWS2.auditlog to SNX_BB2;
grant all on SNX_IWS2.cases to SNX_BB2;
grant all on SNX_IWS2.errorlog to SNX_BB2;
grant all on SNX_IWS2.dpentries to SNX_BB2;
grant all on SNX_IWS2.CASEHISTORY to SNX_BB2;

grant select on SNX_IWS2.clients to SNX_BB2;
grant select on SNX_IWS2.pages to SNX_BB2;
grant select on SNX_IWS2.stages to SNX_BB2;
grant select on SNX_IWS2.medicalhierarchy to SNX_BB2;
grant select on SNX_IWS2.MEDICALHIERARCHY_LEAF_LEVEL_V to SNX_BB2;
grant select on SNX_IWS2.languages to SNX_BB2;
--synonyms
create synonym SNX_BB2.auditlog for SNX_IWS2.auditlog;
create synonym SNX_BB2.cases for SNX_IWS2.cases;
create synonym SNX_BB2.errorlog for SNX_IWS2.errorlog;
create synonym SNX_BB2.clients for SNX_IWS2.clients;
create synonym SNX_BB2.dpentries for SNX_IWS2.dpentries;
create synonym SNX_BB2.pages for SNX_IWS2.pages;
create synonym SNX_BB2.stages for SNX_IWS2.stages;
create synonym SNX_BB2.medicalhierarchy for SNX_IWS2.medicalhierarchy;
create synonym SNX_BB2.MEDICALHIERARCHY_LEAF_LEVEL_V for SNX_IWS2.MEDICALHIERARCHY_LEAF_LEVEL_V;
create synonym SNX_BB2.CASEHISTORY for SNX_IWS2.CASEHISTORY;
create synonym SNX_BB2.languages for SNX_IWS2.languages;
