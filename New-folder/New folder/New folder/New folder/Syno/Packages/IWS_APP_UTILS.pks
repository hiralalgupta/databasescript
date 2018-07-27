create or replace
PACKAGE IWS_APP_UTILS
AS
  /* TODO enter package declarations (types, exceptions, methods etc) here */
FUNCTION getConfigSwitchValue(
    p_clientid    IN INTEGER,
    p_switch_name IN VARCHAR2)
  RETURN VARCHAR2;
  
FUNCTION isCodeRequired(
    p_clientid IN INTEGER,
    p_cat      IN VARCHAR2,
    p_subcat   IN VARCHAR2 DEFAULT NULL,
    p_status   IN VARCHAR2 DEFAULT NULL)
  RETURN VARCHAR2;

/*Based on client id and code id, find out if the code should be displayed in RED BOLD font*/  
FUNCTION isCodeCritical1(
    p_clientid IN INTEGER,
    p_codeid   IN INTEGER)
  RETURN VARCHAR2;

/*Based on case id and code id, find out if the code should be displayed in RED BOLD font*/  
FUNCTION isCodeCritical2(
    p_caseid   IN INTEGER,
    p_codeid   IN INTEGER)
  RETURN VARCHAR2;

FUNCTION getProductSpec(
    p_caseid   IN INTEGER,
    p_itemname IN VARCHAR2)
  RETURN VARCHAR2;

FUNCTION isCodeExcluded(
    p_caseid   IN INTEGER,
    p_codeid   IN INTEGER)
  RETURN VARCHAR2;


FUNCTION getLinkTextForReportIcon(
    p_caseID IN INTEGER,
    p_docType  IN VARCHAR2)	
  RETURN VARCHAR2;


FUNCTION getLinkTextForTemplateIcon(
    p_caseID   IN INTEGER,
	p_position in INTEGER)
  RETURN VARCHAR2;


Function getEpochMillisecond(p_timestamp IN TIMESTAMP WITH TIME ZONE)
  Return number;

FUNCTION TIMESTAMP_TO_DATE 
 ( P_TIMESTAMP  timestamp default NULL  )	
  RETURN Date;


Procedure getNextReadyToReleaseCase;

/*a variation of getNextReadyToReleaseCase to be used in IWS 2.7 per IWN-828*/
Procedure getNextReadyToReleaseCase2;

/*Based on dpentryid, find out the scale of the code*/  
FUNCTION getCodeScaleForDP(
    p_dpentryid IN INTEGER)
  RETURN INTEGER;
  
/*Based on client id and code id, find out the scale of the code*/  
FUNCTION getCodeScale1(
    p_clientid IN INTEGER,
    p_codeid   IN INTEGER)
  RETURN VARCHAR2;

/*Based on case id and code id, find out the scale of the code*/  
FUNCTION getCodeScale2(
    p_caseid   IN INTEGER,
    p_codeid   IN INTEGER)
  RETURN VARCHAR2;

procedure clob_to_file( p_dir in varchar2,
                        p_file in varchar2,
                        p_clob in clob );

procedure BATCHPAYLOAD_XML_to_file
      (p_dir in varchar2,
       P_CASEID in number default null,
       p_file_extn in varchar2 default '.xml');

/*get assigned categories for a user in a parallelized stage*/
Function getVisibleCategories(p_userid IN INTEGER, p_caseid IN INTEGER, p_stageid IN INTEGER)
	Return Varchar2;

/*get assigned document types for a user in a parallelized stage*/
Function getVisibleDocTypes(p_userid IN INTEGER, p_caseid IN INTEGER, p_stageid IN INTEGER)
	Return Varchar2;

/*to create a user account if not already created (initial password is synodex),
  assign the role if not already assigned. */
Procedure setupUserAccess(p_username In Varchar2, p_firstname In Varchar2, p_lastname In Varchar2, p_rolename In Varchar2, p_editby In Varchar2);

/*check the completion status of a case at a parallel stage;
  if all parallel tasks are completed, advance the case to the next stage.*/
Procedure advanceParallelStage;


 PROCEDURE GET_NEXT_CASE_FEEDER 
            (  P_USERID  IN NUMBER,
               P_ROLE    IN VARCHAR2,
               P_CLIENTID IN VARCHAR2,
               P_CASEID  OUT NUMBER,
               P_RESULT  OUT VARCHAR2,
			   P_EXECMODE IN VARCHAR2 Default 'RUN');
               
PROCEDURE GET_NEXT_CASE_POP 
            (  P_USERID  IN NUMBER,
               P_ROLE    IN VARCHAR2,
               P_CLIENTID IN VARCHAR2,
               P_CASEID  OUT NUMBER,
               P_RESULT  OUT VARCHAR2,
			   P_EXECMODE IN VARCHAR2 Default 'RUN');
 
PROCEDURE GET_NEXT_CASE_SEQ 
            (  P_USERID  IN NUMBER,
               P_ROLE    IN VARCHAR2,
               P_CLIENTID IN VARCHAR2,
               P_CASEID  OUT NUMBER,
               P_RESULT  OUT VARCHAR2,
			   P_EXECMODE IN VARCHAR2 Default 'RUN');


 PROCEDURE GET_NEXT_CASE_27 
            (  P_USERID  IN NUMBER,
               P_ROLE    IN VARCHAR2,
               P_CLIENTID IN VARCHAR2,
			   P_BEG_DATE in date default null, 
			   P_END_DATE in date default null,			   
               P_CASEID  OUT NUMBER,
               P_RESULT  OUT VARCHAR2,
			   P_EXECMODE IN VARCHAR2 Default 'RUN');


 PROCEDURE GET_NEXT_CASE_28 
            (  P_USERID  IN NUMBER,
               P_ROLE    IN VARCHAR2,
               P_CLIENTID IN VARCHAR2,
			   P_BEG_DATE in date default null, 
			   P_END_DATE in date default null,	
			   P_SEGMENTED IN VARCHAR2,		   
               P_CASEID  OUT NUMBER,
               P_RESULT  OUT VARCHAR2,
			   P_EXECMODE IN VARCHAR2 Default 'RUN');

			   
Function USERIDLIST_TO_USERNAME
       ( P_Useridlist Varchar2,
         P_Delimiter Varchar2 Default ', ',
         P_FORMAT varchar2 default NULL
        )		
	  RETURN VARCHAR2;	   

Function GET_POP_USERIDLIST
       ( P_Caseid Number,  
         P_Stageid Number,
         P_Delimiter Varchar2 Default ', ',
         P_Format Varchar2 Default 'NAME'
        )		
	  Return Varchar2;	   
			   
--FUNCTION ROLE_ICON 
--      ( P_CASEID  number default NULL,  
--        P_ROLEID number default NULL,
--        P_USERID   number default NULL
--       )			   

/*IWN-543: To append one case, including pages and data points, to another case*/
PROCEDURE APPEND_CASE (
    P_FROM_CASE NUMBER, 
	P_TO_CASE NUMBER,
  P_USERID NUMBER,
	P_Message out varchar2);
/*DG-45:Delete Appeneded cases */  
PROCEDURE DEL_APPEND_CASE(
  P_SOURCE_CASE IN NUMBER,
  P_TARGET_CASE IN NUMBER,
  P_USERID IN NUMBER,
  P_MESSAGE IN OUT VARCHAR2);

Function IS_CASE_ASSIGNED
       ( P_Caseid Number,  
	     P_ROLEID Number default null,
         P_Format Varchar2 Default 'YN'
        )		
	  Return Varchar2;	   
	  
FUNCTION   STATUS_ICON 
      ( P_CASEID  number default NULL,  
        P_STAGEID number default NULL,
        P_USERID   number default NULL,
		P_FILE_SEGMENT number default NULL,
		P_ISCOMPLETED varchar2 default NULL,
		P_PCSID number default NULL
       )	  
	  Return Varchar2;



	  
FUNCTION   BUILD_IWS_URL
    (P_CASEID          number   default null,   
     P_STAGEID         number   default null,
     P_USERID          number   default null,  
     P_ENV             varchar2 default 'AUTODETECT',
     P_GLOBALSESSIONID number   default null,
     P_APEXSESSIONID   number   default null,   
     P_FORMAT          varchar2 default null)	
	 Return Varchar2;  
	 
FUNCTION   GET_TEMPLATE_NAME
    (P_CASEID          number   default null,   
     P_POSITION        number   default null
     )	
	 Return Varchar2;  

PROCEDURE  DISPLAY_IMAGE_INLINE
    (P_URL         varchar2  default null,   
     P_HEIGHT      number    default 1000,
	 P_WIDTH       number    default 850
     );	
  
  
PROCEDURE  GET_DISPLAY_IMAGE
    (P_TABLE        varchar2  default null,   
     P_BLOB_COLUMN  varchar2  default null,
	 P_FILENAME     varchar2  default null,
	 P_MIME_TYPE    varchar2 default 'application/pdf',
	 P_KEY_COLUMN   varchar2  default null,
	 P_KEY_ID       number    default null
     );	

FUNCTION   BLOB_TO_CLOB
    (P_BLOB         BLOB   default null
     )	
	 Return CLOB;  

FUNCTION   CLOB_TO_BLOB
    (P_CLOB         CLOB   default null
     )	
	 Return BLOB;  

 
FUNCTION   METRICS_REPORT_AUTH 
    ( P_USERID number default NULL,
      P_RANGE varchar2 default NULL,  -- BEG or END
      P_FORMAT varchar2 default NULL
    )	 
	 RETURN Number;

FUNCTION   ELAPSED_COUNTDOWN
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
   RETURN Varchar2;


FUNCTION   APPENDED_FROM_CASELISTING
   (P_CASEID IN NUMBER,
    P_LINEBREAK IN VARCHAR2 default '<br>',
    P_FORMAT IN VARCHAR2 default null
   )
   RETURN Varchar2;
   
  
FUNCTION SLA_DUE_ON
    (P_caseId IN NUMBER default null,
	 P_CLIENTID IN NUMBER default null,
	 P_RECEIVED_ON IN TIMESTAMP default null) 
	 RETURN TIMESTAMP;
  

 FUNCTION ISHOLIDAY(P_processed_day_on IN VARCHAR, P_client_sla_id IN NUMBER)
RETURN NUMBER;

FUNCTION IS_WORKING_DAY(P_processed_day_on IN VARCHAR, P_client_sla_id IN NUMBER)
RETURN NUMBER;

FUNCTION LOGIN_AUTH_CHK 
(P_Username Varchar2, P_Password Varchar2)
   RETURN BOOLEAN;

FUNCTION TEST_LOGIN_AUTH_CHK 
(P_Username Varchar2, P_Password Varchar2)
   RETURN VARCHAR2;
  
FUNCTION LDAP_LOGIN_AUTH_CHK 
(P_Username Varchar2, P_Password Varchar2)
   --RETURN VARCHAR2; for testing
   RETURN BOOLEAN;
  
PROCEDURE  POST_AUTH_PROCESS;   -- No Parms

/*this procedure populate the XMLDATA column for the case with data point data in XML format */
PROCEDURE GenerateXMLDataForCase (P_Caseid In Number Default 0);

/*IWN-943 check if client needs encryption and validate public key
# if cut-over date is in the future, return N
# if cut-over date has past and public key is good, return Y
# if cut-over date has past and public key is no good, return E
*/
FUNCTION isEncryptionNeeded (P_CASEID IN NUMBER Default null, P_BATCHID IN NUMBER Default null, P_CLIENTID IN NUMBER Default null) RETURN Varchar2;

/* Textual description or USERID value of 2.7 Assignments for all or a particular thread  */
Function  Show_assign_Status
      ( P_Caseid Number, 
        P_Thread Number Default Null,
        P_FORMAT varchar2 default 'TXT'  --NUM
       )
        RETURN VARCHAR2;

/* Textual description or STAGEID value of 2.7 Assignments for all or a particular thread  */		
Function     Show_Stage_Status
      ( P_Caseid Number, 
        P_Thread Number Default Null,
        P_FORMAT varchar2 default 'TXT'  --NUM
       )
        RETURN VARCHAR2; 		 


/* If userid is present, returns number of open assignments of that case to that user
If no userid, returns count of ope assignements of that cae to ANY user */
Function  Is_Case_Assigned_to_user
      ( P_Caseid Number, 
        P_USERID number Default Null
       )
        RETURN number;


/* Gets the Integer thread for Case/Stage combination
Users by assignments to check for open stages in same thread needing closure */
Function  is_stage_in_thread
      ( P_Caseid Number, 
	    P_Thread number,
        P_STAGEID number
       )
        RETURN varchar2;

		
-- Count of DataPoints for a Case that are Not Pharam, Procedure or Test related
-- does not included ISDELETED (soft deletes) of DPs or Pages in counts
FUNCTION   DOCTOR_DATAPOINT_COUNT 
    (P_CASEID NUMBER default null)
        RETURN number;		


-- Used by Finance/billing reports to provide count of Datapoints or Pages for a particular case.
-- does not included ISDELETED (soft deletes) of DPs or Pages  in counts		
FUNCTION DATAPOINT_COUNT 
    (P_CASEID NUMBER default null)
        RETURN number;		


-- Count of DataPoints for a Case that are Procedure or Test related
-- does not included ISDELETED (soft deletes) of DPs or Pages in counts
FUNCTION PROCANDTEST_DATAPOINT_COUNT 
    (P_CASEID NUMBER default null)
        RETURN number;


-- Count of DataPoints for a Case that are Pharma related
-- does not included ISDELETED (soft deletes) of DPs or Pages in counts
FUNCTION PHARMA_DATAPOINT_COUNT 
    (P_CASEID NUMBER default null)
        RETURN number;         


-- Count of DataPoints for a Case that are General related
-- does not included ISDELETED (soft deletes) of DPs or Pages in counts
FUNCTION GENERAL_DATAPOINT_COUNT 
    (P_CASEID NUMBER default null)
        RETURN number;         


-- Count of DataPoints for a Case that are Disease and Injury related
-- does not included ISDELETED (soft deletes) of DPs or Pages in counts
FUNCTION DI_DATAPOINT_COUNT 
    (P_CASEID NUMBER default null)
        RETURN number;         


-- Count of DataPoints for a Case that are related to a particular Role
-- does not included ISDELETED (soft deletes) of DPs or Pages in counts
FUNCTION DATAPOINT_COUNT_BY_STAGE 
    (P_CASEID NUMBER default null,
	 P_STAGEID NUMBER default null,
	 P_CURSTAGEID NUMBER default null
	)
        RETURN number;         

/* clears and repopulates the workflows_by_thread table for all clients.
	   should be rerun whenever a workflow is changed or a client is added.
	   Relies upon view parallel_stage_thread_v 
*/
Procedure build_workflows_by_thread;

-- Do file segmentation and populate parallel case status tables
Procedure segmentFile (p_caseid In Integer);

/* Do file segmentation and populate parallel case status tables
Will only segment files for sorting steps (USER_FUNCTION_GROUP like '%-S'), 
and will always clear existing records and re-insert, because for "append case" funtionality, segmentation needs to be recalculated. 
When clearing from PARALLELCASESTATUS, need to close open assignments from CASEHISTORYSUM. 
segmentFileForSorting will also update the FILE_SEGMENT column in PAGES table. */
Procedure segmentFileForSorting (p_caseid In Integer);

/* Do file segmentation and populate parallel case status tables
Will only segment files for indexing steps (USER_FUNCTION_GROUP like '%-I'), 
and it will take parameter p_clear_records to clear or preserve existing records. 
When clearing from PARALLELCASESTATUS, need to close open assignments from CASEHISTORYSUM.*/
Procedure segmentFileForIndexing (p_caseid In Integer, p_clear_records In Varchar2 default 'N');

FUNCTION GET_SEGMENT_COMPLETION_STATUS 
      (P_CASEID NUMBER,
	   P_FORMAT varchar2 default 'APEXVALIDATE')
      RETURN varchar2;

FUNCTION GET_THREAD_COMPLETION_STATUS 
      (P_CASEID NUMBER,
	   P_THREADNUM NUMBER default 0,
	   P_FORMAT varchar2 default 'APEXVALIDATE')
      RETURN VARCHAR2;
/* This function is working for converting EST to IST */
FUNCTION CONVERT_EST_TO_IST_TIME(P_EST_TIMESTAMP IN TIMESTAMP)
RETURN  TIMESTAMP;
FUNCTION GET_UNIFIED_STAGE_STATUS 
      (P_STAGEID NUMBER,
	   P_CASEID IN NUMBER)
      RETURN VARCHAR2;
FUNCTION GET_SEGMENTED_STAGE_STATUS 
      (P_STAGEID NUMBER,
      P_SEGMENT NUMBER,
	   P_CASEID IN NUMBER)
      RETURN VARCHAR2;
      
/*QCAI-342: Lookup table functionality for rules*/
Function LookUpTable(p_table_name varchar2,
					 p_input1 varchar2 default null, 
					 p_input2 varchar2 default null, 
					 p_input3 varchar2 default null, 
					 p_input4 varchar2 default null) return varchar2;

--IWT-416: get file status of counterpart triage files
--if there is no couterpart triage client setup, return null
FUNCTION GET_TRIAGE_FILE_STATUS (P_CASEID NUMBER) RETURN varchar2;

function GETSPLIT
(
    p_list varchar2,
    P_DEL VARCHAR2 := ','
) RETURN SPLIT_TBL PIPELINED;

FUNCTION FN_DATAFIELDVAL_AUD(P_DPENTRYID IN NUMBER,P_IN_UP IN VARCHAR2) RETURN VARCHAR2;

FUNCTION getQCAIOnDemandReadyCase Return Integer;

END IWS_APP_UTILS;
/