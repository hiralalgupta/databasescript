--------------------------------------------------------
--  DDL for Function TOKEN_VALIDITY_CHECK
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SNX_IWS2"."TOKEN_VALIDITY_CHECK" 
    (   P_USERID  NUMBER,
        P_SESSIONID NUMBER,
        P_TOKEN  VARCHAR2
    )
    
    -- Created 9-20-2011 R Benzell
    -- Looks up the USER, token and GlobalSession and see if it is a valid 
    -- Combination that is still Active (not expired).
    -- Returns either 'VALID' or a Error Message 
    -- To test: select TOKEN_VALIDITY_CHECK(3,21,151596) from dual
    -- Update History
    -- 9-21-2011 - added NOTNEEDED check
    -- 9-22-2011 - changed to use seconds between dates for clarity
     RETURN VARCHAR2
    
     IS
     v_Result Varchar2(100) ;
     v_Created_On TIMESTAMP ;
     v_elapsed_secs number;
        
     BEGIN
         
        BEGIN 
           select CREATED_TIMESTAMP into v_Created_On
            from SESSIONS
             where SESSIONID = P_SESSIONID
                and  USERID = P_USERID
                and  TOKEN = P_TOKEN  ;
            
         EXCEPTION
           WHEN OTHERS THEN    
           v_Result := 'Invalid Token/ID/User';
           v_Created_ON := NULL;
         END;
      --- Check if Token has expired
        If v_Created_ON IS NOT NULL Then
            v_elapsed_secs := trunc(Seconds_between_Timestamps(v_Created_ON,systimestamp)); 
            --v_Result :=  v_elapsed_secs;
 
            IF v_elapsed_secs <= 300
               Then v_Result :=  'VALID';
               Else v_Result :=  'Expired - is ' || v_elapsed_secs || ' seconds old.';
            END IF;       
        END IF;
            
     return v_Result;
       
      END;

/

