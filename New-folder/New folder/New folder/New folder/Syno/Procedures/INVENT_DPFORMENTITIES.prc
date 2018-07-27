--------------------------------------------------------
--  DDL for Procedure INVENT_DPFORMENTITIES
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "SNX_IWS2"."INVENT_DPFORMENTITIES" 
  -- Program name - INVENT_DPFORMENTITIES
  -- Created 9-26-2011 R Benzell
  -- For initial testing, create DPFORMENTITIES populating based on all existing sub-categories
  --
/** First, make sure this view, or something like it, exists:
Create or replace View dpsubcategories_view as
select B.DPCATEGORYNAME,A.DPSUBCATNAME ,A.DPSUBCATID,    A.DPCATEGORYID    
   from dpsubcategories A,
        dpcategories B
  WHERE A.DPCATEGORYID    =B.DPCATEGORYID(+)
order by A.DPCATEGORYID,DPSUBCATID
    
--to test    
begin
  INVENT_DPFORMENTITIES();
end;    
    
***/
    
    (P_RUN IN VARCHAR2 default NULL)  
               
  
         IS
 
 
         BEGIN
             --- Parse the line into separate elements
     INSERT INTO DPFORMENTITIES
      (       
          "DPCATEGORYID" ,
          "DPSUBCATID" ,
          "DISPLAYLABEL" ,
          "ISDATEREQUIRED",
          "ISSTATUSREQUIRED" ,
          "ISUNIQUEPERCASE" , 
          "LOVID" , 
          "CREATED_TIMESTAMP",
          "CREATED_USERID" ) 
        ( SELECT
          "DPCATEGORYID",
          "DPSUBCATID" ,
          DPCATEGORYNAME||'-'||DPSUBCATNAME,
          'N',
          'N',
          'N',
          1,
          systimestamp,
          3            
            from dpsubcategories_view);  
        COMMIT;
            
       EXCEPTION WHEN OTHERS THEN LOG_APEX_ERROR(15);
             
       END;

/

