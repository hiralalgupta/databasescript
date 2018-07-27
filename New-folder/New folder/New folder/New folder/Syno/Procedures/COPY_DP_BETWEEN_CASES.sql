--------------------------------------------------------
--  File created - Tuesday-March-12-2013   
--------------------------------------------------------
--------------------------------------------------------
--  Procedure COPY_DP_BETWEEN_CASES
--------------------------------------------------------
set define off;

create or replace
PROCEDURE            "COPY_DP_BETWEEN_CASES" (p_from_case Integer, p_to_case Integer) AS
  from_new_to_old exception;
  client_file_not_match exception;
  fail_on_page_copy exception;
  fail_on_dp_copy exception;
  
  v_from_file varchar2(500);--CLIENTFILENAME
  v_to_file varchar2(500);--CLIENTFILENAME
  
  v_from_rootid integer;
  v_to_rootid integer;
  
  v_from_code varchar2(2000);
  v_to_code varchar2(2000);
  
  v_page_number integer;
  
  v_err varchar2(2000);
  v_msg varchar2(2000);
  
  v_sequence integer;
  
  cursor c_dp is
    select * from dpentries where isdeleted='N' and pageid in (select pageid from pages where caseid=p_to_case) order by sequence;
BEGIN
  --check if copying from new case to old case
  if (p_from_case >= p_to_case) then
      raise from_new_to_old;
  end if;
  
  --check if the client file is identical first
  Begin
    select CLIENTFILENAME into v_from_file from cases where caseid=p_from_case;
    select CLIENTFILENAME into v_to_file from cases where caseid=p_to_case;
    if (v_from_file != v_to_file) then
      raise client_file_not_match;
    end if;
  End;
  
  --copy page data
  Begin
    update pages p2 
    set (p2.documentdate,p2.documenttypeid,p2.subdocumentorder,p2.subdocumentpagenumber,p2.finalpagenumber,p2.orientation,p2.isdeleted,p2.deletereason,p2.iscompleted,p2.completetimestamp)=
    (select p1.documentdate,p1.documenttypeid,p1.subdocumentorder,p1.subdocumentpagenumber,p1.finalpagenumber,p1.orientation,p1.isdeleted,p1.deletereason,p1.iscompleted,p1.completetimestamp
    from pages p1 where p1.caseid=p_from_case and p1.originalpagenumber=p2.originalpagenumber) 
    where p2.caseid=p_to_case;
    commit;
    dbms_output.put_line('Page numbers copied from case '||p_from_case||' to '||p_to_case);
  Exception
  When others Then
    v_err := SQLCODE;
    v_msg := SQLERRM;
    raise fail_on_page_copy;
  End;
  
  --get Root hid
  select id into v_from_rootid from medicalhierarchy where revision=(select hierarchyrevision from cases where caseid=p_from_case) and name='Root';
  select id into v_to_rootid from medicalhierarchy where revision=(select hierarchyrevision from cases where caseid=p_to_case) and name='Root';

  --copy all data points
  Begin
    execute immediate 'alter trigger DPENTRIES_DPENTRYID_TGR disable';
    
    delete from dpentries d where pageid in (select pageid from pages where caseid=p_to_case);
    Begin
      INSERT INTO DPENTRIES
        (
        DPENTRYID,
        PAGEID,
        DPFORMENTITYID,
        ENTRYTRANSCRIPTION,
        DATADATE,
        STATUS,
        CREATED_TIMESTAMP,
        CREATED_USERID,
        CREATED_STAGEID,
        UPDATED_TIMESTAMP,
        UPDATED_USERID,
        UPDATED_STAGEID,
        ISCOMPLETED,
        ISDELETED,
        REQUIRECODE,
        SUSPENDNOTE,
        ISREJECTED,
        REJECTREASON,
        HID,
        DATAFIELD1VALUE,
        DATAFIELD2VALUE,
        DATAFIELD3VALUE,
        DATAFIELD4VALUE,
        ISCRITICAL,
        ISTEXT,
        ISHANDWRITING,
        STARTSECTIONNUMBER,
        ENDSECTIONNUMBER,
        DATAFIELD5VALUE,
        DATAFIELD6VALUE,
        DATAFIELD7VALUE,
        DATAFIELD8VALUE,
        HID_PREVIOUS,
        SEQUENCE,
        USERFEEDBACK,
        DATAFIELD9VALUE,
        DATAFIELD10VALUE,
        DATAFIELD11VALUE,
        DATAFIELD12VALUE,
        CRITICALITY,
        ICD10CMCODE,
        ICD9CODE,
        CPTCODE,
        ICD10PCSCODE,
        MIBDATECODE,
        MIBCODE,
        MESHCODE,
        DATAFIELD13VALUE,
        DATAFIELD14VALUE,
        DATAFIELD15VALUE,
        DATAFIELD16VALUE,
        DATAFIELD17VALUE,
        DATAFIELD18VALUE,
        DATAFIELD19VALUE,
        DATAFIELD20VALUE,
        MIBSEVERITYCODE,
        OMIM_ID,
        RGACODE,
        DEBIT_VALUE,
        CREDIT_VALUE,
        ISFINAL,
        DATAFIELD21VALUE,
        DATAFIELD22VALUE,
        DATAFIELD23VALUE,
        DATAFIELD24VALUE,
        DATAFIELD25VALUE,
        DATAFIELD26VALUE,
        DATAFIELD27VALUE,
        DATAFIELD28VALUE,
        DATAFIELD29VALUE,
        DATAFIELD30VALUE,
        DATAFIELD31VALUE,
        DATAFIELD32VALUE,
        RXCUI,
        LINK_TO_SEQUENCE,
        APPLICABLE_PARTIES,
        APPLICABLE_CASEIDS
        )
        SELECT DPENTRIES_SEQ.nextval,
        (select p2.pageid from pages p2 where p2.caseid=p_to_case and p2.originalpagenumber=(select p1.originalpagenumber from pages p1 where p1.pageid=d.pageid)),
        DPFORMENTITYID,
        ENTRYTRANSCRIPTION,
        DATADATE,
        STATUS,
        CREATED_TIMESTAMP,
        CREATED_USERID,
        CREATED_STAGEID,
        UPDATED_TIMESTAMP,
        UPDATED_USERID,
        UPDATED_STAGEID,
        ISCOMPLETED,
        ISDELETED,
        REQUIRECODE,
        SUSPENDNOTE,
        ISREJECTED,
        REJECTREASON,
        HID + v_to_rootid - v_from_rootid,
        DATAFIELD1VALUE,
        DATAFIELD2VALUE,
        DATAFIELD3VALUE,
        DATAFIELD4VALUE,
        ISCRITICAL,
        ISTEXT,
        ISHANDWRITING,
        STARTSECTIONNUMBER,
        ENDSECTIONNUMBER,
        DATAFIELD5VALUE,
        DATAFIELD6VALUE,
        DATAFIELD7VALUE,
        DATAFIELD8VALUE,
        HID_PREVIOUS,
        SEQUENCE,
        USERFEEDBACK,
        DATAFIELD9VALUE,
        DATAFIELD10VALUE,
        DATAFIELD11VALUE,
        DATAFIELD12VALUE,
        CRITICALITY,
        ICD10CMCODE,
        ICD9CODE,
        CPTCODE,
        ICD10PCSCODE,
        MIBDATECODE,
        MIBCODE,
        MESHCODE,
        DATAFIELD13VALUE,
        DATAFIELD14VALUE,
        DATAFIELD15VALUE,
        DATAFIELD16VALUE,
        DATAFIELD17VALUE,
        DATAFIELD18VALUE,
        DATAFIELD19VALUE,
        DATAFIELD20VALUE,
        MIBSEVERITYCODE,
        OMIM_ID,
        RGACODE,
        DEBIT_VALUE,
        CREDIT_VALUE,
        ISFINAL,
        DATAFIELD21VALUE,
        DATAFIELD22VALUE,
        DATAFIELD23VALUE,
        DATAFIELD24VALUE,
        DATAFIELD25VALUE,
        DATAFIELD26VALUE,
        DATAFIELD27VALUE,
        DATAFIELD28VALUE,
        DATAFIELD29VALUE,
        DATAFIELD30VALUE,
        DATAFIELD31VALUE,
        DATAFIELD32VALUE,
        RXCUI,
        LINK_TO_SEQUENCE,
        APPLICABLE_PARTIES,
        APPLICABLE_CASEIDS
        from dpentries d where isdeleted='N' and pageid in (select pageid from pages where caseid=p_from_case);
        commit;
    Exception
    when others then
      rollback;
      execute immediate 'alter trigger DPENTRIES_DPENTRYID_TGR enable';
      v_err := SQLCODE;
      v_msg := SQLERRM;
      raise fail_on_dp_copy;
    End;
      
    execute immediate 'alter trigger DPENTRIES_DPENTRYID_TGR enable';
  Exception
  When fail_on_dp_copy Then
    raise fail_on_dp_copy;
  When others Then
    raise;
  End;
  
  --compare data fields for one dp at a time and delete data point if fields or codes not matching or hid not existing
  Begin
    for r_dp in c_dp loop
      v_sequence := r_dp.sequence;
      Begin
        select name||datafield1||datafield1type||datafield1ref|| 
          datafield2||datafield2type||datafield2ref||
          datafield3||datafield3type||datafield3ref||
          datafield4||datafield4type||datafield4ref||
          datafield5||datafield5type||datafield5ref||
          datafield6||datafield6type||datafield6ref||
          datafield7||datafield7type||datafield7ref||
          datafield8||datafield8type||datafield8ref||
          datafield9||datafield9type||datafield9ref||
          datafield10||datafield10type||datafield10ref||
          datafield11||datafield11type||datafield11ref||
          datafield12||datafield12type||datafield12ref into v_to_code
          from medicalhierarchy where id = r_dp.hid;

        select name||datafield1||datafield1type||datafield1ref|| 
          datafield2||datafield2type||datafield2ref||
          datafield3||datafield3type||datafield3ref||
          datafield4||datafield4type||datafield4ref||
          datafield5||datafield5type||datafield5ref||
          datafield6||datafield6type||datafield6ref||
          datafield7||datafield7type||datafield7ref||
          datafield8||datafield8type||datafield8ref||
          datafield9||datafield9type||datafield9ref||
          datafield10||datafield10type||datafield10ref||
          datafield11||datafield11type||datafield11ref||
          datafield12||datafield12type||datafield12ref into v_from_code
          from medicalhierarchy where id = (select hid from dpentries
          where isdeleted='N' and pageid in (select pageid from pages where caseid=p_from_case)
          and sequence = r_dp.sequence);
        
        v_to_code := replace(v_to_code, 'Other NotesText');
        v_from_code := replace(v_from_code, 'Other NotesText');
        
        if (v_to_code != v_from_code) Then
          --code changed from old spine to new spine
          select finalpagenumber into v_page_number from pages where pageid=r_dp.pageid;
          select name into v_from_code from medicalhierarchy where id = r_dp.hid;
          
          update dpentries set isdeleted='Y' where dpentryid=r_dp.dpentryid;
          commit;
          dbms_output.put_line('DP '||r_dp.sequence||' on code '||v_from_code||' deleted: code field changed. DP info: Page '||v_page_number||', Sec '||r_dp.STARTSECTIONNUMBER||
          '-'||r_dp.ENDSECTIONNUMBER||', Data Date '||trunc(r_dp.DATADATE)||', Data Field Values: '||
          r_dp.DATAFIELD1VALUE||'|'||r_dp.DATAFIELD2VALUE||'|'||r_dp.DATAFIELD3VALUE||'|'||r_dp.DATAFIELD4VALUE||'|'||r_dp.DATAFIELD5VALUE||'|'||r_dp.DATAFIELD6VALUE||'|'||r_dp.DATAFIELD7VALUE||
          '|'||r_dp.DATAFIELD8VALUE||'|'||r_dp.DATAFIELD9VALUE||'|'||r_dp.DATAFIELD10VALUE||'|'||r_dp.DATAFIELD11VALUE||'|'||r_dp.DATAFIELD12VALUE);
        end if;
      
      Exception
      When no_data_found Then
        --hid not exist in new spine, delete the dp and report it
        select finalpagenumber into v_page_number from pages where pageid=r_dp.pageid;
        select name into v_from_code
          from medicalhierarchy where id = (select hid from dpentries
          where isdeleted='N' and pageid in (select pageid from pages where caseid=p_from_case)
          and sequence = r_dp.sequence);
        
        update dpentries set isdeleted='Y' where dpentryid=r_dp.dpentryid;
        commit;
        dbms_output.put_line('DP '||r_dp.sequence||' deleted: code '||v_from_code||' not exist. DP info: Page '||v_page_number||', Sec '||r_dp.STARTSECTIONNUMBER||
        '-'||r_dp.ENDSECTIONNUMBER||', Data Date '||trunc(r_dp.DATADATE)||', Data Field Values: '||
        r_dp.DATAFIELD1VALUE||'|'||r_dp.DATAFIELD2VALUE||'|'||r_dp.DATAFIELD3VALUE||'|'||r_dp.DATAFIELD4VALUE||'|'||r_dp.DATAFIELD5VALUE||'|'||r_dp.DATAFIELD6VALUE||'|'||r_dp.DATAFIELD7VALUE||
        '|'||r_dp.DATAFIELD8VALUE||'|'||r_dp.DATAFIELD9VALUE||'|'||r_dp.DATAFIELD10VALUE||'|'||r_dp.DATAFIELD11VALUE||'|'||r_dp.DATAFIELD12VALUE);
      When others Then
        raise;
      end;
      
    end loop;
  end;

  --put case at step-2-op
  --update cases set stageid=6 where caseid=p_to_case;
  commit;
  dbms_output.put_line('Data points copied from case '||p_from_case||' to '||p_to_case);
  
Exception
  When from_new_to_old Then
    dbms_output.put_line('No copy allowed from newer case to older case!');
  When client_file_not_match Then
    dbms_output.put_line('Case '||p_from_case||' and case '||p_to_case||' are from two different files! No copy allowed!');
  When fail_on_page_copy Then
    rollback;
    dbms_output.put_line('Failed to copy page numbers from case '||p_from_case||' to '||p_to_case);
    dbms_output.put_line(v_err||' '||v_msg);
  When fail_on_dp_copy Then
    dbms_output.put_line('Failed to copy all data points from case '||p_from_case||' to '||p_to_case);
    dbms_output.put_line(v_err||' '||v_msg);
  When others Then
    rollback;
    dbms_output.put_line('Failed to copy DP '||v_sequence||' from case '||p_from_case||' to '||p_to_case||'.'); 
    dbms_output.put_line(SQLCODE||' '||SQLERRM); 
END COPY_DP_BETWEEN_CASES;
/
