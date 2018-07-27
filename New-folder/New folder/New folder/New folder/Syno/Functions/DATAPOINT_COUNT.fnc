--------------------------------------------------------
--  DDL for Function DATAPOINT_COUNT
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SNX_IWS2"."DATAPOINT_COUNT" 
    (P_CASEID NUMBER default null)
    
    -- Created 12-1-2011 R Benzell
    -- Used by Finance/billing reports to provide count of Datapoints for a particular case.
    -- does not included ISDELETED (soft deletes) in counts
    
    -- to test:  select DATAPOINT_COUNT(1800) from dual;
    -- Updated 9-16-2012 R Benzell
    -- use SNX_IWS2.DPENTRYPAGES_VIEW 
    -- Updated 10-17-2012 R Benzell
    -- use DPENTRYPAGES_VIEW 
    
    
        RETURN number
    
        IS
    
       v_Count number;
        BEGIN
            
       
       BEGIN
         select count(*) into v_Count
          from DPENTRYPAGES_VIEW   --DPENTRYPAGES_VIEW
            where  CASEID = P_CASEID 
            AND ( ISDELETED = 'N' or ISDELETED IS NULL);
       EXCEPTION WHEN OTHERS THEN 
            v_Count := NULL;
       END;
 
         return v_Count;
       
      END;

/

