create or replace
trigger trg_purgeid
before insert on PURGELOG
for each row
begin
select purgeid_seq.nextval
into :new.purgeid
from dual;
end;
/