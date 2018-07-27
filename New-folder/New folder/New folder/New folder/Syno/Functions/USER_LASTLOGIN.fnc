--------------------------------------------------------
--  DDL for Function USER_LASTLOGIN
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SNX_IWS2"."USER_LASTLOGIN" 
(p_userid in NUMBER)
return TIMESTAMP
AS LASTLOGINTIME TIMESTAMP;
begin
IF p_userid IS NOT NULL
    THEN    
SELECT max(U.LASTLOGIN) INTO LASTLOGINTIME FROM USERS U WHERE U.USERID=p_userid;
ELSE
    RETURN NULL;
END IF;

RETURN LASTLOGINTIME;

end;

/

