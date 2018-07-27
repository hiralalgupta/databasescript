create or replace
PACKAGE BODY RETENTION_UTILS AS

  procedure redact_phi_info

  IS

 errm VARCHAR2(500);
 v_datafield VARCHAR2(100);
 v_dpentry NUMBER;
   v_count NUMBER(10);
 BEGIN
    --SAVEPOINT start_tran;
          --First Update


FOR A IN

-- This statement is to select cases eligible for Redact
   (
    SELECT c.caseid FROM cases c, clients cl
    WHERE  c.clientid=cl.clientid
    AND trunc(c.receipttimestamp) < trunc(sysdate - (cl.phiretentionperiod))
    AND cl.phiretentionperiod is not null and c.purging_status in ('ELIGIBLE','FAILED')
    UNION ALL
    SELECT c.caseid FROM cases c, clients cl
    WHERE  c.clientid=cl.clientid
    AND c.purging_status ='FORCED'
	 )

   LOOP
   -- To redact Name and Applicant Name
   -- First update
   begin
   Update dpentries set datafield1value = 'Redacted' where dpentryid in
   (SELECT dpe.dpentryid
   FROM dpentries dpe, medicalhierarchy mh, cases c, pages p, clients cl
   WHERE
   c.caseid=A.caseid
   AND c.caseid = p.caseid
   AND c.clientid=cl.clientid
   AND c.hierarchyrevision = mh.revision
   AND p.pageid = dpe.pageid
   AND dpe.hid=mh.id
   AND mh.name = 'NAME'
   AND (mh.DataField1 = 'Name' OR mh.DataField1 = 'Applicant_Name') AND dpe.datafield1value is not null);

   -- Second Update
   Update dpentries set datafield2value = 'Redacted' where dpentryid in
   (SELECT dpe.dpentryid
   FROM dpentries dpe, medicalhierarchy mh, cases c, pages p, clients cl
   WHERE
   c.caseid=A.caseid
   AND c.caseid = p.caseid
   AND c.clientid=cl.clientid
   AND p.pageid = dpe.pageid
   AND dpe.hid=mh.id
   AND c.hierarchyrevision = mh.revision
   AND mh.name = 'NAME' AND (mh.DataField2 = 'Name' OR mh.DataField2 = 'Applicant_Name')
   AND dpe.datafield2value is not null);


   --Third update
   Update dpentries set datafield3value = 'Redacted' where dpentryid in
   (SELECT dpe.datafield3value
   FROM  dpentries dpe, medicalhierarchy mh, cases c, pages p, clients cl
   WHERE
   c.caseid=A.caseid
   AND c.caseid=p.caseid
   AND c.clientid= cl.clientid
   AND p.pageid = dpe.pageid
   AND c.hierarchyrevision = mh.revision
   AND dpe.hid=mh.id
   AND mh.name = 'NAME' AND (mh.DataField3 = 'Other Notes')
   AND dpe.datafield3value is not null);

   --Fourth Update. This is to update auditlog table for Name and Applicant Name
   update auditlog set ORIGINALVALUE=nvl2(ORIGINALVALUE,'Redacted',null), MODIFIEDVALUE=nvl2(MODIFIEDVALUE,'Redacted',null)
   where objecttype='DPENTRIES.DATAFIELD1VALUE' and objectid in
   (SELECT dpe.dpentryid
   FROM dpentries dpe, medicalhierarchy mh, cases c, pages p, clients cl
   WHERE
   c.caseid=A.caseid
   AND c.caseid = p.caseid
   AND c.clientid= cl.clientid
   AND p.pageid = dpe.pageid
   AND c.hierarchyrevision = mh.revision
   AND dpe.hid=mh.id
   AND mh.name = 'NAME' AND (mh.DataField1 = 'Name' OR mh.DataField1 = 'Applicant_Name')
   AND dpe.datafield1value is not null);

   --Fifth update
   update auditlog set ORIGINALVALUE=nvl2(ORIGINALVALUE,'Redacted',null), MODIFIEDVALUE=nvl2(MODIFIEDVALUE,'Redacted',null)
   where objecttype='DPENTRIES.DATAFIELD2VALUE' and objectid in
   (SELECT dpe.dpentryid
   FROM dpentries dpe, medicalhierarchy mh, cases c, pages p, clients cl
   WHERE
   c.caseid=A.caseid
   AND c.caseid = p.caseid
   AND c.clientid= cl.clientid
   AND p.pageid = dpe.pageid
   AND dpe.hid=mh.id
   AND c.hierarchyrevision = mh.revision
   AND mh.name = 'NAME' AND (mh.DataField2 = 'Name' OR mh.DataField2 = 'Applicant_Name')
   AND dpe.datafield2value is not null);

   --Sixth update
   update auditlog set ORIGINALVALUE=nvl2(ORIGINALVALUE,'Redacted',null), MODIFIEDVALUE=nvl2(MODIFIEDVALUE,'Redacted',null)
   where objecttype='DPENTRIES.DATAFIELD3VALUE' and objectid in
   (SELECT dpe.datafield3value
   FROM dpentries dpe, medicalhierarchy mh, cases c, pages p ,clients cl
   WHERE
   c.caseid=A.caseid
   AND c.caseid = p.caseid
   AND c.clientid= cl.clientid
   AND p.pageid = dpe.pageid
   AND dpe.hid=mh.id
   AND c.hierarchyrevision = mh.revision
   AND mh.name = 'NAME' AND (mh.DataField3 = 'Other Notes')
   AND dpe.datafield3value is not null);


   --Seventh update. Redacting data-point values of SynID DOB
   Update dpentries set datafield1value = 'Redacted' where dpentryid in
   (SELECT dpe.dpentryid
   FROM dpentries dpe, medicalhierarchy mh, cases c, pages p, clients cl
   WHERE
   c.caseid=A.caseid
   AND c.caseid = p.caseid
   AND c.clientid= cl.clientid
   AND p.pageid = dpe.pageid
   AND dpe.hid=mh.id
   AND c.hierarchyrevision = mh.revision
   AND mh.name = 'DOB' AND (mh.DataField1 = 'DOB')
   AND dpe.datafield1value is not null);

   --Eighth update
   Update dpentries set datafield2value = 'Redacted' where dpentryid in
   (SELECT dpe.dpentryid FROM dpentries dpe, medicalhierarchy mh, cases c, pages p, clients cl
   WHERE
   c.caseid=A.caseid
   AND c.caseid = p.caseid
   AND c.clientid=cl.clientid
   AND p.pageid = dpe.pageid
   AND dpe.hid=mh.id
   AND c.hierarchyrevision = mh.revision
   AND mh.name = 'DOB' AND (mh.DataField2 = 'DOB')
   AND dpe.datafield2value is not null);

   --Nineth update
   Update dpentries set datafield3value = 'Redacted' where dpentryid in
   (SELECT dpe.datafield3value FROM dpentries dpe, medicalhierarchy mh, cases c, pages p, clients cl
   WHERE
   c.caseid=A.caseid
   AND c.caseid = p.caseid
   AND c.clientid= cl.clientid
   AND p.pageid = dpe.pageid
   AND c.hierarchyrevision = mh.revision
   AND dpe.hid=mh.id
   AND mh.name = 'DOB' AND (mh.DataField3 = 'Other Notes')
   AND dpe.datafield3value is not null);

   --Tenth update
   Update dpentries set datadate = '01-JAN-1800 12.00.00.000000000 AM AMERICA/NEW_YORK' where dpentryid in
   (SELECT dpe.dpentryid
   FROM dpentries dpe, medicalhierarchy mh, cases c, pages p, clients cl
   WHERE
   c.caseid=A.caseid
   AND c.caseid = p.caseid
   AND c.clientid= cl.clientid
   AND p.pageid = dpe.pageid
   AND c.hierarchyrevision = mh.revision
   AND dpe.hid=mh.id
   AND mh.name = 'DOB' AND (mh.DataField1 is null));

   --Eleventh update
   update auditlog set ORIGINALVALUE=nvl2(ORIGINALVALUE,'Redacted',null), MODIFIEDVALUE=nvl2(MODIFIEDVALUE,'Redacted',null)
   where objecttype='DPENTRIES.DATAFIELD1VALUE' and objectid in
   (SELECT dpe.dpentryid
    FROM dpentries dpe, medicalhierarchy mh, cases c, pages p, clients cl
   where
   c.caseid=A.caseid
   AND c.caseid = p.caseid
   AND c.clientid= cl.clientid
   AND p.pageid = dpe.pageid
   AND c.hierarchyrevision = mh.revision
   AND dpe.hid=mh.id
   AND mh.name = 'DOB' AND (mh.DataField1 = 'DOB')
   AND dpe.datafield1value is not null);

   --Twelth update
   update auditlog set ORIGINALVALUE=nvl2(ORIGINALVALUE,'Redacted',null), MODIFIEDVALUE=nvl2(MODIFIEDVALUE,'Redacted',null)
   where objecttype='DPENTRIES.DATAFIELD2VALUE' and objectid in
   (SELECT dpe.dpentryid
   FROM dpentries dpe, medicalhierarchy mh, cases c, pages p, clients cl
   WHERE
   c.caseid=A.caseid
   AND c.caseid = p.caseid
   AND c.clientid= cl.clientid
   AND p.pageid = dpe.pageid
   AND c.hierarchyrevision = mh.revision
   AND dpe.hid=mh.id
   AND mh.name = 'DOB' AND (mh.DataField2 = 'DOB')
   AND dpe.datafield2value is not null);

   --Thirteenth update
   update auditlog set ORIGINALVALUE=nvl2(ORIGINALVALUE,'Redacted',null), MODIFIEDVALUE=nvl2(MODIFIEDVALUE,'Redacted',null)
   where objecttype='DPENTRIES.DATAFIELD3VALUE' and objectid in
   (SELECT dpe.datafield3value
   FROM dpentries dpe, medicalhierarchy mh, cases c, pages p, clients cl
   WHERE
   c.caseid=A.caseid
   AND c.caseid = p.caseid
   AND c.clientid=cl.clientid
   AND c.hierarchyrevision = mh.revision
   AND p.pageid = dpe.pageid
   AND dpe.hid=mh.id
   AND mh.name = 'DOB' AND (mh.DataField3 = 'Other Notes')
   AND dpe.datafield3value is not null);

   --Fourteenth update

   update auditlog set ORIGINALVALUE=nvl2(ORIGINALVALUE,'01-JAN-1800',null), MODIFIEDVALUE=nvl2(MODIFIEDVALUE,'01-JAN-1800',null)
   where objecttype='DPENTRIES.DATADATE' and objectid in
   (SELECT dpe.dpentryid
   FROM dpentries dpe, medicalhierarchy mh, cases c, pages p, clients cl
   WHERE
   c.caseid=A.caseid
   AND c.caseid = p.caseid
   AND c.clientid=cl.clientid
   AND p.pageid = dpe.pageid
   AND dpe.hid=mh.id
   AND c.hierarchyrevision = mh.revision
   AND mh.name = 'DOB' AND (mh.DataField1 is null));

   --Fifteenth update
   Update dpentries set datafield2value = 'Redacted' where dpentryid in
   (SELECT dpe.dpentryid
   FROM dpentries dpe, medicalhierarchy mh, cases c, pages p, clients cl
   WHERE
   c.caseid=A.caseid
   AND c.caseid = p.caseid
   AND c.clientid=cl.clientid
   AND p.pageid = dpe.pageid
   AND dpe.hid=mh.id
   AND c.hierarchyrevision = mh.revision
   AND mh.name = 'DKTR' AND (mh.DataField2 = 'Doctor Name')
   AND dpe.datafield2value is not null);

   --Sixteenth update

   Update dpentries set datafield3value = 'Redacted' where dpentryid in
  (SELECT dpe.datafield3value
  FROM dpentries dpe, medicalhierarchy mh, cases c, pages p, clients cl
  WHERE
  c.caseid=A.caseid
  AND c.caseid = p.caseid
  AND c.clientid= cl.clientid
  AND p.pageid = dpe.pageid
  AND dpe.hid=mh.id
  AND c.hierarchyrevision = mh.revision
  AND mh.name = 'DKTR' AND (mh.DataField3 = 'Other Notes')
  AND dpe.datafield3value is not null);

  -- Seventeenth update
   update auditlog set ORIGINALVALUE=nvl2(ORIGINALVALUE,'Redacted',null), MODIFIEDVALUE=nvl2(MODIFIEDVALUE,'Redacted',null)
   where objecttype='DPENTRIES.DATAFIELD2VALUE' and objectid in
  (SELECT dpe.dpentryid
  FROM dpentries dpe, medicalhierarchy mh, cases c, pages p, clients cl
  WHERE
  c.caseid=A.caseid
  AND c.caseid = p.caseid
  AND c.clientid=cl.clientid
  AND p.pageid = dpe.pageid
  AND c.hierarchyrevision = mh.revision
  AND dpe.hid=mh.id
  AND mh.name = 'DKTR' AND (mh.DataField2 = 'Doctor Name')
  AND dpe.datafield2value is not null);

--Eighteenth update
  update auditlog set ORIGINALVALUE=nvl2(ORIGINALVALUE,'Redacted',null), MODIFIEDVALUE=nvl2(MODIFIEDVALUE,'Redacted',null)
  where objecttype='DPENTRIES.DATAFIELD3VALUE' and objectid in
  (SELECT dpe.datafield3value
   FROM dpentries dpe, medicalhierarchy mh, cases c, pages p, clients cl
   WHERE
   c.caseid=A.caseid
   AND c.caseid = p.caseid
   AND c.clientid= cl.clientid
   AND p.pageid = dpe.pageid
   AND dpe.hid=mh.id
   AND c.hierarchyrevision = mh.revision
   AND mh.name = 'DKTR' AND (mh.DataField3 = 'Other Notes')
   AND dpe.datafield3value is not null);

   ------- to get the datafiled value for Last_Hospitalization_Date

   SELECT  count(dpe.dpentryid) into v_count
   FROM dpentries dpe, medicalhierarchy mh, cases c, pages p, clients cl, MEDICALHIERARCHY_FIELD_LABEL_V l
   WHERE
   c.caseid=A.caseid
   AND  c.caseid = p.caseid
   AND c.clientid= cl.clientid
   AND p.pageid = dpe.pageid
   AND dpe.hid=mh.id
   AND c.hierarchyrevision = mh.revision
   AND mh.name = l.name
   AND mh.revision = l.revision
   and l.datafield_label = 'Last_Hospitalization_Date';

   if v_count > 0 then
     for rec in (SELECT  dpe.dpentryid, l.datafield
     FROM dpentries dpe, medicalhierarchy mh, cases c, pages p, clients cl, MEDICALHIERARCHY_FIELD_LABEL_V l
     WHERE
     c.caseid=A.caseid
     AND  c.caseid = p.caseid
     AND c.clientid= cl.clientid
     AND p.pageid = dpe.pageid
     AND dpe.hid=mh.id
     AND c.hierarchyrevision = mh.revision
     AND mh.name = l.name
     AND mh.revision = l.revision
     and l.datafield_label = 'Last_Hospitalization_Date')

     loop
     --dbms_output.put_line('Test1');
     v_datafield:=rec.datafield||'value';
     execute immediate 'update dpentries set '||v_datafield||' =''Redacted'' where dpentryid='||rec.dpentryid||' and '||v_datafield||' is not null';
     execute immediate 'update auditlog set ORIGINALVALUE=nvl2(ORIGINALVALUE,''Redacted'',null), MODIFIEDVALUE=nvl2(MODIFIEDVALUE,''Redacted'',null) WHERE objectid='''||rec.dpentryid||''' and objecttype=''DPENTRIES.'||upper(v_datafield)||'''';
     commit;
     end loop;
  --else
  --   update cases set purging_status='DB PURGED' where caseid=A.caseid;
  --   insert into purgelog(caseid, purgestatus, purgedate, message) values(A.caseid,'DB PURGED',systimestamp,null);
  --   dbms_output.put_line('Case '|| A.caseid||' is redacted in DB.');
  --   commit;
 end if;
  --Mark all pieces of UCM contents for the case as EXPIRED
  UPDATE snx_ocs.revisions SET DOUTDATE = CURRENT_TIMESTAMP, DSTATUS = 'EXPIRED' WHERE did IN (SELECT did FROM snx_ocs.docmeta WHERE xcaseid = A.caseid);
  update cases set purging_status='DB PURGED' where caseid=A.caseid ;
  insert into purgelog(caseid, purgestatus, purgedate, message) values(A.caseid,'DB PURGED',systimestamp,null);
  dbms_output.put_line('Case '|| A.caseid||' is redacted in DB.');
  commit;

  EXCEPTION
          WHEN OTHERS THEN
          errm := SQLERRM;
          ROLLBACK ;
   update cases set purging_status='FAILED' where caseid=A.caseid;
   insert into purgelog(caseid, purgestatus, purgedate, message) values(A.caseid,'FAILED',systimestamp,errm);
   dbms_output.put_line('Case '|| A.caseid||' failed to update.');
  commit;
  end;
  end loop;

  END redact_phi_info;

  procedure Purge_file_fail(p_caseid in number,p_casefile VARCHAR2,p_status in number) as
  begin

  if p_status=0
  then
    update cases set purging_status='APPFS PURGED' where caseid=p_caseid;
    update purgelog set purgestatus='APPFS PURGED', message='File '|| p_casefile||' removed from App Server' where caseid=p_caseid and purgeid in (select max(purgeid) from purgelog where caseid=p_caseid);
    dbms_output.put_line('Physical file '|| p_casefile||' is removed from App Server.');
  commit;
  end if;


  if p_status=90
  then
    update purgelog set purgestatus='APPFS PURGED', message='Physical File '|| p_casefile||' not found on App Server.' where caseid=p_caseid and purgeid in (select max(purgeid) from purgelog where caseid=p_caseid);
    update cases set purging_status='APPFS PURGED' where caseid=p_caseid;
    dbms_output.put_line('Physical file '|| p_casefile||' file not found on App Server.');
  commit;
  end if;

  if p_status=91
  then
    --update cases set purging_status='FAILED' where caseid=p_caseid;
    update purgelog set message='Permission denied to remove file '|| p_casefile||' on App Server' where caseid=p_caseid and purgeid in (select max(purgeid) from purgelog where caseid=p_caseid);
    dbms_output.put_line('Permission denied to remove '|| p_casefile||' file on App Server.');
  commit;
  end if;

  END Purge_file_fail;

  procedure Purge_file_FG(p_fgcase in number, p_fgcasefile in VARCHAR2,p_fgstatus in number) as
  begin

  if p_fgstatus=0
  then
    update cases set purging_status='PURGED' where caseid=p_fgcase;
    update purgelog set purgestatus='PURGED', message2='File '|| p_fgcasefile||' removed from FG Server' where caseid=p_fgcase and purgeid in (select max(purgeid) from purgelog where caseid=p_fgcase);
    dbms_output.put_line('Physical file '|| p_fgcasefile||' is removed from FG Server.');
  commit;
  end if;


  if p_fgstatus=90
  then
    --update cases set purging_status='FAILED' where caseid=p_caseid;
    update purgelog set purgestatus='PURGED', message2='Physical File '|| p_fgcasefile||' not found on FG Server.' where caseid=p_fgcase and purgeid in (select max(purgeid) from purgelog where caseid=p_fgcase);
    update cases set purging_status='PURGED' where caseid=p_fgcase;
    dbms_output.put_line('Physical file '|| p_fgcasefile||' file not found on FG Server.');
  commit;
  end if;

  if p_fgstatus=91
  then
    --update cases set purging_status='FAILED' where caseid=p_caseid;
    update purgelog set message2='Permission denied to remove file '|| p_fgcasefile||' on FG Server' where caseid=p_fgcase and purgeid in (select max(purgeid) from purgelog where caseid=p_fgcase);
    dbms_output.put_line('Permission denied to remove '|| p_fgcasefile||' file on FG Server.');
  commit;
  end if;

  END Purge_file_FG;

END RETENTION_UTILS;