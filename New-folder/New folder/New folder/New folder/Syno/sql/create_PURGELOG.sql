CREATE TABLE PURGELOG 
(	
PURGEID NUMBER PRIMARY KEY,
CASEID NUMBER, 
PURGESTATUS VARCHAR2(30), 
PURGEDATE TIMESTAMP (4) WITH TIME ZONE, 
MESSAGE VARCHAR2(500);