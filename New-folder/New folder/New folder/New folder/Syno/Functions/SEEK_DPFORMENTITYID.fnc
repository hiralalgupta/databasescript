--------------------------------------------------------
--  DDL for Function SEEK_DPFORMENTITYID
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SNX_IWS2"."SEEK_DPFORMENTITYID" 
    (P_DPCATEGORYID  number,   
     P_DPSUBCATID    number)
    
    -- Created 10-10-2011 R Benzell
    -- Give a Category and SubCategory Id, return the unique DPFORMENTITYID.
    -- Used by Apex screen such as 46 to return primary key to link form entities
    -- from subcategories listings
    
        RETURN number
    
        IS
    
       v_DPFORMENTITYID number default null;
        BEGIN
            
        
       BEGIN
         select DPFORMENTITYID into v_DPFORMENTITYID
          from DPFORMENTITIES
            where 
              DPCategoryId = P_DPCATEGORYID  
             and DPSUBCATID = P_DPSUBCATID;
       EXCEPTION WHEN OTHERS THEN 
            v_DPFORMENTITYID := null;
       END;
       return v_DPFORMENTITYID;
       
      END;

/

