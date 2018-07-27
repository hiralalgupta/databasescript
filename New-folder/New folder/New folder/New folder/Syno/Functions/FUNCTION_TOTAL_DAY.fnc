--------------------------------------------------------
--  File created - Monday-March-14-2016   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Function FUNCTION_TOTAL_DAY
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SNX_DASHBOARD"."FUNCTION_TOTAL_DAY" (P_MONTH IN VARCHAR2) RETURN NUMBER AS
  V_DAY NUMBER:=0;
  V_HOLIDAY NUMBER :=0;
   V_CURRENT_MONTH  VARCHAR2(10);
  BEGIN
  select (to_char(sysdate, 'MM')) INTO V_CURRENT_MONTH  from dual;
  IF P_MONTH= V_CURRENT_MONTH  THEN
      SELECT COUNT(HOLIDAY_DATE) INTO V_HOLIDAY FROM HOLIDAY WHERE  HOLIDAY_CALENDAR_ID=1010 AND TRUNC(SYSDATE,'MM')=TRUNC(HOLIDAY_DATE,'MM');
      SELECT COUNT(*) into v_day FROM
      (SELECT TRUNC(SYSDATE,'MM') + LEVEL - 1 DAT FROM DUAL
      CONNECT BY LEVEL <= LAST_DAY(TRUNC(SYSDATE)) - TRUNC(SYSDATE,'MM') + 1)
       WHERE TO_CHAR(DAT,'DY') NOT IN  ('SUN','SAT')
      GROUP BY TO_CHAR(DAT,'MON-RRRR') ;
   ELSE
      SELECT COUNT(HOLIDAY_DATE) into  V_HOLIDAY FROM HOLIDAY WHERE  HOLIDAY_CALENDAR_ID=1010 AND add_months(TRUNC(SYSDATE,'MM'),-1)=TRUNC(HOLIDAY_DATE,'MM');
      SELECT COUNT(*) into v_day FROM
    (SELECT add_months(TRUNC(SYSDATE,'MM'),-1) + LEVEL - 1 DAT FROM DUAL
    CONNECT BY LEVEL <= LAST_DAY(add_months(TRUNC(SYSDATE,'MM'),-1)) - add_months(TRUNC(SYSDATE,'MM'),-1) + 1)
    WHERE TO_CHAR(DAT,'DY') NOT IN  ('SUN','SAT')
   GROUP BY TO_CHAR(DAT,'MON-RRRR') ;
   END IF;
     v_day := v_day- V_HOLIDAY;

   return v_day;
  end;

/

