create or replace
TRIGGER "BI_CUBE1" 
  before insert on "CUBE1"               
  for each row  
begin   
  if :NEW."ID" is null then 
    select "CUBE1_SEQ".nextval into :NEW."ID" from dual; 
  end if; 
end; 
/