-- 1) Create Row type
CREATE OR REPLACE TYPE P_STAGE_STATUS_ROW AS OBJECT (
  caseid   NUMBER,
  stageid  number,
  file_segment number,
  userid number,
  iscompleted varchar2(1)
);
/

-- 2) Create Table using that Row Type
CREATE OR REPLACE TYPE P_STAGE_STATUS_tab 
  AS TABLE 
  OF P_STAGE_STATUS_ROW;
/

/**
-- 3) Create Package Spec that has a function which outputs to that Table
create or replace
PACKAGE CASESTATUS_UTILS
.... 
-- 4) Create Package Body that wrote each record in that table rowtype format
create or replace
PACKAGE BODY CASESTATUS_UTILS 
FUNCTION GETSTAGESTATUS 
...
  

-- show if you have any issues 
SHOW ERRORS

-- Test
--SELECT * FROM TABLE(CASESTATUS_UTILS.GETSTAGESTATUS())
