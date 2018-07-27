--------------------------------------------------------
--  DDL for Function USERID_TO_USERNAME
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SNX_IWS2"."USERID_TO_USERNAME" 
    (P_USERID NUMBER)
    
    -- Created 10-20-2011 R Benzell
    -- REturn the well-formed user name from the UID 
    -- to test:  select USERID_TO_USERNAME(3) from dual
               RETURN VARCHAR2
           IS
   
      v_USERNAME varchar2(150);
        
     BEGIN
     
         BEGIN 
        select FIRSTNAME ||' ' || LASTNAME     into v_USERNAME
          from USERS
                 where USERID= P_USERID;
        EXCEPTION
           WHEN OTHERS THEN V_USERNAME := NULL;
        END;
        
        return v_USERNAME;
       
      END;

/

