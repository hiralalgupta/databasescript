--------------------------------------------------------
--  DDL for Function TOKEN_NEEDED_CHECK
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SNX_IWS2"."TOKEN_NEEDED_CHECK" 
    (   P_USERID  NUMBER
    )
    
    -- Created 9-21-2011 R Benzell
    -- Looks up the USER and see if it requires a token
    -- Returns either 'NEEDED', 'NOTNEEDED', 'USERNOTFOUND' Error Message 
    -- To test: select TOKEN_NEEDED_CHECK(3) from dual
    -- Update History
     RETURN VARCHAR2
    
     IS
     v_Result Varchar2(100) ;
     v_SEED number;
 
        
     BEGIN
         
        BEGIN 
           select SEED into v_SEED
            from USERS
             where USERID = P_USERID ;
         IF v_SEED IS NULL OR v_SEED = 0
            THEN  v_Result := 'NOTNEEDED';
            ELSE v_Result := 'NEEDED';
         END IF;
            
         EXCEPTION
           WHEN OTHERS THEN    
           v_Result := 'USERNOTFOUND';
         END;
               
     return v_Result;
       
      END;

/

