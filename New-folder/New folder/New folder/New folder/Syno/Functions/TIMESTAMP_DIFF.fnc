--------------------------------------------------------
--  DDL for Function TIMESTAMP_DIFF
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SNX_IWS2"."TIMESTAMP_DIFF" 
(
start_time_in timestamp
, end_time_in timestamp
)
return number
as
l_days number;
l_hours number;
l_minutes number;
l_seconds number;
l_milliseconds number;
begin
select extract(day from end_time_in-start_time_in)
, extract(hour from end_time_in-start_time_in)
, extract(minute from end_time_in-start_time_in)
, extract(second from end_time_in-start_time_in)
into l_days, l_hours, l_minutes, l_seconds
from dual;

l_milliseconds := l_seconds*1000 + l_minutes*60*1000
+ l_hours*60*60*1000 + l_days*24*60*60*1000;

return l_milliseconds;
end;

/

