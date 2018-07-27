--------------------------------------------------------
--  DDL for Function LOOKUP_DP_CATEGORY
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SNX_IWS2"."LOOKUP_DP_CATEGORY" 
    (P_NAME VARCHAR2 default null)
    
    -- Created 9-26-2011 R Benzell
    -- Lookup 
    
    
        RETURN number
    
        IS
    
       v_NAME varchar2(1000);
       v_CategoryId number;
        BEGIN
            
       v_Name := P_NAME;     
    
       BEGIN
         select DPCATEGORYID into v_CategoryId
          from DPCATEGORIES
            where  upper(DPCATEGORYNAME) = upper(V_name);
       EXCEPTION WHEN OTHERS THEN 
            v_CategoryId := null;
       END;
 
         return v_CategoryId;
       
      END;

/

