create or replace FUNCTION            "STATUS_ICON" 
      ( P_CASEID  number default NULL,  
        P_STAGEID number default NULL,
        P_USERID   number default NULL
       )
    
    -- Created 11-01-2011 R Benzell
    -- Returns a Text of an appropriate icon 
    -- Update History
    -- 11-2-2011 R Benzell
    -- Added specific Icons for  Recieved Stages, and for Unknown 
    -- 12-1-2011 R Benzell
    -- Added icons for Ready to Generate, Releasing, BlackBox Step3/4 Error, Reporting Error, 
    --  Publishing Error, Generating
    -- 12-6-2011 R Benzell
    -- Created Separate BB Running Icons for 3 and 4
    -- 6-7-2012 R Benzell
    --  Added Op2-2 and TR-2 Icons
    -- 9-4-2012 R Benzell Added ReviewQA Icons
    -- 10-1-2012 R Benzell added Fileview Icons, changed BlackBox -> QCAI Icons
    -- 11-12-2012 R Benzell  added DR, RX and Nurse Icons    
    -- 11-19-2012 R Benzell  added Cancelled Icon  
    -- 11-21-2012 R Benzell Changed NS to LT, changed FileViewer to FV-OP
    -- 02-21-2013 R Benzell Added POP2 Stage
    -- 03-12-2013 R Benzell.  For POP stages, view PARALLELCASESTATUS to Determine Assignment
   
    
--- Icon names (in /ORACLE/fmw/Oracle_OHS1/instances/instance1/config/OHS/ohs1/images)
   

    

    
        RETURN VARCHAR2 
    
        IS
    
        v_Return Varchar2(500) default null;
        v_UserId Number  default null;
        v_Parallelism Number  default null;

        --v_random number;
      
        BEGIN
        
/****
STAGENAME    STAGEID
Received    1
Step-1-OP    4
Step-1-QA    5
Step-2-OP    6
Step-2-OP2   48            
Step-2-TR    49
Step-2-QA    7
Step-3-BB    28
Step-3-BB-RUN    41
Step-3-OP    8
Step-3-QA    9
Step-4-BB    29
Step-4-BB-RUN    42
Step-4-OP    10
Step-4-QA    11
Ready to Generate    12
Pre-Release QA    30
Ready to Release    13
Published    31 
ReviewQA.png  50
*****/
            
            
 --- If Parallel Stage and V_USERID is null, use PARALLELCASESTATUS to determine if assigned.
 --- else, simple use V_USERID
            
    Select PARALLELISM into v_PARALLELISM
           from STAGES        
           WHERE STAGEID = P_STAGEID; 
            
    IF  v_PARALLELISM > 0 
        then 
           select max(USERID) into v_USERID
           from PARALLELCASESTATUS
           WHERE STAGEID = P_STAGEID;
       else 
          v_USERID := P_USERID;
    END IF;        
    
         CASE
            
          --- Received from client
            WHEN P_STAGEID = 1
              then v_Return  := '/i/Received.png';

          --- Unassigned OPs
            WHEN V_USERID is NULL and P_STAGEID = 4
              then v_Return  := '/i/UnAssignedOP-1.png';

            WHEN V_USERID is NULL and P_STAGEID = 6
              then v_Return  := '/i/UnAssignedOP-2.png';

            WHEN V_USERID is NULL and P_STAGEID = 48
              then v_Return  := '/i/UnAssignedOP2-2.png';

            WHEN V_USERID is NULL and P_STAGEID = 8
              then v_Return  := '/i/UnAssignedOP-3.png';

            WHEN V_USERID is NULL and P_STAGEID = 10
              then v_Return  := '/i/UnAssignedOP-4.png';

            WHEN V_USERID is NULL and P_STAGEID = 66
              then v_Return  := '/i/UnAssignedRX.png';

            WHEN V_USERID is NULL and P_STAGEID = 67
              then v_Return  := '/i/UnAssignedLT.png';

            WHEN V_USERID is NULL and P_STAGEID = 68
              then v_Return  := '/i/UnAssignedDR.png';

          --- Unassigned QAs
            WHEN V_USERID is NULL and P_STAGEID = 5
              then v_Return  := '/i/UnAssignedQA-1.png';

            WHEN V_USERID is NULL and P_STAGEID = 7
              then v_Return  := '/i/UnAssignedQA-2.png';

            WHEN V_USERID is NULL and P_STAGEID = 9
              then v_Return  := '/i/UnAssignedQA-3.png';

            WHEN V_USERID is NULL and P_STAGEID = 11
              then v_Return  := '/i/UnAssignedQA-4.png';

            WHEN V_USERID is NULL and P_STAGEID = 71
              then v_Return  := '/i/UnAssignedPOP2.png';


          --- Assigned OPs
            WHEN V_USERID is NOT NULL and P_STAGEID = 4
              then v_Return  := '/i/AssignedOP-1.png';

            WHEN V_USERID is NOT NULL and P_STAGEID = 6
              then v_Return  := '/i/AssignedOP-2.png';

            WHEN V_USERID is NOT NULL and P_STAGEID = 48
              then v_Return  := '/i/AssignedOP2-2.png';

            WHEN V_USERID is NOT NULL and P_STAGEID = 8
              then v_Return  := '/i/AssignedOP-3.png';

            WHEN V_USERID is NOT NULL and P_STAGEID = 10
              then v_Return  := '/i/AssignedOP-4.png';

          --- Assigned QAs
            WHEN V_USERID is NOT NULL and P_STAGEID = 5
              then v_Return  := '/i/AssignedQA-1.png';

            WHEN V_USERID is NOT NULL and P_STAGEID = 7
              then v_Return  := '/i/AssignedQA-2.png';

            WHEN V_USERID is NOT NULL and P_STAGEID = 9
              then v_Return  := '/i/AssignedQA-3.png';

            WHEN V_USERID is NOT NULL and P_STAGEID = 11
              then v_Return  := '/i/AssignedQA-4.png';

            WHEN V_USERID is NOT NULL and P_STAGEID = 66
              then v_Return  := '/i/AssignedRX.png';

            WHEN V_USERID is NOT NULL and P_STAGEID = 67
              then v_Return  := '/i/AssignedLT.png';

            WHEN V_USERID is NOT NULL and P_STAGEID = 68
              then v_Return  := '/i/AssignedDR.png';

            WHEN V_USERID is NOT NULL and P_STAGEID = 71
              then v_Return  := '/i/AssignedPOP2.png';


          --- Transcription Steps
            WHEN V_USERID is NOT NULL and P_STAGEID = 49
              then v_Return  := '/i/AssignedTR-2.png';

            WHEN V_USERID is NULL and P_STAGEID = 49
              then v_Return  := '/i/UnAssignedTR-2.png';


          --- FileViewer Steps
            WHEN V_USERID is NOT NULL and P_STAGEID = 52
              then v_Return  := '/i/AssignedFVOP.png';
              --then v_Return  := '/i/AssignedFileViewer.png';

            WHEN V_USERID is NULL and P_STAGEID = 52
              then v_Return  := '/i/UnAssignedFVOP.png';
              --then v_Return  := '/i/UnAssignedFileViewer.png';

            WHEN V_USERID is NOT NULL and P_STAGEID = 69
              then v_Return  := '/i/AssignedFVQC.png';

            WHEN V_USERID is NULL and P_STAGEID = 69
              then v_Return  := '/i/UnAssignedFVQC.png';



          --- QCAI/Black Box Steps
            WHEN P_STAGEID = 28 
              then v_Return  := '/i/QCAI-Waiting.png';
              --then v_Return  := '/i/BlackBox-3.png';

            WHEN P_STAGEID = 41
              then v_Return  := '/i/QCAI-Running.png';
              --then v_Return  := '/i/BlackBox-3-Run.png';

            WHEN P_STAGEID = 29 
              then v_Return  := '/i/BlackBox-4.png';

            WHEN P_STAGEID = 42
              then v_Return  := '/i/BlackBox-4-Run.png';

            WHEN P_STAGEID = 43 OR P_STAGEID =56 
                then v_Return  := '/i/QCAI-Error.png';
              --then v_Return  := '/i/BlackBoxStep3Error.png';



            -- Ready to generate Report - was in error
           -- WHEN  P_STAGEID = 30
           --   then v_Return  := '/i/ReadyToGenerateReport.png';

            -- Prelease QA
            WHEN  P_STAGEID = 30
              then v_Return  := '/i/PreReleaseQA.png';

            --- ready to release
            WHEN  P_STAGEID = 13 OR P_STAGEID =57 OR P_STAGEID =58
              then v_Return  := '/i/ReadyToRelease.png';

            --- published
            WHEN P_STAGEID = 31  OR P_STAGEID =63 OR P_STAGEID =64
              then v_Return  := '/i/Published.png';

          --- Below added 12-1-11
            WHEN P_STAGEID = 12
              then v_Return  := '/i/ReadyToGenerate.png';


            WHEN P_STAGEID = 14 OR P_STAGEID =59 OR P_STAGEID =60
              then v_Return  := '/i/Releasing.png';


            WHEN P_STAGEID = 44
              then v_Return  := '/i/ReportingError.png';

            WHEN P_STAGEID = 45 OR P_STAGEID =61 OR P_STAGEID =62 
              then v_Return  := '/i/PublishingError.png';

            WHEN P_STAGEID = 46
              then v_Return  := '/i/BlackBoxStep4Error.png';

            WHEN P_STAGEID = 47 OR P_STAGEID = 53
              then v_Return  := '/i/Generating.png';

            WHEN P_STAGEID = 50
              then v_Return  := '/i/ReviewQA.png';

            WHEN P_STAGEID = 54
              then v_Return  := '/i/AutoWaiting.png';

            WHEN P_STAGEID = 55
              then v_Return  := '/i/AutoRunning.png';

            WHEN P_STAGEID = 65
              then v_Return  := '/i/CheckingDropBox.png';

            WHEN P_STAGEID = 70
              then v_Return  := '/i/Cancelled.png';


         ELSE
              v_Return  := '/i/UnknownStatus.png';
         END CASE;

        return v_Return;
       
       EXCEPTION WHEN OTHERS THEN 
            v_Return := NULL;
           
       END;
/	   