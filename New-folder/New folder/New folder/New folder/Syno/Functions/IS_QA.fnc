--------------------------------------------------------
--  DDL for Function IS_QA
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SNX_IWS2"."IS_QA" 
    (     P_ACCESS varchar2 default NULL)
    
    -- Created 10-25-2011 R Benzell
    -- Returns a Boolean indicating where the APEX current :USERID is an QA/QCer or not
    -- Update History
    -- 2012-08-21 R Benzell
    -- Added QC1 and QC2 roles (ROLEID = 65 and 66)
    
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
    65    STEP-2-QC1
    66    STEP-2-QC2
    
***/    
    
        RETURN BOOLEAN 
    
        IS
    
        v_count number default 0;
        v_Return Boolean default FALSE;
      
        BEGIN
        
        --- See if this users is assigned any roles that count as QA
            SELECT COUNT(*) into v_count from USERROLES where USERID = v('USERID')
              and ROLEID in (2,4,6,8,65,66);
            
           if v_count >= 1 
             then v_Return := TRUE;
             else v_Return := FALSE;
           end if;
      
        return v_Return;
       
       EXCEPTION WHEN OTHERS THEN 
            v_Return := NULL;
           
       END;

/

