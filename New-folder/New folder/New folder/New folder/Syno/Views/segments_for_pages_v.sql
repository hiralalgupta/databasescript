create or replace force view segments_for_pages_v as
select s.stageid, case when p.originalpagenumber<=cs.segments*cs.file_segment_size then 
					ceil(p.originalpagenumber/cs.file_segment_size)
					else cs.segments end file_segment,
  PAGEID,
  p.CASEID,
  ORIGINALPAGENUMBER,
  DOCUMENTTYPEID,
  DOCUMENTDATE,
  SUBDOCUMENTORDER,
  FINALPAGENUMBER,
  SUBDOCUMENTPAGENUMBER,
  ORIENTATION,
  ISDELETED,
  DELETEREASON,
  SUSPENDNOTE,
  ISCOMPLETED,
  COMPLETETIMESTAMP,
  HASDATAPOINT,
  ISBADHANDWRITING,
  SPCONTENTID,
  p.DID,
  ORIGINALCASEID
from pages p, case_segmentations cs, cases c, stages s
where 1=1
and p.caseid = cs.caseid
and cs.caseid = c.caseid
and cs.stageid = s.stageid
AND s.parallelism = 9999;