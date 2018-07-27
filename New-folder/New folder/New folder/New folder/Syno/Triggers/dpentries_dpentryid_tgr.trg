create or replace
TRIGGER "DPENTRIES_DPENTRYID_TGR" before
  INSERT ON DPENTRIES FOR EACH row 
  DECLARE 
    v_caseid INTEGER;
	v_mib varchar2(10);
	v_snomed varchar2(200);
	v_rxcui varchar2(50);
	v_synid varchar2(20);
	v_graphing_unit varchar2(50);
	v_dummy number;
  BEGIN
    IF inserting THEN
      select current_timestamp into :new.CREATED_TIMESTAMP FROM dual;
      IF :NEW.DPENTRYID IS NULL THEN
        SELECT DPENTRIES_SEQ.nextval INTO :NEW.DPENTRYID FROM dual;
      END IF;

      select caseid into v_caseid from pages where pageid = :NEW.PAGEID;
      
      --For user-entered codes, set critical flag based on criticalicdlist table and client
      :NEW.ISCRITICAL := 'N';
      :NEW.criticality := IWS_APP_UTILS.getCodeScale2(v_caseid, :NEW.hid);
      -- if scale is 3, it's critical
      IF :NEW.criticality = '3' THEN
        :NEW.ISCRITICAL := 'Y';
      END IF;
      
      IF :NEW.SEQUENCE IS NULL THEN
        --assign a sequence number to the data point
        select nvl(max(dp.sequence)+1,1) into :NEW.SEQUENCE from dpentries dp, pages p
        where dp.pageid=p.pageid and p.caseid=v_caseid;
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
			--no mib root code found, do nothing
			null;
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
			--no RXCUI code found, do nothing
			null;
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
			null;
		End;
	  
    END IF;
  END;
/