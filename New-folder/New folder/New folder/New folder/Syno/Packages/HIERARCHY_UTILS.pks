CREATE OR REPLACE PACKAGE            "HIERARCHY_UTILS" AS 

  PROCEDURE LOAD_MEDICAL_HIERARCHY (p_revision varchar2);
  PROCEDURE APPEND_PCS_CODE_TO_HIERARCHY (p_revision varchar2);
  PROCEDURE GENERATE_RANGE_LOVS;
  
  -- append into medicalhierarchy table from stage_codes table
  -- p_simulate is true if not updating database
  -- p_verbose is true will show dbms output for every code processed
  PROCEDURE APPEND_MEDICAL_HIERARCHY (p_revision varchar2, p_simulate boolean default true, p_verbose boolean default true);
  
  -- used for NDC consolidation of generic drugs
  PROCEDURE NDC_GROUPING (p_revision varchar2);
  
  -- used for NDC consolidation of brand name drugs
  PROCEDURE NDC_GROUPING2 (p_revision varchar2);
  
  -- Copy a revision to a new revision
  PROCEDURE COPY_REVISION (p_revision_from varchar2, p_revision_to varchar2);
  
  -- Copy exclusion list to a new client and/or new revision
  PROCEDURE COPY_EXCLUSION (p_clientid_from number, p_clientid_to number, p_revision_from varchar2, p_revision_to varchar2);

  -- append into exclusion list table from stage_codes table
  -- p_simulate is true if not updating database
  -- p_verbose is true will show dbms output for every code processed
  PROCEDURE APPEND_EXCLUSION (p_clientid number, p_revision varchar2, p_simulate boolean default true, p_verbose boolean default true);

  -- append into critical list table from stage_codes table
  -- p_simulate is true if not updating database
  -- p_verbose is true will show dbms output for every code processed
  PROCEDURE APPEND_CRITICAL (p_clientid number, p_clientname varchar2, p_simulate boolean default true, p_verbose boolean default true);

  -- This is a new version of hierarchy loading procedure. APPEND_MEDICAL_HIERARCHY is the older version.
  -- append into medicalhierarchy table from STAGE_SPINE table
  -- p_simulate is true if not updating database
  -- p_verbose is true will show dbms output for every code processed
  PROCEDURE APPEND_SPINE (p_revision varchar2, p_simulate boolean default true, p_verbose boolean default true);
  
  -- This is a new version of hierarchy loading procedure.
  -- It only updates the core record, not altering any data fields.
  -- p_simulate is true if not updating database
  -- p_verbose is true will show dbms output for every code processed
  PROCEDURE APPEND_SPINE_CORE (p_revision varchar2, p_simulate boolean default true, p_verbose boolean default true);
  
  -- Remove prefix from field names
  -- for example, SUB2.BeginTreatmentDate => BeginTreatmentDate
  Function Remove_SynId_Prefix (p_fieldname varchar2) return varchar2;
  
  -- this is a new version of exclusion loading procedure. APPEND_EXCLUSION is the older version.
  -- append into exclusion list table from STAGE_SPINE table
  -- p_simulate is true if not updating database
  -- p_verbose is true will show dbms output for every code processed
  PROCEDURE APPEND_SPINE_EXCLUSION (p_clientid number, p_revision varchar2, p_simulate boolean default true, p_verbose boolean default true);
  
  
  FUNCTION VALIDATE_METARULE(
    p_spine IN VARCHAR2,
    p_SYNID IN VARCHAR2,
	p_label in varchar2,
	p_value in varchar2)
  RETURN VARCHAR2;
  

  FUNCTION VALIDATE_METACODE(
    p_CODETYPE IN VARCHAR2,
    p_CODEVALUE IN VARCHAR2)
  RETURN VARCHAR2;

  -- Load list controls as LOVS from CONTROL_VALUES table
  PROCEDURE LOAD_CONTROL_LOVS;

  -- This runs after core spine is loaded to append controls to SynIDs
  -- p_simulate is true if not updating database
  -- p_verbose is true will show dbms output for every code processed
  PROCEDURE APPEND_SPINE_CONTROLS (p_revision varchar2, p_simulate boolean default true, p_verbose boolean default true);

END HIERARCHY_UTILS;
/