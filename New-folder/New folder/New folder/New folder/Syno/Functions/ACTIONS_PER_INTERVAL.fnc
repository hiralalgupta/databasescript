--------------------------------------------------------
--  DDL for Function ACTIONS_PER_INTERVAL
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SNX_IWS2"."ACTIONS_PER_INTERVAL" 
       (P_ACTIONS  number default 0,
        P_INTERVAL number default 0)
    
    -- Created 5-15-2012 R Benzell
    -- Calculate the Actions/Interval, after first checking the Denominator is not ZERO/NULL.
    -- If so, returns a 'dash'
    -- used by reports like 660 Stage/Assign progress Report
    -- If P_ACTIONS is NULL, treat as zero
    -- select ACTIONS_PER_INTERVAL(null,5) from dual yield '-'
    -- select ACTIONS_PER_INTERVAL(5,2) from dual yields 2.5
    -- select ACTIONS_PER_INTERVAL(5,null) from dual
    
     RETURN VARCHAR2
    
     IS
    
      v_Return varchar2(30);
    
     BEGIN
        
        IF P_INTERVAL <> 0 
          THEN v_Return := round(P_ACTIONS/P_INTERVAL,0);
          ELSE v_Return := '-';
        END IF;
      
     
        RETURN (v_Return);

       END;

/

