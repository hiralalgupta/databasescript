--------------------------------------------------------
--  DDL for Procedure POPULATE_CUBE1
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "SNX_IWS2"."POPULATE_CUBE1" 
  -- Program name - POPULATE_CUBE1
  -- Created 4-2-2012 R Benzell
  -- For initial testing, create populate Cube1 with some random values
 /***
    begin
    delete from cube1;
    POPULATE_CUBE1;
    end;
***/
    
    (P_RUN IN VARCHAR2 default 'DEBUG')  

 
  
         IS
    
    i number;
    v_date date;
    
   --- stanza labels    
                            --  '123456789 123456789 12345' 
    v_recv varchar2(25) default 'RCV_THISPERIOD';
    v_comp varchar2(25) default 'COMP_THISPERIOD';
    v_canbl varchar2(25) default 'CAN_BILL_THISPERIOD';
    v_cannb varchar2(25) default 'CAN_NONBILL_THISPERIOD';
    v_fwd  varchar2(25) default 'CARRY_FWD_THISPERIOD';


    --v_recv varchar2(25) default 'Received This Period';
    --v_comp varchar2(25) default 'Completed This Period';
    --v_canbl varchar2(25) default 'Cancelled (Billable)';
    --v_cannb varchar2(25) default 'Cancelled (Non-Billable)';
    --v_fwd  varchar2(25) default 'Received This Period';
    
    --- metric labels    
    v_fd varchar2(25) default 'FILES_PER_DAY';
    v_pd varchar2(25) default 'PAGES_PER_DAY';
    v_pf varchar2(25) default 'PAGES_PER_FILE';
    v_dpp varchar2(25) default 'DATAPOINT_PER_PAGE';
    v_tf  varchar2(25) default 'TOT_FILES';
    v_tp  varchar2(25) default 'TOT_PAGES';
    v_tdp  varchar2(25) default 'TOT_DATAPOINTS';

    --v_fd varchar2(25) default 'Files/Day';
    --v_pd varchar2(25) default 'Pages/Day';
    --v_pf varchar2(25) default 'Pages/File';
    --v_dpp varchar2(25) default 'Datapoints/Page';
    --v_tf  varchar2(25) default 'Total Files';
    --v_tp  varchar2(25) default 'Total Pages';
    --v_tdp  varchar2(25) default 'Total Data Points';
      
    n_fd number;
    n_pd number;
    n_pf number;
    n_dpp number;
    n_tf  number;
    n_tp  number;
    n_tdp number;
    
     BEGIN
         
   for I in 1..780
    LOOP     

 --- Received         
   v_date := trunc(sysdate-I);

   n_fd := abs(mod(dbms_random.random,200))+44;
   n_pd := abs(mod(dbms_random.random,10000))+1001;
   n_pf := round(n_pd/n_fd,1);
   n_dpp := abs(mod(dbms_random.random,7))+1;
   n_tf := n_fd;
   n_tp := n_pd;
   n_tdp := n_dpp *  n_pd;


   INSERT INTO CUBE1 (  STANZA , METRIC ,DATA_VALUE , DATA_DATE )    
    values (v_recv,v_fd,n_fd ,v_date);

   INSERT INTO CUBE1 (  STANZA , METRIC ,DATA_VALUE , DATA_DATE )    
        values (v_recv,v_pd,n_pd ,v_date);

   INSERT INTO CUBE1 (  STANZA , METRIC ,DATA_VALUE , DATA_DATE )    
        values (v_recv,v_pf,n_pf ,v_date);

   INSERT INTO CUBE1 (  STANZA , METRIC ,DATA_VALUE , DATA_DATE )    
        values (v_recv,v_dpp,n_dpp ,v_date);

   INSERT INTO CUBE1 (  STANZA , METRIC ,DATA_VALUE , DATA_DATE )    
        values (v_recv,v_tf,n_tf ,v_date);

   INSERT INTO CUBE1 (  STANZA , METRIC ,DATA_VALUE , DATA_DATE )    
        values (v_recv,v_tp,n_tp ,v_date);

   INSERT INTO CUBE1 (  STANZA , METRIC ,DATA_VALUE , DATA_DATE )    
        values (v_recv,v_tdp,n_tdp ,v_date);
   

 --- Completed         

   n_fd := abs(mod(dbms_random.random,200))+44;
   n_pd := abs(mod(dbms_random.random,10000))+1001;
   n_pf := round(n_pd/n_fd,1);
   n_dpp := abs(mod(dbms_random.random,7))+1;
   n_tf := n_fd;
   n_tp := n_pd;
   n_tdp := n_dpp *  n_pd;


   INSERT INTO CUBE1 (  STANZA , METRIC ,DATA_VALUE , DATA_DATE )    
    values (v_comp,v_fd,n_fd ,v_date);

   INSERT INTO CUBE1 (  STANZA , METRIC ,DATA_VALUE , DATA_DATE )    
        values (v_comp,v_pd,n_pd ,v_date);

   INSERT INTO CUBE1 (  STANZA , METRIC ,DATA_VALUE , DATA_DATE )    
        values (v_comp,v_pf,n_pf ,v_date);

   INSERT INTO CUBE1 (  STANZA , METRIC ,DATA_VALUE , DATA_DATE )    
        values (v_comp,v_dpp,n_dpp ,v_date);

   INSERT INTO CUBE1 (  STANZA , METRIC ,DATA_VALUE , DATA_DATE )    
        values (v_comp,v_tf,n_tf ,v_date);

   INSERT INTO CUBE1 (  STANZA , METRIC ,DATA_VALUE , DATA_DATE )    
        values (v_comp,v_tp,n_tp ,v_date);

   INSERT INTO CUBE1 (  STANZA , METRIC ,DATA_VALUE , DATA_DATE )    
        values (v_comp,v_tdp,n_tdp ,v_date);


  --cancelled billable v_canbl
   n_fd := abs(mod(dbms_random.random,200))+44;
   n_pd := abs(mod(dbms_random.random,10000))+1001;
   n_pf := round(n_pd/n_fd,1);
   n_dpp := abs(mod(dbms_random.random,7))+1;
   n_tf := n_fd;
   n_tp := n_pd;
   n_tdp := n_dpp *  n_pd;


   INSERT INTO CUBE1 (  STANZA , METRIC ,DATA_VALUE , DATA_DATE )    
    values (v_canbl,v_fd,n_fd ,v_date);

   INSERT INTO CUBE1 (  STANZA , METRIC ,DATA_VALUE , DATA_DATE )    
        values (v_canbl,v_pd,n_pd ,v_date);

   INSERT INTO CUBE1 (  STANZA , METRIC ,DATA_VALUE , DATA_DATE )    
        values (v_canbl,v_pf,n_pf ,v_date);

   INSERT INTO CUBE1 (  STANZA , METRIC ,DATA_VALUE , DATA_DATE )    
        values (v_canbl,v_dpp,n_dpp ,v_date);

   INSERT INTO CUBE1 (  STANZA , METRIC ,DATA_VALUE , DATA_DATE )    
        values (v_canbl,v_tf,n_tf ,v_date);

   INSERT INTO CUBE1 (  STANZA , METRIC ,DATA_VALUE , DATA_DATE )    
        values (v_canbl,v_tp,n_tp ,v_date);

   INSERT INTO CUBE1 (  STANZA , METRIC ,DATA_VALUE , DATA_DATE )    
        values (v_canbl,v_tdp,n_tdp ,v_date);



  --cancelled billable v_cannb
   n_fd := abs(mod(dbms_random.random,200))+44;
   n_pd := abs(mod(dbms_random.random,10000))+1001;
   n_pf := round(n_pd/n_fd,1);
   n_dpp := abs(mod(dbms_random.random,7))+1;
   n_tf := n_fd;
   n_tp := n_pd;
   n_tdp := n_dpp *  n_pd;


   INSERT INTO CUBE1 (  STANZA , METRIC ,DATA_VALUE , DATA_DATE )    
    values (v_cannb,v_fd,n_fd ,v_date);

   INSERT INTO CUBE1 (  STANZA , METRIC ,DATA_VALUE , DATA_DATE )    
        values (v_cannb,v_pd,n_pd ,v_date);

   INSERT INTO CUBE1 (  STANZA , METRIC ,DATA_VALUE , DATA_DATE )    
        values (v_cannb,v_pf,n_pf ,v_date);

   INSERT INTO CUBE1 (  STANZA , METRIC ,DATA_VALUE , DATA_DATE )    
        values (v_cannb,v_dpp,n_dpp ,v_date);

   INSERT INTO CUBE1 (  STANZA , METRIC ,DATA_VALUE , DATA_DATE )    
        values (v_cannb,v_tf,n_tf ,v_date);

   INSERT INTO CUBE1 (  STANZA , METRIC ,DATA_VALUE , DATA_DATE )    
        values (v_cannb,v_tp,n_tp ,v_date);

   INSERT INTO CUBE1 (  STANZA , METRIC ,DATA_VALUE , DATA_DATE )    
        values (v_cannb,v_tdp,n_tdp ,v_date);




  -- Forward at period end
   n_fd := abs(mod(dbms_random.random,200))+44;
   n_pd := abs(mod(dbms_random.random,10000))+1001;
   n_pf := round(n_pd/n_fd,1);
   n_dpp := abs(mod(dbms_random.random,7))+1;
   n_tf := n_fd;
   n_tp := n_pd;
   n_tdp := n_dpp *  n_pd;


   INSERT INTO CUBE1 (  STANZA , METRIC ,DATA_VALUE , DATA_DATE )    
    values (v_fwd,v_pd,n_fd ,v_date);

   INSERT INTO CUBE1 (  STANZA , METRIC ,DATA_VALUE , DATA_DATE )    
        values (v_fwd,v_pd,n_pd ,v_date);

   INSERT INTO CUBE1 (  STANZA , METRIC ,DATA_VALUE , DATA_DATE )    
        values (v_fwd,v_pf,n_pf ,v_date);

   INSERT INTO CUBE1 (  STANZA , METRIC ,DATA_VALUE , DATA_DATE )    
        values (v_fwd,v_dpp,n_dpp ,v_date);

   INSERT INTO CUBE1 (  STANZA , METRIC ,DATA_VALUE , DATA_DATE )    
        values (v_fwd,v_tf,n_tf ,v_date);

   INSERT INTO CUBE1 (  STANZA , METRIC ,DATA_VALUE , DATA_DATE )    
        values (v_fwd,v_tp,n_tp ,v_date);

   INSERT INTO CUBE1 (  STANZA , METRIC ,DATA_VALUE , DATA_DATE )    
        values (v_fwd,v_tdp,n_tdp ,v_date);



       COMMIT;

  END Loop;
            
       EXCEPTION WHEN OTHERS THEN LOG_APEX_ERROR(1);
             
       END;

/

