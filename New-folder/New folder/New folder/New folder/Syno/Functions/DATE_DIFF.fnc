--------------------------------------------------------
--  DDL for Function DATE_DIFF
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SNX_IWS2"."DATE_DIFF" (max_date string, min_date string)
RETURN PLS_INTEGER IS
BEGIN
  RETURN TO_DATE(max_date) - TO_DATE(min_date);
EXCEPTION
  WHEN OTHERS THEN
  RETURN NULL;
END date_diff;

/

