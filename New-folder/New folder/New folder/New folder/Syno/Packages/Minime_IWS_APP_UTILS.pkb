set define off

create or replace
PACKAGE BODY IWS_APP_UTILS
--PACKAGE Body IWS_APP_UTILS
-- Update History
-- 4-23-2013 R Benzell
-- IWN-643 Turn off certain roles assigned to a user so that "Get Next" won't assign cases to the user for those roles
-- IWN-644 "Get Next" needs to use received timestamp of a case to determine the age, not by case id
-- RPT-41 Modify Embargo screen to show PDF reports from different templates for a single case

AS
FUNCTION getConfigSwitchValue(
    p_clientid    IN INTEGER,
    p_switch_name IN VARCHAR2)
  RETURN VARCHAR2
IS
  v_return     VARCHAR2(240):= null;
  DEFAULTSPECS VARCHAR2(7)  := 'Default';
BEGIN
  /* check switch value for the client */
  BEGIN
    SELECT cs.switch_value
    INTO v_return
    FROM config_switches cs,
      clients c
    WHERE cs.productspec  = c.productspec
    AND cs.switch_access IN ('DB','DBWS')
    AND cs.switch_name    =p_switch_name
    AND c.clientid        =p_clientid;
  EXCEPTION
  WHEN NO_DATA_FOUND THEN
    /* check default switch value */
    BEGIN
      SELECT cs.switch_value
      INTO v_return
      FROM config_switches cs
      WHERE cs.productspec  = DEFAULTSPECS
      AND cs.switch_access IN ('DB','DBWS')
      AND cs.switch_name    =p_switch_name;
    EXCEPTION
    WHEN NO_DATA_FOUND THEN
      v_return := null;
    END;
  END;
  RETURN v_return;
END getConfigSwitchValue;

FUNCTION isCodeRequired(
    p_clientid IN INTEGER,
    p_cat      IN VARCHAR2,
    p_subcat   IN VARCHAR2 DEFAULT NULL,
    p_status   IN VARCHAR2 DEFAULT NULL)
  RETURN VARCHAR2
IS
  v_return     VARCHAR2(1);
  DEFAULTSPECS VARCHAR2(7) := 'Default';
BEGIN
  /* check switch value for the client */
  BEGIN
    SELECT 'Y'
    INTO v_return
    FROM dual
    WHERE 'REQUIRECODE' IN
      (SELECT switch_value
      FROM config_switches cs,
        clients c
      WHERE cs.productspec  = c.productspec
      AND cs.switch_access IN ('DB','DBWS')
      AND c.clientid        =p_clientid
      AND cs.switch_name   IN (p_cat, p_cat
        ||'.'
        ||p_subcat,p_cat
        ||'.'
        ||p_subcat
        ||'.'
        ||p_status)
      );
  EXCEPTION
  WHEN NO_DATA_FOUND THEN
    /* check default switch value */
    BEGIN
      SELECT 'Y'
      INTO v_return
      FROM dual
      WHERE 'REQUIRECODE' IN
        (SELECT switch_value
        FROM config_switches cs
        WHERE cs.productspec  = DEFAULTSPECS
        AND cs.switch_access IN ('DB','DBWS')
        AND cs.switch_name   IN (p_cat, p_cat
          ||'.'
          ||p_subcat,p_cat
          ||'.'
          ||p_subcat
          ||'.'
          ||p_status)
        );
    EXCEPTION
    WHEN NO_DATA_FOUND THEN
      v_return := 'N';
    END;
  END;
  RETURN v_return;
END isCodeRequired;



/* To be used in Pre-Release QA Review report in APEX to derive the image icon for various report types */
FUNCTION getLinkTextForReportIcon(
    p_caseID  IN INTEGER,
    p_docType VARCHAR2)
  RETURN VARCHAR2
IS
  v_clientID INTEGER;
  v_return   VARCHAR2(240) := '';
  v_filename VARCHAR2(240) := '';
  v_publish  VARCHAR2(1)   := '';
  v_generate VARCHAR2(1)   := '';
  v_dummy varchar2(1);
  v_active varchar2(15);
BEGIN
	
--v_active := Iws_App_Utils.Getconfigswitchvalue(8, 'GEN_IMRS1File') From Dual;
	
  SELECT clientID INTO v_clientID FROM cases WHERE caseid = p_caseID;
  v_filename  := iws_app_utils.getconfigswitchvalue(v_clientID, p_docType);
  v_publish   := iws_app_utils.getconfigswitchvalue(v_clientID, 'PUBLISH_'||p_docType);
  v_generate  := iws_app_utils.getconfigswitchvalue(v_clientID, 'GEN_'||p_docType);
  
  
  -- if the client needs the report, show the report icon 
  --IF v_publish = 'Y' THEN
  IF v_generate = 'Y' THEN   --- RPT-89
    v_return  := '"/i/'||lower(SUBSTR(v_filename, LENGTH(v_filename)-2,3))||'_icon.gif" height="30"';
  ELSE
    v_return := '';
  END IF;
 
  RETURN v_return;
EXCEPTION
WHEN NO_DATA_FOUND THEN
  v_return := '';
  RETURN v_return;
END getLinkTextForReportIcon;



-- To be used in Pre-Release QA Review report in APEX to derive the image icon for various Template types 
FUNCTION getLinkTextForTemplateIcon(
    p_caseID  IN INTEGER,
    p_position IN INTEGER)
  RETURN VARCHAR2
IS

  v_return   VARCHAR2(240) := '';
  v_templateName VARCHAR2(240) := '';
  v_generate VARCHAR2(1) := '';
  v_clientid number;
  v_doctype varchar2(15);
  
BEGIN
	
 -- If there is a template for this case/pos, then return an icon
  v_TemplateName := GET_TEMPLATE_NAME(P_CASEID,P_POSITION);	
  
  --- RPT-89
  SELECT clientID INTO v_clientID FROM cases WHERE caseid = p_caseID;
  --v_doctype := 'GEN_IMRS' || ltrim(to_char(p_position))  || 'File';
  v_doctype := 'GEN_IMRSTFile';
  v_generate  := iws_app_utils.getconfigswitchvalue(v_clientID, v_docType);
  
  
 -- Check if ConfigSwitch is set off.  If so, do not return Icon 
 --  GEN_IMRSTFile switch for the client is "N", no icon should be displayed
	
  -- if Generate is enabled and the template id defined, show the report icon 
  IF v_generate = 'Y' AND v_templatename is not null 
   THEN  v_return  := '"/i/pdf_icon.gif" height="30"';
   ELSE  v_return := '';
  END IF;
  
  

  
  RETURN v_return;
EXCEPTION
WHEN NO_DATA_FOUND THEN
  v_return := '';
  RETURN v_return;
END getLinkTextForTemplateIcon;



Function getEpochMillisecond(p_timestamp IN TIMESTAMP WITH TIME ZONE)
  Return number
Is
  day_to_sec INTERVAL DAY(9) TO SECOND;
  num_val number;
BEGIN
  day_to_sec := p_timestamp - CAST(CAST(TIMESTAMP '1970-01-01 00:00:00 +00:00' AS TIMESTAMP WITH LOCAL TIME ZONE) AS TIMESTAMP WITH TIME ZONE);
  num_val := to_number(extract(second from day_to_sec)) * 1000 +
              to_number(extract(minute from day_to_sec)) * 60 * 1000 + 
              to_number(extract(hour from day_to_sec))   * 60 * 60 * 1000 + 
              to_number(extract(day from day_to_sec))  * 60 * 60* 24 * 1000;
  return num_val;
End getEpochMillisecond;



/*Based on client id and code id, find out if the code should be displayed in RED BOLD font*/  
FUNCTION isCodeCritical1(
    p_clientid IN INTEGER,
    p_codeid   IN INTEGER)
  RETURN VARCHAR2
Is
  criticality INTEGER;
  v_iscritical VARCHAR2(1 CHAR) := 'N';
BEGIN
  -- First, see if there is client specific critical entry
  criticality := getCodeScale1(p_clientid, p_codeid);
  -- if scale is 2 or 3, it should be displayed as RED BOLD
  IF criticality     in (2, 3) THEN
    v_iscritical := 'Y';
  END IF;
  return v_iscritical;
EXCEPTION
WHEN NO_DATA_FOUND THEN
  v_iscritical := 'N';
  return v_iscritical;
END isCodeCritical1;

/*Based on case id and code id, find out if the code should be displayed in RED BOLD font*/  
FUNCTION isCodeCritical2(
    p_caseid   IN INTEGER,
    p_codeid   IN INTEGER)
  RETURN VARCHAR2
Is
  v_clientid INTEGER;
  v_iscritical VARCHAR2(1 CHAR) := 'N';
Begin
  select clientid into v_clientid from cases where caseid=p_caseid;
  v_iscritical := isCodeCritical1(v_clientid, p_codeid);
  return v_iscritical;
End isCodeCritical2;

FUNCTION getProductSpec(
    p_caseid   IN INTEGER,
    p_itemname IN VARCHAR2)
  RETURN VARCHAR2
Is
  v_spec varchar2(2000 byte) := '';
  
Begin
  select ps.spec into v_spec
    from productspecs ps, cases c, clients cl
    where ps.clientid = cl.clientid
    and ps.productspec = cl.productspec
    and cl.clientid = c.clientid
    and c.caseid = p_caseid
    and ps.itemname = p_itemname;
  return v_spec;
EXCEPTION
WHEN NO_DATA_FOUND THEN 
  -- if there is no match of the spec for the case's client ID, look up the default spec
  Begin
    select ps.spec into v_spec
      from productspecs ps
      where ps.clientid = 0
      and ps.productspec = 'Default'
      and ps.itemname = p_itemname;
    return v_spec;
  EXCEPTION
  WHEN NO_DATA_FOUND THEN
    return v_spec;
  End;
End getProductSpec;

FUNCTION isCodeExcluded(
    p_caseid   IN INTEGER,
    p_codeid   IN INTEGER)
  RETURN VARCHAR2
Is
  v_scale integer;
  v_isexcluded VARCHAR2(1 CHAR) := 'N';
BEGIN
  --SPINE-38: Implement client specific exclusion list
  --find client specific scale in exclusion table
  SELECT scale INTO v_scale
  FROM medicalhierarchy mc,
    MEDICALHIERARCHY_EXCLUSION me,
    cases c
  WHERE 1           =1
  AND mc.name     = me.codename
  AND mc.codetype = me.codetype
  AND c.clientid    = me.clientid
  AND c.caseid = p_caseid
  AND mc.id = p_codeid;
  
  if v_scale = 0 then
    v_isexcluded := 'Y';
  else
    v_isexcluded := 'N';
  end if;
  return v_isexcluded;
EXCEPTION
WHEN NO_DATA_FOUND THEN 
  -- if there is no match of the code for the case's client ID, look up the default exclusion with client ID=0
  Begin
    SELECT scale INTO v_scale
      FROM medicalhierarchy mc,
        MEDICALHIERARCHY_EXCLUSION me
      WHERE 1           =1
      AND mc.name     = me.codename
      AND mc.codetype = me.codetype
      AND me.clientid = 0
      AND mc.id = p_codeid;
    if v_scale = 0 then
      v_isexcluded := 'Y';
    else
      v_isexcluded := 'N';
    end if;
    return v_isexcluded;
  EXCEPTION
  WHEN NO_DATA_FOUND THEN
    --not in exclusion list
    v_isexcluded := 'N';
    return v_isexcluded;
  End;
END isCodeExcluded;

Procedure getNextReadyToReleaseCase
Is
  v_id integer; --case id or batch id
  clid integer; --client id
  v_iszipbatch varchar2(1); --is it a batch?
  v_current_stageid integer; --current stage id
  v_next_stageid integer; --next stage id
  
  READYTOPUBLISH integer := 13;
  READYTOPUBLISH_PDF integer :=57;
  READYTOPUBLISH_XML integer :=58;
  PUBLISHER integer := 125;

  sql_stmt VARCHAR2(500);
begin
  -- is there any pending case or batch at any READYTOPUBLISH stage?
  select id, clientid, ISZIPBATCH into v_id, clid, v_iszipbatch from (
    select * from (
      select caseid id, clientid, RECEIPTTIMESTAMP timestamp, 'N' ISZIPBATCH
        from cases where stageid in (READYTOPUBLISH,READYTOPUBLISH_PDF,READYTOPUBLISH_XML) and caseid not in (select caseid from batchpayload where caseid is not null)
      union      
      select batchid id, clientid, receivedon timestamp, 'Y' ISZIPBATCH
        from clientzipbatches z
        where NUMOFFILES=(select count(distinct c.caseid) from cases c, batchpayload b
                          where c.stageid in (READYTOPUBLISH,READYTOPUBLISH_PDF,READYTOPUBLISH_XML) and c.caseid=b.caseid and b.batchid=z.batchid))
    order by timestamp asc)
  where rownum=1;

  if v_iszipbatch='Y' then
    --get current and next stage id 
    select distinct c.stageid into v_current_stageid from cases c, batchpayload b
      where c.caseid=b.caseid and b.batchid=v_id;
    select nextstageid into v_next_stageid from workflows where stageid=v_current_stageid and clientid=clid and condition='COMPLETION';
    
    -- advance all cases in the batch to PUBLISHING stage
    sql_stmt := 'select * from cases where stageid in (' || READYTOPUBLISH || ',' || READYTOPUBLISH_PDF || ',' || READYTOPUBLISH_XML || ') and caseid in ' || 
                '(select caseid from batchpayload where batchid = ' || v_id || ') for update nowait';
    EXECUTE IMMEDIATE sql_stmt;
    update cases set stageid=v_next_stageid, STAGESTARTTIMESTAMP=(SELECT current_timestamp FROM DUAL),
      UPDATED_STAGEID=v_current_stageid, UPDATED_TIMESTAMP=(SELECT current_timestamp FROM DUAL),
      UPDATED_USERID=PUBLISHER where caseid in (select caseid from batchpayload where batchid=v_id);
    commit;  
    dbms_output.put_line('ISZIPBATCH=Y');
    dbms_output.put_line('BATCHID='||v_id); 
    dbms_output.put_line('CASEID=');
    dbms_output.put_line('CLIENTID='||clid);
    dbms_output.put_line('CURRENTSTAGEID='||v_current_stageid);
    dbms_output.put_line('NEXTSTAGEID='||v_next_stageid);
  else
    --get current and next stage id 
    select c.stageid into v_current_stageid from cases c where c.caseid=v_id;
    select nextstageid into v_next_stageid from workflows where stageid=v_current_stageid and clientid=clid and condition='COMPLETION';

    select caseid into v_id from cases where stageid in (READYTOPUBLISH,READYTOPUBLISH_PDF,READYTOPUBLISH_XML) and caseid=v_id for update nowait;
    update cases set stageid=v_next_stageid, STAGESTARTTIMESTAMP=(SELECT current_timestamp FROM DUAL),
      UPDATED_STAGEID=v_current_stageid, UPDATED_TIMESTAMP=(SELECT current_timestamp FROM DUAL),
      UPDATED_USERID=PUBLISHER where caseid=v_id;
    commit;
    dbms_output.put_line('ISZIPBATCH=N');
    dbms_output.put_line('BATCHID='); 
    dbms_output.put_line('CASEID='||v_id);
    dbms_output.put_line('CLIENTID='||clid);
    dbms_output.put_line('CURRENTSTAGEID='||v_current_stageid);
    dbms_output.put_line('NEXTSTAGEID='||v_next_stageid);
  end if;
end getNextReadyToReleaseCase;

/*a variation of getNextReadyToReleaseCase to be used in IWS 2.7 per IWN-828*/
Procedure getNextReadyToReleaseCase2
Is
  v_id integer; --case id or batch id
  clid integer; --client id
  v_iszipbatch varchar2(1); --is it a batch?
  v_current_stageid integer; --current stage id
  v_next_stageid integer; --next stage id
  v_dummy number;
  
  READYTOPUBLISH integer := 13;
  READYTOPUBLISH_PDF integer :=57;
  READYTOPUBLISH_XML integer :=58;
  PUBLISHER integer := 125;

  sql_stmt VARCHAR2(500);
  
  cursor c_cases(p_batchid integer) is
    select caseid from BATCHPAYLOAD where batchid=p_batchid;
  
begin
  -- is there any pending case or batch at any READYTOPUBLISH stage?
  select id, clientid, ISZIPBATCH into v_id, clid, v_iszipbatch from (
    select * from (
      select c.caseid id, c.clientid, c.RECEIPTTIMESTAMP timestamp, 'N' ISZIPBATCH
        from CaseHistorySum ch, Cases c
		where ch.caseid=c.caseid and ch.stageid in (READYTOPUBLISH,READYTOPUBLISH_PDF,READYTOPUBLISH_XML)
		and ch.STAGESTARTTIMESTAMP is not null and ch.STAGECOMPLETIONTIMESTAMP is null
		and c.caseid not in (select caseid from batchpayload where caseid is not null)
      union      
      select batchid id, clientid, receivedon timestamp, 'Y' ISZIPBATCH
        from clientzipbatches z
        where NUMOFFILES=(select count(distinct c.caseid) from CaseHistorySum ch, cases c, batchpayload b
                          where ch.caseid=c.caseid and ch.stageid in (READYTOPUBLISH,READYTOPUBLISH_PDF,READYTOPUBLISH_XML)
						  and ch.STAGESTARTTIMESTAMP is not null and ch.STAGECOMPLETIONTIMESTAMP is null
						  and c.caseid=b.caseid and b.batchid=z.batchid))
    order by timestamp asc)
  where rownum=1;

  if v_iszipbatch='Y' then
    --get current and next stage id 
    select distinct ch.stageid into v_current_stageid from CaseHistorySum ch, cases c, batchpayload b
      where ch.caseid=c.caseid and ch.stageid in (READYTOPUBLISH,READYTOPUBLISH_PDF,READYTOPUBLISH_XML)
	  and ch.STAGESTARTTIMESTAMP is not null and ch.STAGECOMPLETIONTIMESTAMP is null
	  and c.caseid=b.caseid and b.batchid=v_id;
    select nextstageid into v_next_stageid from workflows where stageid=v_current_stageid and clientid=clid and condition='COMPLETION';
    
    -- advance all cases in the batch to PUBLISHING stage
    sql_stmt := 'select caseid from CaseHistorySum where stageid = ' || v_current_stageid || ' and caseid in 
                (select caseid from batchpayload where batchid = ' || v_id || ') 
				and STAGESTARTTIMESTAMP is not null and STAGECOMPLETIONTIMESTAMP is null for update nowait';
    EXECUTE IMMEDIATE sql_stmt;
    
    for r_case in c_cases(v_id) loop
      CASEHISTORY_UTILS.completeStage(r_case.caseid, v_current_stageid, PUBLISHER);
      v_dummy := CASEHISTORY_UTILS.startStage(r_case.caseid, v_next_stageid, PUBLISHER);
      dbms_output.put_line('Case '||r_case.caseid||' moved to stage '||v_next_stageid||'.');
    end loop;
	
    dbms_output.put_line('ISZIPBATCH=Y');
    dbms_output.put_line('BATCHID='||v_id); 
    dbms_output.put_line('CASEID=');
    dbms_output.put_line('CLIENTID='||clid);
    dbms_output.put_line('CURRENTSTAGEID='||v_current_stageid);
    dbms_output.put_line('NEXTSTAGEID='||v_next_stageid);
  else
    --get current and next stage id 
    select distinct ch.stageid into v_current_stageid from CaseHistorySum ch, cases c
      where ch.caseid=c.caseid and ch.stageid in (READYTOPUBLISH,READYTOPUBLISH_PDF,READYTOPUBLISH_XML)
	  and ch.STAGESTARTTIMESTAMP is not null and ch.STAGECOMPLETIONTIMESTAMP is null
	  and c.caseid=v_id;
    select nextstageid into v_next_stageid from workflows where stageid=v_current_stageid and clientid=clid and condition='COMPLETION';

    --try to get lock on the case in CaseHistorySum
    EXECUTE IMMEDIATE 'select ch.caseid from CaseHistorySum ch
    where ch.caseid= ' || v_id ||
    ' and ch.STAGEID= ' || v_current_stageid || ' and ch.STAGESTARTTIMESTAMP is not null and ch.STAGECOMPLETIONTIMESTAMP is null
    for update nowait';

    --Fix for IWN-1026: if another thread grabs the same case and has already called completeStage right before this thread attempts to get a lock,
    --the following select statement will throw NO_DATA_FOUND error so that the case won't be processed by both thread.
    select ch.caseid into v_dummy from CaseHistorySum ch
    where ch.caseid=v_id and ch.STAGEID=v_current_stageid and ch.STAGESTARTTIMESTAMP is not null and ch.STAGECOMPLETIONTIMESTAMP is null;
	
    CASEHISTORY_UTILS.completeStage(v_id, v_current_stageid, PUBLISHER);
    v_dummy := CASEHISTORY_UTILS.startStage(v_id, v_next_stageid, PUBLISHER);

    dbms_output.put_line('ISZIPBATCH=N');
    dbms_output.put_line('BATCHID='); 
    dbms_output.put_line('CASEID='||v_id);
    dbms_output.put_line('CLIENTID='||clid);
    dbms_output.put_line('CURRENTSTAGEID='||v_current_stageid);
    dbms_output.put_line('NEXTSTAGEID='||v_next_stageid);
  end if;
end getNextReadyToReleaseCase2;

/*Based on dpentryid, find out the scale of the code*/  
FUNCTION getCodeScaleForDP(
    p_dpentryid IN INTEGER)
  RETURN INTEGER
Is
  v_caseid Integer;
  v_codeid Integer;
  criticality INTEGER;
  v_category Varchar2(50);
BEGIN
  -- Temporary workaround for RPT-28
  Begin
    select regexp_substr(mh.lineage,'[^/]+', 1, 1) into v_category
    from dpentries dp, medicalhierarchy_leaf_level_v mh
    where dp.dpentryid = p_dpentryid
    AND mh.hid     = dp.hid;
    If (v_category != 'Disease') And (v_category != 'Injuries') Then
      return 1;
    End IF;
  EXCEPTION
  WHEN NO_DATA_FOUND THEN 
    return 1;
  End;
  
  SELECT p.caseid, dp.hid INTO v_caseid, v_codeid
  FROM dpentries dp, pages p
  WHERE 1           =1
  AND dp.dpentryid = p_dpentryid
  AND dp.pageid = p.pageid;

  criticality := getCodeScale2(v_caseid, v_codeid);
  return criticality;
EXCEPTION
WHEN NO_DATA_FOUND THEN 
  criticality := 1;
  return criticality;
END getCodeScaleForDP;

/*Based on client id and code id, find out the scale of the code*/  
FUNCTION getCodeScale1(
    p_clientid IN INTEGER,
    p_codeid   IN INTEGER)
  RETURN VARCHAR2
Is
  criticality INTEGER;
BEGIN
  -- First, see if there is client specific critical entry
  SELECT cr.scale INTO criticality
  FROM medicalhierarchy mc,
    criticalicdlist cr
  WHERE 1           =1
  AND mc.id     = p_codeid
  AND cr.clientid    = p_clientid
  AND mc.name = cr.code_alias
  AND mc.CODETYPE = cr.CODE_TYPE;

  return criticality;
EXCEPTION
WHEN NO_DATA_FOUND THEN 
  -- If there is no client specific critical entry, use the default one
  BEGIN
    SELECT cr.scale INTO criticality
    FROM medicalhierarchy mc,
      criticalicdlist cr
    WHERE 1           =1
    AND mc.id     = p_codeid
    AND cr.clientid   = 0
    AND cr.clientname = 'Default'
    AND mc.name = cr.code_alias
    AND mc.CODETYPE = cr.CODE_TYPE;

    return criticality;
  EXCEPTION
  WHEN NO_DATA_FOUND THEN
    criticality := 1;
    return criticality;
  END;
END getCodeScale1;

/*Based on case id and code id, find out the scale of the code*/  
FUNCTION getCodeScale2(
    p_caseid   IN INTEGER,
    p_codeid   IN INTEGER)
  RETURN VARCHAR2
Is
  v_clientid INTEGER;
  criticality INTEGER;
Begin
  select clientid into v_clientid from cases where caseid=p_caseid;
  criticality := getCodeScale1(v_clientid, p_codeid);
  return criticality;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    criticality := 1;
    return criticality;
End getCodeScale2;

procedure clob_to_file( p_dir in varchar2,
                        p_file in varchar2,
                        p_clob in clob )
is
      l_output utl_file.file_type;
      l_buffer  VARCHAR2(32767);
      l_amount  BINARY_INTEGER := 32000;
      l_pos     INTEGER := 1;
BEGIN
       l_output := utl_file.fopen(p_dir, p_file, 'w', 32760);
       LOOP
        DBMS_LOB.read (p_clob, l_amount, l_pos, l_buffer);
        UTL_FILE.put(l_output, l_buffer);
		UTL_FILE.FFLUSH(l_output);
        l_pos := l_pos + l_amount;
        --utl_file.new_line(l_output);
      END LOOP;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    -- Expected end.
    UTL_FILE.fclose(l_output);
  WHEN OTHERS THEN
    UTL_FILE.fclose(l_output);
    RAISE;
END clob_to_file;

procedure BATCHPAYLOAD_XML_to_file
      (p_dir in varchar2,
       P_CASEID in number default null,
       p_file_extn in varchar2 default '.xml')
is
BEGIN
       for x in ( select *
                    from BATCHPAYLOAD
                   where caseid = nvl(P_CASEID,caseid) and xmldata is not null )
       loop
            clob_to_file( p_dir,
                          x.ORIGINALPDFFILENAME || p_file_extn,
                          x.xmldata );
       end loop;
END BATCHPAYLOAD_XML_to_file;
 
/*get assigned categories for a user in a parallelized stage*/
Function getVisibleCategories(p_userid IN INTEGER, p_caseid IN INTEGER, p_stageid IN INTEGER)
	Return Varchar2
is
  v_categories varchar2(2000);
begin
  select LISTAGG(category, ', ') WITHIN GROUP (ORDER BY category) 
  	into v_categories from
	(select distinct rc.category from
		PARALLELCASESTATUS pc,
		ROLECategories rc
	where 1=1
	and pc.userid = p_userid
	and pc.caseid = p_caseid
	and pc.stageid = p_stageid
	and pc.roleid = rc.roleid
	union								--IWN-920 Show assigned categories based on the assigned stage ids
	select distinct rc.category from
    	rolestages rs,
		ROLECategories rc
	where 1=1
	and rs.stageid = p_stageid
	and rs.roleid = rc.roleid);
  If v_categories='' or v_categories is null Then
  	v_categories := 'All';
  End If;
  return v_categories;
exception
when others then
  v_categories := 'All';
  return v_categories;
end getVisibleCategories;

/*get assigned document types for a user in a parallelized stage*/
Function getVisibleDocTypes(p_userid IN INTEGER, p_caseid IN INTEGER, p_stageid IN INTEGER)
	Return Varchar2
is
  v_doctypes varchar2(2000) := 'All';
begin
  select LISTAGG(documenttypename, ', ') WITHIN GROUP (ORDER BY documenttypename) 
  	into v_doctypes from
	(select distinct dt.documenttypename from
		PARALLELCASESTATUS pc,
		ROLEDOCTYPES rd,
		documenttypes dt
	where 1=1
	and pc.userid = p_userid
	and pc.caseid = p_caseid
	and pc.stageid = p_stageid
	and pc.roleid = rd.roleid
	and rd.documenttypeid = dt.documenttypeid
	union										--IWN-921 Show assigned doc types based on the assigned stageids
	select distinct dt.documenttypename from
		rolestages rs,
		ROLEDOCTYPES rd,
		documenttypes dt
	where 1=1
	and rs.stageid = p_stageid
	and rs.roleid = rd.roleid
	and rd.documenttypeid = dt.documenttypeid);
  If v_doctypes='' or v_doctypes is null Then
  	v_doctypes := 'All';
  End If;

  return v_doctypes;
exception
when others then
  v_doctypes := 'All';
  return v_doctypes;
end getVisibleDocTypes;


/*check the completion status of a case at a parallel stage;
  if all parallel tasks are completed, advance the case to the next stage.*/
Procedure advanceParallelStage
Is
	cursor c_cases is
		select c.caseid, c.stageid, s.stagename from cases c, stages s
			where c.stageid = s.stageid and s.parallelism > 0;
 	v_dummy INTEGER;
 	v_nextstageid Integer;
Begin
	for r_case in c_cases loop
		dbms_output.put_line('Checking Case '||r_case.CaseId||' at '||r_case.stagename||' ...');
    	Begin
			select '1' into v_dummy from PARALLELCASESTATUS where caseid = r_case.CaseId and stageid = r_case.Stageid and IsCompleted = 'N';
			--dbms_output.put_line('Case '||r_case.CaseId||' is incomplete at '||r_case.stagename);
		Exception
		When TOO_MANY_ROWS then
			--dbms_output.put_line('Case '||r_case.CaseId||' is incomplete at '||r_case.stagename);
			null;
		When no_data_found Then
			--all rows for the caseid and stageid are marked completed
			Begin
				select w.nextstageid into v_nextstageid
					from workflows w, cases c
					where w.clientid = c.clientid
					and c.caseid = r_case.CaseId
					and w.stageid = r_case.Stageid
					and w.condition='COMPLETION';
				update cases
					set stageid = v_nextstageid,
						userid = null,
						ASSIGNMENTTIMESTAMP = null,
						ASSIGNEDBY = null,
						STAGESTARTTIMESTAMP = current_timestamp,
						UPDATED_TIMESTAMP = current_timestamp,
						UPDATED_USERID = null,
						UPDATED_STAGEID = r_case.Stageid
					where caseid = r_case.CaseId;
				commit;
				dbms_output.put_line('Case '||r_case.CaseId||' is completed at '||r_case.stagename||' and moved to next stage.');
			Exception
			When others Then
				dbms_output.put_line('An error was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);
			End;
		When others Then
			dbms_output.put_line('An error was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);
		End;
	end loop;
End advanceParallelStage;





 FUNCTION    USERIDLIST_TO_USERNAME
       ( P_Useridlist Varchar2,  
         P_DELIMITER varchar2 default ', ',  
         P_Format     Varchar2 Default Null
    
        )
    
   -- Created 3-30-2013 R Benzell
    -- Take a String of colon userids  like:  22:2:3
    -- and convert them into user names separated by delimiters

    
        RETURN VARCHAR2   -- Y or N 
    
        Is
        --V_Count Number Default 0;
        V_Return Varchar2(32000) Default null;
        v_UserNameList varchar2(32000);
        USERID_Arr2 HTMLDB_APPLICATION_GLOBAL.VC_ARR2;

      
        BEGIN
            
   USERID_Arr2 := HTMLDB_UTIL.STRING_TO_TABLE(P_Useridlist,':'); 
  
  
    For I In 1..Userid_Arr2.Count
     Loop
       If V_Usernamelist Is Null
        Then  V_Usernamelist :=  userid_to_username(Userid_Arr2(I));
        Else  V_Usernamelist := V_Usernamelist ||
                        P_Delimiter ||
                        Userid_To_Username(Userid_Arr2(I));
      end if;
    End Loop;
           
    
     v_Return := v_USERNAMELIST;
      
        return v_Return;
       
       EXCEPTION WHEN OTHERS THEN 
            htp.p(SUBSTR(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
                              CHR(13) || 
                SQLERRM,1,4000));
            v_Return := 'No';
            return v_Return;

           
    END USERIDLIST_TO_USERNAME;

 
 
 Function  GET_POP_USERIDLIST
       ( P_Caseid Number,  
         P_Stageid Number, 
         P_Delimiter Varchar2 Default ', ',  
         P_Format Varchar2 Default 'NAME'   -- or NUM
        )	
    
   -- Created 3-20-2013 R Benzell
    -- If the StageID Is a POPStage, then returns the Users 
    -- who had been assigned to the POP Roles

    
        RETURN VARCHAR2   -- Y or N 
    
        Is
    
        --V_Count Number Default 0;
        V_Return Varchar2(32000) Default null;
        V_Useridlist Varchar2(1000);
       -- v_SQL varchar2(1000);

      
        BEGIN
        
        
       For A In ( Select distinct(Userid)
                    From Parallelcasestatus
                   Where Caseid = P_Caseid  And Stageid = P_Stageid
                   And Userid Is Not Null)
       Loop
               If V_Useridlist Is Null
                 Then V_Useridlist :=  A.Userid;
                 Else V_Useridlist := V_Useridlist || ':' || A.Userid;
               End If;
      
               
       end loop;
            
    
      Case
       When P_Format = 'NAME' Then
          V_Return := Useridlist_To_Username(V_Useridlist,P_DELIMITER);
       When P_Format = 'NUM' Then
          V_Return := V_Useridlist;
       ELSE 
          V_Return := V_Useridlist;
      END CASE;    
      
        return v_Return;
       
       EXCEPTION WHEN OTHERS THEN 
            htp.p(SUBSTR(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
                              CHR(13) || 
                SQLERRM,1,4000));
            v_Return := 'No';
            return v_Return;

           
    End GET_POP_USERIDLIST;
    

function IS_CASE_ASSIGNED
       ( P_Caseid Number,  
	     P_ROLEID Number default NULL,
         P_Format Varchar2 Default 'YN'   -- or 'YNP'
	   )
    
    -- Created 3-27-2013 R Benzell
    -- Return Y (assigned) or N (not assigned) or P (partially assigned)
	-- check Stage first
	-- For non-pop, simply see if CASES.USERID is null
	-- If in PopStage, then
	--     IF P_format=YN
	--        all pops assigned (or completed) then Y, else N
	--     IF   P_format=YNP  	
	--        all pops assigned (or completed) then Y
	--        no pops assigned or completed then N
	--        some pops unassigned then P
	
	    
        RETURN VARCHAR2   -- Y or N 
    
        Is
    

        V_Return Varchar2(55) Default null;
		V_StageId number;
		V_UserId number;
		V_Count number;
		v_PARALLELISM number;
		
		

      
        BEGIN
        
     --- Get current stage (and userid)of this Case   
	  Select STAGEID, USERID 
	   into v_Stageid, v_userid
	    from CASES
		WHERE CASEID = P_CASEID;
		
	 --- See if its in a POP Stage
	   	Select PARALLELISM into v_PARALLELISM
		 from STAGES
		 WHERE STAGEID = v_Stageid;

CASE
   --- NON-pop, not Assiged			 
	WHEN v_PARALLELISM = 0 AND v_USERID is NULL
	  THEN v_RETURN  := 'N';  

   --- NON-pop, not Assiged	   	
	WHEN v_PARALLELISM = 0 AND v_USERID is NOT NULL
	  THEN v_RETURN  := 'Y';
	  
   --- POP, but only interested in a particular role	  
    WHEN P_ROLEID IS NOT NULL
	  THEN
	  	 --- POP - See how many POPs are Completed or Assigned
	   	Select count(*) into v_Count
		 from PARALLELCASESTATUS
		 WHERE CASEID = P_CASEID
		       AND STAGEID = v_Stageid
			   AND ROLEID = P_ROLEID
               AND (ISCOMPLETED='Y' OR USERID IS NOT NULL);
		IF v_Count = 0 
		  THEN 	v_RETURN  := 'N';
	      ELSE  v_RETURN  := 'Y';
	    END IF;

	ELSE
	  --- POP - See how many POPs are Completed or Assigned
	   	Select count(*) into v_Count
		 from PARALLELCASESTATUS
		 WHERE CASEID = P_CASEID
		       AND STAGEID = v_Stageid
               AND (ISCOMPLETED='Y' OR USERID IS NOT NULL);
		CASE
		  WHEN v_Parallelism = v_Count
			THEN v_RETURN  := 'Y';
			
		  WHEN v_Count = 0
			THEN v_RETURN  := 'N';
			
		  WHEN v_Count <  v_Parallelism  AND P_FORMAT = 'YN'
			THEN v_RETURN  := 'N';
			
		  WHEN v_Count <  v_Parallelism  AND P_FORMAT = 'YNP'
			THEN v_RETURN  := 'P';
			
		ELSE v_RETURN  := 'E cnt=' || v_count ||  ' parl=' || v_Parallelism || ' format=' ||P_FORMAT;
			
			 -- error - should not be possible
	END CASE;
END CASE;		
	 		

 RETURN V_REturn;
 
 END IS_CASE_ASSIGNED;
 
 
 
FUNCTION     STATUS_ICON 
      ( P_CASEID  number default NULL,  
        P_STAGEID number default NULL,
        P_USERID   number default NULL,
		P_FILE_SEGMENT number default NULL,
	    P_ISCOMPLETED varchar2 default NULL,
		P_PCSID number default NULL
		
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
	-- 03-27-2013 R Benzell.  For POP stages, add CASEID to where clause against PARALLELCASESTATUS query
	--                        Added QC parallel Icons
	-- 04-13-2013 R Benzell.  Added exception trap to PARALLELISM count query to handle Null 
	--                        or otherwise invalid STAGEID values that are encountered.
    -- 08-12-2013 R Benzell  Determine Icon from STAGES Filename   
	-- 12-4-2013 R Benzell Add support for Segmentations
    
--- Icon names (in /ORACLE/fmw/Oracle_OHS1/instances/instance1/config/OHS/ohs1/images)
   

    

    
        RETURN VARCHAR2 
    
        IS
    
        v_Return Varchar2(500) default null;
        --v_UserId Number  default null;
        v_Parallelism Number  default null;
		
		v_ASSIGNED_ICON_NAME varchar2(80); 
		v_UNASSIGNED_ICON_NAME varchar2(80);
		v_COMPLETED_ICON_NAME varchar2(80);
    v_IS_SEGMENTED_STAGE number;

        v_Icon_Path varchar2(10);
        --v_random number;
      
        BEGIN
        
   v_Icon_Path := '/i/';
            


   BEGIN
     SELECT ASSIGNED_ICON_NAME, UNASSIGNED_ICON_NAME, COMPLETED_ICON_NAME, PARALLELISM
      into v_ASSIGNED_ICON_NAME, v_UNASSIGNED_ICON_NAME,v_COMPLETED_ICON_NAME,v_IS_SEGMENTED_STAGE
	  from STAGES
	  WHERE STAGEID =  P_STAGEID;
	 EXCEPTION
	   WHEN OTHERS THEN  
	   	 v_Return  :=  v_Icon_Path || 'UnknownStatus.png';
		 return v_return;
	END;	 


 --- If no icons found	
	If v_ASSIGNED_ICON_NAME is null
	  then v_ASSIGNED_ICON_NAME := 'UnknownStatus.png';
	End if;

	If v_UnASSIGNED_ICON_NAME is null
	  then v_UnASSIGNED_ICON_NAME := 'UnknownStatus.png';
	End if;
	  	
		
	 
      CASE
	     WHEN P_ISCOMPLETED = 'Y' AND v_IS_SEGMENTED_STAGE = 9999 then
	        v_Return  := v_Icon_Path ||  v_COMPLETED_ICON_NAME;	

         --WHEN P_USERID IS NULL or P_ISCOMPLETED = 'R' then
	     --   v_Return  := v_Icon_Path || v_UNASSIGNED_ICON_NAME;
		
         WHEN P_USERID is NULL then 
            v_Return  := v_Icon_Path || v_UNASSIGNED_ICON_NAME;

         WHEN P_USERID is NOT NULL then 
             v_Return  := v_Icon_Path ||v_ASSIGNED_ICON_NAME;
		
         ELSE v_Return  := v_Icon_Path || 'UnknownStatus.png';
      END CASE;	  



        return v_Return;
       
       EXCEPTION WHEN OTHERS THEN 
            return v_Icon_Path || 'UnknownStatus.png';
           
       END STATUS_ICON;
 
 
 
 
 
 
 
FUNCTION   "BUILD_IWS_URL"
    (P_CASEID          number   default null,   
     P_STAGEID         number   default null,
     P_USERID          number   default null,  
     P_ENV             varchar2 default 'AUTODETECT',
     P_GLOBALSESSIONID number   default null,
     P_APEXSESSIONID   number   default null,   
     P_FORMAT          varchar2 default null)
    
    -- Created 10-12-2011 R Benzell
    -- Generated the full URL necessary to invoke the IWS screen
    -- Updated
    -- 10-13-2011 R Benzell
    -- to Test:  select BUILD_IWS_URL(1,4,3,'DEV') from dual
    --    select BUILD_IWS_URL(1,4,3,'AUTODETECT') from dual
    --    select BUILD_IWS_URL(1,4,3,'INT') from dual
    -- 10-17-2011 R Benzell
    -- Designated 3 environments: DEV-EXT-SSL,DEV-INT-SSL,DEV-INT-NONSSL
    -- 10-20-2011 R Benzell
    -- Added Domain, Port and SSL parameters.  Altered App parameters to CamelHump format
    -- 10-21-2011 R Benzell
    -- Added DEV-CITRIX-SSL, and AUTODETECT
    -- 10-23-2011 R Benzell
    -- Added Stage and role parameter to output
    -- 10-25-2011 R Benzell
    -- Disabled Stage and role from output based on updated requirements
    -- 10-26-2011 R Benzell
    -- Reactivated Stage and role from output based on updated requirements
    -- Also, deactivated non-camel format AppScreen and AppId
    -- 11-1-2011 R Benzell
    -- Added Trap for no Sessions found to avoid the following error when no Session info was found
    --   'ORA-06503: PL/SQL: Function returned without value'
    -- 11-11-2011 R Benzell.  Added "&debug=pi" for debug testing  
    -- 12-5-2011 R Benzell - derive "debug=" flag based on table USER field DEBUG value
    -- 12-7-2011 R Benzell - Use system debug value if no user value indicated
    -- 5-8-2012 R Benzell - removed unused global Session id from URL
    --          added Cookie return info
    -- 6-12-2012 R Benzell - added TR step invocation
    -- 6-15-2012 R Benzell - Added LOCAL PC Debug option, for DEV environment only
    --                 removed unused  cookieName, cookiePath  and cookieDomain info
    -- 6-28-2012 R Benzell - added CX/OP2 Step invocation
    -- 8-18-2012 R Benzell support dual IWS versions based on UAT role
    --                    Better mismatched Host debug info  
    -- 11-14-2012 R Benzell - support for RX, DR and NS Step2 
    -- 3-19-2013 R Benzell - support for POP
	-- 3-29-2013 R Benzell - support for PQ1
	-- 4-24-2013 R Benzell - IWN-645 Update "Local Debug" launch URL to include context root "synodex", and correct the domain parameter
	-- 9-17-2013 R Benzell - IWN-834 Add PK of CaseHistorySum record to IWS launch URL
	-- 10-22-2013 R Benzell - added step2, corrected to provide stage_chid
	-- 11-5-2013 R Benzell - IWN-1000 - invoke only a single stage
    -- 11-15-2013 R Benzell - IWN-1031 - invoke cluster of stages by app_functional_group
    
    -- final format should be something like
    -- /synodex/step1.jsp?caseId=123&globalSessionId=27&apexSessionId=3929040116295472
    -- /synodex/step2.jsp?caseId=123&globalSessionId=27&apexSessionId=3929040116295472
    -- /synodex/step3.jsp?caseId=123&globalSessionId=27&apexSessionId=3929040116295472
    -- /synodex/step4.jsp?caseId=123&globalSessionId=27&apexSessionId=3929040116295472
    

    
        RETURN VARCHAR2
    
        IS
    

       v_URL_HEADER varchar2(255) default null;
       v_ENV varchar2(15);
       v_STEP varchar2(15);
       v_Return varchar2(4000) default null;
	   v_stages varchar2(4000) default null;
	   I number default 0;
	   V_STAGEID number;
     v_stage_chid number;

      --- parameters for IWS returning control to Apex 
      v_Domain varchar2(100);
      v_Port varchar2(10);
      v_SSL varchar2(10);
      v_Role varchar2(2);

      --- Dubugger control
      v_Debug varchar2(10);

 
       --Env Lookup
       v_Org_ENV varchar2(30);
       --v_match_split_pos number;
       

      --- cookie lookup
        v_cookie_name varchar2(256);
        v_cookie_path varchar2(256);
        v_cookie_domain varchar2(256);
        v_secure boolean;
        


        BEGIN
        
         V_ENV := P_ENV;
         v_stage_chid := 0;  
        --v_debug := P_FORMAT;

       --execute immediate 'insert into errorlog (ACTIONID,ACTIONNAME) values (1,''eeeddddd'') ';   
         
      --- Set proper URL header based on the Environment
      --- DEV-EXT-SSL,DEV-INT-SSL,DEV-INT-NONSSL
       CASE
           WHEN v_ENV = 'AUTODETECT'
              then 
                --- Get Original Connection type from SESSIONS Tables
               BEGIN
                 Select CONN_ENV into v_Org_ENV
                 from SESSIONS
                  where APEXSESSIONID = v('APP_SESSION');
               EXCEPTION WHEN OTHERS THEN
                    BEGIN
                      v_URL_HEADER := 'NO AUTODETECT SESSION FOUND for: >>>' || v('APP_SESSION') || '<<<';
                    END;
               END;
           
             --- On original proxy invocation, this field contains the source Domain
            --  v_match_str := owa_util.get_cgi_env('HTTP_REFERER');
            --  if v_match_str IS NULL
            --    then 
            --      htp.p(SHOW_CGI_INFO());   -- show error for debug
            --      v_match_str := owa_util.get_cgi_env('HTTP_HOST');
            --  end if;
     
            --  v_match_split_pos := instr(v_match_str,'/pls/apex/f');
            --  v_match_str := lower(substr(v_match_str,1,v_match_split_pos-1));


               BEGIN
                  select 
                    IWS_URL_PREFIX,
                    SSL,
                    DOMAIN,
                    PORT
                  into  
                    v_URL_HEADER,
                    v_SSL,
                    v_Domain,
                    v_Port
                  from ENV_SETTINGS
                  where ENV = v_Org_ENV
                   and IWS_REL = v('IWS_REL')
                   and  SEQUENCE > 0;
                  EXCEPTION WHEN OTHERS THEN
                       v_URL_HEADER := 
                          'no AUTODETECT APEX_HOST_MATCH entry for: >>>' || v_Org_ENV || '<<<';
               END;
              --htp.p('match:' ||v_Match_Str);
              --htp.p('service path: ' ||OWA_UTIL.GET_OWA_SERVICE_PATH);

       --- Local PC Debug testing - only available on DEV
           WHEN v_ENV = 'LOCAL' 
              then
                 v_URL_HEADER := 'http://localhost:8080/synodex';
                 v_SSL := 'true';
				 v_Domain := 'svrnwjhpv10.newjersey.innodata.net';   -- virnwjhpv04clnx.newjersey.innodata.net, '10.155.1.17';
                 v_Port := '7788';

          

            WHEN v_ENV = 'DEV-EXT-SSL' or
                v_ENV = 'EXTDEV' or
                v_ENV = 'EXT'
              then
                 v_URL_HEADER := 'https://iws-dev.synodex.com:8080/synodex';
                 v_SSL := 'true';
                 v_Domain := 'iws-dev.synodex.com';
                 v_Port := '8080';
                

           WHEN
             v_ENV = 'DEV-INT-NONSSL' 
               then 
                 v_URL_HEADER := 'http://10.150.0.232:16300/synodex';
                 v_SSL := 'false';
                 v_Domain := '10.155.1.17';
                 v_Port := '7787';
                 

           WHEN
               v_ENV = 'DEV-INT-SSL' or
               v_ENV = 'INT'
              then 
                 v_URL_HEADER := 'https://10.150.0.232:16301/synodex';
                 v_SSL := 'true';
                 v_Domain := '10.155.1.17';
                 v_Port := '7788';

           WHEN
               v_ENV = 'DEV-CITRIX-SSL' 
              then
                 v_URL_HEADER := 'https://192.168.158.242:16301/synodex';
                 v_SSL := 'true';
                 v_Domain := '192.168.158.243';
                 v_Port := '7788';
                           
 
           ELSE
             --v_URL_HEADER := 'https://10.150.0.232:16301/synodex';
             v_URL_HEADER := 'http://unknown-' || v_ENV;
       END CASE;




     --- Determine Performance Debug Parameters to send to IWS
     --- See if we have a User specific value that will take precedence
     --- 
        Select DEBUG into v_DEBUG
           FROM USERS
         WHERE USERID = P_USERID;

     --  If no User specific value, use the System Default  value
         IF v_Debug is NULL
           Then v_DEBUG :=
                  IWS_APP_Utils.getConfigSwitchValue(null,'IWS_PERF_DEBUG');
       END IF;

/***  not used.  Was tried as part of a keep-alive solution
      --- Get cookie info
       APEX_CUSTOM_AUTH.GET_COOKIE_PROPS(
          p_app_id =>  v('APP_ID'),
          p_cookie_name => v_cookie_name,
          p_cookie_path => v_cookie_path,
          p_cookie_domain => v_cookie_domain,
          p_secure => v_secure);
***/


  

--- get all the various StageId and chID combinations
    I := 0;



 FOR A IN 
    (	SELECT A.chid as assign_chid,
	           S.chid as stage_chid,
			   A.Stageid,
			   A.Caseid
		From Casehistorysum A,
            CASEHISTORYSUM S
		Where A.assignmentstarttimestamp IS NOT NULL 
			  And A.Assignmentcompletiontimestamp Is Null 
			  And A.Userid = P_USERID
              And A.Caseid=P_CASEID
       		  And S.Caseid=A.Caseid
      		  And S.Stageid=A.Stageid
      		  And S.Stagestarttimestamp Is Not Null 
			  And S.stagecompletiontimestamp Is Null 	
		      AND A.StageID	= P_STAGEID   -- IWN-1000 force only one stage to execute at a time (temp disable for 2.7)
			  And A.Stageid	In (Select Stageid From Workflows_By_Thread  -- IWN-1031 - return stages in same Func Group
                                Where User_Function_Group In 
                                                    (Select User_Function_Group From Workflows_By_Thread
                                                    where stageid = P_STAGEID)
								) 
		)		


	 LOOP
	 	 I := I + 1;
     if V_STAGE_CHID != a.STAGE_CHID OR v_stage_chid = 0 then
        V_STAGES := V_STAGES ||  '&stageId=' || a.STAGEID || '&chId='    || a.STAGE_CHID;
     END IF;
								  
      --- Grab the first StageId for later use to determin Step Type
		If I = 1 then
			V_STAGEID := a.STAGEID;
      v_stage_chid :=A.STAGE_CHID;
		end if;								  
	 END LOOP;


--- Determine Step from first Stage        
       CASE
         --- Step 1  
           WHEN v_StageId = 4  then
             v_STEP := '/step1?';
             v_Role := 'OP';
       
           WHEN v_StageId = 5 then
             v_STEP := '/step1?';
             v_Role := 'QA';


          --- Step 2
           WHEN v_StageId = 6  Or P_Stageid  = 66  -- 2-OP, RX
             Or P_Stageid = 67 Or P_Stageid  = 68  -- 2-LT, 2-DR
             OR P_STAGEID = 71  
			 Or P_Stageid = 101   -- DP-General
			 Or P_Stageid = 102   --DP-DI
			 Or P_Stageid = 103   --DP-Tests
			 Or P_Stageid = 104   --DP-Drugs
 			 Or P_Stageid = 105   --Tran-DI
			 then   --Step2-POP
             v_STEP := '/step2?';
             v_Role := 'OP';
        
           WHEN v_StageId  = 7 or P_Stageid = 72 
		   	Or P_Stageid = 118	--QC1-General
			Or P_Stageid = 119	--QC1-DI
			Or P_Stageid = 120	--QC1-Tests
			Or P_Stageid = 121	--QC1-Drugs
		   then
             v_STEP := '/step2?';
               v_Role := 'QA';

           WHEN v_StageId  = 48 then
             v_STEP := '/step2?';
               v_Role := 'CX';


           WHEN v_StageId  = 49 then
             v_STEP := '/step2?';
               v_Role := 'TR';


         --- Step 3  
           WHEN v_StageId = 8  then
             v_STEP := '/step3?';
             v_Role := 'OP';

           WHEN v_StageId = 9 then
             v_STEP := '/step3?';
             v_Role := 'QA';


          --- Step 4
           WHEN v_StageId = 10  then
             v_STEP := '/step4?';
             v_Role := 'OP';

           WHEN v_StageId = 11 then
             v_STEP := '/step4?';
             v_Role := 'QA';

          --- QA Review 
           WHEN v_StageId = 50 then
             v_STEP := '/step2?';
             v_Role := 'QA';


          ELSE
             v_STEP := '/step1?';
           v_Role := 'OP'; 
       END CASE;   



 
     --- String it all together
         v_Return := v_URL_HEADER || v_Step           ||
              'caseId='           || P_CASEID         ||
              '&apexSessionId='   || v('APP_SESSION') ||
              '&appId='           || v('APP_ID')      ||
              '&appScreen='       || v('APP_PAGE_ID') ||
              '&ssl='              || nvl(v_SSL,' ')   ||
              '&domain='          || nvl(v_Domain,' ')||
              '&port='            || nvl(v_Port,' ')  ||
              '&debug='           || v_Debug          ||
			  v_stages;   
	 
   RETURN v_Return;
       
       EXCEPTION WHEN OTHERS THEN
            v_Return := SUBSTR(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
                              CHR(13) ||
                              SQLERRM,1,4000); 
           
       END BUILD_IWS_URL;
	   


FUNCTION TIMESTAMP_TO_DATE 
 ( P_TIMESTAMP  timestamp default NULL  )	
  RETURN Date
Is

  v_Return date;
  
BEGIN

     v_Return := TO_DATE (TO_CHAR 
          (P_TIMESTAMP, 
          'YYYY-MON-DD HH24:MI:SS'),
          'YYYY-MON-DD HH24:MI:SS');
		  
  return v_Return;
  
EXCEPTION
	When others then return null;  

END TIMESTAMP_TO_DATE;	   



FUNCTION   GET_TEMPLATE_NAME
    (P_CASEID          number   default null,   
     P_POSITION        number   default null
     )	
    
	 Return varchar2
--- to test:
--- select GET_TEMPLATE_NAME(2228,1) from dual  	 
	Is

   v_sql varchar2(300);
   v_Return varchar2(50);
   v_clientid number;
   v_generate varchar2(1);
   v_doctype varchar2(25);
   
  
  BEGIN
	 
 
  --- RPT-89 - If template is not to be Generated, don't return the name
  SELECT clientID INTO v_clientID FROM cases WHERE caseid = p_caseID;
  --v_doctype := 'GEN_IMRS' || ltrim(to_char(p_position))  || 'File';
  v_doctype := 'GEN_IMRSTFile';
  v_generate  := iws_app_utils.getconfigswitchvalue(v_clientID, v_docType);
  
   IF v_Generate = 'Y' then
	 v_sql := 'select  name from
      (select rownum name_seq,t.name from aps_xslt_templates t, cases c
       where t.status=''ACTIVE'' and t.clientid=c.clientid and c.caseid=:CASEID
       order by t.sequence)
       where name_seq=:POSITION ';
	 
	 BEGIN  
	 EXECUTE IMMEDIATE v_SQL into v_Return using P_CASEID,P_POSITION;  
     EXCEPTION
 	 WHEN OTHERS then v_return := null;
     END;
   ELSE
 	v_return := null;  -- do not generate
  END IF;	 

	 --v_Return := 'Sar1';
	 
	 Return v_return; 
	 
	EXCEPTION
	When others then return null;    
	 
END GET_TEMPLATE_NAME;  



PROCEDURE  DISPLAY_IMAGE_INLINE
--- grant execute ON snx_iws2.UCM_UTILS to APEX_PUBLIC_USER 
--  add access for IWS_APP_UTILS.DISPLAY_IMAGE_INLINE to update wwv_flow_epg_include_mod_local
-- Wraps display image in an iframe
    (P_URL         varchar2  default null,   
     P_HEIGHT      number    default 1000,
	 P_WIDTH       number    default 850
     )	
    
	
        IS

  BEGIN
 
	
    htp.p('
    <iframe src="' || P_URL  ||
    '" width="' || P_WIDTH ||   '" height="' || P_HEIGHT ||
    '"> </iframe>');



 --- Catch errors and show their line numbers
    EXCEPTION WHEN OTHERS THEN SHOW_APEX_ERROR;


END DISPLAY_IMAGE_INLINE;  



  
PROCEDURE  GET_DISPLAY_IMAGE
    (P_TABLE        varchar2  default null,   
     P_BLOB_COLUMN  varchar2  default null,
	 P_FILENAME     varchar2  default null,
	 P_MIME_TYPE    varchar2 default 'application/pdf',
	 P_KEY_COLUMN   varchar2  default null,
	 P_KEY_ID       number    default null
     )

/**
to test:

begin
IWS_APP_UTILS.GET_DISPLAY_IMAGE(
P_TABLE=>'APS_XSLT_TEMPLATES',
P_BLOB_COLUMN=>'SAMPLE',
P_FILENAME=>'test.pdf',
P_MIME_TYPE=>'application/pdf',
P_KEY_COLUMN=>'TID',
P_KEY_ID=>1);
end;
https://svrnwjhpv10.newjersey.innodata.net:7788/pls/apex/IWS_APP_UTILS.GET_DISPLAY_IMAGE?P_TABLE=APS_XSLT_TEMPLATE&P_BLOB_COLUMN=SAMPLE&P_FILENAME=test.pdf&P_MIME_TYPE=application/pdf&P_KEY_COLUMN=TID&P_KEY_ID=1	
	
***/	 
       IS

  v_SQL varchar2(2000);
  v_BLOB blob;
  v_length number;

  BEGIN

  -- Returning a cursor...
 	v_sql := 'SELECT ' || P_BLOB_COLUMN || ' FROM ' || P_TABLE || ' WHERE ' || 
            P_KEY_COLUMN || ' = :P_KEY_ID ';
			
 	Execute Immediate V_Sql Into V_BLOB Using P_KEY_ID;

    v_length := length(V_BLOB);

 -- Set mime type and the size so the browser knows how much it will be downloading.
  owa_util.mime_header(P_mime_type, FALSE );
  
  htp.p( 'Content-length: ' || v_length);

  -- The filename will be used by the browser if the users does a "Save as"
  htp.p( 'Content-Disposition: filename="' || P_filename || '"' );

  owa_util.http_header_close;
  
  -- below for debug
  --htp.p( 'v_SQL="' || v_SQL || '"' );

  owa_util.http_header_close;
  -- Download the BLOB
  wpg_docload.download_file( v_blob );

 --- Catch errors and show their line numbers
    EXCEPTION WHEN OTHERS THEN SHOW_APEX_ERROR;


END GET_DISPLAY_IMAGE;  




FUNCTION   BLOB_TO_CLOB
    (P_BLOB         BLOB   default null  )	
	 Return CLOB  

	Is

 v_clob         CLOB;
 v_amount       INTEGER default dbms_lob.lobmaxsize;
 v_dest_offset  INTEGER default 1;
 v_src_offset   INTEGER default 1; 
 v_blob_csid    NUMBER default dbms_lob.default_csid;
 v_lang_context INTEGER default dbms_lob.default_lang_ctx;
 v_warning      INTEGER default 0;
   
  
  BEGIN
	 
 DBMS_LOB.CREATETEMPORARY(lob_loc=>v_clob, cache=>TRUE);
 
 dbms_lob.convertToClob(
  dest_lob     => v_clob,  -- IN OUT NOCOPY CLOB CHARACTER SET ANY_CS,
  src_blob     => P_blob,  --   IN     BLOB,
  amount       => v_amount, --   IN     INTEGER,
  dest_offset  => v_dest_offset,  --IN OUT INTEGER,
  src_offset   => v_src_offset,  --IN OUT INTEGER, 
  blob_csid    => v_blob_csid,  --IN     NUMBER,
  lang_context => v_lang_context,  --IN OUT INTEGER,
  warning      => v_warning);        --    OUT INTEGER)
  
    RETURN v_CLOB;
 
  EXCEPTION WHEN OTHERS THEN  LOG_APEX_ERROR();
	            Return NULL;

END BLOB_TO_CLOB; 


FUNCTION   CLOB_TO_BLOB
    (P_CLOB         CLOB   default null
     )	
	 Return BLOB 
	 

	Is

 v_blob          BLOB;
 v_amount       INTEGER default dbms_lob.lobmaxsize;
 v_dest_offset  INTEGER default 1;
 v_src_offset   INTEGER default 1; 
 v_blob_csid    NUMBER default dbms_lob.default_csid;
 v_lang_context INTEGER default dbms_lob.default_lang_ctx;
 v_warning      INTEGER default 0;
   
  
  BEGIN
	 
 DBMS_LOB.CREATETEMPORARY(lob_loc=>v_blob, cache=>TRUE);
 
 dbms_lob.convertToBlob(
  dest_lob     => v_blob,  -- IN OUT NOCOPY CLOB CHARACTER SET ANY_CS,
  src_clob     => P_clob,  --   IN     BLOB,
  amount       => v_amount, --   IN     INTEGER,
  dest_offset  => v_dest_offset,  --IN OUT INTEGER,
  src_offset   => v_src_offset,  --IN OUT INTEGER, 
  blob_csid    => v_blob_csid,  --IN     NUMBER,
  lang_context => v_lang_context,  --IN OUT INTEGER,
  warning      => v_warning);        --    OUT INTEGER)
  
  RETURN v_BLOB;
  
 EXCEPTION
  WHEN OTHERS THEN LOG_APEX_ERROR();
      return NULL;
 
END CLOB_TO_BLOB;  	 



FUNCTION   METRICS_REPORT_AUTH 
    ( P_USERID number default NULL,
      P_RANGE varchar2 default NULL,  -- BEG or END
      P_FORMAT varchar2 default NULL
     )
    
    -- Created 5-9-2013 R Benzell
    -- Determines whether user is authorized to access either:
    -- All None or a single specific team.
    -- because of limitations of how varying ranges can be passed dynamically
    -- in Apex Interactive Report, this function will need to be called twice,
    -- to obtain a lower and upper range that will be used in a BETWEEN statement:
    --
    -- Desired range  TEAM_ACCESS_RANGE('BEG')  between TEAM_ACCESS_RANGE('END')   
    --   NONE            -1                               -1
    --   ALL             0                                999999999
    --   SPECIFIC        3                                3
   
    
        RETURN NUMBER 
    
        IS
    
        v_count number default 0;
        v_userid number default null;
        v_access varchar2(15) default null;
        v_return varchar2(15) default null;
      
       BEGIN
	
	null;
 
      
      --- Userid to check for access      
        if P_USERID is null
            then v_userid := v('USERID');    
            else v_userid := P_USERID;
        end if;
		
		--- See if this person is a Division Group or Head
		Select count(*) into v_count
		 from
         (select headuserid as exec_userid from head
            UNION
         select DIVISIONMANAGERID as exec_userid from DIVISIONS)
         where exec_userid=v_userid;
            
        --- If this is an Division Group, Head or Admin or SuperAdmin
        IF v_count >=1 OR IS_ADMIN(v_Userid) OR IS_ADMIN(v_Userid) 
            THEN  
              v_access := 'ALL';
            ELSE
              -- Return the team this person managers
              BEGIN   
               SELECT TEAMID into v_access 
               from TEAMS 
               where TEAMMANAGERID = v_USERID;
              EXCEPTION
               When others then v_access := null;
             END;
             
         END IF;       

      
       CASE
          WHEN v_access = 'ALL' and P_RANGE = 'BEG'
            then v_Return := 1;

          WHEN v_access = 'ALL' and P_RANGE = 'END'
            then v_Return := 99999999;

          WHEN v_access is NULL  -- no access
            then v_Return := -1;

          ELSE
            v_Return := v_access;  -- specific case

         END CASE;

       Return V_Return;
              
       EXCEPTION WHEN OTHERS THEN 
            v_Return := NULL;
            return v_return;
			
			END  METRICS_REPORT_AUTH;
  
  
FUNCTION  ELAPSED_COUNTDOWN
   (P_TIMESTAMP IN TIMESTAMP default systimestamp,
    P_DUE_ON IN TIMESTAMP default null,  -- DUE_ON 
    P_STATUS IN VARCHAR2 default null,  
    P_SECONDS  IN NUMBER default null,
	P_DONE_MSG IN VARCHAR2 default 'DONE: ',
	P_ONTIME_MSG IN VARCHAR2 default 'Due in: ',
	P_LATE_MSG IN VARCHAR2 default '*OverDue by: ',
	p_LATE_COLOR IN VARCHAR2 default 'RED',
    P_FORMAT IN VARCHAR2 default 'DHM'   -- DHMS for seconds
   )
   RETURN Varchar2
      
   
 -- Program name: ELAPSED_COUNTDOWN
  -- Created: R Benzell 5-16-2013
  -- If P_TIMESTAMP < P_DUE_ON, calls Elapsed_time with (P_TIMESTAMP,P_DUE_ON),
  --     and will prepend the P_ONTIME_MSG message
  -- If P_TIMESTAMP >= P_DUE_ON, calls Elapsed_time with swapped (P_TIMESTAMP,P_DUE_ON),
  --     and will prepend the P_LATE_MSG message and format the color

 --- to test
   --  select iws_app_utils.ELAPSED_COUNTDOWN(systimestamp-2.0723,systimestamp) from dual;
   --  select iws_app_utils.ELAPSED_COUNTDOWN(systimestamp+1.123,systimestamp) from dual;
   
    
  IS
      v_CountDown     VARCHAR2(100) := '' ;

      v_remainder number := 0 ;
      v_sec_remainder number := 0 ;
      v_days       NUMBER  := 0;  
      v_hours      NUMBER  := 0;
      v_Minutes      NUMBER  := 0;
      v_Seconds      NUMBER  := 0;
      n_age        NUMBER  := 0;
      v_DOB    DATE;

 BEGIN

    CASE
		
      WHEN  P_DUE_ON IS NULL  -- No DueOn implemented, show as blank	
	   THEN v_CountDown := '';		
		
      WHEN  P_STATUS IS NOT NULL  -- simple completion flag	
	   THEN v_CountDown := P_DONE_MSG || ELAPSED_TIME(P_TIMESTAMP,P_DUE_ON);
    
	  WHEN P_TIMESTAMP < P_DUE_ON
	    THEN 
	    v_CountDown := P_ONTIME_MSG || ELAPSED_TIME(P_TIMESTAMP,P_DUE_ON);
		
	  ELSE	
		v_CountDown := P_LATE_MSG   || ELAPSED_TIME(P_DUE_ON,P_TIMESTAMP);
		
		IF p_LATE_COLOR IS NOT NULL
		  THEN v_CountDown := '<font color="' || p_LATE_COLOR  || '">' || 
		                       v_CountDown ||
							   '<font color="black">' ;  
	      END IF;
	END CASE;	  		

    RETURN v_CountDown;
END  ELAPSED_COUNTDOWN;



FUNCTION APPENDED_FROM_CASELISTING
   (P_CASEID IN NUMBER,
    P_LINEBREAK IN VARCHAR2 default '<br>',
    P_FORMAT IN VARCHAR2 default null
   )  
   RETURN Varchar2
      
   
 -- Program name: APPEND_FROM_LIST
  -- Created: R Benzell 5-16-2013
  -- for any case, returns a list of Caseids &Dates that were appended to it, if any
  
     --  select iws_app_utils.APPENDED_FROM_CASELISTING(2228) from dual;
   
    
  IS
      v_Return    VARCHAR2(8000) := '' ;
	  I number default 0;


 BEGIN

    -- Can get info from AUDITLOG, but would be periodically flushed
 	--select timestamp,
	--        originalvalue as from_caseid,
	--		modifiedvalue as details
	--from auditlog 
    -- where actionid=89
    -- and caseid= P_CASEID
    -- order by timestamp
 
 
   FOR A IN 
    (SELECT CASEID
	  FROM CASES
	  WHERE APPENDTOCASEID = P_CASEID
	  ORDER BY CASEID
	 )
	 LOOP
	 	 I := I + 1;
	 	 IF I >= 2
	 	   then v_Return := v_return ||  P_LINEBREAK ||  A.CASEID ;
	       else v_Return :=  A.CASEID ;
		 END IF;
	END LOOP;	 

    RETURN v_Return;


 END APPENDED_FROM_CASELISTING;  
 
 
 
-- function - called by the Ingestor as it processes each case.
-- Based on the case ReceiptTime, it would then look at the SLA and Holiday rules, and calculate the Due Date/Time and store that value in CASES.DUE_ON column.
FUNCTION SLA_DUE_ON 
    (P_caseId IN NUMBER default null,
	 P_CLIENTID IN NUMBER default null, 
	 P_RECEIVED_ON IN TIMESTAMP default null) 

  RETURN TIMESTAMP	
  
/* to test:
update cases set receipttimestamp=systimestamp where caseid=1884;
update cases set receipttimestamp=to_date('05-20-2013 1400','MM-DD-YYYY HH24MI') where caseid=1884;

Set Serveroutput On;
Begin
  dbms_output.put_line(iws_app_utils.SLA_DUE_ON(1884));
  end;
*/  
  
	
IS 	
	v_working_days_count number;
    v_processed_day_on varchar(4000);
	v_case_id number;
    v_case_client_id number;
    v_client_sla_id number;
    v_close_business_day_on varchar(4000);
    v_close_business_day_HH_MM_on number;
    v_start_business_day_on varchar(4000);
    v_case_receipt_time_only number;
	v_case_receipt_time_AM_PM varchar(4000);
    v_DUE_ON timestamp (6);	
    v_case_reciept_on timestamp (6);
    v_tat_days number;
    
BEGIN
	
	

  IF P_CASEID IS NOT NULL 
   THEN
   	 --- need to determine Client and Date from Case
	 v_case_id := P_CASEID;
     --dbms_output.put_line('CASE ID TO BE PROCESSED... = ' || v_case_id );
     -- client id for given caseid
      select cs.clientid into v_case_client_id from cases cs where cs.caseid = v_case_id; 
     --  dbms_output.put_line('v_case_client_id = ' || v_case_client_id );

      -- case received time
      select cs.receipttimestamp into v_case_reciept_on from cases cs where cs.caseid = v_case_id;
       --dbms_output.put_line('Received_on TimeStamp = ' || v_case_reciept_on );
	ELSE
	  --- Use Client and Date info passed
	  v_case_client_id := P_CLIENTID;	   
      v_case_reciept_on := P_RECEIVED_ON;
	END IF;  

	
  --caseid
  --v_case_id := P_caseId ; 
  --dbms_output.put_line('CASE ID TO BE PROCESSED... = ' || v_case_id );
  -- client id for given caseid
  --select cs.clientid into v_case_client_id from cases cs where cs.caseid = v_case_id; 
--  dbms_output.put_line('v_case_client_id = ' || v_case_client_id );
  
  -- sla_id for clientid
  select sla_id into v_client_sla_id from clients  where clientid = v_case_client_id; 
--  dbms_output.put_line('v_client_sla_id = ' || v_client_sla_id );
  
  -- case received time
  select cs.receipttimestamp into v_case_reciept_on from cases cs where cs.caseid = v_case_id;
  --dbms_output.put_line('Received_on TimeStamp = ' || v_case_reciept_on );
  
  --TAT business days
  select sla.TAT_TARGET into v_tat_days from SLA sla where sla.SLA_ID = v_client_sla_id;
  --dbms_output.put_line('TAT days = ' || v_tat_days );
  
  -- EOD - close business day
  select sla.close_business_day into v_close_business_day_on from SLA sla where sla.SLA_ID = v_client_sla_id;
--  dbms_output.put_line('Close business day on = ' || v_close_business_day_on );
  
  -- SOD - start business day
  select sla.start_business_day into v_start_business_day_on from SLA sla where sla.SLA_ID = v_client_sla_id;

  --extract case recived time part
  v_case_receipt_time_only:=substr(v_case_reciept_on, 11 , 5);
--  dbms_output.put_line('v_case_receipt_time_only = ' || v_case_receipt_time_only);
  
  -- make close business day as hh.mm
  v_close_business_day_HH_MM_on := substr(v_close_business_day_on, 1 , 2) || '.' || substr(v_close_business_day_on, 3 , 4);
--  dbms_output.put_line('v_close_business_day_HH_MM_on = ' || v_close_business_day_HH_MM_on);
 -- get AM/PM date format
  v_case_receipt_time_AM_PM := substr(v_case_reciept_on, 27 , 2);
    
  --dbms_output.put_line('RECEIVED TIME = ' || v_case_receipt_time_only);
  --dbms_output.put_line('CLOSE BUSINESS TIME = ' || v_close_business_day_HH_MM_on);
  
  -- business working days counter
  v_working_days_count := 1;
  
  -- An hour must be between 1 and 12
  IF(v_case_receipt_time_AM_PM = 'PM' AND v_close_business_day_HH_MM_on > 12 ) THEN 
      v_close_business_day_HH_MM_on := v_close_business_day_HH_MM_on - 12;
  END IF;
  -- if received Time <= Close Business Day - Case Receipt Date
  -- else received Time > Close Business Day - Case Receipt Date + 1   
  IF(v_case_receipt_time_only <= v_close_business_day_HH_MM_on) THEN
    v_processed_day_on := trunc(v_case_reciept_on)  ;
  ELSE
    v_processed_day_on := trunc(v_case_reciept_on) + 1;
  END IF; 
   
  -- advance one day - if business started(after getting case) processing day is a Country holiday
  LOOP
    IF(isHoliday(v_processed_day_on , v_client_sla_id) = 1) THEN
      v_processed_day_on :=  TO_TIMESTAMP(v_processed_day_on) + 1;
    ELSE
      EXIT;
    END IF;
  END LOOP;
  
  -- advance one day - if business started(after getting case) processing day is not a working day
  LOOP
    IF(IS_WORKING_DAY(v_processed_day_on, v_client_sla_id) = 0) THEN
      v_processed_day_on :=  TO_TIMESTAMP(v_processed_day_on) + 1;
    ELSE
      EXIT;
    END IF;
  END LOOP;
  
  
  --dbms_output.put_line('PROCESSING DATE START_ON = ' || v_processed_day_on);
  -- looping till TAT working days excluding holidays
    
  WHILE v_working_days_count <= v_tat_days LOOP
    -- getNextDayTo(v_processed_day_on);
    v_processed_day_on := TO_TIMESTAMP(v_processed_day_on) + 1;
    IF(isHoliday(v_processed_day_on , v_client_sla_id) = 0) THEN
      IF(IS_WORKING_DAY(v_processed_day_on, v_client_sla_id) = 1)THEN
         --dbms_output.put_line('WORKING DAY-- ' || v_processed_day_on);
         v_working_days_count := v_working_days_count + 1;
	 ELSE
	 	 null;
         --dbms_output.put_line('NOT A WORKING DAY--' || v_processed_day_on);
      END IF;
	ELSE
	  null;	
      --dbms_output.put_line('HOLIDAY FOUND -- ' || v_processed_day_on);
    END IF;
    -- getNextDayTo(v_processed_day_on);
    --v_processed_day_on := TO_TIMESTAMP(v_processed_day_on) + 1;
  END LOOP;
    
  --Case DUE_ON Timstamp
  --dbms_output.put_line('START BUSINESS TIME WAS = ' || v_start_business_day_on );
  v_DUE_ON := TO_TIMESTAMP(v_processed_day_on || ' ' || v_start_business_day_on ,'dd-mon-yy HH24MI');
  --dbms_output.put_line('DUE_ON DATE IS --- ' || v_DUE_ON);
  
  
  
  Return  v_DUE_ON;
  

 END SLA_DUE_ON; 	
	


-- Function : validates whether processing date is an holiday based on the SLa_id
FUNCTION ISHOLIDAY(P_processed_day_on IN VARCHAR, P_client_sla_id IN NUMBER) RETURN NUMBER
    IS
      v_holiday_calendar_id NUMBER;
      v_is_holiday_found NUMBER;
    BEGIN

      SELECT holiday_calendar_id into v_holiday_calendar_id FROM SLA WHERE sla_id = P_client_sla_id;
      
      SELECT COUNT(*) into v_is_holiday_found FROM HOLIDAY WHERE holiday_calendar_id = v_holiday_calendar_id AND TO_DATE(P_processed_day_on, 'dd-mon-yy') = TO_DATE(holiday_date) ;
      --dbms_output.put_line('v_is_holiday_found: = ' || v_is_holiday_found);
      
      IF(v_is_holiday_found = 1) THEN
        RETURN 1;
      ELSE  
        RETURN 0;
      END IF;
  
  END ISHOLIDAY;


-- Function : validates whether processing date is working day based on the SLa_id
FUNCTION IS_WORKING_DAY(P_processed_day_on IN VARCHAR, P_client_sla_id IN NUMBER) RETURN NUMBER
  IS
     v_case_receipt_dayname varchar(4000);
     v_isWeekDay varchar(4000);
     v_SLA_Week_Column varchar(4000);
  BEGIN
    --get day name
    v_case_receipt_dayname := to_char(to_date(substr(P_processed_day_on,1,10) ,'dd-mm-yy'), 'DY');
    
    v_SLA_Week_Column := 'WORK_' || v_case_receipt_dayname;
    --dbms_output.put_line('DAYNAME = ' || v_SLA_Week_Column);
    
    EXECUTE IMMEDIATE 'SELECT "WORK_'|| v_case_receipt_dayname || '" FROM SLA WHERE sla_id= ' || P_client_sla_id || '' INTO v_isWeekDay ;
    
    IF(v_isWeekDay = 'X') THEN
      RETURN 1;
    ELSE
      RETURN 0;
    END IF;
  
  END IS_WORKING_DAY;



/*this procedure populate the XMLDATA column for the case with data point data in XML format */
PROCEDURE GenerateXMLDataForCase (P_Caseid In Number Default 0)
As
  qryCtx DBMS_XMLGEN.ctxHandle;
  result CLOB;
Begin
  --construct query
  qryCtx := dbms_xmlgen.newContext (
  'SELECT
      cast(MULTISET(SELECT v1.CategoryName,
                           cast(MULTISET(SELECT v2.SubcategoryName,
                                                cast(MULTISET(SELECT v3.CodeID,
                                                                     v3.CodeName,
                                                                     v3.CodeType,
                                                                     v3.CodeDescription,
                                                                     v3.CodeVersion,
                                                                     cast(MULTISET(SELECT trunc(v4.datadate),
                                                                                          v4.dpentryId,
                                                                                          cast(MULTISET(Select DataField
                                                                                                        from XML_DataFields_V v5 where v5.dpentryId = v4.dpentryId) as DataFields_t),
                                                                                          v4.page,
                                                                                          v4.line,
                                                                                          v4.ISCRITICAL,
                                                                                          v4.CRITICALITY,
                                                                                          v4.STATUS
                                                                                   from XML_DATAPOINTS_V v4 where v4.caseId='||P_Caseid||' and v4.CodeID=v3.CodeID) as DataPoints_t)
                                                              from XML_DATAPOINTS_CODE_V v3 where v3.caseId='||P_Caseid||' and v3.CategoryName=v2.CategoryName and v3.SubcategoryName=v2.SubcategoryName Order by v3.codename) as Codes_t)     
                                         FROM XML_DATAPOINTS_SUBCAT_V v2 Where v2.caseId='||P_Caseid||' and v2.CategoryName=v1.CategoryName ORDER BY v2.SubcategoryName) AS Subcategories_t)  
                    FROM XML_DATAPOINTS_CAT_V v1 Where v1.caseId='||P_Caseid||' ORDER BY v1.CategoryName) As MedicalDataCategories_t) APS_Extract_Report
   FROM dual');
  DBMS_XMLGEN.setRowTag(qryCtx, NULL);
  DBMS_XMLGEN.setRowSetTag(qryCtx, NULL);
  DBMS_XMLGEN.setNullHandling(qryCtx, DBMS_XMLGEN.EMPTY_TAG);
  -- now get the result
  result := DBMS_XMLGEN.getXML(qryCtx);
  UPDATE Cases set XMLDATA=result where caseid=P_Caseid;
  commit;
  --close context
  DBMS_XMLGEN.closeContext(qryCtx);
End GenerateXMLDataForCase;  

/*IWN-943 check if client needs encryption and validate public key
# if cut-over date is in the future, return N
# if cut-over date has past and public key is good, return Y
# if cut-over date has past and public key is no good, return E
*/
FUNCTION isEncryptionNeeded (P_CASEID IN NUMBER, P_BATCHID IN NUMBER) RETURN Varchar2
IS
	v_return varchar2(1) := 'E';
	v_clientid number;
	v_code NUMBER;
	v_errm VARCHAR2(512);
Begin
	if (P_CASEID is not null) then
		select clientid into v_clientid from cases where caseid=P_CASEID;
	elsif (P_BATCHID is not null) then
		select clientid into v_clientid from clientzipbatches where batchid=P_BATCHID;
	end if;
	
	Begin
		--if cut-over date is in the future, return N
		select 'N' into v_return from clients
			where clientid=v_clientid and encryption_cutover_date > current_timestamp;
	EXCEPTION
	WHEN NO_DATA_FOUND THEN
		Begin
			--cut-over date has past, if there is one and only one active public key, return Y
			select 'Y' into v_return from CLIENTKEYS
				where clientid=v_clientid
				and KEY_TYPE='PUBLIC'
				and status='ACTIVE'
				and nvl(EFFECTIVE_DATE, current_timestamp) <= current_timestamp 
				and nvl(EXPIRATION_DATE, current_timestamp+1) > current_timestamp;
		EXCEPTION
		WHEN Others THEN
			v_return := 'E';
		end;
	End;
	return v_return;
EXCEPTION
WHEN Others THEN
	v_code := SQLCODE;
	v_errm := SUBSTR(SQLERRM, 1 , 512);
	DBMS_OUTPUT.PUT_LINE('Error code ' || v_code || ': ' || v_errm);
	v_return := 'E';
	return v_return;
End isEncryptionNeeded;	


Function     Show_assign_Status
      ( P_Caseid Number, 
        P_Thread Number Default Null,
        P_FORMAT varchar2 default 'TXT'  --NUM
       )
    
    -- Created 10-15-2013 R Benzell
    -- Returns a Text (later an appropriate icon )
    -- If no thread, returns all stages.  Otherwise just owner of particular thread
    -- Update History
	--  12-5-2013  indicate FILE_SEGMENT info for 2.8
	
    -- Select iws_app_utils.show_assign_status(2845) from dual
    
        RETURN VARCHAR2 
    
        IS
    
        v_Return Varchar2(8000) default null;
        v_UserId Number  default null;
        v_Parallelism Number  default null;

        V_Stagename Varchar2(30);
        V_Stageid Number;
        V_Clientid Number;
        V_Starting_Stageid Number;
   
        v_username  Varchar2(30);
          
        Begin
        
   
        
      Case
     --- All Stages 
      When P_thread is null then
        For A In
        (Select S.Stagename, C.Stageid ,C.Userid, U.Firstname, U.Lastname,C.FILE_SEGMENT
           From Casehistorysum C,
                Stages S,
                Users U
           Where C.Caseid=P_Caseid 
           And S.Stageid=C.Stageid
           And c.Userid = u.Userid (+)
           And ( C.assignmentcompletiontimestamp Is Null  And C.assignmentstarttimestamp Is Not Null)
           Order By C.Stageid,c.file_segment,c.chid
          ) 
         Loop
           V_Return := V_Return || A.firstname || ' ' || A.lastname || ' (' || A.Stagename || ')';
		   IF A.FILE_SEGMENT IS NULL 
		     THEN  V_Return := V_Return || '. ';
   		     ELSE  V_Return := V_Return || '-' || A.FILE_SEGMENT || '.  ';
	       END IF;
         End Loop;



      --- Single Thread Stages
      When P_Thread = 0 Then
	  	FOR A IN (
        Select S.Stagename, C.Stageid ,C.Userid, U.Firstname, U.Lastname,C.FILE_SEGMENT
           From Casehistorysum C,
                Stages S,
                users U
           Where C.Caseid=P_Caseid 
           And S.Stageid=C.Stageid
           and c.userid = u.userid (+)
           And (C.assignmentcompletiontimestamp Is Null  And C.assignmentstarttimestamp Is Not Null)
           And C.Stageid In (Select Stageid From Stages Where Parallel_Group Is Null)
           Order By c.chid desc,C.Stageid,c.file_segment)
           
		   LOOP
             If P_Format = 'NUM'
               Then V_Return :=  V_Return ||  a.Userid || ' ';
	           else  V_Return := V_Return || a.firstname || ' ' || a.lastname || ' (' || a.Stagename || ')';
             end if; 
			 
			 IF A.FILE_SEGMENT IS NULL 
		       THEN  V_Return := V_Return || '.  ';
   		       ELSE  V_Return := V_Return || '-' || A.FILE_SEGMENT || '.  ';
	         END IF;
	       END LOOP;


      --- Parallel Threads  >= 1
      When P_Thread >= 1 Then
        select clientid into v_clientid from cases where caseid = P_caseid;
	  	FOR A IN (
        Select S.Stagename, C.Stageid ,C.Userid, U.Firstname, U.Lastname,C.FILE_SEGMENT
         --Into V_Stagename,V_Stageid,V_Userid,V_Username
           From Casehistorysum C,
                Stages S,
                Users U
           Where C.Caseid=P_Caseid 
           And S.Stageid=C.Stageid
           and c.userid = u.userid (+)           
           And ( C.assignmentcompletiontimestamp Is Null  And C.assignmentstarttimestamp Is Not Null)
           And C.Stageid In (select STAGEID from Workflows_By_Thread  where CLIENTID=v_clientid and THREADNUM = P_THREAD)
		   order by c.stageid,c.file_segment
         )
		   
           LOOP
             If P_Format = 'NUM'
             Then V_Return :=  V_Return || ':' || a.Userid ;
             Else V_Return := V_Return || a.firstname || ' ' || a.lastname || ' (' || a.Stagename || ')';
            End If; 
			
			 IF A.FILE_SEGMENT IS NULL 
		       THEN  V_Return := V_Return || '.  ';
   		       ELSE  V_Return := V_Return || '-' || A.FILE_SEGMENT || '.  ';
	         END IF;	
	      END LOOP;
         


        Else Null; 

        END CASE;
		
		/** for debugging
		v_return := v_return || ' case>>'     || P_Caseid || 
                                '<< thread>>' || P_Thread ||  
								'<< format>>' || P_FORMAT ||
								'<<';
		***/						
        
        return v_return;
       
       Exception When Others Then 
            V_Return := Null;
            return v_return;
       END Show_assign_Status;




Function     Show_Stage_Status
      ( P_Caseid Number, 
        P_Thread Number Default Null,
        P_FORMAT varchar2 default 'TXT'  --NUM
       )
    
    -- Created 10-15-2013 R Benzell
    -- Returns a Text (later an appropriate icon )
    -- If no thread, returns all stages.  Otherwise just owner of particular thread
    -- Update History
	--  12-5-2013 indicate FILE_SEGMENT info for 2.8
	
    -- Select iws_app_utils.show_stage_status(2845) from dual
    
        RETURN VARCHAR2 
    
        IS
    
        v_Return Varchar2(8000) default null;
        v_UserId Number  default null;
        v_Parallelism Number  default null;

        V_Stagename Varchar2(30);
        V_Stageid Number;
        V_Clientid Number;
        v_starting_stageid number;
          
        Begin
        
 
         
        
     Case
     --- All Stages 
      When P_thread is null then
        For A In
        (Select S.Stagename, C.Stageid, C.File_Segment
           From Casehistorysum C,
                STAGES S
           Where C.Caseid=P_Caseid 
           and S.stageid=c.stageid
           And ( C.Stagecompletiontimestamp Is Null  And C.Stagestarttimestamp Is Not Null)
           Order By C.Stageid
          ) 
         Loop
           V_Return := V_Return || A.Stagename || ' (' || A.Stageid || ')';
		   IF A.FILE_SEGMENT IS NULL 
		       THEN  V_Return := V_Return || '. ';
   		       ELSE  V_Return := V_Return || '-' || A.FILE_SEGMENT || '. ';
	        END IF;
         End Loop;

     --- Single Thread Stages
      When P_thread = 0 then
	  	FOR A IN (
        Select S.Stagename, C.Stageid, C.File_Segment 
         --into v_Stagename,v_stageid
           From Casehistorysum C,
                STAGES S
           Where C.Caseid=P_Caseid 
           And S.Stageid=C.Stageid
           And ( C.Stagecompletiontimestamp Is Null  And C.Stagestarttimestamp Is Not Null)
           And C.Stageid In (Select Stageid From Stages Where Parallel_Group Is Null)
           --and rownum=1
           Order By C.Stageid)
           
		   LOOP
           If P_Format = 'NUM'
             Then V_Return := V_Return || a.Stageid || ' ';
             else V_Return := V_Return || a.Stagename || ' (' || a.Stageid || ')';
           end if; 
		   
		   	 IF A.FILE_SEGMENT IS NULL 
		       THEN  V_Return := V_Return || '. ';
   		       ELSE  V_Return := V_Return || '-' || A.FILE_SEGMENT || '. ';
	         END IF;
		  END LOOP;

     --- Parallel Threads  >= 1
      When P_thread >= 1 then
	  	select clientid into v_clientid from cases where caseid = P_caseid;
	  	FOR A IN  (
        Select S.Stagename, C.Stageid, C.File_Segment 
         --into v_Stagename,v_stageid
           From Casehistorysum C,
                STAGES S
           Where C.Caseid=P_Caseid 
           and S.stageid=c.stageid
           And ( C.Stagecompletiontimestamp Is Null  And C.Stagestarttimestamp Is Not Null)
		   And C.Stageid In (select STAGEID from Workflows_By_Thread  where CLIENTID=v_clientid and THREADNUM = P_THREAD)
		   Order By C.Stageid )
		    

		   
          LOOP
           If P_Format = 'NUM'
            Then V_Return :=  v_return || a.Stageid || ' ';
            else V_Return := V_Return || a.Stagename || ' (' || a.Stageid || ')';
           End If;
		   
		    IF A.FILE_SEGMENT IS NULL 
		       THEN  V_Return := V_Return || '. ';
   		       ELSE  V_Return := V_Return || '-' || A.FILE_SEGMENT || '. ';
	         END IF;
	      END LOOP; 
           
         
        Else Null; 

        END CASE;
        
        return v_return;
       
       Exception When Others Then 
            V_Return := Null;
            return v_return;
       END Show_Stage_Status;


/* If userid is present, returns number of open assignments of that case to that user
If no userid, returns count of ope assignements of that cae to ANY user 
to test:  select  Is_Case_Assigned_to_user(2845) from dual;
          select  Is_Case_Assigned_to_user(2845,3) from dual;
*/

Function  Is_Case_Assigned_to_user
      ( P_Caseid Number, 
        P_USERID number Default Null
       )
        RETURN number
		
        IS
    
        v_count number ;
          
        Begin
        
     
       IF P_USERID IS NULL THEN 
        Select count(*) into v_count
           From Casehistorysum 
           Where CASEID = P_CASEID 
		   AND USERID IS NOT NULL
		   AND assignmentcompletiontimestamp Is Null  And assignmentstarttimestamp Is Not Null;
        ELSE		   
         Select count(*) into v_count
           From Casehistorysum 
           Where CASEID = P_CASEID
		   AND USERID = P_USERID 
		   AND assignmentcompletiontimestamp Is Null  And assignmentstarttimestamp Is Not Null;
		END IF;   

       return v_count;		

       END Is_Case_Assigned_to_user;



/* If userid is present, returns number of open assignments of that case to that user
If no userid, returns count of ope assignements of that cae to ANY user 
to test:  select   iws_app_utils.is_stage_in_thread(2845,1,101) from dual;  -- returns Y
         
*/

Function  is_stage_in_thread
      ( P_Caseid Number, 
	    P_Thread number,
        P_StageID number
       )
        RETURN varchar2
		
        IS
    
        v_thread number ;
		v_clientid number ;
		v_startstageid number ;
		v_return varchar2(100);
          
        Begin
	
	   v_return := 'N'; --set default that its not a match
      
	   --- Get Client
	   Select CLIENTID INTO v_clientid 
	   from cases where caseid = p_caseid;
	   --v_return := v_return || v_clientid || ': ';
	   
	   --- Get Starting Stage
	   Select Stageid into v_startstageid
    From (
     Select nextstageid as stageid , rownum as threadnum
      From Workflows Where Clientid=v_clientid
      And Condition='PARALLEL'
      Order By Sequence)
     where threadnum= P_Thread;
	 --v_return := v_return || v_startstageid || '>';
	 
	 --- Walk through workflow, see if this stage is present
	 FOR A IN (
	  Select s.StageName,S.Stageid
         From Stages S,
         Workflows W
      Where s.Stageid= v_startstageid
      and W.Stageid=S.stageid
      Union
      Select    s.stagename, s.STAGEID
       FROM
          (Select Stageid, Nextstageid, Sequence As Seq From Workflows 
                  WHERE clientid=v_clientid 
             ) w,
          Stages S
        Where W.Nextstageid  =S.Stageid  
        And S.Stageid In (Select Stageid From Stages Where Parallel_Group Is Not Null) 
        Start With W.Stageid            =  v_startstageid
        Connect By Nocycle Prior W.Nextstageid=W.Stageid)
		
		LOOP
			--v_return := v_return || '-'|| A.stageid; 
			if A.STAGEID = P_STAGEID
			  then v_return := 'Y';
			end if;
			
		END LOOP; 

       return v_return;		

       END is_stage_in_thread;
	   

FUNCTION  DATAPOINT_COUNT 
    (P_CASEID NUMBER default null)
    
    -- Created 12-1-2011 R Benzell
    -- Used by Finance/billing reports to provide count of Datapoints for a particular case.
    -- does not included ISDELETED (soft deletes) in counts
	-- does not included IS_PAGE_DELETED (page excludes) in counts    
    -- to test:  select DATAPOINT_COUNT(1800) from dual;
    -- Updated 9-16-2012 R Benzell
    -- use SNX_IWS2.DPENTRYPAGES_VIEW 
    -- Updated 10-17-2012 R Benzell
    -- use DPENTRYPAGES_VIEW 
	-- 10-28-2013 R Benzell - do not included excluded pages in counts
    
    
        RETURN number
    
        IS
    
       v_Count number;
        BEGIN
            
       
       BEGIN
         select count(*) into v_Count
          from DPENTRYPAGES_VIEW   --DPENTRYPAGES_VIEW
            where  CASEID = P_CASEID
			AND  IS_PAGE_DELETED = 'N'  
            AND ( ISDELETED = 'N' or ISDELETED IS NULL);
       EXCEPTION WHEN OTHERS THEN 
            v_Count := NULL;
       END;
 
         return v_Count;
       
      END DATAPOINT_COUNT;



FUNCTION  DOCTOR_DATAPOINT_COUNT 
    (P_CASEID NUMBER default null)

    -- SUNSETTED 11-12-2013 R Benzell IWN-875
    -- Created 11-1-2012 R Benzell
    -- Count of DataPoints for a Case that are Not Pharam, Procedure or Test related
    -- does not included ISDELETED (soft deletes) in counts
	-- does not included IS_PAGE_DELETED (page excludes) in counts    
    -- to test:  select DOCTOR_DATAPOINT_COUNT(2047) from dual;
	-- 10-28-2013 R Benzell - do not included excluded pages in counts
    
    
        RETURN number
    
        IS
    
       v_Count number;
        BEGIN
            
       
       BEGIN
         select count(*) into v_Count
          from DPENTRYPAGES_VIEW   
            where  CASEID = P_CASEID 
			AND  IS_PAGE_DELETED = 'N'  			
            AND ( ISDELETED = 'N' or ISDELETED IS NULL)
            AND Category NOT in ('Drugs & Medications',
                             'Procedures', 
                             'Procedures and Hospitalizations',
                             'Microbiology',
                             'Biochemistry',
                             'Endoscopy',
                             'General Diagnostic Tests',
                             'Imaging',
                             'Non-Surgical Procedures') ;
       EXCEPTION WHEN OTHERS THEN 
            v_Count := NULL;
       END;
 
         return v_Count;
       
      END DOCTOR_DATAPOINT_COUNT;  --SUNSETTED




FUNCTION  PROCANDTEST_DATAPOINT_COUNT 
    (P_CASEID NUMBER default null)
    
    -- Created 11-1-2012 R Benzell
    -- Count of DataPoints for a Case that are Procedure or Test related
    -- does not included ISDELETED (soft deletes) in counts
	-- Include Categories like:
					--	('Procedures', 
                    --  'Procedures and Hospitalizations',
                    --  'Microbiology',
                    --  'Biochemistry',
                     -- 'Endoscopy',
                     --  'General Diagnostic Tests',
                     --  'Imaging',
                     --  'Non-Surgical Procedures') ;	
    
    -- to test:  select PROCANDTEST_DATAPOINT_COUNT(2047) from dual;
	-- 10-28-2013 R Benzell - do not included excluded pages in counts
	-- 11-12-2013 R Benzell IWN-875 - update to obtain Categories from ROLECATEGORIES
    
    
        RETURN number
    
        IS
    
       v_Count number;
        BEGIN

          
       
       BEGIN
         select count(*) into v_Count
          from DPENTRYPAGES_VIEW   
            where  CASEID = P_CASEID 
			AND  IS_PAGE_DELETED = 'N'  
            AND ( ISDELETED = 'N' or ISDELETED IS NULL)
            AND Category in (select category from ROLECATEGORIES
			                 WHERE ROLEID IN (106,126,143) );

       EXCEPTION WHEN OTHERS THEN 
            v_Count := NULL;
       END;
 
         return v_Count;
       
      END PROCANDTEST_DATAPOINT_COUNT;



FUNCTION  GENERAL_DATAPOINT_COUNT 
    (P_CASEID NUMBER default null)
    
    -- Created 11-12-2013 R Benzell
    -- Count of DataPoints for a Case that are "General" 
    -- does not included ISDELETED (soft deletes) in counts
	-- Include Categories like:
	--	Restrictions
	--	Non-Medical Risk
	--	Missing Information
	--	General Health
	--	Family History
	--  Background
	--  Activity & Other Risk
    -- to test:  select GENERAL_DATAPOINT_COUNT(2047) from dual;
	-- 11-12-2013 R Benzell IWN-875 - update to obtain Categories from ROLECATEGORIES
    
    
        RETURN number
    
        IS
    
       v_Count number;
        BEGIN
       
       BEGIN
         select count(*) into v_Count
          from DPENTRYPAGES_VIEW   
            where  CASEID = P_CASEID 
			AND  IS_PAGE_DELETED = 'N'  
            AND ( ISDELETED = 'N' or ISDELETED IS NULL)
            AND Category in (select category from ROLECATEGORIES
			                 WHERE ROLEID  IN (104,124,141) );

       EXCEPTION WHEN OTHERS THEN 
            v_Count := NULL;
       END;
 
         return v_Count;
       
      END GENERAL_DATAPOINT_COUNT;



FUNCTION  DI_DATAPOINT_COUNT 
    (P_CASEID NUMBER default null)
    
    -- Created 11-12-2013 R Benzell
    -- Count of DataPoints for a Case that are Procedure or Test related
    -- does not included ISDELETED (soft deletes) in counts
	-- Include Categories like:
	--		Symptoms
	--		Injuries
	--		Disease
	--		Disability Claims
	--		Infectious Disease	
    
    -- to test:  select DI_DATAPOINT_COUNT(2047) from dual;
	-- 11-12-2013 R Benzell IWN-875 - update to obtain Categories from ROLECATEGORIES
    
    
        RETURN number
    
        IS
    
       v_Count number;
        BEGIN
       
       BEGIN
         select count(*) into v_Count
          from DPENTRYPAGES_VIEW   
            where  CASEID = P_CASEID 
			AND  IS_PAGE_DELETED = 'N'  
            AND ( ISDELETED = 'N' or ISDELETED IS NULL)
            AND Category in (select category from ROLECATEGORIES
			                 WHERE ROLEID IN (105,125,142) );

       EXCEPTION WHEN OTHERS THEN 
            v_Count := NULL;
       END;
 
         return v_Count;
       
      END DI_DATAPOINT_COUNT;


FUNCTION   PHARMA_DATAPOINT_COUNT 
    (P_CASEID NUMBER default null)
    
    -- Created 11-1-2012 R Benzell
    -- Count of DataPoints for a Case that are Pharma related
    -- does not included ISDELETED (soft deletes) in counts
	-- does not included IS_PAGE_DELETED (page excludes) in counts
	-- covers categories like: 'Drugs & Medications' 
    
    -- to test:  select PHARMA_DATAPOINT_COUNT(2047) from dual;
	-- 10-28-2013 R Benzell - do not included excluded pages in counts
    -- 11-12-2013 R Benzell IWN-875 - update to obtain Categories from ROLECATEGORIES
    
    
        RETURN number
    
        IS
    
       v_Count number;
        BEGIN
            
       
       BEGIN
         select count(*) into v_Count
          from DPENTRYPAGES_VIEW   
            where  CASEID = P_CASEID 
			AND  IS_PAGE_DELETED = 'N'  			
            AND ( ISDELETED = 'N' or ISDELETED IS NULL)
            AND Category in (select category from ROLECATEGORIES
			                 WHERE ROLEID in (107,127,144) );
       EXCEPTION WHEN OTHERS THEN 
            v_Count := NULL;
       END;
 
         return v_Count;
       
      END PHARMA_DATAPOINT_COUNT;




FUNCTION   DATAPOINT_COUNT_BY_STAGE 
    (P_CASEID NUMBER ,
	 P_STAGEID NUMBER ,
	 P_CURSTAGEID NUMBER default null
	)
  
-- Created 11-06-2013 R Benzell
-- Count of DataPoints for a Case that are related to a particular Role
-- does not included ISDELETED (soft deletes) of DPs or Pages in counts
-- Issue - CREATED_STAGEID is not consistently populated in DB
    
  /* to test:  
  select IWS_APP_UTILS.DATAPOINT_COUNT_BY_STAGE(2326,7) from dual;
  select IWS_APP_UTILS.DATAPOINT_COUNT_BY_STAGE(2326,48) from dual;
  select IWS_APP_UTILS.DATAPOINT_COUNT_BY_STAGE(2326,71) from dual;
  select IWS_APP_UTILS.DATAPOINT_COUNT_BY_STAGE(2326,72) from dual;
  */
   
    
        RETURN number
    
        IS
    
       v_Count number;
        BEGIN
            
       
       BEGIN
         select count(*) into v_Count
          from DPENTRYPAGES_VIEW   
            where  CASEID = P_CASEID 
			AND  IS_PAGE_DELETED = 'N'  			
            AND ( ISDELETED = 'N' or ISDELETED IS NULL)
			AND CREATED_STAGEID = P_STAGEID;
       EXCEPTION WHEN OTHERS THEN 
            v_Count := NULL;
       END;
 
         return v_Count;
       
      END DATAPOINT_COUNT_BY_STAGE;	




   Procedure build_workflows_by_thread 
	/* clears and repopulates the workflows_by_thread table for all clients.
	   should be rerun whenever a workflow is changed or a client is added.
	   Relies upon view parallel_stage_thread_v 
	   -- IWT
   */


/* pre-req view:
create or replace view parallel_stage_thread_v as
Select clientid, nextstageid as stageid, 
ROW_NUMBER() OVER (PARTITION BY clientid ORDER BY sequence) AS threadnum
From Workflows
Where Condition='PARALLEL';

   set serveroutput on;
   begin
   	iws_app_utils.build_workflows_by_thread;
   end;
   
 to validate
Select * From Workflows_By_Thread 
order by clientid,threadnum,sequence,threadseq;
**/
    Is
	
		v_chid Number;
		v_code NUMBER;
   		v_errm VARCHAR2(512);
		v_dummy Number;
		v_lf varchar2(10);
		i number;


	Begin

    i := 0;
    delete from workflows_by_thread;

  FOR A in 
   (SELECT CLIENTID,CLIENTNAME from CLIENTS ORDER BY CLIENTID)
 	LOOP	
	 I := I+1;
	 DBMS_OUTPUT.PUT_LINE(I || ' - ' || A.CLIENTID	|| ' ' || A.CLIENTNAME || '...');
	 --IWN-1103: Add parallelism column to workflows_by_thread table
	 insert into workflows_by_thread 
		SELECT distinct w.clientid,  s.stageid, s.stagename, s.sequence, 0 threadnum, 0 threadseq, 
		  (CASE WHEN (instr(upper(s.stagename),'ERROR')>0) THEN 'Y'  ELSE 'N' END) AS IsErrorStage,
		  s.user_function_group,s.Parallel_Group,s.parallelism
		FROM
		  (SELECT * FROM workflows WHERE CLIENTID= A.CLIENTID) w,
		  stages s
		WHERE w.nextstageid                     =s.stageid
		and s.Parallel_Group Is Null
		and CONDITION in ('COMPLETION', 'NON-PARALLEL', 'ERROR')
		START WITH w.STAGEID                  =0
		  CONNECT BY nocycle PRIOR w.NEXTSTAGEID=w.STAGEID
	UNION
		select k.clientid, t.stageid, t.stagename, t.sequence, k.threadnum, 
		  ROW_NUMBER() OVER (PARTITION BY k.threadnum ORDER BY t.sequence) AS threadseq,  
		  (CASE WHEN (instr(upper(t.stagename),'ERROR')>0) THEN 'Y'  ELSE 'N' END) AS IsErrorStage,
		  t.user_function_group,t.Parallel_Group,t.parallelism
		from
		(SELECT s.stageid, s.stagename, s.sequence, connect_by_root w.stageid start_stageid,s.user_function_group,s.Parallel_Group,s.parallelism
		  FROM
			(SELECT * FROM workflows WHERE CLIENTID=A.CLIENTID and CONDITION='COMPLETION') w,
			stages s
		  WHERE w.stageid                     =s.stageid
		  and s.Parallel_Group Is Not Null
		  START WITH w.STAGEID                  in (
			   Select stageid
				From parallel_stage_thread_v where CLIENTID=A.CLIENTID)
			CONNECT BY nocycle PRIOR w.NEXTSTAGEID=w.STAGEID
			union
			SELECT s.stageid, s.stagename, s.sequence, connect_by_root w.stageid start_stageid,s.user_function_group,s.Parallel_Group,s.parallelism
		  FROM
			(SELECT * FROM workflows WHERE CLIENTID=A.CLIENTID) w,
			stages s
		  WHERE w.nextstageid                     =s.stageid
		  and s.Parallel_Group Is Not Null
		  and CONDITION='ERROR'
		  START WITH w.STAGEID                  in (
			   Select stageid
				From parallel_stage_thread_v where CLIENTID=A.CLIENTID)
			CONNECT BY nocycle PRIOR w.NEXTSTAGEID=w.STAGEID) t,
		parallel_stage_thread_v k
		where t.start_stageid = k.stageid
		and k.CLIENTID=A.CLIENTID
	UNION 
		SELECT
		 A.Clientid,  Stageid, Stagename, 9999 Sequence, 0 Threadnum, 0 Threadseq, 'N' 
		   Iserrorstage, user_function_group, Parallel_Group, parallelism from STAGES WHERE STAGEID = 70
	order by sequence, threadnum, threadseq;
  
  END LOOP;
 
  COMMIT;

End build_workflows_by_thread;
	
	

FUNCTION GET_SEGMENT_COMPLETION_STATUS 
      (P_CASEID NUMBER,
	   P_FORMAT varchar2 default 'APEXVALIDATE')
      RETURN varchar2    
/**
 select iws_app_utils.GET_SEGMENT_COMPLETION_STATUS(2829,'APEXVALIDATE') from dual;
 select iws_app_utils.GET_SEGMENT_COMPLETION_STATUS(2829,'debug') from dual;
**/	  
	  
        IS
    

	v_caseid number;
	v_Return varchar2(500);
	v_Info varchar2(500);
	v_done_count number;
	v_open_assigned_count number;
	v_open_notassigned_count number;
	v_total_count number;
	
   
   BEGIN
            
    v_caseid := P_CASEID;			

	BEGIN
	
	--- Total number of Segments 
	select count(*) into v_total_count
	from PARALLELCASESTATUS
	where CASEID = v_caseid;
	
	
	--- number of Segments that are done
	select count(*) into v_done_count
	from PARALLELCASESTATUS
	where CASEID = v_caseid
	   and ISCOMPLETED = 'Y';
	
	--- number of Segments that are open (not in progress)
	select count(*) into v_open_assigned_count
	from PARALLELCASESTATUS
	where CASEID = v_caseid
	   and USERID IS NOT NULL
	   and (ISCOMPLETED = 'N' or ISCOMPLETED IS NULL);
	
	--- number of Segments that not assigned
	select count(*) into v_open_notassigned_count
	from PARALLELCASESTATUS
	where CASEID = v_caseid
	   and USERID IS NULL
	   and (ISCOMPLETED = 'N' or ISCOMPLETED IS NULL);
	

	
	v_info := 'case = ' || v_caseid ||
	          ' done = ' || v_done_count ||
			  ' Assigned = ' || v_open_assigned_count ||
			  ' notAssigned = ' || v_open_notassigned_count ;

  --- apex validation considers response as an ERROR flag
  --- so supress response when APEXVALIDATE format
	CASE
	  WHEN v_done_count =  v_total_count THEN	
        IF P_FORMAT = 'APEXVALIDATE'
		  then v_return := null;
	      else v_return := 'OK - All segments are completed. ';
       END IF;

	  WHEN v_open_notassigned_count =  v_total_count THEN
        IF P_FORMAT = 'APEXVALIDATE'
		  then v_return := null;
	      else v_return := 'OK - All segments are clear. ';
       END IF;
		

	  WHEN v_open_assigned_count >= 1 THEN	
	    v_return := 'Cannot make requested Stage change.  ' || v_open_assigned_count || 
		   ' segments are still being worked. ';
		

	  WHEN v_done_count <  v_total_count THEN	
	    v_return := 'Cannot make requested Stage change.  ' || v_open_notassigned_count ||
		           ' segments are still awaiting completion. ';

	  
     ELSE
  	  v_return := v_info;
	  
	 END CASE;
	 

	
	return v_Return;
	
  END;
	   
  END GET_SEGMENT_COMPLETION_STATUS;	

FUNCTION GET_THREAD_COMPLETION_STATUS 
      (P_CASEID NUMBER,
	   P_THREADNUM NUMBER default 0,
	   P_FORMAT varchar2 default 'APEXVALIDATE')
      RETURN varchar2    
/**
 select iws_app_utils.GET_THREAD_COMPLETION_STATUS(2831,1,'APEXVALIDATE') from dual
 select iws_app_utils.GET_THREAD_COMPLETION_STATUS(2831,1,'debug') from dual
**/	  
	  
        IS
    
    v_clientid number;
	v_caseid number;
	v_Return varchar2(500);
	v_Info varchar2(500);
	v_done_count number;
	v_open_assigned_count number;
	v_open_notassigned_count number;
	v_total_count number;
	
   
   BEGIN
            
    v_caseid := P_CASEID;			

	BEGIN
		
	--- ClientId for this case 
	select CLIENTID into v_ClientID
	from CASES
	where CASEID = v_caseid;
	
	
	--- Total number of Segments in this thread
	select count(*) into v_total_count
	from PARALLELCASESTATUS
	where CASEID = v_caseid
     and STAGEID in (SELECT STAGEID FROM workflows_by_thread 
	                 where clientid=v_clientid
                      and threadnum=P_THREADNUM and PARALLELISM='9999');
	
	
	--- number of Segments that are done for this thread
	select count(*) into v_done_count
	from PARALLELCASESTATUS
	where CASEID = v_caseid
	   and ISCOMPLETED = 'Y'
	   and STAGEID in (SELECT STAGEID FROM workflows_by_thread 
	                 where clientid=v_clientid
                      and threadnum=P_THREADNUM and PARALLELISM='9999');
	
	--- number of Segments that are open (not in progress)
	select count(*) into v_open_assigned_count
	from PARALLELCASESTATUS
	where CASEID = v_caseid
	   and USERID IS NOT NULL
	   and (ISCOMPLETED = 'N' or ISCOMPLETED IS NULL)
	   and STAGEID in (SELECT STAGEID FROM workflows_by_thread 
	                 where clientid=v_clientid
                      and threadnum=P_THREADNUM and PARALLELISM='9999');
	
	--- number of Segments that not assigned
	select count(*) into v_open_notassigned_count
	from PARALLELCASESTATUS
	where CASEID = v_caseid
	   and USERID IS NULL
	   and (ISCOMPLETED = 'N' or ISCOMPLETED IS NULL)
	   and STAGEID in (SELECT STAGEID FROM workflows_by_thread 
	                 where clientid=v_clientid
                      and threadnum=P_THREADNUM and PARALLELISM='9999');
	

	
	v_info := 'case = ' || v_caseid ||
	          ' done = ' || v_done_count ||
			  ' Assigned = ' || v_open_assigned_count ||
			  ' notAssigned = ' || v_open_notassigned_count ;

  --- apex validation considers response as an ERROR flag
  --- so supress response when APEXVALIDATE format
	CASE
	  WHEN v_done_count =  v_total_count THEN	
        IF P_FORMAT = 'APEXVALIDATE'
		  then v_return := null;
	      else v_return := 'OK - All segments are completed in thread ' || P_THREADNUM ||'. ';
       END IF;

	  WHEN v_open_notassigned_count =  v_total_count THEN
        IF P_FORMAT = 'APEXVALIDATE'
		  then v_return := null;
	      else v_return := 'OK - All segments are clear in thread ' || P_THREADNUM ||'. ';
       END IF;
		

	  WHEN v_open_assigned_count >= 1 THEN	
	    v_return := 'Cannot make requested Stage change.  ' || v_open_assigned_count || 
		   ' segments are still being worked in thread ' || P_THREADNUM ||'. ' ;
		

	  WHEN v_done_count <  v_total_count THEN	
	    v_return := 'Cannot make requested Stage change.  ' || v_open_notassigned_count ||
		           ' segments are still awaiting completion in thread ' || P_THREADNUM ||'. ';

	  
     ELSE
  	  v_return := v_info;
	  
	 END CASE;
	 

	
	return v_Return;
	
  END;
	   
END GET_THREAD_COMPLETION_STATUS;

FUNCTION CONVERT_EST_TO_IST_TIME(P_EST_TIMESTAMP IN TIMESTAMP)
return TIMESTAMP
IS
  V_TIMESTAMP VARCHAR2(100);
  V_ISTTIMESTAMP TIMESTAMP; 
BEGIN
  V_TIMESTAMP := NULL;
  V_ISTTIMESTAMP := NULL;
  IF P_EST_TIMESTAMP IS NOT NULL THEN
   SELECT TO_CHAR(FROM_TZ(CAST(P_EST_TIMESTAMP AS TIMESTAMP), 'EST') AT TIME ZONE 'Asia/Calcutta') INTO V_TIMESTAMP  FROM DUAL;
  END IF;
  
  IF V_TIMESTAMP IS NOT NULL
  THEN 
  V_TIMESTAMP := SUBSTR(V_TIMESTAMP, 0,25);
  SELECT TO_TIMESTAMP (V_TIMESTAMP, 'DD-Mon-RR HH24:MI:SS.FF')INTO V_ISTTIMESTAMP FROM DUAL;
  END IF;
  
  RETURN V_ISTTIMESTAMP;
  --EXCEPTION
     --WHEN OTHERS THEN dbms_output.put_line('Error Occured While Converting EST to IST Date Format');
  
END CONVERT_EST_TO_IST_TIME;


FUNCTION GET_UNIFIED_STAGE_STATUS(P_STAGEID IN NUMBER,P_CASEID IN NUMBER)
return varchar2
IS
v_loadTime timestamp;
v_logoffTime timestamp;
V_Exittime Timestamp;
--V_Nonproductivetime Timestamp;
--V_Nonproductivetime number default 0;
V_CASE_OPEN VARCHAR2(5 CHAR) := 'false';
S_LOGOFF_ID number := 84;
S_LOADCASE_ID number := 85;
S_EXITCASE_ID NUMBER := 86;
S_STEPCOMPLETED_ID NUMBER := 87;
S_SESSIONTIMEOUT_ID NUMBER := 90;
S_BROWSERTERMINATED_ID number := 91;
--declare cursor
CURSOR LOGOFFTIME_CURSOR IS
SELECT AL.TIMESTAMP FROM AUDITLOG AL 
  where  al.stageid=P_STAGEID and al.caseid=P_CASEID and al.actionid in(S_LOGOFF_ID,S_EXITCASE_ID,S_STEPCOMPLETED_ID,S_SESSIONTIMEOUT_ID,S_BROWSERTERMINATED_ID) and  trunc(al.timestamp)=trunc(SYSDATE) order by al.timestamp desc;
CURSOR LOADTIME_CURSOR IS
SELECT AL.TIMESTAMP FROM AUDITLOG AL 
  where al.stageid=P_STAGEID and al.caseid=P_CASEID and al.actionid in(S_LOADCASE_ID) and  trunc(al.timestamp)=trunc(SYSDATE) order by al.timestamp desc;

BEGIN
--openeing LOGOFFTIME_CURSOR cursor
FOR LOGTIME IN LOGOFFTIME_CURSOR 
LOOP
  --fetching record from LOGOFFTIME_CURSOR
  --FETCH LOGOFFTIME_CURSOR into v_logoffTime;
  V_Logofftime := Logtime.Timestamp;
  DBMS_OUTPUT.put_line('xlogofftime='||v_logoffTime);
  --openeing LOADTIME_CURSOR cursor
  FOR LOADTIME IN LOADTIME_CURSOR
  LOOP
  --fetching record from LOADTIME_CURSOR
  --FETCH LOADTIME_CURSOR INTO v_loadTime;
  V_Loadtime := Loadtime.Timestamp;
  DBMS_OUTPUT.put_line('xloadtime='||v_loadTime);
  
  IF v_loadTime > v_logoffTime THEN
    DBMS_OUTPUT.PUT_LINE('log off time -->'||V_LOGOFFTIME ||' Load Time -->'||V_LOADTIME);
    --V_Nonproductivetime := V_Nonproductivetime + Timestamp_Diff_Minutes(V_Loadtime,V_Logofftime);
    --Dbms_Output.Put_Line('Non productive time-->' || V_Nonproductivetime);
    V_CASE_OPEN := 'true';
    EXIT WHEN V_LOADTIME > V_LOGOFFTIME;
  ELSE 
    EXIT;
  END IF;
  
  
  END LOOP;
  
  IF v_loadTime < v_logoffTime THEN
     EXIT;
  END IF;
  --CLOSE LOADTIME_CURSOR;
END LOOP;
--CLOSE LOGOFFTIME_CURSOR;
RETURN V_CASE_OPEN;
END;

FUNCTION GET_SEGMENTED_STAGE_STATUS(P_STAGEID IN NUMBER,P_SEGMENT NUMBER,P_CASEID IN NUMBER)
return varchar2
IS
v_loadTime timestamp;
v_logoffTime timestamp;
V_Exittime Timestamp;
V_CASE_OPEN VARCHAR2(500);
V_LOGOFFTIME_COUNT NUMBER:=0;
V_LOADTIME_COUNT number;
--V_Nonproductivetime Timestamp;
--V_Nonproductivetime number default 0;

S_LOGOFF_ID number := 84;
S_LOADCASE_ID number := 85;
S_EXITCASE_ID NUMBER := 86;
S_STEPCOMPLETED_ID NUMBER := 87;
S_SESSIONTIMEOUT_ID NUMBER := 90;
S_BROWSERTERMINATED_ID number := 91;
--declare cursor
CURSOR LOGOFFTIME_CURSOR IS
SELECT AL.TIMESTAMP FROM AUDITLOG AL 
  where  al.stageid=P_STAGEID and instr(al.originalvalue,to_char(P_SEGMENT),1)!=0 and al.caseid=P_CASEID and al.actionid in(S_LOGOFF_ID,S_EXITCASE_ID,S_STEPCOMPLETED_ID,S_SESSIONTIMEOUT_ID,S_BROWSERTERMINATED_ID) and  trunc(al.timestamp)=trunc(SYSDATE) order by al.timestamp desc;
CURSOR LOADTIME_CURSOR IS
SELECT AL.TIMESTAMP FROM AUDITLOG AL 
  where al.stageid=P_STAGEID and instr(al.originalvalue,to_char(P_SEGMENT),1)!=0 and al.caseid=P_CASEID and al.actionid in(S_LOADCASE_ID) and  trunc(al.timestamp)=trunc(SYSDATE) order by al.timestamp desc;



BEGIN

SELECT COUNT(*) INTO V_LOGOFFTIME_COUNT FROM AUDITLOG AL  WHERE  AL.STAGEID=P_STAGEID AND instr(al.originalvalue,to_char(P_SEGMENT),1)!=0 AND AL.CASEID=P_CASEID AND AL.ACTIONID IN(S_LOGOFF_ID,S_EXITCASE_ID,S_STEPCOMPLETED_ID,S_SESSIONTIMEOUT_ID,S_BROWSERTERMINATED_ID) AND  TRUNC(AL.TIMESTAMP)=TRUNC(SYSDATE) ORDER BY AL.TIMESTAMP DESC;
select count(*) into V_LOADTIME_COUNT FROM AUDITLOG AL  where  al.stageid=P_STAGEID and instr(al.originalvalue,to_char(P_SEGMENT),1)!=0 and al.caseid=P_CASEID and al.actionid in(S_LOADCASE_ID) and  trunc(al.timestamp)=trunc(SYSDATE) order by al.timestamp desc;
--V_CASE_OPEN := 'no data';
--openeing LOGOFFTIME_CURSOR cursor

 FOR LOGTIME IN LOGOFFTIME_CURSOR 
LOOP
  --fetching record from LOGOFFTIME_CURSOR
  --FETCH LOGOFFTIME_CURSOR into v_logoffTime;
 
  V_Logofftime := Logtime.Timestamp;
  DBMS_OUTPUT.put_line('xlogofftime='||v_logoffTime);
  --openeing LOADTIME_CURSOR cursor
FOR LOADTIME IN LOADTIME_CURSOR
  LOOP
  --fetching record from LOADTIME_CURSOR
  --FETCH LOADTIME_CURSOR INTO v_loadTime;
    
 V_LOADTIME := LOADTIME.TIMESTAMP;
  DBMS_OUTPUT.put_line('xloadtime='||v_loadTime);
  
  IF v_loadTime > v_logoffTime THEN
    DBMS_OUTPUT.PUT_LINE('log off time -->'||V_LOGOFFTIME ||' Load Time -->'||V_LOADTIME);
    --V_Nonproductivetime := V_Nonproductivetime + Timestamp_Diff_Minutes(V_Loadtime,V_Logofftime);
    --Dbms_Output.Put_Line('Non productive time-->' || V_Nonproductivetime);
    V_CASE_OPEN := 'The current assignee is actively working on the case. Check the radio button beneath the "New Assignee" dropdown to confirm you want to force the reassignment.';
    EXIT WHEN V_LOADTIME > V_LOGOFFTIME;
  ELSE 
    EXIT;
  END IF;
  
  
  
  END LOOP;
  
  IF v_loadTime < v_logoffTime THEN
     EXIT;
  END IF;
  --CLOSE LOADTIME_CURSOR;
END LOOP;
--CLOSE LOGOFFTIME_CURSOR;
IF V_LOADTIME_COUNT >= 1 AND V_LOGOFFTIME_COUNT = 0 THEN
V_CASE_OPEN := 'The current assignee is actively working on the case. Check the radio button beneath the "New Assignee" dropdown to confirm you want to force the reassignment.';
END IF;
RETURN V_CASE_OPEN;
End;

/*QCAI-342: Lookup table functionality for rules*/
Function LookUpTable(p_table_name varchar2,
					 p_input1 varchar2 default null, 
					 p_input2 varchar2 default null, 
					 p_input3 varchar2 default null, 
					 p_input4 varchar2 default null) return varchar2
is
	p_input_label1 varchar2(500);
	p_input_label2 varchar2(500);
	p_input_label3 varchar2(500);
	p_input_label4 varchar2(500);
	v_input1 varchar2(200);
	v_input2 varchar2(200);
	v_input3 varchar2(200);
	v_input4 varchar2(200);
	result varchar2(200) := '';
begin

	if p_input1 is not null then
	  select INPUT_LABEL into p_input_label1 from LOOKUP_DEFINITION where TABLE_NAME=p_table_name and INPUT_POSITION=1;
	  select OUTPUT into v_input1 from LOOKUP_VALUES where LABEL=p_input_label1 and INPUT1=p_input1;
	end if;
	if p_input2 is not null then
	  select INPUT_LABEL into p_input_label2 from LOOKUP_DEFINITION where TABLE_NAME=p_table_name and INPUT_POSITION=2;
	  select OUTPUT into v_input2 from LOOKUP_VALUES where LABEL=p_input_label2 and INPUT1=p_input2;
	end if;
	if p_input3 is not null then
	  select INPUT_LABEL into p_input_label3 from LOOKUP_DEFINITION where TABLE_NAME=p_table_name and INPUT_POSITION=3;
	  select OUTPUT into v_input3 from LOOKUP_VALUES where LABEL=p_input_label3 and INPUT1=p_input3;
	end if;
	if p_input4 is not null then
	  select INPUT_LABEL into p_input_label4 from LOOKUP_DEFINITION where TABLE_NAME=p_table_name and INPUT_POSITION=4;
	  select OUTPUT into v_input4 from LOOKUP_VALUES where LABEL=p_input_label4 and INPUT1=p_input4;
	end if;
	
	select OUTPUT into result from LOOKUP_VALUES where LABEL=p_table_name
		and nvl(INPUT1,'NULL')=nvl(v_input1,'NULL')
		and nvl(INPUT2,'NULL')=nvl(v_input2,'NULL')
		and nvl(INPUT3,'NULL')=nvl(v_input3,'NULL')
		and nvl(INPUT4,'NULL')=nvl(v_input4,'NULL');
	
	return result;
exception when others then
	result := '';
	return result;
end LookUpTable;	

END IWS_APP_UTILS;
/