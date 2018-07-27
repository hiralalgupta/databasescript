--------------------------------------------------------
--  DDL for Function CASE_STAGE_DATETIMES
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SNX_IWS2"."CASE_STAGE_DATETIMES" 
    (P_CASEID NUMBER default null,
     P_MAXMIN VARCHAR2 default 'MIN',    --MIN or MAX - earliest or latest
     P_STAGE_GROUP VARCHAR2 default '%'  --ALL,OP,QC,TR Stage Function Group
    )   
    
    
    -- Created 11-13-2012 R Benzell
    -- Returns the earliest or latest stage
    -- does not included ISDELETED (soft deletes) in counts
    
    -- to test:  SELECT CASE_STAGE_DATETIMES(2047,'MIN') from dual
    
    
        RETURN TIMESTAMP
    
        IS
    
       v_Return  TimeStamp;
        BEGIN
            
       
       CASE
        WHEN P_MAXMIN = 'MIN' then
            Select min(ASSIGNMENTSTARTTIMESTAMP)
            into v_Return
            From CASEHISTORYSUM C,
                 STAGES S
            WHERE CASEID = P_CASEID
            AND S.STAGEID = C.STAGEID
            AND ASSIGNMENTSTARTTIMESTAMP is not null
            AND USER_FUNCTION_GROUP like  P_STAGE_GROUP ;

        WHEN P_MAXMIN = 'MAX' then
            Select max(ASSIGNMENTCOMPLETIONTIMESTAMP)
            into v_Return
            From CASEHISTORYSUM C,
                 STAGES S
            WHERE CASEID = P_CASEID
            AND S.STAGEID = C.STAGEID
            AND ASSIGNMENTCOMPLETIONTIMESTAMP is not null
            AND USER_FUNCTION_GROUP like  P_STAGE_GROUP ;

           
         ELSE null;

       END CASE;

         return v_Return;

       EXCEPTION WHEN OTHERS THEN 
            v_Return := NULL;
       END;
 

/

