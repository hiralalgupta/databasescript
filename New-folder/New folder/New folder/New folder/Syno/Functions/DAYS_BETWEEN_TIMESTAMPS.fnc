--------------------------------------------------------
--  DDL for Function DAYS_BETWEEN_TIMESTAMPS
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SNX_IWS2"."DAYS_BETWEEN_TIMESTAMPS" 
    (P_TIMESTAMP1  TIMESTAMP,
     P_TIMESTAMP2  TIMESTAMP)
    
    -- Created 9-20-2011 R Benzell
    -- Calculate the Days between Two TimeStamp Dates
    -- Multiple result by 1440 to convert to minutes between dates
    -- Multiple result by 86400 to convert to seconds between dates
    
     RETURN number
    
     IS
    
     v_DATE1 date;
     v_DATE2 date;
     v_Days Number;
    
     BEGIN
          
      v_DATE1 := TO_DATE (TO_CHAR 
          (P_TIMESTAMP1, 
          'YYYY-MON-DD HH24:MI:SS'),
          'YYYY-MON-DD HH24:MI:SS');
      v_DATE2 := TO_DATE (TO_CHAR 
          (P_TIMESTAMP2, 
          'YYYY-MON-DD HH24:MI:SS'),
          'YYYY-MON-DD HH24:MI:SS');
    
      v_Days := v_DATE2-v_DATE1;
     
        RETURN (v_DAYS);
       END;

/

