create or replace PACKAGE BODY CASEHISTORY_PACK AS
--- Program name  CASEHISTORY_PACK 
--- Created 3-10-2012 R Benzell
 
    
FUNCTION CASEHISTORY_FUNC RETURN CASEHISTORY_TYPE PIPELINED IS 
 I Number;
 v_last_case number;
 v_last_ASSIGNMENT timestamp;
 v_last_STAGESTART timestamp;
 v_last_STAGEstop  timestamp;
 v_last_userid number;
 
 v_Use_ASSIGNMENT timestamp;
 v_Use_STAGESTART timestamp;
 v_Use_STAGEstop  timestamp;
    
--- Update History
--- 3-16-2016 R Benzell - capture assignment status changes
 
 
BEGIN
    
    I := 0;
    
  --iiFOR i in 1 .. 5
     for A in
         (
          select
             CASEID , 
             USERID , 
             STAGEID , 
             STAGESTARTTIMESTAMP, 
             STAGECOMPLETIONTIMESTAMP , 
             ASSIGNEDBY , 
             CHID  , 
             CREATED_TIMESTAMP , 
             CREATED_USERID , 
             CREATED_STAGEID , 
             UPDATED_TIMESTAMP , 
             UPDATED_USERID , 
             UPDATED_STAGEID  , 
             ASSIGNMENTTIMESTAMP FROM CASEHISTORY
             order by caseid desc, created_timestamp asc
           )
    LOOP
      I := I+1;
 
  -- Fill in missing timestamps if possible
      IF A.STAGESTARTTIMESTAMP IS NULL and 
         A.CASEID = v_last_case
        Then v_Use_STAGESTART := v_last_STAGESTART;
        ELSE v_Use_STAGESTART := A.STAGESTARTTIMESTAMP;
       END IF;
 
    IF A.STAGECOMPLETIONTIMESTAMP IS NULL and
         A.CASEID = v_last_case
        Then v_Use_STAGESTART := v_last_STAGEStop;
        ELSE v_Use_STAGEStop := A.STAGECOMPLETIONTIMESTAMP ;
       END IF;
 
   -- IF A.ASSIGNMENTTIMESTAMP IS NULL and
   --      A.CASEID = v_last_case
   --     Then v_Use_ASSIGNMENT := v_last_ASSIGNMENT;
   --     ELSE v_Use_ASSIGNMENT := A.ASSIGNMENTTIMESTAMP ;
   --    END IF;
 
 
 
    --- Only write out row if we have both stop and start times
    --- this prevents writes of the first Start row that does not have a Stop time
     --- OR - write out if USERID has changed
     IF   (v_Use_STAGESTART IS NOT NULL AND
           v_Use_STAGEStop IS NOT NULL AND
           v_Use_STAGESTART <> v_Use_STAGEStop ) 
           OR A.USERID IS NULL OR v_last_userid <> A.USERID
        --   OR  ( A.ASSIGNMENTTIMESTAMP IS NOT NULL AND  v_last_userid <> A.USERID )
         --( v_Use_STAGESTART <> v_last_STAGESTART AND v_Use_STAGESTOP <> v_last_STAGEStop)
      THEN
      PIPE ROW (
             CASEHISTORY_FORMAT(
             I ,
             A.CASEID ,
             v_last_userid,  --A.USERID ,
             A.STAGEID ,
             v_Use_STAGESTART ,
             v_Use_STAGEStop ,
             round(SECONDS_BETWEEN_TIMESTAMPS(v_Use_STAGESTART,v_Use_STAGEStop)),
             A.ASSIGNEDBY ,
             A.CHID  ,
             A.CREATED_TIMESTAMP ,
             A.CREATED_USERID ,
             A.CREATED_STAGEID ,
             A.UPDATED_TIMESTAMP ,
             A.UPDATED_USERID ,
             A.UPDATED_STAGEID  ,
             A.ASSIGNMENTTIMESTAMP
          ));
      END IF;
 
 
 
     --- remember values for next loop
       v_last_case := A.CASEID;
       v_last_userid := A.USERID;
 
       IF A.STAGESTARTTIMESTAMP IS NOT NULL
        then v_last_STAGESTART := A.STAGESTARTTIMESTAMP;
       END IF;
 
       IF A.STAGECOMPLETIONTIMESTAMP IS NOT NULL
        then v_last_STAGEStop := A.STAGECOMPLETIONTIMESTAMP ;
       END IF;
 
      -- IF A.ASSIGNMENTTIMESTAMP IS NOT NULL
      --  then v_last_ASSIGNMENT := A.ASSIGNMENTTIMESTAMP ;
     --  END IF;
 
    END LOOP;
    RETURN;
  END;
END;
