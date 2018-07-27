create or replace
PROCEDURE JHAPP_OUTPUT AS
cursor c_cases is select * from cases 
  where caseid between 49546 and 49651 and clientid=109 order by caseid;
cursor c_synids is select name from medicalhierarchy where revision='3.0.JH.APP' and depth is null
  and name not in (
  'APP_F_01_A',
  'LS_A_01_A',
  'LS_A_02_A',
  'MED1_A_01_TOB_A',
  'MED1_A_02_01_A',
  'MED1_A_03_A',
  'MED1_A_04_01_A',
  'APP_F_03_A',
  'LS_A_12') order by name;
v_row varchar2(4000);
v_value varchar2(2000);
BEGIN
  dbms_output.enable(200000);
  for r_case in c_cases loop
    v_row := '"' || r_case.caseid || '",';
    v_row := v_row || '"' || r_case.clientfilename || '",';
    
    for r_synid in c_synids loop
      begin
        select dpe.datafield1value into v_value from dpentries dpe, pages p, cases c, medicalhierarchy m
          where c.caseid=p.caseid and p.pageid=dpe.pageid and dpe.hid=m.id and m.revision='3.0.JH.APP' and m.depth is null
          and m.name=r_synid.name and c.caseid=r_case.caseid;
      exception when others then
        v_value := '';
      end;
      v_row := v_row || '"' || v_value || '",';
    end loop;
    dbms_output.put_line(v_row);
    v_row := '';
  end loop;
END JHAPP_OUTPUT;
/