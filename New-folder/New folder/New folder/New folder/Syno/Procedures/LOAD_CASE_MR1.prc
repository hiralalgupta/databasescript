--------------------------------------------------------
--  DDL for Procedure LOAD_CASE_MR1
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "SNX_IWS2"."LOAD_CASE_MR1" 
  -- Program name - LOAD_CASE_MR1
  -- Created 9-27-2011 R Benzell
  -- use current prod format of files that have been processed by:
  -- 1) consolidate all tabs into a single tab
    -- 2) convert dates to MM/DD/YYYY format
    -- 3) copy CAT values into column A
    -- 4) save a tab-delimited
    -- 5) notepad - replace tabs with | pipe
    -- 6) delete 'header' lines in file
    -- 7) cut and paste lines into this file
  -- run manually, replacing the pipe  or CASEID with cut and paste
  --
/** to test    
begin
  LOAD_CASE_MR1(52,'LOAD');
end;
***/
    
           (
             P_CASEID in NUMBER default 53,
             P_RUN IN VARCHAR2 default 'SHOW'   --LOAD
           )   
               
  
         IS
 
 
        v_data clob;
        J Integer;
               
     --- Array to Hold Lines
         LINE_Arr2 HTMLDB_APPLICATION_GLOBAL.VC_ARR2;
         BEGIN
             --- Parse the line into separate elements
             
v_data :=
'General Health|3/10/2003|Height|5 ft||61|11|
General Health|3/20/2009|Weight|120 lbs||61|11|
General Health|3/24/2009|BMI|23.5|Normal|61|11|
General Health|3/20/2009|Alcohol|No alchol intake|None|70|26|
General Health|3/20/2009|Smoking|No smoking|Non-Smoker|70|24|
Disease and Injury|3/26/2009|Diagnosis|Stage 2 duoderm on sacrum area|Positive|100|5|l89.9
Disease and Injury|3/26/2009|Diagnosis|Incontinent of urine|Positive|100|12|R32
Disease and Injury|3/26/2009|Diagnosis|Confused oriented to time and place|Positive|100|19|R41.0
Disease and Injury|3/25/2009|Mental Symptoms|Confused||36|23|R41.0
Disease and Injury|3/25/2009|Physical Symptoms|Pain over right groin area||97|6|
Disease and Injury|3/24/2009|Diagnosis|Sacrum has partial thickness loss of dermis as shallow open ulcer with red pink wound bed without slough (Stage 2)|Positive|61|24|L89.142
Disease and Injury|3/24/2009|Diagnosis|"Records showed oral intake decreasing to less than 10%, fatal assistance with feeding, experiencing inadequate nutrition, swallow evaluation prescribed"|Positive|61|23|
Disease and Injury|3/24/2009|Diagnosis|Pyelonephritis|Positive|64|5|N11.1
Disease and Injury|3/24/2009|Diagnosis|Mild right hydroureter|Positive|35|12|N13.4
Disease and Injury|3/24/2009|Diagnosis|Possible stone|Positive|34|14|N20.0
Disease and Injury|3/24/2009|Physical Symptoms|High nutritional risk||61|3|E63.9
Disease and Injury|3/24/2009|Physical Symptoms|"Past medical history of colon cancer, colon resection with colostomy, arrhythemia and hypertension "||61|10|D01.0
Disease and Injury|3/23/2009|Diagnosis|Bilateral pleural effusion|Positive|130|13|J91.8
Disease and Injury|3/23/2009|Diagnosis|Biliary ductal dilatation. 1.4 cm non obstructing stone in upper pole of the left kidney|Positive|130|17|
Disease and Injury|3/23/2009|Diagnosis|Mild right sided hydronephrosis and hydroureter|Positive|130|27|
Disease and Injury|3/23/2009|Diagnosis|"Sacrum with duoderm, left colostomy, hands with ecchymosis"|Positive|83|18|
Disease and Injury|3/23/2009|Diagnosis|Right abdominal pain|Positive|83|27|R10.10
Disease and Injury|3/23/2009|Diagnosis|Left shin area with erythema and oedema|Positive|88|21|L51.9
Disease and Injury|3/23/2009|Diagnosis|Mild bibasilar atelectasis|Positive|130|29|
Disease and Injury|3/23/2009|Mental Symptoms|Did not recognize her daughter today||87|28|
Disease and Injury|3/23/2009|Physical Symptoms|"Out of sleep all night, confused at times"||86|6|
Disease and Injury|3/22/2009|Diagnosis|Right sided pain|Positive|107|4|
Disease and Injury|3/22/2009|Diagnosis|Pyelonephritis|Positive|111|4|N11.1
Disease and Injury|3/22/2009|Diagnosis|Sacrum has partial thickness loss of dermis as shallow open ulcer with red pink wound bed without slough (Stage 2)|Positive|79|7|L89.9
Disease and Injury|3/22/2009|Diagnosis|"Abdomen slightly distended, left colostomy with stools"|Positive|82|9|
Disease and Injury|3/22/2009|Diagnosis|Localized acne over heads and both feets |Positive|83|7|L70
Disease and Injury|3/22/2009|Diagnosis|Deviation in  genitourinary and GI status|Positive|80|14|
Disease and Injury|3/22/2009|Diagnosis|Deviation in  neuro and cognitive status|Positive|80|17|
Disease and Injury|3/21/2009|Diagnosis|Diastolic dysfunction|Positive|452|15|I51.9
Disease and Injury|3/21/2009|Diagnosis|Confused |Positive|74|27|R41.0
Disease and Injury|3/21/2009|Diagnosis|Left sided colostomy|Positive|78|14|
Disease and Injury|3/21/2009|Diagnosis|Acute hypertension|Positive|78|18|
Disease and Injury|3/21/2009|Diagnosis|Hypomagnesemia|Positive|30|29|E83.42
Disease and Injury|3/21/2009|Diagnosis|Tachypnea|Positive|29|14|R06.82
Disease and Injury|3/21/2009|Diagnosis|Chronic heart failure|Positive|29|15|I50.22
Disease and Injury|3/21/2009|Diagnosis|Hypertension|Positive|29|17|I10
Disease and Injury|3/21/2009|Diagnosis|Stage 2 on sacrum|Positive|78|18|
Disease and Injury|3/21/2009|Diagnosis|Multiple acnes on peripherals but not on skin of back|Positive|78|18|
Disease and Injury|3/21/2009|Physical Symptoms|Sacral and buttocks redness||78|7|
Disease and Injury|3/21/2009|Physical Symptoms|Vomiting||30|22|R11.10
Disease and Injury|3/20/2009|Diagnosis|Right upper quadrant (RUQ) abdominal pain and history of colon cancer|Positive|18|12|R10.9
Disease and Injury|3/20/2009|Diagnosis|Tachypnea|Positive|114|11|R06.82
Disease and Injury|3/20/2009|Diagnosis|Eccyhymosis noted to arms|Positive|9|15|R23.3
Disease and Injury|3/20/2009|Diagnosis|Cardiac enlargement and coronary artery calcification|Positive|18|15|I25.119
Disease and Injury|3/20/2009|Diagnosis|Mild intrahepatic biliary dilatation and marked common bile duct dilatation which measures 17mm in diameter.|Positive|18|17|
Disease and Injury|3/20/2009|Diagnosis|Atrophic pancreas|Positive|18|18|K86.8
Disease and Injury|3/20/2009|Diagnosis|1.4 cm left upper pole renal calculus|Positive|18|20|N20.0
Disease and Injury|3/20/2009|Diagnosis|Right hydronephrosis and hydroureter with enhancing right ureter suspicious of possibly pyelonephritis|Positive|19|14|N13.721
Disease and Injury|3/20/2009|Diagnosis|Right ureter wall thickened which raises the possibility of pyelonephritis|Positive|18|22|N11.1
Disease and Injury|3/20/2009|Diagnosis|Mildly distended bladder|Positive|18|25|
Disease and Injury|3/20/2009|Diagnosis|Minimal fluid noticed in pelvis|Positive|19|6|
Disease and Injury|3/20/2009|Diagnosis|Osteoporosis|Positive|19|7|
Disease and Injury|3/20/2009|Diagnosis|Elevated right hemidiaphragm|Positive|22|8|
Disease and Injury|3/20/2009|Diagnosis|Genitourinary status is incontinence|Positive|69|9|R32
Disease and Injury|3/20/2009|Diagnosis|"Patient is confused, language barrier"|Positive|69|17|R41.0
Disease and Injury|3/20/2009|Diagnosis|Confused and disoriented|Positive|69|4|R41.0
Disease and Injury|3/20/2009|Diagnosis|"Mild left hydronephrosis and hydroureter, more pronounced on right side "|Positive|18|20|N13.721
Disease and Injury|3/20/2009|Mental Symptoms|Mild distress on arrival to hospital||12|12|
Disease and Injury|3/20/2009|Physical Symptoms|"Complains of diarrhea, flatus, bloating, belching and malaise"||9|7|R19.7
Disease and Injury|3/20/2009|Physical Symptoms|"Acute weakness, unsteady gait, needs maximum assistance to ambulate, difficulty moving into or out of bed, difficulty with bed mobility"||69|20|
Disease and Injury|3/20/2009|Physical Symptoms|"Difficulty performing basic grooming activities, difficulty dressing self"||69|23|
Disease and Injury|3/20/2009|Physical Symptoms|Sensory perception is very limited||70|10|
Disease and Injury|3/20/2009|Physical Symptoms|Completely immobile||70|11|
Disease and Injury|3/10/2009|Diagnosis|Left and right weakness|Positive|103|18|R53.1
Disease and Injury|3/10/2009|Diagnosis|Incontinent|Positive|103|16|R32
Disease and Injury|3/10/2009|Mental Symptoms|Confused behavior||103|18|R41.0
Disease and Injury|2/4/2009|Mental Symptoms|Cognitive limitations||104|5|
Diagnostic Tests & Procedures|3/26/2009|Blood Pressure|142/66|High|37|9|R03.0
Diagnostic Tests & Procedures|3/25/2009|Blood Pressure|126/62|Borderline|36|9|
Diagnostic Tests & Procedures|3/23/2009|Blood Pressure|108/82|Normal|33|10|
Diagnostic Tests & Procedures|3/22/2009|Blood Pressure|116/49|Normal|31|19|
Diagnostic Tests & Procedures|3/21/2009|Blood Pressure|162/87|High|74|22|R03.0
Diagnostic Tests & Procedures|3/21/2009|Blood Pressure|153/73|Borderline|78|17|
Diagnostic Tests & Procedures|3/21/2009|Blood Pressure|130/70|High|30|6|R03.0
Diagnostic Tests & Procedures|3/26/2009|Other Test|Braden scale: Total 12 (Score of 18 or below = Risk)|Low|57|27|
Diagnostic Tests & Procedures|3/24/2009|Other Test|Braden scale: Total 11 (Score of 18 or below = Risk)|Low|55|27|
Biochemistry|3/25/2009|Blood Test|RBC 3.47 K/uL [3.76-5.17 K/uL]|Low|134|6|
Biochemistry|3/25/2009|Blood Test|Haemoglobin 11.1 gm/dL [11.6-15.3 gm/dL]|Low|134|6|
Biochemistry|3/25/2009|Blood Test|Haematocrit 33 % [34-45 %]|Low|134|7|
Biochemistry|3/25/2009|Blood Test|Calcium 7.7 mg/dL [8.4-10.5 mg/dL]|Low|135|5|
Biochemistry|3/25/2009|Blood Test|Chloride 115 mEq/L [100-110 mEq/L]|High|135|7|
Biochemistry|3/25/2009|Blood Test|Glomerular filteration rate 54 ml/min [more than 60]|Abnormal|135|10|
Biochemistry|3/24/2009|Blood Test|WBC 8.1 K/uL|Normal|132|6|
Biochemistry|3/24/2009|Blood Test|RBC 3.45 M/uL [3.76-5.17 M/uL]|Low|132|6|
Biochemistry|3/24/2009|Blood Test|Haemoglobin 10.8 gm/dL [11.6-15.3 gm/dL]|Low|132|6|
Biochemistry|3/24/2009|Blood Test|Haematocrit 33 % [34-45 %]|Low|132|6|
Biochemistry|3/24/2009|Blood Test|MCV 95.6 fL|Normal|132|7|
Biochemistry|3/24/2009|Blood Test|MCH 31.3 pg|Normal|132|9|
Biochemistry|3/24/2009|Blood Test|MCHC 32.7 %|Normal|132|9|
Biochemistry|3/24/2009|Blood Test|RDW 12.8|Normal|132|9|
Biochemistry|3/24/2009|Blood Test|Platelet count 298 K/uL|Normal|132|10|
Biochemistry|3/24/2009|Blood Test|MPV 6.74 fL|Normal|132|10|
Biochemistry|3/24/2009|Blood Test|Calcium 7.6 mg/dL [8.4-10.5 mg/dL]|Low|133|5|
Biochemistry|3/24/2009|Blood Test|Creatinine 1.16 mg/dL [0.44-1.03 mg/dL]|High|133|9|
Biochemistry|3/24/2009|Blood Test|CrCl 25 mL/min|Normal|133|14|
Biochemistry|3/24/2009|Blood Test|GFR 47 mL/min [more than 60]|Abnormal|133|10|
Biochemistry|3/23/2009|Blood Test|Alkaline phosphatase 209 IU/L [32-92 IU/L]|High|129|6|
Biochemistry|3/23/2009|Blood Test|AST 139 IU/L [15-21 IU/L]|High|129|7|
Biochemistry|3/23/2009|Blood Test|ALT 53 IU/L|Normal|129|8|
Biochemistry|3/23/2009|Blood Test|Total bilirubin 0.90 mg/dL|Normal|129|9|
Biochemistry|3/23/2009|Blood Test|Direct Bilirubin 0.40 mg/dL|Normal|129|10|
Biochemistry|3/23/2009|Blood Test|Albumin 2.3 gm/dL [3.5-4.8 gm/dL]|Low|129|11|
Biochemistry|3/23/2009|Blood Test|Total protein 5.5 gm/dL [6.1-7.9 gm/dL]|Low|129|12|
Biochemistry|3/22/2009|Blood Test|MCHC 32.4 % [32.7-36.3 %]|Low|107|9|
Biochemistry|3/22/2009|Blood Test|Albumin 2.6 gm/dL [3.5-4.8 gm/dL]|Low|108|7|
Biochemistry|3/22/2009|Blood Test|Glucose 112 mg/dL [70-110 mg/dL]|High|108|9|
Biochemistry|3/22/2009|Blood Test|Total Protein 6.1 gm/dL [6.1-7.9 gm/dL]|Borderline|108|15|
Biochemistry|3/22/2009|Blood Test|Prealbumin 14.9 mg/dL [17-40 mg/dL]|Low|111|5|
Biochemistry|3/22/2009|Blood Test|WBC 5.9 K/uL|Normal|121|5|
Biochemistry|3/22/2009|Blood Test|RBC 3.47 K/uL [3.76-5.17 K/uL]|Low|121|6|
Biochemistry|3/22/2009|Blood Test|Haemoglobin 10.8 gm/dL [11.6-15.3 gm/dL]|Low|121|6|
Biochemistry|3/22/2009|Blood Test|Haematocrit 33 % [34-45 %]|Low|121|7|
Biochemistry|3/22/2009|Blood Test|MCV 94.3 fL|Normal|121|8|
Biochemistry|3/22/2009|Blood Test|MCH 31 pg|Normal|121|8|
Biochemistry|3/22/2009|Blood Test|MCHC 32.9 %|Normal|121|9|
Biochemistry|3/22/2009|Blood Test|RDW 12.8%|Normal|121|9|
Biochemistry|3/22/2009|Blood Test|Platelet count 265 K/uL|Normal|121|10|
Biochemistry|3/22/2009|Blood Test|MPV 6.68 fL|Normal|121|10|
Biochemistry|3/22/2009|Blood Test|Sodium 140 mEq/L|Normal|122|5|
Biochemistry|3/22/2009|Blood Test|Potassium 3.2 mEq/L [3.5-5.3 mEq/L]|Low|122|6|
Biochemistry|3/22/2009|Blood Test|Chloride 112 mEq/L [100-110 mEq/L]|High|122|6|
Biochemistry|3/22/2009|Blood Test|CO2 23 mEq/L|Normal|122|7|
Biochemistry|3/22/2009|Blood Test|Albumin 2.1 gm/dL [3.5-4.8 gm/dL]|Low|122|8|
Biochemistry|3/22/2009|Blood Test|Total bilirubin 0.70 mg/dL|Normal|122|9|
Biochemistry|3/22/2009|Blood Test|Calcium 7.8 mg/dL [8.4-10.5 mg/dL]|Low|122|9|
Biochemistry|3/22/2009|Blood Test|Glucose 83 mg/dL|Normal|122|10|
Biochemistry|3/22/2009|Blood Test|Blood urea nitrogen 6 mg/dL [7-21 mg/dL]|Low|122|11|
Biochemistry|3/22/2009|Blood Test|Creatinine 0.99 mg/dL|Normal|122|11|
Biochemistry|3/22/2009|Blood Test|GFR 56 mL/min [more than 60 mL/min]|Abnormal|122|11|
Biochemistry|3/22/2009|Blood Test|CrCl 30 mL/min|Normal|122|15|
Biochemistry|3/22/2009|Blood Test|Alkaline phosphatase 74 IU/L|Normal|122|18|
Biochemistry|3/22/2009|Blood Test|Total Protein 4.7 gm/dL [6.1-7.9 gm/dL]|Low|122|18|
Biochemistry|3/22/2009|Blood Test|AST 16 IU/L|Normal|122|19|
Biochemistry|3/22/2009|Blood Test|Globulin 2.6 gm/dL|Normal|122|20|
Biochemistry|3/22/2009|Blood Test|ALT 11 IU/L [14-54 IU/L]|Low|122|21|
Biochemistry|3/22/2009|Blood Test|Magnesium 2.2 mg/dL|Normal|123|5|
Biochemistry|3/21/2009|Blood Test|WBC 5.3 K/uL|Normal|117|6|
Biochemistry|3/21/2009|Blood Test|RBC 3.75 M/uL [3.76-5.17 M/uL]|Low|117|6|
Biochemistry|3/21/2009|Blood Test|Haemoglobin 11.3 gm/dL [11.6-15.3 gm/dL]|Low|117|6|
Biochemistry|3/21/2009|Blood Test|Haematocrit 35 %|Normal|117|7|
Biochemistry|3/21/2009|Blood Test|MCV 94.1 fL|Normal|117|8|
Biochemistry|3/21/2009|Blood Test|MCH 30.2 pg|Normal|117|8|
Biochemistry|3/21/2009|Blood Test|MCHC 32 % [32.7-36.3 %]|Low|117|9|
Biochemistry|3/21/2009|Blood Test|RDW 12.7%|Normal|117|9|
Biochemistry|3/21/2009|Blood Test|Platelet count 280 K/uL|Normal|117|10|
Biochemistry|3/21/2009|Blood Test|MPV 6.53 fL|Normal|117|11|
Biochemistry|3/21/2009|Blood Test|Neutrophil 70 %|Normal|117|11|
Biochemistry|3/21/2009|Blood Test|Lymphocyte 16 %|Normal|117|12|
Biochemistry|3/21/2009|Blood Test|Monocyte 11 %|Normal|117|12|
Biochemistry|3/21/2009|Blood Test|Eosinophil 3 %|Normal|117|13|
Biochemistry|3/21/2009|Blood Test|Basophil 0 %|Normal|117|14|
Biochemistry|3/21/2009|Blood Test|Absolute neutrophil 3.7 K/uL|Normal|117|14|
Biochemistry|3/21/2009|Blood Test|Absolute Lymphocyte 0.9 K/uL [1.0-3.4 K/uL]|Low|117|15|
Biochemistry|3/21/2009|Blood Test|Absolute monocyte 0.6 K/uL|Normal|117|15|
Biochemistry|3/21/2009|Blood Test|Absolute eosinophil 0.1 K/uL|Normal|117|15|
Biochemistry|3/21/2009|Blood Test|Absolute basophil 0.0 K/uL|Normal|117|16|
Biochemistry|3/21/2009|Blood Test|Calcium 8.2 mg/dL [8.4-10.5 mg/dL]|Low|118|6|
Biochemistry|3/21/2009|Blood Test|Sodium 142 mEq/L|Normal|118|6|
Biochemistry|3/21/2009|Blood Test|Potassium 3.6 mEq/L|Normal|118|6|
Biochemistry|3/21/2009|Blood Test|CO2 22 mEq/L|Normal|118|7|
Biochemistry|3/21/2009|Blood Test|Chloride 111 mEq/L [100-110 mEq/L]|High|118|7|
Biochemistry|3/21/2009|Blood Test|Glucose 78 mg/dL|Normal|118|7|
Biochemistry|3/21/2009|Blood Test|Blood urea nitrogen 9 mg/dL|Normal|118|8|
Biochemistry|3/21/2009|Blood Test|Creatinine 0.95 mg/dL|Normal|118|9|
Biochemistry|3/21/2009|Blood Test|GFR 59 mL/min [more than 60 mL/min]|Abnormal|118|10|
Biochemistry|3/21/2009|Blood Test|CrCl 30 mL/min|Normal|118|14|
Biochemistry|3/21/2009|Blood Test|Magnesium 1.7 mg/dL [1.8-2.5 mg/dL]|Low|119|5|
Biochemistry|3/21/2009|Blood Test|Phosphorus 2.8 mg/dL|Normal|120|5|
Biochemistry|3/20/2009|Blood Test|Albumin 2.6 gm/dL [3.5-4.8 gm/dL]|Low|15|16|
Biochemistry|3/20/2009|Blood Test|Glucose 112 mg/dL ST|High|15|19|
Biochemistry|3/20/2009|Blood Test|GFR (Glomerular Filtration Rate) 58 mL/min/1.73m^2ST|Abnormal|15|21|
Biochemistry|3/20/2009|Blood Test|Total Protein 6.1 gm/dL|Borderline|16|6|
Biochemistry|3/20/2009|Blood Test|Pre Albumin 14.9 mg/dL [17.0-40.0 mg/dL]|Low|17|18|
Biochemistry|3/20/2009|Blood Test|Hemoglobin 12.6 gm/dL |Normal|14|10|
Biochemistry|3/20/2009|Blood Test|Hematocrit 39 %|Normal|14|11|
Biochemistry|3/20/2009|Blood Test|MCV 93.3 fL|Normal|14|12|
Biochemistry|3/20/2009|Blood Test|MCH 30.2 pg|Normal|14|13|
Biochemistry|3/20/2009|Blood Test|MCHC (Mean corpuscular hemoglobin concentration) 32.4 % [32.7-36.3%]|Low|14|14|
Biochemistry|3/20/2009|Blood Test|Red Blood Cell Distribution Width (RDW) 12.8%|Normal|14|15|
Biochemistry|3/20/2009|Blood Test|Platelet count 284 K/uL|Normal|14|16|
Biochemistry|3/20/2009|Blood Test|Mean Platelet Volume 6.76 fL|Normal|14|17|
Biochemistry|3/20/2009|Blood Test|Neutrophil 61 %|Normal|14|19|
Biochemistry|3/20/2009|Blood Test|Lymphocyte 25 %|Normal|14|19|
Biochemistry|3/20/2009|Blood Test|Monocyte 11 %|Normal|14|20|
Biochemistry|3/20/2009|Blood Test|Eosinophil 3 %|Normal|14|21|
Biochemistry|3/20/2009|Blood Test|Basophil 0%|Normal|14|21|
Biochemistry|3/20/2009|Blood Test|Absolute basophil 0.0 K/uL|Normal|14|25|
Biochemistry|3/20/2009|Blood Test|Absolute neutrophil 2.6 K/uL|Normal|14|22|
Biochemistry|3/20/2009|Blood Test|Absolute lymphocyte 1.0 K/uL|Normal|14|23|
Biochemistry|3/20/2009|Blood Test|Absolute monocyte 0.5 K/uL|Normal|14|23|
Biochemistry|3/20/2009|Blood Test|Sodium 140 mEq/L|Normal|15|13|
Biochemistry|3/20/2009|Blood Test|Potassium 4.1 mEq/L|Normal|15|14|
Biochemistry|3/20/2009|Blood Test|Chloride 109 mEq/L|Normal|15|14|
Biochemistry|3/20/2009|Blood Test|CO2 25 mEq/L|Normal|15|15|
Biochemistry|3/20/2009|Blood Test|Total bilirubin 0.70 mEq/L|Normal|15|17|
Biochemistry|3/20/2009|Blood Test|Calcium 8.8 mEq/L|Normal|15|17|
Biochemistry|3/20/2009|Blood Test|Blood urea nitrogen 14 mEq/L|Normal|15|19|
Biochemistry|3/20/2009|Blood Test|Creatinine 0.96 mEq/L|Normal|15|20|
Biochemistry|3/20/2009|Blood Test|Alkaline phosphatase 85 IU/L |Normal|15|25|
Biochemistry|3/20/2009|Blood Test|Aspartate aminotransferase (AST) 21 IU/L|Normal|16|7|
Biochemistry|3/20/2009|Blood Test|Globulin 3.5 gm/dL|Normal|16|8|
Biochemistry|3/20/2009|Blood Test|Alanine tranferase(ALT) 15 IU/L |Normal|16|8|
Biochemistry|3/20/2009|Blood Test|Amylase 44 IU/L |Normal|16|15|
Biochemistry|3/20/2009|Blood Test|Lipase 25 IU/L |Normal|16|23|
Biochemistry|3/20/2009|Blood Test|White Blood cell 4.2 K/uL|Normal|14|8|
Biochemistry|3/20/2009|Blood Test|Red Blood cell 4.16 M/uL|Normal|14|8|
Biochemistry|3/23/2009|Urine|"Microscopic, WBC Full field [ 1-2/HPF]"|Abnormal|125|6|
Biochemistry|3/23/2009|Urine|"Microscopic, RBC 4-10/HPF [1-2/HPF]"|Abnormal|125|6|
Biochemistry|3/23/2009|Urine|Squamous and renal epithelial cell not seen|Normal|125|7|
Biochemistry|3/23/2009|Urine|Urine bacteria 2+ [should be negative]|Abnormal|125|7|
Biochemistry|3/23/2009|Urine|Amylase 34 IU/L|Normal|127|5|
Biochemistry|3/23/2009|Urine|Lipase 23 IU/L |Normal|128|6|
Biochemistry|3/22/2009|Urine|"Urine appearance straw, turbid"|Normal|124|6|
Biochemistry|3/22/2009|Urine|Specific gravity 1.020|Normal|124|6|
Biochemistry|3/22/2009|Urine|pH 6|Normal|124|7|
Biochemistry|3/22/2009|Urine|Glucose negative|Normal|124|8|
Biochemistry|3/22/2009|Urine|Ketones negative|Normal|124|8|
Biochemistry|3/22/2009|Urine|Blood 3+ |Abnormal|124|9|
Biochemistry|3/22/2009|Urine|Urobilinogen 0.2 EU/dL |Borderline|124|9|
Biochemistry|3/22/2009|Urine|Nitrite negative|Normal|124|10|
Biochemistry|3/22/2009|Urine|Leukocytes large [should be negative]|Abnormal|124|11|
Biochemistry|3/22/2009|Urine|Protein  2+ [should be negative]|Abnormal|124|11|
Biochemistry|3/22/2009|Urine|Bilirubin negative|Normal|124|11|
Microbiology|3/20/2009|Bacteriology|Blood culture showed no growth for 5 days |Negative|115|6|
Microbiology|3/23/2009|Culture|Urine: No growth|Abnormal|125|5|
Imaging|3/23/2009|CT Scan|"Abdomen and pelvis without contrast, small bilateral pleural effusions, mild bibasilar atelectasis. Pancreas atrophic. Biliary ductal dilatation. 1.4 cm non obstructing stone in upper pole of the left kidney. Bilateral extrarenal pelvis. Mild right sided hydronephrosis and hydroureter. Small fluid in the pelvis. Osteoporotic and degenerative bones."|Abnormal|130|26|BW21ZZZ
Imaging|3/20/2009|CT Scan|"Abdomen and pelvis: status post colecystectomy and anterior posterior resection with lower left quadrant colostomy, intra and extrahepatic biliary dilatation, left reanal calculus and right hydronephrosis and hydroureter suspicious possible for pyelonephritis "|Abnormal|112|29|
Imaging|3/20/2009|X-ray|"Chest: Elevated right hemi diaphragm, bones osteoporotic and degenerated, no active disease."|Abnormal|22|8|
Hospitalisations|3/24/2009|Hospitalisation|Admitted for abdomen pain and hydronepheritis|Admitted|61|2|
Hospitalisations|3/20/2009|Hospitalisation|Sacrum has partial thickness loss of dermis as shallow open ulcer with red pink wound bed without slough (Stage 2)|Admitted|59|7|
Hospitalisations|3/20/2009|Hospitalisation|"Abdominal pain, Pyelonephritis"|Admitted|61|10|R10.9
Hospitalisations|4/4/2009|Non_Surgical|Pump Nebulizer|Performed|146|28|
Hospitalisations|4/2/2009|Surgical|Angio catheterization|Performed|145|11|
Hospitalisations|3/24/2009|Surgical|Resection of colon with colostomy|Performed|61|10|
Hospitalisations|3/20/2009|Surgical|AP resection and left lower quadrant colostomy present.|Performed|112|23|
Hospitalisations|3/20/2009|Surgical|Previous cholecystectomy|Performed|18|17|
Hospitalisations|3/10/2009|Surgical|Holister Ostomy|Performed|103|18|
Drugs & Medications|4/3/2009|Oral|Albuterol sulfate 0.5 ml|Administered|146|18|
Drugs & Medications|4/2/2009|Oral|Atenolol 25 mg|Administered|145|29|
Drugs & Medications|4/2/2009|Oral|Cordarone 200mg|Administered|145|29|
Drugs & Medications|4/2/2009|Oral|Tylenol 325 mg|Administered|145|30|
Drugs & Medications|4/2/2009|Oral|Wellbutrin 75 mg|Administered|145|30|
Drugs & Medications|3/26/2009|Oral|Cordarone 200mg|Administered|102|8|
Drugs & Medications|3/26/2009|Oral|Wellbutrin 37.5 mg|Administered|102|10|
Drugs & Medications|3/26/2009|Oral|Tylenol 650 mg|Administered|102|14|
Drugs & Medications|3/26/2009|Oral|Percocet 5-235 mg|Administered|102|16|
Drugs & Medications|3/26/2009|Oral|Unasyn 1.5 gm solution every 6 hours |Prescribed|102|4|
Drugs & Medications|3/24/2009|Oral|Reglan|Prescribed|61|11|
Drugs & Medications|3/20/2009|Oral|Amiodarone Hydrochloride|Administered|9|22|
Drugs & Medications|3/20/2009|Oral|Atenolol 25 mg|Administered|9|22|
Drugs & Medications|3/20/2009|Oral|Bupropion hydrochloride|Administered|9|23|
Drugs & Medications|3/20/2009|Topical|Duoderm patch|Administered|59|23|';
             
 --- Parse line based on LF character
   LINE_Arr2 := HTMLDB_UTIL.STRING_TO_TABLE(v_Data,chr(10));
   htp.p('Case Id: ' || P_CASEID);
   htp.p('Line cnt: ' || LINE_arr2.count);
      for J in 1..LINE_arr2.count
                  LOOP
                    null;
                    -- DATA_Arr2(J),1,25))),
                     LOAD_DP_LINE(P_CASEID,ltrim(LINE_arr2(J)),P_RUN);
                  END LOOP;   
             
       EXCEPTION WHEN OTHERS THEN LOG_APEX_ERROR(15);
             
       END;

/

