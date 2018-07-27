--------------------------------------------------------
--  DDL for Procedure LOAD_IWS_CUBES
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "SNX_IWS2"."LOAD_IWS_CUBES" 
  -- Program name - LOAD_IWS_CUBES
  -- Created 11-14-2012 R Benzell
  -- For Populate IWS Cubes for Operational Reporting
 /***
    begin
    LOAD_IWS_CUBES(999);
    end;
***/
    
    (P_DAYS IN NUMBER default 9999)  

 
  
         IS
    
    T_CASE_STATS CASE_STATS%rowtype;
    T_CLIENT_STATS CLIENT_STATS%rowtype;

    T_ERROR_LISTING ERROR_LISTING%rowtype;
    --L_CLIENT_STATS CLIENT_STATS%rowtype;


    v_return varchar2(200);

    i number;
    w number;
    p number;
    v_count number;
    v_date date;

   
    
    

    
     BEGIN
         
     htp.p('LOAD_IWS_CUBES started at: ' || to_char(sysdate,'YYYY-MM-DD HH24:MI.SS'));   
         
     --- Temp Feature - clear cubes before each run    
      DELETE FROM CASE_STATS; 
      DELETE FROM CLIENT_STATS;
      DELETE FROM ERROR_LISTING;
         
      -------------------------------------
      ----- CASE STATS   -------
      -------------------------------------         
           I := 0;   
           P := 0;   
           W := 0;   
           for A in
           ( SELECT  CASEID,CLIENTID,TOTALPAGES,RECEIPTTIMESTAMP,STAGEID,CLIENTFILENAME
                from CASES
                WHERE  RECEIPTTIMESTAMP > (sysdate-P_DAYS)
             ORDER BY CASEID ASC  )
            LOOP   
              I := I + 1;
              T_CASE_STATS := NULL;

     
              T_CASE_STATS.CASEID      := A.CASEID;
              T_CASE_STATS.CLIENTID    := A.CLIENTID; 
              T_CASE_STATS.CLIENT_FILENAME := A.CLIENTFILENAME; 
              T_CASE_STATS.TOTAL_PAGES := A.TOTALPAGES;
              T_CASE_STATS.RECEIVED_ON := A.RECEIPTTIMESTAMP;
              T_CASE_STATS.STAGEID     := A.STAGEID;

             Select max(STAGESTARTTIMESTAMP) into T_CASE_STATS.PUBLISHED_ON
             from casehistorysum where caseid=A.CASEID
             and STAGEID IN (31,63,64)  --published, published PDF, published XML
             and STAGESTARTTIMESTAMP is not null;

             IF T_CASE_STATS.PUBLISHED_ON IS NOT NULL 
               THEN --- convert milliseconds to minutes
                  T_CASE_STATS.CASE_PROCESSING_TIME := ROUND(TIMESTAMP_DIFF(
                      T_CASE_STATS.RECEIVED_ON,T_CASE_STATS.PUBLISHED_ON ) / (1000*60));
               ELSE
                   T_CASE_STATS.CASE_PROCESSING_TIME := NULL;
             END IF;


              T_CASE_STATS.TOTAL_DP_COUNT := DATAPOINT_COUNT(A.CASEID);
              T_CASE_STATS.OPPORTUNITY_COUNT := CASE_OPPORTUNITY_COUNT(A.CASEID);

             --- Error Count 
             SELECT count(*) into T_CASE_STATS.ERROR_COUNT 
             FROM AUDITLOG aud  
             WHERE (aud.originalvalue <> aud.modifiedvalue  -- if value changed
             OR (aud.originalvalue IS NULL AND aud.modifiedvalue IS NOT NULL)   -- if new value entered
             OR (aud.originalvalue IS NOT NULL AND aud.modifiedvalue IS NULL))   -- if value deleted
             AND aud.objecttype IN ( 
             'DPENTRIES.DATADATE',   -- if data date changed
             'DPENTRIES.DATAFIELD1VALUE', 'DPENTRIES.DATAFIELD2VALUE', 'DPENTRIES.DATAFIELD3VALUE', 'DPENTRIES.DATAFIELD4VALUE',   -- if data field value changed
             'DPENTRIES.DATAFIELD5VALUE', 'DPENTRIES.DATAFIELD6VALUE', 'DPENTRIES.DATAFIELD7VALUE', 'DPENTRIES.DATAFIELD8VALUE',   -- if data field value changed
             'DPENTRIES.DATAFIELD9VALUE', 'DPENTRIES.DATAFIELD10VALUE', 'DPENTRIES.DATAFIELD11VALUE', 'DPENTRIES.DATAFIELD12VALUE',   -- if data field value changed
             'DPENTRIES.HID',  -- if code is replaced
             'DPENTRIES.SUSPENDNOTE', -- if review note entered in QA Review step
             'DPENTRIES.PAGEID', 'DPENTRIES.STARTSECTIONNUMBER', 'DPENTRIES.ENDSECTIONNUMBER')  -- if page/section changed
              AND aud.timestamp >= (SELECT MAX(ch.stagecompletiontimestamp) FROM casehistorysum ch 
                         WHERE stagecompletiontimestamp is not null and stageid=6 and ch.caseid=aud.caseid)   -- capture changed DP entries since last stage change from 2-op to 2-qc1
              AND aud.Caseid = A.CASEID;
              

             IF T_CASE_STATS.OPPORTUNITY_COUNT > 0 -- Avoid divide by 0 errors
               THEN  T_CASE_STATS.QUALITY_EFFICIENCY :=
                   round(100 - (( T_CASE_STATS.ERROR_COUNT/T_CASE_STATS.OPPORTUNITY_COUNT)*100),1);
               ELSE T_CASE_STATS.QUALITY_EFFICIENCY := 0;
             END IF;

          
      -- OP Statistic processing     
      --Return just the LAST OP users who worked on this case 
       BEGIN
        select USERID into T_CASE_STATS.OP2_USERID
          from CASEHISTORYSUM 
          WHERE CHID = (select max(CHID) 
                      from casehistorysum where caseid=A.CASEID 
              and stageid IN (6,8,10,52,66,67,68) );
         -- htp.p('userid ' || A.CASEID || ' = '  || T_CASE_STATS.OP2_USERID);
         EXCEPTION WHEN  OTHERS THEN T_CASE_STATS.OP2_USERID := NULL;
        END;

     --- OP Started
       BEGIN
        select min(ASSIGNMENTSTARTTIMESTAMP) 
          into  T_CASE_STATS.OP2_STARTED_ON  
          from casehistorysum where caseid=A.CASEID
           and stageid IN (6,8,10,52,66,67,68) and userid is not null;
         EXCEPTION WHEN OTHERS THEN  T_CASE_STATS.OP2_STARTED_ON := null;
        END;


     --- Op finished
       BEGIN
        select max(ASSIGNMENTCOMPLETIONTIMESTAMP) 
          into  T_CASE_STATS.OP2_FINISHED_ON  
          from casehistorysum 
             where caseid=A.CASEID
           and stageid IN (6,8,10,52,66,67,68) and userid is not null;
         EXCEPTION WHEN OTHERS THEN T_CASE_STATS.OP2_FINISHED_ON := null;
        END;


     --- Calculate Elapsed OP time  
         IF T_CASE_STATS.OP2_STARTED_ON  IS NOT NULL AND 
            T_CASE_STATS.OP2_FINISHED_ON IS NOT NULL
              THEN --- convert milliseconds to minutes
                  T_CASE_STATS.OP2_PROCESSING_TIME := ROUND(TIMESTAMP_DIFF(
                      T_CASE_STATS.OP2_STARTED_ON,T_CASE_STATS.OP2_FINISHED_ON ) / (1000*60));
               ELSE
                   T_CASE_STATS.OP2_PROCESSING_TIME := NULL;
        END IF;


      -- OP Statistic processing  
       --Return just the LAST QC1 users who worked on this case
       BEGIN
        select USERID into T_CASE_STATS.QC1_USERID
          from CASEHISTORYSUM
          WHERE CHID = (select max(CHID) 
                      from casehistorysum where caseid=A.CASEID 
              and stageid in (7,69) );
         EXCEPTION WHEN OTHERS THEN T_CASE_STATS.QC1_USERID := null;
        END;

   --- Determine the starting  QC1 date/time this step was began on
       BEGIN
        select min(ASSIGNMENTSTARTTIMESTAMP) 
          into  T_CASE_STATS.QC1_STARTED_ON  
          from casehistorysum where caseid=A.CASEID
           and stageid IN (7,69) and userid is not null;
         EXCEPTION WHEN OTHERS THEN T_CASE_STATS.QC1_STARTED_ON := null;
        END;

        --- Determine the final QC1 date/time this step was worked on
       BEGIN
        select max(ASSIGNMENTCOMPLETIONTIMESTAMP) 
          into   T_CASE_STATS.QC1_FINISHED_ON  
          from casehistorysum where caseid=A.CASEID
          and stageid in (7,69) and userid is not null;
         EXCEPTION WHEN OTHERS THEN T_CASE_STATS.QC1_FINISHED_ON := null;
        END;

     --- Calculate Elapsed QC time  
         IF T_CASE_STATS.QC1_STARTED_ON  IS NOT NULL AND 
            T_CASE_STATS.QC1_FINISHED_ON IS NOT NULL
              THEN --- convert milliseconds to minutes
                  T_CASE_STATS.QC1_PROCESSING_TIME := ROUND(TIMESTAMP_DIFF(
                      T_CASE_STATS.QC1_STARTED_ON,T_CASE_STATS.QC1_FINISHED_ON ) / (1000*60));
               ELSE
                   T_CASE_STATS.QC1_PROCESSING_TIME := NULL;
        END IF;


       IF A.STAGEID = 31 or  A.STAGEID = 63 or A.STAGEID = 64      
          THEN T_CASE_STATS.STATUS := 'PUBLISHED';
          ELSE T_CASE_STATS.STATUS := 'ACTIVE';                       
       END IF;      
             
             --- See if existing stats are to be updated, or created anew
             -- select count(CASEID) into v_count
             --     from CASE_STATS where CASEID =  T_CASE_STATS.CASEID ;
              --IF v_count = 1
              --    then INSERT INTO CASE_STATS T_CASE_STATS;
               --   else    
              -- DELETE FROM CASE_STATS where  CASEID =  T_CASE_STATS.CASEID; 
        INSERT INTO CASE_STATS values T_CASE_STATS;

        COMMIT;

       END LOOP; 

     htp.p('CASE_STATS - Insert Count = ' || I);



      -------------------------------------
      ----- CLIENT STATS   -------
      -------------------------------------         
 
     --- Slice from Case Stats
     --- Build up ROW

           I := 0;   
           for A in
           (  SELECT  CLIENTID             CLIENTID  ,
                      trunc(RECEIVED_ON)   ACTIVITY_DATE,
                      nvl(sum(TOTAL_PAGES),0)     SUM_TOTAL_PAGES, 
                      nvl(sum(TOTAL_DP_COUNT),0)  SUM_TOTAL_DP_COUNT,
                      DECODE(STAGEID,31,'PUB',
                                     63,'PUB',
                                     64,'PUB',
                                     'INPROC')  STATUS,
                      nvl(count(*),0)             FILE_COUNT
                from CASE_STATS
               --WHERE RECEIVED_ON > (sysdate-P_DAYS)
             GROUP BY CLIENTID,trunc(RECEIVED_ON), 
                DECODE(STAGEID,31,'PUB',
                               63,'PUB',
                               64,'PUB',
                              'INPROC') 
               order by 1,2,3,4)
               
            LOOP   


            --- See if we have a new client or activity date requiring a write of the last row
              IF  T_CLIENT_STATS.CLIENTID <> A.CLIENTID  OR
                  T_CLIENT_STATS.ACTIVITY_DATE <> A.ACTIVITY_DATE
                  Then
                      I := I + 1;
                      INSERT INTO CLIENT_STATS values T_CLIENT_STATS;
                      COMMIT;
                      T_CLIENT_STATS := NULL;
                      T_CLIENT_STATS.PUBLISHED_FILE_COUNT := 0;
                      T_CLIENT_STATS.PUBLISHED_PAGE_COUNT := 0;
                      T_CLIENT_STATS.PUBLISHED_DATAPOINT_COUNT := 0;
                      T_CLIENT_STATS.INPROCESS_FILE_COUNT := 0;
                      T_CLIENT_STATS.INPROCESS_PAGE_COUNT := 0;


               END IF;           
                  

              T_CLIENT_STATS.CLIENTID := A.CLIENTID; 
              T_CLIENT_STATS.ACTIVITY_DATE := A.ACTIVITY_DATE;

             CASE
              WHEN A.STATUS = 'PUB' THEN
                 T_CLIENT_STATS.PUBLISHED_FILE_COUNT := A.FILE_COUNT;
                 T_CLIENT_STATS.PUBLISHED_PAGE_COUNT := A.SUM_TOTAL_PAGES;
                 T_CLIENT_STATS.PUBLISHED_DATAPOINT_COUNT := A.SUM_TOTAL_DP_COUNT;
                 P := P + 1;

             WHEN A.STATUS = 'INPROC' THEN
                 T_CLIENT_STATS.INPROCESS_FILE_COUNT := A.FILE_COUNT;
                 T_CLIENT_STATS.INPROCESS_PAGE_COUNT := A.SUM_TOTAL_PAGES;
                 W := W + 1;


             ELSE null;

             END CASE;

             T_CLIENT_STATS.RECEIVED_FILE_COUNT := 
                 nvl(T_CLIENT_STATS.PUBLISHED_FILE_COUNT+T_CLIENT_STATS.INPROCESS_FILE_COUNT,0);
             T_CLIENT_STATS.RECEIVED_PAGE_COUNT := 
                 nvl(T_CLIENT_STATS.PUBLISHED_PAGE_COUNT+T_CLIENT_STATS.INPROCESS_PAGE_COUNT,0);
             
              --T_CASE_STATS.TOTAL_PAGES := A.TOTALPAGES;
              --T_CASE_STATS.RECEIVED_ON := A.RECEIPTTIMESTAMP;
              --T_CASE_STATS.STAGEID     := A.STAGEID;
               


            END LOOP;
     
         --- Complete and Write out the last buffered row  
             I := I + 1;
             T_CLIENT_STATS.RECEIVED_FILE_COUNT := 
                 nvl(T_CLIENT_STATS.PUBLISHED_FILE_COUNT+T_CLIENT_STATS.INPROCESS_FILE_COUNT,0);
             T_CLIENT_STATS.RECEIVED_PAGE_COUNT := 
                 nvl(T_CLIENT_STATS.PUBLISHED_PAGE_COUNT+T_CLIENT_STATS.INPROCESS_PAGE_COUNT,0);

           INSERT INTO CLIENT_STATS values T_CLIENT_STATS;
           COMMIT;

           htp.p('CLIENT_STATS - Insert Count = ' || I || ' pub=' || P || ' inworks=' || W);




   -------------------------------------
   ----- CHANGE LISTING  -------
   -------------------------------------         

i := 0;

FOR A IN            
 (select *
  from (
SELECT 
  C.CLIENTID,
  aud.caseid,    
  aud.ORIGINALUSERID,
  aud.USERID,
  aud.TIMESTAMP,
  aud.STAGEID,
  aud.objectid dpentryid,  
  substr(aud.objecttype,11) field_name, 
  aud.originalvalue,  
  aud.modifiedvalue,
 aud.logid
  FROM AUDITLOG aud,  
      CASES C
  WHERE C.CASEID = AUD.CASEID AND
      (aud.originalvalue <> aud.modifiedvalue  -- if value changed
  OR (aud.originalvalue IS NULL AND aud.modifiedvalue IS NOT NULL)   -- if new value entered
  OR (aud.originalvalue IS NOT NULL AND aud.modifiedvalue IS NULL))   -- if value deleted
  AND aud.objecttype IN ( 
   'DPENTRIES.DATADATE',   -- if data date changed
   'DPENTRIES.DATAFIELD1VALUE', 'DPENTRIES.DATAFIELD2VALUE', 'DPENTRIES.DATAFIELD3VALUE', 'DPENTRIES.DATAFIELD4VALUE',   -- if data field value changed
   'DPENTRIES.DATAFIELD5VALUE', 'DPENTRIES.DATAFIELD6VALUE', 'DPENTRIES.DATAFIELD7VALUE', 'DPENTRIES.DATAFIELD8VALUE',   -- if data field value changed
   'DPENTRIES.DATAFIELD9VALUE', 'DPENTRIES.DATAFIELD10VALUE', 'DPENTRIES.DATAFIELD11VALUE', 'DPENTRIES.DATAFIELD12VALUE',   -- if data field value changed
   'DPENTRIES.HID',  -- if code is replaced
   'DPENTRIES.SUSPENDNOTE', -- if review note entered in QA Review step
   'DPENTRIES.PAGEID', 'DPENTRIES.STARTSECTIONNUMBER', 'DPENTRIES.ENDSECTIONNUMBER')  -- if page/section changed
  AND aud.timestamp >= (SELECT MAX(ch.stagecompletiontimestamp) FROM casehistorysum ch 
                        WHERE stagecompletiontimestamp is not null and stageid=6 and ch.caseid=aud.caseid)   -- capture changed DP entries since last stage change from 2-op to 2-qc1
  )
    order by field_name,logid)
  
 LOOP
    I := I + 1; 
    -- htp.p(I || ' '||  A.originalvalue || '=>' || A.modifiedvalue ||'<br>');
    T_ERROR_LISTING.CLIENTID         := A.CLIENTID;
    T_ERROR_LISTING.CASEID           := A.CASEID;
    T_ERROR_LISTING.FIELD_NAME       := A.FIELD_NAME;
    T_ERROR_LISTING.DPENTRYID        := A.DPENTRYID;
    T_ERROR_LISTING.LOGID            := A.LOGID;
    T_ERROR_LISTING.ORIGINAL_VALUE   := A.originalvalue;
    T_ERROR_LISTING.ORIGINAL_USERID  := A.ORIGINALUSERID;
    T_ERROR_LISTING.MODIFIED_VALUE   := A.modifiedvalue;
    T_ERROR_LISTING.MODIFIED_USERID  := A.USERID;
    T_ERROR_LISTING.MODIFIED_ON      := A.TIMESTAMP;
    T_ERROR_LISTING.MODIFIED_STAGEID := A.STAGEID;


   INSERT INTO ERROR_LISTING values T_ERROR_LISTING;
   COMMIT;
     
  END LOOP;
     
  htp.p('ERROR_LISTING - Insert Count = ' || I  );
          
  htp.p('LOAD_IWS_CUBES completed at: ' || to_char(sysdate,'YYYY-MM-DD HH24:MI.SS'));   


       
       EXCEPTION WHEN OTHERS THEN 
             LOG_APEX_ERROR(1);

     END;



/

