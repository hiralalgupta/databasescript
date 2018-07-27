create or replace
TRIGGER "DPENTRIES_UPDATE_TGR" BEFORE
  UPDATE ON DPENTRIES FOR EACH ROW 
  DECLARE 
    v_caseid INTEGER;
	v_mib varchar2(10);
	v_rxcui varchar2(50);
	v_synid varchar2(20);
	v_graphing_unit varchar2(50);
  v_snomed varchar2(200);
	v_dummy number;
  BEGIN
    --when code selection is changing, update critical flags
    --when QCAI updates criticality, this won't be triggered
    IF :NEW.hid <> :OLD.hid THEN
      select caseid into v_caseid from pages where pageid = :NEW.PAGEID;
      
      --For user-entered codes, set critical flag based on criticalicdlist table and client
      :NEW.ISCRITICAL := 'N';
      :NEW.criticality := IWS_APP_UTILS.getCodeScale2(v_caseid, :NEW.hid);
      -- if scale is 3, it's critical
      IF :NEW.criticality = '3' THEN
        :NEW.ISCRITICAL := 'Y';
      END IF;

	  --IWT-72: Populate MIBCODE field in DPENTRIES table
	  Begin
	  	select s.MIBROOTCODE into v_mib
			from medicalhierarchy m, synid_mibcodes s
			where m.name = s.synid
			and m.id = :NEW.hid;
		:NEW.MIBCODE := v_mib;
	  Exception
		When Others Then
			--no mib root code found, set to blank
			:NEW.MIBCODE := '';
	  End;

	  --IWT-198 RxNorm coding for drugs and medication SynIDs
	  Begin
	  	select s.rxcui into v_rxcui
			from medicalhierarchy m, rxnorm s
			where m.name = s.synid
			and m.id = :NEW.hid;
		:NEW.RXCUI := v_rxcui;
	  Exception
		When Others Then
			--no RXCUI code found, set to blank
			:NEW.RXCUI := '';
	  End;

		--IWT-206: populate unit field
		--find SynID
		select name into v_synid from medicalhierarchy where id=:NEW.hid;
		Begin
			--find default unit
			select graphing_unit into v_graphing_unit from synid_graphing_unit_map where synid=v_synid;
			--if found
			--set Units@datafield2 if NULL
			Begin
				if :NEW.datafield2value is null then
					select id into v_dummy from medicalhierarchy_field_label_v where id=:NEW.hid and name=v_synid and datafield_label='Units' and datafield='datafield2';
					:NEW.datafield2value := v_graphing_unit;
				end if;
			Exception
			When no_data_found Then
				--datafield2 is not Units, do nothing
				null;
			End;
			--set Units@datafield5 if NULL
			Begin
				if :NEW.datafield5value is null then
					select id into v_dummy from medicalhierarchy_field_label_v where id=:NEW.hid and name=v_synid and datafield_label='Units' and datafield='datafield5';
					:NEW.datafield5value := v_graphing_unit;
				end if;
			Exception
			When no_data_found Then
				--datafield5 is not Units, do nothing
				null;
			End;
			
			--set Test_Result_Converted_Unit@datafield5
			Begin
				select id into v_dummy from medicalhierarchy_field_label_v where id=:NEW.hid and name=v_synid and datafield_label='Test_Result_Converted_Unit' and datafield='datafield5';
				:NEW.datafield5value := v_graphing_unit;
			Exception
			When no_data_found Then
				--datafield5 is not Test_Result_Converted_Unit, do nothing
				null;
			End;
			--set Test_Result_Converted_Unit@datafield6
			Begin
				select id into v_dummy from medicalhierarchy_field_label_v where id=:NEW.hid and name=v_synid and datafield_label='Test_Result_Converted_Unit' and datafield='datafield6';
				:NEW.datafield6value := v_graphing_unit;
			Exception
			When no_data_found Then
				--datafield6 is not Test_Result_Converted_Unit, do nothing
				null;
			End;
			--set Test_Result_Converted_Unit@datafield7
			Begin
				select id into v_dummy from medicalhierarchy_field_label_v where id=:NEW.hid and name=v_synid and datafield_label='Test_Result_Converted_Unit' and datafield='datafield7';
				:NEW.datafield7value := v_graphing_unit;
			Exception
			When no_data_found Then
				--datafield7 is not Test_Result_Converted_Unit, do nothing
				null;
			End;
			--set Test_Result_Converted_Unit@datafield9
			Begin
				select id into v_dummy from medicalhierarchy_field_label_v where id=:NEW.hid and name=v_synid and datafield_label='Test_Result_Converted_Unit' and datafield='datafield9';
				:NEW.datafield9value := v_graphing_unit;
			Exception
			When no_data_found Then
				--datafield9 is not Test_Result_Converted_Unit, do nothing
				null;
			End;
			
		Exception
		When no_data_found Then
			--no default unit found for the SynID, clear Test_Result_Converted_Unit field
			--set Test_Result_Converted_Unit@datafield5
			Begin
				select id into v_dummy from medicalhierarchy_field_label_v where id=:NEW.hid and name=v_synid and datafield_label='Test_Result_Converted_Unit' and datafield='datafield5';
				:NEW.datafield5value := null;
			Exception
			When no_data_found Then
				--datafield5 is not Test_Result_Converted_Unit, do nothing
				null;
			End;
			--set Test_Result_Converted_Unit@datafield6
			Begin
				select id into v_dummy from medicalhierarchy_field_label_v where id=:NEW.hid and name=v_synid and datafield_label='Test_Result_Converted_Unit' and datafield='datafield6';
				:NEW.datafield6value := null;
			Exception
			When no_data_found Then
				--datafield6 is not Test_Result_Converted_Unit, do nothing
				null;
			End;
			--set Test_Result_Converted_Unit@datafield7
			Begin
				select id into v_dummy from medicalhierarchy_field_label_v where id=:NEW.hid and name=v_synid and datafield_label='Test_Result_Converted_Unit' and datafield='datafield7';
				:NEW.datafield7value := null;
			Exception
			When no_data_found Then
				--datafield7 is not Test_Result_Converted_Unit, do nothing
				null;
			End;
			--set Converted_Unit@datafield9
			Begin
				select id into v_dummy from medicalhierarchy_field_label_v where id=:NEW.hid and name=v_synid and datafield_label='Test_Result_Converted_Unit' and datafield='datafield9';
				:NEW.datafield9value := null;
			Exception
			When no_data_found Then
				--datafield9 is not Test_Result_Converted_Unit, do nothing
				null;
			End;
		End;
    END IF;
    
    --IWF-101: SNOMED_CT coding: SNOMED_CTCODE in DPENTRIES
	if (:NEW.ICD10CMCODE is not null and :OLD.ICD10CMCODE is null or :NEW.ICD10CMCODE <> :OLD.ICD10CMCODE and :OLD.ICD10CMCODE is not null and :NEW.ICD10CMCODE is not null) THEN
	  Begin
        --find snomed code based on synid and icd10 code
		select SNOMED_CTCODE into v_snomed
        from ICD10_SNOMED_MAP s,medicalhierarchy m
        where m.name = s.synid
			and m.id = :NEW.hid and s.ICD10CMCODE = :NEW.ICD10CMCODE;
        :NEW.SNOMED_CTCODE := v_snomed;
	  Exception
		When Others Then
		  --clear snomed code
		  :NEW.SNOMED_CTCODE := '';
	  End;
    END IF;
	
    if (:NEW.ICD10CMCODE is null and :OLD.ICD10CMCODE is not null) THEN
	  --clear snomed code
	  :NEW.SNOMED_CTCODE := '';
    END IF;
    
  END;
  /