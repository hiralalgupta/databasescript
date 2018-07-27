--------------------------------------------------------
--  DDL for Function GET_TOKEN
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SNX_IWS2"."GET_TOKEN" 
    (P_SEED  NUMBER default 0)
    
    -- Created 9-16-2011 R Benzell
    -- Generate a Token using a random number generator
    -- to test: select get_token() from dual;
    -- Update 9-20-2011 R Benzell
    --  added optional seed initialization
    
    
        RETURN number
    
        IS
        BEGIN
    
         IF P_SEED <> 0 then  
            dbms_random.initialize(P_SEED);
         END IF;
         return trunc(dbms_random.value(1,1000000));
       
      END;

/

