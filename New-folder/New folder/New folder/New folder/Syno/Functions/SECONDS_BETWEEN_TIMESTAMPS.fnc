--------------------------------------------------------
--  DDL for Function SECONDS_BETWEEN_TIMESTAMPS
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SNX_IWS2"."SECONDS_BETWEEN_TIMESTAMPS" 
    (P_TIMESTAMP1  TIMESTAMP,P_TIMESTAMP2  TIMESTAMP)
    
    -- Created 9-23-2011 R Benzell
    -- Calculate the Seconds between Two TimeStamp Dates
    
     RETURN number
    
     IS
    
     v_DATE1 date;
     v_DATE2 date;
     v_Seconds Number;
    
     BEGIN
          
      v_DATE1 := TO_DATE (TO_CHAR 
          (P_TIMESTAMP1, 
          'YYYY-MON-DD HH24:MI:SS'),
          'YYYY-MON-DD HH24:MI:SS');
      v_DATE2 := TO_DATE (TO_CHAR 
          (P_TIMESTAMP2, 
          'YYYY-MON-DD HH24:MI:SS'),
          'YYYY-MON-DD HH24:MI:SS');
    
      v_Seconds := (v_DATE2-v_DATE1) * 86400;
     
        RETURN (v_Seconds);
       END;

/

