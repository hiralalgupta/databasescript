--------------------------------------------------------
--  DDL for Function USER_DATEONLY_FORMAT
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SNX_IWS2"."USER_DATEONLY_FORMAT" 
    -- Created 11-2-2011 R Benzell
    -- When provide a ClientID/CaseId combo, returns the desired Date Picture Format
    -- to test:  select CLIENT_DATE_FORMAT(4) from dual;
    -- to test:  select CLIENT_DATE_FORMAT(null,24) from dual;
    --
    -- Update History
     
     
     (P_USERIDID in number default 0,
      P_CASEID in number default 0)  
     RETURN VARCHAR2
   
    IS
    
      v_Date_Format varchar2(35);
     BEGIN
         
   --- Hardcode for Now
       v_Date_Format :='MM-DD-YYYY' ;

/****
       BEGIN   
         
         CASE 
          ---- Case has a specific Language Override FUTURE
          WHEN P_CASEID <> 0 THEN
            select b.DateFormat into  v_Date_Format
            from  CASES A,
                  LANGUAGES B
              where A.LANGUAGEID = B.LanguageID
                    and A.CASEID = P_CASEID;
          
          
         
          ---- Case has a specific Language Override
          WHEN P_CLIENTID <> 0 THEN
            select b.DateFormat into  v_Date_Format
            from  CLIENTS A,
                  LANGUAGES B
              where A.DEFAULTLANGUAGEID = B.LanguageID
                    and A.CLIENTID = P_CLIENTID;
          --- Default in case nothing is specified
          ELSE v_Date_Format :='MM-DD-YYYY HH:MIpm';  
         
          END CASE;

       
        EXCEPTION 
           WHEN OTHERS THEN v_Date_Format :='MM-DD-YYYY HH:MIpm';
      END; 
***/
     
    return  v_Date_Format;
       
    END;

/

