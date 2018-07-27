--------------------------------------------------------
--  DDL for Function DP_CHANGE_LISTING
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SNX_IWS2"."DP_CHANGE_LISTING" 
    (P_DPENTRYID NUMBER default null,
     P_FORMAT VARCHAR2 default null)
    
    -- Created 11-5-2012 R Benzell
    -- Generate Count of changes to each reference DataPoint
    
    -- to test:  select DP_CHANGE_LISTING(25230) from dual;
    -- Update History 
    
    
        RETURN varchar2
    
        IS
    


       v_Count Number;
       v_Return Varchar2(32000);


        BEGIN
            
v_count := 0;            

    
FOR A IN            
 (SELECT  ORIGINAL_VALUE, MODIFIED_VALUE
     FROM ERROR_LISTING
     WHERE DPENTRYID = P_DPENTRYID
     ORDER BY FIELD_NAME,LOGID)
  
 LOOP
    v_count := v_count + 1; 
    v_Return := v_Return || v_count || '.&nbsp;'||
               A.original_value || '=>' || A.modified_value ||'<br>';
     
  END LOOP;
     
            
  
         return v_Return;

      EXCEPTION WHEN OTHERS THEN SHOW_APEX_ERROR('');

      END;



/

