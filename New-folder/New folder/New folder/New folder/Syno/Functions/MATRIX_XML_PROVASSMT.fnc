--------------------------------------------------------
--  DDL for Function MATRIX_XML_PROVASSMT
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SNX_IWS2"."MATRIX_XML_PROVASSMT" (
      P_CASEID NUMBER ,
      P_LF     VARCHAR2 )
    -- Created 10-6-2012 R Benzell
    -- called by GEN_MATRIX_XML
    RETURN CLOB
  IS
    v_Str CLOB;
    v_CaseId NUMBER;
    LF       VARCHAR2(5);
  BEGIN
    v_CaseId := P_CaseId;
    LF       := P_LF;
    -----------------------------------
    v_Str := v_Str || '<ProviderAssessment>' || LF;
    /*
    v_Str := v_Str || '<ProviderAssessment>' ||  Get_InfoPathData('Medical_History_Diagnosis_1',v_CaseId,'ST') || '</ProviderAssessment>'  || LF;
    v_Str := v_Str || '<ProviderAssessment>'  || LF;
    v_Str := v_Str || '<ProviderAssessment>' ||  Get_InfoPathData('Active (A),Inactive(I), or Chronic (C)',v_CaseId,'ST') || '</ProviderAssessment>'  || LF;
    v_Str := v_Str || '<ProviderAssessment>' ||  Get_InfoPathData('Medical_History_Diagnosis_1_A+Medical_History_Diagnosis_1_I+Medical_History_Diagnosis_1_C',v_CaseId,'ST') || '</ProviderAssessment>'  || LF;
    v_Str := v_Str || '<ProviderAssessment>'  || LF;
    v_Str := v_Str || '<ProviderAssessment>' ||  Get_InfoPathData('Addendum_Add_Med_Diag_1',v_CaseId,'ST') || '</ProviderAssessment>'  || LF;
    v_Str := v_Str || '<ProviderAssessment>'  || LF;
    v_Str := v_Str || '<ProviderAssessment>' ||  Get_InfoPathData('Active (A),Inactive(I), or Chronic (C)',v_CaseId,'ST') || '</ProviderAssessment>'  || LF;
    v_Str := v_Str || '<ProviderAssessment>' ||  Get_InfoPathData('Addendum_Add_Med_Diag_1_A+Addendum_Add_Med_Diag_1_I+Addendum_Add_Med_Diag_1_C',v_CaseId,'ST') || '</ProviderAssessment>'  || LF;
    */
    v_Str := v_Str || '   <sectionTitle>Provider''s Assessment and Diagnosis of the Patient</sectionTitle>' || LF;
    v_Str := v_Str || '   <sections>'|| LF;
    v_Str := v_Str || '        <title>Cardiovascular</title>' || LF;
    v_Str := v_Str || '   <diagnosis>'|| LF;
    v_Str := v_Str || '    <title>Hypertension</title>' || LF;
    v_Str := v_Str || '    <value>' || Get_InfoPathData('PA_Cardio_Hypertension',v_CaseId,'TF') || '</value>' || LF;
    v_Str := v_Str || '        <followUpQuestions>'|| LF;
    v_Str := v_Str || '            <title>Type:</title>' || LF;
    v_Str := v_Str || '            <answer>' || Get_InfoPathData('PA_Cardio_Benign + PA_Cardio_Unspecified',v_CaseId,'ST') || '</answer>' || LF;
    v_Str := v_Str || '            <value>' || Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
    v_Str := v_Str || '        </followUpQuestions>'|| LF;
    v_Str := v_Str || '        <followUpQuestions>' || LF;
    v_Str := v_Str || '         <title>Heart Disease related to hypertension:</title>' || LF;
    v_Str := v_Str || '            <value>' || Get_InfoPathData('PA_Cardio_Heart_Disease',v_CaseId,'TF') || '</value>' || LF;
    v_Str := v_Str || '            <answer>' || Get_InfoPathData('PA_Cardio_With_Heart_Failure + PA_Cardio_Without_Heart_Failure',v_CaseId,'ST') || '</answer>' || LF;
    v_Str := v_Str || '        </followUpQuestions>'|| LF;
    v_Str := v_Str || '        <managementPlan>' || Get_InfoPathData('PA_Cardio_Plan_E1 
+ PA_Cardio_Plan_E2 
+ PA_Cardio_Plan_E3 
+ PA_Cardio_Plan_E4 
+ PA_Cardio_Plan_E5 
+ PA_Cardio_Plan_M1 
+ PA_Cardio_Plan_M2 
+ PA_Cardio_Plan_M3 
+ PA_Cardio_Plan_R1 
+ PA_Cardio_Plan_R2',v_CaseId,'MP') || '</managementPlan>' || LF;
    v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
    v_Str := v_Str || '    <title>Congestive Heart Failure</title>' || LF;
    v_Str := v_Str || '    <value>' || Get_InfoPathData('PA_Cardio_Congestive_Heart_Failure',v_CaseId,'TF') || '</value>' || LF;
    v_Str := v_Str || '    <title>Congestive Heart Failure</title>' || LF;
    v_Str := v_Str || '    <value>' || Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
    v_Str := v_Str || '        <managementPlan>' || Get_InfoPathData('PA_Cardio_Congestive_Heart_Failure_Plan_E1'                                                  
||'+ PA_Cardio_Congestive_Heart_Failure_Plan_E2'                                                  
||'+ PA_Cardio_Congestive_Heart_Failure_Plan_E3'                                                  
||'+ PA_Cardio_Congestive_Heart_Failure_Plan_E4'                                                  
||'+ PA_Cardio_Congestive_Heart_Failure_Plan_E5'                                                  
||'+ PA_Cardio_Congestive_Heart_Failure_Plan_M1'                                                  
||'+ PA_Cardio_Congestive_Heart_Failure_Plan_M2'                                                  
||'+ PA_Cardio_Congestive_Heart_Failure_Plan_M3'                                                  
||'+ PA_Cardio_Congestive_Heart_Failure_Plan_R1'                                                  
||'+ PA_Cardio_Congestive_Heart_Failure_Plan_R2',v_CaseId,'ST') ||
    '</managementPlan>' || LF;

    v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
    v_Str := v_Str || '    <title>Left Heart failure</title>' || LF;
    v_Str := v_Str || '    <value>' || Get_InfoPathData('PA_Cardio_Left_Heart_Failure',v_CaseId,'TF') || '</value>' || LF;
    v_Str := v_Str || '        <managementPlan>' || Get_InfoPathData('PA_Cardio_Left_Heart_Failure_Plan_E1'                                                  
||'+ PA_Cardio_Left_Heart_Failure_Plan_E2'                                                  
||'+ PA_Cardio_Left_Heart_Failure_Plan_E3'                                                  
||'+ PA_Cardio_Left_Heart_Failure_Plan_E4'                                                  
||'+ PA_Cardio_Left_Heart_Failure_Plan_E5'                                                  
||'+ PA_Cardio_Left_Heart_Failure_Plan_M1'                                                  
||'+ PA_Cardio_Left_Heart_Failure_Plan_M2'                                                  
||'+ PA_Cardio_Left_Heart_Failure_Plan_M3'                                                  
||'+ PA_Cardio_Left_Heart_Failure_Plan_R1'                                                  
||'+ PA_Cardio_Left_Heart_Failure_Plan_R2',v_CaseId,'MP') || '</managementPlan>' || LF;

    v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
    v_Str := v_Str || '        <title>Systolic Heart Failure</title>' || LF;
    v_Str := v_Str || '        <value>' || Get_InfoPathData(' PA_Cardio_Systolic_Heart_Failure ',v_CaseId,'TF') || '</value>' || LF;
    v_Str := v_Str || '        <managementPlan>' || Get_InfoPathData('PA_Cardio_Systolic_Heart_Failure_Plan_E1'                                                  
||'+ PA_Cardio_Systolic_Heart_Failure_Plan_E2'                                                  
||'+ PA_Cardio_Systolic_Heart_Failure_Plan_E3'                                                  
||'+ PA_Cardio_Systolic_Heart_Failure_Plan_E4'                                                  
||'+ PA_Cardio_Systolic_Heart_Failure_Plan_E5'                                                  
||'+ PA_Cardio_Systolic_Heart_Failure_Plan_M1'                                                  
||'+ PA_Cardio_Systolic_Heart_Failure_Plan_M2'                                                  
||'+ PA_Cardio_Systolic_Heart_Failure_Plan_M3'                                                  
||'+ PA_Cardio_Systolic_Heart_Failure_Plan_R1'                                                  
||'+ PA_Cardio_Systolic_Heart_Failure_Plan_R2',v_CaseId,'MP') || '</managementPlan>' || LF;
    v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
    v_Str := v_Str || '    <title>Diastolic Heart Failure</title>' || LF;
    v_Str := v_Str || '    <value>' || Get_InfoPathData('PA_Cardio_Diastolic_Heart_Failure',v_CaseId,'TF') || '</value>' || LF;
    v_Str := v_Str || '        <managementPlan>' || Get_InfoPathData('PA_Cardio_Diastolic_Heart_Failure_Plan_E1'                                                  
||'+ PA_Cardio_Diastolic_Heart_Failure_Plan_E2'                                                  
||'+ PA_Cardio_Diastolic_Heart_Failure_Plan_E3'                                                  
||'+ PA_Cardio_Diastolic_Heart_Failure_Plan_E4'                                                  
||'+ PA_Cardio_Diastolic_Heart_Failure_Plan_E5'                                                  
||'+ PA_Cardio_Diastolic_Heart_Failure_Plan_M1'                                                  
||'+ PA_Cardio_Diastolic_Heart_Failure_Plan_M2'                                                  
||'+ PA_Cardio_Diastolic_Heart_Failure_Plan_M3'                                                  
||'+ PA_Cardio_Diastolic_Heart_Failure_Plan_R1'                                                  
||'+ PA_Cardio_Diastolic_Heart_Failure_Plan_R2',v_CaseId,'MP') || '</managementPlan>' || LF;
    v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
    v_Str := v_Str || '    <title>Combined Systolic and Diastolic Heart Failure</title>' || LF;
    v_Str := v_Str || '    <value>' || Get_InfoPathData('PA_Cardio_Combined_Heart_Failure',v_CaseId,'TF') || '</value>' || LF;
    v_Str := v_Str || '        <managementPlan>' || Get_InfoPathData('PA_Cardio_Combined_Heart_Failure_Plan_E1'                                                  
||'+ PA_Cardio_Combined_Heart_Failure_Plan_E2'                                                  
||'+ PA_Cardio_Combined_Heart_Failure_Plan_E3'                                                  
||'+ PA_Cardio_Combined_Heart_Failure_Plan_E4'                                                  
||'+ PA_Cardio_Combined_Heart_Failure_Plan_E5'                                                  
||'+ PA_Cardio_Combined_Heart_Failure_Plan_M1'                                                  
||'+ PA_Cardio_Combined_Heart_Failure_Plan_M2'                                                  
||'+ PA_Cardio_Combined_Heart_Failure_Plan_M3'                                                  
||'+ PA_Cardio_Combined_Heart_Failure_Plan_R1'                                                  
||'+ PA_Cardio_Combined_Heart_Failure_Plan_R2',v_CaseId,'ST') || '</managementPlan>' ||    LF;
    v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
    v_Str := v_Str || '    <title>Cardiomyopathy</title>' || LF;
    v_Str := v_Str || '    <value>' || Get_InfoPathData('PA_Cardio_Cardiomyopathy',v_CaseId,'TF') || '</value>' || LF;
    v_Str := v_Str || '        <managementPlan>' || Get_InfoPathData('PA_Cardio_Cardiomyopathy_Plan_E1'                                                  
||'+ PA_Cardio_Cardiomyopathy_Plan_E2'                                                  
||'+ PA_Cardio_Cardiomyopathy_Plan_E3'                                                  
||'+ PA_Cardio_Cardiomyopathy_Plan_E4'                                                  
||'+ PA_Cardio_Cardiomyopathy_Plan_E5'                                                  
||'+ PA_Cardio_Cardiomyopathy_Plan_M1'                                                  
||'+ PA_Cardio_Cardiomyopathy_Plan_M2'                                                  
||'+ PA_Cardio_Cardiomyopathy_Plan_M3'                                                  
||'+ PA_Cardio_Cardiomyopathy_Plan_R1'                                                  
||'+ PA_Cardio_Cardiomyopathy_Plan_R2',v_CaseId,'MP') || '</managementPlan>' || LF;
    v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
    v_Str := v_Str || '    <title>Cardiomegaly</title>' || LF;
    v_Str := v_Str || '    <value>' || Get_InfoPathData('PA_Cardio_Cardiomegaly',v_CaseId,'TF') || '</value>' || LF;
    v_Str := v_Str || '        <managementPlan>' || Get_InfoPathData('PA_Cardio_Cardiomegaly_Plan_E1'                                                  
||'+ PA_Cardio_Cardiomegaly_Plan_E2'                                                  
||'+ PA_Cardio_Cardiomegaly_Plan_E3'                                                  
||'+ PA_Cardio_Cardiomegaly_Plan_E4'                                                  
||'+ PA_Cardio_Cardiomegaly_Plan_E5'                                                  
||'+ PA_Cardio_Cardiomegaly_Plan_M1'                                                  
||'+ PA_Cardio_Cardiomegaly_Plan_M2'                                                  
||'+ PA_Cardio_Cardiomegaly_Plan_M3'                                                  
||'+ PA_Cardio_Cardiomegaly_Plan_R1'                                                  
||'+ PA_Cardio_Cardiomegaly_Plan_R2',v_CaseId,'MP') || '</managementPlan>' || LF;

    v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
    v_Str := v_Str || '    <title>Edema (current only)</title>' || LF;
    v_Str := v_Str || '    <value>' || Get_InfoPathData('PA_Cardio_Edema',v_CaseId,'TF') || '</value>' || LF;
    v_Str := v_Str || '        <managementPlan>' || Get_InfoPathData('PA_Cardio_Edema_Plan_E1'                                                  
||'+ PA_Cardio_Edema_Plan_E2'                                                  
||'+ PA_Cardio_Edema_Plan_E3'                                                  
||'+ PA_Cardio_Edema_Plan_E4'                                                  
||'+ PA_Cardio_Edema_Plan_E5'                                                  
||'+ PA_Cardio_Edema_Plan_M1'                                                  
||'+ PA_Cardio_Edema_Plan_M2'                                                  
||'+ PA_Cardio_Edema_Plan_M3'                                                  
||'+ PA_Cardio_Edema_Plan_R1'                                                  
||'+ PA_Cardio_Edema_Plan_R2',v_CaseId,'MP') || '</managementPlan>' || LF;

    v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
    v_Str := v_Str || '    <title>Hypotension</title>' || LF;
    v_Str := v_Str || '    <value>' || Get_InfoPathData('PA_Cardio_Hypotension',v_CaseId,'TF') || '</value>' || LF;
    v_Str := v_Str || '        <followUpQuestions>' || LF;
    v_Str := v_Str || '         <title>Type:</title>' || LF;
    v_Str := v_Str || '         <value>' || Get_InfoPathData('PA_Cardio_Hypotension_Chronic',v_CaseId,'ST') || '</value>' || LF;
    v_Str := v_Str || '            <answer>' || Get_InfoPathData('PA_Cardio_Hypotension_Chronic',v_CaseId,'ST') || '</answer>' || LF;
    v_Str := v_Str || '        </followUpQuestions>'|| LF;
    v_Str := v_Str || '        <followUpQuestions>' || LF;
    v_Str := v_Str || '         <title>Type:</title>' || LF;
    v_Str := v_Str || '         <value>' || Get_InfoPathData('PA_Cardio_Hypotension_Orthostatic',v_CaseId,'ST') || '</value>' || LF;
    v_Str := v_Str || '            <answer>' || Get_InfoPathData('PA_Cardio_Hypotension_Orthostatic',v_CaseId,'ST') || '</answer>' || LF;
    v_Str := v_Str || '        </followUpQuestions>'|| LF;
    v_Str := v_Str || '        <managementPlan>' || Get_InfoPathData('PA_Cardio_Hypotension_Plan_E1'                                                  
||'+ PA_Cardio_Hypotension_Plan_E2'                                                  
||'+ PA_Cardio_Hypotension_Plan_E3'                                                  
||'+ PA_Cardio_Hypotension_Plan_E4'                                                  
||'+ PA_Cardio_Hypotension_Plan_E5'                                                  
||'+ PA_Cardio_Hypotension_Plan_M1'                                                  
||'+ PA_Cardio_Hypotension_Plan_M2'                                                  
||'+ PA_Cardio_Hypotension_Plan_M3'                                                  
||'+ PA_Cardio_Hypotension_Plan_R1'                                                  
||'+ PA_Cardio_Hypotension_Plan_R2',v_CaseId,'MP') || '</managementPlan>' || LF;

    v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
    v_Str := v_Str || '    <title>Syncope</title>' || LF;
    v_Str := v_Str || '    <value>' || Get_InfoPathData('PA_Cardio_Syncope',v_CaseId,'TF') || '</value>' || LF;
    v_Str := v_Str || '        <managementPlan>' || Get_InfoPathData('PA_Cardio_Syncope_Plan_E1'                                                  
||'+ PA_Cardio_Syncope_Plan_E2'                                                  
||'+ PA_Cardio_Syncope_Plan_E3'                                                  
||'+ PA_Cardio_Syncope_Plan_E4'                                                  
||'+ PA_Cardio_Syncope_Plan_E5'                                                  
||'+ PA_Cardio_Syncope_Plan_M1'                                                  
||'+ PA_Cardio_Syncope_Plan_M2'                                                  
||'+ PA_Cardio_Syncope_Plan_M3'                                                  
||'+ PA_Cardio_Syncope_Plan_R1'                                                  
||'+ PA_Cardio_Syncope_Plan_R2',v_CaseId,'MP') || '</managementPlan>' || LF;

    v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
    v_Str := v_Str || '        <title>Arrhythmia</title>' || LF;
    v_Str := v_Str || '        <value>' || Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
    v_Str := v_Str || '        <followUpQuestions>' || LF;
    v_Str := v_Str || '         <title>Arrhythmia Type:</title>' || LF;
    --- check below line
    v_Str := v_Str || '         <value>' || Get_InfoPathData('PA_Cardio_Arrhythmia_Atrial_Fibrillation + PA_Cardio_Arrhythmia_Supraventricular_Tachycardia + PA_Cardio_Sick_Sinus_Syndrome',v_CaseId,'ST') || '</value>' || LF;
    v_Str := v_Str || '            <answer>' || Get_InfoPathData('PA_Cardio_Arrhythmia_Atrial_Fibrillation + PA_Cardio_Arrhythmia_Supraventricular_Tachycardia + PA_Cardio_Sick_Sinus_Syndrome',v_CaseId,'ST') || '</answer>' || LF;
    v_Str := v_Str || '            <otherValue>' || Get_InfoPathData('',v_CaseId,'ST') || '</otherValue>' || LF;
    v_Str := v_Str || '        </followUpQuestions>'|| LF;
    v_Str := v_Str || '        <followUpQuestions>' || LF;
    v_Str := v_Str || '         <title>Arrhythmia Type:</title>' || LF;
    v_Str := v_Str || '         <value>' || Get_InfoPathData('PA_Cardio_Arrhythmia_Other',v_CaseId,'TF') || '</value>' || LF;
    v_Str := v_Str || '            <answer>' || 'Other' || '</answer>' || LF;
    v_Str := v_Str || '            <otherValue>' || Get_InfoPathData('PA_Cardio_Arrhythmia_Other_Box',v_CaseId,'ST') || '</otherValue>' || LF;
    v_Str := v_Str || '        </followUpQuestions>'|| LF;
    v_Str := v_Str || '        <managementPlan>' || Get_InfoPathData('PA_Cardio_Arrhythmia_Plan_E1'                                                  
||'+ PA_Cardio_Arrhythmia_Plan_E2'                                                  
||'+ PA_Cardio_Arrhythmia_Plan_E3'                                                  
||'+ PA_Cardio_Arrhythmia_Plan_E4'                                                  
||'+ PA_Cardio_Arrhythmia_Plan_E5'                                                  
||'+ PA_Cardio_Arrhythmia_Plan_M1'                                                  
||'+ PA_Cardio_Arrhythmia_Plan_M2'                                                  
||'+ PA_Cardio_Arrhythmia_Plan_M3'                                                  
||'+ PA_Cardio_Arrhythmia_Plan_R1'                                                  
||'+ PA_Cardio_Arrhythmia_Plan_R2',v_CaseId,'MP') || '</managementPlan>' || LF;
    v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
    v_Str := v_Str || '    <title>Ventricular Tachycardia</title>' || LF;
    v_Str := v_Str || '    <value>' || Get_InfoPathData('PA_Cardio_Ventricular_Tachycardia',v_CaseId,'TF') || '</value>' || LF;
    v_Str := v_Str || '        <managementPlan>' || Get_InfoPathData('PA_Cardio_Ventricular_Tachycardia_Plan_E1'                                                  
||'+ PA_Cardio_Ventricular_Tachycardia_Plan_E2'                                                  
||'+ PA_Cardio_Ventricular_Tachycardia_Plan_E3'                                                  
||'+ PA_Cardio_Ventricular_Tachycardia_Plan_E4'                                                  
||'+ PA_Cardio_Ventricular_Tachycardia_Plan_E5'                                                  
||'+ PA_Cardio_Ventricular_Tachycardia_Plan_M1'                                                  
||'+ PA_Cardio_Ventricular_Tachycardia_Plan_M2'                                                  
||'+ PA_Cardio_Ventricular_Tachycardia_Plan_M3'                                                  
||'+ PA_Cardio_Ventricular_Tachycardia_Plan_R1'                                                  
||'+ PA_Cardio_Ventricular_Tachycardia_Plan_R2',v_CaseId,'MP') || '</managementPlan>' || LF;
    v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
    v_Str := v_Str || '    <title>Pacemaker</title>' || LF;
    v_Str := v_Str || '    <value>' || Get_InfoPathData('PA_Cardio_Pacemaker',v_CaseId,'TF') || '</value>' || LF;
    v_Str := v_Str || '        <followUpQuestions>' || LF;
    v_Str := v_Str || '         <title>Specify Arryhthmia:</title>' || LF;
    v_Str := v_Str || '         <value>' || Get_InfoPathData('PA_Cardio_Pacemaker_Box',v_CaseId,'ST') || '</value>' || LF;
    v_Str := v_Str || '            <answer>' || 'Other' || '</answer>' || LF;
    v_Str := v_Str || '            <otherValue>' || Get_InfoPathData('PA_Cardio_Pacemaker_Box',v_CaseId,'ST') || '</otherValue>' || LF;
    v_Str := v_Str || '        </followUpQuestions>'|| LF;
    v_Str := v_Str || '        <managementPlan>' || Get_InfoPathData('PA_Cardio_Pacemaker_Plan_E1'                                                  
||'+ PA_Cardio_Pacemaker_Plan_E2'                                                  
||'+ PA_Cardio_Pacemaker_Plan_E3'                                                  
||'+ PA_Cardio_Pacemaker_Plan_E4'                                                  
||'+ PA_Cardio_Pacemaker_Plan_E5'                                                  
||'+ PA_Cardio_Pacemaker_Plan_M1'                                                  
||'+ PA_Cardio_Pacemaker_Plan_M2'                                                  
||'+ PA_Cardio_Pacemaker_Plan_M3'                                                  
||'+ PA_Cardio_Pacemaker_Plan_R1'                                                  
||'+ PA_Cardio_Pacemaker_Plan_R2',v_CaseId,'MP') || '</managementPlan>' || LF;
    v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
    v_Str := v_Str || '    <title>Defibrillator/AICD</title>' || LF;
    v_Str := v_Str || '    <value>' || Get_InfoPathData('PA_Cardio_Defibrillator',v_CaseId,'TF') || '</value>' || LF;
    v_Str := v_Str || '        <followUpQuestions>' || LF;
    v_Str := v_Str || '         <title>Specify Reason:</title>' || LF;
    v_Str := v_Str || '         <value>' || Get_InfoPathData('PA_Cardio_Defibrillator_Box',v_CaseId,'ST') || '</value>' || LF;
    v_Str := v_Str || '            <answer>' || 'Other' || '</answer>' || LF;
    v_Str := v_Str || '            <otherValue>' || Get_InfoPathData('PA_Cardio_Defibrillator_Box',v_CaseId,'ST') || '</otherValue>' || LF;
    v_Str := v_Str || '        </followUpQuestions>'|| LF;
    v_Str := v_Str || '        <managementPlan>' || Get_InfoPathData('PA_Cardio_Defibrillator_Plan_E1'                                                  
||'+ PA_Cardio_Defibrillator_Plan_E2'                                                  
||'+ PA_Cardio_Defibrillator_Plan_E3'                                                  
||'+ PA_Cardio_Defibrillator_Plan_E4'                                                  
||'+ PA_Cardio_Defibrillator_Plan_E5'                                                  
||'+ PA_Cardio_Defibrillator_Plan_M1'                                                  
||'+ PA_Cardio_Defibrillator_Plan_M2'                                                  
||'+ PA_Cardio_Defibrillator_Plan_M3'                                                  
||'+ PA_Cardio_Defibrillator_Plan_R1'                                                  
||'+ PA_Cardio_Defibrillator_Plan_R2',v_CaseId,'MP') || '</managementPlan>' || LF;

    v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
    v_Str := v_Str || '    <title>Coronary Artery Disease (CAD)</title>' || LF;
    v_Str := v_Str || '    <value>' || Get_InfoPathData('PA_Cardio_CAD',v_CaseId,'TF') || '</value>' || LF;
    v_Str := v_Str || '        <managementPlan>' || Get_InfoPathData('PA_Cardio_CAD_Plan_E1'                                                  
||'+ PA_Cardio_CAD_Plan_E2'                                                  
||'+ PA_Cardio_CAD_Plan_E3'                                                  
||'+ PA_Cardio_CAD_Plan_E4'                                                  
||'+ PA_Cardio_CAD_Plan_E5'                                                  
||'+ PA_Cardio_CAD_Plan_M1'                                                  
||'+ PA_Cardio_CAD_Plan_M2'                                                  
||'+ PA_Cardio_CAD_Plan_M3'                                                  
||'+ PA_Cardio_CAD_Plan_R1'                                                  
||'+ PA_Cardio_CAD_Plan_R2',v_CaseId,'MP') || '</managementPlan>' || LF;

    v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
    v_Str := v_Str || '    <title>Old Myocardial Infarction(>8 weeks old)</title>' || LF;
    v_Str := v_Str || '    <value>' || Get_InfoPathData('PA_Cardio_Old_Myocardial_Infarction',v_CaseId,'TF') || '</value>' || LF;
    v_Str := v_Str || '        <managementPlan>' || Get_InfoPathData('PA_Cardio_Old_Myocardial_Infarction_Plan_E1                                                  
+ PA_Cardio_Old_Myocardial_Infarction_Plan_E2                                                  
+ PA_Cardio_Old_Myocardial_Infarction_Plan_E3                                                  
+ PA_Cardio_Old_Myocardial_Infarction_Plan_E4                                                  
+ PA_Cardio_Old_Myocardial_Infarction_Plan_E5                                                  
+ PA_Cardio_Old_Myocardial_Infarction_Plan_M1                                                  
+ PA_Cardio_Old_Myocardial_Infarction_Plan_M2                                                  
+ PA_Cardio_Old_Myocardial_Infarction_Plan_M3                                                  
+ PA_Cardio_Old_Myocardial_Infarction_Plan_R1                                                  
+ PA_Cardio_Old_Myocardial_Infarction_Plan_R2',v_CaseId,    'ST') || '</managementPlan>' || LF;

    v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
    v_Str := v_Str || '    <title>Recent Myocardial Infarction (&amp;lt; 8 weeks old)</title>' || LF;
    v_Str := v_Str || '    <value>' || Get_InfoPathData('PA_Cardio_Recent_Myocardial_Infarction',v_CaseId,'TF') || '</value>' || LF;
    v_Str := v_Str || '        <managementPlan>' || Get_InfoPathData('PA_Cardio_Recent_Myocardial_Infarction_Plan_E1                                                  
+ PA_Cardio_Recent_Myocardial_Infarction_Plan_E2                                                  
+ PA_Cardio_Recent_Myocardial_Infarction_Plan_E3                                                  
+ PA_Cardio_Recent_Myocardial_Infarction_Plan_E4                                                  
+ PA_Cardio_Recent_Myocardial_Infarction_Plan_E5                                                  
+ PA_Cardio_Recent_Myocardial_Infarction_Plan_M1                                                  
+ PA_Cardio_Recent_Myocardial_Infarction_Plan_M2                                                  
+ PA_Cardio_Recent_Myocardial_Infarction_Plan_M3                                                  
+ PA_Cardio_Recent_Myocardial_Infarction_Plan_R1                                                  
+ PA_Cardio_Recent_Myocardial_Infarction_Plan_R2',v_CaseId,'MP') || '</managementPlan>' || LF;

    v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
    v_Str := v_Str || '    <title>Angina (active or chronic  on medication)</title>' || LF;
    v_Str := v_Str || '    <value>' || Get_InfoPathData('PA_Cardio_Angina',v_CaseId,'TF') || '</value>' || LF;
    v_Str := v_Str || '        <managementPlan>' || Get_InfoPathData('PA_Cardio_Angina_Plan_E1                                                  
+ PA_Cardio_Angina_Plan_E2                                                  
+ PA_Cardio_Angina_Plan_E3                                                  
+ PA_Cardio_Angina_Plan_E4                                                  
+ PA_Cardio_Angina_Plan_E5                                                  
+ PA_Cardio_Angina_Plan_M1                                                  
+ PA_Cardio_Angina_Plan_M2                                                  
+ PA_Cardio_Angina_Plan_M3                                                  
+ PA_Cardio_Angina_Plan_R1                                                  
+ PA_Cardio_Angina_Plan_R2',v_CaseId,'MP') || '</managementPlan>' || LF;

    v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
    v_Str := v_Str || '    <title>Angina (inactive  not on meds  no cardiac chest pain symptoms)</title>' || LF;
    v_Str := v_Str || '    <value>' || Get_InfoPathData('PA_Cardio_Angina_Inactive',v_CaseId,'TF') || '</value>' || LF;
    v_Str := v_Str || '        <managementPlan>' || Get_InfoPathData('PA_Cardio_Angina_Inactive_Plan_E1                                                  
+ PA_Cardio_Angina_Inactive_Plan_E2                                                  
+ PA_Cardio_Angina_Inactive_Plan_E3                                                  
+ PA_Cardio_Angina_Inactive_Plan_E4                                                  
+ PA_Cardio_Angina_Inactive_Plan_E5                                                  
+ PA_Cardio_Angina_Inactive_Plan_M1                                                  
+ PA_Cardio_Angina_Inactive_Plan_M2                                                  
+ PA_Cardio_Angina_Inactive_Plan_M3                                                  
+ PA_Cardio_Angina_Inactive_Plan_R1                                                  
+ PA_Cardio_Angina_Inactive_Plan_R2',v_CaseId,'MP') || '</managementPlan>' || LF;

    v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
    v_Str := v_Str || '    <title>History of CABG (or S/P CABG)</title>' || LF;
    v_Str := v_Str || '    <value>' || Get_InfoPathData('PA_Cardio_CABG',v_CaseId,'TF') || '</value>' || LF;
    v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
    v_Str := v_Str || '    <title>History of PTCA (or stent)</title>' || LF;
    v_Str := v_Str || '    <value>' || Get_InfoPathData('PA_Cardio_PTCA',v_CaseId,'TF') || '</value>' || LF;
    v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
    v_Str := v_Str || '    <title>Peripheral Vascular Disease (PVD) (peripheral arterial disease)</title>' || LF;
    v_Str := v_Str || '    <value>' || Get_InfoPathData('PA_Cardio_PVD',v_CaseId,'TF') || '</value>' || LF;
    v_Str := v_Str || '        <managementPlan>' || Get_InfoPathData('PA_Cardio_PVD_E1                                                  
+ PA_Cardio_PVD_E2                                                  
+ PA_Cardio_PVD_E3                                                  
+ PA_Cardio_PVD_E4                                                  
+ PA_Cardio_PVD_E5                                                  
+ PA_Cardio_PVD_M1                                                  
+ PA_Cardio_PVD_M2                                                  
+ PA_Cardio_PVD_M3                                                  
+ PA_Cardio_PVD_R1                                                  
+ PA_Cardio_PVD_R2',v_CaseId,'MP') || '</managementPlan>' || LF;

    v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
    v_Str := v_Str || '        <title>Atherosclerosis of Extremities:</title>' || LF;
    v_Str := v_Str || '        <value>' || Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
    v_Str := v_Str || '        <followUpQuestions>' || LF;
    v_Str := v_Str || '            <title>Type:</title>' || LF;
    v_Str := v_Str || '            <answer>' || Get_InfoPathData('PA_Cardio_Atherosclerosis_Asymptomatic',v_CaseId,'ST') || '</answer>' || LF;
    v_Str := v_Str || '            <value>' || Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
    v_Str := v_Str || '        </followUpQuestions>'|| LF;
    v_Str := v_Str || '        <followUpQuestions>' || LF;
    v_Str := v_Str || '            <title>Type:</title>' || LF;
    v_Str := v_Str || '            <answer>' || Get_InfoPathData('PA_Cardio_Atherosclerosis_Claudication 
 +PA_Cardio_Atherosclerosis_Gangrene 
 +PA_Cardio_Atherosclerosis_Rest_Pain 
 +PA_Cardio_Atherosclerosis_Ulceration 
 +PA_Cardio_Atherosclerosis_Amputation',v_CaseId,'MP') || '</answer>' || LF;
    v_Str := v_Str || '            <value>' || Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
    v_Str := v_Str || '        </followUpQuestions>'|| LF;
    v_Str := v_Str || '        <managementPlan>' || Get_InfoPathData('PA_Cardio_Atherosclerosis_Extrem_Plan_E1                                                  
+ PA_Cardio_Atherosclerosis_Extrem_Plan_E2                                                  
+ PA_Cardio_Atherosclerosis_Extrem_Plan_E3                                                  
+ PA_Cardio_Atherosclerosis_Extrem_Plan_E4                                                  
+ PA_Cardio_Atherosclerosis_Extrem_Plan_E5                                                  
+ PA_Cardio_Atherosclerosis_Extrem_Plan_M1                                                  
+ PA_Cardio_Atherosclerosis_Extrem_Plan_M2                                                  
+ PA_Cardio_Atherosclerosis_Extrem_Plan_M3                                                  
+ PA_Cardio_Atherosclerosis_Extrem_Plan_R1                                                  
+ PA_Cardio_Atherosclerosis_Extrem_Plan_R2',v_CaseId,'ST') || '</managementPlan>' ||    LF;

    v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
    v_Str := v_Str || '    <title>Atherosclerosis of</title>' || LF;
    v_Str := v_Str || '    <value>' || Get_InfoPathData('PA_Cardio_Atherosclerosis',v_CaseId,'TF') || '</value>' || LF;
    v_Str := v_Str || '   <subDiagnosis>' || Get_InfoPathData('',v_CaseId,'ST') || '</subDiagnosis>' || LF;
    v_Str := v_Str || '    <title>Aorta</title>' || LF;
    v_Str := v_Str || '    <value>' || Get_InfoPathData('PA_Cardio_Atherosclerosis_Aorta',v_CaseId,'TF') || '</value>' || LF;
    v_Str := v_Str || '        <managementPlan>' || Get_InfoPathData('PA_Cardio_Atherosclerosis_Plan_E1                                                  
+ PA_Cardio_Atherosclerosis_Plan_E2                                                  
+ PA_Cardio_Atherosclerosis_Plan_E3                                                  
+ PA_Cardio_Atherosclerosis_Plan_E4                                                  
+ PA_Cardio_Atherosclerosis_Plan_E5                                                  
+ PA_Cardio_Atherosclerosis_Plan_M1                                                  
+ PA_Cardio_Atherosclerosis_Plan_M2                                                  
+ PA_Cardio_Atherosclerosis_Plan_M3                                                  
+ PA_Cardio_Atherosclerosis_Plan_R1                                                  
+ PA_Cardio_Atherosclerosis_Plan_R2',v_CaseId,'MP') || '</managementPlan>' || LF;

    v_Str := v_Str || '   <subDiagnosis>' || Get_InfoPathData('',v_CaseId,'ST') || '</subDiagnosis>' || LF;
    v_Str := v_Str || '    <title>Renal Artery</title>' || LF;
    v_Str := v_Str || '    <value>' || Get_InfoPathData('PA_Cardio_Atherosclerosis_Renal_Artery',v_CaseId,'TF') || '</value>' || LF;
    v_Str := v_Str || '        <managementPlan>' || Get_InfoPathData('PA_Cardio_Atherosclerosis_Plan_E1                                                  
+ PA_Cardio_Atherosclerosis_Plan_E2                                                  
+ PA_Cardio_Atherosclerosis_Plan_E3                                                  
+ PA_Cardio_Atherosclerosis_Plan_E4                                                  
+ PA_Cardio_Atherosclerosis_Plan_E5                                                  
+ PA_Cardio_Atherosclerosis_Plan_M1                                                  
+ PA_Cardio_Atherosclerosis_Plan_M2                                                  
+ PA_Cardio_Atherosclerosis_Plan_M3                                                  
+ PA_Cardio_Atherosclerosis_Plan_R1                                                  
+ PA_Cardio_Atherosclerosis_Plan_R2',v_CaseId,'MP') || '</managementPlan>' || LF;

    v_Str := v_Str || '   <subDiagnosis>' || Get_InfoPathData('',v_CaseId,'ST') || '</subDiagnosis>' || LF;
    v_Str := v_Str || '    <title>Carotid Artery</title>' || LF;
    v_Str := v_Str || '    <value>' || Get_InfoPathData('PA_Cardio_Atherosclerosis_Carotid_Artery',v_CaseId,'TF') || '</value>' || LF;
    v_Str := v_Str || '        <managementPlan>' || Get_InfoPathData('PA_Cardio_Atherosclerosis_Plan_E1                                                  
+ PA_Cardio_Atherosclerosis_Plan_E2                                                  
+ PA_Cardio_Atherosclerosis_Plan_E3                                                  
+ PA_Cardio_Atherosclerosis_Plan_E4                                                  
+ PA_Cardio_Atherosclerosis_Plan_E5                                                  
+ PA_Cardio_Atherosclerosis_Plan_M1                                                  
+ PA_Cardio_Atherosclerosis_Plan_M2                                                  
+ PA_Cardio_Atherosclerosis_Plan_M3                                                  
+ PA_Cardio_Atherosclerosis_Plan_R1                                                  
+ PA_Cardio_Atherosclerosis_Plan_R2',v_CaseId,'MP') || '</managementPlan>' || LF;

    v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
    v_Str := v_Str || '        <title>Aortic Aneurysm (current) Without Rupture</title>' || LF;
    v_Str := v_Str || '        <value>' || Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
    v_Str := v_Str || '   <subDiagnosis>' || Get_InfoPathData('',v_CaseId,'ST') || '</subDiagnosis>' || LF;
    v_Str := v_Str || '    <title>Thoracic</title>' || LF;
    v_Str := v_Str || '    <value>' || Get_InfoPathData('PA_Cardio_Aortic_No_Rupture_Thoracic',v_CaseId,'TF') || '</value>' || LF;
    v_Str := v_Str || '        <managementPlan>' || Get_InfoPathData('PA_Cardio_Aortic_Plan_E1                                                  
+ PA_Cardio_Aortic_Plan_E2                                                  
+ PA_Cardio_Aortic_Plan_E3                                                  
+ PA_Cardio_Aortic_Plan_E4                                                  
+ PA_Cardio_Aortic_Plan_E5                                                  
+ PA_Cardio_Aortic_Plan_M1                                                  
+ PA_Cardio_Aortic_Plan_M2                                                  
+ PA_Cardio_Aortic_Plan_M3                                                  
+ PA_Cardio_Aortic_Plan_R1                                                  
+ PA_Cardio_Aortic_Plan_R2',v_CaseId,'MP') || '</managementPlan>' || LF;

    v_Str := v_Str || '   <subDiagnosis>' || Get_InfoPathData('',v_CaseId,'ST') || '</subDiagnosis>' || LF;
    v_Str := v_Str || '    <title>Abdominal</title>' || LF;
    v_Str := v_Str || '    <value>' || Get_InfoPathData('PA_Cardio_Aortic_No_Rupture_Abdominal',v_CaseId,'TF') || '</value>' || LF;
    v_Str := v_Str || '        <managementPlan>' || Get_InfoPathData('PA_Cardio_Aortic_Plan_E1                                                  
+ PA_Cardio_Aortic_Plan_E2                                                  
+ PA_Cardio_Aortic_Plan_E3                                                  
+ PA_Cardio_Aortic_Plan_E4                                                  
+ PA_Cardio_Aortic_Plan_E5                                                  
+ PA_Cardio_Aortic_Plan_M1                                                  
+ PA_Cardio_Aortic_Plan_M2                                                  
+ PA_Cardio_Aortic_Plan_M3                                                  
+ PA_Cardio_Aortic_Plan_R1                                                  
+ PA_Cardio_Aortic_Plan_R2',v_CaseId,'MP') || '</managementPlan>' || LF;

    v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
    v_Str := v_Str || '    <title>Current Venous Thrombosis/ Embolism (on Rx &amp;lt;3 months)</title>' || LF;
    v_Str := v_Str || '    <value>' || Get_InfoPathData('PA_Cardio_Venous_Thrombosis',v_CaseId,'TF') || '</value>' || LF;
    v_Str := v_Str || '        <managementPlan>' || Get_InfoPathData('PA_Cardio_Venous_Thrombosis_Plan_E1                                                  
+ PA_Cardio_Venous_Thrombosis_Plan_E2                                                  
+ PA_Cardio_Venous_Thrombosis_Plan_E3                                                  
+ PA_Cardio_Venous_Thrombosis_Plan_E4                                                  
+ PA_Cardio_Venous_Thrombosis_Plan_E5                                                  
+ PA_Cardio_Venous_Thrombosis_Plan_M1                                                  
+ PA_Cardio_Venous_Thrombosis_Plan_M2                                                  
+ PA_Cardio_Venous_Thrombosis_Plan_M3                                                  
+ PA_Cardio_Venous_Thrombosis_Plan_R1                                                  
+ PA_Cardio_Venous_Thrombosis_Plan_R2',v_CaseId,'MP') || '</managementPlan>' || LF;

    v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
    v_Str := v_Str || '    <title>History of Venous Thrombosis/ Embolism on Rx or S/P IVC filter</title>' || LF;
    v_Str := v_Str || '    <value>' || Get_InfoPathData('PA_Cardio_History_Venous_Thrombosis',v_CaseId,'TF') || '</value>' || LF;
    v_Str := v_Str || '        <managementPlan>' || Get_InfoPathData('PA_Cardio_History_Venous_Thrombosis_Plan_E1                                                  
+ PA_Cardio_History_Venous_Thrombosis_Plan_E2                                                  
+ PA_Cardio_History_Venous_Thrombosis_Plan_E3                                                  
+ PA_Cardio_History_Venous_Thrombosis_Plan_E4                                                  
+ PA_Cardio_History_Venous_Thrombosis_Plan_E5                                                  
+ PA_Cardio_History_Venous_Thrombosis_Plan_M1                                                  
+ PA_Cardio_History_Venous_Thrombosis_Plan_M2                                                  
+ PA_Cardio_History_Venous_Thrombosis_Plan_M3                                                  
+ PA_Cardio_History_Venous_Thrombosis_Plan_R1                                                  
+ PA_Cardio_History_Venous_Thrombosis_Plan_R2',v_CaseId,
    'ST') || '</managementPlan>' || LF;

    v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
    v_Str := v_Str || '    <title>Valve Disorder</title>' || LF;
    v_Str := v_Str || '    <value>' || Get_InfoPathData('PA_Cardio_Valve_Disorder',v_CaseId,'TF') || '</value>' || LF;
    v_Str := v_Str || '   <subDiagnosis>' || Get_InfoPathData('',v_CaseId,'ST') || '</subDiagnosis>' || LF;
    v_Str := v_Str || '        <title>Valve</title>' || LF;
    v_Str := v_Str || '        <value>' || Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
    v_Str := v_Str || '        <followUpQuestions>' || LF;
    v_Str := v_Str || '            <title>Valve Options:</title>' || LF;
-- need to check the answer node for these 6 tags  
    v_Str := v_Str || '            <answer>' || Get_InfoPathData('PA_Cardio_Valve_Disorder_Mitral',v_CaseId,'ST') || '</answer>' || LF;
    v_Str := v_Str || '            <value>' || Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
    v_Str := v_Str || '        </followUpQuestions>'|| LF;
    v_Str := v_Str || '        <followUpQuestions>' || LF;
    v_Str := v_Str || '            <title>Valve Options:</title>' || LF;
    v_Str := v_Str || '            <answer>' || Get_InfoPathData('PA_Cardio_Valve_Disorder_Aortic',v_CaseId,'ST') || '</answer>' || LF;
    v_Str := v_Str || '            <value>' || Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
    v_Str := v_Str || '        </followUpQuestions>'|| LF;
    v_Str := v_Str || '        <followUpQuestions>' || LF;
    v_Str := v_Str || '            <title>Valve Options:</title>' || LF;
    v_Str := v_Str || '            <answer>' || Get_InfoPathData('PA_Cardio_Valve_Disorder_Tricuspid',v_CaseId,'ST') || '</answer>' || LF;
    v_Str := v_Str || '            <value>' || Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
    v_Str := v_Str || '        </followUpQuestions>'|| LF;
    v_Str := v_Str || '        <followUpQuestions>' || LF;
    v_Str := v_Str || '            <title>Valve Options:</title>' || LF;
    v_Str := v_Str || '            <answer>' || Get_InfoPathData('PA_Cardio_Valve_Disorder_Pulmonary',v_CaseId,'ST') || '</answer>' || LF;
    v_Str := v_Str || '            <value>' || Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
    v_Str := v_Str || '        </followUpQuestions>'|| LF;
    v_Str := v_Str || '   <subDiagnosis>' || Get_InfoPathData('',v_CaseId,'ST') || '</subDiagnosis>' || LF;
    v_Str := v_Str || '        <title>Type:</title>' || LF;
    v_Str := v_Str || '        <value>' || Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
    v_Str := v_Str || '        <followUpQuestions>' || LF;
    v_Str := v_Str || '            <title>Type Options:</title>' || LF;
    v_Str := v_Str || '            <answer>' || Get_InfoPathData('PA_Cardio_Valve_Disorder_Insufficiency',v_CaseId,'ST') || '</answer>' || LF;
    v_Str := v_Str || '            <value>' || Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
    v_Str := v_Str || '        </followUpQuestions>'|| LF;
    v_Str := v_Str || '        <followUpQuestions>' || LF;
    v_Str := v_Str || '            <title>Type Options:</title>' || LF;
    v_Str := v_Str || '            <answer>' || Get_InfoPathData('PA_Cardio_Valve_Disorder_Stenosis',v_CaseId,'ST') || '</answer>' || LF;
    v_Str := v_Str || '            <value>' || Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
    v_Str := v_Str || '        </followUpQuestions>'|| LF;
    v_Str := v_Str || '        <managementPlan>' || Get_InfoPathData('PA_Cardio_Valve_Disorder_Plan_E1                                                  
+ PA_Cardio_Valve_Disorder_Plan_E2                                                  
+ PA_Cardio_Valve_Disorder_Plan_E3                                                  
+ PA_Cardio_Valve_Disorder_Plan_E4                                                  
+ PA_Cardio_Valve_Disorder_Plan_E5                                                  
+ PA_Cardio_Valve_Disorder_Plan_M1                                                  
+ PA_Cardio_Valve_Disorder_Plan_M2                                                  
+ PA_Cardio_Valve_Disorder_Plan_M3                                                  
+ PA_Cardio_Valve_Disorder_Plan_R1                                                  
+ PA_Cardio_Valve_Disorder_Plan_R2',v_CaseId,'MP') || '</managementPlan>' || LF;

    v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
    v_Str := v_Str || '    <title>Pulmonary Hypertension</title>' || LF;
    v_Str := v_Str || '    <value>' || Get_InfoPathData('PA_Cardio_Pulmonary',v_CaseId,'TF') || '</value>' || LF;
    v_Str := v_Str || '        <managementPlan>' || Get_InfoPathData('PA_Cardio_Pulmonary_Plan_E1                                                  
+ PA_Cardio_Pulmonary_Plan_E2                                                  
+ PA_Cardio_Pulmonary_Plan_E3                                                  
+ PA_Cardio_Pulmonary_Plan_E4                                                  
+ PA_Cardio_Pulmonary_Plan_E5                                                  
+ PA_Cardio_Pulmonary_Plan_M1                                                  
+ PA_Cardio_Pulmonary_Plan_M2                                                  
+ PA_Cardio_Pulmonary_Plan_M3                                                  
+ PA_Cardio_Pulmonary_Plan_R1                                                  
+ PA_Cardio_Pulmonary_Plan_R2',v_CaseId,'MP') || '</managementPlan>' || LF;

    v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
    v_Str := v_Str || '    <title>Other Significant Diagnoses:</title>' || LF;
    v_Str := v_Str || '    <value>' || Get_InfoPathData('PA_Cardio_Other',v_CaseId,'TF') || '</value>' || LF;
    v_Str := v_Str || '        <followUpQuestions>' || LF;
    v_Str := v_Str || '            <title>Other</title>' || LF;
    v_Str := v_Str || '            <answer>' || Get_InfoPathData('PA_Cardio_Other_Box',v_CaseId,'ST') || '</answer>' || LF;
    v_Str := v_Str || '            <value>' || Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
    v_Str := v_Str || '        </followUpQuestions>'|| LF;
    v_Str := v_Str || '        <managementPlan>' || Get_InfoPathData('PA_Cardio_Other_Plan_E1                                                  
+ PA_Cardio_Other_Plan_E2                                                  
+ PA_Cardio_Other_Plan_E3                                                  
+ PA_Cardio_Other_Plan_E4                                                  
+ PA_Cardio_Other_Plan_E5                                                  
+ PA_Cardio_Other_Plan_M1                                                  
+ PA_Cardio_Other_Plan_M2                                                  
+ PA_Cardio_Other_Plan_M3                                                  
+ PA_Cardio_Other_Plan_R1                                                  
+ PA_Cardio_Other_Plan_R2',v_CaseId,'MP') || '</managementPlan>' || LF;

    v_Str := v_Str || '   <sections>' || Get_InfoPathData('',v_CaseId,'ST') || '</sections>' || LF;
    v_Str := v_Str || '        <title>Neuropsychiatric Disease</title>' || LF;
    v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
    v_Str := v_Str || '        <title>Alcohol Abuse</title>' || LF;
    v_Str := v_Str || '        <value>' || Get_InfoPathData('',v_CaseId,'TF') || '</value>' || LF;
    v_Str := v_Str || '        <followUpQuestions>' || LF;
    v_Str := v_Str || '            <title>Status:</title>' || LF;
    v_Str := v_Str || '            <answer>' || Get_InfoPathData('PA_Neuro_Alcohol_Abuse_Continuous
+  PA_Neuro_Alcohol_Abuse_Episodic 
+ PA_Neuro_Alcohol_Abuse_Remission ',v_CaseId,'ST') || '</answer>' || LF;
    v_Str := v_Str || '            <value>' || Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
    v_Str := v_Str || '        </followUpQuestions>'|| LF;
    v_Str := v_Str || '        <managementPlan>' || Get_InfoPathData('PA_Neuro_Alcohol_Abuse_Plan_E1                                                  
+ PA_Neuro_Alcohol_Abuse_Plan_E2                                                  
+ PA_Neuro_Alcohol_Abuse_Plan_E3                                                  
+ PA_Neuro_Alcohol_Abuse_Plan_E4                                                  
+ PA_Neuro_Alcohol_Abuse_Plan_E5                                                  
+ PA_Neuro_Alcohol_Abuse_Plan_M1                                                  
+ PA_Neuro_Alcohol_Abuse_Plan_M2                                                  
+ PA_Neuro_Alcohol_Abuse_Plan_M3                                                  
+ PA_Neuro_Alcohol_Abuse_Plan_R1                                                  
+ PA_Neuro_Alcohol_Abuse_Plan_R2',v_CaseId,'MP') || '</managementPlan>' || LF;

    v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
    v_Str := v_Str || '        <title>Alcohol Dependence</title>' || LF;
    v_Str := v_Str || '        <value>' || Get_InfoPathData('',v_CaseId,'TF') || '</value>' || LF;
    v_Str := v_Str || '        <followUpQuestions>' || LF;
    v_Str := v_Str || '            <title>Status:</title>' || LF;
    v_Str := v_Str || '            <answer>' || Get_InfoPathData('PA_Neuro_Alcohol_Dependence_Continuous 
+ PA_Neuro_Alcohol_Dependence_Episodic 
+ PA_Neuro_Alcohol_Dependence_Remission ',v_CaseId,'MP') || '</answer>' || LF;
    v_Str := v_Str || '            <value>' || Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
    v_Str := v_Str || '        </followUpQuestions>'|| LF;
    v_Str := v_Str || '        <managementPlan>' || Get_InfoPathData('PA_Neuro_Alcohol_Dependence_Plan_E1                                                  
+ PA_Neuro_Alcohol_Dependence_Plan_E2                                                  
+ PA_Neuro_Alcohol_Dependence_Plan_E3                                                  
+ PA_Neuro_Alcohol_Dependence_Plan_E4                                                  
+ PA_Neuro_Alcohol_Dependence_Plan_E5                                                  
+ PA_Neuro_Alcohol_Dependence_Plan_M1                                                  
+ PA_Neuro_Alcohol_Dependence_Plan_M2                                                  
+ PA_Neuro_Alcohol_Dependence_Plan_M3                                                  
+ PA_Neuro_Alcohol_Dependence_Plan_R1                                                  
+ PA_Neuro_Alcohol_Dependence_Plan_R2',v_CaseId,'MP') || '</managementPlan>' || LF;

    v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
    v_Str := v_Str || '        <title>Drug Abuse</title>' || LF;
    v_Str := v_Str || '        <value>' || Get_InfoPathData('',v_CaseId,'TF') || '</value>' || LF;
    v_Str := v_Str || '        <followUpQuestions>' || LF;
    v_Str := v_Str || '            <title>Specify Drug:</title>' || LF;
    v_Str := v_Str || '            <value>' || Get_InfoPathData('PA_Neuro_Drug_Abuse',v_CaseId,'ST') || '</value>' || LF;
    v_Str := v_Str || '        </followUpQuestions>'|| LF;
    v_Str := v_Str || '        <followUpQuestions>' || LF;
    v_Str := v_Str || '            <title>Status:</title>' || LF;
    v_Str := v_Str || '            <answer>' || Get_InfoPathData('PA_Neuro_Drug_Abuse_Continuous 
+ PA_Neuro_Drug_Abuse_Episodic 
+ PA_Neuro_Drug_Abuse_Remission',v_CaseId,'ST') || '</answer>' || LF;
    v_Str := v_Str || '            <value>' || Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
    v_Str := v_Str || '        </followUpQuestions>'|| LF;
    v_Str := v_Str || '        <managementPlan>' || Get_InfoPathData('PA_Neuro_Drug_Abuse_Plan_E1                                                  
+ PA_Neuro_Drug_Abuse_Plan_E2                                                  
+ PA_Neuro_Drug_Abuse_Plan_E3                                                  
+ PA_Neuro_Drug_Abuse_Plan_E4                                                  
+ PA_Neuro_Drug_Abuse_Plan_E5                                                  
+ PA_Neuro_Drug_Abuse_Plan_M1                                                  
+ PA_Neuro_Drug_Abuse_Plan_M2                                                  
+ PA_Neuro_Drug_Abuse_Plan_M3                                                  
+ PA_Neuro_Drug_Abuse_Plan_R1                                                  
+ PA_Neuro_Drug_Abuse_Plan_R2',v_CaseId,'MP') || '</managementPlan>' || LF;
    v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
    v_Str := v_Str || '        <title>Drug Dependence</title>' || LF;
    v_Str := v_Str || '        <value>' || Get_InfoPathData('',v_CaseId,'TF') || '</value>' || LF;
    v_Str := v_Str || '        <followUpQuestions>' || LF;
    v_Str := v_Str || '            <title>Specify Drug:</title>' || LF;
    v_Str := v_Str || '            <value>' || Get_InfoPathData('PA_Neuro_Drug_Dependence',v_CaseId,'ST') || '</value>' || LF;
    v_Str := v_Str || '        </followUpQuestions>'|| LF;
    v_Str := v_Str || '        <followUpQuestions>' || LF;
    v_Str := v_Str || '            <title>Status:</title>' || LF;
    v_Str := v_Str || '            <answer>' || Get_InfoPathData('PA_Neuro_Drug_Dependence_Continuous 
+ PA_Neuro_Drug_Dependence_Episodic 
+ PA_Neuro_Drug_Dependence_Remission',v_CaseId,'MP') || '</answer>' || LF;
    v_Str := v_Str || '            <value>' || Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
    v_Str := v_Str || '        </followUpQuestions>'|| LF;
    v_Str := v_Str || '        <managementPlan>' || Get_InfoPathData('PA_Neuro_Drug_Dependence_Plan_E1                                                  
+ PA_Neuro_Drug_Dependence_Plan_E2                                                  
+ PA_Neuro_Drug_Dependence_Plan_E3                                                  
+ PA_Neuro_Drug_Dependence_Plan_E4                                                  
+ PA_Neuro_Drug_Dependence_Plan_E5                                                  
+ PA_Neuro_Drug_Dependence_Plan_M1                                                  
+ PA_Neuro_Drug_Dependence_Plan_M2                                                  
+ PA_Neuro_Drug_Dependence_Plan_M3                                                  
+ PA_Neuro_Drug_Dependence_Plan_R1                                                  
+ PA_Neuro_Drug_Dependence_Plan_R2',v_CaseId,'MP') || '</managementPlan>' || LF;
    v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
    v_Str := v_Str || '        <title>Tobacco Use</title>' || LF;
    v_Str := v_Str || '        <value>' || Get_InfoPathData('',v_CaseId,'TF') || '</value>' || LF;
    v_Str := v_Str || '        <followUpQuestions>' || LF;
    v_Str := v_Str || '            <title>Status:</title>' || LF;
    v_Str := v_Str || '            <answer>' || Get_InfoPathData(' PA_Neuro_Tobacco_Current ',v_CaseId,'ST') || '</answer>' || LF;
    v_Str := v_Str || '            <value>' || Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
    v_Str := v_Str || '        </followUpQuestions>'|| LF;
    v_Str := v_Str || '        <followUpQuestions>' || LF;
    v_Str := v_Str || '            <title>Status:</title>' || LF;
    v_Str := v_Str || '            <answer>' || Get_InfoPathData(' PA_Neuro_Tobacco_History_Of ',v_CaseId,'ST') || '</answer>' || LF;
    v_Str := v_Str || '            <value>' || Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
    v_Str := v_Str || '        </followUpQuestions>'|| LF;
    v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
    v_Str := v_Str || '        <title>Alzheimer''s Disease</title>' || LF;
    v_Str := v_Str || '        <value>' || Get_InfoPathData(' PA_Neuro_Alzheimers ',v_CaseId,'TF') || '</value>' || LF;
    v_Str := v_Str || '        <followUpQuestions>' || LF;
    v_Str := v_Str || '            <title>Dementia in Alzheimer''s without Behavioral Disturbance</title>' || LF;
    v_Str := v_Str || '            <answer>' || Get_InfoPathData('',v_CaseId,'ST') || '</answer>' || LF;
    v_Str := v_Str || '            <value>' || Get_InfoPathData(' PA_Neuro_Alzheimers_Dementia_Without_Disturbance ',v_CaseId,'TF') || '</value>' || LF;
    v_Str := v_Str || '        </followUpQuestions>'|| LF;
    v_Str := v_Str || '        <followUpQuestions>' || LF;
    v_Str := v_Str || '            <title>Dementia in Alzheimer''s with Behavioral Disturbance</title>' || LF;
    v_Str := v_Str || '            <answer>' || Get_InfoPathData(' PA_Neuro_Alzheimers_Dementia_With_Disturbance ',v_CaseId,'TF') || '</answer>' || LF;
    v_Str := v_Str || '            <value>' || Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
    v_Str := v_Str || '        </followUpQuestions>'|| LF;
    v_Str := v_Str || '        <secondaryQuestions>' || LF;
    v_Str := v_Str || '            <title>Specify:</title>' || LF;
    v_Str := v_Str || '            <answer>' || Get_InfoPathData(' PA_Neuro_Alzheimers_Dementia_With_Disturbance_Box ',v_CaseId,'ST') || '</answer>' || LF;
    v_Str := v_Str || '            <value>' || Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
    v_Str := v_Str || '        </secondaryQuestions>' || LF;
    v_Str := v_Str || '        <managementPlan>' || Get_InfoPathData('PA_Neuro_Alzheimers_Plan_E1                                                  
+ PA_Neuro_Alzheimers_Plan_E2                                                  
+ PA_Neuro_Alzheimers_Plan_E3                                                  
+ PA_Neuro_Alzheimers_Plan_E4                                                  
+ PA_Neuro_Alzheimers_Plan_E5                                                  
+ PA_Neuro_Alzheimers_Plan_M1                                                  
+ PA_Neuro_Alzheimers_Plan_M2                                                  
+ PA_Neuro_Alzheimers_Plan_M3                                                  
+ PA_Neuro_Alzheimers_Plan_R1                                                  
+ PA_Neuro_Alzheimers_Plan_R2',v_CaseId,'MP') || '</managementPlan>' || LF;

    v_Str := v_Str || '        <followUpQuestions>' || LF;
    v_Str := v_Str || '            <title>Unspecified Dementia without behavioral disturbance</title>' || LF;
    v_Str := v_Str || '            <answer>' || Get_InfoPathData(' PA_Neuro_Unspecified_Dementia_Without ',v_CaseId,'TF') || '</answer>' || LF;
    v_Str := v_Str || '            <value>' || Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
    v_Str := v_Str || '        </followUpQuestions>'|| LF;
    v_Str := v_Str || '        <followUpQuestions>' || LF;
    v_Str := v_Str || '            <title>Unspecified Dementia with behavioral disturbance</title>' || LF;
    v_Str := v_Str || '            <answer>' || Get_InfoPathData(' PA_Neuro_Unspecified_Dementia_With ',v_CaseId,'TF') || '</answer>' || LF;
    v_Str := v_Str || '            <value>' || Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
    v_Str := v_Str || '        </followUpQuestions>'|| LF;
    v_Str := v_Str || '        <secondaryQuestions>' || LF;
    v_Str := v_Str || '            <title>Specify:</title>' || LF;
    v_Str := v_Str || '            <answer>' || Get_InfoPathData(' PA_Neuro_Unspecified_Dementia_With_Box ',v_CaseId,'ST') || '</answer>' || LF;
    v_Str := v_Str || '            <value>' || Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
    v_Str := v_Str || '        </secondaryQuestions>' || LF;
    v_Str := v_Str || '        <managementPlan>' || Get_InfoPathData('PA_Neuro_Unspecified_Dementia_E1                                                  
+ PA_Neuro_Unspecified_Dementia_E2                                                  
+ PA_Neuro_Unspecified_Dementia_E3                                                  
+ PA_Neuro_Unspecified_Dementia_E4                                                  
+ PA_Neuro_Unspecified_Dementia_E5                                                  
+ PA_Neuro_Unspecified_Dementia_M1                                                  
+ PA_Neuro_Unspecified_Dementia_M2                                                  
+ PA_Neuro_Unspecified_Dementia_M3                                                  
+ PA_Neuro_Unspecified_Dementia_R1                                                  
+ PA_Neuro_Unspecified_Dementia_R2',v_CaseId,'MP') || '</managementPlan>' || LF;

    v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
    v_Str := v_Str || '        <title>Wandering in patient diagnosed with dementia</title>' || LF;
    v_Str := v_Str || '        <value>' || Get_InfoPathData(' PA_Neuro_Wandering ',v_CaseId,'TF') || '</value>' || LF;
    v_Str := v_Str || '        <managementPlan>' || Get_InfoPathData('PA_Neuro_Wandering_E1                                                  
+ PA_Neuro_Wandering_E2                                                  
+ PA_Neuro_Wandering_E3                                                  
+ PA_Neuro_Wandering_E4                                                  
+ PA_Neuro_Wandering_E5                                                  
+ PA_Neuro_Wandering_M1                                                  
+ PA_Neuro_Wandering_M2                                                  
+ PA_Neuro_Wandering_M3                                                  
+ PA_Neuro_Wandering_R1                                                  
+ PA_Neuro_Wandering_R2',v_CaseId,'MP') || '</managementPlan>' || LF;

    v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
    v_Str := v_Str || '        <title>Mild Cognitive Impairment</title>' || LF;
    v_Str := v_Str || '        <value>' || Get_InfoPathData(' PA_Neuro_Mild_Cognitive_Impairment ',v_CaseId,'TF') || '</value>' || LF;
    v_Str := v_Str || '        <managementPlan>' || Get_InfoPathData('PA_Neuro_Mild_Cognitive_Impairment_Plan_E1                                                  
+ PA_Neuro_Mild_Cognitive_Impairment_Plan_E2                                                  
+ PA_Neuro_Mild_Cognitive_Impairment_Plan_E3                                                  
+ PA_Neuro_Mild_Cognitive_Impairment_Plan_E4                                                  
+ PA_Neuro_Mild_Cognitive_Impairment_Plan_E5                                                  
+ PA_Neuro_Mild_Cognitive_Impairment_Plan_M1                                                  
+ PA_Neuro_Mild_Cognitive_Impairment_Plan_M2                                                  
+ PA_Neuro_Mild_Cognitive_Impairment_Plan_M3                                                  
+ PA_Neuro_Mild_Cognitive_Impairment_Plan_R1                                                  
+ PA_Neuro_Mild_Cognitive_Impairment_Plan_R2',v_CaseId,'ST') ||
    '</managementPlan>' || LF;

    v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
    v_Str := v_Str || '        <title>Anxiety</title>' || LF;
    v_Str := v_Str || '        <value>' || Get_InfoPathData(' PA_Neuro_Anxiety ',v_CaseId,'TF') || '</value>' || LF;
    v_Str := v_Str || '        <managementPlan>' || Get_InfoPathData('PA_Neuro_Anxiety_E1                                                  
+ PA_Neuro_Anxiety_E2                                                  
+ PA_Neuro_Anxiety_E3                                                  
+ PA_Neuro_Anxiety_E4                                                  
+ PA_Neuro_Anxiety_E5                                                  
+ PA_Neuro_Anxiety_M1                                                  
+ PA_Neuro_Anxiety_M2                                                  
+ PA_Neuro_Anxiety_M3                                                  
+ PA_Neuro_Anxiety_R1                                                  
+ PA_Neuro_Anxiety_R2',v_CaseId,'MP') || '</managementPlan>' || LF;

    v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
    v_Str := v_Str || '        <title>Bipolar Disorder (manic-depressive)</title>' || LF;
    v_Str := v_Str || '        <value>' || Get_InfoPathData(' PA_Neuro_Bipolar ',v_CaseId,'TF') || '</value>' || LF;
    v_Str := v_Str || '        <managementPlan>' || Get_InfoPathData('PA_Neuro_Bipolar_Plan_E1                                                  
+ PA_Neuro_Bipolar_Plan_E2                                                  
+ PA_Neuro_Bipolar_Plan_E3                                                  
+ PA_Neuro_Bipolar_Plan_E4                                                  
+ PA_Neuro_Bipolar_Plan_E5                                                  
+ PA_Neuro_Bipolar_Plan_M1                                                  
+ PA_Neuro_Bipolar_Plan_M2                                                  
+ PA_Neuro_Bipolar_Plan_M3                                                  
+ PA_Neuro_Bipolar_Plan_R1                                                  
+ PA_Neuro_Bipolar_Plan_R2',v_CaseId,'MP') || '</managementPlan>' || LF;

    v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
    v_Str := v_Str || '        <title>Schizophrenia</title>' || LF;
    v_Str := v_Str || '        <value>' || Get_InfoPathData(' PA_Neuro_Schizophrenia ',v_CaseId,'TF') || '</value>' || LF;
    v_Str := v_Str || '        <followUpQuestions>' || LF;
    v_Str := v_Str || '            <title>Type of Schizophrenia:</title>' || LF;
    v_Str := v_Str || '            <value>' || Get_InfoPathData(' PA_Neuro_Schizophrenia ',v_CaseId,'ST') || '</value>' || LF;
    v_Str := v_Str || '            <otherValue>' || Get_InfoPathData('',v_CaseId,'ST') || '</otherValue>' || LF;
    v_Str := v_Str || '        </followUpQuestions>'|| LF;
    v_Str := v_Str || '        <managementPlan>' || Get_InfoPathData('PA_Neuro_Schizophrenia_Plan_E1                                                  
+ PA_Neuro_Schizophrenia_Plan_E2                                                  
+ PA_Neuro_Schizophrenia_Plan_E3                                                  
+ PA_Neuro_Schizophrenia_Plan_E4                                                  
+ PA_Neuro_Schizophrenia_Plan_E5                                                  
+ PA_Neuro_Schizophrenia_Plan_M1                                                  
+ PA_Neuro_Schizophrenia_Plan_M2                                                  
+ PA_Neuro_Schizophrenia_Plan_M3                                                  
+ PA_Neuro_Schizophrenia_Plan_R1                                                  
+ PA_Neuro_Schizophrenia_Plan_R2',v_CaseId,'MP') || '</managementPlan>' || LF;

    v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
    v_Str := v_Str || '        <title>Parkinson''s Disease</title>' || LF;
    v_Str := v_Str || '        <value>' || Get_InfoPathData(' PA_Neuro_Parkinsons ',v_CaseId,'TF') || '</value>' || LF;
    v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
    v_Str := v_Str || '        <title>Peripheral Neuropathy (not Diabetes-related)</title>' || LF;
    v_Str := v_Str || '        <value>' || Get_InfoPathData(' PA_Neuro_Peripheral_Neuropathy ',v_CaseId,'TF') || '</value>' || LF;
    v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
    v_Str := v_Str || '        <title>Aphasia</title>' || LF;
    v_Str := v_Str || '        <value>' || Get_InfoPathData(' PA_Neuro_Aphasia ',v_CaseId,'TF') || '</value>' || LF;
    v_Str := v_Str || '        <followUpQuestions>' || LF;
    v_Str := v_Str || '            <title>Cause:</title>' || LF;
    v_Str := v_Str || '            <answer>' || 'Other Cause' || '</answer>' || LF;
    v_Str := v_Str || '            <value>' || Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
    v_Str := v_Str || '        </followUpQuestions>'|| LF;
    v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
    v_Str := v_Str || '        <title>Dysphagia</title>' || LF;
    v_Str := v_Str || '        <value>' || Get_InfoPathData(' PA_Neuro_Aphasia_Dysphagia ',v_CaseId,'TF') || '</value>' || LF;
    v_Str := v_Str || '        <followUpQuestions>' || LF;
    v_Str := v_Str || '            <title>Cause:</title>' || LF;
    v_Str := v_Str || '            <answer>' || 'Other Cause' || '</answer>' || LF;
    v_Str := v_Str || '            <value>' || Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
    v_Str := v_Str || '        </followUpQuestions>'|| LF;
    v_Str := v_Str || '        <managementPlan>' || Get_InfoPathData('PA_Neuro_Aphasia_Dysphagia_Plan_E1                                                  
+ PA_Neuro_Aphasia_Dysphagia_Plan_E2                                                  
+ PA_Neuro_Aphasia_Dysphagia_Plan_E3                                                  
+ PA_Neuro_Aphasia_Dysphagia_Plan_E4                                                  
+ PA_Neuro_Aphasia_Dysphagia_Plan_E5                                                  
+ PA_Neuro_Aphasia_Dysphagia_Plan_M1                                                  
+ PA_Neuro_Aphasia_Dysphagia_Plan_M2                                                  
+ PA_Neuro_Aphasia_Dysphagia_Plan_M3                                                  
+ PA_Neuro_Aphasia_Dysphagia_Plan_R1                                                  
+ PA_Neuro_Aphasia_Dysphagia_Plan_R2',v_CaseId,'MP') || '</managementPlan>' || LF;

    v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
    v_Str := v_Str || '        <title>Hemiparesis</title>' || LF;
    v_Str := v_Str || '        <value>' || Get_InfoPathData(' PA_Neuro_Hemiparesis ',v_CaseId,'TF') || '</value>' || LF;
    v_Str := v_Str || '        <followUpQuestions>' || LF;
    v_Str := v_Str || '            <title>Cause:</title>' || LF;
    v_Str := v_Str || '            <answer>' || 'Late Effect of Stroke' || '</answer>' || LF;
    v_Str := v_Str || '            <value>' || Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
    v_Str := v_Str || '        </followUpQuestions>'|| LF;
    v_Str := v_Str || '        <secondaryQuestions>' || LF;
    v_Str := v_Str || '            <title>Dominant</title>' || LF;
    v_Str := v_Str || '            <answer>' || 'Late Effect of Stroke' || '</answer>' || LF;
    v_Str := v_Str || '            <value>' || Get_InfoPathData(' PA_Neuro_Hemiparesis_Dominant ',v_CaseId,'ST') || '</value>' || LF;
    v_Str := v_Str || '        </secondaryQuestions>' || LF;
    v_Str := v_Str || '        <secondaryQuestions>' || LF;
    v_Str := v_Str || '            <title>Non-Dominant</title>' || LF;
    v_Str := v_Str || '            <answer>' || 'Late Effect of Stroke' || '</answer>' || LF;
    v_Str := v_Str || '            <value>' || Get_InfoPathData(' PA_Neuro_Hemiparesis_Dominant ',v_CaseId,'ST') || '</value>' || LF;
    v_Str := v_Str || '        </secondaryQuestions>' || LF;
    v_Str := v_Str || '        <secondaryQuestions>' || LF;
    v_Str := v_Str || '            <title>Unspecified</title>' || LF;
    v_Str := v_Str || '            <answer>' || 'Late Effect of Stroke' || '</answer>' || LF;
    v_Str := v_Str || '            <value>' || Get_InfoPathData(' PA_Neuro_Hemiparesis_Dominant ',v_CaseId,'ST') || '</value>' || LF;
    v_Str := v_Str || '        </secondaryQuestions>' || LF;
    v_Str := v_Str || '        <managementPlan>' || Get_InfoPathData('PA_Neuro_Hemi_Plan_E1                                                  
+ PA_Neuro_Hemi_Plan_E2                                                  
+ PA_Neuro_Hemi_Plan_E3                                                  
+ PA_Neuro_Hemi_Plan_E4                                                  
+ PA_Neuro_Hemi_Plan_E5                                                  
+ PA_Neuro_Hemi_Plan_M1                                                  
+ PA_Neuro_Hemi_Plan_M2                                                  
+ PA_Neuro_Hemi_Plan_M3                                                  
+ PA_Neuro_Hemi_Plan_R1                                                  
+ PA_Neuro_Hemi_Plan_R2',v_CaseId,'MP') || '</managementPlan>' || LF;

    v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
    v_Str := v_Str || '        <title>Hemiplegia</title>' || LF;
    v_Str := v_Str || '        <value>' || Get_InfoPathData(' PA_Neuro_Hemiplegia ',v_CaseId,'TF') || '</value>' || LF;
    v_Str := v_Str || '        <followUpQuestions>' || LF;
    v_Str := v_Str || '            <title>Cause:</title>' || LF;
    v_Str := v_Str || '            <answer>' || 'Late Effect of Stroke' || '</answer>' || LF;
    v_Str := v_Str || '            <value>' || Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
    v_Str := v_Str || '        </followUpQuestions>'|| LF;
    v_Str := v_Str || '        <secondaryQuestions>' || LF;
    v_Str := v_Str || '            <title>Dominant</title>' || LF;
    v_Str := v_Str || '            <answer>' || 'Late Effect of Stroke' || '</answer>' || LF;
    v_Str := v_Str || '            <value>' || Get_InfoPathData(' PA_Neuro_Hemiplegia_Dominant ',v_CaseId,'ST') || '</value>' || LF;
    v_Str := v_Str || '        </secondaryQuestions>' || LF;
    v_Str := v_Str || '        <secondaryQuestions>' || LF;
    v_Str := v_Str || '            <title>Non-Dominant</title>' || LF;
    v_Str := v_Str || '           <answer>' || 'Late Effect of Stroke' || '</answer>' || LF;
    v_Str := v_Str || '            <value>' || Get_InfoPathData(' PA_Neuro_Hemiplegia_Dominant ',v_CaseId,'ST') || '</value>' || LF;
    v_Str := v_Str || '        <secondaryQuestions>' || LF;
    v_Str := v_Str || '        </secondaryQuestions>' || LF;
    v_Str := v_Str || '            <title>Unspecified</title>' || LF;
    v_Str := v_Str || '            <answer>' || 'Late Effect of Stroke' || '</answer>' || LF;
    v_Str := v_Str || '            <value>' || Get_InfoPathData(' PA_Neuro_Hemiplegia_Dominant ',v_CaseId,'ST') || '</value>' || LF;
    v_Str := v_Str || '        </secondaryQuestions>' || LF;
    v_Str := v_Str || '        <managementPlan>' || Get_InfoPathData('PA_Neuro_Hemi_Plan_E1                                                  
+ PA_Neuro_Hemi_Plan_E2                                                  
+ PA_Neuro_Hemi_Plan_E3                                                  
+ PA_Neuro_Hemi_Plan_E4                                                  
+ PA_Neuro_Hemi_Plan_E5                                                  
+ PA_Neuro_Hemi_Plan_M1                                                  
+ PA_Neuro_Hemi_Plan_M2                                                  
+ PA_Neuro_Hemi_Plan_M3                                                  
+ PA_Neuro_Hemi_Plan_R1                                                  
+ PA_Neuro_Hemi_Plan_R2',v_CaseId,'MP') || '</managementPlan>' || LF;

    v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
    v_Str := v_Str || '        <title>Monoparesis</title>' || LF;
    v_Str := v_Str || '        <value>' || Get_InfoPathData(' PA_Neuro_Monoparesis ',v_CaseId,'TF') || '</value>' || LF;
    v_Str := v_Str || '        <followUpQuestions>' || LF;
    v_Str := v_Str || '            <title>Location:</title>' || LF;
    v_Str := v_Str || '            <answer>' || Get_InfoPathData(' PA_Neuro_Monoparesis_Lower_Extremity 
+ PA_Neuro_Monoparesis_Upper_Extremity',v_CaseId,'ST') || '</answer>' || LF;
    v_Str := v_Str || '            <value>' || Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
    v_Str := v_Str || '        </followUpQuestions>'|| LF;
    v_Str := v_Str || '        <followUpQuestions>' || LF;
    v_Str := v_Str || '            <title>Cause:</title>' || LF;
    v_Str := v_Str || '            <answer>' || 'Late Effect of Stroke' || '</answer>' || LF;
    v_Str := v_Str || '            <value>' || Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
    v_Str := v_Str || '        </followUpQuestions>'|| LF;
    v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
    v_Str := v_Str || '        <title>Monoplegia</title>' || LF;
    v_Str := v_Str || '        <value>' || Get_InfoPathData(' PA_Neuro_Monoplegia ',v_CaseId,'ST') || '</value>' || LF;
    v_Str := v_Str || '        <followUpQuestions>' || LF;
    v_Str := v_Str || '            <title>Location:</title>' || LF;
    v_Str := v_Str || '            <answer>' || Get_InfoPathData(' PA_Neuro_Monoplegia_Lower_Extremity 
+ PA_Neuro_Monoplegia_Upper_Extremity 
',v_CaseId,'ST') || '</answer>' || LF;
    v_Str := v_Str || '            <value>' || Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
    v_Str := v_Str || '        </followUpQuestions>'|| LF;
    v_Str := v_Str || '        <followUpQuestions>' || LF;
    v_Str := v_Str || '            <title>Cause:</title>' || LF;
    v_Str := v_Str || '            <answer>' || 'Late Effect of Stroke' || '</answer>' || LF;
    v_Str := v_Str || '            <value>' || Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
    v_Str := v_Str || '        </followUpQuestions>'|| LF;
    v_Str := v_Str || '        <managementPlan>' || Get_InfoPathData('PA_Neuro_Mono_Plan_E1                                                  
+ PA_Neuro_Mono_Plan_E2                                                  
+ PA_Neuro_Mono_Plan_E3                                                  
+ PA_Neuro_Mono_Plan_E4                                                  
+ PA_Neuro_Mono_Plan_E5                                                  
+ PA_Neuro_Mono_Plan_M1                                                  
+ PA_Neuro_Mono_Plan_M2                                                  
+ PA_Neuro_Mono_Plan_M3                                                  
+ PA_Neuro_Mono_Plan_R1                                                  
+ PA_Neuro_Mono_Plan_R2',v_CaseId,'MP') || '</managementPlan>' || LF;

    v_Str := v_Str || '        <followUpQuestions>' || LF;
    v_Str := v_Str || '            <title>other</title>' || LF;
    v_Str := v_Str || '            <value>' || Get_InfoPathData('PA_Neuro_Stroke_Other',v_CaseId,'TF') || '</value>' || LF;
    v_Str := v_Str || '            <otherValue>' || Get_InfoPathData('PA_Neuro_Stroke_Other_Box',v_CaseId,'ST') || '</otherValue>' || LF;
    v_Str := v_Str || '        </followUpQuestions>'|| LF;
    v_Str := v_Str || '        <managementPlan>' || Get_InfoPathData('PA_Neuro_Stroke_Other_Plan_E1                                                  
+ PA_Neuro_Stroke_Other_Plan_E2                                                  
+ PA_Neuro_Stroke_Other_Plan_E3                                                  
+ PA_Neuro_Stroke_Other_Plan_E4                                                  
+ PA_Neuro_Stroke_Other_Plan_E5                                                  
+ PA_Neuro_Stroke_Other_Plan_M1                                                  
+ PA_Neuro_Stroke_Other_Plan_M2                                                  
+ PA_Neuro_Stroke_Other_Plan_M3                                                  
+ PA_Neuro_Stroke_Other_Plan_R1                                                  
+ PA_Neuro_Stroke_Other_Plan_R2',v_CaseId,'MP') || '</managementPlan>' || LF;

    v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
    v_Str := v_Str || '        <title>History TIA or of a Stroke without Residual Deficits</title>' || LF;
    v_Str := v_Str || '        <value>' || Get_InfoPathData(' PA_Neuro_TIA + PA_Neuro_History_Stroke ',v_CaseId,'TF') || '</value>' || LF;
    v_Str := v_Str || '        <managementPlan>' || Get_InfoPathData(
    'PA_Neuro_TIA_E1                                                  
+ PA_Neuro_TIA_Plan_E2                                                  
+ PA_Neuro_TIA_Plan_E3                                                  
+ PA_Neuro_TIA_Plan_E4                                                  
+ PA_Neuro_TIA_Plan_E5                                                  
+ PA_Neuro_TIA_Plan_M1                                                  
+ PA_Neuro_TIA_Plan_M2                                                  
+ PA_Neuro_TIA_Plan_M3                                                  
+ PA_Neuro_TIA_Plan_R1                                                  
+ PA_Neuro_TIA_Plan_R2                                                  
+ PA_Neuro_History_Stroke_Plan_E1                                                  
+ PA_Neuro_History_Stroke_Plan_E2                                                  
+ PA_Neuro_History_Stroke_Plan_E3                                                  
+ PA_Neuro_History_Stroke_Plan_E4                                                  
+ PA_Neuro_History_Stroke_Plan_E5                                                  
+ PA_Neuro_History_Stroke_Plan_M1                                                  
+ PA_Neuro_History_Stroke_Plan_M2                                                  
+ PA_Neuro_History_Stroke_Plan_M3                                                  
+ PA_Neuro_History_Stroke_Plan_R1                                                  
+ PA_Neuro_History_Stroke_Plan_R2'
    ,v_CaseId,'MP') || '</managementPlan>' || LF;

    v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
    v_Str := v_Str || '        <title>Epilepsy or Seizure Disorder</title>' || LF;
    v_Str := v_Str || '        <value>' || Get_InfoPathData(' PA_Neuro_Epilepsy ',v_CaseId,'TF') || '</value>' || LF;
    v_Str := v_Str || '        <managementPlan>' || Get_InfoPathData('PA_Neuro_Epilepsy_Plan_E1                                                  
+ PA_Neuro_Epilepsy_Plan_E2                                                  
+ PA_Neuro_Epilepsy_Plan_E3                                                  
+ PA_Neuro_Epilepsy_Plan_E4                                                  
+ PA_Neuro_Epilepsy_Plan_E5                                                  
+ PA_Neuro_Epilepsy_Plan_M1                                                  
+ PA_Neuro_Epilepsy_Plan_M2                                                  
+ PA_Neuro_Epilepsy_Plan_M3                                                  
+ PA_Neuro_Epilepsy_Plan_R1                                                  
+ PA_Neuro_Epilepsy_Plan_R2',v_CaseId,'MP') || '</managementPlan>' || LF;
    v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
    v_Str := v_Str || '        <title>Other convulsions</title>' || LF;
    v_Str := v_Str || '        <value>' || Get_InfoPathData(' PA_Neuro_Convulsions ',v_CaseId,'TF') || '</value>' || LF;
    v_Str := v_Str || '        <managementPlan>' || Get_InfoPathData('PA_Neuro_Convulsions_E1                                                  
+ PA_Neuro_Convulsions_E2                                                  
+ PA_Neuro_Convulsions_E3                                                  
+ PA_Neuro_Convulsions_E4                                                  
+ PA_Neuro_Convulsions_E5                                                  
+ PA_Neuro_Convulsions_M1                                                  
+ PA_Neuro_Convulsions_M2                                                  
+ PA_Neuro_Convulsions_M3                                                  
+ PA_Neuro_Convulsions_R1                                                  
+ PA_Neuro_Convulsions_R2',v_CaseId,'MP') || '</managementPlan>' || LF;
    v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
    v_Str := v_Str || '        <title>Quadriplegia</title>' || LF;
    v_Str := v_Str || '        <value>' || Get_InfoPathData(' PA_Neuro_Quadriplegia ',v_CaseId,'TF') || '</value>' || LF;
    v_Str := v_Str || '        <managementPlan>' || Get_InfoPathData('PA_Neuro_Quadriplegia_Plan_E1                                                  
+ PA_Neuro_Quadriplegia_Plan_E2                                                  
+ PA_Neuro_Quadriplegia_Plan_E3                                                  
+ PA_Neuro_Quadriplegia_Plan_E4                                                  
+ PA_Neuro_Quadriplegia_Plan_E5                                                  
+ PA_Neuro_Quadriplegia_Plan_M1                                                  
+ PA_Neuro_Quadriplegia_Plan_M2                                                  
+ PA_Neuro_Quadriplegia_Plan_M3                                                  
+ PA_Neuro_Quadriplegia_Plan_R1                                                  
+ PA_Neuro_Quadriplegia_Plan_R2',v_CaseId,'MP') || '</managementPlan>' || LF;
    v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
    v_Str := v_Str || '        <title>Paraplegia</title>' || LF;
    v_Str := v_Str || '        <value>' || Get_InfoPathData(' PA_Neuro_Paraplegia ',v_CaseId,'TF') || '</value>' || LF;
    v_Str := v_Str || '        <managementPlan>' || Get_InfoPathData('PA_Neuro_Paraplegia_Plan_E1                                                  
+ PA_Neuro_Paraplegia_Plan_E2                                                  
+ PA_Neuro_Paraplegia_Plan_E3                                                  
+ PA_Neuro_Paraplegia_Plan_E4                                                  
+ PA_Neuro_Paraplegia_Plan_E5                                                  
+ PA_Neuro_Paraplegia_Plan_M1                                                  
+ PA_Neuro_Paraplegia_Plan_M2                                                  
+ PA_Neuro_Paraplegia_Plan_M3                                                  
+ PA_Neuro_Paraplegia_Plan_R1                                                  
+ PA_Neuro_Paraplegia_Plan_R2',v_CaseId,'MP') || '</managementPlan>' || LF;
    v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
    v_Str := v_Str || '        <title>Insomnia</title>' || LF;
    v_Str := v_Str || '        <value>' || Get_InfoPathData(' PA_Neuro_Insomnia ',v_CaseId,'TF') || '</value>' || LF;
    v_Str := v_Str || '        <managementPlan>' || Get_InfoPathData('PA_Neuro_Insomnia_Plan_E1                                                  
+ PA_Neuro_Insomnia_Plan_E2                                                  
+ PA_Neuro_Insomnia_Plan_E3                                                  
+ PA_Neuro_Insomnia_Plan_E4                                                  
+ PA_Neuro_Insomnia_Plan_E5                                                  
+ PA_Neuro_Insomnia_Plan_M1                                                  
+ PA_Neuro_Insomnia_Plan_M2                                                  
+ PA_Neuro_Insomnia_Plan_M3                                                  
+ PA_Neuro_Insomnia_Plan_R1                                                  
+ PA_Neuro_Insomnia_Plan_R2',v_CaseId,'MP') || '</managementPlan>' || LF;
    v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
    v_Str := v_Str || '        <title>Other Significant Diagnoses:</title>' || LF;
    v_Str := v_Str || '        <value>' || Get_InfoPathData(' PA_Neuro_Other_Significant ',v_CaseId,'TF') || '</value>' || LF;
    v_Str := v_Str || '        <followUpQuestions>' || LF;
    v_Str := v_Str || '            <title>Other:</title>' || LF;
    v_Str := v_Str || '            <answer>' || Get_InfoPathData(' PA_Neuro_Other_Significant_Box ',v_CaseId,'ST') || '</answer>' || LF;
    v_Str := v_Str || '            <value>' || Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
    v_Str := v_Str || '        </followUpQuestions>'|| LF;
    v_Str := v_Str || '        <managementPlan>' || Get_InfoPathData('PA_Neuro_Other_Significant_Plan_E1                                                  
+ PA_Neuro_Other_Significant_Plan_E2                                                  
+ PA_Neuro_Other_Significant_Plan_E3                                                  
+ PA_Neuro_Other_Significant_Plan_E4                                                  
+ PA_Neuro_Other_Significant_Plan_E5                                                  
+ PA_Neuro_Other_Significant_Plan_M1                                                  
+ PA_Neuro_Other_Significant_Plan_M2                                                  
+ PA_Neuro_Other_Significant_Plan_M3                                                  
+ PA_Neuro_Other_Significant_Plan_R1                                                  
+ PA_Neuro_Other_Significant_Plan_R2',v_CaseId,'MP') || '</managementPlan>' || LF;
    v_Str := v_Str || '   <sections>' || Get_InfoPathData('',v_CaseId,'ST') || '</sections>' || LF;
    v_Str := v_Str || '        <title>Pulmonary</title>' || LF;
    v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
    v_Str := v_Str || '        <title>Chronic Bronchitis:</title>' || LF;
    v_Str := v_Str || '        <value>' || Get_InfoPathData('',v_CaseId,'TF') || '</value>' || LF;
    v_Str := v_Str || '        <followUpQuestions>' || LF;
    v_Str := v_Str || '            <title>Specify:</title>' || LF;
    v_Str := v_Str || '            <answer>' || Get_InfoPathData(' PA_Pulmonary_Bronchitis_Simple 
+ PA_Pulmonary_Bronchitis_Mucopurulent 
+ PA_Pulmonary_Bronchitis_Exacerbation 
',v_CaseId,'ST') || '</answer>' || LF;
    v_Str := v_Str || '            <value>' || Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
    v_Str := v_Str || '        </followUpQuestions>'|| LF;
    v_Str := v_Str || '        <managementPlan>' || Get_InfoPathData('PA_Pulmonary_Bronchitis_Plan_E1                                                  
+ PA_Pulmonary_Bronchitis_Plan_E2                                                  
+ PA_Pulmonary_Bronchitis_Plan_E3                                                  
+ PA_Pulmonary_Bronchitis_Plan_E4                                                  
+ PA_Pulmonary_Bronchitis_Plan_E5                                                  
+ PA_Pulmonary_Bronchitis_Plan_M1                                                  
+ PA_Pulmonary_Bronchitis_Plan_M2                                                  
+ PA_Pulmonary_Bronchitis_Plan_M3                                                  
+ PA_Pulmonary_Bronchitis_Plan_R1                                                  
+ PA_Pulmonary_Bronchitis_Plan_R2                                                  
',v_CaseId,'MP') || '</managementPlan>' || LF;
    v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
    v_Str := v_Str || '        <title>Chronic Airway Obstruction/COPD</title>' || LF;
    v_Str := v_Str || '        <value>' || Get_InfoPathData(' PA_Pulmonary_COPD ',v_CaseId,'TF') || '</value>' || LF;
    v_Str := v_Str || '        <managementPlan>' || Get_InfoPathData('PA_Pulmonary_COPD_Plan_E1                                                  
+ PA_Pulmonary_COPD_Plan_E2                                                  
+ PA_Pulmonary_COPD_Plan_E3                                                  
+ PA_Pulmonary_COPD_Plan_E4                                                  
+ PA_Pulmonary_COPD_Plan_E5                                                  
+ PA_Pulmonary_COPD_Plan_M1                                                  
+ PA_Pulmonary_COPD_Plan_M2                                                  
+ PA_Pulmonary_COPD_Plan_M3                                                  
+ PA_Pulmonary_COPD_Plan_R1                                                  
+ PA_Pulmonary_COPD_Plan_R2                                                  
',v_CaseId,'MP') || '</managementPlan>' || LF;

    v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
    v_Str := v_Str || '        <title>Emphysema</title>' || LF;
    v_Str := v_Str || '        <value>' || Get_InfoPathData(' PA_Pulmonary_Emphysema ',v_CaseId,'TF') || '</value>' || LF;
    v_Str := v_Str || '        <managementPlan>' || Get_InfoPathData('PA_Pulmonary_Emphysema_Plan_E1                                                  
+ PA_Pulmonary_Emphysema_Plan_E2                                                  
+ PA_Pulmonary_Emphysema_Plan_E3                                                  
+ PA_Pulmonary_Emphysema_Plan_E4                                                  
+ PA_Pulmonary_Emphysema_Plan_E5                                                  
+ PA_Pulmonary_Emphysema_Plan_M1                                                  
+ PA_Pulmonary_Emphysema_Plan_M2                                                  
+ PA_Pulmonary_Emphysema_Plan_M3                                                  
+ PA_Pulmonary_Emphysema_Plan_R1                                                  
+ PA_Pulmonary_Emphysema_Plan_R2                                                  
',v_CaseId,'MP') || '</managementPlan>' || LF;

    v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
    v_Str := v_Str || '        <title>Tracheostomy Status (current)</title>' || LF;
    v_Str := v_Str || '        <value>' || Get_InfoPathData(' PA_Pulmonary_Tracheostomy ',v_CaseId,'TF') || '</value>' || LF;
    v_Str := v_Str || '        <managementPlan>' || Get_InfoPathData('PA_Pulmonary_Tracheostomy_Plan_E1                                                  
+ PA_Pulmonary_Tracheostomy_Plan_E2                                                  
+ PA_Pulmonary_Tracheostomy_Plan_E3                                                  
+ PA_Pulmonary_Tracheostomy_Plan_E4                                                  
+ PA_Pulmonary_Tracheostomy_Plan_E5                                                  
+ PA_Pulmonary_Tracheostomy_Plan_M1                                                  
+ PA_Pulmonary_Tracheostomy_Plan_M2                                                  
+ PA_Pulmonary_Tracheostomy_Plan_M3                                                  
+ PA_Pulmonary_Tracheostomy_Plan_R1                                                  
+ PA_Pulmonary_Tracheostomy_Plan_R2                                                  
',v_CaseId,'MP') || '</managementPlan>' || LF;

    v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
    v_Str := v_Str || '        <title>Ventilator Dependent</title>' || LF;
    v_Str := v_Str || '        <value>' || Get_InfoPathData(' PA_Pulmonary_Ventilator ',v_CaseId,'TF') || '</value>' || LF;
    v_Str := v_Str || '        <managementPlan>' || Get_InfoPathData('PA_Pulmonary_Ventilator_Plan_E1                                                  
+ PA_Pulmonary_Ventilator_Plan_E2                                                  
+ PA_Pulmonary_Ventilator_Plan_E3                                                  
+ PA_Pulmonary_Ventilator_Plan_E4                                                  
+ PA_Pulmonary_Ventilator_Plan_E5                                                  
+ PA_Pulmonary_Ventilator_Plan_M1                                                  
+ PA_Pulmonary_Ventilator_Plan_M2                                                  
+ PA_Pulmonary_Ventilator_Plan_M3                                                  
+ PA_Pulmonary_Ventilator_Plan_R1                                                  
+ PA_Pulmonary_Ventilator_Plan_R2                                                  
',v_CaseId,'MP') || '</managementPlan>' || LF;

    v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
    v_Str := v_Str || '        <title>Supplemental O2</title>' || LF;
    v_Str := v_Str || '        <value>' || Get_InfoPathData(' PA_Pulmonary_Supplemental_O2 ',v_CaseId,'TF') || '</value>' || LF;
    v_Str := v_Str || '        <managementPlan>' || Get_InfoPathData('PA_Pulmonary_Supplemental_O2_Plan_E1                                                  
+ PA_Pulmonary_Supplemental_O2_Plan_E2                                                  
+ PA_Pulmonary_Supplemental_O2_Plan_E3                                                  
+ PA_Pulmonary_Supplemental_O2_Plan_E4                                                  
+ PA_Pulmonary_Supplemental_O2_Plan_E5                                                  
+ PA_Pulmonary_Supplemental_O2_Plan_M1                                                  
+ PA_Pulmonary_Supplemental_O2_Plan_M2                                                  
+ PA_Pulmonary_Supplemental_O2_Plan_M3                                                  
+ PA_Pulmonary_Supplemental_O2_Plan_R1                                                  
+ PA_Pulmonary_Supplemental_O2_Plan_R2                                                  
',v_CaseId,'ST') ||
    '</managementPlan>' || LF;

    v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
    v_Str := v_Str || '        <title>Chronic Respiratory Failure</title>' || LF;
    v_Str := v_Str || '        <value>' || Get_InfoPathData(' PA_Pulmonary_Chronic_Respiratory_Failure ',v_CaseId,'TF') || '</value>' || LF;
    v_Str := v_Str || '        <managementPlan>' || Get_InfoPathData(
    'PA_Pulmonary_Respiratory_Failure_Plan_E1                                                  
+ PA_Pulmonary_Respiratory_Failure_Plan_E2                                                  
+ PA_Pulmonary_Respiratory_Failure_Plan_E3                                                  
+ PA_Pulmonary_Respiratory_Failure_Plan_E4                                                  
+ PA_Pulmonary_Respiratory_Failure_Plan_E5                                                  
+ PA_Pulmonary_Respiratory_Failure_Plan_M1                                                  
+ PA_Pulmonary_Respiratory_Failure_Plan_M2                                                  
+ PA_Pulmonary_Respiratory_Failure_Plan_M3                                                  
+ PA_Pulmonary_Respiratory_Failure_Plan_R1                                                  
+ PA_Pulmonary_Respiratory_Failure_Plan_R2                                                  
',v_CaseId,'MP') || '</managementPlan>' || LF;

    v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
    v_Str := v_Str || '        <title>Asthma/Acute Exacerbation</title>' || LF;
    v_Str := v_Str || '        <value>' || Get_InfoPathData(' PA_Pulmonary_Asthma ',v_CaseId,'TF') || '</value>' || LF;
    v_Str := v_Str || '        <followUpQuestions>' || LF;
    v_Str := v_Str || '            <title>Specify:</title>' || LF;
    v_Str := v_Str || '            <answer>' || Get_InfoPathData(' PA_Pulmonary_Asthma_Acute_Exacerbation ',v_CaseId,'ST') || '</answer>' || LF;
    v_Str := v_Str || '            <value>' || Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
    v_Str := v_Str || '        </followUpQuestions>'|| LF;
    v_Str := v_Str || '        <managementPlan>' || Get_InfoPathData('PA_Pulmonary_Asthma_Plan_E1                                                  
+ PA_Pulmonary_Asthma_Plan_E2                                                  
+ PA_Pulmonary_Asthma_Plan_E3                                                  
+ PA_Pulmonary_Asthma_Plan_E4                                                  
+ PA_Pulmonary_Asthma_Plan_E5                                                  
+ PA_Pulmonary_Asthma_Plan_M1                                                  
+ PA_Pulmonary_Asthma_Plan_M2                                                  
+ PA_Pulmonary_Asthma_Plan_M3                                                  
+ PA_Pulmonary_Asthma_Plan_R1                                                  
+ PA_Pulmonary_Asthma_Plan_R2                                                  
',v_CaseId,'MP') || '</managementPlan>' || LF;

    v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
    v_Str := v_Str || '        <title>Other Significant Diagnoses</title>' || LF;
    v_Str := v_Str || '        <value>' || Get_InfoPathData(' PA_Pulmonary_Other ',v_CaseId,'TF') || '</value>' || LF;
    v_Str := v_Str || '        <followUpQuestions>' || LF;
    v_Str := v_Str || '            <title>Other:</title>' || LF;
    v_Str := v_Str || '            <answer>' || Get_InfoPathData(' PA_Pulmonary_Other_Box',v_CaseId,'ST') || '</answer>' || LF;
    v_Str := v_Str || '            <value>' || Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
    v_Str := v_Str || '        </followUpQuestions>'|| LF;
    v_Str := v_Str || '        <managementPlan>' || Get_InfoPathData('PA_Pulmonary_Other_Plan_E1                                                  
+ PA_Pulmonary_Other_Plan_E2                                                  
+ PA_Pulmonary_Other_Plan_E3                                                  
+ PA_Pulmonary_Other_Plan_E4                                                  
+ PA_Pulmonary_Other_Plan_E5                                                  
+ PA_Pulmonary_Other_Plan_M1                                                  
+ PA_Pulmonary_Other_Plan_M2                                                  
+ PA_Pulmonary_Other_Plan_M3                                                  
+ PA_Pulmonary_Other_Plan_R1                                                  
+ PA_Pulmonary_Other_Plan_R2                                                  
',v_CaseId,'MP') || '</managementPlan>' || LF;

    v_Str := v_Str || '   <sections>' || Get_InfoPathData('',v_CaseId,'ST') || '</sections>' || LF;
    v_Str := v_Str || '        <title>Hematology/Oncology</title>' || LF;
    v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
    v_Str := v_Str || '        <title>Anemia</title>' || LF;
    v_Str := v_Str || '        <value>' || Get_InfoPathData('',v_CaseId,'TF') || '</value>' || LF;
    v_Str := v_Str || '        <followUpQuestions>' || LF;
    v_Str := v_Str || '            <title>Type:</title>' || LF;
    v_Str := v_Str || '            <answer>' || Get_InfoPathData(' PA_Hematology_Anemia_Acute ',v_CaseId,'ST') || '</answer>' || LF;
    v_Str := v_Str || '            <value>' || Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
    v_Str := v_Str || '        </followUpQuestions>'|| LF;
    v_Str := v_Str || '        <followUpQuestions>' || LF;
    v_Str := v_Str || '            <title>Type:</title>' || LF;
    v_Str := v_Str || '            <answer>' || Get_InfoPathData(' PA_Hematology_Anemia_CKD ',v_CaseId,'ST') || '</answer>' || LF;
    v_Str := v_Str || '            <value>' || Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
    v_Str := v_Str || '        </followUpQuestions>'|| LF;
    v_Str := v_Str || '        <followUpQuestions>' || LF;
    v_Str := v_Str || '            <title>Type:</title>' || LF;
    v_Str := v_Str || '            <answer>' || Get_InfoPathData(' PA_Hematology_Anemia_Other_Chronic ',v_CaseId,'ST') || '</answer>' || LF;
    v_Str := v_Str || '            <value>' || Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
    v_Str := v_Str || '        </followUpQuestions>'|| LF;
    v_Str := v_Str || '        <followUpQuestions>' || LF;
    v_Str := v_Str || '            <title>Type:</title>' || LF;
    v_Str := v_Str || '            <answer>' || Get_InfoPathData(' PA_Hematology_Anemia_Aplastic ',v_CaseId,'ST') || '</answer>' || LF;
    v_Str := v_Str || '            <value>' || Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
    v_Str := v_Str || '        </followUpQuestions>'|| LF;
    v_Str := v_Str || '        <followUpQuestions>' || LF;
    v_Str := v_Str || '            <title>Type:</title>' || LF;
    v_Str := v_Str || '            <answer>' || Get_InfoPathData(' PA_Hematology_Anemia_Iron_Deficiency ',v_CaseId,'ST') || '</answer>' || LF;
    v_Str := v_Str || '            <value>' || Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
    v_Str := v_Str || '        </followUpQuestions>'|| LF;
    v_Str := v_Str || '        <followUpQuestions>' || LF;
    v_Str := v_Str || '            <title>Type:</title>' || LF;
    v_Str := v_Str || '            <answer>' || Get_InfoPathData(' PA_Hematology_Anemia_Unknown ',v_CaseId,'ST') || '</answer>' || LF;
    v_Str := v_Str || '            <value>' || Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
    v_Str := v_Str || '        </followUpQuestions>'|| LF;
    v_Str := v_Str || '        <managementPlan>' || Get_InfoPathData('PA_Hematology_Anemia_Plan_E1                                                  
+ PA_Hematology_Anemia_Plan_E2                                                  
+ PA_Hematology_Anemia_Plan_E3                                                  
+ PA_Hematology_Anemia_Plan_E4                                                  
+ PA_Hematology_Anemia_Plan_E5                                                  
+ PA_Hematology_Anemia_Plan_M1                                                  
+ PA_Hematology_Anemia_Plan_M2                                                  
+ PA_Hematology_Anemia_Plan_M3                                                  
+ PA_Hematology_Anemia_Plan_R1                                                  
+ PA_Hematology_Anemia_Plan_R2                                                  
',v_CaseId,'MP') || '</managementPlan>' || LF;

    v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
    v_Str := v_Str || '        <title>Hemolytic Anemia</title>' || LF;
    v_Str := v_Str || '        <value>' || Get_InfoPathData('',v_CaseId,'TF') || '</value>' || LF;
    v_Str := v_Str || '        <followUpQuestions>' || LF;
    v_Str := v_Str || '            <title>Type:</title>' || LF;
    v_Str := v_Str || '            <answer>' || Get_InfoPathData(' PA_Hematology_Hemolytic_Anemia_Autoimmune ',v_CaseId,'ST') || '</answer>' || LF;
    v_Str := v_Str || '            <value>' || Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
    v_Str := v_Str || '        </followUpQuestions>'|| LF;
    v_Str := v_Str || '        <followUpQuestions>' || LF;
    v_Str := v_Str || '            <title>Type:</title>' || LF;
    v_Str := v_Str || '            <answer>' || Get_InfoPathData(' PA_Hematology_Hemolytic_Anemia_NonAutoimmune ',v_CaseId,'ST') || '</answer>' || LF;
    v_Str := v_Str || '            <value>' || Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
    v_Str := v_Str || '        </followUpQuestions>'|| LF;
    v_Str := v_Str || '        <followUpQuestions>' || LF;
    v_Str := v_Str || '            <title>Class:</title>' || LF;
    v_Str := v_Str || '            <answer>' || Get_InfoPathData(' PA_Hematology_Neutropenia ',v_CaseId,'ST') || '</answer>' || LF;
    v_Str := v_Str || '            <value>' || Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
    v_Str := v_Str || '        </followUpQuestions>'|| LF;
    v_Str := v_Str || '        <followUpQuestions>' || LF;
    v_Str := v_Str || '            <title>Class:</title>' || LF;
    v_Str := v_Str || '            <answer>' || Get_InfoPathData(' PA_Hematology_Agranulocytosis ',v_CaseId,'ST') || '</answer>' || LF;
    v_Str := v_Str || '            <value>' || Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
    v_Str := v_Str || '        </followUpQuestions>'|| LF;
    v_Str := v_Str || '        <followUpQuestions>' || LF;
    v_Str := v_Str || '            <title>Class:</title>' || LF;
    v_Str := v_Str || '            <answer>' || Get_InfoPathData(' PA_Hematology_Pancytopenia ',v_CaseId,'ST') || '</answer>' || LF;
    v_Str := v_Str || '            <value>' || Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
    v_Str := v_Str || '        </followUpQuestions>'|| LF;
    v_Str := v_Str || '        <managementPlan>' || Get_InfoPathData(
    'PA_Hematology_Hemolytic_Anemia_Plan_E1                                                  
+ PA_Hematology_Hemolytic_Anemia_Plan_E2                                                  
+ PA_Hematology_Hemolytic_Anemia_Plan_E3                                                  
+ PA_Hematology_Hemolytic_Anemia_Plan_E4                                                  
+ PA_Hematology_Hemolytic_Anemia_Plan_E5                                                  
+ PA_Hematology_Hemolytic_Anemia_Plan_M1                                                  
+ PA_Hematology_Hemolytic_Anemia_Plan_M2                                                  
+ PA_Hematology_Hemolytic_Anemia_Plan_M3                                                  
+ PA_Hematology_Hemolytic_Anemia_Plan_R1                                                  
+ PA_Hematology_Hemolytic_Anemia_Plan_R2                                                  
+ PA_Hematology_Neutropenia_Plan_E1                                                  
+ PA_Hematology_Neutropenia_Plan_E2                                                  
+ PA_Hematology_Neutropenia_Plan_E3                                                  
+ PA_Hematology_Neutropenia_Plan_E4                                                  
+ PA_Hematology_Neutropenia_Plan_E5                                                  
+ PA_Hematology_Neutropenia_Plan_M1                                                  
+ PA_Hematology_Neutropenia_Plan_M2                                                  
+ PA_Hematology_Neutropenia_Plan_M3                                                  
+ PA_Hematology_Neutropenia_Plan_R1                                                  
+ PA_Hematology_Neutropenia_Plan_R2 ',v_CaseId,'MP') || '</managementPlan>' || LF;

    v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
    v_Str := v_Str || '        <title>Thrombocytopenia</title>' || LF;
    v_Str := v_Str || '        <value>' || Get_InfoPathData(' PA_Hematology_Thrombocytopenia ',v_CaseId,'TF') || '</value>' || LF;
    v_Str := v_Str || '        <managementPlan>' || Get_InfoPathData('PA_Hematology_Thrombocytopenia_Plan_E1                                                  
+ PA_Hematology_Thrombocytopenia_Plan_E2                                                  
+ PA_Hematology_Thrombocytopenia_Plan_E3                                                  
+ PA_Hematology_Thrombocytopenia_Plan_E4                                                  
+ PA_Hematology_Thrombocytopenia_Plan_E5                                                  
+ PA_Hematology_Thrombocytopenia_Plan_M1                                                  
+ PA_Hematology_Thrombocytopenia_Plan_M2                                                  
+ PA_Hematology_Thrombocytopenia_Plan_M3                                                  
+ PA_Hematology_Thrombocytopenia_Plan_R1                                                  
+ PA_Hematology_Thrombocytopenia_Plan_R2                                                  
',v_CaseId
    ,'ST') || '</managementPlan>' || LF;

    v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
    v_Str := v_Str || '        <title>B12 Deficiency</title>' || LF;
    v_Str := v_Str || '        <value>' || Get_InfoPathData(' PA_Hematology_B12_Deficiency ',v_CaseId,'TF') || '</value>' || LF;
    v_Str := v_Str || '        <managementPlan>' || Get_InfoPathData('PA_Hematology_B12_Deficiency_Plan_E1                                                  
+ PA_Hematology_B12_Deficiency_Plan_E2                                                  
+ PA_Hematology_B12_Deficiency_Plan_E3                                                  
+ PA_Hematology_B12_Deficiency_Plan_E4                                                  
+ PA_Hematology_B12_Deficiency_Plan_E5                                                  
+ PA_Hematology_B12_Deficiency_Plan_M1                                                  
+ PA_Hematology_B12_Deficiency_Plan_M2                                                  
+ PA_Hematology_B12_Deficiency_Plan_M3                                                  
+ PA_Hematology_B12_Deficiency_Plan_R1                                                  
+ PA_Hematology_B12_Deficiency_Plan_R2                                                  
',v_CaseId,'ST') ||
    '</managementPlan>' || LF;

    v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
    v_Str := v_Str || '        <title>Leukemia</title>' || LF;
    v_Str := v_Str || '        <value>' || Get_InfoPathData(' PA_Hematology_Leukemia ',v_CaseId,'TF') || '</value>' || LF;
    v_Str := v_Str || '        <followUpQuestions>' || LF;
    v_Str := v_Str || '            <title>Type:</title>' || LF;
    v_Str := v_Str || '            <answer>' || Get_InfoPathData(' PA_Hematology_Leukemia_Box ',v_CaseId,'ST') || '</answer>' || LF;
    v_Str := v_Str || '            <value>' || Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
    v_Str := v_Str || '        </followUpQuestions>'|| LF;
    v_Str := v_Str || '        <followUpQuestions>' || LF;
    v_Str := v_Str || '            <title>State:</title>' || LF;
    v_Str := v_Str || '            <answer>' || Get_InfoPathData('PA_Hematology_Leukemia_Active 
+ PA_Hematology_Leukemia_Relapse 
+ PA_Hematology_Leukemia_Remission
',v_CaseId,'ST') || '</answer>' || LF;
    v_Str := v_Str || '            <value>' || Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
    v_Str := v_Str || '        </followUpQuestions>'|| LF;
    v_Str := v_Str || '        <managementPlan>' || Get_InfoPathData('PA_Hematology_Leukemia_Plan_E1                                                  
+ PA_Hematology_Leukemia_Plan_E2                                                  
+ PA_Hematology_Leukemia_Plan_E3                                                  
+ PA_Hematology_Leukemia_Plan_E4                                                  
+ PA_Hematology_Leukemia_Plan_E5                                                  
+ PA_Hematology_Leukemia_Plan_M1                                                  
+ PA_Hematology_Leukemia_Plan_M2                                                  
+ PA_Hematology_Leukemia_Plan_M3                                                  
+ PA_Hematology_Leukemia_Plan_R1                                                  
+ PA_Hematology_Leukemia_Plan_R2                                                  
',v_CaseId,'MP') || '</managementPlan>' || LF;

    v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
    v_Str := v_Str || '        <title>Lymphoma</title>' || LF;
    v_Str := v_Str || '        <value>' || Get_InfoPathData(' PA_Hematology_Lymphoma ',v_CaseId,'TF') || '</value>' || LF;
    v_Str := v_Str || '        <followUpQuestions>' || LF;
    v_Str := v_Str || '            <title>Type:</title>' || LF;
    v_Str := v_Str || '            <answer>' || Get_InfoPathData(' PA_Hematology_Lymphoma_Box ',v_CaseId,'ST') || '</answer>' || LF;
    v_Str := v_Str || '            <value>' || Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
    v_Str := v_Str || '        </followUpQuestions>'|| LF;
    v_Str := v_Str || '        <followUpQuestions>' || LF;
    v_Str := v_Str || '            <title>State:</title>' || LF;
    v_Str := v_Str || '            <answer>' || Get_InfoPathData('PA_Hematology_Lymphoma_Active 
+ PA_Hematology_Lymphoma_Remission
',v_CaseId,'ST') || '</answer>' || LF;
    v_Str := v_Str || '            <value>' || Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
    v_Str := v_Str || '        </followUpQuestions>'|| LF;
    v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
    v_Str := v_Str || '        <title>Benign neoplasm of Brain or Meninges</title>' || LF;
    v_Str := v_Str || '        <value>' || Get_InfoPathData(' PA_Hematology_Benign_Neoplasm_Brain ',v_CaseId,'TF') || '</value>' || LF;
    v_Str := v_Str || '        <managementPlan>' || Get_InfoPathData(
    'PA_Hematology_Benign_Neoplasm_Brain_Plan_E1                                                  
+ PA_Hematology_Benign_Neoplasm_Brain_Plan_E2                                                  
+ PA_Hematology_Benign_Neoplasm_Brain_Plan_E3                                                  
+ PA_Hematology_Benign_Neoplasm_Brain_Plan_E4                                                  
+ PA_Hematology_Benign_Neoplasm_Brain_Plan_E5                                                  
+ PA_Hematology_Benign_Neoplasm_Brain_Plan_M1                                                  
+ PA_Hematology_Benign_Neoplasm_Brain_Plan_M2                                                  
+ PA_Hematology_Benign_Neoplasm_Brain_Plan_M3                                                  
+ PA_Hematology_Benign_Neoplasm_Brain_Plan_R1                                                  
+ PA_Hematology_Benign_Neoplasm_Brain_Plan_R2                                                  
',v_CaseId,'ST') ||
    '</managementPlan>' || LF;

    v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
    v_Str := v_Str || '        <title>Bone Marrow Transplant Status</title>' || LF;
    v_Str := v_Str || '        <value>' || Get_InfoPathData(' PA_Hematology_Bone_Marrow ',v_CaseId,'TF') || '</value>' || LF;
    v_Str := v_Str || '        <managementPlan>' || Get_InfoPathData('PA_Hematology_Bone_Marrow_Plan_E1                                                  
+ PA_Hematology_Bone_Marrow_Plan_E2                                                  
+ PA_Hematology_Bone_Marrow_Plan_E3                                                  
+ PA_Hematology_Bone_Marrow_Plan_E4                                                  
+ PA_Hematology_Bone_Marrow_Plan_E5                                                  
+ PA_Hematology_Bone_Marrow_Plan_M1                                                  
+ PA_Hematology_Bone_Marrow_Plan_M2                                                  
+ PA_Hematology_Bone_Marrow_Plan_M3                                                  
+ PA_Hematology_Bone_Marrow_Plan_R1                                                  
+ PA_Hematology_Bone_Marrow_Plan_R2                                                  
',v_CaseId,'MP') || '</managementPlan>' || LF;

    v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
    v_Str := v_Str || '        <title>Long Term (Current) Use of Anticoagulants (excluding Aspirin)</title>' || LF;
    v_Str := v_Str || '        <value>' || Get_InfoPathData(' PA_Hematology_Long_Anticoagulants ',v_CaseId,'TF') || '</value>' || LF;
    v_Str := v_Str || '        <managementPlan>' || Get_InfoPathData(
    'PA_Hematology_Long_Anticoagulants_Plan_E1                                                  
+ PA_Hematology_Long_Anticoagulants_Plan_E2                                                  
+ PA_Hematology_Long_Anticoagulants_Plan_E3                                                  
+ PA_Hematology_Long_Anticoagulants_Plan_E4                                                  
+ PA_Hematology_Long_Anticoagulants_Plan_E5                                                  
+ PA_Hematology_Long_Anticoagulants_Plan_M1                                                  
+ PA_Hematology_Long_Anticoagulants_Plan_M2                                                  
+ PA_Hematology_Long_Anticoagulants_Plan_M3                                                  
+ PA_Hematology_Long_Anticoagulants_Plan_R1                                                  
+ PA_Hematology_Long_Anticoagulants_Plan_R2                                                  
',v_CaseId,'ST') || '</managementPlan>' || LF
    ;

    v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
    v_Str := v_Str || '        <title>Long Term (Current) Use of Aspirin</title>' || LF;
    v_Str := v_Str || '        <value>' || Get_InfoPathData(' PA_Hematology_Long_Aspirin ',v_CaseId,'TF') || '</value>' || LF;
    v_Str := v_Str || '        <managementPlan>' || Get_InfoPathData('PA_Hematology_Long_Aspirin_Plan_E1                                                  
+ PA_Hematology_Long_Aspirin_Plan_E2                                                  
+ PA_Hematology_Long_Aspirin_Plan_E3                                                  
+ PA_Hematology_Long_Aspirin_Plan_E4                                                  
+ PA_Hematology_Long_Aspirin_Plan_E5                                                  
+ PA_Hematology_Long_Aspirin_Plan_M1                                                  
+ PA_Hematology_Long_Aspirin_Plan_M2                                                  
+ PA_Hematology_Long_Aspirin_Plan_M3                                                  
+ PA_Hematology_Long_Aspirin_Plan_R1                                                  
+ PA_Hematology_Long_Aspirin_Plan_R2                                                  
',v_CaseId,'MP') || '</managementPlan>' || LF;

    v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
    v_Str := v_Str || '        <title>Long Term (Current) Use of Antiplatelet/Antithrombotic</title>' || LF;
    v_Str := v_Str || '        <value>' || Get_InfoPathData(' PA_Hematology_Long_Antiplatelet ',v_CaseId,'TF') || '</value>' || LF;
    v_Str := v_Str || '        <managementPlan>' || Get_InfoPathData(
    'PA_Hematology_Long_Antiplatelet_Plan_E1                                                  
+ PA_Hematology_Long_Antiplatelet_Plan_E2                                                  
+ PA_Hematology_Long_Antiplatelet_Plan_E3                                                  
+ PA_Hematology_Long_Antiplatelet_Plan_E4                                                  
+ PA_Hematology_Long_Antiplatelet_Plan_E5                                                  
+ PA_Hematology_Long_Antiplatelet_Plan_M1                                                  
+ PA_Hematology_Long_Antiplatelet_Plan_M2                                                  
+ PA_Hematology_Long_Antiplatelet_Plan_M3                                                  
+ PA_Hematology_Long_Antiplatelet_Plan_R1                                                  
+ PA_Hematology_Long_Antiplatelet_Plan_R2                                                  
',v_CaseId,'MP') || '</managementPlan>' || LF;

    v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
    v_Str := v_Str || '        <title>Long Term (Current) Steroid Use</title>' || LF;
    v_Str := v_Str || '        <value>' || Get_InfoPathData(' PA_Hematology_Long_Steriod ',v_CaseId,'TF') || '</value>' || LF;
    v_Str := v_Str || '        <managementPlan>' || Get_InfoPathData('PA_Hematology_Long_Steriod_Plan_E1                                                  
+ PA_Hematology_Long_Steriod_Plan_E2                                                  
+ PA_Hematology_Long_Steriod_Plan_E3                                                  
+ PA_Hematology_Long_Steriod_Plan_E4                                                  
+ PA_Hematology_Long_Steriod_Plan_E5                                                  
+ PA_Hematology_Long_Steriod_Plan_M1                                                  
+ PA_Hematology_Long_Steriod_Plan_M2                                                  
+ PA_Hematology_Long_Steriod_Plan_M3                                                  
+ PA_Hematology_Long_Steriod_Plan_R1                                                  
+ PA_Hematology_Long_Steriod_Plan_R2                                                  
',v_CaseId,'MP') || '</managementPlan>' || LF;

    v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
    v_Str := v_Str || '        <title>Other Significant Diagnoses:</title>' || LF;
    v_Str := v_Str || '        <value>' || Get_InfoPathData(' PA_Hematology_Other ',v_CaseId,'TF') || '</value>' || LF;
    v_Str := v_Str || '        <followUpQuestions>' || LF;
    v_Str := v_Str || '            <title>Other</title>' || LF;
    v_Str := v_Str || '            <answer>' || Get_InfoPathData(' PA_Hematology_Other_Box',v_CaseId,'ST') || '</answer>' || LF;
    v_Str := v_Str || '            <value>' || Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
    v_Str := v_Str || '        </followUpQuestions>'|| LF;
    v_Str := v_Str || '        <managementPlan>' || Get_InfoPathData('PA_Hematology_Other_Plan_E1                                                  
+ PA_Hematology_Other_Plan_E2                                                  
+ PA_Hematology_Other_Plan_E3                                                  
+ PA_Hematology_Other_Plan_E4                                                  
+ PA_Hematology_Other_Plan_E5                                                  
+ PA_Hematology_Other_Plan_M1                                                  
+ PA_Hematology_Other_Plan_M2                                                  
+ PA_Hematology_Other_Plan_M3                                                  
+ PA_Hematology_Other_Plan_R1                                                  
+ PA_Hematology_Other_Plan_R2                                                  
',v_CaseId,'MP') || '</managementPlan>' || LF;

    v_Str := v_Str || '   <sections>' || Get_InfoPathData('',v_CaseId,'ST') || '</sections>' || LF;
    v_Str := v_Str || '        <title>Endocrine</title>' || LF;
    v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
    v_Str := v_Str || '        <title>Hyperlipidemia</title>' || LF;
    v_Str := v_Str || '        <value>' || Get_InfoPathData(' PA_Endoctrine_Hyperlipidemia ',v_CaseId,'TF') || '</value>' || LF;
    v_Str := v_Str || '        <subDiagnosis>' || LF;
    v_Str := v_Str || '            <title>Hypothyroidism</title>' || LF;
    v_Str := v_Str || '            <value>' || Get_InfoPathData(' PA_Endoctrine_Hypothyroidism ',v_CaseId,'TF') || '</value>' || LF;
    v_Str := v_Str || '            <managementPlan>' || Get_InfoPathData('PA_Endoctrine_Hypothyroidism_Plan_E1                                                  
+ PA_Endoctrine_Hypothyroidism_Plan_E2                                                  
+ PA_Endoctrine_Hypothyroidism_Plan_E3                                                  
+ PA_Endoctrine_Hypothyroidism_Plan_E4                                                  
+ PA_Endoctrine_Hypothyroidism_Plan_E5                                                  
+ PA_Endoctrine_Hypothyroidism_Plan_M1                                                  
+ PA_Endoctrine_Hypothyroidism_Plan_M2                                                  
+ PA_Endoctrine_Hypothyroidism_Plan_M3                                                  
+ PA_Endoctrine_Hypothyroidism_Plan_R1                                                  
+ PA_Endoctrine_Hypothyroidism_Plan_R2                                                  
',v_CaseId,'ST') ||
    '</managementPlan>' || LF;
    v_Str := v_Str || '        </subDiagnosis>' || LF;
    v_Str := v_Str || '        <managementPlan>' || Get_InfoPathData('PA_Endoctrine_Hyperlipidemia_Plan_E1                                                  
+ PA_Endoctrine_Hyperlipidemia_Plan_E2                                                  
+ PA_Endoctrine_Hyperlipidemia_Plan_E3                                                  
+ PA_Endoctrine_Hyperlipidemia_Plan_E4                                                  
+ PA_Endoctrine_Hyperlipidemia_Plan_E5                                                  
+ PA_Endoctrine_Hyperlipidemia_Plan_M1                                                  
+ PA_Endoctrine_Hyperlipidemia_Plan_M2                                                  
+ PA_Endoctrine_Hyperlipidemia_Plan_M3                                                  
+ PA_Endoctrine_Hyperlipidemia_Plan_R1                                                  
+ PA_Endoctrine_Hyperlipidemia_Plan_R2                                                  
',v_CaseId,'ST') ||
    '</managementPlan>' || LF;

    v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
    v_Str := v_Str || '        <title>Cachexia</title>' || LF;
    v_Str := v_Str || '        <value>' || Get_InfoPathData(' PA_Endoctrine_Cachexia ',v_CaseId,'TF') || '</value>' || LF;
    v_Str := v_Str || '        <managementPlan>' || Get_InfoPathData('PA_Endoctrine_Cachexia_Plan_E1                                                  
+ PA_Endoctrine_Cachexia_Plan_E2                                                  
+ PA_Endoctrine_Cachexia_Plan_E3                                                  
+ PA_Endoctrine_Cachexia_Plan_E4                                                  
+ PA_Endoctrine_Cachexia_Plan_E5                                                  
+ PA_Endoctrine_Cachexia_Plan_M1                                                  
+ PA_Endoctrine_Cachexia_Plan_M2                                                  
+ PA_Endoctrine_Cachexia_Plan_M3                                                  
+ PA_Endoctrine_Cachexia_Plan_R1                                                  
+ PA_Endoctrine_Cachexia_Plan_R2                                                  
',v_CaseId,'MP') || '</managementPlan>' || LF;

    v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
    v_Str := v_Str || '        <title>Hypoalbuminemia</title>' || LF;
    v_Str := v_Str || '        <value>' || Get_InfoPathData(' PA_Endoctrine_Hypoalbuminemia ',v_CaseId,'TF') || '</value>' || LF;
    v_Str := v_Str || '        <managementPlan>' || Get_InfoPathData('PA_Endoctrine_Hypoalbuminemia_Plan_E1                                                  
+ PA_Endoctrine_Hypoalbuminemia_Plan_E2                                                  
+ PA_Endoctrine_Hypoalbuminemia_Plan_E3                                                  
+ PA_Endoctrine_Hypoalbuminemia_Plan_E4                                                  
+ PA_Endoctrine_Hypoalbuminemia_Plan_E5                                                  
+ PA_Endoctrine_Hypoalbuminemia_Plan_M1                                                  
+ PA_Endoctrine_Hypoalbuminemia_Plan_M2                                                  
+ PA_Endoctrine_Hypoalbuminemia_Plan_M3                                                  
+ PA_Endoctrine_Hypoalbuminemia_Plan_R1                                                  
+ PA_Endoctrine_Hypoalbuminemia_Plan_R2                                                  
',v_CaseId,'ST') ||
    '</managementPlan>' || LF;

    v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
    v_Str := v_Str || '        <title>Other Significant Diagnoses:</title>' || LF;
    v_Str := v_Str || '        <value>' || Get_InfoPathData(' PA_Endoctrine_Other ',v_CaseId,'TF') || '</value>' || LF;
    v_Str := v_Str || '        <followUpQuestions>' || LF;
    v_Str := v_Str || '        <title>Other:</title>' || LF;
    v_Str := v_Str || '        <answer>' || Get_InfoPathData(' PA_Endoctrine_Other_Box',v_CaseId,'ST') || '</answer>' || LF;
    v_Str := v_Str || '        <value>' || Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
    v_Str := v_Str || '        </followUpQuestions>'|| LF;
    v_Str := v_Str || '        <managementPlan>' || Get_InfoPathData('PA_Endoctrine_Other_Plan_E1                                                  
+ PA_Endoctrine_Other_Plan_E2                                                  
+ PA_Endoctrine_Other_Plan_E3                                                  
+ PA_Endoctrine_Other_Plan_E4                                                  
+ PA_Endoctrine_Other_Plan_E5                                                  
+ PA_Endoctrine_Other_Plan_M1                                                  
+ PA_Endoctrine_Other_Plan_M2                                                  
+ PA_Endoctrine_Other_Plan_M3                                                  
+ PA_Endoctrine_Other_Plan_R1                                                  
+ PA_Endoctrine_Other_Plan_R2                                                  
',v_CaseId,'MP') || '</managementPlan>' || LF;

    v_Str := v_Str || '   <sections>' || Get_InfoPathData('',v_CaseId,'ST') || '</sections>' || LF;
    v_Str := v_Str || '        <title>Gastrointestinal</title>' || LF;
    v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
    v_Str := v_Str || '        <title>Esophageal Retlux (GERD)</title>' || LF;
    v_Str := v_Str || '        <value>' || Get_InfoPathData(' PA_Gastrointestinal_Gerd ',v_CaseId,'TF') || '</value>' || LF;
    v_Str := v_Str || '        <managementPlan>' || Get_InfoPathData('PA_Gastrointestinal_Gerd_Plan_E1                                                  
+ PA_Gastrointestinal_Gerd_Plan_E2                                                  
+ PA_Gastrointestinal_Gerd_Plan_E3                                                  
+ PA_Gastrointestinal_Gerd_Plan_E4                                                  
+ PA_Gastrointestinal_Gerd_Plan_E5                                                  
+ PA_Gastrointestinal_Gerd_Plan_M1                                                  
+ PA_Gastrointestinal_Gerd_Plan_M2                                                  
+ PA_Gastrointestinal_Gerd_Plan_M3                                                  
+ PA_Gastrointestinal_Gerd_Plan_R1                                                  
+ PA_Gastrointestinal_Gerd_Plan_R2                                                  
',v_CaseId,'MP') || '</managementPlan>' || LF;
    v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
    v_Str := v_Str || '        <title>Peptic Ulcer Disease (PUD)</title>' || LF;
    v_Str := v_Str || '        <value>' || Get_InfoPathData(' PA_Gastrointestinal_PUD ',v_CaseId,'TF') || '</value>' || LF;
    v_Str := v_Str || '        <managementPlan>' || Get_InfoPathData('PA_Gastrointestinal_PUD_Plan_E1                                                  
+ PA_Gastrointestinal_PUD_Plan_E2                                                  
+ PA_Gastrointestinal_PUD_Plan_E3                                                  
+ PA_Gastrointestinal_PUD_Plan_E4                                                  
+ PA_Gastrointestinal_PUD_Plan_E5                                                  
+ PA_Gastrointestinal_PUD_Plan_M1                                                  
+ PA_Gastrointestinal_PUD_Plan_M2                                                  
+ PA_Gastrointestinal_PUD_Plan_M3                                                  
+ PA_Gastrointestinal_PUD_Plan_R1                                                  
+ PA_Gastrointestinal_PUD_Plan_R2                                                  
',v_CaseId,'MP') || '</managementPlan>' || LF;

    v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
    v_Str := v_Str || '        <title>Gastritis</title>' || LF;
    v_Str := v_Str || '        <value>' || Get_InfoPathData('',v_CaseId,'TF') || '</value>' || LF;
    v_Str := v_Str || '        <followUpQuestions>' || LF;
    v_Str := v_Str || '            <title>Type:</title>' || LF;
    v_Str := v_Str || '            <answer>' || Get_InfoPathData(' PA_Gastrointestinal_Gastritis_Active ',v_CaseId,'ST') || '</answer>' || LF;
    v_Str := v_Str || '            <value>' || Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
    v_Str := v_Str || '        </followUpQuestions>'|| LF;
    v_Str := v_Str || '        <followUpQuestions>' || LF;
    v_Str := v_Str || '            <title>Type:</title>' || LF;
    v_Str := v_Str || '            <answer>' || Get_InfoPathData(' PA_Gastrointestinal_Gastritis_Chronic ',v_CaseId,'ST') || '</answer>' || LF;
    v_Str := v_Str || '            <value>' || Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
    v_Str := v_Str || '        </followUpQuestions>'|| LF;
    v_Str := v_Str || '        <managementPlan>' || Get_InfoPathData('PA_Gastrointestinal_Gastritis_Plan_E1                                                  
+ PA_Gastrointestinal_Gastritis_Plan_E2                                                  
+ PA_Gastrointestinal_Gastritis_Plan_E3                                                  
+ PA_Gastrointestinal_Gastritis_Plan_E4                                                  
+ PA_Gastrointestinal_Gastritis_Plan_E5                                                  
+ PA_Gastrointestinal_Gastritis_Plan_M1                                                  
+ PA_Gastrointestinal_Gastritis_Plan_M2                                                  
+ PA_Gastrointestinal_Gastritis_Plan_M3                                                  
+ PA_Gastrointestinal_Gastritis_Plan_R1                                                  
+ PA_Gastrointestinal_Gastritis_Plan_R2                                                  
',v_CaseId,'ST') ||
    '</managementPlan>' || LF;

    v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
    v_Str := v_Str || '        <title>Croh''s disease</title>' || LF;
    v_Str := v_Str || '        <value>' || Get_InfoPathData(' PA_Gastrointestinal_Crohns ',v_CaseId,'TF') || '</value>' || LF;
    v_Str := v_Str || '        <managementPlan>' || Get_InfoPathData('PA_Gastrointestinal_Crohns_Plan_E1                                                  
+ PA_Gastrointestinal_Crohns_Plan_E2                                                  
+ PA_Gastrointestinal_Crohns_Plan_E3                                                  
+ PA_Gastrointestinal_Crohns_Plan_E4                                                  
+ PA_Gastrointestinal_Crohns_Plan_E5                                                  
+ PA_Gastrointestinal_Crohns_Plan_M1                                                  
+ PA_Gastrointestinal_Crohns_Plan_M2                                                  
+ PA_Gastrointestinal_Crohns_Plan_M3                                                  
+ PA_Gastrointestinal_Crohns_Plan_R1                                                  
+ PA_Gastrointestinal_Crohns_Plan_R2                                                  
',v_CaseId,'MP') || '</managementPlan>' || LF;

    v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
    v_Str := v_Str || '        <title>Ulcerative Colitis</title>' || LF;
    v_Str := v_Str || '        <value>' || Get_InfoPathData(' PA_Gastrointestinal_Ulcerative_Colitis ',v_CaseId,'TF') || '</value>' || LF;
    v_Str := v_Str || '        <managementPlan></managementPlan>' || LF;
    v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
    v_Str := v_Str || '        <title>Diarrhea</title>' || LF;
    v_Str := v_Str || '        <value>' || Get_InfoPathData(' PA_Gastrointestinal_Diarrhea ',v_CaseId,'TF') || '</value>' || LF;
    v_Str := v_Str || '        <managementPlan>' || Get_InfoPathData('PA_Gastrointestinal_Diarrhea_Plan_E1                                                  
+ PA_Gastrointestinal_Diarrhea_Plan_E2                                                  
+ PA_Gastrointestinal_Diarrhea_Plan_E3                                                  
+ PA_Gastrointestinal_Diarrhea_Plan_E4                                                  
+ PA_Gastrointestinal_Diarrhea_Plan_E5                                                  
+ PA_Gastrointestinal_Diarrhea_Plan_M1                                                  
+ PA_Gastrointestinal_Diarrhea_Plan_M2                                                  
+ PA_Gastrointestinal_Diarrhea_Plan_M3                                                  
+ PA_Gastrointestinal_Diarrhea_Plan_R1                                                  
+ PA_Gastrointestinal_Diarrhea_Plan_R2                                                  
',v_CaseId,'ST') ||
    '</managementPlan>' || LF;

    v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
    v_Str := v_Str || '        <title>C. Dif. Colitis</title>' || LF;
    v_Str := v_Str || '        <value>' || Get_InfoPathData(' PA_Gastrointestinal_cdifcolitis ',v_CaseId,'TF') || '</value>' || LF;
    v_Str := v_Str || '        <managementPlan></managementPlan>' || LF;
    v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
    v_Str := v_Str || '        <title>Chronic Hepatitis</title>' || LF;
    v_Str := v_Str || '        <value>' || Get_InfoPathData('',v_CaseId,'TF') || '</value>' || LF;
    v_Str := v_Str || '        <followUpQuestions>' || LF;
    v_Str := v_Str || '            <title>Type:</title>' || LF;
    v_Str := v_Str || '            <answer>' || Get_InfoPathData(' PA_Gastrointestinal_Hepatitis_B ',v_CaseId,'ST') || '</answer>' || LF;
    v_Str := v_Str || '            <value>' || Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
    v_Str := v_Str || '        </followUpQuestions>'|| LF;
    v_Str := v_Str || '        <followUpQuestions>' || LF;
    v_Str := v_Str || '            <title>Type:</title>' || LF;
    v_Str := v_Str || '            <answer>' || Get_InfoPathData(' PA_Gastrointestinal_Hepatitis_C ',v_CaseId,'ST') || '</answer>' || LF;
    v_Str := v_Str || '            <value>' || Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
    v_Str := v_Str || '        </followUpQuestions>'|| LF;
    v_Str := v_Str || '        <managementPlan>' || Get_InfoPathData('PA_Gastrointestinal_Hepatitis_Plan_E1                                                  
+ PA_Gastrointestinal_Hepatitis_Plan_E2                                                  
+ PA_Gastrointestinal_Hepatitis_Plan_E3                                                  
+ PA_Gastrointestinal_Hepatitis_Plan_E4                                                  
+ PA_Gastrointestinal_Hepatitis_Plan_E5                                                  
+ PA_Gastrointestinal_Hepatitis_Plan_M1                                                  
+ PA_Gastrointestinal_Hepatitis_Plan_M2                                                  
+ PA_Gastrointestinal_Hepatitis_Plan_M3                                                  
+ PA_Gastrointestinal_Hepatitis_Plan_R1                                                  
+ PA_Gastrointestinal_Hepatitis_Plan_R2                                                  
',v_CaseId,'ST') ||
    '</managementPlan>' || LF;

    v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
    v_Str := v_Str || '        <title>Constipation</title>' || LF;
    v_Str := v_Str || '        <value>' || Get_InfoPathData(' PA_Gastrointestinal_Constipation ',v_CaseId,'TF') || '</value>' || LF;
    v_Str := v_Str || '        <managementPlan>' || Get_InfoPathData(
    'PA_Gastrointestinal_Constipation_Plan_E1                                                  
+ PA_Gastrointestinal_Constipation_Plan_E2                                                  
+ PA_Gastrointestinal_Constipation_Plan_E3                                                  
+ PA_Gastrointestinal_Constipation_Plan_E4                                                  
+ PA_Gastrointestinal_Constipation_Plan_E5                                                  
+ PA_Gastrointestinal_Constipation_Plan_M1                                                  
+ PA_Gastrointestinal_Constipation_Plan_M2                                                  
+ PA_Gastrointestinal_Constipation_Plan_M3                                                  
+ PA_Gastrointestinal_Constipation_Plan_R1                                                  
+ PA_Gastrointestinal_Constipation_Plan_R2                                                  
',v_CaseId,'MP') || '</managementPlan>' || LF;

    v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
    v_Str := v_Str || '        <title>Diverticulosis without Hemorrhage</title>' || LF;
    v_Str := v_Str || '        <value>' || Get_InfoPathData(' PA_Gastrointestinal_Diverticulosis_Without ',v_CaseId,'TF') || '</value>' || LF;
    v_Str := v_Str || '        <followUpQuestions>' || LF;
    v_Str := v_Str || '            <title>Type:</title>' || LF;
    v_Str := v_Str || '            <answer>' || Get_InfoPathData(' PA_Gastrointestinal_Alcoholic_Cirrhosis ',v_CaseId,'ST') || '</answer>' || LF;
    v_Str := v_Str || '            <value>' || Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
    v_Str := v_Str || '            <managementPlan>' || Get_InfoPathData('PA_Gastrointestinal_Cirrhosis_Plan_E1                                                  
+ PA_Gastrointestinal_Cirrhosis_Plan_E2                                                  
+ PA_Gastrointestinal_Cirrhosis_Plan_E3                                                  
+ PA_Gastrointestinal_Cirrhosis_Plan_E4                                                  
+ PA_Gastrointestinal_Cirrhosis_Plan_E5                                                  
+ PA_Gastrointestinal_Cirrhosis_Plan_M1                                                  
+ PA_Gastrointestinal_Cirrhosis_Plan_M2                                                  
+ PA_Gastrointestinal_Cirrhosis_Plan_M3                                                  
+ PA_Gastrointestinal_Cirrhosis_Plan_R1                                                  
+ PA_Gastrointestinal_Cirrhosis_Plan_R2                                                  
',v_CaseId,'ST')
    || '</managementPlan>' || LF;
    v_Str := v_Str || '        </followUpQuestions>'|| LF;
    v_Str := v_Str || '        <followUpQuestions>' || LF;
    v_Str := v_Str || '            <title>Type:</title>' || LF;
    v_Str := v_Str || '            <answer>' || Get_InfoPathData(' PA_Gastrointestinal_Cirrhosis_No_Alcohol ',v_CaseId,'ST') || '</answer>' || LF;
    v_Str := v_Str || '            <value>' || Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
    v_Str := v_Str || '            <managementPlan>' || Get_InfoPathData('PA_Gastrointestinal_Cirrhosis_Plan_E1                                                  
+ PA_Gastrointestinal_Cirrhosis_Plan_E2                                                  
+ PA_Gastrointestinal_Cirrhosis_Plan_E3                                                  
+ PA_Gastrointestinal_Cirrhosis_Plan_E4                                                  
+ PA_Gastrointestinal_Cirrhosis_Plan_E5                                                  
+ PA_Gastrointestinal_Cirrhosis_Plan_M1                                                  
+ PA_Gastrointestinal_Cirrhosis_Plan_M2                                                  
+ PA_Gastrointestinal_Cirrhosis_Plan_M3                                                  
+ PA_Gastrointestinal_Cirrhosis_Plan_R1                                                  
+ PA_Gastrointestinal_Cirrhosis_Plan_R2                                                  
',v_CaseId,'ST')
    || '</managementPlan>' || LF;
    v_Str := v_Str || '        </followUpQuestions>'|| LF;
    v_Str := v_Str || '        <managementPlan>' || Get_InfoPathData(
    'PA_Gastrointestinal_Diverticulosis_Plan_E1                                                  
+ PA_Gastrointestinal_Diverticulosis_Plan_E2                                                  
+ PA_Gastrointestinal_Diverticulosis_Plan_E3                                                  
+ PA_Gastrointestinal_Diverticulosis_Plan_E4                                                  
+ PA_Gastrointestinal_Diverticulosis_Plan_E5                                                  
+ PA_Gastrointestinal_Diverticulosis_Plan_M1                                                  
+ PA_Gastrointestinal_Diverticulosis_Plan_M2                                                  
+ PA_Gastrointestinal_Diverticulosis_Plan_M3                                                  
+ PA_Gastrointestinal_Diverticulosis_Plan_R1                                                  
+ PA_Gastrointestinal_Diverticulosis_Plan_R2                                                  
',v_CaseId,'ST') ||
    '</managementPlan>' || LF;

    v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
    v_Str := v_Str || '        <title>End Stage Liver Disease</title>' || LF;
    v_Str := v_Str || '        <value>' || Get_InfoPathData(' PA_Gastrointestinal_End_Liver_Disease ',v_CaseId,'TF') || '</value>' || LF;
    v_Str := v_Str || '        <managementPlan>' || Get_InfoPathData(
    'PA_Gastrointestinal_End_Liver_Disease_Plan_E1                                                  
+ PA_Gastrointestinal_End_Liver_Disease_Plan_E2                                                  
+ PA_Gastrointestinal_End_Liver_Disease_Plan_E3                                                  
+ PA_Gastrointestinal_End_Liver_Disease_Plan_E4                                                  
+ PA_Gastrointestinal_End_Liver_Disease_Plan_E5                                                  
+ PA_Gastrointestinal_End_Liver_Disease_Plan_M1                                                  
+ PA_Gastrointestinal_End_Liver_Disease_Plan_M2                                                  
+ PA_Gastrointestinal_End_Liver_Disease_Plan_M3                                                  
+ PA_Gastrointestinal_End_Liver_Disease_Plan_R1                                                  
+ PA_Gastrointestinal_End_Liver_Disease_Plan_R2                                                  
',
    v_CaseId,'MP') || '</managementPlan>' || LF;

    v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
    v_Str := v_Str || '        <title>Pancreatitis - Chronic</title>' || LF;
    v_Str := v_Str || '        <value>' || Get_InfoPathData(' PA_Gastrointestinal_Pancreatitis_Chronic ',v_CaseId,'TF') || '</value>' || LF;
    v_Str := v_Str || '        <managementPlan>' || Get_InfoPathData(
    'PA_Gastrointestinal_Pancreatitis_Plan_E1                                                  
+ PA_Gastrointestinal_Pancreatitis_Plan_E2                                                  
+ PA_Gastrointestinal_Pancreatitis_Plan_E3                                                  
+ PA_Gastrointestinal_Pancreatitis_Plan_E4                                                  
+ PA_Gastrointestinal_Pancreatitis_Plan_E5                                                  
+ PA_Gastrointestinal_Pancreatitis_Plan_M1                                                  
+ PA_Gastrointestinal_Pancreatitis_Plan_M2                                                  
+ PA_Gastrointestinal_Pancreatitis_Plan_M3                                                  
+ PA_Gastrointestinal_Pancreatitis_Plan_R1                                                  
+ PA_Gastrointestinal_Pancreatitis_Plan_R2                                                  
',v_CaseId,'MP') || '</managementPlan>' || LF;

    v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
    v_Str := v_Str || '        <title>Other Significant Diagnoses:</title>' || LF;
    v_Str := v_Str || '        <value>' || Get_InfoPathData(' PA_Gastrointestinal_Other ',v_CaseId,'TF') || '</value>' || LF;
    v_Str := v_Str || '        <followUpQuestions>' || LF;
    v_Str := v_Str || '            <title>Other:</title>' || LF;
    v_Str := v_Str || '            <answer>' || Get_InfoPathData(' PA_Gastrointestinal_Other_Box',v_CaseId,'ST') || '</answer>' || LF;
    v_Str := v_Str || '            <value>' || Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
    v_Str := v_Str || '        </followUpQuestions>'|| LF;
    v_Str := v_Str || '        <managementPlan>' || Get_InfoPathData('PA_Gastrointestinal_Other_Plan_E1                                                  
+ PA_Gastrointestinal_Other_Plan_E2                                                  
+ PA_Gastrointestinal_Other_Plan_E3                                                  
+ PA_Gastrointestinal_Other_Plan_E4                                                  
+ PA_Gastrointestinal_Other_Plan_E5                                                  
+ PA_Gastrointestinal_Other_Plan_M1                                                  
+ PA_Gastrointestinal_Other_Plan_M2                                                  
+ PA_Gastrointestinal_Other_Plan_M3                                                  
+ PA_Gastrointestinal_Other_Plan_R1                                                  
+ PA_Gastrointestinal_Other_Plan_R2                                                  
',v_CaseId,'MP') || '</managementPlan>' || LF;

    v_Str := v_Str || '   <sections>' || Get_InfoPathData('',v_CaseId,'ST') || '</sections>' || LF;
    v_Str := v_Str || '        <title>Skin</title>' || LF;
    v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
    v_Str := v_Str || '        <title>Pressure Ulcer (Decubitus)</title>' || LF;
    v_Str := v_Str || '        <value>' || Get_InfoPathData(' PA_Skin_Pressure_Ulcer ',v_CaseId,'TF') || '</value>' || LF;
    v_Str := v_Str || '        <followUpQuestions>' || LF;
    v_Str := v_Str || '            <title>Location</title>' || LF;
    v_Str := v_Str || '            <answer>' || Get_InfoPathData(' PA_Skin_Pressure_Ulcer_Site_1 ',v_CaseId,'ST') || '</answer>' || LF;
    v_Str := v_Str || '            <value>' || Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
    v_Str := v_Str || '            <secondaryQuestions>' || LF;
    v_Str := v_Str || '               <title>Stage:</title>' || LF;
    v_Str := v_Str || '               <answer>' || Get_InfoPathData('PA_Skin_Pressure_Ulcer_Stage_1 ',v_CaseId,'ST') || '</answer>' || LF;
    v_Str := v_Str || '               <value>' || Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
    v_Str := v_Str || '            </secondaryQuestions>' || LF;
    v_Str := v_Str || '        </followUpQuestions>'|| LF;
    v_Str := v_Str || '        <followUpQuestions>' || LF;
    v_Str := v_Str || '            <title>Location</title>' || LF;
    v_Str := v_Str || '            <answer>' || Get_InfoPathData(' PA_Skin_Pressure_Ulcer_Site_2 ',v_CaseId,'ST') || '</answer>' || LF;
    v_Str := v_Str || '            <value>' || Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
    v_Str := v_Str || '            <secondaryQuestions>' || LF;
    v_Str := v_Str || '               <title>Stage:</title>' || LF;
    v_Str := v_Str || '               <answer>' || Get_InfoPathData('PA_Skin_Pressure_Ulcer_Stage_2 ',v_CaseId,'ST') || '</answer>' || LF;
    v_Str := v_Str || '               <value>' || Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
    v_Str := v_Str || '            </secondaryQuestions>' || LF;
    v_Str := v_Str || '        </followUpQuestions>'|| LF;
    v_Str := v_Str || '        <managementPlan>' || Get_InfoPathData('PA_Skin_Pressure_Ulcer_Plan_E1                                                  
+ PA_Skin_Pressure_Ulcer_Plan_E2                                                  
+ PA_Skin_Pressure_Ulcer_Plan_E3                                                  
+ PA_Skin_Pressure_Ulcer_Plan_E4                                                  
+ PA_Skin_Pressure_Ulcer_Plan_E5                                                  
+ PA_Skin_Pressure_Ulcer_Plan_M1                                                  
+ PA_Skin_Pressure_Ulcer_Plan_M2                                                  
+ PA_Skin_Pressure_Ulcer_Plan_M3                                                  
+ PA_Skin_Pressure_Ulcer_Plan_R1                                                  
+ PA_Skin_Pressure_Ulcer_Plan_R2                                                  
',v_CaseId,'MP') || '</managementPlan>' || LF;

    v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
    v_Str := v_Str || '        <title>Arterial Ulcer</title>' || LF;
    v_Str := v_Str || '        <value>' || Get_InfoPathData(' PA_Skin_Ulcer_Not_Pressure_Arterial ',v_CaseId,'TF') || '</value>' || LF;
    v_Str := v_Str || '        <followUpQuestions>' || LF;
    v_Str := v_Str || '            <title>Site:</title>' || LF;
    v_Str := v_Str || '            <answer>' || Get_InfoPathData(' PA_Skin_Ulcer_Not_Pressure_Box ',v_CaseId,'ST') || '</answer>' || LF;
    v_Str := v_Str || '            <value>' || Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
    v_Str := v_Str || '        </followUpQuestions>'|| LF;
    v_Str := v_Str || '        <managementPlan>' || Get_InfoPathData('PA_Skin_Ulcer_Not_Pressure_Plan_E1                                                  
+ PA_Skin_Ulcer_Not_Pressure_Plan_E2                                                  
+ PA_Skin_Ulcer_Not_Pressure_Plan_E3                                                  
+ PA_Skin_Ulcer_Not_Pressure_Plan_E4                                                  
+ PA_Skin_Ulcer_Not_Pressure_Plan_E5                                                  
+ PA_Skin_Ulcer_Not_Pressure_Plan_M1                                                  
+ PA_Skin_Ulcer_Not_Pressure_Plan_M2                                                  
+ PA_Skin_Ulcer_Not_Pressure_Plan_M3                                                  
+ PA_Skin_Ulcer_Not_Pressure_Plan_R1                                                  
+ PA_Skin_Ulcer_Not_Pressure_Plan_R2                                                  
',v_CaseId,'MP') || '</managementPlan>' || LF;

    v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
    v_Str := v_Str || '        <title>Venous Ulcer</title>' || LF;
    v_Str := v_Str || '        <value>' || Get_InfoPathData(' PA_Skin_Ulcer_Not_Pressure_Venous ',v_CaseId,'TF') || '</value>' || LF;
    v_Str := v_Str || '        <followUpQuestions>' || LF;
    v_Str := v_Str || '            <title>Site:</title>' || LF;
    v_Str := v_Str || '            <answer>' || Get_InfoPathData(' PA_Skin_Ulcer_Not_Pressure_Box_2 ',v_CaseId,'ST') || '</answer>' || LF;
    v_Str := v_Str || '            <value>' || Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
    v_Str := v_Str || '        </followUpQuestions>'|| LF;
    v_Str := v_Str || '        <managementPlan>' || Get_InfoPathData('PA_Skin_Ulcer_Not_Pressure_Plan_E1                                                  
+ PA_Skin_Ulcer_Not_Pressure_Plan_E2                                                  
+ PA_Skin_Ulcer_Not_Pressure_Plan_E3                                                  
+ PA_Skin_Ulcer_Not_Pressure_Plan_E4                                                  
+ PA_Skin_Ulcer_Not_Pressure_Plan_E5                                                  
+ PA_Skin_Ulcer_Not_Pressure_Plan_M1                                                  
+ PA_Skin_Ulcer_Not_Pressure_Plan_M2                                                  
+ PA_Skin_Ulcer_Not_Pressure_Plan_M3                                                  
+ PA_Skin_Ulcer_Not_Pressure_Plan_R1                                                  
+ PA_Skin_Ulcer_Not_Pressure_Plan_R2                                                  
',v_CaseId,'MP') || '</managementPlan>' || LF;

    v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
    v_Str := v_Str || '        <title>Diabetic Ulcer</title>' || LF;
    v_Str := v_Str || '        <value>' || Get_InfoPathData(' PA_Skin_Ulcer_Not_Pressure_Diabetic ',v_CaseId,'TF') || '</value>' || LF;
    v_Str := v_Str || '        <followUpQuestions>' || LF;
    v_Str := v_Str || '            <title>Site:</title>' || LF;
    v_Str := v_Str || '            <answer>' || Get_InfoPathData(' PA_Skin_Ulcer_Not_Pressure_Box_3 ',v_CaseId,'ST') || '</answer>' || LF;
    v_Str := v_Str || '            <value>' || Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
    v_Str := v_Str || '        </followUpQuestions>'|| LF;
    v_Str := v_Str || '        <managementPlan>' || Get_InfoPathData('PA_Skin_Ulcer_Not_Pressure_Plan_E1                                                  
+ PA_Skin_Ulcer_Not_Pressure_Plan_E2                                                  
+ PA_Skin_Ulcer_Not_Pressure_Plan_E3                                                  
+ PA_Skin_Ulcer_Not_Pressure_Plan_E4                                                  
+ PA_Skin_Ulcer_Not_Pressure_Plan_E5                                                  
+ PA_Skin_Ulcer_Not_Pressure_Plan_M1                                                  
+ PA_Skin_Ulcer_Not_Pressure_Plan_M2                                                  
+ PA_Skin_Ulcer_Not_Pressure_Plan_M3                                                  
+ PA_Skin_Ulcer_Not_Pressure_Plan_R1                                                  
+ PA_Skin_Ulcer_Not_Pressure_Plan_R2                                                  
',v_CaseId,'MP') || '</managementPlan>' || LF;

    v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
    v_Str := v_Str || '        <title>Ulcer (not Pressure):</title>' || LF;
    v_Str := v_Str || '        <value>' || Get_InfoPathData(' PA_Skin_Ulcer_Not_Pressure ',v_CaseId,'TF') || '</value>' || LF;
    v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
    v_Str := v_Str || '        <title>Cellulitis</title>' || LF;
    v_Str := v_Str || '        <value>' || Get_InfoPathData(' PA_Skin_Cellulitis',v_CaseId,'ST') || '</value>' || LF;
    v_Str := v_Str || '        <followUpQuestions>' || LF;
    v_Str := v_Str || '            <title>Site:</title>' || LF;
    v_Str := v_Str || '            <answer>' || Get_InfoPathData(' PA_Skin_Cellulitis_Box ',v_CaseId,'ST') || '</answer>' || LF;
    v_Str := v_Str || '            <value>' || Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
    v_Str := v_Str || '        </followUpQuestions>'|| LF;
    v_Str := v_Str || '        <managementPlan>' || Get_InfoPathData('PA_Skin_Cellulitis_Plan_E1                                                  
+ PA_Skin_Cellulitis_Plan_E2                                                  
+ PA_Skin_Cellulitis_Plan_E3                                                  
+ PA_Skin_Cellulitis_Plan_E4                                                  
+ PA_Skin_Cellulitis_Plan_E5                                                  
+ PA_Skin_Cellulitis_Plan_M1                                                  
+ PA_Skin_Cellulitis_Plan_M2                                                  
+ PA_Skin_Cellulitis_Plan_M3                                                  
+ PA_Skin_Cellulitis_Plan_R1                                                  
+ PA_Skin_Cellulitis_Plan_R2                                                  
',v_CaseId,'MP') || '</managementPlan>' || LF;

    v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
    v_Str := v_Str || '        <title>Psoriasis</title>' || LF;
    v_Str := v_Str || '        <value>' || Get_InfoPathData(' PA_Skin_Psoriasis ',v_CaseId,'TF') || '</value>' || LF;
    v_Str := v_Str || '        <managementPlan>' || Get_InfoPathData('PA_Skin_Psoriasis_Plan_E1                                                  
+ PA_Skin_Psoriasis_Plan_E2                                                  
+ PA_Skin_Psoriasis_Plan_E3                                                  
+ PA_Skin_Psoriasis_Plan_E4                                                  
+ PA_Skin_Psoriasis_Plan_E5                                                  
+ PA_Skin_Psoriasis_Plan_M1                                                  
+ PA_Skin_Psoriasis_Plan_M2                                                  
+ PA_Skin_Psoriasis_Plan_M3                                                  
+ PA_Skin_Psoriasis_Plan_R1                                                  
+ PA_Skin_Psoriasis_Plan_R2                                                  
',v_CaseId,'MP') || '</managementPlan>' || LF;

    v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
    v_Str := v_Str || '        <title>Other Significant Diagnoses</title>' || LF;
    v_Str := v_Str || '        <value>' || Get_InfoPathData(' PA_Skin_Other ',v_CaseId,'TF') || '</value>' || LF;
    v_Str := v_Str || '        <followUpQuestions>' || LF;
    v_Str := v_Str || '            <title>Other:</title>' || LF;
    v_Str := v_Str || '            <answer>' || Get_InfoPathData(' PA_Skin_Other_box',v_CaseId,'ST') || '</answer>' || LF;
    v_Str := v_Str || '            <value>' || Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
    v_Str := v_Str || '        </followUpQuestions>'|| LF;
    v_Str := v_Str || '        <managementPlan>' || Get_InfoPathData('PA_Skin_Other_Plan_E1                                                  
+ PA_Skin_Other_Plan_E2                                                  
+ PA_Skin_Other_Plan_E3                                                  
+ PA_Skin_Other_Plan_E4                                                  
+ PA_Skin_Other_Plan_E5                                                  
+ PA_Skin_Other_Plan_M1                                                  
+ PA_Skin_Other_Plan_M2                                                  
+ PA_Skin_Other_Plan_M3                                                  
+ PA_Skin_Other_Plan_R1                                                  
+ PA_Skin_Other_Plan_R2                                                  
',v_CaseId,'MP') || '</managementPlan>' || LF;

    v_Str := v_Str || '   <sections>' || Get_InfoPathData('',v_CaseId,'ST') || '</sections>' || LF;
    v_Str := v_Str || '        <title>Renal/Genitourinary</title>' || LF;
    v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
    v_Str := v_Str || '        <title>Urinary Tract Infection (active)</title>' || LF;
    v_Str := v_Str || '        <value>' || Get_InfoPathData(' PA_Renal_UTI ',v_CaseId,'TF') || '</value>' || LF;
    v_Str := v_Str || '        <managementPlan>' || Get_InfoPathData('PA_Renal_UTI_Plan_E1                                                  
+ PA_Renal_UTI_Plan_E2                                                  
+ PA_Renal_UTI_Plan_E3                                                  
+ PA_Renal_UTI_Plan_E4                                                  
+ PA_Renal_UTI_Plan_E5                                                  
+ PA_Renal_UTI_Plan_M1                                                  
+ PA_Renal_UTI_Plan_M2                                                  
+ PA_Renal_UTI_Plan_M3                                                  
+ PA_Renal_UTI_Plan_R1                                                  
+ PA_Renal_UTI_Plan_R2                                                  
',v_CaseId,'MP') || '</managementPlan>' || LF;

    v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
    v_Str := v_Str || '        <title>Chronic Kidney Disease Stage I (GER 2.90) (with evidence of renalDamage such as proteinuria)</title>' || LF;
    v_Str := v_Str || '        <value>' || Get_InfoPathData(' PA_Renal_CKD_Stage1 ',v_CaseId,'TF') || '</value>' || LF;
    v_Str := v_Str || '        <managementPlan>' || Get_InfoPathData('PA_Renal_CKD_Stage1_Plan_E1                                                  
+ PA_Renal_CKD_Stage1_Plan_E2                                                  
+ PA_Renal_CKD_Stage1_Plan_E3                                                  
+ PA_Renal_CKD_Stage1_Plan_E4                                                  
+ PA_Renal_CKD_Stage1_Plan_E5                                                  
+ PA_Renal_CKD_Stage1_Plan_M1                                                  
+ PA_Renal_CKD_Stage1_Plan_M2                                                  
+ PA_Renal_CKD_Stage1_Plan_M3                                                  
+ PA_Renal_CKD_Stage1_Plan_R1                                                  
+ PA_Renal_CKD_Stage1_Plan_R2                                                  
',v_CaseId,'MP') || '</managementPlan>' || LF;

    v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
    v_Str := v_Str || '        <title>Chronic Kidney Disease Stage II Mild(GFR 60-89)</title>' || LF;
    v_Str := v_Str || '        <value>' || Get_InfoPathData('PA_Renal_CKD_Stage2',v_CaseId,'TF') || '</value>' || LF;
    v_Str := v_Str || '        <managementPlan>' || Get_InfoPathData('PA_Renal_CKD_Stage2_Plan_E1                                                  
+ PA_Renal_CKD_Stage2_Plan_E2                                                  
+ PA_Renal_CKD_Stage2_Plan_E3                                                  
+ PA_Renal_CKD_Stage2_Plan_E4                                                  
+ PA_Renal_CKD_Stage2_Plan_E5                                                  
+ PA_Renal_CKD_Stage2_Plan_M1                                                  
+ PA_Renal_CKD_Stage2_Plan_M2                                                  
+ PA_Renal_CKD_Stage2_Plan_M3                                                  
+ PA_Renal_CKD_Stage2_Plan_R1                                                  
+ PA_Renal_CKD_Stage2_Plan_R2                                                  
',v_CaseId,'MP') || '</managementPlan>' || LF;

    v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
    v_Str := v_Str || '        <title>Chronic Kidney Disease Stage III Moderate (GFR 30-59)</title>' || LF;
    v_Str := v_Str || '        <value>' || Get_InfoPathData('PA_Renal_CKD_Stage3',v_CaseId,'TF') || '</value>' || LF;
    v_Str := v_Str || '        <managementPlan>' || Get_InfoPathData('PA_Renal_CKD_Stage3_Plan_E1                                                  
+ PA_Renal_CKD_Stage3_Plan_E2                                                  
+ PA_Renal_CKD_Stage3_Plan_E3                                                  
+ PA_Renal_CKD_Stage3_Plan_E4                                                  
+ PA_Renal_CKD_Stage3_Plan_E5                                                  
+ PA_Renal_CKD_Stage3_Plan_M1                                                  
+ PA_Renal_CKD_Stage3_Plan_M2                                                  
+ PA_Renal_CKD_Stage3_Plan_M3                                                  
+ PA_Renal_CKD_Stage3_Plan_R1                                                  
+ PA_Renal_CKD_Stage3_Plan_R2                                                  
',v_CaseId,'MP') || '</managementPlan>' || LF;

    v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
    v_Str := v_Str || '        <title>Chronic Kidney Disease Stage IV Severe (GFR 15-29)</title>' || LF;
    v_Str := v_Str || '        <value>' || Get_InfoPathData('PA_Renal_CKD_Stage4',v_CaseId,'TF') || '</value>' || LF;
    v_Str := v_Str || '        <managementPlan>' || Get_InfoPathData('PA_Renal_CKD_Stage4_Plan_E1                                                  
+ PA_Renal_CKD_Stage4_Plan_E2                                                  
+ PA_Renal_CKD_Stage4_Plan_E3                                                  
+ PA_Renal_CKD_Stage4_Plan_E4                                                  
+ PA_Renal_CKD_Stage4_Plan_E5                                                  
+ PA_Renal_CKD_Stage4_Plan_M1                                                  
+ PA_Renal_CKD_Stage4_Plan_M2                                                  
+ PA_Renal_CKD_Stage4_Plan_M3                                                  
+ PA_Renal_CKD_Stage4_Plan_R1                                                  
+ PA_Renal_CKD_Stage4_Plan_R2                                                  
',v_CaseId,'MP') || '</managementPlan>' || LF;

    v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
    v_Str := v_Str || '        <title>Chronic Kidney Disease Stage V (GFR &amp;lt;15)</title>' || LF;
    v_Str := v_Str || '        <value>' || Get_InfoPathData('PA_Renal_CKD_Stage5',v_CaseId,'TF') || '</value>' || LF;
    v_Str := v_Str || '        <value>' || Get_InfoPathData('PA_Renal_CKD_Stage5_Plan_E1                                                  
+ PA_Renal_CKD_Stage5_Plan_E2                                                  
+ PA_Renal_CKD_Stage5_Plan_E3                                                  
+ PA_Renal_CKD_Stage5_Plan_E4                                                  
+ PA_Renal_CKD_Stage5_Plan_E5                                                  
+ PA_Renal_CKD_Stage5_Plan_M1                                                  
+ PA_Renal_CKD_Stage5_Plan_M2                                                  
+ PA_Renal_CKD_Stage5_Plan_M3                                                  
+ PA_Renal_CKD_Stage5_Plan_R1                                                  
+ PA_Renal_CKD_Stage5_Plan_R2                                                  
',v_CaseId,'ST') || '</value>' || LF;
    v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
    v_Str := v_Str || '        <title>Chronic Kidney Disease ESR (If on dialysis)</title>' || LF;
    v_Str := v_Str || '        <value>' || Get_InfoPathData(' PA_Renal_CKD_ESRD ',v_CaseId,'TF') || '</value>' || LF;
    v_Str := v_Str || '        <managementPlan>' || Get_InfoPathData('PA_Renal_CKD_ESRD_Plan_E1                                                  
+ PA_Renal_CKD_ESRD_Plan_E2                                                  
+ PA_Renal_CKD_ESRD_Plan_E3                                                  
+ PA_Renal_CKD_ESRD_Plan_E4                                                  
+ PA_Renal_CKD_ESRD_Plan_E5                                                  
+ PA_Renal_CKD_ESRD_Plan_M1                                                  
+ PA_Renal_CKD_ESRD_Plan_M2                                                  
+ PA_Renal_CKD_ESRD_Plan_M3                                                  
+ PA_Renal_CKD_ESRD_Plan_R1                                                  
+ PA_Renal_CKD_ESRD_Plan_R2                                                  
',v_CaseId,'MP') || '</managementPlan>' || LF;

    v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
    v_Str := v_Str || '        <title>Chronic Kidney Disease Unspecified</title>' || LF;
    v_Str := v_Str || '        <value>' || Get_InfoPathData(' PA_Renal_CKD_Unspecified ',v_CaseId,'TF') || '</value>' || LF;
    v_Str := v_Str || '        <managementPlan>' || Get_InfoPathData('PA_Renal_CKD_Unspecified_Plan_E1                                                  
+ PA_Renal_CKD_Unspecified_Plan_E2                                                  
+ PA_Renal_CKD_Unspecified_Plan_E3                                                  
+ PA_Renal_CKD_Unspecified_Plan_E4                                                  
+ PA_Renal_CKD_Unspecified_Plan_E5                                                  
+ PA_Renal_CKD_Unspecified_Plan_M1                                                  
+ PA_Renal_CKD_Unspecified_Plan_M2                                                  
+ PA_Renal_CKD_Unspecified_Plan_M3                                                  
+ PA_Renal_CKD_Unspecified_Plan_R1                                                  
+ PA_Renal_CKD_Unspecified_Plan_R2                                                  
',v_CaseId,'MP') || '</managementPlan>' || LF;

    v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
    v_Str := v_Str || '        <title>Dialysis</title>' || LF;
    v_Str := v_Str || '        <value>' || Get_InfoPathData(' PA_Renal_Dialysis_Status ',v_CaseId,'TF') || '</value>' || LF;
    v_Str := v_Str || '        <followUpQuestions>' || LF;
    v_Str := v_Str || '            <title>Dialysis Status:</title>' || LF;
    v_Str := v_Str || '            <answer>' || Get_InfoPathData(' PA_Renal_Dialysis_Status_Hemodialysis 
+ PA_Renal_Dialysis_Status_Peritoneal',v_CaseId,'ST') || '</answer>' || LF;
    v_Str := v_Str || '            <value>' || Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
    v_Str := v_Str || '        </followUpQuestions>'|| LF;
    v_Str := v_Str || '        <followUpQuestions>' || LF;
    v_Str := v_Str || '            <title>Start Date:</title>' || LF;
    v_Str := v_Str || '            <answer>' || Get_InfoPathData(' PA_Renal_Dialysis_Status_Date',v_CaseId,'ST') || '</answer>' || LF;
    v_Str := v_Str || '            <value>' || Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
    v_Str := v_Str || '        </followUpQuestions>'|| LF;
    v_Str := v_Str || '        <managementPlan>' || Get_InfoPathData('PA_Renal_Dialysis_Status_Plan_E1                                                  
+ PA_Renal_Dialysis_Status_Plan_E2                                                  
+ PA_Renal_Dialysis_Status_Plan_E3                                                  
+ PA_Renal_Dialysis_Status_Plan_E4                                                  
+ PA_Renal_Dialysis_Status_Plan_E5                                                  
+ PA_Renal_Dialysis_Status_Plan_M1                                                  
+ PA_Renal_Dialysis_Status_Plan_M2                                                  
+ PA_Renal_Dialysis_Status_Plan_M3                                                  
+ PA_Renal_Dialysis_Status_Plan_R1                                                  
+ PA_Renal_Dialysis_Status_Plan_R2                                                  
',v_CaseId,'MP') || '</managementPlan>' || LF;

    v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
    v_Str := v_Str || '        <title>Renal Transplant</title>' || LF;
    v_Str := v_Str || '        <value>' || Get_InfoPathData(' PA_Renal_Transplant ',v_CaseId,'TF') || '</value>' || LF;
    v_Str := v_Str || '        <managementPlan>' || Get_InfoPathData('PA_Renal_Transplant_Plan_E1                                                  
+ PA_Renal_Transplant_Plan_E2                                                  
+ PA_Renal_Transplant_Plan_E3                                                  
+ PA_Renal_Transplant_Plan_E4                                                  
+ PA_Renal_Transplant_Plan_E5                                                  
+ PA_Renal_Transplant_Plan_M1                                                  
+ PA_Renal_Transplant_Plan_M2                                                  
+ PA_Renal_Transplant_Plan_M3                                                  
+ PA_Renal_Transplant_Plan_R1                                                  
+ PA_Renal_Transplant_Plan_R2                                                  
',v_CaseId,'MP') || '</managementPlan>' || LF;

    v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
    v_Str := v_Str || '        <title>BPH (benign prostatic hypettiophy)</title>' || LF;
    v_Str := v_Str || '        <value>' || Get_InfoPathData(' PA_Renal_BPH ',v_CaseId,'TF') || '</value>' || LF;
    v_Str := v_Str || '        <managementPlan>' || Get_InfoPathData('PA_Renal_BPH_Plan_E1                                                  
+ PA_Renal_BPH_Plan_E2                                                  
+ PA_Renal_BPH_Plan_E3                                                  
+ PA_Renal_BPH_Plan_E4                                                  
+ PA_Renal_BPH_Plan_E5                                                  
+ PA_Renal_BPH_Plan_M1                                                  
+ PA_Renal_BPH_Plan_M2                                                  
+ PA_Renal_BPH_Plan_M3                                                  
+ PA_Renal_BPH_Plan_R1                                                  
+ PA_Renal_BPH_Plan_R2                                                  
',v_CaseId,'MP') || '</managementPlan>' || LF;

    v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
    v_Str := v_Str || '        <title>Other Significant Diagnoses:</title>' || LF;
    v_Str := v_Str || '        <value>' || Get_InfoPathData(' PA_Renal_Other ',v_CaseId,'TF') || '</value>' || LF;
    v_Str := v_Str || '        <followUpQuestions>' || LF;
    v_Str := v_Str || '            <title>Other:</title>' || LF;
    v_Str := v_Str || '            <answer>' || Get_InfoPathData(' PA_Renal_Other_Box',v_CaseId,'ST') || '</answer>' || LF;
    v_Str := v_Str || '            <value>' || Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
    v_Str := v_Str || '        </followUpQuestions>'|| LF;
    v_Str := v_Str || '        <managementPlan>' || Get_InfoPathData('PA_Renal_Other_Plan_E1                                                  
+ PA_Renal_Other_Plan_E2                                                  
+ PA_Renal_Other_Plan_E3                                                  
+ PA_Renal_Other_Plan_E4                                                  
+ PA_Renal_Other_Plan_E5                                                  
+ PA_Renal_Other_Plan_M1                                                  
+ PA_Renal_Other_Plan_M2                                                  
+ PA_Renal_Other_Plan_M3                                                  
+ PA_Renal_Other_Plan_R1                                                  
+ PA_Renal_Other_Plan_R2                                                  
',v_CaseId,'MP') || '</managementPlan>' || LF;

    v_Str := v_Str || '   <sections>' || Get_InfoPathData('',v_CaseId,'ST') || '</sections>' || LF;
    v_Str := v_Str || '        <title>Bone/Rheum/Joint Disease</title>' || LF;
    v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
    v_Str := v_Str || '        <title>Polymyalgia Rheumatica</title>' || LF;
    v_Str := v_Str || '        <value>' || Get_InfoPathData(' PA_Bone_Polymyalgia_Rheumatica ',v_CaseId,'TF') || '</value>' || LF;
    v_Str := v_Str || '        <managementPlan>' || Get_InfoPathData('PA_Bone_Polymyalgia_Rheumatica_Plan_E1                                                  
+ PA_Bone_Polymyalgia_Rheumatica_Plan_E2                                                  
+ PA_Bone_Polymyalgia_Rheumatica_Plan_E3                                                  
+ PA_Bone_Polymyalgia_Rheumatica_Plan_E4                                                  
+ PA_Bone_Polymyalgia_Rheumatica_Plan_E5                                                  
+ PA_Bone_Polymyalgia_Rheumatica_Plan_M1                                                  
+ PA_Bone_Polymyalgia_Rheumatica_Plan_M2                                                  
+ PA_Bone_Polymyalgia_Rheumatica_Plan_M3                                                  
+ PA_Bone_Polymyalgia_Rheumatica_Plan_R1                                                  
+ PA_Bone_Polymyalgia_Rheumatica_Plan_R2                                                  
',v_CaseId ,'ST') || '</managementPlan>' || LF;

    v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
    v_Str := v_Str || '        <title>Systemic Lupus Erythematosus (SLE)</title>' || LF;
    v_Str := v_Str || '        <value>' || Get_InfoPathData(' PA_Bone_SLE ',v_CaseId,'TF') || '</value>' || LF;
    v_Str := v_Str || '        <managementPlan>' || Get_InfoPathData('PA_Bone_SLE_Plan_E1                                                  
+ PA_Bone_SLE_Plan_E2                                                  
+ PA_Bone_SLE_Plan_E3                                                  
+ PA_Bone_SLE_Plan_E4                                                  
+ PA_Bone_SLE_Plan_E5                                                  
+ PA_Bone_SLE_Plan_M1                                                  
+ PA_Bone_SLE_Plan_M2                                                  
+ PA_Bone_SLE_Plan_M3                                                  
+ PA_Bone_SLE_Plan_R1                                                  
+ PA_Bone_SLE_Plan_R2                                                  
',v_CaseId,'MP') || '</managementPlan>' || LF;

    v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
    v_Str := v_Str || '        <title>Rheumatoid Arthritis</title>' || LF;
    v_Str := v_Str || '        <value>' || Get_InfoPathData(' PA_Bone_Rheumatoid_Arthritis ',v_CaseId,'TF') || '</value>' || LF;
    v_Str := v_Str || '        <followUpQuestions>' || LF;
    v_Str := v_Str || '            <title>Also Complicated with:</title>' || LF;
    v_Str := v_Str || '            <answer>' || Get_InfoPathData(' PA_Bone_Rheumatoid_Arthritis_Myopathy ',v_CaseId,'ST') || '</answer>' || LF;
    v_Str := v_Str || '            <value>' || Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
    v_Str := v_Str || '        </followUpQuestions>'|| LF;
    v_Str := v_Str || '        <followUpQuestions>' || LF;
    v_Str := v_Str || '            <title>Also Complicated with:</title>' || LF;
    v_Str := v_Str || '            <answer>' || Get_InfoPathData(' PA_Bone_Rheumatoid_Arthritis_Polyneuropathy ',v_CaseId,'ST') || '</answer>' || LF;
    v_Str := v_Str || '            <value>' || Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
    v_Str := v_Str || '        </followUpQuestions>'|| LF;
    v_Str := v_Str || '        <managementPlan>' || Get_InfoPathData('PA_Bone_Rheumatoid_Arthritis_Plan_E1                                                  
+ PA_Bone_Rheumatoid_Arthritis_Plan_E2                                                  
+ PA_Bone_Rheumatoid_Arthritis_Plan_E3                                                  
+ PA_Bone_Rheumatoid_Arthritis_Plan_E4                                                  
+ PA_Bone_Rheumatoid_Arthritis_Plan_E5                                                  
+ PA_Bone_Rheumatoid_Arthritis_Plan_M1                                                  
+ PA_Bone_Rheumatoid_Arthritis_Plan_M2                                                  
+ PA_Bone_Rheumatoid_Arthritis_Plan_M3                                                  
+ PA_Bone_Rheumatoid_Arthritis_Plan_R1                                                  
+ PA_Bone_Rheumatoid_Arthritis_Plan_R2                                                  
',v_CaseId,'ST') ||
    '</managementPlan>' || LF;

    v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
    v_Str := v_Str || '        <title>Fibromyalgia</title>' || LF;
    v_Str := v_Str || '        <value>' || Get_InfoPathData(' PA_Bone_Fibromyalgia ',v_CaseId,'TF') || '</value>' || LF;
    v_Str := v_Str || '        <managementPlan>' || Get_InfoPathData('PA_Bone_Fibromyalgia_Plan_E1                                                  
+ PA_Bone_Fibromyalgia_Plan_E2                                                  
+ PA_Bone_Fibromyalgia_Plan_E3                                                  
+ PA_Bone_Fibromyalgia_Plan_E4                                                  
+ PA_Bone_Fibromyalgia_Plan_E5                                                  
+ PA_Bone_Fibromyalgia_Plan_M1                                                  
+ PA_Bone_Fibromyalgia_Plan_M2                                                  
+ PA_Bone_Fibromyalgia_Plan_M3                                                  
+ PA_Bone_Fibromyalgia_Plan_R1                                                  
+ PA_Bone_Fibromyalgia_Plan_R2                                                  
',v_CaseId,'MP') || '</managementPlan>' || LF;

    v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
    v_Str := v_Str || '        <title>Back Pain</title>' || LF;
    v_Str := v_Str || '        <value>' || Get_InfoPathData(' PA_Bone_Back_Pain ',v_CaseId,'TF') || '</value>' || LF;
    v_Str := v_Str || '        <managementPlan>' || Get_InfoPathData('PA_Bone_Back_Pain_Plan_E1                                                  
+ PA_Bone_Back_Pain_Plan_E2                                                  
+ PA_Bone_Back_Pain_Plan_E3                                                  
+ PA_Bone_Back_Pain_Plan_E4                                                  
+ PA_Bone_Back_Pain_Plan_E5                                                  
+ PA_Bone_Back_Pain_Plan_M1                                                  
+ PA_Bone_Back_Pain_Plan_M2                                                  
+ PA_Bone_Back_Pain_Plan_M3                                                  
+ PA_Bone_Back_Pain_Plan_R1                                                  
+ PA_Bone_Back_Pain_Plan_R2                                                  
',v_CaseId,'MP') || '</managementPlan>' || LF;

    v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
    v_Str := v_Str || '        <title>Degenerative Disc Disease (DDD)</title>' || LF;
    v_Str := v_Str || '        <value>' || Get_InfoPathData('',v_CaseId,'TF') || '</value>' || LF;
    v_Str := v_Str || '        <followUpQuestions>' || LF;
    v_Str := v_Str || '            <title>Location:</title>' || LF;
    v_Str := v_Str || '            <answer>' || Get_InfoPathData(' PA_Bone_DDD_Cervical ',v_CaseId,'ST') || '</answer>' || LF;
    v_Str := v_Str || '            <value>' || Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
    v_Str := v_Str || '        </followUpQuestions>'|| LF;
    v_Str := v_Str || '        <followUpQuestions>' || LF;
    v_Str := v_Str || '            <title>Location:</title>' || LF;
    v_Str := v_Str || '            <answer>' || Get_InfoPathData(' PA_Bone_DDD_Lumbar ',v_CaseId,'ST') || '</answer>' || LF;
    v_Str := v_Str || '            <value>' || Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
    v_Str := v_Str || '        </followUpQuestions>'|| LF;
    v_Str := v_Str || '        <managementPlan>' || Get_InfoPathData('PA_Bone_DDD_Plan_E1                                                  
+ PA_Bone_DDD_Plan_E2                                                  
+ PA_Bone_DDD_Plan_E3                                                  
+ PA_Bone_DDD_Plan_E4                                                  
+ PA_Bone_DDD_Plan_E5                                                  
+ PA_Bone_DDD_Plan_M1                                                  
+ PA_Bone_DDD_Plan_M2                                                  
+ PA_Bone_DDD_Plan_M3                                                  
+ PA_Bone_DDD_Plan_R1                                                  
+ PA_Bone_DDD_Plan_R2                                                  
',v_CaseId,'MP') || '</managementPlan>' || LF;

    v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
    v_Str := v_Str || '        <title>Osteoarthritis/DJD Localized</title>' || LF;
    v_Str := v_Str || '        <value>' || Get_InfoPathData(' PA_Bone_Osteoarthritis_Localized ',v_CaseId,'TF') || '</value>' || LF;
    v_Str := v_Str || '        <followUpQuestions>' || LF;
    v_Str := v_Str || '            <title>Site:</title>' || LF;
    v_Str := v_Str || '            <answer>' || Get_InfoPathData(' PA_Bone_Osteoarthritis_Localized_Box ',v_CaseId,'ST') || '</answer>' || LF;
    v_Str := v_Str || '            <value>' || Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
    v_Str := v_Str || '        </followUpQuestions>'|| LF;
    v_Str := v_Str || '        <managementPlan>' || Get_InfoPathData(
    'PA_Bone_Osteoarthritis_Localized_Plan_E1                                                  
+ PA_Bone_Osteoarthritis_Localized_Plan_E2                                                  
+ PA_Bone_Osteoarthritis_Localized_Plan_E3                                                  
+ PA_Bone_Osteoarthritis_Localized_Plan_E4                                                  
+ PA_Bone_Osteoarthritis_Localized_Plan_E5                                                  
+ PA_Bone_Osteoarthritis_Localized_Plan_M1                                                  
+ PA_Bone_Osteoarthritis_Localized_Plan_M2                                                  
+ PA_Bone_Osteoarthritis_Localized_Plan_M3                                                  
+ PA_Bone_Osteoarthritis_Localized_Plan_R1                                                  
+ PA_Bone_Osteoarthritis_Localized_Plan_R2                                                  
',v_CaseId,'MP') || '</managementPlan>' || LF;

    v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
    v_Str := v_Str || '        <title>Osteoarthritis/DJD Generalized</title>' || LF;
    v_Str := v_Str || '        <value>' || Get_InfoPathData(' PA_Bone_Osteoarthritis_Generalized ',v_CaseId,'TF') || '</value>' || LF;
    v_Str := v_Str || '        <followUpQuestions>' || LF;
    v_Str := v_Str || '            <title>Site:</title>' || LF;
    v_Str := v_Str || '            <answer>' || Get_InfoPathData('',v_CaseId,'ST') || '</answer>' || LF;
    v_Str := v_Str || '            <value>' || Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
    v_Str := v_Str || '        </followUpQuestions>'|| LF;
    v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
    v_Str := v_Str || '        <title>Gout</title>' || LF;
    v_Str := v_Str || '        <value>' || Get_InfoPathData('',v_CaseId,'TF') || '</value>' || LF;
    v_Str := v_Str || '        <followUpQuestions>' || LF;
    v_Str := v_Str || '            <title>Type:</title>' || LF;
    v_Str := v_Str || '            <answer>' || Get_InfoPathData(' PA_Bone_Gout_Acute ',v_CaseId,'ST') || '</answer>' || LF;
    v_Str := v_Str || '            <value>' || Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
    v_Str := v_Str || '        </followUpQuestions>'|| LF;
    v_Str := v_Str || '        <followUpQuestions>' || LF;
    v_Str := v_Str || '            <title>Type:</title>' || LF;
    v_Str := v_Str || '            <answer>' || Get_InfoPathData(' PA_Bone_Gout_Chronic' ,v_CaseId,'ST') || '</answer>' || LF;
    v_Str := v_Str || '            <value>' || Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
    v_Str := v_Str || '        </followUpQuestions>'|| LF;
    v_Str := v_Str || '        <followUpQuestions>' || LF;
    v_Str := v_Str || '            <title>Type:</title>' || LF;
    v_Str := v_Str || '            <answer>' || Get_InfoPathData(' PA_Bone_Gout_Unspecified ',v_CaseId,'ST') || '</answer>' || LF;
    v_Str := v_Str || '            <value>' || Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
    v_Str := v_Str || '        </followUpQuestions>'|| LF;
    v_Str := v_Str || '        <managementPlan>' || Get_InfoPathData('PA_Bone_Gout_Plan_E1                                                  
+ PA_Bone_Gout_Plan_E2                                                  
+ PA_Bone_Gout_Plan_E3                                                  
+ PA_Bone_Gout_Plan_E4                                                  
+ PA_Bone_Gout_Plan_E5                                                  
+ PA_Bone_Gout_Plan_M1                                                  
+ PA_Bone_Gout_Plan_M2                                                  
+ PA_Bone_Gout_Plan_M3                                                  
+ PA_Bone_Gout_Plan_R1                                                  
+ PA_Bone_Gout_Plan_R2                                                  
',v_CaseId,'MP') || '</managementPlan>' || LF;

    v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
    v_Str := v_Str || '        <title>Spinal Stenosis</title>' || LF;
    v_Str := v_Str || '        <value>' || Get_InfoPathData(' PA_Bone_Spinal_Stenosis ',v_CaseId,'TF') || '</value>' || LF;
    v_Str := v_Str || '        <followUpQuestions>' || LF;
    v_Str := v_Str || '            <title>Type:</title>' || LF;
    v_Str := v_Str || '            <answer>' || Get_InfoPathData(' PA_Bone_Spinal_Stenosis_Lumbar ',v_CaseId,'ST') || '</answer>' || LF;
    v_Str := v_Str || '            <value>' || Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
    v_Str := v_Str || '        </followUpQuestions>'|| LF;
    v_Str := v_Str || '        <followUpQuestions>' || LF;
    v_Str := v_Str || '            <title>Type:</title>' || LF;
    v_Str := v_Str || '            <answer>' || Get_InfoPathData(' PA_Bone_Spinal_Stenosis_Cervical ',v_CaseId,'ST') || '</answer>' || LF;
    v_Str := v_Str || '            <value>' || Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
    v_Str := v_Str || '        </followUpQuestions>'|| LF;
    v_Str := v_Str || '        <managementPlan>' || Get_InfoPathData('PA_Bone_Spinal_Stenosis_Plan_E1                                                  
+ PA_Bone_Spinal_Stenosis_Plan_E2                                                  
+ PA_Bone_Spinal_Stenosis_Plan_E3                                                  
+ PA_Bone_Spinal_Stenosis_Plan_E4                                                  
+ PA_Bone_Spinal_Stenosis_Plan_E5                                                  
+ PA_Bone_Spinal_Stenosis_Plan_M1                                                  
+ PA_Bone_Spinal_Stenosis_Plan_M2                                                  
+ PA_Bone_Spinal_Stenosis_Plan_M3                                                  
+ PA_Bone_Spinal_Stenosis_Plan_R1                                                  
+ PA_Bone_Spinal_Stenosis_Plan_R2                                                  
',v_CaseId,'MP') || '</managementPlan>' || LF;

    v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
    v_Str := v_Str || '        <title>' || 'Osteomyelitis, Acute' || '</title>' || LF;
    v_Str := v_Str || '        <value>' || Get_InfoPathData(' PA_Bone_Osteomyelitis_Acute ',v_CaseId,'TF') || '</value>' || LF;
    v_Str := v_Str || '        <followUpQuestions>' || LF;
    v_Str := v_Str || '            <title>Specify site:</title>' || LF;
    v_Str := v_Str || '            <answer>' || Get_InfoPathData(' PA_Bone_Osteomyelitis_Acute_Box ',v_CaseId,'ST') || '</answer>' || LF;
    v_Str := v_Str || '            <value>' || Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
    v_Str := v_Str || '        </followUpQuestions>'|| LF;
    v_Str := v_Str || '        <managementPlan>' || Get_InfoPathData('PA_Bone_Osteomyelitis_Acute_Plan_E1                                                  
+ PA_Bone_Osteomyelitis_Acute_Plan_E2                                                  
+ PA_Bone_Osteomyelitis_Acute_Plan_E3                                                  
+ PA_Bone_Osteomyelitis_Acute_Plan_E4                                                  
+ PA_Bone_Osteomyelitis_Acute_Plan_E5                                                  
+ PA_Bone_Osteomyelitis_Acute_Plan_M1                                                  
+ PA_Bone_Osteomyelitis_Acute_Plan_M2                                                  
+ PA_Bone_Osteomyelitis_Acute_Plan_M3                                                  
+ PA_Bone_Osteomyelitis_Acute_Plan_R1                                                  
+ PA_Bone_Osteomyelitis_Acute_Plan_R2                                                  
',v_CaseId,'ST') || '</managementPlan>'
    || LF;

    v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
    v_Str := v_Str || '        <title>' || 'Osteomyelitis, Chronic' || '</title>' || LF;
    v_Str := v_Str || '        <value>' || Get_InfoPathData('PA_Bone_Osteomyelitis_Chronic',v_CaseId,'TF') || '</value>' || LF;
    v_Str := v_Str || '        <followUpQuestions>' || LF;
    v_Str := v_Str || '            <title>Specify site:</title>' || LF;
    v_Str := v_Str || '            <answer>' || Get_InfoPathData(' PA_Bone_Osteomyelitis_Chronic_Box ',v_CaseId,'ST') || '</answer>' || LF;
    v_Str := v_Str || '            <value>' || Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
    v_Str := v_Str || '        </followUpQuestions>'|| LF;
    v_Str := v_Str || '        <managementPlan>' || Get_InfoPathData('PA_Bone_Osteomyelitis_Chronic_Plan_E1                                                  
+ PA_Bone_Osteomyelitis_Chronic_Plan_E2                                                  
+ PA_Bone_Osteomyelitis_Chronic_Plan_E3                                                  
+ PA_Bone_Osteomyelitis_Chronic_Plan_E4                                                  
+ PA_Bone_Osteomyelitis_Chronic_Plan_E5                                                  
+ PA_Bone_Osteomyelitis_Chronic_Plan_M1                                                  
+ PA_Bone_Osteomyelitis_Chronic_Plan_M2                                                  
+ PA_Bone_Osteomyelitis_Chronic_Plan_M3                                                  
+ PA_Bone_Osteomyelitis_Chronic_Plan_R1                                                  
+ PA_Bone_Osteomyelitis_Chronic_Plan_R2                                                  
',v_CaseId,'ST') ||
    '</managementPlan>' || LF;

    v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
    v_Str := v_Str || '        <title>Osteoporosis</title>' || LF;
    v_Str := v_Str || '        <value>' || Get_InfoPathData(' PA_Bone_Osteoporosis ',v_CaseId,'TF') || '</value>' || LF;
    v_Str := v_Str || '        <managementPlan>' || Get_InfoPathData('PA_Bone_Osteoporosis_Plan_E1                                                  
+ PA_Bone_Osteoporosis_Plan_E2                                                  
+ PA_Bone_Osteoporosis_Plan_E3                                                  
+ PA_Bone_Osteoporosis_Plan_E4                                                  
+ PA_Bone_Osteoporosis_Plan_E5                                                  
+ PA_Bone_Osteoporosis_Plan_M1                                                  
+ PA_Bone_Osteoporosis_Plan_M2                                                  
+ PA_Bone_Osteoporosis_Plan_M3                                                  
+ PA_Bone_Osteoporosis_Plan_R1                                                  
+ PA_Bone_Osteoporosis_Plan_R2                                                  
',v_CaseId,'MP') || '</managementPlan>' || LF;

    v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
    v_Str := v_Str || '        <title>Pathological Fracture Vertebra</title>' || LF;
    v_Str := v_Str || '        <value>' || Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
    v_Str := v_Str || '   <subDiagnosis>' || Get_InfoPathData('',v_CaseId,'ST') || '</subDiagnosis>' || LF;
    v_Str := v_Str || '        <title>Healing</title>' || LF;
    v_Str := v_Str || '        <value>' || Get_InfoPathData(' PA_Bone_Path_Frac_Vertebra_Healing ',v_CaseId,'ST') || '</value>' || LF;
    v_Str := v_Str || '        <managementPlan>' || Get_InfoPathData('PA_Bone_Path_Frac_Vertebra_Plan_E1                                                  
+ PA_Bone_Path_Frac_Vertebra_Plan_E2                                                  
+ PA_Bone_Path_Frac_Vertebra_Plan_E3                                                  
+ PA_Bone_Path_Frac_Vertebra_Plan_E4                                                  
+ PA_Bone_Path_Frac_Vertebra_Plan_E5                                                  
+ PA_Bone_Path_Frac_Vertebra_Plan_M1                                                  
+ PA_Bone_Path_Frac_Vertebra_Plan_M2                                                  
+ PA_Bone_Path_Frac_Vertebra_Plan_M3                                                  
+ PA_Bone_Path_Frac_Vertebra_Plan_R1                                                  
+ PA_Bone_Path_Frac_Vertebra_Plan_R2                                                  
',v_CaseId,'MP') || '</managementPlan>' || LF;

    v_Str := v_Str || '   <subDiagnosis>' || Get_InfoPathData('',v_CaseId,'ST') || '</subDiagnosis>' || LF;
    v_Str := v_Str || '        <title>History of</title>' || LF;
    v_Str := v_Str || '        <value>' || Get_InfoPathData(' PA_Bone_Path_Frac_Vertebra_History ',v_CaseId,'ST') || '</value>' || LF;
    v_Str := v_Str || '        <managementPlan>' || Get_InfoPathData('PA_Bone_Path_Frac_Vertebra_Plan_E1                                                  
+ PA_Bone_Path_Frac_Vertebra_Plan_E2                                                  
+ PA_Bone_Path_Frac_Vertebra_Plan_E3                                                  
+ PA_Bone_Path_Frac_Vertebra_Plan_E4                                                  
+ PA_Bone_Path_Frac_Vertebra_Plan_E5                                                  
+ PA_Bone_Path_Frac_Vertebra_Plan_M1                                                  
+ PA_Bone_Path_Frac_Vertebra_Plan_M2                                                  
+ PA_Bone_Path_Frac_Vertebra_Plan_M3                                                  
+ PA_Bone_Path_Frac_Vertebra_Plan_R1                                                  
+ PA_Bone_Path_Frac_Vertebra_Plan_R2                                                  
',v_CaseId,'MP') || '</managementPlan>' || LF;

    v_Str := v_Str || '   <subDiagnosis>' || Get_InfoPathData('',v_CaseId,'ST') || '</subDiagnosis>' || LF;
    v_Str := v_Str || '        <title>Non-healed</title>' || LF;
    v_Str := v_Str || '        <value>' || Get_InfoPathData(' PA_Bone_Path_Frac_Vertebra_Nonhealed ',v_CaseId,'ST') || '</value>' || LF;
    v_Str := v_Str || '        <managementPlan>' || Get_InfoPathData('PA_Bone_Path_Frac_Vertebra_Plan_E1                                                  
+ PA_Bone_Path_Frac_Vertebra_Plan_E2                                                  
+ PA_Bone_Path_Frac_Vertebra_Plan_E3                                                  
+ PA_Bone_Path_Frac_Vertebra_Plan_E4                                                  
+ PA_Bone_Path_Frac_Vertebra_Plan_E5                                                  
+ PA_Bone_Path_Frac_Vertebra_Plan_M1                                                  
+ PA_Bone_Path_Frac_Vertebra_Plan_M2                                                  
+ PA_Bone_Path_Frac_Vertebra_Plan_M3                                                  
+ PA_Bone_Path_Frac_Vertebra_Plan_R1                                                  
+ PA_Bone_Path_Frac_Vertebra_Plan_R2                                                  
',v_CaseId,'MP') || '</managementPlan>' || LF;

    v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
    v_Str := v_Str || '        <title>Pathological Fracture Hip</title>' || LF;
    v_Str := v_Str || '        <value>' || Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
    v_Str := v_Str || '   <subDiagnosis>' || Get_InfoPathData('',v_CaseId,'ST') || '</subDiagnosis>' || LF;
    v_Str := v_Str || '        <title>Healing</title>' || LF;
    v_Str := v_Str || '        <value>' || Get_InfoPathData(' PA_Bone_Path_Frac_Hip_Healing ',v_CaseId,'ST') || '</value>' || LF;
    v_Str := v_Str || '        <managementPlan>' || Get_InfoPathData('PA_Bone_Path_Frac_Hip_Plan_E1                                                  
+ PA_Bone_Path_Frac_Hip_Plan_E2                                                  
+ PA_Bone_Path_Frac_Hip_Plan_E3                                                  
+ PA_Bone_Path_Frac_Hip_Plan_E4                                                  
+ PA_Bone_Path_Frac_Hip_Plan_E5                                                  
+ PA_Bone_Path_Frac_Hip_Plan_M1                                                  
+ PA_Bone_Path_Frac_Hip_Plan_M2                                                  
+ PA_Bone_Path_Frac_Hip_Plan_M3                                                  
+ PA_Bone_Path_Frac_Hip_Plan_R1                                                  
+ PA_Bone_Path_Frac_Hip_Plan_R2                                                  
',v_CaseId,'MP') || '</managementPlan>' || LF;

    v_Str := v_Str || '   <subDiagnosis>' || Get_InfoPathData('',v_CaseId,'ST') || '</subDiagnosis>' || LF;
    v_Str := v_Str || '        <title>History of</title>' || LF;
    v_Str := v_Str || '        <value>' || Get_InfoPathData(' PA_Bone_Path_Frac_Hip_History ',v_CaseId,'ST') || '</value>' || LF;
    v_Str := v_Str || '        <managementPlan>' || Get_InfoPathData('PA_Bone_Path_Frac_Hip_Plan_E1                                                  
+ PA_Bone_Path_Frac_Hip_Plan_E2                                                  
+ PA_Bone_Path_Frac_Hip_Plan_E3                                                  
+ PA_Bone_Path_Frac_Hip_Plan_E4                                                  
+ PA_Bone_Path_Frac_Hip_Plan_E5                                                  
+ PA_Bone_Path_Frac_Hip_Plan_M1                                                  
+ PA_Bone_Path_Frac_Hip_Plan_M2                                                  
+ PA_Bone_Path_Frac_Hip_Plan_M3                                                  
+ PA_Bone_Path_Frac_Hip_Plan_R1                                                  
+ PA_Bone_Path_Frac_Hip_Plan_R2                                                  
',v_CaseId,'MP') || '</managementPlan>' || LF;

    v_Str := v_Str || '   <subDiagnosis>' || Get_InfoPathData('',v_CaseId,'ST') || '</subDiagnosis>' || LF;
    v_Str := v_Str || '        <title>Non-healed</title>' || LF;
    v_Str := v_Str || '        <value>' || Get_InfoPathData(' PA_Bone_Path_Frac_Hip_Nonhealed ',v_CaseId,'ST') || '</value>' || LF;
    v_Str := v_Str || '        <managementPlan>' || Get_InfoPathData('PA_Bone_Path_Frac_Hip_Plan_E1                                                  
+ PA_Bone_Path_Frac_Hip_Plan_E2                                                  
+ PA_Bone_Path_Frac_Hip_Plan_E3                                                  
+ PA_Bone_Path_Frac_Hip_Plan_E4                                                  
+ PA_Bone_Path_Frac_Hip_Plan_E5                                                  
+ PA_Bone_Path_Frac_Hip_Plan_M1                                                  
+ PA_Bone_Path_Frac_Hip_Plan_M2                                                  
+ PA_Bone_Path_Frac_Hip_Plan_M3                                                  
+ PA_Bone_Path_Frac_Hip_Plan_R1                                                  
+ PA_Bone_Path_Frac_Hip_Plan_R2                                                  
',v_CaseId,'MP') || '</managementPlan>' || LF;
    v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
    v_Str := v_Str || '        <title>History of Traumatic Fracture</title>' || LF;
    v_Str := v_Str || '        <value>' || Get_InfoPathData(' PA_Bone_History_Traumatic_Fracture ',v_CaseId,'TF') || '</value>' || LF;
    v_Str := v_Str || '        <managementPlan>' || Get_InfoPathData(
    'PA_Bone_History_Traumatic_Fracture_Plan_E1                                                  
+ PA_Bone_History_Traumatic_Fracture_Plan_E2                                                  
+ PA_Bone_History_Traumatic_Fracture_Plan_E3                                                  
+ PA_Bone_History_Traumatic_Fracture_Plan_E4                                                  
+ PA_Bone_History_Traumatic_Fracture_Plan_E5                                                  
+ PA_Bone_History_Traumatic_Fracture_Plan_M1                                                  
+ PA_Bone_History_Traumatic_Fracture_Plan_M2                                                  
+ PA_Bone_History_Traumatic_Fracture_Plan_M3                                                  
+ PA_Bone_History_Traumatic_Fracture_Plan_R1                                                  
+ PA_Bone_History_Traumatic_Fracture_Plan_R2                                                  
',v_CaseId,'ST') ||
    '</managementPlan>' || LF;

    v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
    v_Str := v_Str || '        <title>Amputation Status</title>' || LF;
    v_Str := v_Str || '        <value>' || Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
    v_Str := v_Str || '        <subDiagnosis>' || Get_InfoPathData('',v_CaseId,'ST') || '</subDiagnosis>' || LF;
    v_Str := v_Str || '            <title>Above Knee</title>' || LF;
    v_Str := v_Str || '            <value>' || Get_InfoPathData(' PA_Bone_Amputation_Above_Knee ',v_CaseId,'ST') || '</value>' || LF;
    v_Str := v_Str || '            <managementPlan>' || Get_InfoPathData('PA_Bone_Amputation_Plan_E1                                                  
+ PA_Bone_Amputation_Plan_E2                                                  
+ PA_Bone_Amputation_Plan_E3                                                  
+ PA_Bone_Amputation_Plan_E4                                                  
+ PA_Bone_Amputation_Plan_E5                                                  
+ PA_Bone_Amputation_Plan_M1                                                  
+ PA_Bone_Amputation_Plan_M2                                                  
+ PA_Bone_Amputation_Plan_M3                                                  
+ PA_Bone_Amputation_Plan_R1                                                  
+ PA_Bone_Amputation_Plan_R2                                                  
',v_CaseId,'MP') || '</managementPlan>' || LF;
    v_Str := v_Str || '            <managementPlan>' || Get_InfoPathData('',v_CaseId,'MP') || '</managementPlan>' || LF;
    v_Str := v_Str || '        <subDiagnosis>' || Get_InfoPathData('',v_CaseId,'ST') || '</subDiagnosis>' || LF;
    v_Str := v_Str || '            <title>Below Knee</title>' || LF;
    v_Str := v_Str || '            <value>' || Get_InfoPathData(' PA_Bone_Amputation_Below_Knee ',v_CaseId,'ST') || '</value>' || LF;
    v_Str := v_Str || '            <managementPlan>' || Get_InfoPathData('PA_Bone_Amputation_Plan_E1                                                  
+ PA_Bone_Amputation_Plan_E2                                                  
+ PA_Bone_Amputation_Plan_E3                                                  
+ PA_Bone_Amputation_Plan_E4                                                  
+ PA_Bone_Amputation_Plan_E5                                                  
+ PA_Bone_Amputation_Plan_M1                                                  
+ PA_Bone_Amputation_Plan_M2                                                  
+ PA_Bone_Amputation_Plan_M3                                                  
+ PA_Bone_Amputation_Plan_R1                                                  
+ PA_Bone_Amputation_Plan_R2                                                  
',v_CaseId,'MP') || '</managementPlan>' || LF;
    v_Str := v_Str || '            <managementPlan>' || Get_InfoPathData('',v_CaseId,'MP') || '</managementPlan>' || LF;
    v_Str := v_Str || '        <subDiagnosis>' || Get_InfoPathData('',v_CaseId,'ST') || '</subDiagnosis>' || LF;
    v_Str := v_Str || '            <title>Great Toe</title>' || LF;
    v_Str := v_Str || '            <value>' || Get_InfoPathData(' PA_Bone_Amputation_Great_Toe ',v_CaseId,'ST') || '</value>' || LF;
    v_Str := v_Str || '            <managementPlan>' || Get_InfoPathData('PA_Bone_Amputation_Plan_E1                                                  
+ PA_Bone_Amputation_Plan_E2                                                  
+ PA_Bone_Amputation_Plan_E3                                                  
+ PA_Bone_Amputation_Plan_E4                                                  
+ PA_Bone_Amputation_Plan_E5                                                  
+ PA_Bone_Amputation_Plan_M1                                                  
+ PA_Bone_Amputation_Plan_M2                                                  
+ PA_Bone_Amputation_Plan_M3                                                  
+ PA_Bone_Amputation_Plan_R1                                                  
+ PA_Bone_Amputation_Plan_R2                                                  
',v_CaseId,'MP') || '</managementPlan>' || LF;
    v_Str := v_Str || '            <managementPlan>' || Get_InfoPathData('',v_CaseId,'MP') || '</managementPlan>' || LF;
    v_Str := v_Str || '        <subDiagnosis>' || Get_InfoPathData('',v_CaseId,'ST') || '</subDiagnosis>' || LF;
    v_Str := v_Str || '            <title>TMA</title>' || LF;
    v_Str := v_Str || '            <value>' || Get_InfoPathData(' PA_Bone_Amputation_TMA ',v_CaseId,'ST') || '</value>' || LF;
    v_Str := v_Str || '            <managementPlan>' || Get_InfoPathData('PA_Bone_Amputation_Plan_E1                                                  
+ PA_Bone_Amputation_Plan_E2                                                  
+ PA_Bone_Amputation_Plan_E3                                                  
+ PA_Bone_Amputation_Plan_E4                                                  
+ PA_Bone_Amputation_Plan_E5                                                  
+ PA_Bone_Amputation_Plan_M1                                                  
+ PA_Bone_Amputation_Plan_M2                                                  
+ PA_Bone_Amputation_Plan_M3                                                  
+ PA_Bone_Amputation_Plan_R1                                                  
+ PA_Bone_Amputation_Plan_R2                                                  
',v_CaseId,'MP') || '</managementPlan>' || LF;
    v_Str := v_Str || '            <managementPlan>' || Get_InfoPathData('',v_CaseId,'MP') || '</managementPlan>' || LF;
    v_Str := v_Str || '        <subDiagnosis>' || Get_InfoPathData('',v_CaseId,'ST') || '</subDiagnosis>' || LF;
    v_Str := v_Str || '            <title>Other Toe(s)</title>' || LF;
    v_Str := v_Str || '            <value>' || Get_InfoPathData(' PA_Bone_Amputation_Other_Toes ',v_CaseId,'ST') || '</value>' || LF;
    v_Str := v_Str || '            <managementPlan>' || Get_InfoPathData('PA_Bone_Amputation_Plan_E1                                                  
+ PA_Bone_Amputation_Plan_E2                                                  
+ PA_Bone_Amputation_Plan_E3                                                  
+ PA_Bone_Amputation_Plan_E4                                                  
+ PA_Bone_Amputation_Plan_E5                                                  
+ PA_Bone_Amputation_Plan_M1                                                  
+ PA_Bone_Amputation_Plan_M2                                                  
+ PA_Bone_Amputation_Plan_M3                                                  
+ PA_Bone_Amputation_Plan_R1                                                  
+ PA_Bone_Amputation_Plan_R2                                                  
',v_CaseId,'MP') || '</managementPlan>' || LF;
    v_Str := v_Str || '            <managementPlan>' || Get_InfoPathData('',v_CaseId,'MP') || '</managementPlan>' || LF;
    v_Str := v_Str || '        <subDiagnosis>' || LF;
    v_Str := v_Str || '            <title>Other:</title>' || LF;
    v_Str := v_Str || '            <value>' || Get_InfoPathData(' PA_Bone_Amputation_Other ',v_CaseId,'ST') || '</value>' || LF;
    v_Str := v_Str || '            <followUpQuestions>'|| LF;
    v_Str := v_Str || '               <title>Other:</title>' || LF;
    v_Str := v_Str || '               <answer>' || Get_InfoPathData(' PA_Bone_Amputation_Other_Box ',v_CaseId,'ST') || '</answer>' || LF;
    v_Str := v_Str || '               <value>' || Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
    v_Str := v_Str || '            </followUpQuestions>'|| LF;
    v_Str := v_Str || '        </subDiagnosis>' || LF;
    v_Str := v_Str || '        <managementPlan>' || Get_InfoPathData('PA_Bone_Amputation_Plan_E1                                                  
+ PA_Bone_Amputation_Plan_E2                                                  
+ PA_Bone_Amputation_Plan_E3                                                  
+ PA_Bone_Amputation_Plan_E4                                                  
+ PA_Bone_Amputation_Plan_E5                                                  
+ PA_Bone_Amputation_Plan_M1                                                  
+ PA_Bone_Amputation_Plan_M2                                                  
+ PA_Bone_Amputation_Plan_M3                                                  
+ PA_Bone_Amputation_Plan_R1                                                  
+ PA_Bone_Amputation_Plan_R2                                                  
',v_CaseId,'MP') || '</managementPlan>' || LF;

    v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
    v_Str := v_Str || '        <title>Joint Replacement Status</title>' || LF;
    v_Str := v_Str || '        <value>' || Get_InfoPathData('',v_CaseId,'TF') || '</value>' || LF;
    v_Str := v_Str || '        <subDiagnosis>' || Get_InfoPathData('',v_CaseId,'ST') || '</subDiagnosis>' || LF;
    v_Str := v_Str || '            <title>Knee</title>' || LF;
    v_Str := v_Str || '            <value>' || Get_InfoPathData(' PA_Bone_Joint_Knee ',v_CaseId,'ST') || '</value>' || LF;
    v_Str := v_Str || '            <managementPlan>' || Get_InfoPathData('PA_Bone_Joint_Plan_E1                                                  
+ PA_Bone_Joint_Plan_E2                                                  
+ PA_Bone_Joint_Plan_E3                                                  
+ PA_Bone_Joint_Plan_E4                                                  
+ PA_Bone_Joint_Plan_E5                                                  
+ PA_Bone_Joint_Plan_M1                                                  
+ PA_Bone_Joint_Plan_M2                                                  
+ PA_Bone_Joint_Plan_M3                                                  
+ PA_Bone_Joint_Plan_R1                                                  
+ PA_Bone_Joint_Plan_R2                                                  
',v_CaseId,'MP') || '</managementPlan>' || LF;
    v_Str := v_Str || '            <managementPlan>' || Get_InfoPathData('',v_CaseId,'MP') || '</managementPlan>' || LF;
    v_Str := v_Str || '        <subDiagnosis>' || Get_InfoPathData('',v_CaseId,'ST') || '</subDiagnosis>' || LF;
    v_Str := v_Str || '            <title>Hip</title>' || LF;
    v_Str := v_Str || '            <value>' || Get_InfoPathData(' PA_Bone_Joint_Hip ',v_CaseId,'ST') || '</value>' || LF;
    v_Str := v_Str || '            <managementPlan>' || Get_InfoPathData('PA_Bone_Joint_Plan_E1                                                  
+ PA_Bone_Joint_Plan_E2                                                  
+ PA_Bone_Joint_Plan_E3                                                  
+ PA_Bone_Joint_Plan_E4                                                  
+ PA_Bone_Joint_Plan_E5                                                  
+ PA_Bone_Joint_Plan_M1                                                  
+ PA_Bone_Joint_Plan_M2                                                  
+ PA_Bone_Joint_Plan_M3                                                  
+ PA_Bone_Joint_Plan_R1                                                  
+ PA_Bone_Joint_Plan_R2                                                  
',v_CaseId,'MP') || '</managementPlan>' || LF;
    v_Str := v_Str || '        <subDiagnosis>' || LF;
    v_Str := v_Str || '            <title>Other:</title>' || LF;
    v_Str := v_Str || '            <value>' || Get_InfoPathData(' PA_Bone_Joint_Other ',v_CaseId,'TF') || '</value>' || LF;
    v_Str := v_Str || '            <followUpQuestions>'|| LF;
    v_Str := v_Str || '               <title>Other:</title>' || LF;
    v_Str := v_Str || '               <answer>' || Get_InfoPathData(' PA_Bone_Joint_Other_Box',v_CaseId,'ST') || '</answer>' || LF;
    v_Str := v_Str || '               <value>' || Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
    v_Str := v_Str || '            </followUpQuestions>'|| LF;
    v_Str := v_Str || '        </subDiagnosis>' || LF;
    v_Str := v_Str || '        <managementPlan>' || Get_InfoPathData('PA_Bone_Joint_Plan_E1                                                  
+ PA_Bone_Joint_Plan_E2                                                  
+ PA_Bone_Joint_Plan_E3                                                  
+ PA_Bone_Joint_Plan_E4                                                  
+ PA_Bone_Joint_Plan_E5                                                  
+ PA_Bone_Joint_Plan_M1                                                  
+ PA_Bone_Joint_Plan_M2                                                  
+ PA_Bone_Joint_Plan_M3                                                  
+ PA_Bone_Joint_Plan_R1                                                  
+ PA_Bone_Joint_Plan_R2                                                  
',v_CaseId,'MP') || '</managementPlan>' || LF;

    v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
    v_Str := v_Str || '        <title>Gait Disturbance or Abnormality</title>' || LF;
    v_Str := v_Str || '        <value>' || Get_InfoPathData(' PA_Bone_Gait_Disturbance ',v_CaseId,'TF') || '</value>' || LF;
    v_Str := v_Str || '        <followUpQuestions>' || LF;
    v_Str := v_Str || '            <title>Related to a joint problem</title>' || LF;
    v_Str := v_Str || '            <answer>' || Get_InfoPathData(' PA_Bone_Gait_Joint_Problem ',v_CaseId,'ST') || '</answer>' || LF;
    v_Str := v_Str || '            <value>' || Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
    v_Str := v_Str || '        </followUpQuestions>'|| LF;
    v_Str := v_Str || '        <managementPlan>' || Get_InfoPathData('PA_Bone_Gait_Plan_E1                                                  
+ PA_Bone_Gait_Plan_E2                                                  
+ PA_Bone_Gait_Plan_E3                                                  
+ PA_Bone_Gait_Plan_E4                                                  
+ PA_Bone_Gait_Plan_E5                                                  
+ PA_Bone_Gait_Plan_M1                                                  
+ PA_Bone_Gait_Plan_M2                                                  
+ PA_Bone_Gait_Plan_M3                                                  
+ PA_Bone_Gait_Plan_R1                                                  
+ PA_Bone_Gait_Plan_R2                                                  
',v_CaseId,'MP') || '</managementPlan>' || LF;

    v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
    v_Str := v_Str || '        <title>Other Significant Diagnoses</title>' || LF;
    v_Str := v_Str || '        <value>' || Get_InfoPathData(' PA_Bone_Other ',v_CaseId,'TF') || '</value>' || LF;
    v_Str := v_Str || '        <followUpQuestions>' || LF;
    v_Str := v_Str || '            <title>Other:</title>' || LF;
    v_Str := v_Str || '            <answer>' || Get_InfoPathData(' PA_Bone_Other_Box ',v_CaseId,'ST') || '</answer>' || LF;
    v_Str := v_Str || '            <value>' || Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
    v_Str := v_Str || '        </followUpQuestions>'|| LF;
    v_Str := v_Str || '        <managementPlan>' || Get_InfoPathData('PA_Bone_Other_E1                                                  
+ PA_Bone_Other_E2                                                  
+ PA_Bone_Other_E3                                                  
+ PA_Bone_Other_E4                                                  
+ PA_Bone_Other_E5                                                  
+ PA_Bone_Other_M1                                                  
+ PA_Bone_Other_M2                                                  
+ PA_Bone_Other_M3                                                  
+ PA_Bone_Other_R1                                                  
+ PA_Bone_Other_R2                                                  
',v_CaseId,'MP') || '</managementPlan>' || LF;

    v_Str := v_Str || '   <sections>' || Get_InfoPathData('',v_CaseId,'ST') || '</sections>' || LF;
    v_Str := v_Str || '        <title>Other</title>' || LF;
    v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
    v_Str := v_Str || '        <title>Legal Blindness</title>' || LF;
    v_Str := v_Str || '        <value>' || Get_InfoPathData(' PA_Other_Legal_Blindness ',v_CaseId,'TF') || '</value>' || LF;
    v_Str := v_Str || '        <managementPlan>' || Get_InfoPathData('PA_Other_Legal_Blindness_Plan_E1                                                  
+ PA_Other_Legal_Blindness_Plan_E2                                                  
+ PA_Other_Legal_Blindness_Plan_E3                                                  
+ PA_Other_Legal_Blindness_Plan_E4                                                  
+ PA_Other_Legal_Blindness_Plan_E5                                                  
+ PA_Other_Legal_Blindness_Plan_M1                                                  
+ PA_Other_Legal_Blindness_Plan_M2                                                  
+ PA_Other_Legal_Blindness_Plan_M3                                                  
+ PA_Other_Legal_Blindness_Plan_R1                                                  
+ PA_Other_Legal_Blindness_Plan_R2                                                  
',v_CaseId,'MP') || '</managementPlan>' || LF;

    v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
    v_Str := v_Str || '        <title>Macular Degeneration</title>' || LF;
    v_Str := v_Str || '        <value>' || Get_InfoPathData(' PA_Other_Macular_Degen ',v_CaseId,'TF') || '</value>' || LF;
    v_Str := v_Str || '        <managementPlan>' || Get_InfoPathData('PA_Other_Macular_Degen_Plan_E1                                                  
+ PA_Other_Macular_Degen_Plan_E2                                                  
+ PA_Other_Macular_Degen_Plan_E3                                                  
+ PA_Other_Macular_Degen_Plan_E4                                                  
+ PA_Other_Macular_Degen_Plan_E5                                                  
+ PA_Other_Macular_Degen_Plan_M1                                                  
+ PA_Other_Macular_Degen_Plan_M2                                                  
+ PA_Other_Macular_Degen_Plan_M3                                                  
+ PA_Other_Macular_Degen_Plan_R1                                                  
+ PA_Other_Macular_Degen_Plan_R2                                                  
',v_CaseId,'MP') || '</managementPlan>' || LF;

    v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
    v_Str := v_Str || '        <title>Glaucoma</title>' || LF;
    v_Str := v_Str || '        <value>' || Get_InfoPathData(' PA_Other_Glaucoma ',v_CaseId,'TF') || '</value>' || LF;
    v_Str := v_Str || '        <managementPlan>' || Get_InfoPathData('PA_Other_Glaucoma_Plan_E1                                                  
+ PA_Other_Glaucoma_Plan_E2                                                  
+ PA_Other_Glaucoma_Plan_E3                                                  
+ PA_Other_Glaucoma_Plan_E4                                                  
+ PA_Other_Glaucoma_Plan_E5                                                  
+ PA_Other_Glaucoma_Plan_M1                                                  
+ PA_Other_Glaucoma_Plan_M2                                                  
+ PA_Other_Glaucoma_Plan_M3                                                  
+ PA_Other_Glaucoma_Plan_R1                                                  
+ PA_Other_Glaucoma_Plan_R2                                                  
',v_CaseId,'MP') || '</managementPlan>' || LF;

    v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
    v_Str := v_Str || '        <title>Hearing Impairment/Deafness</title>' || LF;
    v_Str := v_Str || '        <value>' || Get_InfoPathData(' PA_Other_Hearing_Impairment ',v_CaseId,'TF') || '</value>' || LF;
    v_Str := v_Str || '        <managementPlan>' || Get_InfoPathData('PA_Other_Hearing_Impairment_Plan_E1                                                  
+ PA_Other_Hearing_Impairment_Plan_E2                                                  
+ PA_Other_Hearing_Impairment_Plan_E3                                                  
+ PA_Other_Hearing_Impairment_Plan_E4                                                  
+ PA_Other_Hearing_Impairment_Plan_E5                                                  
+ PA_Other_Hearing_Impairment_Plan_M1                                                  
+ PA_Other_Hearing_Impairment_Plan_M2                                                  
+ PA_Other_Hearing_Impairment_Plan_M3                                                  
+ PA_Other_Hearing_Impairment_Plan_R1                                                  
+ PA_Other_Hearing_Impairment_Plan_R2                                                  
',v_CaseId,'ST') || '</managementPlan>'
    || LF;

    v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
    v_Str := v_Str || '        <title>HIV Infection with Symptoms</title>' || LF;
    v_Str := v_Str || '        <value>' || Get_InfoPathData(' PA_Other_HIV ',v_CaseId,'TF') || '</value>' || LF;
    v_Str := v_Str || '        <managementPlan>' || Get_InfoPathData('PA_Other_HIV_Plan_E1                                                  
+ PA_Other_HIV_Plan_E2                                                  
+ PA_Other_HIV_Plan_E3                                                  
+ PA_Other_HIV_Plan_E4                                                  
+ PA_Other_HIV_Plan_E5                                                  
+ PA_Other_HIV_Plan_M1                                                  
+ PA_Other_HIV_Plan_M2                                                  
+ PA_Other_HIV_Plan_M3                                                  
+ PA_Other_HIV_Plan_R1                                                  
+ PA_Other_HIV_Plan_R2                                                  
',v_CaseId,'MP') || '</managementPlan>' || LF;

    v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
    v_Str := v_Str || '        <title>Asymptomatic HIV Infection Status</title>' || LF;
    v_Str := v_Str || '        <value>' || Get_InfoPathData(' PA_Other_Asymptomatic_HIV ',v_CaseId,'TF') || '</value>' || LF;
    v_Str := v_Str || '        <managementPlan>' || Get_InfoPathData('PA_Other_Asymptomatic_HIV_Plan_E1                                                  
+ PA_Other_Asymptomatic_HIV_Plan_E2                                                  
+ PA_Other_Asymptomatic_HIV_Plan_E3                                                  
+ PA_Other_Asymptomatic_HIV_Plan_E4                                                  
+ PA_Other_Asymptomatic_HIV_Plan_E5                                                  
+ PA_Other_Asymptomatic_HIV_Plan_M1                                                  
+ PA_Other_Asymptomatic_HIV_Plan_M2                                                  
+ PA_Other_Asymptomatic_HIV_Plan_M3                                                  
+ PA_Other_Asymptomatic_HIV_Plan_R1                                                  
+ PA_Other_Asymptomatic_HIV_Plan_R2                                                  
',v_CaseId,'MP') || '</managementPlan>' || LF;

    v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
    v_Str := v_Str || '        <title>Other significant diagnoses:</title>' || LF;
    v_Str := v_Str || '        <value>' || Get_InfoPathData(' PA_Other_Other ',v_CaseId,'TF') || '</value>' || LF;
    v_Str := v_Str || '        <followUpQuestions>' || LF;
    v_Str := v_Str || '            <title>Other:</title>' || LF;
    v_Str := v_Str || '            <answer>' || Get_InfoPathData(' PA_Other_Other_Box',v_CaseId,'ST') || '</answer>' || LF;
    v_Str := v_Str || '            <value>' || Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
    v_Str := v_Str || '        </followUpQuestions>'|| LF;
    v_Str := v_Str || '        <managementPlan>' || Get_InfoPathData('PA_Other_Other_Plan_E1                                                  
+ PA_Other_Other_Plan_E2                                                  
+ PA_Other_Other_Plan_E3                                                  
+ PA_Other_Other_Plan_E4                                                  
+ PA_Other_Other_Plan_E5                                                  
+ PA_Other_Other_Plan_M1                                                  
+ PA_Other_Other_Plan_M2                                                  
+ PA_Other_Other_Plan_M3                                                  
+ PA_Other_Other_Plan_R1                                                  
+ PA_Other_Other_Plan_R2                                                  
',v_CaseId,'MP') || '</managementPlan>' || LF;
    v_Str := v_Str || '  </diagnosis></sections></ProviderAssessment>' || LF;
    ------------------------------------
    RETURN v_Str;
  EXCEPTION
  WHEN OTHERS THEN
    v_Str := SUBSTR(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || CHR(13) || SQLERRM,1,4000);
  END;

/

