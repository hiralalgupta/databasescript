--------------------------------------------------------
--  DDL for Function MATRIX_XML_PATIENTINFO
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SNX_IWS2"."MATRIX_XML_PATIENTINFO" (
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
    v_Str := v_Str || '        <patientId>' || Get_InfoPathData('Patient_ID',v_CaseId,'ST') || '</patientId>' || LF;
    v_Str := v_Str || '        <firstName>' || Get_InfoPathData('Patient_First_Name',v_CaseId,'ST') || '</firstName>' || LF;
    v_Str := v_Str || '        <lastName>' || Get_InfoPathData('Patient_Last_Name',v_CaseId,'ST') || '</lastName>' || LF;
    v_Str := v_Str || '        <phone>' || Get_InfoPathData('Summary_Member_Phone',v_CaseId,'ST') || '</phone>' || LF;
    v_Str := v_Str || '        <address>'  || LF;
    v_Str := v_Str || '            <address1>' || Get_InfoPathData('Summary_Member_Address',v_CaseId,'ST') || '</address1>' || LF;
    v_Str := v_Str || '            <address2>' || Get_InfoPathData('',v_CaseId,'ST') || '</address2>' || LF;
    v_Str := v_Str || '            <city>' || Get_InfoPathData('',v_CaseId,'ST') || '</city>' || LF;
    v_Str := v_Str || '            <country>' || Get_InfoPathData('',v_CaseId,'ST') || '</country>' || LF;
    v_Str := v_Str || '            <state>' || Get_InfoPathData('',v_CaseId,'ST') || '</state>' || LF;
    v_Str := v_Str || '            <suite>' || Get_InfoPathData('',v_CaseId,'ST') || '</suite>' || LF;
    v_Str := v_Str || '            <zipCode>' || Get_InfoPathData('',v_CaseId,'ST') || '</zipCode>' || LF;
    v_Str := v_Str || '        </address>' || Lf;
    v_Str := v_Str || '        <dob>' || Get_InfoPathData('Patient_DOB',v_CaseId,'DT') || '</dob>' || LF;
    v_Str := v_Str || '        <gender>' || Get_InfoPathData('Patient_Gender_Male+Patient_Gender_Female',v_CaseId,'MF') || '</gender>' || LF;
    v_Str := v_Str || '        <primaryLanguage>' || Get_InfoPathData('Patient_Primary_Language',v_CaseId,'ST') || '</primaryLanguage>' || LF;
    v_Str := v_Str || '        <otherLanguage>' || Get_InfoPathData('Patient_Primary_Language',v_CaseId,'ST') || '</otherLanguage>' || LF;
    v_Str := v_Str || '        <planName>' || Get_InfoPathData('Plan_Name',v_CaseId,'ST') || '</planName>' || LF;
    v_Str := v_Str || '        <contacts>' || Lf;
    v_Str := v_Str || '            <firstName>' || Get_InfoPathData('MI_Emergency_Contact_First_Name',v_CaseId,'ST') || '</firstName>' || LF;
    v_Str := v_Str || '            <lastName>' || Get_InfoPathData('MI_Emergency_Contact_Last_Name',v_CaseId,'ST') || '</lastName>' || LF;
    v_Str := v_Str || '            <phone>' || Get_InfoPathData('MI_Emergency_Contact_Phone',v_CaseId,'ST') || '</phone>' || LF;
    v_Str := v_Str || '            <address>'  || LF;
    v_Str := v_Str || '              <address1>' || Get_InfoPathData('',v_CaseId,'ST') || '</address1>' || LF;
    v_Str := v_Str || '              <address2>' || Get_InfoPathData('',v_CaseId,'ST') || '</address2>' || LF;
    v_Str := v_Str || '              <city>' || Get_InfoPathData('',v_CaseId,'ST') || '</city>' || LF;
    v_Str := v_Str || '              <country>' || Get_InfoPathData('',v_CaseId,'ST') || '</country>' || LF;
    v_Str := v_Str || '              <state>' || Get_InfoPathData('',v_CaseId,'ST') || '</state>' || LF;
    v_Str := v_Str || '              <suite>' || Get_InfoPathData('',v_CaseId,'ST') || '</suite>' || LF;
    v_Str := v_Str || '              <zipCode>' || Get_InfoPathData('',v_CaseId,'ST') || '</zipCode>' || LF;
    v_Str := v_Str || '            </address>' || Lf;
    v_Str := v_Str || '            <contactType>EMERGENCY</contactType>'||lf;
    v_Str := v_Str || '            <relationship>' || Get_InfoPathData('MI_Emergency_Contact_Relationship',v_CaseId,'ST') || '</relationship>' || LF;
    v_Str := v_Str || '            <typeDesc>' || Get_InfoPathData('MI_Emergency_Contact_Relationship',v_CaseId,'ST') || '</typeDesc>' || LF;
    v_Str := v_Str || '        </contacts>' || Lf;   


    v_Str := v_Str || '        <contacts>' || Lf;
    v_Str := v_Str || '            <firstName>' || Get_InfoPathData('MI_Healthcare_DPOA_First_Name',v_CaseId,'ST') || '</firstName>' || LF;
    v_Str := v_Str || '            <lastName>' || Get_InfoPathData('MI_Healthcare_DPOA_Last_Name',v_CaseId,'ST') || '</lastName>' || LF;
    v_Str := v_Str || '            <phone>' || Get_InfoPathData('MI_Healthcare_DPOA_Phone',v_CaseId,'ST') || '</phone>' || LF;
    v_Str := v_Str || '          <address>'  || LF;
    v_Str := v_Str || '            <address1>' || Get_InfoPathData('',v_CaseId,'ST') || '</address1>' || LF;
    v_Str := v_Str || '            <address2>' || Get_InfoPathData('',v_CaseId,'ST') || '</address2>' || LF;
    v_Str := v_Str || '            <city>' || Get_InfoPathData('',v_CaseId,'ST') || '</city>' || LF;
    v_Str := v_Str || '            <country>' || Get_InfoPathData('',v_CaseId,'ST') || '</country>' || LF;
    v_Str := v_Str || '            <state>' || Get_InfoPathData('',v_CaseId,'ST') || '</state>' || LF;
    v_Str := v_Str || '            <suite>' || Get_InfoPathData('',v_CaseId,'ST') || '</suite>' || LF;
    v_Str := v_Str || '            <zipCode>' || Get_InfoPathData('',v_CaseId,'ST') || '</zipCode>' || LF;
    v_Str := v_Str || '          </address>' || Lf;
    v_Str := v_Str || '            <contactType>HEALTHCARE_PROXY</contactType>'||lf;
    v_Str := v_Str || '            <relationship>' || Get_InfoPathData('MI_Healthcare_DPOA_Relationship',v_CaseId,'ST') || '</relationship>' || LF;
    v_Str := v_Str || '            <typeDesc>' || Get_InfoPathData('MI_Healthcare_DPOA_Relationship',v_CaseId,'ST') || '</typeDesc>' || LF;
    v_Str := v_Str || '         </contacts>' || Lf; 


    v_Str := v_Str || '         <advanceDirective>' ||lf;
    v_Str := v_Str || '                 <exists>' ||lf;
    v_Str := v_Str || '                  <title>Has Advance Directives</title>' || LF;
    v_Str := v_Str || '                  <value>' || Get_InfoPathData('MI_Has_Advanced_Directives',v_CaseId,'TF') || '</value>' || LF;
    v_Str := v_Str || '                 </exists>' ||lf; 

    v_Str := v_Str || '                 <declinedDiscussion>' ||lf; 
    v_Str := v_Str || '                  <title>Declines discussion of Advance Directives</title>' || LF;
    v_Str := v_Str || '                  <value>' || Get_InfoPathData('MI_Decline_Discussion_Adv_Directives',v_CaseId,'TF') || '</value>' || LF;
    v_Str := v_Str || '                 </declinedDiscussion>' ||lf; 

    v_Str := v_Str || '             <polstMolstType>' || LF;
    v_Str := v_Str || '                  <title>POLST/MOLST</title>' || LF;
    v_Str := v_Str || '                  <value>' || Get_InfoPathData('MI_POLST_MOLST',v_CaseId,'TF') || '</value>' || LF;
    v_Str := v_Str || '             </polstMolstType>' || LF;    

     v_Str := v_Str || '             <livingWillType>' || LF;
    v_Str := v_Str || '                  <title>Living Will</title>' || LF;
    v_Str := v_Str || '                  <value>' || Get_InfoPathData('MI_Living_Will',v_CaseId,'TF') || '</value>' || LF;
    v_Str := v_Str || '               </livingWillType>' || LF;

    v_Str := v_Str || '                <dnrType>' || LF;
    v_Str := v_Str || '                  <title>DNR</title>' || LF;
    v_Str := v_Str || '                  <value>' || Get_InfoPathData('MI_DNR',v_CaseId,'TF') || '</value>' || LF;
    v_Str := v_Str || '                </dnrType>' || LF;
    
    v_Str := v_Str || '       </advanceDirective>' ||lf;

   v_Str := v_Str || '        <advanceIllness>' ||lf;
   v_Str := v_Str || '               <hospice>' ||lf;
   v_Str := v_Str || '                  <title>Enrolled in Hospice</title>' || LF;
   v_Str := v_Str || '                  <value>' || Get_InfoPathData('MI_Enrolled_Hospice',v_CaseId,'TF') || '</value>' || LF;
   v_Str := v_Str || '               </hospice>' ||lf;
    
    v_Str := v_Str || '              <palliative>' ||lf;    
    v_Str := v_Str || '                  <title>Enrolled in Palliative Care Program</title>' || LF;
    v_Str := v_Str || '                  <value>' || Get_InfoPathData('MI_Palliative_Care',v_CaseId,'TF') || '</value>' || LF;
    v_Str := v_Str || '              </palliative>' ||lf;    
    v_Str := v_Str || '        </advanceIllness>' ||lf;  
    v_Str := v_Str || ' </patient>' || LF;
    v_Str := v_Str || '</PatientInfo>' || LF;
    ------------------------------------
    RETURN v_Str;
  EXCEPTION
  WHEN OTHERS THEN
    v_Str := SUBSTR(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || CHR(13) || SQLERRM,1,4000);
  END;

/

