--------------------------------------------------------
--  DDL for Function TEST_FUNCTION
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SNX_IWS2"."TEST_FUNCTION" 
(in_val1 IN NUMBER, in_val2 IN VARCHAR2)
RETURN VARCHAR2
IS
BEGIN
RETURN (in_val1||' - '||in_val2);
END;

/

