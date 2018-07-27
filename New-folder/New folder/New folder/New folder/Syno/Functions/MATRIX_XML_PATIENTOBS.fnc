--------------------------------------------------------
--  DDL for Function MATRIX_XML_PATIENTOBS
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SNX_IWS2"."MATRIX_XML_PATIENTOBS" (
      P_CASEID NUMBER DEFAULT 1884 ,
      P_LF     VARCHAR2 DEFAULT chr(
        10)||chr(
        13) )
    -- Created 10-6-2012 R Benzell
    -- called by ClientXMLgenerator
    -- Updated
    -- 10-13-2011 R Benzell
    -- to Test:  select XMLTEST1(1884) from dual
    RETURN CLOB
  IS
    v_Str CLOB;
    v_CaseId NUMBER;
    LF       VARCHAR2(5);
  BEGIN
    v_CaseId := P_CaseId;
    LF       := P_LF;
    -----------------------------------
    v_Str := v_Str || '<PatientObservation>' || LF;
    v_Str := v_Str || '  <observations>' || LF;
    v_Str := v_Str || '    <title>If SNF, reason for admission</title>' || LF;
    v_Str := v_Str || '    <value>' || Get_InfoPathData('PO_Reason_For_Admission',v_CaseId,'TF') || '</value>' || LF;
    v_Str := v_Str || '  </observations>' || LF;

    v_Str := v_Str || '  <observations>' || LF;
    v_Str := v_Str || '    <title>Appearance</title>' || LF;
    v_Str := v_Str || '    <value>' || Get_InfoPathData('PO_Appearance',v_CaseId,'TF') || '</value>' || LF;
    v_Str := v_Str || '  </observations>' || LF;

    v_Str := v_Str || '  <observations>' || LF;
    v_Str := v_Str || '    <title>Movement</title>' || LF;
    v_Str := v_Str || '    <value>' || Get_InfoPathData('PO_Movement',v_CaseId,'TF') || '</value>' || LF;
    v_Str := v_Str || '  </observations>' || LF;

    v_Str := v_Str || '  <observations>' || LF;
     v_Str := v_Str || '    <title>Posture</title>' || LF;
    v_Str := v_Str || '    <value>' || Get_InfoPathData('PO_Posture',v_CaseId,'TF') || '</value>' || LF;
    v_Str := v_Str || '  </observations>' || LF;

    v_Str := v_Str || '  <observations>' || LF;
     v_Str := v_Str || '    <title>Dress</title>' || LF;
    v_Str := v_Str || '    <value>' || Get_InfoPathData('PO_Dress',v_CaseId,'TF') || '</value>' || LF;
    v_Str := v_Str || '  </observations>' || LF;

    v_Str := v_Str || '  <observations>' || LF;
     v_Str := v_Str || '    <title>Grooming/Hygiene</title>' || LF;
    v_Str := v_Str || '    <value>' || Get_InfoPathData('PO_Grooming',v_CaseId,'TF') || '</value>' || LF;
    v_Str := v_Str || '  </observations>' || LF;

    v_Str := v_Str || '  <observations>' || LF;
     v_Str := v_Str || '    <title>Environment</title>' || LF;
    v_Str := v_Str || '    <value>' || Get_InfoPathData('PO_Environment',v_CaseId,'TF') || '</value>' || LF;
    v_Str := v_Str || '  </observations>' || LF;

    v_Str := v_Str || '  <observations>' || LF;
     v_Str := v_Str || '    <title>Safety</title>' || LF;
    v_Str := v_Str || '    <value>' || Get_InfoPathData('PO_Safety',v_CaseId,'TF') || '</value>' || LF;
    v_Str := v_Str || '  </observations>' || LF;

v_Str := v_Str || '</PatientObservation>' || LF;
    ------------------------------------
    RETURN v_Str;
  EXCEPTION
  WHEN OTHERS THEN
    v_Str := SUBSTR(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || CHR(13) || SQLERRM,1,4000);
  END;

/

