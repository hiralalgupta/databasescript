--------------------------------------------------------
--  DDL for Procedure LOAD_DP_LINE
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "SNX_IWS2"."LOAD_DP_LINE" 
  -- Program name - LOAD_DP_LINE
  -- Created 9-26-2011 R Benzell
  -- Called by various LOAD_CASE_xxx programs to process each DP line
  -- update history
  -- 9-27-2011 R benzell - modified to use Prod versions of spreadsheets  
           (
             P_CASEID in NUMBER default NULL,
             P_LINE in VARCHAR2,   
             P_RUN IN VARCHAR2   -- either LOAD or SHOW (for debugging)
           )   
               
  
         IS
 
 
        --v_data clob;
        J Integer;
        v_line varchar2(4000);
        v_LineType varchar2(50);
        v_Cat varchar2(50);
        v_CatOrg varchar2(50);
        v_SubCatName varchar2(2000);
        v_dataentry varchar2(4000);
        v_datadate date;
        v_status varchar2(2000);
        v_icd10 varchar2(50);
        v_page varchar2(50);
        v_section varchar2(50);  
        v_CategoryId number;
        v_SubCategoryId number;
        v_DPFORMENTITYID number;
        v_DPENTRYID number;
        v_PageID number;
     --- Array to Hold Lines
         LINE_Arr2 HTMLDB_APPLICATION_GLOBAL.VC_ARR2;
         t_DPENTRIES  DPENTRIES%rowtype;
         t_DPENTRYCODES  DPENTRYCODES%rowtype;
         BEGIN
 /**Parse the line into separate elements.  Sample line formats are
Background Data,9/1/2011,Full Name,,Patient 555,,,,
General Health,9/21/2009,Alcohol Use,Low Alcohol,Drinks small amount of alcohol,,18,19,
Disease and Injury,1/21/2010,Diagnosis,Suffers from gastro-oesophageal reflux disease or GORD,Positive,K21,9,5,
Diagnostic Tests & Procedures,6/2/1988,Biochemistry,Urine,Showed pus cells. No growth in culture.,Abnormal,,124,21
Imaging,8/13/2009,Ultrasound,,Testes normal except for small 5mm spermatocele,Abnormal, N43.4,19,16
Surgical Procedures,12/1/1996,Surgery,,Operation on left lower leg,,,2,25
Non-Surgical Procedures,7/17/2002,Physiotherapy,,Physiotherapy recommended for knee,,,75,17
Hospitalisations,10/10/2005,Hospital Admission,,Admitted as outpatient for outpatient vasectomy,,,49,10
 Drugs & Medications,1/21/2010,Adverse Reaction,,Allergic reaction to Ranitidine and Lansoprazole,, T88.7,9,5
**/
 
 --- Pad line with additional delimiters at end to avoid null element parsing errors
   v_Line := P_LINE || '|||||||';  
 
             
             
 --- parse line based on commas
htp.p('----------------------------------------------------------------------------------');
        
LINE_Arr2 := HTMLDB_UTIL.STRING_TO_TABLE(v_LINE,'|');  -- pipe is delim
    v_LineType := LINE_arr2(1);
            v_Cat := LINE_arr2(1);
            v_datadate := to_date(LINE_arr2(2),'MM/DD/YYYY');    
            v_SubCatName := LINE_arr2(3);
            v_dataentry := LINE_arr2(4);
            v_status := LINE_arr2(5);
            v_page := LINE_arr2(6);
            v_section := LINE_arr2(7);
            v_icd10 := LINE_arr2(8);
            
            
      /**************  
       CASE   
         -- In some cases the category is in column1, others, column3
        WHEN  v_LineType = 'Diagnostic Tests & Procedures' OR
              v_LineType = 'Surgical Procedures' OR
              v_LineType = 'Non-Surgical Procedures' OR
              v_LineType = 'Imaging' OR
              v_LineType = 'Diagnostic Tests & Procedures' 
         THEN
            v_datadate := to_date(LINE_arr2(2),'MM/DD/YYYY');    
            v_Cat := LINE_arr2(3);
            v_SubCatName := LINE_arr2(4);
            v_dataentry := LINE_arr2(5);
            v_status := LINE_arr2(6);
            v_icd10 := LINE_arr2(7);
            v_page := LINE_arr2(8);
            v_section := LINE_arr2(9);
        
        
        
       -- In some cases the category is in column1, others, column3
        WHEN  v_LineType = 'Drugs & Medications' 
         THEN
            --htp.p('DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD');
            v_Cat := LINE_arr2(1);
            v_datadate := to_date(LINE_arr2(2),'MM/DD/YYYY');    
            v_SubCatName := LINE_arr2(3);
            v_dataentry := LINE_arr2(5);
            --v_status := LINE_arr2(6);
            v_icd10 := LINE_arr2(7);
            v_page := LINE_arr2(8);
            v_section := LINE_arr2(9);       
        
        
        
        
        ELSE
            v_Cat := LINE_arr2(1);  
            v_datadate := to_date(LINE_arr2(2),'MM/DD/YYYY');
            v_SubCatName := LINE_arr2(3);
            v_dataentry := LINE_arr2(4);
            v_status := LINE_arr2(5);
            v_icd10 := LINE_arr2(6);
            v_page := LINE_arr2(7);
            v_section := LINE_arr2(8);
       END CASE;
      ******/
    v_CatOrg := v_Cat;    
   --- Massage name in some cases because of Human entry inconsistencies
      CASE     
         when v_Cat = 'BP Measurement' then v_Cat := 'Other';
         when v_Cat = 'Sleep' then v_Cat := 'Other';
         when v_Cat = 'Surgical Procedures' then v_Cat := 'Surgical';
         when v_Cat = 'Non-Surgical Procedures' then v_cat := 'Non_Surgical';
         when v_Cat = 'Hospitalisations' then v_Cat := 'Hospitalisation';
         when v_Cat = 'Alcohol Use' then v_Cat := 'Alcohol';
         when v_Cat = 'BMI Measurement' then v_Cat := 'Other';
         when v_Cat = 'Stool Examination' then v_Cat := 'Other';
         when v_Cat = 'Substance Use' then v_Cat := 'Substances';
         when v_Cat = 'Weight' then v_Cat := 'Weight/BMI';
         --when v_Cat = '' then v_Cat := '';
         --when v_Cat = '' then v_Cat := '';
         --when v_Cat = '' then v_Cat := '';
         else null;
        END CASE;
    
    --- Show our matches so far
        v_CategoryId := LOOKUP_DP_CATEGORY(v_Cat);
        htp.p( v_LineType || ': ' || v_CategoryId  || ' - ' || v_Cat  || ' (' || v_CatOrg || ')' );
       
     --- Now, perform the SubCat lookup
       --v_subCatName := 
       v_SubCategoryId := LOOKUP_DP_SUBCATEGORY(v_Subcatname,v_CategoryId);
       htp.p( v_SubCategoryId || ' - ' || v_Subcatname);
     --- Determine the DPENTITY form value based on the Cat and Sub Cat
        
       IF v_SubCategoryId IS NOT NULL and v_CategoryId IS NOT NULL
          then  
            Select DPFORMENTITYID into v_DPFORMENTITYID 
              from DPFORMENTITIES
              where  DPSUBCATID = v_SubCategoryId 
                 and DPCATEGORYID = v_CategoryId;
       END IF;
   -- Populate null dates, pages and sections with default values
    v_datadate := nvl(v_datadate,to_date('01/01/1900','MM/DD/YYYY'));
    v_section := nvl(v_section,0);
    v_page := nvl(v_page,0);
 IF P_RUN = 'LOAD' then
    --- Create a new PAGE if not already present
        --- First, check if the CASEID already exists
      BEGIN
      select PAGEID into v_PageID
          from PAGES
          where CASEID = P_CASEID 
              and ORIGINALPAGENUMBER = v_page;
      EXCEPTION WHEN OTHERS THEN
          --- create new pageId and capture the info 
          BEGIN
            Insert into PAGES
             (CASEID ,   
              ORIGINALPAGENUMBER ,  
              DOCUMENTTYPEID,    
              DOCUMENTDATE,
             CREATED_TIMESTAMP)
              values
             (P_CASEID,
              v_page,
              1,
              v_datadate,
                 systimestamp);
               
            SELECT SNX_APEX_DEV.PAGES_SEQ.currval INTO v_pageId FROM dual;
            COMMIT; 
            htp.p('Created PageId ' || v_pageId || ' for page ' || v_page);
                 
           END;
      END;
                  
     
    IF v_DPFORMENTITYID is NOT NULL then
      --- Now - populate the Case DP entry
      INSERT INTO DPENTRIES
        (PAGEID ,   
         SECTIONNUMBER ,   
         DPFORMENTITYID,  
         ENTRYTRANSCRIPTION ,   
         DATADATE ,   
         STATUS,   
         CREATED_TIMESTAMP
        )  
       values
         ( v_pageId ,
           v_section,
           v_DPFORMENTITYID, 
           v_dataentry,
           v_datadate, 
           v_status,
           systimestamp  
         );   
       
       SELECT SNX_APEX_DEV.DPENTRIES_SEQ.currval INTO v_DPENTRYID FROM dual;
       
       COMMIT;
      --- Store the ICD-10 code as well if present
      if v_ICD10 is not null then
         Insert into DPENTRYCODES
          (DPENTRYID,  
           CODE,    
           CODETYPE,   
           --ISHIDDEN,    
           --CONFIDENCE,   
           --STATUS,
           CREATED_TIMESTAMP)
          values
           (v_DPENTRYID,
            v_icd10,
            'ICD10',
            systimestamp
           );
         COMMIT;
       END IF;
--v_icd10 := LINE_arr2(6);
      END IF;
ELSE
    null;  --htp.p('show only');   
END IF;  --- SHOW or LOAD
    htp.p( 'DPFORMENTITYID: '||   v_DPFORMENTITYID || '<<<');
    htp.p( 'CategoryId: '||   v_CategoryId || '<<<');
    htp.p( 'SubCategoryId: '||  v_SubCategoryId || '<<<');
    htp.p( 'date: '||   v_datadate || '<<<');
    htp.p( 'text: '||      v_dataentry  || '<<<');
    htp.p( 'status: '||       v_status || '<<<');
    htp.p( 'icd10: '||      v_icd10|| '<<<');
    htp.p( 'page: '||       v_page|| '<<<');
    htp.p( 'pageId: '||       v_pageId|| '<<<');
    htp.p( 'section: '|| v_section || '<<<');
       htp.p('');
             
       EXCEPTION WHEN OTHERS THEN 
         BEGIN  
          LOG_APEX_ERROR(P_ACTIONID =>15,
            P_CONTENT => ' ERROR on - ' ||
                         v_line || '
' ||  
                         'date: '||   v_datadate || 
                         'text: '||      v_dataentry  || 
                         'status: '||       v_status || 
                         'icd10: '||      v_icd10|| 
                         'page: '||       v_page|| 
                         'section: '|| v_section,
            P_HANDLE => 'SHOW') ;
         END;
             
       END;

/

