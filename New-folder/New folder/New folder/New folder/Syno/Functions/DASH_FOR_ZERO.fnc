--------------------------------------------------------
--  DDL for Function DASH_FOR_ZERO...
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SNX_IWS2"."DASH_FOR_ZERO" 
  -- program name DASH_FOR_ZERO
  -- Created 5-4-2012 R Benzell
  -- replaces 0 with - for enhanced report readability
    
     (P_NUM in number,
      P_FORMAT IN VARCHAR2 default '-')
    
    return varchar2 IS

    
    v_Return varchar2(25);

begin

   CASE  
    WHEN P_NUM = 0
          THEN v_return := P_FORMAT;
    WHEN P_NUM IS NULL
      THEN v_return := null;
    ELSE  
       v_return := P_NUM;
  END CASE;  
 
       return (v_return);

end;



