--------------------------------------------------------
--  DDL for Procedure IWS_AUTHORIZE
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "SNX_IWS2"."IWS_AUTHORIZE" 
     (pStageId IN number, 
      pCaseId IN number, 
      pUserId IN number, 
      pAuthorized IN OUT char) 
    
    -- Created 10-23-2011 R Benzell based on TeamInformatics Parameters
    -- provides a reponse indicating if a User is Authorized to perform an action
    -- to test:
    -- returns Y = authorized or N for not
    /***
    declare
      v_result char;
    begin
      IWS_AUTHORIZE(pStageId => 4,
                    pCaseId  => 1603,
                    pUserId => 3,
          pAuthorized => v_result);
       htp.p('Auth Result=' ||v_result);
     end;
    ***/
    -- Update History:
    
    
    
     IS
     
     BEGIN  
    
     --pAuthorized := 'Y';
     pAuthorized := IWS_AUTHORIZE_CHK(PStageId,pCaseid,pUserid);

     EXCEPTION WHEN OTHERS THEN LOG_APEX_ERROR(1);

   END; 

 

/

