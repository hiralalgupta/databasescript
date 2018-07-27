set define off

create or replace
PACKAGE BODY FORWARDING_UTILS
AS

procedure process_forwarding_requests is
	cursor cur_forwarding_requests is
		select * from FORWARDING_QUEUE@SC where STATUS='SUBMITTED';
	rec_forwarding_queue FORWARDING_QUEUE%ROWTYPE;
	v_request_valid boolean;
begin
	--loop thru new requests
	for rec_forwarding_requests in cur_forwarding_requests loop
		
		--initialize rec_forwarding_queue
		rec_forwarding_queue.QUEUEID := rec_forwarding_requests.QUEUEID;
		rec_forwarding_queue.FILENAME := rec_forwarding_requests.FILENAME;
		rec_forwarding_queue.FILEID := rec_forwarding_requests.FILEID;
		rec_forwarding_queue.ORIGINATING_CLIENTNAME := rec_forwarding_requests.ORIGINATING_CLIENTNAME;
		rec_forwarding_queue.FORWARDING_CLIENTNAME := rec_forwarding_requests.FORWARDING_CLIENTNAME;
		rec_forwarding_queue.FORWARD_REQUEST_ON := rec_forwarding_requests.FORWARD_REQUEST_ON;
		rec_forwarding_queue.STATUS := rec_forwarding_requests.STATUS;
		log(INFO, 'Start processing request ' || rec_forwarding_queue.QUEUEID);
		log(DEBUG, rec_forwarding_queue.FILENAME);
		log(DEBUG, rec_forwarding_queue.FILEID);
		log(DEBUG, rec_forwarding_queue.ORIGINATING_CLIENTNAME);
		log(DEBUG, rec_forwarding_queue.FORWARDING_CLIENTNAME);
		log(DEBUG, rec_forwarding_queue.FORWARD_REQUEST_ON);
		log(DEBUG, rec_forwarding_queue.STATUS);
		
		--begin processing
		begin
			--validate the request
			v_request_valid := is_request_valid(rec_forwarding_queue);
			
			if v_request_valid = false then
				raise invalid_request_exception;
			end if;
			
			--Write a request entry in SNX_IWS2_MINIME FORWARDING_QUEUE table
			record_forwarding_request (rec_forwarding_queue);
			
			--Look up the forwarding case
			lookup_iws_case (rec_forwarding_queue);
			
			--Clone the case
			clone_case (rec_forwarding_queue);
			
			--Put the new case at the QCAI-3 stage of workflow
			enter_workflow (rec_forwarding_queue.CLONE_CASEID);
			
			--Update the status flag to Processing, and set status message in FORWARDING_QUEUE tables on both sides
			update_request_status (rec_forwarding_queue, 'PROCESSING', null);
			
		exception
		when request_validation_exception then
			--FWD-00001: fail to validate the request
			update_request_status (rec_forwarding_queue, 'FAILED', 'FWD-00001');
			log(EXCPT, 'FWD-00001: fail to validate the request');
		when invalid_request_exception then
			--FWD-00002: request is invalid
			update_request_status (rec_forwarding_queue, 'FAILED', 'FWD-00002');
			log(EXCPT, 'FWD-00002: request is invalid');
		when request_recording_exception then
			--FWD-00003: fail to record the request in SNX_IWS2_MINIME FORWARDING_QUEUE table
			update_request_status (rec_forwarding_queue, 'FAILED', 'FWD-00003');
			log(EXCPT, 'FWD-00003: fail to record the request in SNX_IWS2_MINIME FORWARDING_QUEUE table');
		when iws_case_not_found_exception then
			--FWD-00004: can not locate the IWS case
			update_request_status (rec_forwarding_queue, 'FAILED', 'FWD-00004');
			log(EXCPT, 'FWD-00004: can not locate the IWS case');
		when iws_case_lookup_exception then
			--FWD-00005: fail to look up the IWS case
			update_request_status (rec_forwarding_queue, 'FAILED', 'FWD-00005');
			log(EXCPT, 'FWD-00005: fail to look up the IWS case');
		when iws_caseid_recording_exception then
			--FWD-00006: fail to record IWS case id in both FORWARDING_QUEUE table
			update_request_status (rec_forwarding_queue, 'FAILED', 'FWD-00006');
			log(EXCPT, 'FWD-00006: fail to record IWS case id in both FORWARDING_QUEUE table');
		when clone_case_exception then
			--FWD-00007: fail to clone the case
			remove_clone_case(rec_forwarding_queue.CLONE_CASEID);
			update_request_status (rec_forwarding_queue, 'FAILED', 'FWD-00007');
			log(EXCPT, 'FWD-00007: fail to clone the case');
		when clone_caseid_recording_ex then
			--FWD-00008: fail to set clone case id
			remove_clone_case(rec_forwarding_queue.CLONE_CASEID);
			update_request_status (rec_forwarding_queue, 'FAILED', 'FWD-00008');
			log(EXCPT, 'FWD-00008: fail to set clone case id');
		when workflow_exception then
			--FWD-00009: fail to put cloned case into workflow
			remove_clone_case(rec_forwarding_queue.CLONE_CASEID);
			update_request_status (rec_forwarding_queue, 'FAILED', 'FWD-00009');
			log(EXCPT, 'FWD-00009: fail to put cloned case into workflow');
		when status_update_exception then
			--FWD-00010: fail to update request status in both FORWARDING_QUEUE table
			log(EXCPT, 'FWD-00010: fail to update request status in both FORWARDING_QUEUE table');
		when others then
			--FWD-99999
			update_request_status (rec_forwarding_queue, 'FAILED', 'FWD-99999');
			log(EXCPT, 'FWD-99999');
		end;
		
		commit;
		log(INFO, 'Finished processing request ' || rec_forwarding_queue.QUEUEID);
		
	end loop;
end process_forwarding_requests;

--request_validation_exception exception
function is_request_valid (rec_forwarding_queue FORWARDING_QUEUE%ROWTYPE) RETURN Boolean is
	v_return boolean := false;
	v_originating_clientid integer;
	v_forwarding_clientid integer;
	v_forwarding_groupid integer;
	v_FORWARD_AUTH_ID integer;
begin
	log(INFO, 'Start to validate request');
	--get both client IDs
	select clientid into v_originating_clientid 
		from sc_clients where clientname = rec_forwarding_queue.ORIGINATING_CLIENTNAME;
	log(DEBUG, 'v_originating_clientid='||v_originating_clientid);
	select clientid into v_forwarding_clientid 
		from sc_clients where clientname = rec_forwarding_queue.FORWARDING_CLIENTNAME;
	log(DEBUG, 'v_forwarding_clientid='||v_forwarding_clientid);
	
	begin
		--look up SC_FORWARDING_AUTH.RELATION_TYPE=CLIENT
		select FORWARD_AUTH_ID into v_FORWARD_AUTH_ID 
			from SC_FORWARDING_AUTH 
			where SENDER_ID = v_originating_clientid and RECEPIENT_ID = v_forwarding_clientid 
			and RELATION_TYPE='CLIENT' and STATUS = 'A';
		v_return := true;
		log(DEBUG, 'FORWARD_AUTH_ID found as type CLIENT');
	exception
	when others then
		--if not found, get group ID for FORWARDING_CLIENTNAME and look up SC_FORWARDING_AUTH.RELATION_TYPE=GROUP
		begin
			select GROUPID into v_forwarding_groupid
				from SC_GROUPS_CLIENTS where CLIENTID = v_forwarding_clientid;
			select FORWARD_AUTH_ID into v_FORWARD_AUTH_ID 
				from SC_FORWARDING_AUTH 
				where SENDER_ID = v_originating_clientid and RECEPIENT_ID = v_forwarding_groupid 
				and RELATION_TYPE='GROUP' and STATUS = 'A';
			v_return := true;
			log(DEBUG, 'FORWARD_AUTH_ID found as type GROUP');
		exception
		when others then
			--if not found, return false
			v_return := false;
			log(INFO, 'FORWARD_AUTH_ID not found');
		end;
	end;
	log(INFO, 'Finished validate request');
	
	return v_return;
exception
when no_data_found then
	log_error ('FORWARDING_UTILS.is_request_valid', 'no client id found for client name', SQLCODE||' '||SQLERRM);
	raise request_validation_exception;
end is_request_valid;

--request_recording_exception exception
procedure record_forwarding_request (rec_forwarding_queue FORWARDING_QUEUE%ROWTYPE) is
begin
	log(INFO, 'Start record forwarding request');
	Delete from FORWARDING_QUEUE where QUEUEID = rec_forwarding_queue.QUEUEID;
	INSERT INTO FORWARDING_QUEUE
	  (
		QUEUEID,
		FILENAME,
		FILEID,
		ORIGINATING_CLIENTNAME,
		FORWARDING_CLIENTNAME,
		FORWARD_REQUEST_ON,
		STATUS
	  )
	  VALUES
	  (
		rec_forwarding_queue.QUEUEID,
		rec_forwarding_queue.FILENAME,
		rec_forwarding_queue.FILEID,
		rec_forwarding_queue.ORIGINATING_CLIENTNAME,
		rec_forwarding_queue.FORWARDING_CLIENTNAME,
		rec_forwarding_queue.FORWARD_REQUEST_ON,
		rec_forwarding_queue.STATUS
	  );
	commit;
	log(INFO, 'Finished recording forwarding request');
exception
when others then
	rollback;
	log_error ('FORWARDING_UTILS.record_forwarding_request', 'fails to insert forwarding request '||rec_forwarding_queue.QUEUEID, SQLCODE||' '||SQLERRM);
	raise request_recording_exception;
end record_forwarding_request;

--iws_case_not_found_exception exception;
--iws_case_lookup_exception exception;
--iws_caseid_recording_exception exception;
procedure lookup_iws_case (rec_forwarding_queue IN OUT FORWARDING_QUEUE%ROWTYPE) is
	v_originating_clientid integer;
	v_iws_clientid integer;
	v_IWS_CASEID integer;
begin
	log(INFO, 'Start looking up iws case');
	--look up the IWS client of th originating sc client
	select clientid into v_originating_clientid 
		from sc_clients where clientname = rec_forwarding_queue.ORIGINATING_CLIENTNAME;
	select clientid into v_iws_clientid
		from clients where SC_CLIENTID = v_originating_clientid;
	log(DEBUG, 'v_iws_clientid='||v_iws_clientid);
		
	begin
		--find the latest case of the client matching the file name
		select caseid into v_IWS_CASEID
			from snx_iws2.cases where clientid = v_iws_clientid and clientfilename = rec_forwarding_queue.FILENAME and rownum = 1
			order by caseid desc;
		log(DEBUG, 'v_IWS_CASEID='||v_IWS_CASEID);
	exception
	when no_data_found then
		log_error ('FORWARDING_UTILS.lookup_iws_case', 'iws case not found for request '||rec_forwarding_queue.QUEUEID, SQLCODE||' '||SQLERRM);
		raise iws_case_not_found_exception;
	when others then
		log_error ('FORWARDING_UTILS.lookup_iws_case', 'fails to find iws case for request '||rec_forwarding_queue.QUEUEID, SQLCODE||' '||SQLERRM);
		raise iws_case_lookup_exception;
	end;
	
	--Record case ID in FORWARDING_QUEUE tables on both sides
	rec_forwarding_queue.IWS_CASEID := v_IWS_CASEID;
	begin
		update FORWARDING_QUEUE set IWS_CASEID = v_IWS_CASEID
			where QUEUEID = rec_forwarding_queue.QUEUEID;
		--must commit before updating SC table to avoid ORA-02047
		commit;
		update FORWARDING_QUEUE@SC set IWS_CASEID = v_IWS_CASEID
			where QUEUEID = rec_forwarding_queue.QUEUEID;
		commit;
	exception
	when others then
		rollback;
		log_error ('FORWARDING_UTILS.lookup_iws_case', 'fails to set iws case ID for request '||rec_forwarding_queue.QUEUEID, SQLCODE||' '||SQLERRM);
		raise iws_caseid_recording_exception;
	end;	
	log(INFO, 'Finished looking up iws case');
		
exception
when no_data_found then
	log_error ('FORWARDING_UTILS.lookup_iws_case', 'no iws client found for sc originating client', SQLCODE||' '||SQLERRM);
	raise iws_case_lookup_exception;
when iws_case_not_found_exception then
	raise iws_case_not_found_exception;
when iws_case_lookup_exception then
	raise iws_case_lookup_exception;
when iws_caseid_recording_exception then
	raise iws_caseid_recording_exception;
end lookup_iws_case;

--clone_case_exception exception
--clone_caseid_recording_ex
procedure clone_case (rec_forwarding_queue IN OUT FORWARDING_QUEUE%ROWTYPE) is
	v_clone_caseid integer;
	v_forwarding_clientid integer;
	v_iws_clientid integer;
begin
	log(INFO, 'Start cloning case');
	--look up the IWS client for the forwarding sc client
	select clientid into v_forwarding_clientid 
		from sc_clients where clientname = rec_forwarding_queue.FORWARDING_CLIENTNAME;
	select clientid into v_iws_clientid
		from clients where SC_CLIENTID = v_forwarding_clientid;
	log(DEBUG, 'v_iws_clientid='||v_iws_clientid);
	
	select cases_seq.nextval into v_clone_caseid from dual;
	rec_forwarding_queue.CLONE_CASEID := v_clone_caseid;
	log(DEBUG, 'v_clone_caseid='||v_clone_caseid);
	
	--copy case data from SNX_IWS2 CASES, PAGES, and DPENTRIES tables
	insert into cases
	SELECT v_clone_caseid, --new case id
	  v_iws_clientid, --recipient iws client
	  PRIORITY,
	  RECEIPTTIMESTAMP,
	  ORIGINALCONTENTID,
	  PAPERSIZE,
	  FILESIZE,
	  APPLICANTNAME,
	  APPLICANTPOSTALCODE,
	  USERID,
	  STAGEID,
	  ASSIGNMENTTIMESTAMP,
	  STAGESTARTTIMESTAMP,
	  TOTALPAGES,
	  TOTALDOCUMENTS,
	  DELETEDPAGECOUNT,
	  DATAPOINTCOUNT,
	  IMAGEREJECTREASON,
	  IMRSDELIVERYTIMESTAMP,
	  IMRDDELIVERYTIMESTAMP,
	  IMRSCONTENTID,
	  SUBMISSIONTYPE,
	  PRIORORIGINALCONTENTID,
	  ISTEST,
	  ISANONYMOUS,
	  ISPURGED,
	  VERSION,
	  IMRSVERSION,
	  STATUS,
	  LANGUAGEID,
	  CLIENTFILENAME,
	  NOTES,
	  CLIENTCASENUMBER,
	  CREATED_TIMESTAMP,
	  CREATED_USERID,
	  CREATED_STAGEID,
	  UPDATED_TIMESTAMP,
	  UPDATED_USERID,
	  UPDATED_STAGEID,
	  DID,
	  ASSIGNEDBY,
	  ISINTERNALTEST,
	  IMRDCONTENTID,
	  LAST_BILLED_TIMESTAMP,
	  CODE_TYPE,
	  CODE_VERSION,
	  HIERARCHYREVISION,
	  DEBUG,
	  UPLOAD_METHOD,
	  SOURCE_IP_ADDR,
	  DUE_ON,
	  APPENDTOCASEID,
	  DELIVERYTIMESTAMP,
	  XMLDATA,
	  FILESTATUS,
	  PURGING_STATUS
	FROM snx_iws2.CASES where caseid=rec_forwarding_queue.IWS_CASEID;
	
	--replicate pages
	--if the same case is forwarded again, delete existing DP and page records first
	delete from dpentries where DPENTRYID in (select DPENTRYID FROM snx_iws2.DPENTRIES where pageid in (select pageid from snx_iws2.pages where caseid=rec_forwarding_queue.IWS_CASEID));
	delete from pages where pageid in (select pageid from snx_iws2.PAGES where caseid=rec_forwarding_queue.IWS_CASEID);
		
	insert into pages
	SELECT PAGEID,
	  v_clone_caseid, --new case id
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
	  CREATED_TIMESTAMP,
	  CREATED_USERID,
	  CREATED_STAGEID,
	  UPDATED_TIMESTAMP,
	  UPDATED_USERID,
	  UPDATED_STAGEID,
	  DID,
	  CASEID, --use originating case id as original case id
	  FILE_SEGMENT
	FROM snx_iws2.PAGES where caseid=rec_forwarding_queue.IWS_CASEID;
	
	--replicate DP
	insert into dpentries
	SELECT DPENTRYID,
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
	  DEBIT_VALUE,
	  CREDIT_VALUE,
	  RGACODE,
	  ISFINAL,
	  DATAFIELD21VALUE,  --IWN-1178 Add 12 more data fields to related database tables and views
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
	  RXCUI --IWT-198 RxNorm coding for drugs and medication SynIDs
	FROM snx_iws2.DPENTRIES where pageid in (select pageid from snx_iws2.pages where caseid=rec_forwarding_queue.IWS_CASEID);
	
	commit;	
	--Record Clone case ID in FORWARDING_QUEUE table
	begin
		update FORWARDING_QUEUE set CLONE_CASEID = v_clone_caseid
			where QUEUEID = rec_forwarding_queue.QUEUEID;
			
		commit;
	exception
	when others then
		rollback;
		log_error ('FORWARDING_UTILS.clone_case', 'fails to set clone case ID for request '||rec_forwarding_queue.QUEUEID, SQLCODE||' '||SQLERRM);
		raise clone_caseid_recording_ex;
	end;	
	log(INFO, 'Finished cloning case');
exception
when no_data_found then
	log_error ('FORWARDING_UTILS.clone_case', 'no client id found for forwarding client name', SQLCODE||' '||SQLERRM);
	raise clone_case_exception;
when clone_caseid_recording_ex then
	raise clone_caseid_recording_ex;
when others then
	rollback;
	log_error ('FORWARDING_UTILS.clone_case', 'fails to clone case for request '||rec_forwarding_queue.QUEUEID, SQLCODE||' '||SQLERRM);
	raise clone_case_exception;
end clone_case;

--workflow_exception exception
procedure enter_workflow (caseid integer) is
begin
	log(INFO, 'Start entering workflow');
	CASEHISTORY_UTILS.stageHop(
		p_caseID => caseid,
		p_stageID => 125, --QCAI-3 stage --need to find the step right before ready to generate
		p_userID => null,
		p_assignment_reason => 'by FORWARDING_UTILS.enter_workflow procedure'
	   );
	log(INFO, 'Finished entering workflow');
exception
when others then
	rollback;
	log_error ('FORWARDING_UTILS.enter_workflow', 'fails to enter QCAI-3 stage for case '||caseid, SQLCODE||' '||SQLERRM);
	raise workflow_exception;
end enter_workflow;

--status_update_exception exception
procedure update_request_status (rec_forwarding_queue FORWARDING_QUEUE%ROWTYPE, p_status varchar2, p_status_msg varchar2) is
begin
	log(INFO, 'Start updating request status to '||p_status);
	update FORWARDING_QUEUE set STATUS = p_status, STATUS_MSG = p_status_msg
		where QUEUEID = rec_forwarding_queue.QUEUEID;
	--must commit before updating SC table to avoid ORA-02047
	commit;	
	update FORWARDING_QUEUE@SC set STATUS = p_status, STATUS_MSG = p_status_msg
		where QUEUEID = rec_forwarding_queue.QUEUEID;
	commit;
	log(INFO, 'Finished updating request status to '||p_status);
exception
when others then
	rollback;
	log_error ('FORWARDING_UTILS.update_request_status', 'fails to update status for request '||rec_forwarding_queue.QUEUEID, SQLCODE||' '||SQLERRM);
	raise status_update_exception;
end update_request_status;

procedure log_error (actionname varchar2, message varchar2, content varchar2) is
	PRAGMA AUTONOMOUS_TRANSACTION;
begin
	INSERT INTO ERRORLOG
	  (
		ACTIONNAME,
		MESSAGE,
		CONTENT
	  )
	  VALUES
	  (
		actionname,
		message,
		content
	  );
	commit;
exception
when others then
	null;
end log_error;

procedure log (log_level integer, message varchar2) is
begin
	if log_level <= system_log_level then
		if log_level = DEBUG then
			dbms_output.put_line('(DEBUG) ' || message);
		elsif log_level = INFO then
			dbms_output.put_line('(INFO) ' || message);
		elsif log_level = EXCPT then
			dbms_output.put_line('(EXCEPTION) ' || message);
		end if;
	end if;
end log;

procedure remove_clone_case (p_caseid integer) is
begin
	delete from DPENTRIES where pageid in (select pageid from pages where caseid=p_caseid);
	delete from pages where caseid=p_caseid;
	delete from cases where caseid=p_caseid;
	commit;
end remove_clone_case;

procedure complete_request (p_clone_caseid integer) is
	v_queueid integer;
	v_timestamp varchar2(20);
begin
	log(INFO, 'Start completing request for clone case '||p_clone_caseid);
	--locate the pending forwarding request
	select queueid into v_queueid from FORWARDING_QUEUE where CLONE_CASEID = p_clone_caseid and Status = 'PROCESSING';

	update FORWARDING_QUEUE set STATUS = 'COMPLETED', FORWARD_COMPLETE = CURRENT_TIMESTAMP
		where QUEUEID = v_queueid;
	--must commit before updating SC table to avoid ORA-02047
	commit;	
	
	--if update status in SC database fails, set STATUS = 'PROCESSING' on IWS side so it can be re-delivered later
	begin
		v_timestamp := TO_CHAR(CURRENT_TIMESTAMP, 'YYYY-MM-DD HH24:MI:SS');
		update FORWARDING_QUEUE@SC set STATUS = 'COMPLETED', FORWARD_COMPLETE = v_timestamp
			where QUEUEID = v_queueid;
		commit;
	exception
	when others then
		rollback;
		update FORWARDING_QUEUE set STATUS = 'PROCESSING', FORWARD_COMPLETE = null
			where QUEUEID = v_queueid;
		commit;	
		raise;
	end;
	
	log(INFO, 'Finished completing request for clone case '||p_clone_caseid);
exception
when no_data_found then
	log_error ('FORWARDING_UTILS.complete_request', 'fails to locate the pending forwarding request for clone case '||p_clone_caseid, SQLCODE||' '||SQLERRM);
	raise no_data_found;
when others then
	rollback;
	log_error ('FORWARDING_UTILS.complete_request', 'fails to complete request for clone case '||p_clone_caseid, SQLCODE||' '||SQLERRM);
	raise;
end complete_request;

END FORWARDING_UTILS;
/