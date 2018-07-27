--------------------------------------------------------
--  DDL for Function OP2_CASE_USERS
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SNX_IWS2"."OP2_CASE_USERS" 
    (P_CASEID NUMBER,
     P_DELIM VARCHAR2 default ',',
     P_FORMAT VARCHAR2 default NULL)
    
    -- Created 9-20-2012 R Benzell
    -- Return the well-formed user name from the UID 
    -- Returns any user who actually entered data for a Case while it was in an non-QA Stage (ie - exclude QC1, QC2 and QA Review)
    -- Includes Step1-OP, Step2-OP and Transcription
    -- to test:  select CASE_OP_ENTRY_USERS(2272) from dual
               RETURN VARCHAR2
           IS
    
    
    --select caseid,stageid,userid from auditlog 
    -- where  actionid=17
    -- group by caseid,stageid,userid
    -- order by 1,2,3
   
      v_USERNAME varchar2(4000);
        
     BEGIN
     
         BEGIN 
           for A in
         (
             select distinct USERID_TO_USERNAME(userid) USERNAME
             from auditlog
             where caseid=P_CASEID
                and actionid = 17
                and stageid not in (7,48,50)
                and userid is not null
               
            )
           LOOP
              IF v_USERNAME is NULL  
                then v_USERNAME :=   A.USERNAME ;  -- First instance
                else v_USERNAME := v_USERNAME || P_DELIM ||  A.USERNAME ;  -- second or addl name
              END IF;
           END LOOP;    


        EXCEPTION
           WHEN OTHERS THEN V_USERNAME := NULL;
        END;
        
        return v_USERNAME;
       
      END;

/

