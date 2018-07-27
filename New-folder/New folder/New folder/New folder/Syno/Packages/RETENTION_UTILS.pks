create or replace
PACKAGE RETENTION_UTILS AS

  procedure redact_phi_info;
  procedure Purge_file_fail(p_caseid in number, p_casefile VARCHAR2,p_status in number);
  procedure Purge_file_FG(p_fgcase in number, p_fgcasefile VARCHAR2,p_fgstatus in number);

END RETENTION_UTILS;