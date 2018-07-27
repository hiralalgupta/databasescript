--------------------------------------------------------
--  DDL for Procedure GEN_MATRIX_XML_NEW
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "SNX_IWS2"."GEN_MATRIX_XML_NEW" 
  --- Copy a Snodex Table into a backup table with a specified BK suffix
  --- Updated 6-26-2011 - Log progress and time into EMR_REPLICATE_LOG
  /*
  begin
  GEN_MATRIX_XML(1884,chr(10)||chr(13));
  end;
  */
  (
    P_CASEID IN NUMBER DEFAULT 5000,
    p_LF     IN VARCHAR DEFAULT chr(
      10)||chr(
      13) )
AS
  v_Xml CLOB;
BEGIN
  v_Xml := '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>';
  v_Xml := v_xml || '<HealthRiskManagement>' || P_LF;
  v_Xml := v_Xml || MATRIX_XML_HRALOCATION(P_CASEID,P_LF);
  v_Xml := v_Xml || MATRIX_XML_PATIENTINFO(P_CASEID,P_LF);
  v_Xml := v_Xml || MATRIX_XML_PCPMEMBER(P_CASEID,P_LF);
  v_Xml := v_Xml || MATRIX_XML_PATIENTOBS(P_CASEID,P_LF);
  v_Xml := v_Xml || MATRIX_XML_INFOSOURCE(P_CASEID,P_LF);
  v_Xml := v_Xml || MATRIX_XML_MEDHISTORY(P_CASEID,P_LF);
  v_Xml := v_Xml || MATRIX_XML_ADMISSIONHIST(P_CASEID,P_LF);
  v_Xml := v_Xml || MATRIX_XML_HEALTHMAINT(P_CASEID,P_LF);
  v_Xml := v_Xml || MATRIX_XML_PERSANDSOC(P_CASEID,P_LF);
  v_Xml := v_Xml || MATRIX_XML_HEALTHBEHV(P_CASEID,P_LF);
  v_Xml := v_Xml || MATRIX_XML_FUNCSTATUS(P_CASEID,P_LF);
  v_Xml := v_Xml || MATRIX_XML_DEPRSCREEN(P_CASEID,P_LF);
  v_Xml := v_Xml || MATRIX_XML_FOCUSREVIEW(P_CASEID,P_LF);
  v_Xml := v_Xml || MATRIX_XML_PHYEXAM(P_CASEID,P_LF);
  v_Xml := v_Xml || MATRIX_XML_LABDATA(P_CASEID,P_LF);
  v_Xml := v_Xml || MATRIX_XML_DIABETICSCREEN(P_CASEID,P_LF);
  v_Xml := v_Xml || MATRIX_XML_NUTRIHEALTH(P_CASEID,P_LF);
  v_Xml := v_Xml || MATRIX_XML_NUTRIDIAG(P_CASEID,P_LF);
  v_Xml := v_Xml || MATRIX_XML_FALLRISK(P_CASEID,P_LF);
  v_Xml := v_Xml || MATRIX_XML_PROVASSMT(P_CASEID,P_LF);
  v_Xml := v_Xml || MATRIX_XML_SIGNATURE(P_CASEID,P_LF);
  v_Xml := v_Xml || MATRIX_XML_MGMTREFER(P_CASEID,P_LF);
  v_Xml := v_xml || '</HealthRiskManagement>' || P_LF;
  
  update xmltable set xmldata=v_Xml where id=P_CASEID;
  commit;
  --- Catch errors and show their line numbers
EXCEPTION
WHEN OTHERS THEN
  LOG_APEX_ERROR(16);
END;

/

