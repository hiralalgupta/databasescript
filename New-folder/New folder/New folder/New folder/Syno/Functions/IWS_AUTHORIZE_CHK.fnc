--------------------------------------------------------
--  DDL for Function IWS_AUTHORIZE_CHK
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SNX_IWS2"."IWS_AUTHORIZE_CHK" 
    -- program name IWS_AUTHORIZE_CHK
    -- Created 10-23-2011 R Benzell
    -- Used by procedure IWS_AUTHORIZE and various Apex IWS list/launch
    -- screens to determine if an particular user can perform an action on a file
    -- to test: select IWS_AUTHORIZE_CHK(4,1603,3) from dual;
    
      
           (
            p_StageId IN number,
            p_CaseId IN number,
            p_UserId IN number
      --pAuthorized IN OUT char
           )
            
    RETURN   Char
    
        IS
    
     v_Result Char; -- Varchar2(5) ;
     v_RoleCount number; 
     v_CaseCount number;


     BEGIN
        
        --- See if user has the Stage Role 
         select count(*) into v_Rolecount
         from USER_ROLES_STAGES
         where USERID =  p_UserId and 
               STAGEID = p_StageId;

        If v_Rolecount >= 1
           then  v_Result := 'Y';
           else  v_Result := 'N';
        end if;

       --- Basic Sanity check - see if the case exists.
       --- if it does not exist, the user obviosuly is not allowed access
       --- if case exists,  assume user is allow access (for now).
       --- Future - add more comprehensive Case access logic here
        select count(*) into v_CaseCount
         from CASES
         where CASEID =  p_CAseId;


        If v_Rolecount >= 1 and v_CaseCount >= 1
           then  v_Result := 'Y';
           else  v_Result := 'N';
        end if;
          
       return v_Result; --true;
        
      END;

 

/

