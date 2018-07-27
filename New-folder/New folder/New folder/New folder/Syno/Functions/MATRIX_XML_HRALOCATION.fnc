--------------------------------------------------------
--  DDL for Function MATRIX_XML_HRALOCATION
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SNX_IWS2"."MATRIX_XML_HRALOCATION" (
      P_CASEID NUMBER ,
      P_LF     VARCHAR2)
    -- Created 10-6-2012 R Benzell
    -- typically called by GEN_MATRIX_XML
    -- select MATRIX_XML_HRALocation(1884,chr(10)) from dual
    -- Update History
    RETURN CLOB
  IS
    v_Str CLOB;
    v_CaseId NUMBER;
    LF       VARCHAR2(5);
  BEGIN
    v_CaseId := P_CaseId;
    LF       := P_LF;
    -----------------------------------
    v_Str := v_Str || ' <HRALocation>' || LF;

If Get_InfoPathData('HRA_Home',v_CaseId,'ST') is not null then
    v_Str := v_Str || '   <hraLocation>' ||  LF;
    v_Str := v_Str || '        <locationType>Home</locationType>' || LF;
    --v_Str := v_Str || '        <locationSubType>' || Get_InfoPathData('HRA_Home',v_CaseId,'ST') || '</locationSubType>' || LF;
    --v_Str := v_Str || '        <locationName>' || Get_InfoPathData('HRA_SNF_Name',v_CaseId,'ST') || '</locationName>' || LF;
    v_Str := v_Str || '   </hraLocation>' || LF;
end if;

If Get_InfoPathData('HRA_SNF_PAC',v_CaseId,'ST') is not null then
    v_Str := v_Str || '   <hraLocation>' ||  LF;
    v_Str := v_Str || '        <locationType>SNF</locationType>' || LF;
    v_Str := v_Str || '        <locationSubType>PAC</locationSubType>' || LF;
    v_Str := v_Str || '        <locationName>' || Get_InfoPathData('HRA_SNF_Name',v_CaseId,'ST') || '</locationName>' || LF;
    v_Str := v_Str || '   </hraLocation>' || LF;
end if;

If Get_InfoPathData('HRA_SNF_LTC',v_CaseId,'ST') is not null then
     v_Str := v_Str || '   <hraLocation>'  ||  LF;
    v_Str := v_Str || '        <locationType>SNF</locationType>' || LF;
    v_Str := v_Str || '        <locationSubType>LTC</locationSubType>' || LF;
    v_Str := v_Str || '        <locationName>' || Get_InfoPathData('HRA_SNF_Name',v_CaseId,'ST') || '</locationName>' || LF;
    v_Str := v_Str || '   </hraLocation>' || LF; 
end if;

if Get_InfoPathData('HRA_SNF_ESRD',v_CaseId,'ST') is not null then
     v_Str := v_Str || '   <hraLocation>'  || LF;
    v_Str := v_Str || '        <locationType>ESRD</locationType>' || LF;
--    v_Str := v_Str || '        <locationSubType>' || Get_InfoPathData('HRA_SNF_ESRD',v_CaseId,'ST') || '</locationSubType>' || LF;
--    v_Str := v_Str || '        <locationName>' || Get_InfoPathData('HRA_SNF_Name',v_CaseId,'ST') || '</locationName>' || LF;
     v_Str := v_Str || '   </hraLocation>' || LF;    
end if;

v_Str := v_Str || ' </HRALocation>' || LF;
    ---------
    RETURN v_Str;
  EXCEPTION
  WHEN OTHERS THEN
    v_Str := SUBSTR(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || CHR(13) || SQLERRM,1,4000);
  END;

/

