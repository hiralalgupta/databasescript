create or replace
FUNCTION    IS_UAT 
    (     P_ACCESS varchar2 default NULL)
    
    -- Created 8-19-2012 R Benzell
    -- Returns a Boolean indicating where the APEX current :USERID is an Operator or not
    
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
    64   UAT-TESTER
***/    
    
        RETURN BOOLEAN 
    
        IS
    
        v_count number default 0;
        V_RETURN BOOLEAN DEFAULT FALSE;
        v_num number := 0;
        BEGIN
        
        
      SELECT COUNT(1) INTO V_NUM FROM DUAL WHERE (SELECT T.TEAMDESC FROM TEAMS T, USERS U  WHERE T.TEAMID = U.SUPERVISORID AND U.USERID = V('USERID')) = 'DocGenix';
        
        IF V_NUM > 0 THEN
        
         V_RETURN := TRUE;
        ELSE
        --- See if this users is assigned any roles that count as MGR
            SELECT COUNT(*) into v_count from USERROLES where USERID = v('USERID')
              and ROLEID = 64;
            
           if v_count >= 1 
             THEN V_RETURN := TRUE;
             else v_Return := FALSE; 
           END IF;
         END IF;
        return v_Return;
       
       EXCEPTION WHEN OTHERS THEN 
            v_Return := NULL;
           
       END;

/

