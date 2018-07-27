--------------------------------------------------------
--  DDL for Function IS_USERID_IN_ROLELIST
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SNX_IWS2"."IS_USERID_IN_ROLELIST" 
       ( P_USERID number,  
        P_ROLELIST varchar2 
        )
    
    -- Created 6-25-2012 R Benzell
    -- Returns a flag indicating whether a USERID is a member of a string 
    -- colon delimted rolelist like:  22:2:3
    -- which corresponds to a selectection of ROLE_USER, STEP-1-OP , STEP-1-QA
    -- where rolelist is build using Checkbox or Shuttle controller
    -- used by screen 150 to build where clause
    -- to test:  select IS_USERID_IN_ROLELIST(3,'22:2:3') from dual
    

    
        RETURN VARCHAR2   -- Y or N 
    
        IS
    
        v_count number default 0;
        v_Return VARCHAR2(10) default 'N';
        v_RoleList varchar2(1000);
        v_SQL varchar2(1000);

      
        BEGIN
            
  

   --- Convert the ROLELIST from : to , for SQL in compatability
         v_RoleList := replace(P_ROLELIST,':',',');

        
        --- See if this users is assigned any roles that count as MGR
         v_SQL := ' SELECT COUNT(*)  from USERROLES where USERID = :b_USERID
             and ROLEID in (' || v_roleList || ') ' ;

        -- htp.p('vsql='||v_sql);

         IF P_ROLELIST is not NULL 
          then EXECUTE IMMEDIATE v_sql INTO v_count USING P_USERID;
          else v_count := 0; -- avoids ORA-00936 if no P_ROLELIST value passed
         END IF;     
            
           if v_count >= 1 
             then v_Return := 'Y';
             else v_Return := 'N';
           end if;
      
        return v_Return;
       
       EXCEPTION WHEN OTHERS THEN 
            htp.p(SUBSTR(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
                              CHR(13) || 
                SQLERRM,1,4000));
            v_Return := 'No';
            return v_Return;
           
       END;

/

