create or replace
TRIGGER "BI_IMAGES" 
  before insert on "IMAGES"               
  for each row  
begin   
  if :NEW."IMAGEID" is null then 
    select "IMAGES_SEQ".nextval into :NEW."IMAGEID" from dual; 
  end if; 
end;
/