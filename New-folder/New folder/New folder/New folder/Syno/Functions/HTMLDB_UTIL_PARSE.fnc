--------------------------------------------------------
--  DDL for Function HTMLDB_UTIL_PARSE
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SNX_IWS2"."HTMLDB_UTIL_PARSE" 
    (   P_USERID number,  
        P_ROLELIST varchar2)
    
    -- Created 6-25-2012 R Benzell
    -- SAMPLE CODE


    
        RETURN VARCHAR2   -- Y or N 
    
        IS
    
        v_count number default 0;
        v_Return VARCHAR2(1) default 'N';

        ROLE_arr2 HTMLDB_APPLICATION_GLOBAL.VC_ARR2;
      
        BEGIN
            
  

      --- Parse the line into separate elements
       ROLE_arr2 := HTMLDB_UTIL.STRING_TO_TABLE(P_ROLELIST);
  

     --- show each field values
      for z in 1..ROLE_arr2.count
      LOOP
        if ROLE_arr2(z) IS NOT NULL then
           v_Return :=  v_Return || '-' || z || ': ' || ROLE_arr2(z) || '<br>';
        end if;
      END LOOP;

 
        return v_Return;
       
       EXCEPTION WHEN OTHERS THEN 
            v_Return := NULL;
           
       END;

/

