--------------------------------------------------------
--  DDL for Procedure LOAD_DIAG_DATAPOINTS
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "SNX_IWS2"."LOAD_DIAG_DATAPOINTS" 
  -- Program name - LOAD_DIAG_DATAPOINTS
  -- Created 11-18-2011 R Benzell
  -- Loads all the diagnosois Datapoints, cut and pasted from the Manual Process Spreadsheet
  -- Used to prepare data for BB Step 3 processing
  -- Normally called by Screen 126, after a Case was created by Screen 127
  --
/** to test    
begin
  LOAD_DIAG_DATAPOINTS(1830,'SHOW',
'11-May-2009    Diagnosis    Seasonal allergies    Positive    110    4    J30.2
11-May-2009    Diagnosis    Hypertension     Positive    110    4    I10
11-May-2009    Diagnosis    Crohn's disease since 50 years (interp)    Positive    110    6    K50.10'

  );
end;
***/
    
           (
             P_CASEID in NUMBER default 1534,
             P_RUN IN VARCHAR2 default 'SHOW',   --LOAD
             P_DATA IN VARCHAR2
           )   
               
  
         IS
 
 
        v_data clob;
        J Integer;
               
     --- Array to Hold Lines
         LINE_Arr2 HTMLDB_APPLICATION_GLOBAL.VC_ARR2;
         BEGIN
             --- Parse the line into separate elements
             
         v_data := replace(P_Data,chr(9),'|');

-- Data should look like: 
-- '11-May-2009|Diagnosis|Seasonal allergies|Positive|110|4|J30.2
-- 11-May-2009|Diagnosis|Hypertension |Positive|110|4|I10
             
    
 --- Parse line based on LF character
   LINE_Arr2 := HTMLDB_UTIL.STRING_TO_TABLE(v_Data,chr(10));
   htp.p('Case Id: ' || P_CASEID);
   htp.p('Line cnt: ' || LINE_arr2.count);
      for J in 1..LINE_arr2.count
                  LOOP
                    null;
                    -- DATA_Arr2(J),1,25))),
                     LOAD_DIAG_DP_LINE(P_CASEID,ltrim(LINE_arr2(J)),P_RUN);
                  END LOOP;   
             
       EXCEPTION WHEN OTHERS THEN LOG_APEX_ERROR(15);
             
       END;

/

