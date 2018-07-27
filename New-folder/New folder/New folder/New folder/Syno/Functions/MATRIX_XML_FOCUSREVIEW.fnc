--------------------------------------------------------
--  DDL for Function MATRIX_XML_FOCUSREVIEW
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SNX_IWS2"."MATRIX_XML_FOCUSREVIEW" 
    (   P_CASEID  number   ,
        P_LF varchar2  ) 
     
    -- Created 10-6-2012 R Benzell
    -- called by GEN_MATRIX_XML
    -- Edited and completed 10-8-12 Denis
    
        RETURN CLOB
    
        IS
    
 
        v_Str CLOB;
        v_CaseId number;
        LF varchar2(5);
      
       
          
            BEGIN
                
      v_CaseId := P_CaseId;
      LF := P_LF;
        
 
-----------------------------------


v_Str := v_Str || ' <FocusedSystemReview>'  || LF;

v_Str := v_Str || '   <items>' || LF;
v_Str := v_Str || '     <title>Constitutional</title>'  || LF;
v_Str := v_Str || '     <value/>' || LF;
v_Str := v_Str || '        <questions>' || LF;
v_Str := v_Str || '            <title>Fatigue</title>'  || LF;
v_Str := v_Str || '            <value>' ||  Get_InfoPathData('Focused_Review_Fatigue',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '        </questions>' || LF;
v_Str := v_Str || '        <questions>' || LF;
v_Str := v_Str || '            <title>Weakness</title>'  || LF;
v_Str := v_Str || '            <value>' ||  Get_InfoPathData('Focused_Review_Weakness',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '        </questions>' || LF;
v_Str := v_Str || '   </items>' || LF;

v_Str := v_Str || '   <items>' || LF;
v_Str := v_Str || '        <title>Respiratory</title>'  || LF;
v_Str := v_Str || '        <value/>' || LF;
v_Str := v_Str || '        <questions>' || LF;
v_Str := v_Str || '            <title>Bronchitis</title>'  || LF;
v_Str := v_Str || '            <value>' ||  Get_InfoPathData('Focused_Review_Bronchitis',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '        </questions>' || LF; 
v_Str := v_Str || '        <questions>' || LF;
v_Str := v_Str || '            <title>Emphysema</title>'  || LF;
v_Str := v_Str || '            <value>' ||  Get_InfoPathData('Focused_Review_Emphysema',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '        </questions>' || LF; 
v_Str := v_Str || '        <questions>' || LF;
v_Str := v_Str || '            <title>COPD</title>'  || LF;
v_Str := v_Str || '            <value>' ||  Get_InfoPathData('Focused_Review_COPD',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '        </questions>' || LF; 
v_Str := v_Str || '        <questions>' || LF;
v_Str := v_Str || '            <title>Chronic Cough</title>'  || LF;
v_Str := v_Str || '            <value>' ||  Get_InfoPathData('Focused_Review_Cough',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '        </questions>' || LF; 
v_Str := v_Str || '        <questions>' || LF;
v_Str := v_Str || '            <title>Coughing up blood</title>'  || LF; 
v_Str := v_Str || '            <value>' ||  Get_InfoPathData('Focused_Review_Blood',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '        </questions>' || LF;  
v_Str := v_Str || '        <questions>'  || LF;
v_Str := v_Str || '            <title>Shortness of breath</title>'  || LF;
v_Str := v_Str || '            <value>' ||  Get_InfoPathData('Focused_Review_Breath',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '        </questions>' || LF; 
v_Str := v_Str || '        <questions>'  || LF;
v_Str := v_Str || '            <title>Asthma or Wheezing</title>'  || LF;
v_Str := v_Str || '            <value>' ||  Get_InfoPathData('Focused_Review_Asthma',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '        </questions>' || LF; 
v_Str := v_Str || '        <questions>'  || LF;
v_Str := v_Str || '            <title>Tuberculosis</title>'  || LF;
v_Str := v_Str || '            <value>' ||  Get_InfoPathData('Focused_Review_TB',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '        </questions>' || LF;
v_Str := v_Str || '   </items>' || LF;
 
v_Str := v_Str || '   <items>' || LF;
v_Str := v_Str || '        <title>HEENT</title>'  || LF;
v_Str := v_Str || '        <value/>' || LF;
v_Str := v_Str || '        <questions>' || LF;
v_Str := v_Str || '            <title>Glaucoma</title>'  || LF;
v_Str := v_Str || '            <value>' ||  Get_InfoPathData('Focused_Review_Glaucoma',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '        </questions>' || LF; 
v_Str := v_Str || '        <questions>'  || LF;
v_Str := v_Str || '            <title>Blind</title>'  || LF;
v_Str := v_Str || '            <value>' ||  Get_InfoPathData('Focused_Review_Blind',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '        </questions>' || LF; 
v_Str := v_Str || '        <questions>' || LF;
v_Str := v_Str || '            <title>Vision Impaired</title>'  || LF;
v_Str := v_Str || '            <value>' ||  Get_InfoPathData('Focused_Review_Vision_Impaired',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '        </questions>' || LF; 
v_Str := v_Str || '        <questions>'  || LF;
v_Str := v_Str || '            <title>Hearing Impaired</title>'  || LF;
v_Str := v_Str || '            <value>' ||  Get_InfoPathData('Focused_Review_Hearing_Impaired',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '        </questions>' || LF; 
v_Str := v_Str || '        <questions>' || LF;
v_Str := v_Str || '            <title>Hoarseness</title>'  || LF;
v_Str := v_Str || '            <value>' ||  Get_InfoPathData('Focused_Review_Hoarseness',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '        </questions>' || LF;  
v_Str := v_Str || '        <questions>'  || LF;
v_Str := v_Str || '            <title>Difficulty swallowing</title>'  || LF; 
v_Str := v_Str || '            <value>' ||  Get_InfoPathData('Focused_Review_Swallow',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '        </questions>' || LF;  
v_Str := v_Str || '        <questions>'  || LF;
v_Str := v_Str || '            <title>Lesions in mouth</title>'  || LF;
v_Str := v_Str || '            <value>' ||  Get_InfoPathData('Focused_Review_Lesions',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '        </questions>' || LF;  
v_Str := v_Str || '   </items>' || LF;

v_Str := v_Str || '   <items>' || LF;
v_Str := v_Str || '        <title>Genitourinary</title>'  || LF;
v_Str := v_Str || '        <value/>'  || LF;
v_Str := v_Str || '        <questions>' || LF;   
v_Str := v_Str || '            <title>Blood in urine</title>'  || LF;  
v_Str := v_Str || '            <value>' ||  Get_InfoPathData('Focused_Review_Blood_Urine',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '        </questions>' || LF; 
v_Str := v_Str || '        <questions>'  || LF;
v_Str := v_Str || '            <title>Frequency</title>'  || LF; 
v_Str := v_Str || '            <value>' ||  Get_InfoPathData('Focused_Review_Frequency',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '         </questions>' || LF; 
v_Str := v_Str || '         <questions>'  || LF;
v_Str := v_Str || '            <title>Urgency</title>'  || LF;
v_Str := v_Str || '            <value>' ||  Get_InfoPathData('Focused_Review_Urgency',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '        </questions>' || LF;  
v_Str := v_Str || '        <questions>'  || LF;
v_Str := v_Str || '            <title>Kidney Disease</title>'  || LF;
v_Str := v_Str || '            <value>' ||  Get_InfoPathData('Focused_Review_Kidney',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '        </questions>' || LF; 
v_Str := v_Str || '   </items>' || LF;

v_Str := v_Str || '   <items>' || LF;
v_Str := v_Str || '        <title>Skin</title>'  || LF;
v_Str := v_Str || '        <value/>' || LF;
v_Str := v_Str || '        <questions>'  || LF;
v_Str := v_Str || '            <title>Skin Lesions/Changes</title>'  || LF;
v_Str := v_Str || '            <value>' ||  Get_InfoPathData('Focused_Review_Skin_Lesions',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '        </questions>' || LF;  
v_Str := v_Str || '        <questions>'  || LF;
v_Str := v_Str || '            <title>Decubitus (Pressure) Ulcer</title>'  || LF;
v_Str := v_Str || '            <value>' ||  Get_InfoPathData('Focused_Review_Skin_Decubitus +',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '        </questions>' || LF;  
v_Str := v_Str || '        <questions>' || LF;
v_Str := v_Str || '            <title>Vascular (non-pressure) Ulcer</title>'  || LF;
v_Str := v_Str || '            <value>' ||  Get_InfoPathData('Focused_Review_Skin_Vascular',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '        </questions>' || LF;   
v_Str := v_Str || '        <questions>'  || LF;
v_Str := v_Str || '            <title>Rashes</title>'  || LF;
v_Str := v_Str || '            <value>' ||  Get_InfoPathData('Focused_Review_Skin_Rashes',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '        </questions>' || LF;  
v_Str := v_Str || '        <questions>'  || LF;
v_Str := v_Str || '            <title>Skin Cancer</title>'  || LF;
v_Str := v_Str || '            <value>' ||  Get_InfoPathData('Focused_Review_Skin_Cancer',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '            <extradata>' || LF;
v_Str := v_Str || '                  <title>Type:</title>'  || LF;
v_Str := v_Str || '                  <value>' ||  Get_InfoPathData('Focused_Review_Skin_Cancer_type',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '            </extradata>' || LF; 
v_Str := v_Str || '            <extradata>'  || LF;
v_Str := v_Str || '                  <title>Location:</title>'  || LF;
v_Str := v_Str || '                  <value>' ||  Get_InfoPathData('Focused_Review_Skin_Cancer_Location',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '            </extradata>' || LF;
v_Str := v_Str || '        </questions>' || LF; 
v_Str := v_Str || '   </items>'  || LF;

v_Str := v_Str || '   <items>'  || LF;
 
v_Str := v_Str || '        <title>Gastrointestinal</title>'  || LF;
v_Str := v_Str || '        <value/>'  || LF;
v_Str := v_Str || '        <questions>' || LF;
v_Str := v_Str || '            <title>HeartBurn</title>'  || LF;
v_Str := v_Str || '            <value>' ||  Get_InfoPathData('Focused_Review_Heart_Burn',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '        </questions>' || LF; 
v_Str := v_Str || '        <questions>' || LF;
v_Str := v_Str || '            <title>GERD</title>'  || LF;
v_Str := v_Str || '            <value>' ||  Get_InfoPathData('Focused_Review_Heart_Burn',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '        </questions>' || LF; 
v_Str := v_Str || '        <questions>' || LF; 
v_Str := v_Str || '            <title>Peptic ulcers</title>'  || LF;
v_Str := v_Str || '            <value>' ||  Get_InfoPathData('Focused_Review_Peptic',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '        </questions>' || LF;  
v_Str := v_Str || '        <questions>'  || LF;
v_Str := v_Str || '            <title>Change in bowel movements</title>'  || LF;
v_Str := v_Str || '            <value>' ||  Get_InfoPathData('Focused_Review_BMS',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '        </questions>' || LF; 
v_Str := v_Str || '        <questions>'  || LF;
v_Str := v_Str || '            <title>Blood in stool(GI Bleed)</title>'  || LF;
v_Str := v_Str || '            <value>' ||  Get_InfoPathData('Focused_Review_Stool',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '        </questions>' || LF; 
v_Str := v_Str || '        <questions>'  || LF;
v_Str := v_Str || '            <title>Constipation</title>'  || LF;
v_Str := v_Str || '            <value>' ||  Get_InfoPathData('Focused_Review_Constipation',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '        </questions>' || LF; 
v_Str := v_Str || '        <questions>'  || LF;
v_Str := v_Str || '            <title>Incontinence of stool</title>'  || LF;
v_Str := v_Str || '            <value>' ||  Get_InfoPathData('Focused_Review_Incontinence',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '        </questions>' || LF;  
v_Str := v_Str || '        <questions>'  || LF;
v_Str := v_Str || '            <title>Liver disease</title>'  || LF; 
v_Str := v_Str || '            <value>' ||  Get_InfoPathData('Focused_Review_Liver',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '        </questions>' || LF;  
v_Str := v_Str || '   </items>'  || LF;

v_Str := v_Str || '   <items>'  || LF; 
v_Str := v_Str || '        <title>Cardiovascular</title>'  || LF;
v_Str := v_Str || '        <value/>' || LF;
v_Str := v_Str || '        <questions>'  || LF;
v_Str := v_Str || '            <title>Heart Attack/MI</title>'  || LF;
v_Str := v_Str || '            <value>' ||  Get_InfoPathData('Focused_Review_Heart',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '            <date>' ||  Get_InfoPathData('Focused_Review_Heart_Date',v_CaseId,'ST') || '</date>'  || LF;
v_Str := v_Str || '        </questions>'  || LF; 
v_Str := v_Str || '        <questions>'  || LF;
v_Str := v_Str || '            <title>Chest pain on exertion</title>'  || LF;
v_Str := v_Str || '            <value>' ||  Get_InfoPathData('Focused_Review_Chest',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '        </questions>'  || LF;  
v_Str := v_Str || '        <questions>'  || LF;
v_Str := v_Str || '            <title>Heart Failure</title>'  || LF;
v_Str := v_Str || '            <value>' ||  Get_InfoPathData('Focused_Review_Heart_Failure',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '        </questions>'  || LF;  
v_Str := v_Str || '        <questions>'   || LF;
v_Str := v_Str || '            <title>Hypertension</title>'  || LF;
v_Str := v_Str || '            <value>' ||  Get_InfoPathData('Focused_Review_Hypertension',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '        </questions>'  || LF; 
v_Str := v_Str || '        <questions>'  || LF;
v_Str := v_Str || '            <title>Hyperlipidemia</title>'  || LF;
v_Str := v_Str || '            <value>' ||  Get_InfoPathData('Focused_Review_Hyperlipidemia',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '        </questions>'  || LF; 
v_Str := v_Str || '        <questions>'  || LF;
v_Str := v_Str || '            <title>Dyspnea on exertion</title>'  || LF;
v_Str := v_Str || '            <value>' ||  Get_InfoPathData('Focused_Review_Dyspnea',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '        </questions>'  || LF; 
v_Str := v_Str || '        <questions>' || LF;
v_Str := v_Str || '            <title>Dyspnea lying flat</title>'  || LF;
v_Str := v_Str || '            <value>' ||  Get_InfoPathData('Focused_Review_Dyspnea_Flat',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '        </questions>'  || LF; 
v_Str := v_Str || '        <questions>'  || LF;
v_Str := v_Str || '            <title>Dyspnea at night(PND)</title>'  || LF;
v_Str := v_Str || '            <value>' ||  Get_InfoPathData('Focused_Review_Dyspnea_Night',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '        </questions>'  || LF; 
v_Str := v_Str || '        <questions>'   || LF;
v_Str := v_Str || '            <title>Edema in legs</title>'  || LF;
v_Str := v_Str || '            <value>' ||  Get_InfoPathData('Focused_Review_Edema',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '        </questions>'  || LF; 
v_Str := v_Str || '        <questions>' || LF;
v_Str := v_Str || '            <title>Leg pain with walking</title>'  || LF;
v_Str := v_Str || '            <value>' ||  Get_InfoPathData('Focused_Review_Leg_Pain',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '        </questions>'  || LF; 
v_Str := v_Str || '        <questions>' || LF;
v_Str := v_Str || '            <title>Palpitations/Irregular heartbeat</title>'  || LF;
v_Str := v_Str || '            <value>' ||  Get_InfoPathData('Focused_Review_Palpitations',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '        </questions>'  || LF; 
v_Str := v_Str || '        <questions>'  || LF;
v_Str := v_Str || '            <title>Heart valve problems</title>'  || LF;
v_Str := v_Str || '            <value>' ||  Get_InfoPathData('Focused_Review_Valve',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '        </questions>'  || LF;
v_Str := v_Str || '   </items>' || LF; 
 
v_Str := v_Str || '   <items>' || LF;
v_Str := v_Str || '        <title>HematologyOncology</title>'  || LF;
v_Str := v_Str || '        <value/>' || LF;
v_Str := v_Str || '        <questions>'  || LF;
v_Str := v_Str || '            <title>Anemia (low red blood cell count)</title>'  || LF; 
v_Str := v_Str || '            <value>' ||  Get_InfoPathData('Focused_Review_Anemia',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '        </questions>'  || LF; 
v_Str := v_Str || '        <questions>'  || LF;
v_Str := v_Str || '            <title>Easily Bruised or Bleeding</title>'  || LF;
v_Str := v_Str || '            <value>' ||  Get_InfoPathData('Focused_Review_Easily_Bruised',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '        </questions>'  || LF; 
v_Str := v_Str || '        <questions>' || LF;
v_Str := v_Str || '            <title>Swollen Lymph Nodes</title>'  || LF;
v_Str := v_Str || '            <value>' ||  Get_InfoPathData('Focused_Review_Swollen_Lymph',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '        </questions>'  || LF; 
v_Str := v_Str || '        <questions>'  || LF;
v_Str := v_Str || '            <title>Leukemia</title>'  || LF;
v_Str := v_Str || '            <value>' ||  Get_InfoPathData('Focused_Review_Leukemia',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '           <extradata>' || LF;
v_Str := v_Str || '              <title>Type</title>'  || LF;
v_Str := v_Str || '              <value>' ||  Get_InfoPathData('Focused_Review_Leukemia_Box',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '           </extradata>' || LF; 
v_Str := v_Str || '        </questions>'  || LF;
v_Str := v_Str || '        <questions>' || LF;
v_Str := v_Str || '           <title>Lymphoma</title>'  || LF;
v_Str := v_Str || '           <value>' ||  Get_InfoPathData('Focused_Review_Lymphoma',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '           <extradata>' || LF;
v_Str := v_Str || '              <title>Type</title>'  || LF;
v_Str := v_Str || '              <value>' ||  Get_InfoPathData('Focused_Review_Lymphoma_Box',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '           </extradata>' || LF;   
v_Str := v_Str || '        </questions>'  || LF;
v_Str := v_Str || '   </items>' || LF;

v_Str := v_Str || '   <items>' || LF;
v_Str := v_Str || '        <title>Musculoskeletal</title>'  || LF;
v_Str := v_Str || '        <value/>' || LF;
v_Str := v_Str || '        <questions>'  || LF;
v_Str := v_Str || '           <title>Rheumatoid Arthritis (RA)</title>'  || LF; 
v_Str := v_Str || '            <value>' ||  Get_InfoPathData('Focused_Review_RA',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '        </questions>'  || LF; 
v_Str := v_Str || '        <questions>' || LF;
v_Str := v_Str || '            <title>Osteoarthritis(OA or DJD)</title>'  || LF;
v_Str := v_Str || '            <value>' ||  Get_InfoPathData('Focused_Review_Osteoarthritis',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '        </questions>'  || LF;  
v_Str := v_Str || '        <questions>'  || LF;
v_Str := v_Str || '            <title>Fracture/Injury</title>'  || LF;
v_Str := v_Str || '            <value>' ||  Get_InfoPathData('Focused_Review_Fracture',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '            <extradata>'  || LF;
v_Str := v_Str || '                  <title>Location R/L</title>'  || LF;
v_Str := v_Str || '                  <value>' ||  Get_InfoPathData('Focused_Review_Fracture',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '            </extradata>'  || LF;  
v_Str := v_Str || '            <extradata>' || LF;
v_Str := v_Str || '                  <title>Location</title>'  || LF;
v_Str := v_Str || '                  <value>' ||  Get_InfoPathData('Focused_Review_Fracture_Location',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '            </extradata>'  || LF; 
v_Str := v_Str || '        </questions>'  || LF;  
v_Str := v_Str || '        <questions>'  || LF;
v_Str := v_Str || '            <title>Joint stiffness</title>'  || LF;
v_Str := v_Str || '            <value>' ||  Get_InfoPathData('Focused_Review_Joint_Stiffness',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '        </questions>'  || LF; 
v_Str := v_Str || '        <questions>' || LF;
v_Str := v_Str || '            <title>Joint Pain</title>'  || LF;
v_Str := v_Str || '            <value>' ||  Get_InfoPathData('Focused_Review_Joint_Pain',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '        </questions>'  || LF;  
v_Str := v_Str || '        <questions>' || LF;
v_Str := v_Str || '            <title>Back Pain</title>'  || LF;
v_Str := v_Str || '            <value>' ||  Get_InfoPathData('Focused_Review_Back_Pain',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '        </questions>'  || LF; 
v_Str := v_Str || '        <questions>' || LF;
v_Str := v_Str || '            <title>Osteoporosis</title>'  || LF;
v_Str := v_Str || '            <value>' ||  Get_InfoPathData('Focused_Review_Osteoporsis',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '        </questions>'  || LF;  
v_Str := v_Str || '        <questions>'  || LF;
v_Str := v_Str || '            <title>Gout</title>'  || LF;
v_Str := v_Str || '            <value>' ||  Get_InfoPathData('Focused_Review_Gout',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '        </questions>'  || LF; 
v_Str := v_Str || '   </items>'   || LF;

v_Str := v_Str || '   <items>'   || LF;
v_Str := v_Str || '        <title>Neurology</title>'  || LF;
v_Str := v_Str || '        <value/>'  || LF;
v_Str := v_Str || '        <questions>' || LF;
v_Str := v_Str || '            <title>Stroke or TIA</title>'  || LF;
v_Str := v_Str || '            <value>' ||  Get_InfoPathData('Focused_Review_Stroke',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '        </questions>'  || LF;  
v_Str := v_Str || '        <questions>'  || LF;
v_Str := v_Str || '            <title>Dementia</title>'  || LF;
v_Str := v_Str || '            <value>' ||  Get_InfoPathData('Focused_Review_Dementia',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '        </questions>'  || LF;  
v_Str := v_Str || '        <questions>'  || LF;
v_Str := v_Str || '            <title>Memory Change</title>'  || LF;
v_Str := v_Str || '            <value>' ||  Get_InfoPathData('Focused_Review_Memory_Change',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '        </questions>'  || LF;  
v_Str := v_Str || '        <questions>'  || LF;
v_Str := v_Str || '            <title>Numbness or tingling in hands or feet</title>'  || LF; 
v_Str := v_Str || '            <value>' ||  Get_InfoPathData('Focused_Review_Numb_Hands',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '            <extradata>'  || LF;
v_Str := v_Str || '                  <title>Type</title>'  || LF;
v_Str := v_Str || '                  <value>' ||  Get_InfoPathData('Focused_Review_Numb_Hands_Bilateral +Focused_Review_Numb_Hands_Unilateral',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '            </extradata>'  || LF;
v_Str := v_Str || '        </questions>'  || LF; 
v_Str := v_Str || '        <questions>' || LF;
v_Str := v_Str || '            <title>Trouble Walking</title>'  || LF;  
v_Str := v_Str || '            <value>' ||  Get_InfoPathData('Focused_Review_Neuro_Trouble_Walking',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '        </questions>'  || LF;  
v_Str := v_Str || '        <questions>'  || LF;
v_Str := v_Str || '            <title>Paralysis</title>'  || LF;
v_Str := v_Str || '            <value>' ||  Get_InfoPathData('Focused_Review_Neuro_Paralysis',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '        </questions>'  || LF; 
v_Str := v_Str || '        <questions>'   || LF;
v_Str := v_Str || '            <title>Tremors</title>'  || LF;
v_Str := v_Str || '            <value>' ||  Get_InfoPathData('Focused_Review_Tremors',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '        </questions>'  || LF; 
v_Str := v_Str || '        <questions>'  || LF;
v_Str := v_Str || '            <title>Seizures</title>'  || LF;
v_Str := v_Str || '            <value>' ||  Get_InfoPathData('Focused_Review_Seizures',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '        </questions>'  || LF; 
v_Str := v_Str || '        <questions>'  || LF;
v_Str := v_Str || '            <title>Parkinson''s Disease</title>'  || LF;
v_Str := v_Str || '            <value>' ||  Get_InfoPathData('Focused_Review_Parkinsons',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '        </questions>'  || LF;
v_Str := v_Str || '   </items>' || LF; 

v_Str := v_Str || '   <items>' || LF;
v_Str := v_Str || '        <title>Endocrine</title>'  || LF;
v_Str := v_Str || '        <value/>' || LF;
v_Str := v_Str || '        <questions>' || LF;
v_Str := v_Str || '            <title>Thyroid Disorder</title>'  || LF;
v_Str := v_Str || '            <value>' ||  Get_InfoPathData('Focused_Review_Thyroid',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '        </questions>'  || LF; 
v_Str := v_Str || '        <questions>' || LF;
v_Str := v_Str || '            <title>Diabetes</title>'  || LF;
v_Str := v_Str || '            <value>' ||  Get_InfoPathData('Focused_Review_Diabetes',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '        </questions>'  || LF;
v_Str := v_Str || '   </items>' || LF; 

v_Str := v_Str || '   <items>' || LF;
v_Str := v_Str || '        <title>Psychiatric</title>'  || LF;
v_Str := v_Str || '        <value/>'  || LF;
v_Str := v_Str || '        <questions>'  || LF;
v_Str := v_Str || '            <title>Bipolar disorder diagnosed</title>'  || LF;
v_Str := v_Str || '            <value>' ||  Get_InfoPathData('Focused_Review_Bipolar',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '        </questions>'  || LF; 
v_Str := v_Str || '        <questions>' || LF;
v_Str := v_Str || '            <title>Anxiety/excessive nervousness</title>'  || LF;
v_Str := v_Str || '            <value>' ||  Get_InfoPathData('Focused_Review_Anxiety',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '        </questions>'  || LF; 
v_Str := v_Str || '        <questions>'  || LF;
v_Str := v_Str || '            <title>Hallucinations</title>'  || LF;
v_Str := v_Str || '            <value>' ||  Get_InfoPathData('Focused_Review_Hallucinations',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '        </questions>'  || LF; 
v_Str := v_Str || '        <questions>'  || LF;
v_Str := v_Str || '            <title>Schizophrenia</title>'  || LF;
v_Str := v_Str || '            <value>' ||  Get_InfoPathData('Focused_Review_Schizophrenia',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '        </questions>'  || LF; 
v_Str := v_Str || '   </items>' || LF;

v_Str := v_Str || '   <bladdercontrol>'  || LF;
v_Str := v_Str || '        <items>'  || LF;
v_Str := v_Str || '            <title>In the past 6 months have you accidentally leaked urine?</title>'  || LF;
v_Str := v_Str || '            <value>' ||  Get_InfoPathData('Bladder_leaked',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '        </items>' || LF; 
v_Str := v_Str || '        <items>'  || LF;
v_Str := v_Str || '            <title>Is the urinary leakage a problem for you?</title>'  || LF;
v_Str := v_Str || '            <value>' ||  Get_InfoPathData('Bladder_leaked_problem',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '        </items>' || LF; 
v_Str := v_Str || '        <items>'  || LF;
v_Str := v_Str || '            <title>Educated the patient about the causes of urinary incontinence</title>'  || LF; 
v_Str := v_Str || '            <value>' ||  Get_InfoPathData('Bladder_Incontionence_Educated',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '        </items>' || LF; 
v_Str := v_Str || '        <items>'  || LF;
v_Str := v_Str || '            <title>Discussed the roles of training, exercises, and medication</title>'  || LF;
v_Str := v_Str || '            <value>' ||  Get_InfoPathData('Bladder_training',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '        </items>' || LF; 
v_Str := v_Str || '        <items>'  || LF;
v_Str := v_Str || '            <title>Provided education about non-pharmaceutical mechanisms</title>'  || LF;
v_Str := v_Str || '            <value>' ||  Get_InfoPathData('Bladder_pharma',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '        </items>' || LF;  
v_Str := v_Str || '        <items>' || LF;
v_Str := v_Str || '            <title>Advised to follow up with PCP for ongoing care</title>'  || LF;
v_Str := v_Str || '            <value>' ||  Get_InfoPathData('Bladder_PCP_advised',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '        </items>' || LF;  
v_Str := v_Str || '   </bladdercontrol>'  || LF;

v_Str := v_Str || ' </FocusedSystemReview>'  || LF; 
 
------------------------------------
 
 
       RETURN v_Str;
       
       EXCEPTION WHEN OTHERS THEN
            v_Str := SUBSTR(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
                              CHR(13) ||
                              SQLERRM,1,4000); 
           
       END;

/

