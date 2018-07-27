--------------------------------------------------------
--  DDL for Function REJECTION
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SNX_IWS2"."REJECTION" 

v_SQL varchar2(32000);

BEGIN
v_SQL := 'select * from (
 select	 "CASES"."PRIORITY" as "PRIORITY",
	 "CASES"."RECEIPTTIMESTAMP" as "RECEIPTTIMESTAMP",
	 "CASES"."FILESIZE" as "FILESIZE",
	 "CASES"."TOTALPAGES" as "TOTALPAGES",
	 "CASES"."CLIENTFILENAME" as "CLIENTFILENAME",
	 "CLIENTS"."CLIENTNAME" as "CLIENTNAME" 
 from	 "CLIENTS" "CLIENTS",
	 "CASES" "CASES"
where CLIENTS.CLIENTID=CASES.CLIENTID and CASES.CLIENTFILENAME IS NOT NULL)
where (
 instr(upper("PRIORITY"),upper(nvl(:P620_REPORT_SEARCH,"PRIORITY"))) > 0  or
 instr(upper("CLIENTFILENAME"),upper(nvl(:P620_REPORT_SEARCH,"CLIENTFILENAME"))) > 0  or
 instr(upper("CLIENTNAME"),upper(nvl(:P620_REPORT_SEARCH,"CLIENTNAME"))) > 0 
)';

IF :BEG_DATE IS NOT NULL 
  Then v_SQL := v_SQL || ' AND trunc(RECEIPTTIMESTAMP) >= :BEG_DATE ';
 END IF;

 IF :END_DATE IS NOT NULL 
  Then v_SQL := v_SQL || ' AND trunc(RECEIPTTIMESTAMP) <= :END_DATE ';
 END IF;

RETURN v_SQL;

END;

/

