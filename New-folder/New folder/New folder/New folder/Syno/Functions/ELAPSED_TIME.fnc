--------------------------------------------------------
--  DDL for Function ELAPSED_TIME
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SNX_IWS2"."ELAPSED_TIME" 
   (P_TIMESTAMP IN TIMESTAMP default NULL,
    P_COMPARETIME IN TIMESTAMP default systimestamp,  
    P_SECONDS  IN NUMBER default null,
    P_FORMAT IN VARCHAR2 default 'DHM'   -- DHMS for seconds
   )

  -- Program name: ELAPSED_TIME
  -- Created: R Benzell 10-26-2011
    -- to test:  select elapsed_time(systimestamp-1000) from dual;  
  -- Update History R Benzell 3-12-2012 
  -- Optionally support seconds in format.
  -- also display time based on P_SECONDS input parameter

 --- to test
    --  select ELAPSED_TIME(systimestamp-.0123,systimestamp,null,'DHM') from dual;
    -- select ELAPSED_TIME(systimestamp-(1/1440),systimestamp,null,'DHMS') from dual;
    -- select ELAPSED_TIME(systimestamp-(1/86400),systimestamp,null,'DHMS') from dual;
    -- select ELAPSED_TIME(null,null,61,'DHMS') from dual
    

 RETURN VARCHAR2

  AS
      v_ElapsedTime     VARCHAR2(100) := '' ;

      v_remainder number := 0 ;
      v_sec_remainder number := 0 ;
      v_days       NUMBER  := 0;  
      v_hours      NUMBER  := 0;
      v_Minutes      NUMBER  := 0;
      v_Seconds      NUMBER  := 0;
      n_age        NUMBER  := 0;
      v_DOB    DATE;

 BEGIN

   IF P_TIMESTAMP is NOT NULL 
     then
       --- Calculated Total Seconds between 2 timestamps
        v_Seconds := round(SECONDS_BETWEEN_TIMESTAMPS(P_TIMESTAMP,P_COMPARETIME),0);

     ELSE
       --- Used passed Seconds
        v_Seconds := P_SECONDS;
   END IF;


  --- Calculate only if we have a provided value
  if v_Seconds is NOT NULL then
     
   --- Get total Seconds
    -- v_Seconds := round(SECONDS_BETWEEN_TIMESTAMPS(P_TIMESTAMP,P_COMPARETIME),0);
     
     --- Get total minutes
     v_Minutes := trunc((v_seconds/60),0);
     --v_Minutes := round((v_seconds/60),0);

    -- remainder of seconds 
     v_Seconds := mod(v_seconds, 60 );


     -- determine days, and remainder
     v_days :=  trunc(v_minutes/1440);
     v_remainder := v_Minutes - (v_days*1440);

     -- determine hours and hours in remainder
     v_hours :=  trunc(v_remainder/60);
     v_minutes := v_remainder - (v_hours*60);
     
     CASE 
     WHEN P_FORMAT = 'DHM' then
            v_ElapsedTime :=   v_days    || 'd ' || 
                               v_hours   || 'h ' || 
                               v_Minutes || 'm' ;

     WHEN P_FORMAT = 'DHMS' then
            v_ElapsedTime :=   v_days    || 'd ' ||
                               v_hours   || 'h ' ||
                               v_Minutes || 'm '  ||
                               v_Seconds || 's'  ;

     ELSE v_ElapsedTime :=   v_days    || 'd ' ||
                             v_hours   || 'h ' ||
                             v_Minutes || 'm' ;
     END CASE  ;


   ELSE
     v_ElapsedTime := '';
   END IF;


    RETURN v_ElapsedTime;

 END;

/

