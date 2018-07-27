--------------------------------------------------------
--  DDL for Function CLIENTNAME
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SNX_IWS2"."CLIENTNAME" 
(clientid in NUMBER)
return VARCHAR2
is
begin
select clientname from clients c where c.clientid=clientid
end;

/

