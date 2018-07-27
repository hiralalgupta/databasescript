create or replace PACKAGE BODY myDemoPack AS
FUNCTION prodFunc RETURN myTableType PIPELINED IS
BEGIN
  FOR i in 1 .. 5
    LOOP
      PIPE ROW (myObjectFormat(i,SYSDATE+i,'Row '||i));
    END LOOP;
    RETURN;
  END;
END;
