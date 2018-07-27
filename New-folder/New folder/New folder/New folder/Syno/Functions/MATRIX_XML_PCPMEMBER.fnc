--------------------------------------------------------
--  DDL for Function MATRIX_XML_PCPMEMBER
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SNX_IWS2"."MATRIX_XML_PCPMEMBER" (
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
    v_Str := v_Str || ' <PCPMember>' || LF;
    v_Str := v_Str || '   <person>' || Get_InfoPathData('MI_Palliative_Care',v_CaseId,'ST') || '</person>' || LF;
    v_Str := v_Str || '      <firstName>' || Get_InfoPathData('MI_First_Name',v_CaseId,'ST') || '</firstName>' || LF;
    v_Str := v_Str || '      <lastName>' || Get_InfoPathData('MI_Last_Name',v_CaseId,'ST') || '</lastName>' || LF;
    v_Str := v_Str || '      <phone>' || Get_InfoPathData('MI_Phone',v_CaseId,'ST') || '</phone>' || LF;
    v_Str := v_Str || '      <address>'  || LF;
    v_Str := v_Str || '        <address1>' || Get_InfoPathData('MI_Address_Street',v_CaseId,'ST') || '</address1>' || LF;
    v_Str := v_Str || '        <address2>' || Get_InfoPathData('',v_CaseId,'ST') || '</address2>' || LF;
    v_Str := v_Str || '        <city>' || Get_InfoPathData('MI_Address_City',v_CaseId,'ST') || '</city>' || LF;
    v_Str := v_Str || '        <country>' || Get_InfoPathData('',v_CaseId,'ST') || '</country>' || LF;
    v_Str := v_Str || '        <state>' || Get_InfoPathData('MI_Address_State',v_CaseId,'ST') || '</state>' || LF;
    v_Str := v_Str || '        <suite>' || Get_InfoPathData('MI_Address_Suite',v_CaseId,'ST') || '</suite>' || LF;
    v_Str := v_Str || '        <zipCode>' || Get_InfoPathData('MI_Address_Zip',v_CaseId,'ST') || '</zipCode>' || LF;
    v_Str := v_Str || '      </address>'  || LF;
    v_Str := v_Str || '      <contactType>PRIMARY</contactType>' || LF;
    v_Str := v_Str || '      <relationship>' || Get_InfoPathData('',v_CaseId,'ST') || '</relationship>' || LF;
    v_Str := v_Str || '      <typeDesc>' || Get_InfoPathData('',v_CaseId,'ST') || '</typeDesc>' || LF;
    v_Str := v_Str || ' </PCPMember>' || LF;
    ------------------------------------
    RETURN v_Str;
  EXCEPTION
  WHEN OTHERS THEN
    v_Str := SUBSTR(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || CHR(13) || SQLERRM,1,4000);
  END;

/

