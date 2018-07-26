-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/12c/pdbs.sql
-- Author       : Tim Hall
-- Description  : Displays information about all PDBs in the current CDB.
-- Requirements : Access to the DBA views.
-- Call Syntax  : @pdbs
-- Last Modified: 18/12/2013
-- -----------------------------------------------------------------------------------

COLUMN pdb_name FORMAT A20

SELECT pdb_name, status
FROM   dba_pdbs
ORDER BY pdb_name;

SELECT name, open_mode
FROM   v$pdbs
ORDER BY name;
