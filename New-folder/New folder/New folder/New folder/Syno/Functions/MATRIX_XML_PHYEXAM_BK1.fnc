--------------------------------------------------------
--  DDL for Function MATRIX_XML_PHYEXAM_BK1
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SNX_IWS2"."MATRIX_XML_PHYEXAM_BK1" 
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
v_Str := v_Str || '   <PhysicalExam>' || LF;
 
v_Str := v_Str || '   <bloodPressures>' ||  Get_InfoPathData('',v_CaseId,'ST') || '</bloodPressures>'  || LF;
 
v_Str := v_Str || '        <title>Advised to follow up with PCP for ongoing care</title>'  || LF;
v_Str := v_Str || '        <leftOrRight>' ||  Get_InfoPathData('Physical_BP_R+Physical_BP_L',v_CaseId,'ST') || '</leftOrRight>'  || LF;
v_Str := v_Str || '        <systolic>' ||  Get_InfoPathData('Physical_BP_R+Physical_BP_L',v_CaseId,'ST') || '</systolic>'  || LF;
v_Str := v_Str || '        <diastolic>' ||  Get_InfoPathData('Physical_BP_R+Physical_BP_L',v_CaseId,'ST') || '</diastolic>'  || LF;
 
v_Str := v_Str || '   <pulse>' ||  Get_InfoPathData('Physical_Pulse',v_CaseId,'ST') || '</pulse>'  || LF;
v_Str := v_Str || '   <respiration>' ||  Get_InfoPathData('Physical_Resp',v_CaseId,'ST') || '</respiration>'  || LF;
v_Str := v_Str || '   <o2sat>' ||  Get_InfoPathData('Physical_Sat',v_CaseId,'ST') || '</o2sat>'  || LF;
v_Str := v_Str || '   <o2sat>' ||  Get_InfoPathData('Physical_Temp',v_CaseId,'ST') || '</o2sat>'  || LF;
v_Str := v_Str || '   <weight>' ||  Get_InfoPathData('Physical_Weight',v_CaseId,'ST') || '</weight>'  || LF;
v_Str := v_Str || '   <usualWeight>' ||  Get_InfoPathData('Physical_Usual_WT',v_CaseId,'ST') || '</usualWeight>'  || LF;
v_Str := v_Str || '   <heightFeet>' ||  Get_InfoPathData('Physical_Height',v_CaseId,'ST') || '</heightFeet>'  || LF;
v_Str := v_Str || '   <heightInches>' ||  Get_InfoPathData('Physical_Height',v_CaseId,'ST') || '</heightInches>'  || LF;
v_Str := v_Str || '   <pulseType>' ||  Get_InfoPathData('',v_CaseId,'ST') || '</pulseType>'  || LF;
v_Str := v_Str || '   <bmi>' ||  Get_InfoPathData('Physical_BMI',v_CaseId,'ST') || '</bmi>'  || LF;
 
v_Str := v_Str || '   <weightLoss>'  || LF;
 
v_Str := v_Str || '    <title>Physical_Weight_Loss</title>'  || LF; 
v_Str := v_Str || '    <value>' ||  Get_InfoPathData('Physical_Weight_Loss',v_CaseId,'ST') || '</value>'  || LF;
 
v_Str := v_Str || '    <title>Physical_Weight_Loss_Yes</title>'  || LF;
v_Str := v_Str || '    <value>' ||  Get_InfoPathData('Physical_Weight_Loss_Yes',v_CaseId,'ST') || '</value>'  || LF;
 
v_Str := v_Str || '    <title>Physical_Weight_Loss_lbs_Over</title>'  || LF;
v_Str := v_Str || '    <value>' ||  Get_InfoPathData('Physical_Weight_Loss_lbs_Over',v_CaseId,'ST') || '</value>'  || LF;
 
v_Str := v_Str || '    <title>Physical_Weight_Loss_From_Date</title>'  || LF;
v_Str := v_Str || '    <value>' ||  Get_InfoPathData('Physical_Weight_Loss_From_Date',v_CaseId,'ST') || '</value>'  || LF;
 
v_Str := v_Str || '    <title>Physical_Weight_Loss_To_Date</title>'  || LF;
v_Str := v_Str || '    <value>' ||  Get_InfoPathData('Physical_Weight_Loss_To_Date',v_CaseId,'ST') || '</value>'  || LF;
 
v_Str := v_Str || '        <managementPlan>' ||  Get_InfoPathData('',v_CaseId,'ST') || '</managementPlan>'  || LF;
 
v_Str := v_Str || '   </weightLoss>'  || LF;
 
v_Str := v_Str || '   <pain>'  || LF;
 
v_Str := v_Str || '        <painScale>'  || LF;
 
v_Str := v_Str || '            <label>Advised to follow up with PCP for ongoing care</label>'  || LF;
v_Str := v_Str || '            <quantity>' ||  Get_InfoPathData('Physical_Pain_Scale',v_CaseId,'ST') || '</quantity>'  || LF;
v_Str := v_Str || '        </painScale>'  || LF; 
 
v_Str := v_Str || '        <questions>'  || LF;
 
v_Str := v_Str || '         <title>Pain Location</title>'  || LF;
v_Str := v_Str || '         <answer>' ||  Get_InfoPathData('Physical_Pain_Location',v_CaseId,'ST') || '</answer>'  || LF;
v_Str := v_Str || '         <value>' ||  Get_InfoPathData('Physical_Pain_Location',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '        </questions>'  || LF;
 
v_Str := v_Str || '        <questions>'  || LF;
v_Str := v_Str || '         <title>Quality of Pain</title>'  || LF;
v_Str := v_Str || '         <answer>' ||  Get_InfoPathData('Quality of Pain',v_CaseId,'ST') || '</answer>'  || LF;
v_Str := v_Str || '         <value>' ||  Get_InfoPathData('Quality of Pain',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '         <othervalue>' ||  Get_InfoPathData('Quality of Pain',v_CaseId,'ST') || '</othervalue>'  || LF;
 
v_Str := v_Str || '         <secondaryQuestions>'  || LF;
v_Str := v_Str || '          <title>Other</title>'  || LF;
v_Str := v_Str || '          <value>' ||  Get_InfoPathData('Other',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '         </secondaryQuestions>'  || LF; 
 
v_Str := v_Str || '        </questions>'  || LF;
 
v_Str := v_Str || '        <questions>'  || LF;
v_Str := v_Str || '         <title>Pattern of Pain</title>'  || LF;
v_Str := v_Str || '         <answer>' ||  Get_InfoPathData('Pattern of Pain',v_CaseId,'ST') || '</answer>'  || LF;
v_Str := v_Str || '         <value>' ||  Get_InfoPathData('Pattern of Pain',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '        </questions>'  || LF;
 
v_Str := v_Str || '        <questions>'  || LF;
v_Str := v_Str || '         <title>Intervention?</title>'  || LF;
v_Str := v_Str || '         <value>' ||  Get_InfoPathData('Intervention?',v_CaseId,'ST') || '</value>'  || LF;
 
v_Str := v_Str || '         <secondaryQuestions>'  || LF;
v_Str := v_Str || '          <title>Reason</title>'  || LF;
v_Str := v_Str || '          <value>' ||  Get_InfoPathData('Reason',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '         </secondaryQuestions>'  || LF; 
 
v_Str := v_Str || '         <secondaryQuestions>'  || LF;
v_Str := v_Str || '          <title>Details</title>'  || LF;
v_Str := v_Str || '          <answer>' ||  Get_InfoPathData('Details',v_CaseId,'ST') || '</answer>'  || LF;
v_Str := v_Str || '          <value>' ||  Get_InfoPathData('Details',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '         </secondaryQuestions>'  || LF; 
 
v_Str := v_Str || '        </questions>'  || LF;
 
v_Str := v_Str || '   </pain>'  || LF;
 
--v_Str := v_Str || '                         <answer>' ||  Get_InfoPathData('Physical_Pain_Intervention_Education + Physical_Pain_Intervention_Medication + 
--    Physical_Pain_Intervention_Support + Physical_Pain_No_Intervention  Physical_Pain_No_Intervention_Lack_Severity + Physical_Pain_No_Intervention_Patient_Pref',v_CaseId,'ST') || '</answer>'  || LF;
 
 
v_Str := v_Str || '   <mental>'  || LF;
 
v_Str := v_Str || '        <sectionTitle>Mental Status Screen- Mini Cog Test</sectionTitle>'  || LF;
 
v_Str := v_Str || '        <isCorrect>'  ||  LF;
v_Str := v_Str || '         <title># of right words (if 3 then stop-screen is negative)</title>'  || LF;
v_Str := v_Str || '         <value>' ||  Get_InfoPathData('Mental_Status_Score',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '        </isCorrect>'  ||  LF;
 
v_Str := v_Str || '        <rating>' ||  Get_InfoPathData('',v_CaseId,'ST') || '</rating>'  || LF;
 
v_Str := v_Str || '        <clockValid>'  || LF; 
v_Str := v_Str || '         <title>Mental_Status_Time</title>'  || LF;
v_Str := v_Str || '         <value>' ||  Get_InfoPathData('Clock appears normal?',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '        </clockValid>'  || LF;
 
--v_Str := v_Str || '        <testValid>' ||  Get_InfoPathData('',v_CaseId,'ST') || '</testValid>'  || LF;
--v_Str := v_Str || '        <instructions>' ||  Get_InfoPathData('',v_CaseId,'ST') || '</instructions>'  || LF;
--v_Str := v_Str || '        <interpretation>' ||  Get_InfoPathData('',v_CaseId,'ST') || '</interpretation>'  || LF;
 
v_Str := v_Str || '   </mental>'  || LF;
 
v_Str := v_Str || '   <sections>'  || LF;
v_Str := v_Str || '   <sectionTitle>General</sectionTitle>'  || LF;
 
v_Str := v_Str || '        <followUpQuestion>' ||  LF;
 
v_Str := v_Str || '            <title>Distress Level</title>'  || LF;
v_Str := v_Str || '            <answer>' ||  Get_InfoPathData('Physical_Gen_Distress',v_CaseId,'ST') || '</answer>'  || LF;
--v_Str := v_Str || '            <answer>' ||  Get_InfoPathData('',v_CaseId,'ST') || '</answer>'  || LF;
 
v_Str := v_Str || '        </followUpQuestion>' ||  LF;
 
v_Str := v_Str || '        <followUpQuestion>' ||  LF;
 
v_Str := v_Str || '            <title>Body Appearance</title>'  || LF;
v_Str := v_Str || '            <answer>' ||  Get_InfoPathData('Physical_Gen_Body_Appearance',v_CaseId,'ST') || '</answer>'  || LF;
 
v_Str := v_Str || '        </followUpQuestion>' ||  LF;
 
v_Str := v_Str || '        <followUpQuestion>'  || LF;
 
v_Str := v_Str || '            <title>Responsiveness Level</title>'  || LF;
v_Str := v_Str || '            <answer>' ||  Get_InfoPathData('Physical_Gen_Drowsy , Physical_Gen_Cooperative,  Physical_Gen_Combative ,  Physical_Gen_Alert,  Physical_Gen_Withdrawn,  Physical_Gen_Other',v_CaseId,'ST') || '</answer>'  || LF;
 
v_Str := v_Str || '        </followUpQuestion>' ||  LF;
 
v_Str := v_Str || '   </sections>'  || LF;
 
v_Str := v_Str || '   <sections>'  || LF;
 
v_Str := v_Str || '   <sectionTitle>EENT</sectionTitle>'  || LF;
 
v_Str := v_Str || '        <followUpQuestion>' || LF;
 
v_Str := v_Str || '            <title>PERRLA</title>'  || LF;
v_Str := v_Str || '            <value>' ||  Get_InfoPathData('Physical_EENT_Perrla',v_CaseId,'ST') || '</value>'  || LF;
 
v_Str := v_Str || '        </followUpQuestion>' || LF;
 
v_Str := v_Str || '        <followUpQuestion>' || LF;
 
v_Str := v_Str || '            <title>Extra Occular Motion Intact</title>'  || LF;
v_Str := v_Str || '            <value>' ||  Get_InfoPathData('Physical_EENT_Extra_Ocular',v_CaseId,'ST') || '</value>'  || LF;
 
v_Str := v_Str || '        </followUpQuestion>' || LF;
 
v_Str := v_Str || '        <followUpQuestion>'  || LF;
--v_Str := v_Str || '            <title>Oral Lesions</title>'  || LF;
--v_Str := v_Str || '            <value>' ||  Get_InfoPathData('Physical_EENT_Oral_Lesions',v_CaseId,'ST') || '</value>'  || LF;
 
v_Str := v_Str || '          <secondaryQuestions>' ||  LF;
 
v_Str := v_Str || '            <title>Location</title>'  || LF;
v_Str := v_Str || '            <answer>' ||  Get_InfoPathData('Physical_EENT_',v_CaseId,'ST') || '</answer>'  || LF;
 
v_Str := v_Str || '          </secondaryQuestions>' ||  LF;
 
v_Str := v_Str || '        </followUpQuestion>' || LF;
 
v_Str := v_Str || '        <followUpQuestion>' || LF;
 
v_Str := v_Str || '            <title>Teeth</title>'  || LF;
v_Str := v_Str || '            <answer>' ||  Get_InfoPathData('Physical_EENT_Teeth_Dentures, Physical_EENT_Teeth_Edentulous,  Physical_EENT_Teeth_Intact,  Physical_EENT_Teeth_Missing', v_CaseId,'ST') || '</answer>'  || LF;
 
v_Str := v_Str || '        </followUpQuestion>' || LF;
    
--MISSING 
--v_Str := v_Str || '        <followUpQuestion>' || LF;
 
--v_Str := v_Str || '            <title>Oral Hygiene</title>'  || LF;
--v_Str := v_Str || '        </followUpQuestion>' || LF;
 
v_Str := v_Str || '   </sections>'  || LF;
 
 
v_Str := v_Str || '   <sections>'  || LF;
 
v_Str := v_Str || '   <sectionTitle>Neuro</sectionTitle>'  || LF;
 
v_Str := v_Str || '        <followUpQuestion>' || LF;
 
v_Str := v_Str || '            <title>CN 2-12 Intact</title>'  || LF;
v_Str := v_Str || '            <value>' ||  Get_InfoPathData('Physical_Neuro_CN_Intact',v_CaseId,'ST') || '</value>'  || LF;
 
v_Str := v_Str || '        </followUpQuestion>' || LF;
 
v_Str := v_Str || '        <followUpQuestion>' ||  LF;
 
v_Str := v_Str || '            <title>Speech normal</title>'  || LF;
v_Str := v_Str || '            <value>' ||  Get_InfoPathData('Physical_Neuro_Speech',v_CaseId,'ST') || '</value>'  || LF;
 
v_Str := v_Str || '                  <secondaryQuestions>' ||  LF;
 
v_Str := v_Str || '                         <title>Abnormality</title>'  || LF;
-- MISSING ANSWER LINE
v_Str := v_Str || '            <value>' ||  Get_InfoPathData('Physical_Neuro_Speech_Abnormality',v_CaseId,'ST') || '</value>'  || LF;
--MISSING OtherValue Line
 
v_Str := v_Str || '                  </secondaryQuestions>' ||  LF;
 
v_Str := v_Str || '        </followUpQuestion>' || LF;
 
 
v_Str := v_Str || '        <followUpQuestion>'  || LF;
 
v_Str := v_Str || '            <title>Cerebellar exam: Normal finger to nose?</title>'  || LF;
v_Str := v_Str || '            <answer>' ||  Get_InfoPathData('Physical_Neuro_Finger_to_Nose',v_CaseId,'ST') || '</answer>'  || LF;
 
v_Str := v_Str || '        </followUpQuestion>' || LF;
 
v_Str := v_Str || '        <followUpQuestion>' || LF;
 
v_Str := v_Str || '            <title>Cerebellar exam: Balance normal (Romberg test)?</title>'  || LF;
v_Str := v_Str || '            <value>' ||  Get_InfoPathData('Physical_Neuro_Romberg_Test',v_CaseId,'ST') || '</value>'  || LF;
 
v_Str := v_Str || '        </followUpQuestion>' || LF;
 
v_Str := v_Str || '        <followUpQuestion>'  || LF;
 
v_Str := v_Str || '            <title>Sensory exam: Right UE</title>'  || LF;
v_Str := v_Str || '            <answer>' ||  Get_InfoPathData('Physical_Neuro_Sensory_Right_Normal_UE,  Physical_Neuro_Sensory_Right_Diminished_UE',v_CaseId,'ST') || '</answer>'  || LF;
 
v_Str := v_Str || '        </followUpQuestion>' || LF;
 
v_Str := v_Str || '        <followUpQuestion>' || LF;
 
v_Str := v_Str || '            <title>Sensory exam: Right LE</title>'  || LF;
v_Str := v_Str || '            <answer>' ||  Get_InfoPathData('Physical_Neuro_Sensory_Right_Normal_LE, Physical_Neuro_Sensory_Right_Diminished_LE',v_CaseId,'ST') || '</answer>'  || LF;
 
v_Str := v_Str || '        </followUpQuestion>' || LF;
 
v_Str := v_Str || '        <followUpQuestion>' ||  LF;
 
v_Str := v_Str || '            <title>Sensory exam: Left UE</title>'  || LF;
v_Str := v_Str || '            <answer>' ||  Get_InfoPathData('Physical_Neuro_Sensory_Left_Normal_UE, Physical_Neuro_Sensory_Left_Diminshed_UE',v_CaseId,'ST') || '</answer>'  || LF;
 
v_Str := v_Str || '        </followUpQuestion>' || LF;
 
v_Str := v_Str || '        <followUpQuestion>'  || LF;
 
v_Str := v_Str || '            <title>Sensory exam: Left LE</title>'  || LF;
v_Str := v_Str || '            <answer>' ||  Get_InfoPathData('Physical_Neuro_Sensory_Left_Normal_LE Physical_Neuro_Sensory_Left_Diminished_LE',v_CaseId,'ST') || '</answer>'  || LF;
 
v_Str := v_Str || '        </followUpQuestion>' || LF;
 
v_Str := v_Str || '        <followUpQuestion>' || LF;
 
v_Str := v_Str || '            <title>Reflexes: Right Biceps</title>'  || LF;
v_Str := v_Str || '            <answer>' ||  Get_InfoPathData('Physical_Neuro_Reflexes_Right_Normal_Biceps,  Physical_Neuro_Reflexes_Right_Diminished_Biceps',v_CaseId,'ST') || '</answer>'  || LF;
 
v_Str := v_Str || '        </followUpQuestion>' || LF;
 
v_Str := v_Str || '        <followUpQuestion>'  || LF;
 
v_Str := v_Str || '            <title>Reflexes: Right Achilles</title>'  || LF;
v_Str := v_Str || '            <answer>' ||  Get_InfoPathData('Physical_Neuro_Reflexes_Right_Normal_Achilles,  Physical_Neuro_Reflexes_Right_Diminished_Achilles',v_CaseId,'ST') || '</answer>'  || LF;
 
v_Str := v_Str || '        </followUpQuestion>' || LF;
 
v_Str := v_Str || '        <followUpQuestion>' || LF;
 
v_Str := v_Str || '            <title>Reflexes: Right Patellar</title>'  || LF;
v_Str := v_Str || '            <answer>' ||  Get_InfoPathData('Physical_Neuro_Reflexes_Left_Normal_Patellar,  Physical_Neuro_Reflexes_Right_Diminished_Patellar',v_CaseId,'ST') || '</answer>'  || LF;
 
v_Str := v_Str || '        </followUpQuestion>' || LF;
 
v_Str := v_Str || '        <followUpQuestion>'  || LF;
 
v_Str := v_Str || '            <title>Reflexes: Left Biceps</title>'  || LF;
v_Str := v_Str || '            <answer>' ||  Get_InfoPathData('Physical_Neuro_Reflexes_Left_Normal_Biceps,  Physical_Neuro_Reflexes_Left_Diminished_Biceps',v_CaseId,'ST') || '</answer>'  || LF;
 
v_Str := v_Str || '        </followUpQuestion>' || LF;
 
v_Str := v_Str || '        <followUpQuestion>'  || LF;
 
v_Str := v_Str || '            <title>Reflexes: Left Achilles</title>'  || LF;
v_Str := v_Str || '            <answer>' ||  Get_InfoPathData('Physical_Neuro_Reflexes_Left_Normal_Achilles,  Physical_Neuro_Reflexes_Left_Diminished_Achilles',v_CaseId,'ST') || '</answer>'  || LF;
 
v_Str := v_Str || '        </followUpQuestion>' || LF;
 
v_Str := v_Str || '        <followUpQuestion>'  || LF;
 
v_Str := v_Str || '            <title>Reflexes: Left Patellar</title>'  || LF;
v_Str := v_Str || '            <value>' ||  Get_InfoPathData('Physical_Neuro_Reflexes_Left_Normal_Patellar, Physical_Neuro_Reflexes_Left_Diminished_Patellar',v_CaseId,'ST') || '</value>'  || LF;
 
v_Str := v_Str || '        </followUpQuestion>' || LF;
 
v_Str := v_Str || '        <followUpQuestion>'  || LF;
 
v_Str := v_Str || '            <title>Strength: Right UE</title>'  || LF;
v_Str := v_Str || '            <answer>' ||  Get_InfoPathData('Physical_Neuro_Strength_Right_Normal_UE,  Physical_Neuro_Strength_Right_Monoparesis_UE, Physical_Neuro_Strength_Right_Diminished_Monoplegia_UE',v_CaseId,'ST') || '</answer>'  || LF;
 
v_Str := v_Str || '        </followUpQuestion>' || LF;
 
v_Str := v_Str || '        <followUpQuestion>'   || LF;
 
v_Str := v_Str || '            <title>Strength: Right LE</title>'  || LF;
v_Str := v_Str || '            <answer>' ||  Get_InfoPathData('Physical_Neuro_Strength_Right_Normal_LE,  Physical_Neuro_Strength_Right_Diminished_Monoplegia_LE, Physical_Neuro_Strength_Right_Monoparesis_LE',v_CaseId,'ST') || '</answer>'  || LF;
 
v_Str := v_Str || '        </followUpQuestion>' || LF;
 
v_Str := v_Str || '        <followUpQuestion>' ||  LF;
 
v_Str := v_Str || '            <title>Strength: Left UE</title>'  || LF;
v_Str := v_Str || '            <answer>' ||  Get_InfoPathData('Physical_Neuro_Strength_Left_Normal_UE,  Physical_Neuro_Strength_Left_Monoparesis_UE,  Physical_Neuro_Strength_Left_Diminished_Monoplegia_UE',v_CaseId,'ST') || '</answer>'  || LF;
 
v_Str := v_Str || '        </followUpQuestion>' || LF;
 
v_Str := v_Str || '        <followUpQuestion>'   || LF;
 
v_Str := v_Str || '            <title>Strength: Left LE</title>'  || LF;
v_Str := v_Str || '            <answer>' ||  Get_InfoPathData('Physical_Neuro_Strength_Left_Normal_LE, Physical_Neuro_Strength_Left_Diminished_Monoplegia_LE,  Physical_Neuro_Strength_Left_Monoparesis_LE',v_CaseId,'ST') || '</answer>'  || LF;
 
v_Str := v_Str || '        </followUpQuestion>' || LF;
 
v_Str := v_Str || '        <followUpQuestion>'  || LF;
 
v_Str := v_Str || '            <title>Strength Right</title>'  || LF;
v_Str := v_Str || '            <answer>' ||  Get_InfoPathData('Physical_Neuro_Strength_Right_Hemiplegia,  Physical_Neuro_Strength_Right_Hemiparesis',v_CaseId,'ST') || '</answer>'  || LF;
 
v_Str := v_Str || '        </followUpQuestion>' || LF;
 
v_Str := v_Str || '        <followUpQuestion>'   || LF;
 
v_Str := v_Str || '            <title>Strength Left</title>'  || LF;
v_Str := v_Str || '            <answer>' ||  Get_InfoPathData('Physical_Neuro_Strength_Left_Hemiplegia,  Physical_Neuro_Strength_Left_Hemiparesis',v_CaseId,'ST') || '</answer>'  || LF;
 
v_Str := v_Str || '        </followUpQuestion>' || LF;
 
v_Str := v_Str || '        <followUpQuestion>'  || LF;
 
v_Str := v_Str || '            <title>Paraplegia</title>'  || LF;
v_Str := v_Str || '            <value>' ||  Get_InfoPathData('Physical_Neuro_Strength_Paraplegia',v_CaseId,'ST') || '</value>'  || LF;
 
v_Str := v_Str || '        </followUpQuestion>' || LF;
 
v_Str := v_Str || '        <followUpQuestion>'  || LF;
 
v_Str := v_Str || '            <title>Quadriplegia</title>'  || LF;
v_Str := v_Str || '            <value>' ||  Get_InfoPathData('Physical_Neuro_Strength_Quadriplegia',v_CaseId,'ST') || '</value>'  || LF;
 
v_Str := v_Str || '        </followUpQuestion>' || LF;
 
v_Str := v_Str || '        <followUpQuestion>'   || LF;
 
v_Str := v_Str || '            <title>Cogwheel rigidity</title>'  || LF;
v_Str := v_Str || '            <answer>' ||  Get_InfoPathData('Physical_Neuro_Cogwheel',v_CaseId,'ST') || '</answer>'  || LF;
 
v_Str := v_Str || '        </followUpQuestion>' || LF;
 
v_Str := v_Str || '        <followUpQuestion>' ||  Get_InfoPathData('',v_CaseId,'ST') || '</followUpQuestion>'  || LF;
 
v_Str := v_Str || '            <title>Resting (pill rolling) tremor</title>'  || LF;
v_Str := v_Str || '            <answer>' ||  Get_InfoPathData('Physical_Neuro_Cogwheel_Resting',v_CaseId,'ST') || '</answer>'  || LF;
 
v_Str := v_Str || '        </followUpQuestion>' || LF;
 
v_Str := v_Str || '   </sections>'  || LF;
 
v_Str := v_Str || '   <sections>'  || LF;
 
v_Str := v_Str || '   <sectionTitle>Skin</sectionTitle>'  || LF;
 
v_Str := v_Str || '        <followUpQuestion>'  || LF;
 
v_Str := v_Str || '            <title>Rash</title>'  || LF;
v_Str := v_Str || '            <value>' ||  Get_InfoPathData('Physical_Skin_Rashes',v_CaseId,'ST') || '</value>'  || LF;
 
v_Str := v_Str || '                  <secondaryQuestions>'  || LF;
 
v_Str := v_Str || '                         <title>Describe Color:</title>'  || LF;
v_Str := v_Str || '                         <answer>' ||  Get_InfoPathData('Physical_Skin_Rashes_Describe',v_CaseId,'ST') || '</answer>'  || LF;
v_Str := v_Str || '                         <value>' ||  Get_InfoPathData('',v_CaseId,'ST') || '</value>'  || LF;
 
v_Str := v_Str || '                  </secondaryQuestions>'  || LF;
 
v_Str := v_Str || '                  <secondaryQuestions>'  || LF;
 
v_Str := v_Str || '                         <title>Describe Elevation:</title>'  || LF;
--MISSING ANSWER v_Str := v_Str || '                         <answer>' ||  Get_InfoPathData('',v_CaseId,'ST') || '</answer>'  || LF;
--Missing Value
 
v_Str := v_Str || '                  </secondaryQuestions>'  || LF;
 
v_Str := v_Str || '                  <secondaryQuestions>'   || LF;
 
v_Str := v_Str || '                         <title>Describe Shape:</title>'  || LF;
--MISSING ANSWER v_Str := v_Str || '                         <answer>' ||  Get_InfoPathData('',v_CaseId,'ST') || '</answer>'  || LF;
--Missing Value
v_Str := v_Str || '                  </secondaryQuestions>'  || LF;
 
v_Str := v_Str || '        </followUpQuestion>' || LF;
 
 
v_Str := v_Str || '        <followUpQuestion>'   || LF;
 
v_Str := v_Str || '            <title>Lesions</title>'  || LF;
v_Str := v_Str || '            <value>' ||  Get_InfoPathData('Physical_Skin_Lesions',v_CaseId,'ST') || '</value>'  || LF;
 
v_Str := v_Str || '                  <secondaryQuestions>'  || LF;
 
v_Str := v_Str || '                         <title>Describe</title>'  || LF;
--MISSING ANSWER v_Str := v_Str || '                         <answer>' ||  Get_InfoPathData('',v_CaseId,'ST') || '</answer>'  || LF;
--MISSING Value v_Str := v_Str || '                         <value>' ||  Get_InfoPathData('Physical_Skin_Lesions',v_CaseId,'ST') || '</value>'  || LF;
 
v_Str := v_Str || '                  </secondaryQuestions>'  || LF;
 
v_Str := v_Str || '                  <secondaryQuestions>'  || LF;
 
v_Str := v_Str || '                         <title>Other</title>'  || LF;
--MISSING ANSWER v_Str := v_Str || '                         <answer>' ||  Get_InfoPathData('',v_CaseId,'ST') || '</answer>'  || LF;
--MISSING VALUE v_Str := v_Str || '                         <value>' ||  Get_InfoPathData('',v_CaseId,'ST') || '</value>'  || LF;
 
v_Str := v_Str || '                  </secondaryQuestions>'  || LF;
 
v_Str := v_Str || '        </followUpQuestion>' || LF;
 
v_Str := v_Str || '        <followUpQuestion>'   || LF;
 
v_Str := v_Str || '         <title>Decubitus Ulcer(s)</title>'  || LF;
 
v_Str := v_Str || '         <value>' ||  Get_InfoPathData('Physical_Skin_Decubitus',v_CaseId,'ST') || '</value>'  || LF;
 
v_Str := v_Str || '                  <secondaryQuestions>'  || LF;
 
v_Str := v_Str || '                         <title>Stage</title>'  || LF;
 
v_Str := v_Str || '                         <answer>' ||  Get_InfoPathData('Physical_Skin_Decubitus_Healed',v_CaseId,'ST') || '</answer>'  || LF;
--MISSING VALUE
 
v_Str := v_Str || '                  </secondaryQuestions>'  || LF;
 
v_Str := v_Str || '                  <secondaryQuestions>'  || LF;
 
v_Str := v_Str || '                         <title>Location</title>'  || LF;
 
v_Str := v_Str || '                         <answer>' ||  Get_InfoPathData('Physical_Skin_Decubitus_Location',v_CaseId,'ST') || '</answer>'  || LF;
 --MISSING VALUE
 
v_Str := v_Str || '                  </secondaryQuestions>'  || LF;
 
v_Str := v_Str || '                  <secondaryQuestions>' ||  Get_InfoPathData('',v_CaseId,'ST') || '</secondaryQuestions>'  || LF;
 
v_Str := v_Str || '        </followUpQuestion>'  || LF;
 
v_Str := v_Str || '        <followUpQuestion>' ||  Get_InfoPathData('',v_CaseId,'ST') || '</followUpQuestion>'  || LF;
 
v_Str := v_Str || '         <title>Decubitus Ulcer(s)</title>'  || LF;
 
--MISSING v_Str := v_Str || '         <value>' ||  Get_InfoPathData('Physical_Skin_Decubitus_2',v_CaseId,'ST') || '</value>'  || LF;
 
--MISSING v_Str := v_Str || '                  <secondaryQuestions>'  || LF;
 
--MISSING v_Str := v_Str || '                         <title>Stage</title>'  || LF;
 
--MISSING v_Str := v_Str || '                         <answer>' ||  Get_InfoPathData('Physical_Skin_Decubitus_Healed_2',v_CaseId,'ST') || '</answer>'  || LF;
 
--v_Str := v_Str || '                  </secondaryQuestions>'  || LF;
--MISSING  v_Str := v_Str || '                  <secondaryQuestions>'  || LF;
 
--MISSING v_Str := v_Str || '                         <title>Location</title>'  || LF;
 
--MISSING v_Str := v_Str || '                         <answer>' ||  Get_InfoPathData('Physical_Skin_Decubitus_Location_2',v_CaseId,'ST') || '</answer>'  || LF;
--v_Str := v_Str || '                  </secondaryQuestions>'  || LF;
 
v_Str := v_Str || '        </followUpQuestion>'  || LF;
 
v_Str := v_Str || '        <followUpQuestion>'  || LF;
 
v_Str := v_Str || '         <title>Arterial Ulcer(s)</title>'  || LF;
 
v_Str := v_Str || '         <value>' ||  Get_InfoPathData('Physical_Skin_Arterial',v_CaseId,'ST') || '</value>'  || LF;
 
v_Str := v_Str || '                  <secondaryQuestions>'  || LF;
 
v_Str := v_Str || '                         <title>Location</title>'  || LF;
 
--SHOULD BE VALUE v_Str := v_Str || '                         <answer>' ||  Get_InfoPathData('Physical_Skin_Arterial_Box',v_CaseId,'ST') || '</answer>'  || LF;
--MISSING OtherValue
 
v_Str := v_Str || '                  </secondaryQuestions>'  || LF;
 
v_Str := v_Str || '        </followUpQuestion>'  || LF;
 
v_Str := v_Str || '        <followUpQuestion>'  || LF;
 
v_Str := v_Str || '         <title>Venous Ulcer(s)</title>'  || LF;
 
v_Str := v_Str || '         <value>' ||  Get_InfoPathData('Physical_Skin_Venous',v_CaseId,'ST') || '</value>'  || LF;
 
--v_Str := v_Str || '                  <secondaryQuestions>'  || LF;
 
--v_Str := v_Str || '                         <title>Stage</title>'  || LF;
 
--v_Str := v_Str || '                         <answer>' ||  Get_InfoPathData('Physical_Skin_Venous_Healed',v_CaseId,'ST') || '</answer>'  || LF;
 
v_Str := v_Str || '                  <secondaryQuestions>'  || LF;
 
v_Str := v_Str || '                         <title>Location</title>'  || LF;
 
--SHOULD BE FOR VENOUS ULCER v_Str := v_Str || '                         <answer>' ||  Get_InfoPathData('Physical_Skin_Arterial_Box',v_CaseId,'ST') || '</answer>'  || LF;
 
v_Str := v_Str || '                  </secondaryQuestions>' || LF;
 
v_Str := v_Str || '        </followUpQuestion>'  || LF;
 
v_Str := v_Str || '        <followUpQuestion>' ||  LF;
 
v_Str := v_Str || '         <title>Diabetic Ulcer(s)</title>'  || LF;
 
v_Str := v_Str || '         <value>' ||  Get_InfoPathData('Physical_Skin_Diabetic',v_CaseId,'ST') || '</value>'  || LF;
 
-- v_Str := v_Str || '                  <secondaryQuestions>'  || LF;
 
-- v_Str := v_Str || '                         <title>Stage</title>'  || LF;
 
-- v_Str := v_Str || '                         <answer>' ||  Get_InfoPathData('Physical_Skin_Diabetic_Healed',v_CaseId,'ST') || '</answer>'  || LF;
 
v_Str := v_Str || '                  <secondaryQuestions>'  || LF;
 
v_Str := v_Str || '                         <title>Location</title>'  || LF;
 
v_Str := v_Str || '                         <answer>' ||  Get_InfoPathData('Physical_Skin_Diabetic_Box',v_CaseId,'ST') || '</answer>'  || LF;
 
v_Str := v_Str || '                  </secondaryQuestions>' || LF;
 
v_Str := v_Str || '        </followUpQuestion>'  || LF;
 
--MISSING SECTION ON GANGRENE
--MISSING SECTION ON GANGRENE
--MISSING SECTION ON GANGRENE
 
v_Str := v_Str || '        <followUpQuestion>'  || LF;
 
v_Str := v_Str || '         <title>Surgical Incision</title>'  || LF;
 
v_Str := v_Str || '         <value>' ||  Get_InfoPathData('Physical_Skin_Incision',v_CaseId,'ST') || '</value>'  || LF;
 
v_Str := v_Str || '                  <secondaryQuestions>'  || LF;
 
v_Str := v_Str || '                         <title>Location</title>'  || LF;
 
v_Str := v_Str || '                         <answer>' ||  Get_InfoPathData('Physical_Skin_Incision',v_CaseId,'ST') || '</answer>'  || LF;
 
v_Str := v_Str || '                  </secondaryQuestions>'  || LF;
 
v_Str := v_Str || '                  <secondaryQuestions>'  || LF;
 
v_Str := v_Str || '                         <title>Status</title>'  || LF;
 
v_Str := v_Str || '                         <answer>' ||  Get_InfoPathData('Physical_Skin_Incision_Clean,  Physical_Skin_Incision_Infected,  Physical_Skin_Incision_Dehisced,  Physical_Skin_Incision_Healed',v_CaseId,'ST') || '</answer>'  || LF;
 
v_Str := v_Str || '                  </secondaryQuestions>'  || LF;
 
v_Str := v_Str || '        </followUpQuestion>'  || LF;
 
v_Str := v_Str || '   </sections>'  || LF;
 
v_Str := v_Str || '   <sections>'  || LF;
 
v_Str := v_Str || '   <sectionTitle>Musculoskeletal</sectionTitle>'  || LF;
 
v_Str := v_Str || '        <followUpQuestion>'   || LF;
 
v_Str := v_Str || '            <title>Full Range of Motion</title>'  || LF;
v_Str := v_Str || '            <value>' ||  Get_InfoPathData('Physical_MSkel_Motion',v_CaseId,'ST') || '</value>'  || LF;
 
v_Str := v_Str || '                  <secondaryQuestions>'   || LF;
 
v_Str := v_Str || '                         <title>List Limitations:</title>'  || LF;
v_Str := v_Str || '                         <answer>' ||  Get_InfoPathData('Physical_MSkel_Motion_Limitation',v_CaseId,'ST') || '</answer>'  || LF;
v_Str := v_Str || '                         <value>' ||  Get_InfoPathData('',v_CaseId,'ST') || '</value>'  || LF;
 
v_Str := v_Str || '                  </secondaryQuestions>'   || LF;
 
v_Str := v_Str || '        </followUpQuestion>'   || LF;
 
v_Str := v_Str || '        <followUpQuestion>'  || LF;
 
v_Str := v_Str || '            <title>Joints Normal</title>'  || LF;
v_Str := v_Str || '            <value>' ||  Get_InfoPathData('Physical_MSkel_Joints',v_CaseId,'ST') || '</value>'  || LF;
 
v_Str := v_Str || '                  <secondaryQuestions>'  || LF;
 
v_Str := v_Str || '                         <title>Abnormality</title>'  || LF;
v_Str := v_Str || '                         <answer>' ||  Get_InfoPathData('Physical_MSkel_Joints_Abnormality',v_CaseId,'ST') || '</answer>'  || LF;
v_Str := v_Str || '                         <value>' ||  Get_InfoPathData('',v_CaseId,'ST') || '</value>'  || LF;
 
v_Str := v_Str || '                  </secondaryQuestions>'  || LF;
 
v_Str := v_Str || '        </followUpQuestion>'   || LF; 
 
v_Str := v_Str || '        <followUpQuestion>'   || LF; 
 
v_Str := v_Str || '                  <secondaryQuestions>' ||  Get_InfoPathData('',v_CaseId,'ST') || '</secondaryQuestions>'  || LF;
 
v_Str := v_Str || '        <followUpQuestion>'   || LF;
 
v_Str := v_Str || '            <title>Hands: Ulnar Deviation</title>'  || LF;
v_Str := v_Str || '            <value>' ||  Get_InfoPathData('Physical_MSkel_Hands_Ulnar',v_CaseId,'ST') || '</value>'  || LF;
 
v_Str := v_Str || '        </followUpQuestion>'   || LF;
 
v_Str := v_Str || '        <followUpQuestion>'  || LF;
 
v_Str := v_Str || '            <title>Hands: MCP joint bony enlargement</title>'  || LF;
v_Str := v_Str || '            <value>' ||  Get_InfoPathData('',v_CaseId,'ST') || '</value>'  || LF;
 
v_Str := v_Str || '        </followUpQuestion>'   || LF;
 
v_Str := v_Str || '        <followUpQuestion>'  || LF;
 
v_Str := v_Str || '            <title>PIP joint swelling</title>'  || LF;
v_Str := v_Str || '            <value>' ||  Get_InfoPathData('Physical_MSkel_Hands_Pip',v_CaseId,'ST') || '</value>'  || LF;
 
v_Str := v_Str || '        </followUpQuestion>'   || LF;
 
v_Str := v_Str || '        <followUpQuestion>'  || LF;
 
v_Str := v_Str || '            <title>DIP joint bony enlargement</title>'  || LF;
v_Str := v_Str || '            <value>' ||  Get_InfoPathData('Physical_MSkel_Hands_Dip',v_CaseId,'ST') || '</value>'  || LF;
 
v_Str := v_Str || '        </followUpQuestion>'   || LF;
 
v_Str := v_Str || '        <followUpQuestion>'  || LF;
 
v_Str := v_Str || '         <title>Amputation</title>'  || LF;
 
v_Str := v_Str || '         <answer>' ||  Get_InfoPathData('Physical_MSkel_Amputation',v_CaseId,'ST') || '</answer>'  || LF;
 
v_Str := v_Str || '                  <secondaryQuestions>'  || LF;
 
--SHOULD BE OTHER TEXT: v_Str := v_Str || '                         <title>Location</title>'  || LF;
--SHOULD BE ANSWER v_Str := v_Str || '                         <value>' ||  Get_InfoPathData('Physical_MSkel_Left_Aka, Physical_MSkel_Left_Bka, Physical_MSkel_Left_Great_Toe,  Physical_MSkel_Left_Other_Toes,  
---    Physical_MSkel_Right_Aka,  Physical_MSkel_Right_Bka,  Physical_MSkel_Right_Great_Toe,  Physical_MSkel_Right_Other_Toes',v_CaseId,'ST') || '</value>'  || LF;
 
 
v_Str := v_Str || '        <followUpQuestion>'  || LF;
 
v_Str := v_Str || '            <title>Get up and Go</title>'  || LF;
v_Str := v_Str || '            <answer>' ||  Get_InfoPathData('Physical_MSkel_Get_Up_Pass,  Physical_MSkel_Get_Up_Assessment,  Physical_MSkel_Get_Up_Perform',v_CaseId,'ST') || '</answer>'  || LF;
v_Str := v_Str || '            <answer>' ||  Get_InfoPathData('',v_CaseId,'ST') || '</answer>'  || LF;
 
v_Str := v_Str || '        </followUpQuestion>'  || LF;
 
v_Str := v_Str || '   </sections>'  || LF;
 
v_Str := v_Str || '   <sections>'  || LF;
 
v_Str := v_Str || '   <sectionTitle>Abdomen</sectionTitle>'  || LF;
 
v_Str := v_Str || '        <followUpQuestion>'   || LF;
 
v_Str := v_Str || '            <title>Soft?</title>'  || LF;
v_Str := v_Str || '            <value>' ||  Get_InfoPathData('Physical_Abd_Soft',v_CaseId,'ST') || '</value>'  || LF;
 
v_Str := v_Str || '        </followUpQuestion>'   || LF;
 
v_Str := v_Str || '        <followUpQuestion>'   || LF;
 
v_Str := v_Str || '            <title>Non-tender?</title>'  || LF;
v_Str := v_Str || '            <value>' ||  Get_InfoPathData('Physical_Abd_Non_Tender',v_CaseId,'ST') || '</value>'  || LF;
 
v_Str := v_Str || '        </followUpQuestion>'   || LF;
 
v_Str := v_Str || '        <followUpQuestion>'   || LF; 
 
v_Str := v_Str || '            <title>Distended?</title>'  || LF;
v_Str := v_Str || '            <value>' ||  Get_InfoPathData('',v_CaseId,'ST') || '</value>'  || LF;
 
v_Str := v_Str || '        </followUpQuestion>'   || LF;
 
v_Str := v_Str || '        <followUpQuestion>'   || LF;
 
v_Str := v_Str || '            <title>Bowel sounds normal?</title>'  || LF;
v_Str := v_Str || '            <value>' ||  Get_InfoPathData('Physical_Abd_Bowel_Sounds_Normal',v_CaseId,'ST') || '</value>'  || LF;
 
v_Str := v_Str || '        </followUpQuestion>'   || LF;
 
v_Str := v_Str || '        <followUpQuestion>'   || LF; 
 
v_Str := v_Str || '            <title>Masses?</title>'  || LF;
v_Str := v_Str || '            <value>' ||  Get_InfoPathData('Physical_Abd_Masses',v_CaseId,'ST') || '</value>'  || LF;
 
v_Str := v_Str || '                  <secondaryQuestions>'  || LF;
 
v_Str := v_Str || '                         <title>Select Location</title>'  || LF;
v_Str := v_Str || '                         <answer>' ||  Get_InfoPathData('Physical_Abd_Masses_Describe',v_CaseId,'ST') || '</answer>'  || LF;
 -- MISSING VALUE
 
v_Str := v_Str || '                  </secondaryQuestions>'  || LF;
 
v_Str := v_Str || '                  <secondaryQuestions>'   || LF;
 
v_Str := v_Str || '                         <title>Select Consistency</title>'  || LF;
--MISSING ANSWER v_Str := v_Str || '                         <answer>' ||  Get_InfoPathData('',v_CaseId,'ST') || '</answer>'  || LF;
--MISSING VALUE v_Str := v_Str || '                         <value>' ||  Get_InfoPathData('',v_CaseId,'ST') || '</value>'  || LF;
--MISSING OTHERVALUE v_Str := v_Str || '                         <otherValue>' ||  Get_InfoPathData('',v_CaseId,'ST') || '</otherValue>'  || LF;
 
v_Str := v_Str || '                  </secondaryQuestions>'  || LF;
 
v_Str := v_Str || '        </followUpQuestion>'   || LF;
 
v_Str := v_Str || '        <followUpQuestion>'  || LF;
 
v_Str := v_Str || '            <title>Presence of ostomies?</title>'  || LF;
v_Str := v_Str || '            <answer>' ||  Get_InfoPathData('Physical_Abd_Presence_Peg,   Physical_Abd_Presence_Colostomy , Physical_Abd_Presence_Ileostomy,  Physical_Abd_Presence_Cystectomy',v_CaseId,'ST') || '</answer>'  || LF;
 
v_Str := v_Str || '        </followUpQuestion>'   || LF;
 
v_Str := v_Str || '   </sections>'  || LF;
 
v_Str := v_Str || '   <sections>'  || LF;
 
v_Str := v_Str || '   <sectionTitle>Pulmonary</sectionTitle>'  || LF;
 
v_Str := v_Str || '        <followUpQuestion>'  || LF;
 
v_Str := v_Str || '            <title>On O2</title>'  || LF;
v_Str := v_Str || '            <value>' ||  Get_InfoPathData('Physical_Pulm_O2',v_CaseId,'ST') || '</value>'  || LF;
 
v_Str := v_Str || '                  <secondaryQuestions>'   || LF;
 
v_Str := v_Str || '                         <title>How much 02 (liters/minute)?</title>'  || LF;
--MISSING ANSWER v_Str := v_Str || '                         <answer>' ||  Get_InfoPathData('',v_CaseId,'ST') || '</answer>'  || LF;
--MISSING VALUE v_Str := v_Str || '                         <value>' ||  Get_InfoPathData('',v_CaseId,'ST') || '</value>'  || LF;
 
v_Str := v_Str || '                  </secondaryQuestions>'   || LF; 
 
v_Str := v_Str || '                  <secondaryQuestions>'  || LF;
 
v_Str := v_Str || '                         <title>Is Continuous?</title>'  || LF;
v_Str := v_Str || '                         <answer>' ||  Get_InfoPathData('Physical_Pulm_O2_Continuous',v_CaseId,'ST') || '</answer>'  || LF;
 
v_Str := v_Str || '                  </secondaryQuestions>'   || LF;
 
v_Str := v_Str || '        </followUpQuestion>'  || LF;
 
v_Str := v_Str || '        <followUpQuestion>'  || LF;
 
v_Str := v_Str || '            <title>Lungs Clear Bilaterally</title>'  || LF;
v_Str := v_Str || '            <answer>' ||  Get_InfoPathData('Physical_Pulm_Lungs_Clear',v_CaseId,'ST') || '</answer>'  || LF;
 
v_Str := v_Str || '        </followUpQuestion>'  || LF;
 
v_Str := v_Str || '        <followUpQuestion>'  || LF; 
 
v_Str := v_Str || '            <title>Wheezes</title>'  || LF;
v_Str := v_Str || '            <answer>' ||  Get_InfoPathData('Physical_Pulm_Lungs_Wheezes',v_CaseId,'ST') || '</answer>'  || LF;
 
 v_Str := v_Str || '        </followUpQuestion>'  || LF;
 
v_Str := v_Str || '        <followUpQuestion>'  || LF;
 
v_Str := v_Str || '            <title>Rales</title>'  || LF;
v_Str := v_Str || '            <value>' ||  Get_InfoPathData('Physical_Pulm_Lungs_Rales',v_CaseId,'ST') || '</value>'  || LF;
 
 v_Str := v_Str || '        </followUpQuestion>'  || LF;
 
v_Str := v_Str || '        <followUpQuestion>'  || LF;
 
v_Str := v_Str || '            <title>Rhonchi</title>'  || LF;
v_Str := v_Str || '            <value>' ||  Get_InfoPathData('Physical_Pulm_Lungs_Rhonchi',v_CaseId,'ST') || '</value>'  || LF;
 
v_Str := v_Str || '        </followUpQuestion>'  || LF;
 
v_Str := v_Str || '        <followUpQuestion>'  || LF;
 
v_Str := v_Str || '            <title>Respiratory Effort Normal</title>'  || LF;
v_Str := v_Str || '            <value>' ||  Get_InfoPathData('Physical_Pulm_Resp_Effort',v_CaseId,'ST') || '</value>'  || LF;
 
v_Str := v_Str || '        </followUpQuestion>'  || LF;
 
v_Str := v_Str || '        <followUpQuestion>'  || LF;
 
v_Str := v_Str || '            <title>Breath sounds decreased</title>'  || LF;
--MISSING VALUEv_Str := v_Str || '            <value>' ||  Get_InfoPathData('',v_CaseId,'ST') || '</value>'  || LF;
 
v_Str := v_Str || '        </followUpQuestion>'  || LF;
 
v_Str := v_Str || '   </sections>'  || LF;
 
v_Str := v_Str || '   <sections>'  || LF;
 
v_Str := v_Str || '   <sectionTitle>Cardiovascular</sectionTitle>'  || LF;
 
v_Str := v_Str || '        <followUpQuestion>' ||  Get_InfoPathData('',v_CaseId,'ST') || '</followUpQuestion>'  || LF;
 
v_Str := v_Str || '            <title>Heart Rhythm</title>'  || LF;
v_Str := v_Str || '            <answer>' ||  Get_InfoPathData('Physical_CV_Heart_Regular,  Physical_CV_Heart_Irregular',v_CaseId,'ST') || '</answer>'  || LF;
 
v_Str := v_Str || '        </followUpQuestion>'  || LF;
 
v_Str := v_Str || '        <followUpQuestion>'  || LF;
 
v_Str := v_Str || '            <title>Murmur</title>'  || LF;
v_Str := v_Str || '            <value>' ||  Get_InfoPathData('Physical_CV_Murmur',v_CaseId,'ST') || '</value>'  || LF;
 
v_Str := v_Str || '        </followUpQuestion>'  || LF;
 
v_Str := v_Str || '        <followUpQuestion>'  || LF;
 
v_Str := v_Str || '            <title>Carotid bruits</title>'  || LF;
v_Str := v_Str || '            <value>' ||  Get_InfoPathData('Physical_CV_Carotid',v_CaseId,'ST') || '</value>'  || LF;
 
v_Str := v_Str || '                  <secondaryQuestions>'  || LF;
 
v_Str := v_Str || '                         <title>Right or Left?</title>'  || LF;
v_Str := v_Str || '                         <answer>' ||  Get_InfoPathData('Physical_CV_Carotid_Right , Physical_CV_Carotid_Left',v_CaseId,'ST') || '</answer>'  || LF;
v_Str := v_Str || '                         <value>' ||  Get_InfoPathData('',v_CaseId,'ST') || '</value>'  || LF;
 
v_Str := v_Str || '                  </secondaryQuestions>'  || LF;
 
v_Str := v_Str || '        </followUpQuestion>'  || LF;
 
v_Str := v_Str || '        <followUpQuestion>'  || LF;
 
v_Str := v_Str || '            <title>Jugular venous distension</title>'  || LF;
v_Str := v_Str || '            <value>' ||  Get_InfoPathData('Physical_CV_Carotid_Jugular',v_CaseId,'ST') || '</value>'  || LF;
 
v_Str := v_Str || '        </followUpQuestion>'  || LF;
 
v_Str := v_Str || '        <followUpQuestion>'  || LF;
 
v_Str := v_Str || '            <title>Lower Extremity Edema</title>'  || LF;
v_Str := v_Str || '            <value>' ||  Get_InfoPathData('Physical_CV_Edema',v_CaseId,'ST') || '</value>'  || LF;
 
 
v_Str := v_Str || '                  <secondaryQuestions>'  || LF;
 
v_Str := v_Str || '                         <title>Pitting Edema Type:</title>'  || LF;
v_Str := v_Str || '                         <answer>' ||  Get_InfoPathData('Physical_CV_Edema_1',v_CaseId,'ST') || '</answer>'  || LF;
v_Str := v_Str || '                         <value>' ||  Get_InfoPathData('Physical_CV_Edema_2',v_CaseId,'ST') || '</value>'  || LF;
 
v_Str := v_Str || '                  </secondaryQuestions>'  || LF;
 
v_Str := v_Str || '        </followUpQuestion>'  || LF;
 
--v_Str := v_Str || '                  <secondaryQuestions>' ||  Get_InfoPathData('Physical_CV_Edema_3',v_CaseId,'ST') || '</secondaryQuestions>'  || LF;
--v_Str := v_Str || '                  <secondaryQuestions>' ||  Get_InfoPathData('',v_CaseId,'ST') || '</secondaryQuestions>'  || LF;
 
v_Str := v_Str || '        <followUpQuestion>'  || LF;
 
v_Str := v_Str || '            <title>Lower extremity pulse: Right DP</title>'  || LF;
v_Str := v_Str || '            <answer>' ||  Get_InfoPathData('Physical_CV_Pulses_Right_Normal_DP,  Physical_CV_Pulses_Right_Dimished_DP',v_CaseId,'ST') || '</answer>'  || LF;
 
v_Str := v_Str || '        </followUpQuestion>'  || LF;
 
v_Str := v_Str || '        <followUpQuestion>'  || LF;
  
v_Str := v_Str || '            <title>Lower extremity pulse: Right PT</title>'  || LF;
v_Str := v_Str || '            <answer>' ||  Get_InfoPathData('Physical_CV_Pulses_Right_Normal_PT,  Physical_CV_Pulses_Right_Dimished_PT',v_CaseId,'ST') || '</answer>'  || LF;
 
v_Str := v_Str || '        </followUpQuestion>'  || LF;
 
v_Str := v_Str || '        <followUpQuestion>'  || LF;
 
v_Str := v_Str || '            <title>Lower extremity pulse: Left DP</title>'  || LF;
v_Str := v_Str || '            <answer>' ||  Get_InfoPathData('Physical_CV_Pulses_Left_Normal_DP,  Physical_CV_Pulses_Left_Dimished_DP',v_CaseId,'ST') || '</answer>'  || LF;
 
v_Str := v_Str || '        </followUpQuestion>'  || LF;
 
v_Str := v_Str || '        <followUpQuestion>'  || LF;
 
v_Str := v_Str || '            <title>Lower extremity pulse: Left PT</title>'  || LF;
v_Str := v_Str || '            <answer>' ||  Get_InfoPathData('Physical_CV_Pulses_Left_Normal_PT,  Physical_CV_Pulses_Left_Dimished_PT',v_CaseId,'ST') || '</answer>'  || LF;
 
v_Str := v_Str || '        </followUpQuestion>'  || LF;
 
v_Str := v_Str || '        <followUpQuestion>'  || LF; 
 
v_Str := v_Str || '            <title>Arterio-venous (AV) fistula or graft</title>'  || LF;
v_Str := v_Str || '            <value>' ||  Get_InfoPathData('Physical_CV_AV',v_CaseId,'ST') || '</value>'  || LF;
 
v_Str := v_Str || '        </followUpQuestion>'  || LF;
 
v_Str := v_Str || '   </sections>'  || LF;
 
v_Str := v_Str || '   <sections>'  || LF;
 
v_Str := v_Str || '   <sectionTitle>Lymph</sectionTitle>'  || LF;
 
v_Str := v_Str || '        <followUpQuestion>' || LF;
 
v_Str := v_Str || '            <title>Lymphadenopathy: neck</title>'  || LF;
v_Str := v_Str || '            <value>' ||  Get_InfoPathData('Physical_Lymph',v_CaseId,'ST') || '</value>'  || LF;
 
v_Str := v_Str || '        </followUpQuestion>' || LF;
 
--v_Str := v_Str || '        <followUpQuestion>' || LF;
  
--v_Str := v_Str || '            <title>Lymphadenopathy: axila</title>'  || LF;
--MISSING VALUE v_Str := v_Str || '            <value>' ||  Get_InfoPathData('',v_CaseId,'ST') || '</value>'  || LF;
 
--v_Str := v_Str || '        <followUpQuestion>' || LF;
 
--v_Str := v_Str || '            <title>Lymphadenopathy: groin</title>'  || LF;
--MISSING VALUE v_Str := v_Str || '            <value>' ||  Get_InfoPathData('',v_CaseId,'ST') || '</value>'  || LF;
 
--v_Str := v_Str || '        </followUpQuestion>' || LF;
 
v_Str := v_Str || '        <followUpQuestion>' || LF;
 
v_Str := v_Str || '            <title>Lymphadenopathy: other</title>'  || LF;
v_Str := v_Str || '            <value>' ||  Get_InfoPathData('Physical_Lymph_Other_Specify',v_CaseId,'ST') || '</value>'  || LF;
 
v_Str := v_Str || '                  <secondaryQuestions>'  || LF;
 
v_Str := v_Str || '                         <title>Location</title>'  || LF;
--MISSING ANSWER v_Str := v_Str || '                         <answer>' ||  Get_InfoPathData('',v_CaseId,'ST') || '</answer>'  || LF;
--MISSING VALUE v_Str := v_Str || '                         <value>' ||  Get_InfoPathData('',v_CaseId,'ST') || '</value>'  || LF;
 
v_Str := v_Str || '                  </secondaryQuestions>'  || LF;
 
v_Str := v_Str || '        </followUpQuestion>' || LF;
 
v_Str := v_Str || '   </sections>'  || LF;
 
v_Str := v_Str || '   <sections>'  || LF;
 
v_Str := v_Str || '   <sectionTitle>Neck</sectionTitle>'  || LF;
 
v_Str := v_Str || '        <followUpQuestion>'   || LF;
 
v_Str := v_Str || '            <title>Surgical scar</title>'  || LF;
v_Str := v_Str || '            <value>' ||  Get_InfoPathData('Physical_Neck_Surg',v_CaseId,'ST') || '</value>'  || LF;
 
v_Str := v_Str || '                  <secondaryQuestions>'  || LF;
 
v_Str := v_Str || '                         <title>Location</title>'  || LF;
v_Str := v_Str || '                         <answer>' ||  Get_InfoPathData('Physical_Neck_Surg_Location',v_CaseId,'ST') || '</answer>'  || LF;
v_Str := v_Str || '                         <value>' ||  Get_InfoPathData('',v_CaseId,'ST') || '</value>'  || LF;
 
v_Str := v_Str || '                  <secondaryQuestions>'  || LF;
 
v_Str := v_Str || '        </followUpQuestion>'   || LF;
 
v_Str := v_Str || '        <followUpQuestion>'  || LF;
 
v_Str := v_Str || '            <title>Trachea midline</title>'  || LF;
v_Str := v_Str || '            <value>' ||  Get_InfoPathData('Physical_Neck_Trachea',v_CaseId,'ST') || '</value>'  || LF;
 
v_Str := v_Str || '        </followUpQuestion>'   || LF;
 
v_Str := v_Str || '        <followUpQuestion>'  || LF;
 
v_Str := v_Str || '            <title>Tracheostomy present</title>'  || LF;
v_Str := v_Str || '            <value>' ||  Get_InfoPathData('Physical_Neck_Tracheostomy',v_CaseId,'ST') || '</value>'  || LF;
 
v_Str := v_Str || '        </followUpQuestion>'   || LF;
 
v_Str := v_Str || '   </sections>'  || LF;
 
v_Str := v_Str || '   </PhysicalExam>' || LF; 
 
 
 
------------------------------------
 
 
       RETURN v_Str;
       
       EXCEPTION WHEN OTHERS THEN
            v_Str := SUBSTR(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
                              CHR(13) ||
                              SQLERRM,1,4000); 
           
       END;

/

