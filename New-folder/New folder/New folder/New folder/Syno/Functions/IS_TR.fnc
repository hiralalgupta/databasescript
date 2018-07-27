--------------------------------------------------------
--  DDL for Function IS_TR
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SNX_IWS2"."IS_TR" 
    (     P_ACCESS varchar2 default NULL)
    
    -- Created 6-12-2011 R Benzell
    -- Returns a Boolean indicating where the APEX current :USERID is an Transcriber or not
    
/***
   Utilize the ROLES table 
    
    ROLEID    ROLENAME
    22    ROLE_USER
    1    STEP-1-OP
    2    STEP-1-QA
    3    STEP-2-OP
    4    STEP-2-QA
    5    STEP-3-OP
    6    STEP-3-QA
    7    STEP-4-OP
    8    STEP-4-QA
    9    MANAGER
    10    ADMIN
    11    SUPERADMIN
    44  STEP-2-TR
***/    
    
        RETURN BOOLEAN 
    
        IS
    
        v_count number default 0;
        v_Return Boolean default FALSE;
      
        BEGIN
        
        --- See if this users is assigned any roles that count as OP
            SELECT COUNT(*) into v_count from USERROLES where USERID = v('USERID')
              and ROLEID = 44;
            
           if v_count >= 1 
             then v_Return := TRUE;
             else v_Return := FALSE;
           end if;
      
        return v_Return;
       
       EXCEPTION WHEN OTHERS THEN 
            v_Return := NULL;
           
       END;  

/

