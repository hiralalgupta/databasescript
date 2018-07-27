--------------------------------------------------------
--  DDL for Function DISPLAY_LOVVALUES
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SNX_IWS2"."DISPLAY_LOVVALUES" 
    (P_LOVID  number,   
     P_DELIM varchar2 default ', ',
     P_FORMAT varchar2 default NULL)
    
    -- Created 10-12-2011 R Benzell
    -- Given a LOVID, display all the associated LOVValues
    -- Used in APEX reports to allow easy display of LOV's as a single function call
    
        RETURN VARCHAR2
    
        IS
    
       v_DELIM varchar2(10) default null;
       v_Return varchar2(32000) default null;
       I integer;
        BEGIN
        
         I := 0;
       
      --- Set proper Delimiter
       CASE 
           WHEN P_DELIM = 'LF' then v_DELIM := chr(10);  
           WHEN P_DELIM = 'BR' then v_DELIM := '
'; 
           ELSE v_DELIM := P_DELIM;
       END CASE;
        
           
          for A in
           ( SELECT  LOVVALUE from LOVVALUES
            where LOVID = P_LOVID
            ORDER BY  SEQUENCE,LOVVALUE  )
            LOOP   
              I := I + 1;
              IF I = 1
                then v_Return :=  A.LOVVALUE  ;  -- Don't need Delim on first value
                else v_Return := v_Return  || v_DELIM || A.LOVVALUE  ;
              END IF;
             END LOOP; 
        return v_Return;
       
       EXCEPTION WHEN OTHERS THEN 
            v_Return := NULL;
           
       END;

/

