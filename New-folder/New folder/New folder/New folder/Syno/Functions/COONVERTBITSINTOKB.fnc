--------------------------------------------------------
--  DDL for Function COONVERTBITSINTOKB
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SNX_IWS2"."COONVERTBITSINTOKB" 
(bit Integer)
return varchar2
As kb varchar2(30);
Begin
if bit > 0 then
    kb := round(bit/1024);
 kb:=kb||'k';
 else kb:=0||'K';
 End if;
 return kb;
 End;


/

