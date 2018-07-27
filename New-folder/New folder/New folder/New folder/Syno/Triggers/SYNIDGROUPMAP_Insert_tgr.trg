create or replace
TRIGGER "SYNIDGROUPMAP_INSERT_TGR" after
  INSERT ON SYNIDGROUPMAP FOR EACH row 
  DECLARE
  	PRAGMA AUTONOMOUS_TRANSACTION; 
	cursor cur_primary_groups is
		Select MAP_TO_PRIMARY_GROUP from SpineGroups where GROUPNAME = :NEW.GROUPNAME and MAP_TO_PRIMARY_GROUP is not null;
	cursor cur_support_groups is
		Select MAP_TO_SUPPORT_GROUP from SpineGroups where GROUPNAME = :NEW.GROUPNAME and MAP_TO_SUPPORT_GROUP is not null;
	
  BEGIN
	--IWT-203 Automate group mapping from drug classes to diseases
	for rec_primary_groups in cur_primary_groups loop
		Begin
			INSERT
			INTO SYNIDGROUPMAP
			  (
				SYNID,
				GROUPNAME,
				ISSUPPORTING,
				CREATED_BY,
				CREATED_TIMESTAMP,
				CASEID
			  )
			  VALUES
			  (
				:NEW.SYNID,
				rec_primary_groups.MAP_TO_PRIMARY_GROUP,
				'N',
				0,
				current_timestamp,
				:NEW.CASEID
			  );
		Exception
		When Others Then
			--this group already mapped for the SynID for the case
			null;
		End;
	End loop;
	  
	for rec_support_groups in cur_support_groups loop
		Begin
			INSERT
			INTO SYNIDGROUPMAP
			  (
				SYNID,
				GROUPNAME,
				ISSUPPORTING,
				CREATED_BY,
				CREATED_TIMESTAMP,
				CASEID
			  )
			  VALUES
			  (
				:NEW.SYNID,
				rec_support_groups.MAP_TO_SUPPORT_GROUP,
				'Y',
				0,
				current_timestamp,
				:NEW.CASEID
			  );
		Exception
		When Others Then
			--this group already mapped for the SynID for the case
			null;
		End;
	End loop;
	
	commit;
  END;
/