CREATE OR REPLACE FUNCTION "A_TEST"                     -- program name 1_TEST
                                   -- to test:  select a_test from dual;


(P_NUM IN VARCHAR2 DEFAULT NULL, P_FORMAT IN VARCHAR2 DEFAULT '-')
   RETURN VARCHAR2
IS
   v_Return   VARCHAR2 (25);
BEGIN
   v_return := TO_CHAR (SYSDATE, 'MM-DD-YYYY HH:MI.SS')||'-'||P_NUM;

   RETURN v_return;
END;