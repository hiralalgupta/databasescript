--------------------------------------------------------
--  DDL for Procedure CREATE_TEST_CASE
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "SNX_IWS2"."CREATE_TEST_CASE" 
  -- Program name - LOAD_CASE_555
  -- Created 9-26-2011 R Benzell
  -- run manually, replacing the CSV or CASEID with cut and paste
  --
/** to test    
begin
  LOAD_CASE_555(123,'SHOW');
end;
***/
    
           (
             P_CASEID in NUMBER default 123,
             P_PAGEID out NUMBER,  
             P_RUN IN VARCHAR2 default 'SHOW'   --LOAD
           )   
               
  
         IS
 
 
        J Integer;
        v_CaseCnt integer;
               
         BEGIN
        --- First, check if the CASEID already exists
             select count(*) into v_CaseCnt
              from CASES 
               where CASEID = P_CASEID;
          IF v_CaseCnt = 0 
              then Htp.p('ERROR - CASEID ' || P_CASEID || ' does not exist');
          END IF;
                
             
       EXCEPTION WHEN OTHERS THEN LOG_APEX_ERROR(15);
             
       END;

/

