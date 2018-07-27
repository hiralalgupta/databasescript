--------------------------------------------------------
--  DDL for Function MATRIX_XML_DIABETICSCREEN_BK1
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SNX_IWS2"."MATRIX_XML_DIABETICSCREEN_BK1" 
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

v_Str := v_Str || '<DiabeticScreen>'  || LF;
v_Str := v_Str || '   <diagnosis>' ||  Get_InfoPathData('',v_CaseId,'ST') || '</diagnosis>'  || LF;

v_Str := v_Str || '        <title>Diabetes Mellitus:</title>'  || LF;
v_Str := v_Str || '        <value>' ||  Get_InfoPathData('',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '        <followupQuestions>' ||  Get_InfoPathData('',v_CaseId,'ST') || '</followupQuestions>'  || LF;
v_Str := v_Str || '         <title>Type</title>'  || LF;

v_Str := v_Str || '         <answer>' ||  Get_InfoPathData('Diabetes_Diag_Mellitus_type_1 + Diabetes_Diag_Mellitus_type_2',v_CaseId,'ST') || '</answer>'  || LF;

v_Str := v_Str || '   <diagnosis>' ||  Get_InfoPathData('',v_CaseId,'ST') || '</diagnosis>'  || LF;

v_Str := v_Str || '        <title>Diabetes Mellitus: Controlled</title>'  || LF;
v_Str := v_Str || '        <value>' ||  Get_InfoPathData('',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '        <followupQuestions>' ||  Get_InfoPathData('',v_CaseId,'ST') || '</followupQuestions>'  || LF;

v_Str := v_Str || '         <title>Controlled</title>'  || LF;

v_Str := v_Str || '         <answer>' ||  Get_InfoPathData('Diabetes_Diag_Controlled + Diabetes_Diag_Uncontrolled + Diabetes_Diag_Unknown',v_CaseId,'ST') || '</answer>'  || LF;

v_Str := v_Str || '   <diagnosis>' ||  Get_InfoPathData('',v_CaseId,'ST') || '</diagnosis>'  || LF;

v_Str := v_Str || '        <title>Ophthalmic Complications</title>'  || LF;
v_Str := v_Str || '        <value>' ||  Get_InfoPathData('',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '        <followupQuestions>' ||  Get_InfoPathData('',v_CaseId,'ST') || '</followupQuestions>'  || LF;

v_Str := v_Str || '         <title>Background Diabetic Retinopathy</title>'  || LF;

v_Str := v_Str || '         <value>' ||  Get_InfoPathData('Diabetes_Background_Retinopathy',v_CaseId,'ST') || '</value>'  || LF;

v_Str := v_Str || '        <followupQuestions>' ||  Get_InfoPathData('',v_CaseId,'ST') || '</followupQuestions>'  || LF;

v_Str := v_Str || '         <title>Proliferative Diabetic Retinopathy</title>'  || LF;

v_Str := v_Str || '         <value>' ||  Get_InfoPathData('Diabetes_Proliferative_Retinopathy',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '            <secondaryQuestions>' ||  Get_InfoPathData('',v_CaseId,'ST') || '</secondaryQuestions>'  || LF;

v_Str := v_Str || '                  <title>Diabetic Macular/Retinal Edema (if clearly documented)</title>'  || LF;

v_Str := v_Str || '                  <value>' ||  Get_InfoPathData('Diabetes_Edema',v_CaseId,'ST') || '</value>'  || LF;

v_Str := v_Str || '            <secondaryQuestions>' ||  Get_InfoPathData('',v_CaseId,'ST') || '</secondaryQuestions>'  || LF;

v_Str := v_Str || '                  <title>Specific Diagnosis if known:</title>'  || LF;

v_Str := v_Str || '                  <value>' ||  Get_InfoPathData('Diabetes_Edema_Diagnosis',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '                  <answer>' ||  Get_InfoPathData('Diabetes_Edema_Diagnosis_Box',v_CaseId,'ST') || '</answer>'  || LF;

v_Str := v_Str || '   <diagnosis>' ||  Get_InfoPathData('',v_CaseId,'ST') || '</diagnosis>'  || LF;

v_Str := v_Str || '        <title>Peripheral Circulatory Complications</title>'  || LF;
v_Str := v_Str || '        <value>' ||  Get_InfoPathData('',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '        <followupQuestions>' ||  Get_InfoPathData('',v_CaseId,'ST') || '</followupQuestions>'  || LF;

v_Str := v_Str || '         <title>Peripheral Angiopathy (peripheral arterial vascular disease - PVD)</title>'  || LF;

v_Str := v_Str || '         <value>' ||  Get_InfoPathData('Diabetes_Diag_Peripheral_Angiopathy',v_CaseId,'ST') || '</value>'  || LF;

v_Str := v_Str || '        <followupQuestions>' ||  Get_InfoPathData('',v_CaseId,'ST') || '</followupQuestions>'  || LF;

v_Str := v_Str || '         <title>Gangrene</title>'  || LF;

v_Str := v_Str || '         <value>' ||  Get_InfoPathData('Diabetes_Diag_Gangrene',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '            <secondaryQuestions>' ||  Get_InfoPathData('',v_CaseId,'ST') || '</secondaryQuestions>'  || LF;

v_Str := v_Str || '                  <title>Specify:</title>'  || LF;

v_Str := v_Str || '                  <answer>' ||  Get_InfoPathData('Diabetes_Diag_Gangrene_Specify',v_CaseId,'ST') || '</answer>'  || LF;
v_Str := v_Str || '                  <value>' ||  Get_InfoPathData('',v_CaseId,'ST') || '</value>'  || LF;

v_Str := v_Str || '        <followupQuestions>' ||  Get_InfoPathData('',v_CaseId,'ST') || '</followupQuestions>'  || LF;

v_Str := v_Str || '         <title>Amputation</title>'  || LF;

v_Str := v_Str || '         <value>' ||  Get_InfoPathData('Diabetes_Diag_Amputation',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '            <secondaryQuestions>' ||  Get_InfoPathData('',v_CaseId,'ST') || '</secondaryQuestions>'  || LF;

v_Str := v_Str || '                  <title>Amputation location</title>'  || LF;

v_Str := v_Str || '                  <answer>' ||  Get_InfoPathData('Diabetes_Diag_Amputation_Location',v_CaseId,'ST') || '</answer>'  || LF;
v_Str := v_Str || '                  <value>' ||  Get_InfoPathData('',v_CaseId,'ST') || '</value>'  || LF;

v_Str := v_Str || '   <diagnosis>' ||  Get_InfoPathData('',v_CaseId,'ST') || '</diagnosis>'  || LF;

v_Str := v_Str || '        <title>Renal Complications</title>'  || LF;
v_Str := v_Str || '        <value>' ||  Get_InfoPathData('',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '        <followupQuestions>' ||  Get_InfoPathData('',v_CaseId,'ST') || '</followupQuestions>'  || LF;

v_Str := v_Str || '         <title>Diabetic Nephropathy</title>'  || LF;

v_Str := v_Str || '         <value>' ||  Get_InfoPathData('Diabetes_Nephropathy',v_CaseId,'ST') || '</value>'  || LF;

v_Str := v_Str || '        <followupQuestions>' ||  Get_InfoPathData('',v_CaseId,'ST') || '</followupQuestions>'  || LF;

v_Str := v_Str || '         <title>Chronic Kidney Disease</title>'  || LF;

v_Str := v_Str || '         <value>' ||  Get_InfoPathData('Diabetes_Kidney_Disease',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '            <secondaryQuestions>' ||  Get_InfoPathData('',v_CaseId,'ST') || '</secondaryQuestions>'  || LF;

v_Str := v_Str || '                  <title>Stage</title>'  || LF;

v_Str := v_Str || '                  <answer>' ||  Get_InfoPathData('Diabetes_Kidney_Disease_Stage',v_CaseId,'ST') || '</answer>'  || LF;
v_Str := v_Str || '                  <value>' ||  Get_InfoPathData('',v_CaseId,'ST') || '</value>'  || LF;

v_Str := v_Str || '            <secondaryQuestions>' ||  Get_InfoPathData('',v_CaseId,'ST') || '</secondaryQuestions>'  || LF;

v_Str := v_Str || '                  <title>Currently on dialysis</title>'  || LF;

v_Str := v_Str || '                  <value>' ||  Get_InfoPathData('Diabetes_On_Dialysis',v_CaseId,'ST') || '</value>'  || LF;

v_Str := v_Str || '   <diagnosis>' ||  Get_InfoPathData('',v_CaseId,'ST') || '</diagnosis>'  || LF;

v_Str := v_Str || '    <title>Long Term (Current) Use of Insulin</title>'  || LF;

v_Str := v_Str || '    <value>' ||  Get_InfoPathData('Diabetes_Use_Insulin',v_CaseId,'ST') || '</value>'  || LF;

v_Str := v_Str || '   <diagnosis>' ||  Get_InfoPathData('',v_CaseId,'ST') || '</diagnosis>'  || LF;

v_Str := v_Str || '        <title>Other Diabetic Complications</title>'  || LF;
v_Str := v_Str || '        <value>' ||  Get_InfoPathData('',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '        <followupQuestions>' ||  Get_InfoPathData('',v_CaseId,'ST') || '</followupQuestions>'  || LF;

v_Str := v_Str || '         <title>Diabetic Ulcer</title>'  || LF;

v_Str := v_Str || '         <value>' ||  Get_InfoPathData('Diabetes_NonPressure_Ulcer',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '            <secondaryQuestions>' ||  Get_InfoPathData('',v_CaseId,'ST') || '</secondaryQuestions>'  || LF;

v_Str := v_Str || '                  <title>Site</title>'  || LF;

v_Str := v_Str || '                  <answer>' ||  Get_InfoPathData('Diabetes_NonPressure_Ulcer_Site',v_CaseId,'ST') || '</answer>'  || LF;
v_Str := v_Str || '                  <value>' ||  Get_InfoPathData('',v_CaseId,'ST') || '</value>'  || LF;

v_Str := v_Str || '        <followupQuestions>' ||  Get_InfoPathData('',v_CaseId,'ST') || '</followupQuestions>'  || LF;

v_Str := v_Str || '         <title>Diabetic Hypoglycemia (acute)</title>'  || LF;

v_Str := v_Str || '         <value>' ||  Get_InfoPathData('Diabetes_Hypoglycemia',v_CaseId,'ST') || '</value>'  || LF;

v_Str := v_Str || '   <diagnosis>' ||  Get_InfoPathData('',v_CaseId,'ST') || '</diagnosis>'  || LF;

v_Str := v_Str || '        <title>Neurologic Complications</title>'  || LF;
v_Str := v_Str || '        <value>' ||  Get_InfoPathData('',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '        <followupQuestions>' ||  Get_InfoPathData('',v_CaseId,'ST') || '</followupQuestions>'  || LF;

v_Str := v_Str || '         <title>Diabetic Peripheral Neuropathy</title>'  || LF;

v_Str := v_Str || '         <value>' ||  Get_InfoPathData('Diabetes_Diag_Peripheral_Neuropathy',v_CaseId,'ST') || '</value>'  || LF;

v_Str := v_Str || '        <followupQuestions>' ||  Get_InfoPathData('',v_CaseId,'ST') || '</followupQuestions>'  || LF;

v_Str := v_Str || '         <title>Diabetic Autonomic Neuropathy</title>'  || LF;

v_Str := v_Str || '         <value>' ||  Get_InfoPathData('Diabetes_Diag_Autonomic_Neuropathy',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '            <secondaryQuestions>' ||  Get_InfoPathData('',v_CaseId,'ST') || '</secondaryQuestions>'  || LF;

v_Str := v_Str || '                  <title>Gastroparesis</title>'  || LF;

v_Str := v_Str || '                  <value>' ||  Get_InfoPathData('Diabetes_Diag_Gastroparesis',v_CaseId,'ST') || '</value>'  || LF;

v_Str := v_Str || '            <secondaryQuestions>' ||  Get_InfoPathData('',v_CaseId,'ST') || '</secondaryQuestions>'  || LF;

v_Str := v_Str || '                  <title>Other:</title>'  || LF;

v_Str := v_Str || '                  <value>' ||  Get_InfoPathData('Diabetes_Diag_Other',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '                  <answer>' ||  Get_InfoPathData('Diabetes_Diag_Other_Box',v_CaseId,'ST') || '</answer>'  || LF;
v_Str := v_Str || '                  <answer>' ||  Get_InfoPathData('',v_CaseId,'ST') || '</answer>'  || LF;

v_Str := v_Str || '   <screenGroups>' ||  Get_InfoPathData('',v_CaseId,'ST') || '</screenGroups>'  || LF;

v_Str := v_Str || '        <title>Diabetic neurologic complications: peripheral neuropathy</title>'  || LF;
v_Str := v_Str || '        <value>' ||  Get_InfoPathData('',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '        <questions>' ||  Get_InfoPathData('',v_CaseId,'ST') || '</questions>'  || LF;

v_Str := v_Str || '         <title>On questioning patient notes experiencing numbness and/or tingling in hands or feet</title>'  || LF;

v_Str := v_Str || '         <value>' ||  Get_InfoPathData('Diabetes_Peripheral_Numbness',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '         <title>On exam has decreased sensation in feet</title>'  || LF;

v_Str := v_Str || '         <value>' ||  Get_InfoPathData('Diabetes_Peripheral_Sensation',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '         <title>Has been prescribed medicine to treat peripheral neuropathy symptoms</title>'  || LF;

v_Str := v_Str || '         <value>' ||  Get_InfoPathData('Diabetes_Peripheral_Medication',v_CaseId,'ST') || '</value>'  || LF;

v_Str := v_Str || '   <screenGroups>' ||  Get_InfoPathData('',v_CaseId,'ST') || '</screenGroups>'  || LF;

v_Str := v_Str || '        <title>Diabetic neurologic complications: autonomic neuropathy</title>'  || LF;
v_Str := v_Str || '        <value>' ||  Get_InfoPathData('',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '        <questions>' ||  Get_InfoPathData('',v_CaseId,'ST') || '</questions>'  || LF;

v_Str := v_Str || '         <title>Gives history of wide swings in blood pressure or temperature</title>'  || LF;

v_Str := v_Str || '         <value>' ||  Get_InfoPathData('Diabetes_Autonomic_Swings',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '         <title>Gives history of difficulty digesting meals because stomach doesn~t empty properly</title>'  || LF;

v_Str := v_Str || '         <value>' ||  Get_InfoPathData('Diabetes_Autonomic_Digesting',v_CaseId,'ST') || '</value>'  || LF;

v_Str := v_Str || '   <screenGroups>' ||  Get_InfoPathData('',v_CaseId,'ST') || '</screenGroups>'  || LF;

v_Str := v_Str || '        <title>Diabetic cirulatory complications: peripheral vascular disease on exam of the lower extremities and feet</title>'  || LF;
v_Str := v_Str || '        <value>' ||  Get_InfoPathData('',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '        <questions>' ||  Get_InfoPathData('',v_CaseId,'ST') || '</questions>'  || LF;

v_Str := v_Str || '         <title>Has decreased pulses</title>'  || LF;

v_Str := v_Str || '         <value>' ||  Get_InfoPathData('Diabetes_Circulatory_Decreased_Pulses',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '         <title>Has decreased temperature, hair loss, and thin shiny skin consistent with arterial insufficiency</title>'  || LF;

v_Str := v_Str || '         <value>' ||  Get_InfoPathData('Diabetes_Circulatory_Decreased_Temp',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '         <title>Has evidence of arterial ulcer</title>'  || LF;

v_Str := v_Str || '         <value>' ||  Get_InfoPathData('Diabetes_Circulatory_Arterial_Ulcer',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '            <extraData>' ||  Get_InfoPathData('',v_CaseId,'ST') || '</extraData>'  || LF;

v_Str := v_Str || '                  <title>Location:</title>'  || LF;

v_Str := v_Str || '                  <value>' ||  Get_InfoPathData('Diabetes_Circulatory_Arterial_Ulcer_Location',v_CaseId,'ST') || '</value>'  || LF;

v_Str := v_Str || '         <title>Has evidence of gangrene</title>'  || LF;

v_Str := v_Str || '         <value>' ||  Get_InfoPathData('Diabetes_Circulatory_Gangrene',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '            <extraData>' ||  Get_InfoPathData('',v_CaseId,'ST') || '</extraData>'  || LF;

v_Str := v_Str || '                  <title>Location:</title>'  || LF;

v_Str := v_Str || '                  <value>' ||  Get_InfoPathData('Diabetes_Circulatory_Gangrene_Location',v_CaseId,'ST') || '</value>'  || LF;

v_Str := v_Str || '         <title>Has evidence of amputation resulting from poor circulation</title>'  || LF;

v_Str := v_Str || '         <value>' ||  Get_InfoPathData('Diabetes_Circulatory_Amputation',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '            <extraData>' ||  Get_InfoPathData('',v_CaseId,'ST') || '</extraData>'  || LF;

v_Str := v_Str || '                  <title>Location:</title>'  || LF;

v_Str := v_Str || '                  <value>' ||  Get_InfoPathData('Diabetes_Circulatory_Amputation_Location',v_CaseId,'ST') || '</value>'  || LF;

v_Str := v_Str || '         <title>Provides history consistent with intermittent claudication</title>'  || LF;

v_Str := v_Str || '         <value>' ||  Get_InfoPathData('Diabetes_Circulatory_Claudication',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '         <title>Has been prescribed medicine to try to improve peripheral circulation</title>'  || LF;

v_Str := v_Str || '         <value>' ||  Get_InfoPathData('Diabetes_Circulatory_Medication',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '         <title>Has a history of vascular surgery to improve peripheral circulation</title>'  || LF;

v_Str := v_Str || '         <value>' ||  Get_InfoPathData('Diabetes_Circulatory_Surgery',v_CaseId,'ST') || '</value>'  || LF;

v_Str := v_Str || '   <screenGroups>' ||  Get_InfoPathData('',v_CaseId,'ST') || '</screenGroups>'  || LF;

v_Str := v_Str || '        <title>Diabetic ophthalmic complications: retinopathy</title>'  || LF;
v_Str := v_Str || '        <value>' ||  Get_InfoPathData('',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '        <questions>' ||  Get_InfoPathData('',v_CaseId,'ST') || '</questions>'  || LF;

v_Str := v_Str || '         <title>Has been diagnosed by an eye specialist</title>'  || LF;

v_Str := v_Str || '         <value>' ||  Get_InfoPathData('Diabetes_Ophthalmic_Diagnosed',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '            <extraData>' ||  Get_InfoPathData('',v_CaseId,'ST') || '</extraData>'  || LF;

v_Str := v_Str || '                  <title>specific diagnosis known?</title>'  || LF;

v_Str := v_Str || '                  <value>' ||  Get_InfoPathData('Diabetes_Ophthalmic_Diagnosis',v_CaseId,'ST') || '</value>'  || LF;

v_Str := v_Str || '         <title>Has received treatment such as laser treatment for diabetic retinal disease</title>'  || LF;

v_Str := v_Str || '         <value>' ||  Get_InfoPathData('Diabetes_Ophthalmic_Treatment',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '         <title>Is blind as a result of diabetic retinopathy</title>'  || LF;

v_Str := v_Str || '         <value>' ||  Get_InfoPathData('Diabetes_Ophthalmic_Blind',v_CaseId,'ST') || '</value>'  || LF;

v_Str := v_Str || '   <screenGroups>' ||  Get_InfoPathData('',v_CaseId,'ST') || '</screenGroups>'  || LF;

v_Str := v_Str || '        <title>Diabetic renal complications: nephropathy</title>'  || LF;
v_Str := v_Str || '        <value>' ||  Get_InfoPathData('',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '        <questions>' ||  Get_InfoPathData('',v_CaseId,'ST') || '</questions>'  || LF;

v_Str := v_Str || '         <title>Has been diagnosised with chronic kidney disease due to diabetes</title>'  || LF;

v_Str := v_Str || '         <value>' ||  Get_InfoPathData('Diabetes_Renal_Kidney_Disease',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '         <title>Has been advised to take medication or modify diet due to kidney disease</title>'  || LF;

v_Str := v_Str || '         <value>' ||  Get_InfoPathData('Diabetes_Renal_Medication',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '         <title>Has been told there is excess protein or albumin in urine</title>'  || LF;

v_Str := v_Str || '         <value>' ||  Get_InfoPathData('Diabetes_Renal_Excess_Protein',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '         <title>Is currently treated with dialysis</title>'  || LF;

v_Str := v_Str || '         <value>' ||  Get_InfoPathData('Diabetes_Renal_Treated',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '         <title>Is currently treated with dialysis</title>'  || LF;

v_Str := v_Str || '         <value>' ||  Get_InfoPathData('',v_CaseId,'ST') || '</value>'  || LF;

v_Str := v_Str || '   <testingGroup>' ||  Get_InfoPathData('',v_CaseId,'ST') || '</testingGroup>'  || LF;

v_Str := v_Str || '        <desc>' ||  Get_InfoPathData('',v_CaseId,'ST') || '</desc>'  || LF;
v_Str := v_Str || '        <title>Does the patient have regular testing of (check all that apply):</title>'  || LF;
v_Str := v_Str || '        <questions>' ||  Get_InfoPathData('',v_CaseId,'ST') || '</questions>'  || LF;

v_Str := v_Str || '         <title>Self-monitoring blood glucose</title>'  || LF;

v_Str := v_Str || '         <status>' ||  Get_InfoPathData('Diabetes_Blood_Sugar',v_CaseId,'ST') || '</status>'  || LF;
v_Str := v_Str || '         <title>HbA1c</title>'  || LF;

v_Str := v_Str || '         <status>' ||  Get_InfoPathData('Diabetes_HbA1C',v_CaseId,'ST') || '</status>'  || LF;
v_Str := v_Str || '         <title>Urine for protein</title>'  || LF;

v_Str := v_Str || '         <status>' ||  Get_InfoPathData('Diabetes_Protein',v_CaseId,'ST') || '</status>'  || LF;
v_Str := v_Str || '         <title>Cholesterol/LDL-C</title>'  || LF;

v_Str := v_Str || '         <status>' ||  Get_InfoPathData('Diabetes_LDL',v_CaseId,'ST') || '</status>'  || LF;
v_Str := v_Str || '         <title>Diabetic foot exam</title>'  || LF;

v_Str := v_Str || '         <status>' ||  Get_InfoPathData('Diabetes_Foot_Exam',v_CaseId,'ST') || '</status>'  || LF;
v_Str := v_Str || '         <title>Dilated or retinal eye exam by an eye specialist</title>'  || LF;

v_Str := v_Str || '         <status>' ||  Get_InfoPathData('Diabetes_Eye_Exam',v_CaseId,'ST') || '</status>'  || LF;

v_Str := v_Str || '</DiabeticScreen>'  || LF;


------------------------------------


       RETURN v_Str;
       
       EXCEPTION WHEN OTHERS THEN
            v_Str := SUBSTR(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
                              CHR(13) ||
                              SQLERRM,1,4000); 
           
       END;

/

