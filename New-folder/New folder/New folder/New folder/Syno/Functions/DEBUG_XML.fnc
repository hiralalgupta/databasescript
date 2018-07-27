--------------------------------------------------------
--  DDL for Function DEBUG_XML
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SNX_IWS2"."DEBUG_XML" 
    (   P_str clob  ) 
    
    
        RETURN CLOB
    
        IS
    

        v_Str CLOB;
          
          
            BEGIN
      
  
         v_Str := replace(P_Str,'<','['); 
         v_Str := replace(v_Str,'>',']');
         v_Str := replace(v_Str,'[br]','<br>');
     
         
        
       RETURN v_Str;
    
             
           
       END;

/

