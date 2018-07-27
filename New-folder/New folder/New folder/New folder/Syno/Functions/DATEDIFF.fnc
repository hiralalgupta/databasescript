--------------------------------------------------------
--  DDL for Function DATEDIFF
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SNX_IWS2"."DATEDIFF" 
(
BEGINTIME DATE
, ENDTIME DATE
)
-- RETURN NUMBER
RETURN VARCHAR2(50) AS STR;  


BEGIN

SELECT FLOOR(TO_DATE(SUSTR(BEGINTIME,1,15),'MM-DD-YYYY hh24:mi')-TO_DATE(SUBSTR(ENDTIME,1,15),'MM-DD-YYYY hh24:mi'))*24*60 FROM dual;

RETURN STR;

END;

/

