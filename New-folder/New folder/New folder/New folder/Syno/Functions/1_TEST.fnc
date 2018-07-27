  CREATE OR REPLACE FUNCTION "SNX_IWS2"."1_TEST" 
  -- program name 1_TEST 1
 
    
     (P_NUM in varchar2,
      P_FORMAT IN VARCHAR2 default '-')
    
    return varchar2 IS

    
    v_Return varchar2(25);

begin

 select sysdate into v_return;	

 return v_return

end;



