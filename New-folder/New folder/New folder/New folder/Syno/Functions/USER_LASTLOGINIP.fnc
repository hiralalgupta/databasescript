--------------------------------------------------------
--  DDL for Function USER_LASTLOGINIP
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SNX_IWS2"."USER_LASTLOGINIP" 
(p_userid in NUMBER)
return VARCHAR2
As
    v_SQL varchar2(2000);
begin
BEGIN
   SELECT MAX(LASTLOGINIP)INTO V_SQL
    FROM USERS WHERE USERID=p_userid;
EXCEPTION WHEN OTHERS THEN
     v_SQL := NULL;
END;

RETURN V_SQL;
end;

/

