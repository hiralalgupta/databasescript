--------------------------------------------------------
--  DDL for Function USER_LASTLOGOUT
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SNX_IWS2"."USER_LASTLOGOUT" 
(p_userid in NUMBER)
return TIMESTAMP
AS LASTLOGOUTTIME TIMESTAMP;
--- created A Mathur on 3-1-2012
begin
IF p_userid IS NOT NULL
    THEN    
SELECT max(U.LASTLOGOUT) INTO LASTLOGOUTTIME FROM USERS U WHERE U.USERID=p_userid;
ELSE
    RETURN NULL;
END IF;

RETURN LASTLOGOUTTIME;
end;

/

