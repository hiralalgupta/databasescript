--------------------------------------------------------
--  DDL for Function DP_CHANGE_COUNT
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SNX_IWS2"."DP_CHANGE_COUNT" 
    (P_DPENTRYID NUMBER default null,
     P_FORMAT VARCHAR2 default null)
    
    -- Created 11-5-2012 R Benzell
    -- Generate Count of changes to each reference DataPoint
    
    -- to test:  select DP_CHANGE_COUNT(25230) from dual;
    -- Update History 
    
    
        RETURN Number
    
        IS
    


       v_Count Number;


        BEGIN
           
            

  SELECT count(*) into v_Count
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
  AND aud.objectid = P_DPENTRYID order by aud.logid;

           
     
            
  
         return v_Count;

      EXCEPTION WHEN OTHERS THEN SHOW_APEX_ERROR('');

      END;



/

