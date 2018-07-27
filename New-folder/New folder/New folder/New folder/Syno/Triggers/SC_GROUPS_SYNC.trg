create or replace
TRIGGER SC_GROUPS_SYNC 
After INSERT OR DELETE OR UPDATE OF GROUPID,GROUPNAME ON SC_GROUPS 
FOR EACH ROW 
DECLARE 
  PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
  IF inserting THEN
    insert into "GROUPS"@SC.IWS.INNODATA_SYNODEX.COM ("GroupId", "GroupName") values (:NEW.GROUPID, :NEW.GROUPNAME);
    commit;
  End If;
  IF updating THEN
    update "GROUPS"@SC.IWS.INNODATA_SYNODEX.COM
    set "GroupId" = :NEW.GROUPID, "GroupName" = :NEW.GROUPNAME
    where "GroupId" = :OLD.GROUPID;
    commit;
  End If;
  IF deleting THEN
    delete from "GROUPS"@SC.IWS.INNODATA_SYNODEX.COM where "GroupId" = :OLD.GROUPID;
    commit;
  End If;
END;
