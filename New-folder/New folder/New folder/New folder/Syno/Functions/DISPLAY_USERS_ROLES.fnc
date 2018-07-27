--------------------------------------------------------
--  DDL for Function DISPLAY_USERS_ROLES
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SNX_IWS2"."DISPLAY_USERS_ROLES" 
    (P_USERID number,   
     P_DELIM varchar2 default 'BR',
     P_FORMAT varchar2 default NULL)
    
    -- Created 10-18-2011 R Benzell
    -- Given a USERID, display all the asssigned UserRoles
    -- Used in APEX reports to allow easy display of UserRoles as a single function call
    -- to test: select DISPLAY_USERS_ROLES(3) from dual
    
        RETURN VARCHAR2
    
        IS
    
       v_DELIM varchar2(10) default null;
       v_Return varchar2(32000) default null;
       I integer;
        BEGIN
        
         I := 0;
       
      --- Set proper Delimiter
       CASE 
           WHEN P_DELIM = 'LF' then v_DELIM := chr(10);  
           WHEN P_DELIM = 'BR' then v_DELIM := '<br>'; 
           ELSE v_DELIM := P_DELIM;
       END CASE;
        
           
          for A in
           ( SELECT  A.ROLEID, B.ROLENAME 
                from USERROLES A,
                     ROLES B
            where A.USERID = P_USERID
               and B.ROLEID = A.ROLEID
            ORDER BY  B.SEQUENCE  )
            LOOP   
              I := I + 1;
              IF I = 1
                then v_Return :=  A.ROLENAME   ;  -- Don't need Delim on first value
                else v_Return := v_Return  || v_DELIM || A.ROLENAME   ;
              END IF;
             END LOOP; 
        return v_Return;
       
       EXCEPTION WHEN OTHERS THEN 
            v_Return := NULL;
           
       END;

/

