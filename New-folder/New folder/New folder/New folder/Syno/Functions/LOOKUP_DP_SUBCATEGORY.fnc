--------------------------------------------------------
--  DDL for Function LOOKUP_DP_SUBCATEGORY
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SNX_IWS2"."LOOKUP_DP_SUBCATEGORY" 
    (P_NAME VARCHAR2 default null,
     P_CATID NUMBER default null)
    
    -- Created 9-26-2011 R Benzell
    
        RETURN number
    
        IS
    
       v_NAME varchar2(1000);
       v_SubCatId number;
        BEGIN
            
       v_Name := P_NAME;  
      --- Massage name in some cases because of Human entry inconsistencies
       CASE      
         when V_name = 'Blood' then V_name := 'Blood Test';  
         --when V_name = 'Urethral Swab' then V_name := 'Blood Test';
         else null;
       END CASE;
    
       BEGIN
         select DPSUBCATID into v_SubCatId
          from DPSUBCATEGORIES
            where 
              DPCategoryId = P_CATID and
              upper(DPSUBCATNAME) = upper(V_name);
       EXCEPTION WHEN OTHERS THEN 
            v_SubCatId := null;
       END;
 
         return v_SubCatId;
       
      END;

/

