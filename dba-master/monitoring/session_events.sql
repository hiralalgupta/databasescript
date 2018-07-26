-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/monitoring/session_events.sql
-- Author       : Tim Hall
-- Description  : Displays information on all database session events.
-- Requirements : Access to the V$ views.
-- Call Syntax  : @session_events
-- Last Modified: 11/03/2005
-- -----------------------------------------------------------------------------------
SET LINESIZE 200
SET PAGESIZE 1000
SET VERIFY OFF

COLUMN username FORMAT A20
COLUMN event FORMAT A40

SELECT NVL(s.username, '(oracle)') AS username,
       s.sid,
       s.serial#,
       se.event,
       se.total_waits,
       se.total_timeouts,
       se.time_waited,
       se.average_wait,
       se.max_wait,
       se.time_waited_micro
FROM   v$session_event se,
       v$session s
WHERE  s.sid = se.sid
AND    s.sid = &1
ORDER BY se.time_waited DESC;
