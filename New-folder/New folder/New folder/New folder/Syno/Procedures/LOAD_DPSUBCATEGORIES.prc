--------------------------------------------------------
--  DDL for Procedure LOAD_DPSUBCATEGORIES
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "SNX_IWS2"."LOAD_DPSUBCATEGORIES" 
  -- Program name - LOAD_DPSUBCATEGORIES
  -- Created 9-26-20 to manually load lookup table, assumes table is initially blank, and categories is populated
 -- Unix AWK script to retrieve value pairs from spreadsheet   
 --cat dp.txt|gawk "{print \"aaa \" $1 \" bbb \" $2 \" \" $3 \" \" $4 \" ccc\" }"  > dp4.txt
               
  
         IS
    
 
         BEGIN
    
insert into DPSUBCATEGORIES (DPCATEGORYID,DPSUBCATNAME) values ( 1 ,'Low');
insert into DPSUBCATEGORIES (DPCATEGORYID,DPSUBCATNAME) values ( 1 ,'Moderate');
insert into DPSUBCATEGORIES (DPCATEGORYID,DPSUBCATNAME) values ( 1 ,'High');
insert into DPSUBCATEGORIES (DPCATEGORYID,DPSUBCATNAME) values ( 1 ,'Low to High');
insert into DPSUBCATEGORIES (DPCATEGORYID,DPSUBCATNAME) values ( 1 ,'Low to Moderate');
insert into DPSUBCATEGORIES (DPCATEGORYID,DPSUBCATNAME) values ( 1 ,'Moderate to High');
insert into DPSUBCATEGORIES (DPCATEGORYID,DPSUBCATNAME) values ( 1 ,'None');
insert into DPSUBCATEGORIES (DPCATEGORYID,DPSUBCATNAME) values ( 1 ,'Unknown');
insert into DPSUBCATEGORIES (DPCATEGORYID,DPSUBCATNAME) values ( 2 ,'Male');
insert into DPSUBCATEGORIES (DPCATEGORYID,DPSUBCATNAME) values ( 2 ,'Female');
insert into DPSUBCATEGORIES (DPCATEGORYID,DPSUBCATNAME) values ( 2 ,'Unknown');
insert into DPSUBCATEGORIES (DPCATEGORYID,DPSUBCATNAME) values ( 3 ,'Height');
insert into DPSUBCATEGORIES (DPCATEGORYID,DPSUBCATNAME) values ( 4 ,'Smoker');
insert into DPSUBCATEGORIES (DPCATEGORYID,DPSUBCATNAME) values ( 4 ,'Non-Smoker');
insert into DPSUBCATEGORIES (DPCATEGORYID,DPSUBCATNAME) values ( 4 ,'Ex-Smoker');
insert into DPSUBCATEGORIES (DPCATEGORYID,DPSUBCATNAME) values ( 4 ,'Never Smoked');
insert into DPSUBCATEGORIES (DPCATEGORYID,DPSUBCATNAME) values ( 4 ,'Other Nicotine');
insert into DPSUBCATEGORIES (DPCATEGORYID,DPSUBCATNAME) values ( 4 ,'Variable');
insert into DPSUBCATEGORIES (DPCATEGORYID,DPSUBCATNAME) values ( 4 ,'Unknown');
insert into DPSUBCATEGORIES (DPCATEGORYID,DPSUBCATNAME) values ( 5 ,'None');
insert into DPSUBCATEGORIES (DPCATEGORYID,DPSUBCATNAME) values ( 5 ,'Amphetamines');
insert into DPSUBCATEGORIES (DPCATEGORYID,DPSUBCATNAME) values ( 5 ,'Barbiturates');
insert into DPSUBCATEGORIES (DPCATEGORYID,DPSUBCATNAME) values ( 5 ,'Cannabis');
insert into DPSUBCATEGORIES (DPCATEGORYID,DPSUBCATNAME) values ( 5 ,'Cocaine');
insert into DPSUBCATEGORIES (DPCATEGORYID,DPSUBCATNAME) values ( 5 ,'Hallucinogens');
insert into DPSUBCATEGORIES (DPCATEGORYID,DPSUBCATNAME) values ( 5 ,'Opiates');
insert into DPSUBCATEGORIES (DPCATEGORYID,DPSUBCATNAME) values ( 5 ,'Sedatives');
insert into DPSUBCATEGORIES (DPCATEGORYID,DPSUBCATNAME) values ( 5 ,'Solvents');
insert into DPSUBCATEGORIES (DPCATEGORYID,DPSUBCATNAME) values ( 5 ,'Other Substances');
insert into DPSUBCATEGORIES (DPCATEGORYID,DPSUBCATNAME) values ( 5 ,'Multiple');
insert into DPSUBCATEGORIES (DPCATEGORYID,DPSUBCATNAME) values ( 6 ,'None');
insert into DPSUBCATEGORIES (DPCATEGORYID,DPSUBCATNAME) values ( 6 ,'Yes');
insert into DPSUBCATEGORIES (DPCATEGORYID,DPSUBCATNAME) values ( 7 ,'Normal');
insert into DPSUBCATEGORIES (DPCATEGORYID,DPSUBCATNAME) values ( 7 ,'Overweight');
insert into DPSUBCATEGORIES (DPCATEGORYID,DPSUBCATNAME) values ( 7 ,'Underweight');
insert into DPSUBCATEGORIES (DPCATEGORYID,DPSUBCATNAME) values ( 7 ,'Obese');
insert into DPSUBCATEGORIES (DPCATEGORYID,DPSUBCATNAME) values ( 7 ,'Unknown');
insert into DPSUBCATEGORIES (DPCATEGORYID,DPSUBCATNAME) values ( 8 ,'Arthritis');
insert into DPSUBCATEGORIES (DPCATEGORYID,DPSUBCATNAME) values ( 8 ,'Asthma');
insert into DPSUBCATEGORIES (DPCATEGORYID,DPSUBCATNAME) values ( 8 ,'Cancer');
insert into DPSUBCATEGORIES (DPCATEGORYID,DPSUBCATNAME) values ( 8 ,'Cerebral Palsy');
insert into DPSUBCATEGORIES (DPCATEGORYID,DPSUBCATNAME) values ( 8 ,'CHD');
insert into DPSUBCATEGORIES (DPCATEGORYID,DPSUBCATNAME) values ( 8 ,'Congenital Anomalies');
insert into DPSUBCATEGORIES (DPCATEGORYID,DPSUBCATNAME) values ( 8 ,'Diabetes');
insert into DPSUBCATEGORIES (DPCATEGORYID,DPSUBCATNAME) values ( 8 ,'Hepatitis C');
insert into DPSUBCATEGORIES (DPCATEGORYID,DPSUBCATNAME) values ( 8 ,'Hypertension');
insert into DPSUBCATEGORIES (DPCATEGORYID,DPSUBCATNAME) values ( 8 ,'Mental Health');
insert into DPSUBCATEGORIES (DPCATEGORYID,DPSUBCATNAME) values ( 8 ,'Renal');
insert into DPSUBCATEGORIES (DPCATEGORYID,DPSUBCATNAME) values ( 8 ,'Scleroderma');
insert into DPSUBCATEGORIES (DPCATEGORYID,DPSUBCATNAME) values ( 8 ,'Stroke');
insert into DPSUBCATEGORIES (DPCATEGORYID,DPSUBCATNAME) values ( 8 ,'Other Registry');
insert into DPSUBCATEGORIES (DPCATEGORYID,DPSUBCATNAME) values ( 9 ,'Diagnosis');
insert into DPSUBCATEGORIES (DPCATEGORYID,DPSUBCATNAME) values ( 9 ,'Prelimin.Diagnosis');
insert into DPSUBCATEGORIES (DPCATEGORYID,DPSUBCATNAME) values ( 9 ,'Physical Symptoms');
insert into DPSUBCATEGORIES (DPCATEGORYID,DPSUBCATNAME) values ( 9 ,'Mental Symptoms');
insert into DPSUBCATEGORIES (DPCATEGORYID,DPSUBCATNAME) values ( 10 ,'Amniocentesis');
insert into DPSUBCATEGORIES (DPCATEGORYID,DPSUBCATNAME) values ( 10 ,'Blood Test');
insert into DPSUBCATEGORIES (DPCATEGORYID,DPSUBCATNAME) values ( 10 ,'Cerebrospinal Fluid');
insert into DPSUBCATEGORIES (DPCATEGORYID,DPSUBCATNAME) values ( 10 ,'Hair Analysis');
insert into DPSUBCATEGORIES (DPCATEGORYID,DPSUBCATNAME) values ( 10 ,'Occult Blood');
insert into DPSUBCATEGORIES (DPCATEGORYID,DPSUBCATNAME) values ( 10 ,'Other Biochemistry');
insert into DPSUBCATEGORIES (DPCATEGORYID,DPSUBCATNAME) values ( 10 ,'Other Fluid');
insert into DPSUBCATEGORIES (DPCATEGORYID,DPSUBCATNAME) values ( 10 ,'Paracentesis');
insert into DPSUBCATEGORIES (DPCATEGORYID,DPSUBCATNAME) values ( 10 ,'Sweat Test');
insert into DPSUBCATEGORIES (DPCATEGORYID,DPSUBCATNAME) values ( 10 ,'Thoracentesis');
insert into DPSUBCATEGORIES (DPCATEGORYID,DPSUBCATNAME) values ( 10 ,'Urine');
insert into DPSUBCATEGORIES (DPCATEGORYID,DPSUBCATNAME) values ( 11 ,'Bacteriology');
insert into DPSUBCATEGORIES (DPCATEGORYID,DPSUBCATNAME) values ( 11 ,'Chromosome Analysis');
insert into DPSUBCATEGORIES (DPCATEGORYID,DPSUBCATNAME) values ( 11 ,'Culture');
insert into DPSUBCATEGORIES (DPCATEGORYID,DPSUBCATNAME) values ( 11 ,'Cytology');
insert into DPSUBCATEGORIES (DPCATEGORYID,DPSUBCATNAME) values ( 11 ,'Fertility');
insert into DPSUBCATEGORIES (DPCATEGORYID,DPSUBCATNAME) values ( 11 ,'Other Microbiology');
insert into DPSUBCATEGORIES (DPCATEGORYID,DPSUBCATNAME) values ( 11 ,'Pap Smear');
insert into DPSUBCATEGORIES (DPCATEGORYID,DPSUBCATNAME) values ( 11 ,'Pathology');
insert into DPSUBCATEGORIES (DPCATEGORYID,DPSUBCATNAME) values ( 11 ,'Semen Analysis');
insert into DPSUBCATEGORIES (DPCATEGORYID,DPSUBCATNAME) values ( 11 ,'Stool Test');
insert into DPSUBCATEGORIES (DPCATEGORYID,DPSUBCATNAME) values ( 12 ,'Angiography');
insert into DPSUBCATEGORIES (DPCATEGORYID,DPSUBCATNAME) values ( 12 ,'Barium X-ray');
insert into DPSUBCATEGORIES (DPCATEGORYID,DPSUBCATNAME) values ( 12 ,'Cholangiography');
insert into DPSUBCATEGORIES (DPCATEGORYID,DPSUBCATNAME) values ( 12 ,'CT Scan');
insert into DPSUBCATEGORIES (DPCATEGORYID,DPSUBCATNAME) values ( 12 ,'Echo Cardiogram');
insert into DPSUBCATEGORIES (DPCATEGORYID,DPSUBCATNAME) values ( 12 ,'Fluroscopy');
insert into DPSUBCATEGORIES (DPCATEGORYID,DPSUBCATNAME) values ( 12 ,'Mammography');
insert into DPSUBCATEGORIES (DPCATEGORYID,DPSUBCATNAME) values ( 12 ,'MRI');
insert into DPSUBCATEGORIES (DPCATEGORYID,DPSUBCATNAME) values ( 12 ,'Myelography');
insert into DPSUBCATEGORIES (DPCATEGORYID,DPSUBCATNAME) values ( 12 ,'Other Imaging');
insert into DPSUBCATEGORIES (DPCATEGORYID,DPSUBCATNAME) values ( 12 ,'PET Scan');
insert into DPSUBCATEGORIES (DPCATEGORYID,DPSUBCATNAME) values ( 12 ,'Radiological');
insert into DPSUBCATEGORIES (DPCATEGORYID,DPSUBCATNAME) values ( 12 ,'Ultrasound');
insert into DPSUBCATEGORIES (DPCATEGORYID,DPSUBCATNAME) values ( 12 ,'Urography');
insert into DPSUBCATEGORIES (DPCATEGORYID,DPSUBCATNAME) values ( 12 ,'Venography');
insert into DPSUBCATEGORIES (DPCATEGORYID,DPSUBCATNAME) values ( 12 ,'X-ray');
insert into DPSUBCATEGORIES (DPCATEGORYID,DPSUBCATNAME) values ( 13 ,'Abdominal');
insert into DPSUBCATEGORIES (DPCATEGORYID,DPSUBCATNAME) values ( 13 ,'Cervix');
insert into DPSUBCATEGORIES (DPCATEGORYID,DPSUBCATNAME) values ( 13 ,'Chest');
insert into DPSUBCATEGORIES (DPCATEGORYID,DPSUBCATNAME) values ( 13 ,'Colon');
insert into DPSUBCATEGORIES (DPCATEGORYID,DPSUBCATNAME) values ( 13 ,'Joints');
insert into DPSUBCATEGORIES (DPCATEGORYID,DPSUBCATNAME) values ( 13 ,'Large Intestine');
insert into DPSUBCATEGORIES (DPCATEGORYID,DPSUBCATNAME) values ( 13 ,'Lungs & Pleura');
insert into DPSUBCATEGORIES (DPCATEGORYID,DPSUBCATNAME) values ( 13 ,'Mouth');
insert into DPSUBCATEGORIES (DPCATEGORYID,DPSUBCATNAME) values ( 13 ,'Nose');
insert into DPSUBCATEGORIES (DPCATEGORYID,DPSUBCATNAME) values ( 13 ,'Other Endoscopy');
insert into DPSUBCATEGORIES (DPCATEGORYID,DPSUBCATNAME) values ( 13 ,'Urethra');
insert into DPSUBCATEGORIES (DPCATEGORYID,DPSUBCATNAME) values ( 13 ,'Vagina');
insert into DPSUBCATEGORIES (DPCATEGORYID,DPSUBCATNAME) values ( 14 ,'Allergy');
insert into DPSUBCATEGORIES (DPCATEGORYID,DPSUBCATNAME) values ( 14 ,'Audiometry');
insert into DPSUBCATEGORIES (DPCATEGORYID,DPSUBCATNAME) values ( 14 ,'Blood Pressure');
insert into DPSUBCATEGORIES (DPCATEGORYID,DPSUBCATNAME) values ( 14 ,'BMI');
insert into DPSUBCATEGORIES (DPCATEGORYID,DPSUBCATNAME) values ( 14 ,'Cardiac Catheterization');
insert into DPSUBCATEGORIES (DPCATEGORYID,DPSUBCATNAME) values ( 14 ,'CVD Risk');
insert into DPSUBCATEGORIES (DPCATEGORYID,DPSUBCATNAME) values ( 14 ,'D&C Procedure');
insert into DPSUBCATEGORIES (DPCATEGORYID,DPSUBCATNAME) values ( 14 ,'ECG/EKG');
insert into DPSUBCATEGORIES (DPCATEGORYID,DPSUBCATNAME) values ( 14 ,'EEG');
insert into DPSUBCATEGORIES (DPCATEGORYID,DPSUBCATNAME) values ( 14 ,'Electromyography');
insert into DPSUBCATEGORIES (DPCATEGORYID,DPSUBCATNAME) values ( 14 ,'ERCP');
insert into DPSUBCATEGORIES (DPCATEGORYID,DPSUBCATNAME) values ( 14 ,'GERD Test');
insert into DPSUBCATEGORIES (DPCATEGORYID,DPSUBCATNAME) values ( 14 ,'Lung Function');
insert into DPSUBCATEGORIES (DPCATEGORYID,DPSUBCATNAME) values ( 14 ,'Memory Test');
insert into DPSUBCATEGORIES (DPCATEGORYID,DPSUBCATNAME) values ( 14 ,'MRC Breathless');
insert into DPSUBCATEGORIES (DPCATEGORYID,DPSUBCATNAME) values ( 14 ,'Other Test');
insert into DPSUBCATEGORIES (DPCATEGORYID,DPSUBCATNAME) values ( 14 ,'Neurological');
insert into DPSUBCATEGORIES (DPCATEGORYID,DPSUBCATNAME) values ( 14 ,'Ophthalmoscopy');
insert into DPSUBCATEGORIES (DPCATEGORYID,DPSUBCATNAME) values ( 14 ,'Reflex Text');
insert into DPSUBCATEGORIES (DPCATEGORYID,DPSUBCATNAME) values ( 14 ,'Sleep Study');
insert into DPSUBCATEGORIES (DPCATEGORYID,DPSUBCATNAME) values ( 14 ,'Stress Test');
insert into DPSUBCATEGORIES (DPCATEGORYID,DPSUBCATNAME) values ( 15 ,'Emergency');
insert into DPSUBCATEGORIES (DPCATEGORYID,DPSUBCATNAME) values ( 16 ,'Admitted');
insert into DPSUBCATEGORIES (DPCATEGORYID,DPSUBCATNAME) values ( 16 ,'Advised');
insert into DPSUBCATEGORIES (DPCATEGORYID,DPSUBCATNAME) values ( 16 ,'Discharged');
insert into DPSUBCATEGORIES (DPCATEGORYID,DPSUBCATNAME) values ( 17 ,'Physiotherapy');
insert into DPSUBCATEGORIES (DPCATEGORYID,DPSUBCATNAME) values ( 18 ,'Surgery');
insert into DPSUBCATEGORIES (DPCATEGORYID,DPSUBCATNAME) values ( 18 ,'Surgical Result');
insert into DPSUBCATEGORIES (DPCATEGORYID,DPSUBCATNAME) values ( 18 ,'Adverse Result');
insert into DPSUBCATEGORIES (DPCATEGORYID,DPSUBCATNAME) values ( 18 ,'Advised');
insert into DPSUBCATEGORIES (DPCATEGORYID,DPSUBCATNAME) values ( 18 ,'Complications');
insert into DPSUBCATEGORIES (DPCATEGORYID,DPSUBCATNAME) values ( 18 ,'Performed');
insert into DPSUBCATEGORIES (DPCATEGORYID,DPSUBCATNAME) values ( 18 ,'Scheduled');
insert into DPSUBCATEGORIES (DPCATEGORYID,DPSUBCATNAME) values ( 19 ,'Adverse Reaction');
insert into DPSUBCATEGORIES (DPCATEGORYID,DPSUBCATNAME) values ( 19 ,'Drug Prescribed');
insert into DPSUBCATEGORIES (DPCATEGORYID,DPSUBCATNAME) values ( 19 ,'Injection');
insert into DPSUBCATEGORIES (DPCATEGORYID,DPSUBCATNAME) values ( 19 ,'Administered');
insert into DPSUBCATEGORIES (DPCATEGORYID,DPSUBCATNAME) values ( 19 ,'Adverse Reaction');
insert into DPSUBCATEGORIES (DPCATEGORYID,DPSUBCATNAME) values ( 19 ,'Advised');
insert into DPSUBCATEGORIES (DPCATEGORYID,DPSUBCATNAME) values ( 19 ,'Prescribed');
insert into DPSUBCATEGORIES (DPCATEGORYID,DPSUBCATNAME) values ( 19 ,'Side Effects');
insert into DPSUBCATEGORIES (DPCATEGORYID,DPSUBCATNAME) values ( 19 ,'Stopped');
insert into DPSUBCATEGORIES (DPCATEGORYID,DPSUBCATNAME) values ( 19 ,'Taken');
insert into DPSUBCATEGORIES (DPCATEGORYID,DPSUBCATNAME) values ( 20 ,'Father');
insert into DPSUBCATEGORIES (DPCATEGORYID,DPSUBCATNAME) values ( 20 ,'Grandparent');
insert into DPSUBCATEGORIES (DPCATEGORYID,DPSUBCATNAME) values ( 20 ,'Mother');
insert into DPSUBCATEGORIES (DPCATEGORYID,DPSUBCATNAME) values ( 20 ,'Other Relative');
insert into DPSUBCATEGORIES (DPCATEGORYID,DPSUBCATNAME) values ( 20 ,'Parent');
insert into DPSUBCATEGORIES (DPCATEGORYID,DPSUBCATNAME) values ( 20 ,'Sibling');
insert into DPSUBCATEGORIES (DPCATEGORYID,DPSUBCATNAME) values ( 21 ,'Work');
insert into DPSUBCATEGORIES (DPCATEGORYID,DPSUBCATNAME) values ( 21 ,'Activity');
insert into DPSUBCATEGORIES (DPCATEGORYID,DPSUBCATNAME) values ( 21 ,'Mobility');
    
    
    
    
COMMIT;
             
       EXCEPTION WHEN OTHERS THEN LOG_APEX_ERROR();
             
       END;

/

