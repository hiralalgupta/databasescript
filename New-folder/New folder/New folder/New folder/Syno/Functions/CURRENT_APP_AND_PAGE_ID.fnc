--------------------------------------------------------
--  DDL for Function CURRENT_APP_AND_PAGE_ID
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SNX_IWS2"."CURRENT_APP_AND_PAGE_ID" 
    (P_APP NUMBER default NULL,
     P_PAGE NUMBER default NULL)
    
    -- Created 9-20-2011 R Benzell
    -- Uniform mechanism to return the current application ID and Page ID
    -- in format of A185-P101 
    -- Used by Auditing and Error routines
    -- to test: select CURRENT_APP_AND_PAGE_ID from dual;
    -- Updated History 
    -- 9-22-2011 Optionally accept page and App passed as paramters
     
               RETURN VARCHAR2
           IS
    
 
             BEGIN
   --- Generate from Global Apex variables  
    return  'A' || nvl(v('APP_ID'),P_APP) ||
           '-S' || nvl(v('APP_PAGE_ID'),P_PAGE)
            ;
       
      END;

/

