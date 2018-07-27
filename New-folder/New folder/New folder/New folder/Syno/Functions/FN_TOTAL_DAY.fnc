--------------------------------------------------------
--  File created - Friday-April-01-2016   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Function FN_TOTAL_DAY
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SNX_DASHBOARD"."FN_TOTAL_DAY" RETURN NUMBER AS
  V_DAY NUMBER:=0;
  V_HOLIDAY NUMBER :=0;
  BEGIN
  SELECT COUNT(HOLIDAY_DATE) INTO V_HOLIDAY FROM HOLIDAY WHERE  HOLIDAY_CALENDAR_ID=1010 AND TRUNC(SYSDATE,'MM')=TRUNC(HOLIDAY_DATE,'MM');
  
 SELECT COUNT(*) into v_day FROM
    (SELECT TRUNC(SYSDATE,'MM') + LEVEL - 1 DAT FROM DUAL
    CONNECT BY LEVEL <= LAST_DAY(TRUNC(SYSDATE)) - TRUNC(SYSDATE,'MM') + 1)
    WHERE TO_CHAR(DAT,'DY') NOT IN  ('SUN','SAT')
   GROUP BY TO_CHAR(DAT,'MON-RRRR') ;

/*
 SELECT COUNT(*) into v_day FROM
    (SELECT * FROM
    (SELECT TRUNC(SYSDATE,'MM') + LEVEL - 1 DAT FROM DUAL
     CONNECT BY LEVEL <= LAST_DAY(TRUNC(SYSDATE)) - TRUNC(SYSDATE,'MM') + 1)
     WHERE TO_CHAR(DAT,'DY') NOT IN  ('SUN','SAT')) WHERE DAT <= SYSDATE;
   */   
     
     v_day := v_day- V_HOLIDAY;

   return v_day;
  end;

/

