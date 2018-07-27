--------------------------------------------------------
--  DDL for Function CLIENT_LOGIN_AUTH_CHK
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SNX_IWS2"."CLIENT_LOGIN_AUTH_CHK" 
    -- Created 9-14-2011 R Benzell
    -- select CLIENT_LOGIN_AUTH_CHK('RBENZELL','synodex') from dual;
    
     
     
           (
            p_username varchar2,
            p_password varchar2  )
               RETURN   boolean   -- varchar2 --(for testing) boolean
           IS
             v_Valid boolean default false;
             v_count number;
             v_IP_ADDR_AUTH varchar2(200);
             v_ip_pos number;
             v_token number;
             BEGIN
              --- should get 1 exact match on userid/password
               select count(*) into v_count
               from USERS
                where upper(USERNAME) = upper(p_username)
                      and PASSWORD = p_password
                      and CLIENTID is not null
                      and EFFECTIVEDATE < systimestamp
                      and (EXPIRATIONDATE IS NULL or
                          EXPIRATIONDATE > systimestamp);
              --- Convert count into T/F
              if v_count = 1
                then v_Valid := TRUE;
                else v_Valid := FALSE;
              end if;
              --- Perform additional security checks
              IF v_valid
                then
                -- Check if IP authorization is needed, and if so, whether is matches
                select IP_ADDR_AUTH into v_IP_ADDR_AUTH
                 from USERS
                 where upper(USERNAME) = upper(p_username);
                IF v_IP_ADDR_AUTH is NOT NULL
                   then 
                    --- See if Session IP is in the users auth IP list
                    v_ip_pos := instr(v_IP_ADDR_AUTH,CURRENT_USER_IP());
                       if v_ip_pos >= 1 
                            then v_Valid := TRUE;    -- this IP is in the Auth List
                            else v_Valid := FALSE;   -- IP not in Auth List - reject login
                       end if;
                 END IF;
              END IF;
          --- use for debuggind testing  
           -- if v_Valid
           --   THEN return 'TRUE';
           --   ELSE return 'FALSE';
           -- END IF;
    
          
           return v_Valid; --true;
        
      END;

/

