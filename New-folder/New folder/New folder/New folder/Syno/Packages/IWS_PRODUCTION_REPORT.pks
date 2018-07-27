--------------------------------------------------------
--  File created - Friday-October-09-2015   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Package IWS_PRDUCTION_REPORT
--------------------------------------------------------

CREATE OR REPLACE PACKAGE "SNX_IWS2"."IWS_PRDUCTION_REPORT" AS 
FUNCTION FUN_PRODUCTIVE_TIME(P_STAGEID NUMBER, P_CASEID NUMBER) RETURN NUMBER;
FUNCTION FUN_PRODUCTIVE_USER_TIME(P_STAGEID NUMBER, P_CASEID NUMBER,P_USERID NUMBER) RETURN NUMBER;
/*This function used for hours*/
function timestamp_diff_minutes
   (
     start_time_in timestamp,
     end_time_in timestamp,
	 P_RoundTo number default 2
)
return number;
  /* TODO enter package declarations (types, exceptions, methods etc) here */ 
FUNCTION FUN_USER_STR(P_CASEID NUMBER,P_STAGEID NUMBER) RETURN VARCHAR2;

END IWS_PRDUCTION_REPORT;

/

