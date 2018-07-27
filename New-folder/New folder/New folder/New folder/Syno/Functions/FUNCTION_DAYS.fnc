--------------------------------------------------------
--  File created - Monday-March-14-2016   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Function FUNCTION_DAYS
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SNX_DASHBOARD"."FUNCTION_DAYS" (P_MONTH IN VARCHAR2) RETURN NUMBER AS
V_DAY NUMBER:=0;
  V_CURRENT_MONTH  VARCHAR2(10);
BEGIN
select to_char(sysdate, 'MM') INTO V_CURRENT_MONTH  from dual;
IF P_MONTH= V_CURRENT_MONTH  THEN
     select FUNCTION_TOTAL_DAY(P_MONTH) -    (SELECT COUNT(*) FROM
    (SELECT TRUNC(SYSDATE,'MM') + LEVEL - 1 DAT FROM DUAL
     connect by level <= LAST_DAY(TRUNC(sysdate)) - TRUNC(sysdate,'MM') + 1)
     where TO_CHAR(DAT,'DY') not in  ('SUN','SAT') and DAT >sysdate
    GROUP BY TO_CHAR(DAT,'MON-RRRR') ) INTO V_DAY from dual;
ELSE
   select  FUNCTION_TOTAL_DAY(P_MONTH)  INTO V_DAY from dual;
END IF;
  RETURN V_DAY;
END FUNCTION_DAYS;

/

