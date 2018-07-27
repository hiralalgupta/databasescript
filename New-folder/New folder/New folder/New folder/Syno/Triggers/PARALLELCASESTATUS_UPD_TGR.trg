create or replace
TRIGGER  "PARALLELCASESTATUS_UPD_TGR" before UPDATE ON PARALLELCASESTATUS FOR EACH row
 DECLARE
      PRAGMA AUTONOMOUS_TRANSACTION;
  BEGIN

  --- Update Advanced CaseHistorySum processing
  --- R Benzell 3-14-2013   Update the POP info
  --- R Benzell 3-18-2013   Fiex Old/new misallignment for ISCOMPLETED
  
 
   SNX_IWS2.UPDATE_POP_CASEHISTORYSUM
      (P_Caseid =>  :New.Caseid,
       P_Stageid => :New.Stageid,
       P_Roleid => :New.Roleid,
       P_Prev_Userid => :Old.Userid,
       P_New_Userid => :New.Userid,
       P_Prev_Iscompleted => :Old.Iscompleted,
       P_New_Iscompleted => :New.Iscompleted,
       P_DATE => SYSTIMESTAMP
      ); 
      COMMIT;


 END;
 /