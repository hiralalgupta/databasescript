--------------------------------------------------------
--  DDL for Function MINUTES_BETWEEN_TIMESTAMPS
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SNX_IWS2"."MINUTES_BETWEEN_TIMESTAMPS" 
    (P_TIMESTAMP1  TIMESTAMP,
     P_TIMESTAMP2  TIMESTAMP)
    
    -- Created 10-25-2011 R Benzell
    -- Calculate the Minutes between Two TimeStamp Dates
    
     RETURN number
    
     IS
    
     v_DATE1 date;
     v_DATE2 date;
     v_Minutes Number;
    
     BEGIN
          
      v_DATE1 := TO_DATE (TO_CHAR 
          (P_TIMESTAMP1, 
          'YYYY-MON-DD HH24:MI:SS'),
          'YYYY-MON-DD HH24:MI:SS');
      v_DATE2 := TO_DATE (TO_CHAR 
          (P_TIMESTAMP2, 
          'YYYY-MON-DD HH24:MI:SS'),
          'YYYY-MON-DD HH24:MI:SS');
    
      v_Minutes := (v_DATE2-v_DATE1) * 1440 ;
     
        RETURN (v_Minutes);
       END;

/

