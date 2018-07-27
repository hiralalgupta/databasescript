--------------------------------------------------------
--  DDL for Function DATAFIELD_DISPLAY
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SNX_IWS2"."DATAFIELD_DISPLAY" 
    (P_DATAFIELD1VALUE VARCHAR2 default null,
     P_DATAFIELD2VALUE VARCHAR2 default null,
     P_DATAFIELD3VALUE VARCHAR2 default null,
     P_DATAFIELD4VALUE VARCHAR2 default null,    
     P_DATAFIELD5VALUE VARCHAR2 default null,    
     P_DATAFIELD6VALUE VARCHAR2 default null,
     P_DATAFIELD7VALUE VARCHAR2 default null,
     P_DATAFIELD8VALUE VARCHAR2 default null,
     P_DATAFIELD9VALUE VARCHAR2 default null,    
     P_DATAFIELD10VALUE VARCHAR2 default null,
     P_DATAFIELD11VALUE VARCHAR2 default null,
     P_DATAFIELD12VALUE VARCHAR2 default null,
     P_DELIMITER         VARCHAR2 default ' | ')
    
    -- Created 11-7-2012 R Benzell
    -- Display the DataField values with the indicated delimiter
/* to test    
     select "DATAFIELD_DISPLAY('123',null,'456') from dual
*/    
    

    
        RETURN VARCHAR2
    
        IS
    
        v_Return VARCHAR2(32000) ;

       BEGIN

         IF P_DATAFIELD1VALUE is not null THEN
           v_Return := v_Return || P_DELIMITER || P_DATAFIELD1VALUE; 
         END IF;

         IF P_DATAFIELD2VALUE is not null THEN
           v_Return := v_Return || P_DELIMITER || P_DATAFIELD2VALUE  ; 
         END IF;

         IF P_DATAFIELD3VALUE is not null THEN
           v_Return := v_Return || P_DELIMITER || P_DATAFIELD3VALUE ; 
         END IF;

         IF P_DATAFIELD4VALUE is not null THEN
           v_Return := v_Return || P_DELIMITER || P_DATAFIELD4VALUE; 
         END IF;

         IF P_DATAFIELD5VALUE is not null THEN
           v_Return := v_Return || P_DELIMITER || P_DATAFIELD5VALUE  ; 
         END IF;

         IF P_DATAFIELD6VALUE is not null THEN
           v_Return := v_Return || P_DELIMITER || P_DATAFIELD6VALUE ; 
         END IF;
 
         IF P_DATAFIELD7VALUE is not null THEN
           v_Return := v_Return || P_DELIMITER || P_DATAFIELD7VALUE; 
         END IF;

         IF P_DATAFIELD8VALUE is not null THEN
           v_Return := v_Return || P_DELIMITER || P_DATAFIELD8VALUE  ; 
         END IF;

         IF P_DATAFIELD9VALUE is not null THEN
           v_Return := v_Return || P_DELIMITER || P_DATAFIELD9VALUE ; 
         END IF;

         IF P_DATAFIELD10VALUE is not null THEN
           v_Return := v_Return || P_DELIMITER || P_DATAFIELD10VALUE; 
         END IF;

         IF P_DATAFIELD11VALUE is not null THEN
           v_Return := v_Return || P_DELIMITER || P_DATAFIELD11VALUE  ; 
         END IF;

         IF P_DATAFIELD12VALUE is not null THEN
           v_Return := v_Return || P_DELIMITER || P_DATAFIELD12VALUE ; 
         END IF;    
    

     --- Remove firstdelimiter
         v_Return := trim(substr(v_Return,length(P_DELIMITER)+1));
 
         return v_Return;
       
      END;

/

