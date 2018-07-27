--------------------------------------------------------
--  DDL for Function CODE_COUNT
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SNX_IWS2"."CODE_COUNT" 
    (P_CASEID NUMBER default null,
     P_CODETYPE VARCHAR2 default 'ICD10')
    
    -- Created 12-1-2011 R Benzell
    -- Used by Finance/billing reports to provide count of Code Entries  for a particular case.
    -- or a particular codetype, typically ICD10
    
    -- to test:  select CODE_COUNT(1800) from dual;
    
    
        RETURN number
    
        IS
    
       v_Count number;
        BEGIN
            
       
       BEGIN
         select count(*) into v_Count
          from DPENTRYCODES_VIEW
            where  CASEID = P_CASEID 
               AND CODETYPE = P_CODETYPE
            AND (CODE_STATUS <> 'rejected');  -- or CODE_STATUS IS NULL);
       EXCEPTION WHEN OTHERS THEN 
            v_Count := NULL;
       END;
 
         return v_Count;
       
      END;

/

