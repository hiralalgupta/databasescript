create or replace
PACKAGE            "UCM_UTILS" 
AS
  /* TODO enter package declarations (types, exceptions, methods etc) here */
PROCEDURE get_file(
    caseid IN NUMBER,
    doctype    VARCHAR2,
    outputfile VARCHAR2);
	
PROCEDURE DISPLAY_FILE(
    p_caseID  NUMBER,
    p_docType VARCHAR2);

--added p_tName for RPT-41 Modify Embargo screen to show PDF reports from different templates for a single case
PROCEDURE DISPLAY_FILE_T(
    p_caseID  NUMBER,
    p_docType VARCHAR2,
    p_tName VARCHAR2 Default '');
	
END UCM_UTILS;
