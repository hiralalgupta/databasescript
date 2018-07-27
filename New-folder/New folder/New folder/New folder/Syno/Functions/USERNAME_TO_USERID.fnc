--------------------------------------------------------
--  DDL for Function USERNAME_TO_USERID
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SNX_IWS2"."USERNAME_TO_USERID" 
    (P_USERNAME VARCHAR2)
    
    -- Created 9-17-2011 R Benzell
    -- Generate the UID from the USERNAME
    -- Update History
    -- 9-20-11 R Benzell - always us uppercase P_USERNAME in where
               RETURN number
           IS
        v_USERID number;
        
             BEGIN
        BEGIN 
        select USERID into v_USERID
          from USERS
                 where USERNAME = upper(P_USERNAME);
        EXCEPTION
           WHEN OTHERS THEN V_USERID := -1;
        END;
        
        return v_USERID;
       
      END;

/

