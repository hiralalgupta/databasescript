--------------------------------------------------------
--  DDL for Function MATRIX_XML_PATIENTINFO_NEW
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SNX_IWS2"."MATRIX_XML_PATIENTINFO_NEW" (
      P_CASEID NUMBER ,
      P_LF     VARCHAR2 )
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
    v_Str := v_Str || '<PatientInfo>' || LF;
    v_Str := v_Str || '   <patient>'  || LF;
    v_Str := v_Str || '        <patientId>' || Get_InfoPathData_new('Patient_First_Name + Patient_ID + Patient_First_Name + Summary_Member_Phone + Patient_Last_Name',v_CaseId,'ST') || '</patientId>' || LF;
    v_Str := v_Str || '        <firstName>' || Get_InfoPathData_new('Patient_First_Name',v_CaseId,'ST') || '</firstName>' || LF;
    v_Str := v_Str || '        <lastName>' || Get_InfoPathData_new('Patient_Last_Name',v_CaseId,'ST') || '</lastName>' || LF;
    v_Str := v_Str || '        <phone>' || Get_InfoPathData_new('Summary_Member_Phone',v_CaseId,'ST') || '</phone>' || LF;
    v_Str := v_Str || '        <address>'  || LF;
    v_Str := v_Str || '            <address1>' || Get_InfoPathData_new('Summary_Member_Address',v_CaseId,'ST') || '</address1>' || LF;
    v_Str := v_Str || '            <address2>' || Get_InfoPathData_new('',v_CaseId,'ST') || '</address2>' || LF;
    v_Str := v_Str || '            <city>' || Get_InfoPathData_new('',v_CaseId,'ST') || '</city>' || LF;
    v_Str := v_Str || '            <country>' || Get_InfoPathData_new('',v_CaseId,'ST') || '</country>' || LF;
    v_Str := v_Str || '            <state>' || Get_InfoPathData_new('',v_CaseId,'ST') || '</state>' || LF;
    v_Str := v_Str || '            <suite>' || Get_InfoPathData_new('Summary_Member_Address',v_CaseId,'ST') || '</suite>' || LF;
    v_Str := v_Str || '            <zipCode>' || Get_InfoPathData_new('Summary_Member_Address',v_CaseId,'ST') || '</zipCode>' || LF;
    v_Str := v_Str || '        </address>' || Lf;
    v_Str := v_Str || '        <dob>' || Get_InfoPathData_new('Patient_DOB',v_CaseId,'DT') || '</dob>' || LF;
    v_Str := v_Str || '        <gender>' || Get_InfoPathData_new('Patient_Gender_Female+Patient_Gender_Male',v_CaseId,'MF') || '</gender>' || LF;
    v_Str := v_Str || '        <primaryLanguage>' || Get_InfoPathData_new('Patient_Primary_Language',v_CaseId,'ST') || '</primaryLanguage>' || LF;
    v_Str := v_Str || '        <otherLanguage>' || Get_InfoPathData_new('Patient_Primary_Language',v_CaseId,'ST') || '</otherLanguage>' || LF;
    v_Str := v_Str || '        <planName>' || Get_InfoPathData_new('Plan_Name',v_CaseId,'ST') || '</planName>' || LF;
    v_Str := v_Str || '            <firstName>' || Get_InfoPathData_new('MI_Emergency_Contact_First_Name',v_CaseId,'ST') || '</firstName>' || LF;
    v_Str := v_Str || '            <lastName>' || Get_InfoPathData_new('MI_Emergency_Contact_Last_Name',v_CaseId,'ST') || '</lastName>' || LF;
    v_Str := v_Str || '            <phone>' || Get_InfoPathData_new('MI_Emergency_Contact_Phone',v_CaseId,'ST') || '</phone>' || LF;
    v_Str := v_Str || '            <relationship>' || Get_InfoPathData_new('MI_Emergency_Contact_Relationship',v_CaseId,'ST') || '</relationship>' || LF;
    v_Str := v_Str || '            <typeDesc>' || Get_InfoPathData_new('MI_Emergency_Contact_Relationship',v_CaseId,'ST') || '</typeDesc>' || LF;
    v_Str := v_Str || '            <firstName>' || Get_InfoPathData_new('MI_Healthcare_DPOA_First_Name',v_CaseId,'ST') || '</firstName>' || LF;
    v_Str := v_Str || '            <lastName>' || Get_InfoPathData_new('MI_Healthcare_DPOA_Last_Name',v_CaseId,'ST') || '</lastName>' || LF;
    v_Str := v_Str || '            <phone>' || Get_InfoPathData_new('MI_Healthcare_DPOA_Phone',v_CaseId,'ST') || '</phone>' || LF;
    v_Str := v_Str || '            <relationship>' || Get_InfoPathData_new('MI_Healthcare_DPOA_Relationship',v_CaseId,'ST') || '</relationship>' || LF;
    v_Str := v_Str || '            <typeDesc>' || Get_InfoPathData_new('MI_Healthcare_DPOA_Relationship',v_CaseId,'ST') || '</typeDesc>' || LF;
    v_Str := v_Str || '                  <title>Has Advance Directives</title>' || LF;
    v_Str := v_Str || '                  <value>' || Get_InfoPathData_new('MI_Has_Advanced_Directives',v_CaseId,'ST') || '</value>' || LF;
    v_Str := v_Str || '                  <title>Declines discussion of Advance Directives</title>' || LF;
    v_Str := v_Str || '                  <value>' || Get_InfoPathData_new('MI_Decline_Discussion_Adv_Directives',v_CaseId,'ST') || '</value>' || LF;
    v_Str := v_Str || '                  <title>POLST/MOLST</title>' || LF;
    v_Str := v_Str || '                  <value>' || Get_InfoPathData_new('MI_POLST_MOLST',v_CaseId,'ST') || '</value>' || LF;
    v_Str := v_Str || '                  <title>Living Will</title>' || LF;
    v_Str := v_Str || '                  <value>' || Get_InfoPathData_new('MI_Living_Will',v_CaseId,'ST') || '</value>' || LF;
    v_Str := v_Str || '                  <title>DNR</title>' || LF;
    v_Str := v_Str || '                  <value>' || Get_InfoPathData_new('MI_DNR',v_CaseId,'ST') || '</value>' || LF;
    v_Str := v_Str || '                  <title>DNR</title>' || LF;
    v_Str := v_Str || '                  <value>' || Get_InfoPathData_new('MI_Enrolled_Hospice',v_CaseId,'ST') || '</value>' || LF;
    v_Str := v_Str || '                  <title>DNR</title>' || LF;
    v_Str := v_Str || '                  <value>' || Get_InfoPathData_new('MI_Palliative_Care',v_CaseId,'ST') || '</value>' || LF;
    v_Str := v_Str || '   </patient>' || LF;
    v_Str := v_Str || '</PatientInfo>' || LF;
    ------------------------------------
    RETURN v_Str;
  EXCEPTION
  WHEN OTHERS THEN
    v_Str := SUBSTR(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || CHR(13) || SQLERRM,1,4000);
  END;

/

