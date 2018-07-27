set define off
--------------------------------------------------------
--  DDL for Function PHARMA_DATAPOINT_COUNT
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SNX_IWS2"."PHARMA_DATAPOINT_COUNT" 
    (P_CASEID NUMBER default null)
    
    -- Created 11-1-2012 R Benzell
    -- Count of DataPoints for a Case that are Pharma related
    -- does not included ISDELETED (soft deletes) in counts
    
    -- to test:  select PHARMA_DATAPOINT_COUNT(2047) from dual;
    
    
        RETURN number
    
        IS
    
       v_Count number;
        BEGIN
--
return 0;
--
            
       
       BEGIN
         select count(*) into v_Count
          from DPENTRYPAGES_VIEW   
            where  CASEID = P_CASEID 
            AND ( ISDELETED = 'N' or ISDELETED IS NULL)
            AND Category = 'Drugs & Medications' ;
       EXCEPTION WHEN OTHERS THEN 
            v_Count := NULL;
       END;
 
         return v_Count;
       
      END;

/

