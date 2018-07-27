--------------------------------------------------------
--  DDL for Function IS_FVQA
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SNX_IWS2"."IS_FVQA" 
    (     P_ACCESS varchar2 default NULL)
    
    -- Created 9-21-2012 R Benzell
    -- Returns a Boolean indicating where the APEX current :USERID is an Infopath FileViewer QA'eror not
    

 
    
        RETURN BOOLEAN 
    
        IS
    
        v_count number default 0;
        v_Return Boolean default FALSE;
      
        BEGIN
        
        --- See if this users is assigned any roles that count as FV
            SELECT COUNT(*) into v_count from USERROLES where USERID = v('USERID')
              and ROLEID in (86);
            
           if v_count >= 1 
             then v_Return := TRUE;
             else v_Return := FALSE;
           end if;
      
        return v_Return;
       
       EXCEPTION WHEN OTHERS THEN 
            v_Return := NULL;
           
       END;

/

