--------------------------------------------------------
--  DDL for Procedure LOAD_DP_LINE_V2
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "SNX_IWS2"."LOAD_DP_LINE_V2" 
  -- Program name - LOAD_DP_LINE_V1
  -- Created 9-26-2011 R Benzell
  -- Called by various LOAD_CASE_xxx programs to process each DP line
  --
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

         v_Delim varchar2(1) default '|';  --chr(9);    -- "tab" is delim


         BEGIN
 /**Parse the line into separate elements.  Sample line formats are
11-May-2009    Diagnosis    Seasonal allergies    Positive    110    4    J30.2
11-May-2009    Diagnosis    Hypertension     Positive    110    4    I10
11-May-2009    Diagnosis    Crohn's disease since 50 years (interp)    Positive    110    6    K50.10
13-Apr-2009    Diagnosis    Chronic obstructive pulmonary disease (COPD) with persistent dyspnea     Positive    107    17    J44.9
             
Background Data,9/1/2011,Full Name,,Patient 555,,,,
General Health,9/21/2009,Alcohol Use,Low Alcohol,Drinks small amount of alcohol,,18,19,
Disease and Injury,1/21/2010,Diagnosis,Suffers from gastro-oesophageal reflux disease or GORD,Positive,K21,9,5,

**/
 
 --- Pad line with additional delimiters at end to avoid null element parsing errors
   v_Line := P_LINE || '|||||||';  
 
             
             
 --- parse line based on commas
htp.p('----------------------------------------------------------------------------------');
--         11-May-2009    Diagnosis    Seasonal allergies    Positive    110    4    J30.2
        
         LINE_Arr2 := HTMLDB_UTIL.STRING_TO_TABLE(v_LINE,v_Delim);
        -- v_LineType := LINE_arr2(1);

            htp.p('1>>'||LINE_arr2(1)||'<<');
            htp.p('2>>'||LINE_arr2(2)||'<<');
            htp.p('3>>'||LINE_arr2(3)||'<<');
            htp.p('4>>'||LINE_arr2(4)||'<<');
            htp.p('5>>'||LINE_arr2(5)||'<<');
            htp.p('6>>'||LINE_arr2(6)||'<<');
            htp.p('7>>'||LINE_arr2(7)||'<<');


            v_datadate := to_date(trim(LINE_arr2(1)),'DD-MON-YYYY');    
            --v_Cat := LINE_arr2(2);
            v_SubCatName := LINE_arr2(2);
            v_dataentry := LINE_arr2(3);
            v_status := LINE_arr2(4);
            v_page := LINE_arr2(5);
            v_section := LINE_arr2(6);
            v_icd10 := LINE_arr2(7);
        
        

    
    --- Show our matches so far
        v_Cat := 'Disease and Injury';
        v_CatOrg := 'Disease and Injury';
        v_CategoryId := LOOKUP_DP_CATEGORY(v_Cat);  
         htp.p( 'Category: ' || v_CategoryId  || ' - ' || v_Cat);  --  || ' (' || v_CatOrg || ')' );
       
     --- Now, perform the SubCat lookup
       --v_subCatName := 'Diagnosis'
       v_SubCategoryId := LOOKUP_DP_SUBCATEGORY(v_Subcatname,v_CategoryId);
       htp.p( 'SubCat: ' || v_SubCategoryId || ' - ' || v_Subcatname);
     --- Determine the DPENTITY form value based on the Cat and Sub Cat
        
       IF v_SubCategoryId IS NOT NULL and v_CategoryId IS NOT NULL
          then  
            Select DPFORMENTITYID into v_DPFORMENTITYID 
              from DPFORMENTITIES
              where  DPSUBCATID = v_SubCategoryId 
                 and DPCATEGORYID = v_CategoryId;
       END IF;
      htp.p( 'DPFORMENTITY Id: ' || v_DPFORMENTITYID) ;


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
               
            SELECT SNX_IWS.PAGES_SEQ.currval INTO v_pageId FROM dual;
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
       
       SELECT SNX_IWS.DPENTRIES_SEQ.currval INTO v_DPENTRYID FROM dual;
     htp.p('Inserted DPEntries: ' || v_DPENTRYID );
       
      COMMIT;

       END IF;
--v_icd10 := LINE_arr2(6);
      END IF;

    COMMIT;

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

