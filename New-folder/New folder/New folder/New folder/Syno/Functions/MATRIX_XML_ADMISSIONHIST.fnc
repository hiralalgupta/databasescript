--------------------------------------------------------
--  DDL for Function MATRIX_XML_ADMISSIONHIST
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SNX_IWS2"."MATRIX_XML_ADMISSIONHIST" 
    (   P_CASEID  number   ,
        P_LF varchar2  ) 
    
    -- Created 10-6-2012 R Benzell
    -- called by GEN_MATRIX_XML

    
        RETURN CLOB
    
        IS
    

        v_Str CLOB;
        v_CaseId number;
        LF varchar2(5);
      
       
          
            BEGIN
                
      v_CaseId := P_CaseId;
      LF := P_LF;
        

-----------------------------------
v_Str := v_Str || '   <AdmissionHistory>' || LF;

v_Str := v_Str || '   <psychiatricAdmissions>' || LF;

v_Str := v_Str || '        <title>Psychiatric</title>'  || LF;

v_Str := v_Str || '          <admissions>' || LF;

v_Str := v_Str || '            <reasonForAdmission>' ||  Get_InfoPathData('Sig_Ill_Admin_History_Psych_Reason_1',v_CaseId,'ST') || '</reasonForAdmission>'  || LF;
v_Str := v_Str || '            <date>' ||  Get_InfoPathData('Sig_Ill_Admin_History_Psych_Date_1',v_CaseId,'DT') || '</date>'  || LF;

v_Str := v_Str || '          </admissions>' || LF;

--v_Str := v_Str || '            <reasonForAdmission>' ||  Get_InfoPathData('Sig_Ill_Admin_History_Psych_Reason_2',v_CaseId,'ST') || '</reasonForAdmission>'  || LF;
--v_Str := v_Str || '            <date>' ||  Get_InfoPathData('Sig_Ill_Admin_History_Psych_Date_2',v_CaseId,'ST') || '</date>'  || LF;

v_Str := v_Str || '   </psychiatricAdmissions>' || LF;
    
v_Str := v_Str || '   <rehabAdmissions>'    || LF;
    
v_Str := v_Str || '        <title>SNF/Rehab/Nursing Home</title>'  || LF;

v_Str := v_Str || '          <admissions>' || LF;

v_Str := v_Str || '            <reasonForAdmission>' ||  Get_InfoPathData('Sig_Ill_Admin_History_SNF_Reason_1',v_CaseId,'ST') || '</reasonForAdmission>'  || LF;
v_Str := v_Str || '            <date>' ||  Get_InfoPathData('Sig_Ill_Admin_History_SNF_Date_1',v_CaseId,'DT') || '</date>'  || LF;

v_Str := v_Str || '          </admissions>' || LF;

--v_Str := v_Str || '            <reasonForAdmission>' ||  Get_InfoPathData('Sig_Ill_Admin_History_SNF_Reason_2',v_CaseId,'ST') || '</reasonForAdmission>'  || LF;
--v_Str := v_Str || '            <date>' ||  Get_InfoPathData('Sig_Ill_Admin_History_SNF_Date_2',v_CaseId,'DT') || '</date>'  || LF;

v_Str := v_Str || '   </rehabAdmissions>'    || LF;

v_Str := v_Str || '   <medicalAdmissions>'    || LF;
    
v_Str := v_Str || '        <title>Medical (include nonsurgical fractures</title>'  || LF;

v_Str := v_Str || '          <admissions>' || LF;

v_Str := v_Str || '            <reasonForAdmission>' ||  Get_InfoPathData('Sig_Ill_Admin_History_Medical_Reason_1',v_CaseId,'ST') || '</reasonForAdmission>'  || LF;
v_Str := v_Str || '            <date>' ||  Get_InfoPathData('Sig_Ill_Admin_History_Medical_Date_1',v_CaseId,'DT') || '</date>'  || LF;

v_Str := v_Str || '          </admissions>' || LF;

v_Str := v_Str || '          <admissions>' || LF;

v_Str := v_Str || '            <reasonForAdmission>' ||  Get_InfoPathData('Sig_Ill_Admin_History_Medical_Reason_2',v_CaseId,'ST') || '</reasonForAdmission>'  || LF;
v_Str := v_Str || '            <date>' ||  Get_InfoPathData('Sig_Ill_Admin_History_Medical_Date_2',v_CaseId,'DT') || '</date>'  || LF;

v_Str := v_Str || '          </admissions>' || LF;

--v_Str := v_Str || '            <reasonForAdmission>' ||  Get_InfoPathData('Sig_Ill_Admin_History_Medical_Reason_3',v_CaseId,'ST') || '</reasonForAdmission>'  || LF;
--v_Str := v_Str || '            <date>' ||  Get_InfoPathData('Sig_Ill_Admin_History_Medical_Date_3',v_CaseId,'DT') || '</date>'  || LF;

v_Str := v_Str || '   </medicalAdmissions>'    || LF;

v_Str := v_Str || '   <surgeryAdmissions>'    || LF;

v_Str := v_Str || '        <title>Surgical (include fractures)</title>'  || LF;

v_Str := v_Str || '          <admissions>' || LF;

v_Str := v_Str || '            <reasonForAdmission>' ||  Get_InfoPathData('Sig_Ill_Admin_History_Surgical_Reason_1',v_CaseId,'ST') || '</reasonForAdmission>'  || LF;
v_Str := v_Str || '            <date>' ||  Get_InfoPathData('Sig_Ill_Admin_History_Surgical_Date_1',v_CaseId,'DT') || '</date>'  || LF;

v_Str := v_Str || '          </admissions>' || LF;

--v_Str := v_Str || '            <reasonForAdmission>' ||  Get_InfoPathData('Sig_Ill_Admin_History_Surgical_Reason_2',v_CaseId,'ST') || '</reasonForAdmission>'  || LF;
--v_Str := v_Str || '            <date>' ||  Get_InfoPathData('Sig_Ill_Admin_History_Surgical_Date_2',v_CaseId,'DT') || '</date>'  || LF;

--v_Str := v_Str || '            <reasonForAdmission>' ||  Get_InfoPathData('Sig_Ill_Admin_History_Surgical_Reason_3',v_CaseId,'ST') || '</reasonForAdmission>'  || LF;
--v_Str := v_Str || '            <date>' ||  Get_InfoPathData('Sig_Ill_Admin_History_Surgical_Date_3',v_CaseId,'DT') || '</date>'  || LF;

v_Str := v_Str || '   </surgeryAdmissions>'    || LF;

v_Str := v_Str || '   </AdmissionHistory>' || LF;


------------------------------------


       RETURN v_Str;
       
       EXCEPTION WHEN OTHERS THEN
            v_Str := SUBSTR(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
                              CHR(13) ||
                              SQLERRM,1,4000); 
           
       END;

/

