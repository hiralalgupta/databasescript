--------------------------------------------------------
--  DDL for Procedure LOAD_CASE_1
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "SNX_IWS2"."LOAD_CASE_1" 
  -- Program name - LOAD_CASE_555
  -- Created 11-18-2011 R Benzell
  -- run manually, replacing the CSV or CASEID with cut and paste
  --
/** to test    
begin
  LOAD_CASE_1(1534,'SHOW');
end;
***/
    
           (
             P_CASEID in NUMBER default 1534,
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
'11-May-2009|Diagnosis|Seasonal allergies|Positive|110|4|J30.2
11-May-2009|Diagnosis|Hypertension |Positive|110|4|I10
11-May-2009|Diagnosis|Crohn''s disease since 50 years (interp)|Positive|110|6|K50.10
13-Apr-2009|Diagnosis|Chronic obstructive pulmonary disease (COPD) with persistent dyspnea |Positive|107|17|J44.9
13-Apr-2009|Diagnosis|Mild focal upper lobe predominant emphysema with few tiny nodules revealed in chest CT scan|Positive|107|15|J43.9
8-Jan-2009|Diagnosis|Osteopenia|Positive|102|16|M85.8
22-Dec-2008|Diagnosis|History of Graves disease in 1985|Positive|100|3|E050
22-Dec-2008|Diagnosis|History of Crohn''s disease status post ileal resection in March 2005|Positive|100|3|K50.10
22-Dec-2008|Diagnosis|History of inflammatory bowel disease related arthritis versus rheumatoid arthritis|Positive|100|4|M13
22-Dec-2008|Diagnosis|Asthma|Positive|100|6|J45.909
22-Dec-2008|Diagnosis|Vitreous detachment |Positive|100|7|H43.89
22-Dec-2008|Diagnosis|Allergic to shell fish and down feathers |Positive|100|10| J30.89
22-Dec-2008|Diagnosis|Shingles diagnosed on 28-Dec-07|Positive|100|28|B02.9
22-Dec-2008|Physical Symptoms|Shortness of breath (SOB) currently better with exercise||100|25|R06.02
28-Oct-2008|Physical Symptoms|Got flashy lights in right visual field, then had black lines for a few hours||91|6|
28-Oct-2008|Physical Symptoms|Vomiting, diarrhea and headache ||91|9|K59.1; R11.10; R51
28-Oct-2008|Diagnosis|History of inflammatory bowel disease related arthritis, now stable|Positive|91|25|M13
28-Oct-2008|Diagnosis|History of hypertension|Positive|91|26|I10
28-Oct-2008|Diagnosis|Asthma with recent fatigue |Positive|91|26|J45.909
28-Oct-2008|Diagnosis|Headache possibly migraine|Suspicious|91|26|G43.909
28-Oct-2008|Physical Symptoms|Lost 20 lbs in January due to diet and exercise then gained weight in August||91|3|
6-Oct-2008|Diagnosis|Stable COPD|Positive|88|16|J44.9
6-Oct-2008|Diagnosis|Allergic rhinitis|Positive|88|16|J30.9
28-Jun-2008|Diagnosis|History of bilateral cerumen impaction|Positive|87|11|H61.0
28-Jun-2008|Diagnosis|History of positional vertigo|Positive|87|12|H81
28-Jun-2008|Diagnosis|History of positive TB test|Positive|87|14|A15
28-Jun-2008|Diagnosis|Sensorineural hearing loss, wears hearing aids|Positive|87|12|H90.3
28-Jun-2008|Diagnosis|History of hay fever|Positive|87|14|J11.1
28-Jun-2008|Diagnosis|History of intestinal polyps|Positive|87|14|K63.5
28-Jun-2008|Physical Symptoms|History of sinus trouble||87|14|
29-Apr-2008|Diagnosis|De Quervain''s disease of right wrist with pain and swelling |Positive|86|10|M65.4
29-Apr-2008|Diagnosis|History of rheumatoid arthritis, treated with Humira for one and half years|Positive|86|13|M06.9
29-Apr-2008|Diagnosis|History of hypertension|Positive|86|14|I10
29-Apr-2008|Diagnosis|History of asthma|Positive|86|14|J45.909
9-Apr-2008|Diagnosis|Moderate obstructive airways dysfunction|Positive|85|25|J43.9
9-Apr-2008|Diagnosis|Allergic rhinitis, COPD or asthma|Positive|84|17|J30.9; J44.9; J45.909
9-Apr-2008|Physical Symptoms|Nasal congestion with clear nasal discharge and productive cough, some relief from over the counter antihistamines ||84|13|J11.1; R05
21-Feb-2008|Diagnosis|Lentigines and seborrheic keratosis on face, chest and back|Positive|79|13|L81.4
21-Feb-2008|Diagnosis|Xerotic eczema patches in the arms and legs|Positive|79|14|L30.9
21-Feb-2008|Diagnosis|Mild elevated blood pressure|Positive|80|25|I10
21-Feb-2008|Physical Symptoms|Exertional dyspnea||78|7|R06.00
21-Feb-2008|Physical Symptoms|Vertigo probably due to calcium deposition in the middle ear||80|25|H81
21-Feb-2008|Physical Symptoms|Dizziness with some abdominal symptom a week ago, had some vertigo in the past||80|9|R42; R19
28-Dec-2007|Diagnosis|History of severe arthralgias improved by Humira|Positive|73|4|M25.50
28-Dec-2007|Diagnosis|History of Graves disease in 1985|Positive|73|10|E05.0
28-Dec-2007|Diagnosis|Asthma stable, using inhaler |Positive|73|27|J45.909
28-Dec-2007|Diagnosis|Hypertension |Positive|74|1|I10
28-Dec-2007|Diagnosis|Crohn''s disease stable|Positive|74|1|K50.10
28-Dec-2007|Physical Symptoms|Fine tremors that resolved ||73|7|R25.1
31-Oct-2007|Diagnosis|COPD with history of bronchospasm|Positive|67|17|J44.9
31-Oct-2007|Physical Symptoms|Increased dyspnea on exertion, etiology uncertain||67|17|R06.00
31-Oct-2007|Physical Symptoms|Increased wheezing||67|13|
9-Aug-2007|Diagnosis|Recent diagnosis of rheumatoid arthritis|Positive|66|8|M06.9
9-Aug-2007|Diagnosis|Arthritis due to rheumatoid arthritis or secondary to inflammatory bowel disease|Positive|66|24|M06.9
9-Aug-2007|Diagnosis|Hypertension |Positive|66|25|I10
9-Aug-2007|Diagnosis|Asthma currently in control|Positive|66|26|J45.909
30-Jul-2007|Diagnosis|History of Grave''s disease which is in remission|Positive|65|9|E05.0
30-Jul-2007|Diagnosis|Rosacea|Positive|64|6|L71
30-Jul-2007|Diagnosis|Shortness of breath, COPD as well as asthma |Positive|64|8|J45.909; J44.9
30-Jul-2007|Diagnosis|Severe measles leading to left hearing loss in childhood and scarlet fever |Positive|64|13|A38
30-Jul-2007|Diagnosis|Diagnosed with colitis at the age of 20 |Positive|63|14|K50.10
30-Jul-2007|Diagnosis|Osteopenia, some narrowing of the navicular multiangular joint on the left|Positive|51|11|M85.8
30-Jul-2007|Physical Symptoms|Occasional pain in right hand||64|3|M79.641
30-Jul-2007|Physical Symptoms|Mild dryness of the mouth ||64|5|R68.2
30-Jul-2007|Physical Symptoms|Hearing was diminished||51|4|
5-Jul-2007|Diagnosis|Increased allergy symptoms two months ago when she resumed Allegra and Singulair|Positive|58|12|
5-Jul-2007|Diagnosis|COPD with bronchospasm|Positive|58|16|J44.9
8-Jun-2007|Physical Symptoms|Had some redness on right leg few days ago||54|10|
16-Apr-2007|Diagnosis|Arthritis is controlled|Positive|50|14|M06.9
16-Apr-2007|Diagnosis|PPD test was positive but CT scan showed no evidence of current or old tuberculosis|Positive|49|8|
16-Apr-2007|Physical Symptoms|Fever, dizziness , malaise as well as upper respiratory symptoms on starting INH therapy||50|8|R42; R19
5-Apr-2007|Diagnosis|Positive PPD without evidence of active TB or prior active infection, stable nodules consistent with granulomas or scars, COPD or asthma stable|Positive|44|17|
3-Apr-2007|Diagnosis|Developed mildly elevated liver function test, then developed viral type of syndrome last week|Positive|42|8|
28-Mar-2007|Diagnosis|Viral upper respiratory infection,  possibly influenza|Inconclusive|40|12|J06.9
8-Mar-2007|Physical Symptoms|Slight pain and swelling of the right fifth proximal interphalangeal joint||37|11|
1-Dec-2006|Physical Symptoms|Pain on the dorsum of the hand and MCP joint||69|13|
22-Nov-2006|Diagnosis|Pain in the front of right ear, right temporomandibular joint (TMJ) syndrome |Positive|31|18|K07.6
22-Sep-2006|Diagnosis|Increased allergic rhinitis related to ragweed|Positive|29|12|J30.9
24-Aug-2006|Diagnosis|Fine tremors may be due to thyroid dysfunction|Positive|28|19|R25.1
18-Jul-2006|Diagnosis|Recurrence of arthritis |Positive|25|10|M06.9
5-Jul-2006|Diagnosis|De Quervain''s disease of right wrist  treated in 2003 |Positive|23|15|M65.4
10-Feb-2006|Diagnosis|Upper respiratory infection |Positive|19|10|J06.9
28-Dec-2005|Physical Symptoms|Severe fatigue without localizing symptoms||15|25|
22-Jul-2005|Diagnosis|Hand arthritis|Positive|4|10|M13
22-Jul-2005|Diagnosis|Iritis diagnosed in 1980 and again in 1999|Positive|4|11|M20.0
22-Jul-2005|Diagnosis|Colitis diagnosed in 2003|Positive|4|12|K50.10
22-Jul-2005|Diagnosis|Crohn''s disease in terminal ileum|Positive|4|13|K50.10
22-Jul-2005|Physical Symptoms|Intermittent abdominal pain, cramps and diarrhea since age of 20||4|11|R10.0; K59.1';
             
             
    
 --- Parse line based on LF character
   LINE_Arr2 := HTMLDB_UTIL.STRING_TO_TABLE(v_Data,chr(10));
   htp.p('Case Id: ' || P_CASEID);
   htp.p('Line cnt: ' || LINE_arr2.count);
      for J in 1..LINE_arr2.count
                  LOOP
                    null;
                    -- DATA_Arr2(J),1,25))),
                     LOAD_DP_LINE_V2(P_CASEID,ltrim(LINE_arr2(J)),P_RUN);
                  END LOOP;   
             
       EXCEPTION WHEN OTHERS THEN LOG_APEX_ERROR(15);
             
       END;

/

