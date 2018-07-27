--------------------------------------------------------
--  DDL for Function LANG_ICON
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SNX_IWS2"."LANG_ICON" 
      ( P_LANGID  number default NULL,  
        P_FORMAT varchar2 default NULL  -- for future parameterization
       )
    
    -- Created 6-14-2013 R Benzell
    -- REturn US or UK or ? Icons depending on Langid
    
/*** Icon names (in /ORACLE/fmw/Oracle_OHS1/instances/instance1/config/OHS/ohs1/images)
   
'/i/US-flag.png';
'/i/UK-flag.png';
'/i/UnknownStatus.png';

    
****/    

  
    
        RETURN VARCHAR2 
    
        IS
    
        v_Return Varchar2(500) default null;
 
      
        BEGIN
        
    
         CASE
            
            WHEN P_LANGID = 1  then v_Return  := '/i/US-flag.png';
            WHEN P_LANGID = 2  then v_Return  := '/i/UK-flag.png';
            ELSE                    v_Return  := '/i/UnknownStatus.png';
         END CASE;

        return v_Return;
       
       EXCEPTION WHEN OTHERS THEN 
            v_Return := NULL;
           
       END;

/

