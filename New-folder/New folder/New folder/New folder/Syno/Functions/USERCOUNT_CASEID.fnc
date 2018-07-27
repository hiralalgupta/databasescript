--------------------------------------------------------
--  DDL for Function USERCOUNT_CASEID
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SNX_IWS2"."USERCOUNT_CASEID" 
(p_userid in NUMBER)
return NUMBER
    
As Case_count Number;

begin
   IF P_USERID IS NOT NULL Then
select count(caseid) into Case_count from cases where userid=p_userid;
ELSE 
    RETURN NULL;
END IF;

RETURN Case_count;

end;

/

