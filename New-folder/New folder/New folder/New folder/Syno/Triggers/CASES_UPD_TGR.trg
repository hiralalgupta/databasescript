create or replace
TRIGGER  CASES_UPD_TGR before UPDATE ON CASES FOR EACH row
 DECLARE
      PRAGMA AUTONOMOUS_TRANSACTION;
  BEGIN

  --- Update Advanced CaseHistorySum processing
  --- R Benzell 5-2-2012
   SNX_IWS2.UPDATE_CASEHISTORYSUM
      ( 
       P_CASEID =>  :NEW.CASEID,
       P_PREV_STAGEID => :OLD.STAGEID,
       P_PREV_USERID =>  :OLD.USERID,
       P_NEW_STAGEID => :NEW.STAGEID,
       P_NEW_USERID =>  :NEW.USERID,
       P_USERID =>  :NEW.USERID  -- id initiating the change
      ); 
      COMMIT;

 END;
/