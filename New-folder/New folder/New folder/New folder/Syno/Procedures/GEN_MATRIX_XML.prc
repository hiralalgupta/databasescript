--------------------------------------------------------
--  DDL for Procedure GEN_MATRIX_XML
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "SNX_IWS2"."GEN_MATRIX_XML" 
     --- Copy a Snodex Table into a backup table with a specified BK suffix
     --- Updated 6-26-2011 - Log progress and time into EMR_REPLICATE_LOG
/*
    begin
    GEN_MATRIX_XML(1884,chr(10)||chr(13));
    end;
*/
         (
          P_CASEID in number default 1884,
          p_LF in varchar default chr(10)||chr(13)
          )
         AS
 
     v_Xml CLOB; 
    
  BEGIN 
      htp.p('<pre>');
      htp.p('[?xml version="1.0" encoding="UTF-16" standalone="yes"?]');
      htp.p(debug_xml(MATRIX_XML_HRALOCATION(P_CASEID,P_LF))) ;
      htp.p(debug_xml(MATRIX_XML_PATIENTINFO(P_CASEID,P_LF)));
      htp.p(debug_xml(MATRIX_XML_PCPMEMBER(P_CASEID,P_LF)));
      htp.p(debug_xml(MATRIX_XML_PATIENTOBS(P_CASEID,P_LF)));

       htp.p(debug_xml( MATRIX_XML_INFOSOURCE(P_CASEID,P_LF)));
       htp.p(debug_xml(  MATRIX_XML_MEDHISTORY(P_CASEID,P_LF)));
       htp.p(debug_xml(  MATRIX_XML_ADMISSIONHIST(P_CASEID,P_LF)));
       htp.p(debug_xml(  MATRIX_XML_HEALTHMAINT(P_CASEID,P_LF)));
       htp.p(debug_xml(  MATRIX_XML_PERSANDSOC(P_CASEID,P_LF)));
       htp.p(debug_xml(  MATRIX_XML_HEALTHBEHV(P_CASEID,P_LF)));
       htp.p(debug_xml(  MATRIX_XML_FUNCSTATUS(P_CASEID,P_LF)));
       htp.p(debug_xml(  MATRIX_XML_DEPRSCREEN(P_CASEID,P_LF)));
       htp.p(debug_xml(  MATRIX_XML_FOCUSREVIEW(P_CASEID,P_LF)));
       htp.p(debug_xml(  MATRIX_XML_PHYEXAM(P_CASEID,P_LF)));
       htp.p(debug_xml(  MATRIX_XML_LABDATA(P_CASEID,P_LF)));
       htp.p(debug_xml(  MATRIX_XML_DIABETICSCREEN(P_CASEID,P_LF)));
       htp.p(debug_xml(  MATRIX_XML_NUTRIHEALTH(P_CASEID,P_LF)));
       htp.p(debug_xml(  MATRIX_XML_NUTRIDIAG(P_CASEID,P_LF)));
       htp.p(debug_xml(  MATRIX_XML_FALLRISK(P_CASEID,P_LF)));
       htp.p(debug_xml(  MATRIX_XML_PROVASSMT(P_CASEID,P_LF)));
       htp.p(debug_xml(  MATRIX_XML_SIGNATURE(P_CASEID,P_LF)));
       htp.p(debug_xml(  MATRIX_XML_MGMTREFER(P_CASEID,P_LF)));


      htp.p('--------');
      
        --- Catch errors and show their line numbers
    EXCEPTION WHEN OTHERS THEN LOG_APEX_ERROR(16);
   END;

/

