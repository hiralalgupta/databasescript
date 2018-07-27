--------------------------------------------------------
--  DDL for Function ICDCODE_COUNT
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SNX_IWS2"."ICDCODE_COUNT" 
    (P_CASEID NUMBER default null)
    
    -- Created 12-16-2011 R Benzell
    -- Used by Finance/billing reports and Screen 12to provide count of ICDcodes for a particular case.
    -- does not included ISDELETED (soft deletes) in counts
    
    -- to test:  select DATAPOINT_COUNT(1800) from dual;
    
    
        RETURN number
    
        IS
    
       v_Count number;
        BEGIN
            
       
       BEGIN
         select count(*) into v_Count
          from DPENTRYCODES_VIEW 
            where  CASEID = P_CASEID; 
            --AND ( ISDELETED = 'N' or ISDELETED IS NULL);
       EXCEPTION WHEN OTHERS THEN 
            v_Count := NULL;
       END;
 
         return v_Count;
       
      END;

/

