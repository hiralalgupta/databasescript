CREATE OR REPLACE PROCEDURE "CASE_555"              -- Program name - CASE_555
                                      -- Created 9-26-2011 R Benzell
                                      -- run manually, replacing the CSV or CASEID with cut and paste
                                      -- xxx
(P_CASEID IN NUMBER DEFAULT 123, P_RUN IN VARCHAR2 DEFAULT 'SHOW'       --LOAD
                                                                 )
IS
   v_data      CLOB;
   J           INTEGER;

   --- Array to Hold Lines xxxx
   LINE_Arr2   HTMLDB_APPLICATION_GLOBAL.VC_ARR2;
BEGIN
   --- Parse the line into separate elements xxxx

   v_data :=
      'Background Data,9/1/2011,Full Name,,Patient 555,,,,
Background Data,,DOB,,2-Nov-69,,,,
Background Data,,Age,,36,,,,
Background Data,,Sex,,Male,,,,
Background Data,,Postal Code,,AB25 2AY,,,,
Background Data,6/24/2009,Height,,1.83 meters,,,,
Background Data,5/10/2009,Last Weight,,94 kgs,,,,
Background Data, ,Weight Group,,Overweight,,,,
Background Data,10/5/2009,Last BMI,,28.5,,,,
Background Data,,BMI Status,,Overweight,,,,
Background Data,8/19/2009,Last Smoking,,Non-Smoker,,,,
Background Data,,Smoking History,,Variable,,,,
Background Data,6/24/2009,Last Alcohol,,Yes,,,,
Background Data,,Alcohol Data Date,,,,,,
Background Data,,Alcohol History,,Variable,,,,
Background Data,,Last Substance Use,,None,,,,
Background Data,,Substance Data Date,,None,,,,
Background Data,,Substance Description,,None,,,,
Background Data,,Family Medical History,,None of Note,,,,
General Health,9/21/2009,Alcohol Use,Low Alcohol,Drinks small amount of alcohol,,18,19,
General Health,6/24/2009,Alcohol Use,Heavy Alcohol,Drinks slightly above recommended limit, High,38,7,
General Health,8/4/2008,Alcohol Use,Low Alcohol,Drinks minimal amount of alcohol,,20,16,
General Health,3/22/2005,Alcohol Use,Moderate Alcohol,Moderate Drinker 3-6 Units/day,,4,21,
General Health,3/23/1998,Alcohol Use,Moderate Alcohol,Drinks 10 to 20 Units of alcohol/week,,3,16,
General Health,10/5/2009,BMI Measurement,,Measured BMI 28.5,Overweight,18,21,
General Health,7/21/2004,Family History,,No family medical history of note,Normal,69,19,
General Health,8/24/2009,Height,,1.83 meters,,4,24,
General Health,8/19/2009,Smoking,Non-Smoker,Non-Smoker,,18,19,
General Health,8/7/2008,Smoking,Non-Smoker,Does not smoke,,20,16,
General Health,6/16/2007,Smoking,Never Smoked,Never smoked tobacco,,4,20,
General Health,10/18/2005,Smoking,Stopped Smoking,Stopped smoking in 2004,,53,24,
General Health,3/23/2005,Smoking,Non-Smoker,No tobacco use,,103,4,
General Health,7/20/2004,Smoking,Smoker,He is current smoker having taken up smoking during this illness,,69,18,
General Health,3/23/1998,Smoking,Non-Smoker,No tobacco use,,103,3,
General Health,1/1/1997,Smoking,Stopped Smoking,Stopped smoking,,3,15,
General Health,3/23/1998,Substance Use,No,Has not used substances,,3,18,
General Health,8/24/2009,Weight,,94 kgs,,4,23,
Disease and Injury,1/21/2010,Diagnosis,Suffers from gastro-oesophageal reflux disease or GORD,Positive,K21,9,5,
Disease and Injury,1/15/2010,Physical Symptoms,Skin itchiness and dryness when taking Lansoprazole,,,9,6,
Disease and Injury,11/26/2009,Physical Symptoms,Throat very sore from previous surgery,,,9,8,
Disease and Injury,11/20/2009,Physical Symptoms,Snoring,,,17,15,
Disease and Injury,9/21/2009,Diagnosis,Snoring. Long uvula.,Abnormal,R06.5,18,20,
Disease and Injury,7/8/2009,Diagnosis,Small spermatocele,Abnormal,N43.4,9,10,
Disease and Injury,7/2/2009,Diagnosis,Testicular lump about 12mm,Abnormal,N43.4,33,15,
Disease and Injury,6/24/2009,Physical Symptoms,12mm hard lump behind left testicle,,N43.4,9,11,
Disease and Injury,1/3/2008,Physical Symptoms,Persistent diarrhoea,,K59.1,9,19,
Disease and Injury,12/28/2007,Physical Symptoms,Skin lesions on both feet,,R21,9,20,
Disease and Injury,9/4/2007,Diagnosis,Vasectomy failure,Abnormal,,25,12,
Disease and Injury,12/20/2005,Physical Symptoms,Continued episodes of pins and needles. Negative for Lyme Disease.,Negative,R20.2,59,15,
Disease and Injury,11/10/2005,Diagnosis,"Negative for Brucella, Borrelia, Leptospira and Toxoplasma",Negative,A69.2,61,18,
Disease and Injury,11/1/2005,Diagnosis,No cause or diagnosis for pins & needles,Inconclusive,R20.2,60,20,
Disease and Injury,10/18/2005,Physical Symptoms,Sudden development of pins and needles over back of left hand and left arm,,R20.2,53,18,
Disease and Injury,9/27/2005,Physical Symptoms,"Fatigue, joint problems and problems with memory",,R53,55,16,
Disease and Injury,7/7/2005,Diagnosis,Pulled muscle and back pain,Injury,M62.9,88,18,
Disease and Injury,3/7/2005,Diagnosis,There is no sinister cause for unexplained sensory symptoms,Inconclusive,R20.2,51,20,
Disease and Injury,3/7/2005,Physical Symptoms,Sensory disturbances affecting different parts of the body,,R20.2,51,16,
Disease and Injury,1/28/2005,Mental Symptoms,Ongoing mood disturbance,,F34.9,62,19,
Disease and Injury,12/17/2004,Physical Symptoms,Intermittent transient patches of numbness and pins and needles over a number of areas,,R20.2,63,17,
Disease and Injury,12/17/2004,Physical Symptoms,"Various pins and needles symptoms affecting hands, arms, thighs, head, scalp, buttocks, legs and feet",,R20.2,64,15,
Disease and Injury,12/17/2004,Physical Symptoms,"List of pins and needles symptoms including neck, scalp and shoulders",,R20.2,64,1,
Disease and Injury,7/20/2004,Diagnosis,Transverse myelitis 20% chance of conversion to clinically definite MS,Abnormal,G37.3,70,13,
Disease and Injury,6/7/2004,Diagnosis,Possible diagnosis of transverse myelitis,Inconclusive,G37.3,67,15,
Disease and Injury,5/31/2004,Physical Symptoms,3 day history or paraethesia of left C5-C8 level and right C-8,,R20.2,68,10,
Disease and Injury,5/7/2004,Diagnosis,Cortical fracture of proximal phalanx of right little finger,Injury,S62.6,73,18,
Disease and Injury,4/18/2003,Physical Symptoms,"Knee pain, joint stiffness and muscle weakness",,M25.5,74,12,
Disease and Injury,1/13/2003,Diagnosis,Sinusitis,Positive,J32.9,90,7,
Disease and Injury,7/17/2002,Diagnosis,Right knee pain from football injury,Injury,M25.5,75,14,
Disease and Injury,7/17/2002,Physical Symptoms,Slight decrease in muscle bulk in  right quadriceps,,,75,15,
Disease and Injury,7/12/2002,Diagnosis,Meniscus tear found in right knee,Injury,S83.2,93,7,
Disease and Injury,1/29/2001,Physical Symptoms,Tired all the time (TATT),,,92,23,
Disease and Injury,3/20/2001,Physical Symptoms,Sore throat and tonsil with pus,,J31.2,92,10,
Disease and Injury,9/9/1999,Diagnosis,Mild allergy to house dust mites,Positive,J30.4,118,18,
Disease and Injury,3/23/1998,Physical Symptoms,Sore ear,,H92.0,94,7,
Disease and Injury,12/4/1994,Diagnosis,Pharyngitis,Positive,J31.2,99,21,
Disease and Injury,8/4/1993,Physical Symptoms,Rash on chin and nostrils,,R21,99,19,
Disease and Injury,11/11/1983,Diagnosis,Diagnosed with flat feet,Abnormal,M21.4,83,12,
Diagnostic Tests & Procedures,11/26/2009,Microbiology,Throat  Swab,Throat swab and culture,,,4,13
Diagnostic Tests & Procedures,11/20/2009,Sleep,,Sleep nasendoscopy  showed palatal flutter and long uvula,Abnormal,R06.5,16,19
Diagnostic Tests & Procedures,9/21/2009,Sleep,Epworth Score,Epworth Score 2/24,Not sleepy,,18,20
Diagnostic Tests & Procedures,8/24/2009,BMI Measurement,,28 O/E,Overweight,,4,23
Diagnostic Tests & Procedures,6/24/2009,BP Measurement,,123/81 Sitting Right,Borderline,,4,18
Diagnostic Tests & Procedures,6/24/2009,BP Measurement,,123/81,Borderline,,38,7
Diagnostic Tests & Procedures,12/2/2008,BP Measurement,,150/87 Sitting,High, I10,4,18
Diagnostic Tests & Procedures,1/3/2008,Stool Examination,,Negative results for parasites and enteric pathogens,Negative,,13,6
Diagnostic Tests & Procedures,4/21/2005,Microbiology,Borrelia burgdorferi EIA,Negative for Lyme''s Disease,Negative,A69.2,116,19
Diagnostic Tests & Procedures,3/22/2005,Biochemistry,Blood,Potassium 4.3,Normal,,104,8
Diagnostic Tests & Procedures,3/22/2005,Biochemistry,Blood,Chloride 102,Normal,,104,9
Diagnostic Tests & Procedures,3/22/2005,Biochemistry,Blood,Creatinine 93,Normal,,104,10
Diagnostic Tests & Procedures,3/22/2005,Biochemistry,Blood,Albumin 47,Normal,,104,10
Diagnostic Tests & Procedures,3/22/2005,Biochemistry,Blood,Tot Bilirubin 11,Normal,,104,10
Diagnostic Tests & Procedures,3/22/2005,Biochemistry,Blood,Gamma Glut Trans 24,Normal,,104,11
Diagnostic Tests & Procedures,3/22/2005,Biochemistry,Blood,Glucose 5,Normal,,104,12
Diagnostic Tests & Procedures,3/22/2005,Biochemistry,Blood,Thryroid Stim Hormone 2.13,Normal,,104,12
Diagnostic Tests & Procedures,3/22/2005,Biochemistry,Blood,Haemolysis,Normal,,104,13
Diagnostic Tests & Procedures,3/22/2005,Biochemistry,Blood,Lipaemia,Normal,,104,13
Diagnostic Tests & Procedures,3/22/2005,Biochemistry,Blood,Sodium 140,Normal,,104,8
Diagnostic Tests & Procedures,3/22/2005,Biochemistry,Blood,HB 145,Normal,,104,16
Diagnostic Tests & Procedures,3/22/2005,Biochemistry,Blood,Urea 6.8,Normal,,104,9
Diagnostic Tests & Procedures,3/22/2005,Biochemistry,Blood,NCT 0.42,Normal,,104,17
Diagnostic Tests & Procedures,3/22/2005,Biochemistry,Blood,MCV 89,Normal,,104,18
Diagnostic Tests & Procedures,3/22/2005,Biochemistry,Blood,MCH 30,Normal,,104,18
Diagnostic Tests & Procedures,3/22/2005,Biochemistry,Blood,PLT 310,Normal,,104,18
Diagnostic Tests & Procedures,3/22/2005,Biochemistry,Blood,MPV 8.3,Normal,,104,19
Diagnostic Tests & Procedures,3/22/2005,Biochemistry,Blood,WBC 7,Normal,,104,19
Diagnostic Tests & Procedures,3/22/2005,Biochemistry,Blood,NEUT 3.6,Normal,,104,20
Diagnostic Tests & Procedures,3/22/2005,Biochemistry,Blood,BASO 0.06,Normal,,104,21
Diagnostic Tests & Procedures,3/22/2005,Biochemistry,Blood,LYMPH 2.6,Normal,,104,21
Diagnostic Tests & Procedures,3/22/2005,Biochemistry,Blood,MONO 0.5,Normal,,104,22
Diagnostic Tests & Procedures,3/22/2005,Biochemistry,Blood,LUC 0.19,Normal,,104,22
Diagnostic Tests & Procedures,3/22/2005,Biochemistry,Blood,Icteric,Normal,,104,13
Diagnostic Tests & Procedures,3/22/2005,Biochemistry,Blood,EOS 0.07 [Range 0.1 - 0.5],Out of Range,,105,21
Diagnostic Tests & Procedures,3/22/2005,Biochemistry,Blood,RBC 4.7 [Range 5.0 - 6.0],Out of Range,,104,17
Diagnostic Tests & Procedures,3/22/2005,Biochemistry,Blood,Alk Phosphatase 129 [Range 45 -105],Out of Range,,104,12
Diagnostic Tests & Procedures,3/22/2005,Biochemistry,Blood,Ala Amino Trans 52 [Range 1 - 40],Out of Range,,104,11
Diagnostic Tests & Procedures,3/22/2005,Biochemistry,Blood,ESR 2,Normal,,104,22
Diagnostic Tests & Procedures,3/22/2005,BP Measurement,,124/78,Borderline,,4,18
Diagnostic Tests & Procedures,3/22/2005,BP Measurement,,124/78,Borderline,,103,4
Diagnostic Tests & Procedures,3/7/2005,BP Measurement,,120/75,Normal,,51,17
Diagnostic Tests & Procedures,11/5/2004,Biochemistry,Blood,Serum ACE level was 57 against normal range of 0-52,Out of Range,,66,21
Diagnostic Tests & Procedures,11/5/2004,Diagnostic Test (Other),Lumbar Puncture,Normal lumbar puncture results,Normal,,66,20
Diagnostic Tests & Procedures,2/19/2001,Microbiology,Chlamydia DNA,Negative for Chlamydia,Negative,A55,117,20
Diagnostic Tests & Procedures,3/23/1998,BP Measurement,,120/76,Normal,,103,3
Diagnostic Tests & Procedures,9/18/1997,Biochemistry,Blood,MCHC 35.6 g/dl [Range 30.0 - 35.0],Out of Range,,113,24
Diagnostic Tests & Procedures,9/18/1997,Biochemistry,Blood,MCH 32.3 pg [Range 27.0 - 32.0],Out of Range,,113,23
Diagnostic Tests & Procedures,12/4/1994,BP Measurement,,130/64,Borderline,,99,21
Diagnostic Tests & Procedures,6/3/1988,Microbiology,Urethral Swab,Showed Trichomonas Vaginalis,Positive,A59.0,122,21
Diagnostic Tests & Procedures,6/3/1988,Microbiology,Urethral Swab,Showed Escherichia Coli,Positive,A49.8,123,20
Diagnostic Tests & Procedures,6/2/1988,Biochemistry,Urine,Showed pus cells. No growth in culture.,Abnormal,,124,21
Imaging,8/13/2009,Ultrasound,,Testes normal except for small 5mm spermatocele,Abnormal, N43.4,19,16
Imaging,8/7/2009,Ultrasound,,Ultra sound of testes done,,,4,5
Imaging,7/20/2004,MRI, ,Normal MRI brain scan,Normal,,70,12
Imaging,5/31/2004,MRI, ,High signal on T2 at the level of C5/6. This may indicate transverse myelitis,Abnormal,G37.3,68,15
Imaging,5/27/1982,X-Ray, ,Appearance of both heels normal,Normal,,85,16
Surgical Procedures,11/20/2009,Surgery,,UVPP Procedure Performed,,,16,19
Surgical Procedures,10/10/2005,Surgery,,Bilateral vasectomy performed,,,49,12
Surgical Procedures,10/1/2005,Surgery,,Underwent bilateral vasectomy for contraception purposes,,,4,6
Surgical Procedures,10/23/1997,Surgical Result,,"Tenderness at lower end of left leg, wasting of left medial gastronemious and tibialis",Abnormal,M62.5,96,23
Surgical Procedures,12/13/1996,Surgery,,Operation lower leg with periosteel release,,,96,22
Surgical Procedures,12/1/1996,Surgery,,Operation on left lower leg,,,2,25
Non-Surgical Procedures,7/17/2002,Physiotherapy,,Physiotherapy recommended for knee,,,75,17
Non-Surgical Procedures,11/11/1983,Physiotherapy,,Physiotherapy recommended for flat feet,,,83,11
Hospitalisations,11/20/2009,Hospital Admission,,Admitted to hospital for sleep nasendoscopy and UVPP,,,17,15
Hospitalisations,9/4/2007,Hospital Admission,,Re-do failed bilateral vasectomy,,,25,10
Hospitalisations,9/4/2007,Hospital Discharge,,Discharged for vasectomy without complications,,,26,16
Hospitalisations,10/10/2005,Hospital Admission,,Admitted as outpatient for outpatient vasectomy,,,49,10
 Drugs & Medications,1/21/2010,Adverse Reaction,,Allergic reaction to Ranitidine and Lansoprazole,, T88.7,9,5
 Drugs & Medications,1/21/2010,Drug Prescribed,,Gaviscon Advance oral susp 5ML or 10ml 4x day,,,10,4
 Drugs & Medications,1/15/2010,Drug Prescribed,,Ranitidine tabs 150mg 2x day,,,10,4
 Drugs & Medications,12/9/2009,Drug Prescribed,,Lansoprazole caps 15mg 1x day,,,10,4
 Drugs & Medications,11/26/2009,Drug Prescribed,,Co-Codamol tabs 30/500mg 4x day,,,10,5
 Drugs & Medications,11/26/2009,Drug Prescribed,,Co-Amoxiclav tabs 500/125mg 3x day,,,10,5
 Drugs & Medications,11/4/2009,Drug Prescribed,,Hydrocortisone 1%,,,10,5
 Drugs & Medications,10/2/2009,Drug Prescribed,,Voltarol Emulgel 1.15% 3x day,,,14,6
 Drugs & Medications,10/2/2009,Drug Prescribed,,Diclofenac Sodium tabs 50mg 3x day,,,14,10
 Drugs & Medications,6/19/2009,Drug Prescribed,,Lanzoprazole caps 15mg 1x,,,14,5
 Drugs & Medications,12/2/2008,Drug Prescribed,,Lanzoprazole caps 15mg 1x,,,14,8
 Drugs & Medications,6/3/2008,Drug Prescribed,,Lanzoprazole caps 15mg 1x,,,14,8
 Drugs & Medications,10/18/2005,Drug Prescribed,,6 Weeks Doxycyline,,,53,22
 Drugs & Medications,4/15/2005,Drug Prescribed,,Doxycycline 10mg 1x,,,88,11
 Drugs & Medications,7/20/2004,Injection,,Non-steroidal intra-muscular injection,,,69,24
 Drugs & Medications,6/7/2004,Drug Prescribed,,Course of Penicillin V 250mg prescribed,,,67,19
 Drugs & Medications,8/20/2001,Drug Prescribed,,Salbutamol 1od,,,92,21
 Drugs & Medications,6/9/1998,Drug Prescribed,,Prescribed Chloroquine,,,80,22';

   LINE_Arr2 := HTMLDB_UTIL.STRING_TO_TABLE (v_Data, CHR (10));
   HTP.p ('Case Id: ' || P_CASEID);
   HTP.p ('Line cnt: ' || LINE_arr2.COUNT);

   FOR J IN 1 .. LINE_arr2.COUNT
   LOOP
      NULL;
   -- DATA_Arr2(J),1,25))),
   END LOOP;
EXCEPTION
   WHEN OTHERS
   THEN
      LOG_APEX_ERROR (15);
END;