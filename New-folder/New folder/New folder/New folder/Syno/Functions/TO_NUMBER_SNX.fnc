--------------------------------------------------------
--  DDL for Function TO_NUMBER_SNX
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SNX_IWS2"."TO_NUMBER_SNX" 
  (str_in VARCHAR2
   )
--- Created 11-29-2011 R Benzell
--- Return a number.


RETURN NUMBER IS

  v_Return Number default 0;

  BEGIN

    BEGIN
        v_Return := to_number(str_in);

    EXCEPTION WHEN OTHERS THEN
         v_Return := NULL;

    END;



    Return v_Return;

   END;

/

