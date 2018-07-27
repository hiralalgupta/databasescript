--------------------------------------------------------
--  DDL for Function MSECBETWEEN
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SNX_IWS2"."MSECBETWEEN" 
   (ts1 timestamp with time zone,
    ts2 timestamp with time zone,
    numDec number default 0
   )
  Return Number is
    i INTERVAL DAY(3) TO SECOND(3) := ts2 - ts1;
  Begin
    return round (
      +     extract( day    from i )*24*60*60*1000
      +     extract( hour   from i )*60*60*1000
      +     extract( minute from i )*60*1000
      +     extract( second from i )*1000
    , numDec);
  End;

/

