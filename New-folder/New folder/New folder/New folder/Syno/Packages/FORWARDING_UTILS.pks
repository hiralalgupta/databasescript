create or replace
PACKAGE FORWARDING_UTILS
AS
request_validation_exception exception;
invalid_request_exception exception;
request_recording_exception exception;
iws_case_not_found_exception exception;
iws_case_lookup_exception exception;
iws_caseid_recording_exception exception;
clone_case_exception exception;
clone_caseid_recording_ex exception;
workflow_exception exception;
status_update_exception exception;
DEBUG INTEGER := 3;
INFO INTEGER := 2;
EXCPT INTEGER := 1;
system_log_level integer := DEBUG;

--main driver
procedure process_forwarding_requests;

--validate the request
function is_request_valid (rec_forwarding_queue FORWARDING_QUEUE%ROWTYPE) RETURN Boolean;

--Write a request entry in SNX_IWS2_MINIME FORWARDING_QUEUE table
procedure record_forwarding_request (rec_forwarding_queue FORWARDING_QUEUE%ROWTYPE);

--Look up the forwarding case
procedure lookup_iws_case (rec_forwarding_queue IN OUT FORWARDING_QUEUE%ROWTYPE);

--Create a new case in SNX_IWS2_MINIME for the forwarding client, and copy case data from SNX_IWS2 CASES, PAGES, and DPENTRIES tables.
procedure clone_case (rec_forwarding_queue IN OUT FORWARDING_QUEUE%ROWTYPE);

--Put the new case at the QCAI-3 stage of workflow
procedure enter_workflow (caseid integer);

--Update the status flag to Processing, and set status message in FORWARDING_QUEUE tables on both sides
procedure update_request_status (rec_forwarding_queue FORWARDING_QUEUE%ROWTYPE, p_status varchar2, p_status_msg varchar2);

--record error log
procedure log_error (actionname varchar2, message varchar2, content varchar2);

procedure log (log_level integer, message varchar2);

procedure remove_clone_case (p_caseid integer);

--flag request as COMPLETED and set timestamp
procedure complete_request (p_clone_caseid integer);

END FORWARDING_UTILS;
/