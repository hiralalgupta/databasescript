--------------------------------------------------------
--  DDL for Function IS_USERID_VALID
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SNX_IWS2"."IS_USERID_VALID" 
    -- program name IS_USERID_VALID
    -- Created 6-18-2012 R Benzell
    -- Used by reports and assignment screen to distinguish between 
    -- expired and locked accounts from active accounts
    -- to test: select IS_USERID_VALID(3) from dual;
    
      
           (
            p_UserId IN number,
            p_Format IN varchar2  default null  -- future formatting opiton
           )
            
    RETURN   varChar2
    
        IS
    
     v_Count number; 
     v_Result varchar2(100) ;


     BEGIN
        
        --- if userid meets active status and non-expiration
         select count(*) into v_count
         from USERS 
         where USERID =  p_UserId
                  AND ACCOUNTSTATUS = 'ACTIVE'
                  AND EFFECTIVEDATE     < systimestamp
                  AND (EXPIRATIONDATE  IS NULL OR EXPIRATIONDATE > systimestamp);



        If v_count = 1
           then  v_Result := 'Y';
           else  v_Result := 'N';
        end if;

          
       return v_Result; --true;
        
      END;

/

