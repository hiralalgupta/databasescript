--------------------------------------------------------
--  DDL for Function USER_LASTACTIVITY
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SNX_IWS2"."USER_LASTACTIVITY" 
(p_userid in NUMBER)
return TIMESTAMP
As lastActivitytime TIMESTAMP;
--- created A Mathur on 5-1-2012
begin
    IF p_userid IS NOT NULL THEN
    Select max(S.lastactivitytimestamp) into lastActivitytime from sessions S where S.userid = p_userid;
    --lastActivitytime := activitytime;
    ELSE
        RETURN NULL;
END IF;
RETURN lastActivitytime;

end;

/

