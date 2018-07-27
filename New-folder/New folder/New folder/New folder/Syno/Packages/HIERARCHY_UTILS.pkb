set define off

create or replace
PACKAGE BODY HIERARCHY_UTILS AS
 
  PROCEDURE LOAD_MEDICAL_HIERARCHY (p_revision varchar2) AS
    cat1name varchar2(100);
    cat2name varchar2(100);
    cat3name varchar2(100);
    cat4name varchar2(100);
    hid integer;
    rootid integer;
    cat1id integer;
    cat2id integer;
    cat3id integer;
    cat4id integer;
    v_parentid integer;
    billable varchar2(1);
    AMOUNTBOX1 integer :=0;
    AMOUNTBOX2 integer :=0;
    DROPDOWN1 integer :=0;
    DROPDOWN2 integer :=0;
    DROPDOWN3 integer :=0;
    DATEBOX1 integer :=0;
    iString varchar2(1000);
    v_depth integer := 0;
    
    CURSOR cat1
    IS
      SELECT DISTINCT category1 catname FROM STAGE_CODES ORDER BY 1;
  
    CURSOR cat2(cat1 VARCHAR2)
    IS
      SELECT DISTINCT category2 catname    FROM STAGE_CODES
      WHERE category2 IS NOT NULL    AND category1    =cat1
      ORDER BY 1;
  
    CURSOR cat3(cat1 VARCHAR2, cat2 VARCHAR2)
    IS
      SELECT DISTINCT category3 catname    FROM STAGE_CODES
      WHERE category3 IS NOT NULL    AND category1    =cat1    AND category2    =cat2
      ORDER BY 1;
  
    CURSOR cat4(cat1 VARCHAR2, cat2 VARCHAR2, cat3 VARCHAR2)
    IS
      SELECT DISTINCT category4 catname    FROM STAGE_CODES
      WHERE category4 IS NOT NULL    AND category1    =cat1    AND category2    =cat2    AND category3    =cat3
      ORDER BY 1;
      
    CURSOR codes IS
      SELECT * FROM STAGE_CODES ORDER BY category1,category2,category3,category4,codevalue;
  BEGIN
    --get next ID number
    select max(id)+1 into hid from medicalhierarchy;
    
    --insert Root node
    insert into medicalhierarchy (id,name,parentid,billable,revision) values (hid,'Root',null,'N',p_revision);
    rootid := hid;
    hid := hid + 1;
    
    --level 1
    for rec1 in cat1 loop
      cat1name := rec1.catname;
      insert into medicalhierarchy (id,name,parentid,billable,revision) values (hid,cat1name,rootid,'N',p_revision);
      cat1id := hid;
      hid := hid + 1;
      --level 2
      for rec2 in cat2(cat1name) loop
        cat2name := rec2.catname;
        insert into medicalhierarchy (id,name,parentid,billable,revision) values (hid,cat2name,cat1id,'N',p_revision);
        cat2id := hid;
        hid := hid + 1;
        --level 3
        for rec3 in cat3(cat1name,cat2name) loop
            cat3name := rec3.catname;
            insert into medicalhierarchy (id,name,parentid,billable,revision) values (hid,cat3name,cat2id,'N',p_revision);
            cat3id := hid;
            hid := hid + 1;
            --level 4
            for rec4 in cat4(cat1name,cat2name,cat3name) loop
              cat4name := rec4.catname;
              insert into medicalhierarchy (id,name,parentid,billable,revision) values (hid,cat4name,cat3id,'N',p_revision);
              cat4id := hid;
              hid := hid + 1;
            end loop;
          end loop;
      end loop;
      commit;
    end loop;
    
    --codes
    for rec in codes loop
      cat1name := rec.category1;
      cat2name := rec.category2;
      cat3name := rec.category3;
      cat4name := rec.category4;
      --get parentid
      if (cat2name is null) then
        --dbms_output.put_line('cat1='||cat1name);
        --the code branch only has 2 levels
        v_depth := 2;
        select id into v_parentid from medicalhierarchy where
          revision=p_revision and name=cat1name and parentid=
          (select id from medicalhierarchy where revision=p_revision and name='Root');
      elsif (cat3name is null) then
        --dbms_output.put_line('cat1='||cat1name);
        --dbms_output.put_line('cat2='||cat2name);
        select id into v_parentid from medicalhierarchy where
          revision=p_revision and name=cat2name and parentid=
          (select id from medicalhierarchy where revision=p_revision and name=cat1name and parentid=
          (select id from medicalhierarchy where revision=p_revision and name='Root')
          );
      elsif (cat4name is null) then
        --dbms_output.put_line('cat1='||cat1name);
        --dbms_output.put_line('cat2='||cat2name);
        --dbms_output.put_line('cat3='||cat3name);
        select id into v_parentid from medicalhierarchy where
          revision=p_revision and name=cat3name and parentid=
          (select id from medicalhierarchy where revision=p_revision and name=cat2name and parentid=
          (select id from medicalhierarchy where revision=p_revision and name=cat1name and parentid=
          (select id from medicalhierarchy where revision=p_revision and name='Root')
          ));
      else    
        --dbms_output.put_line('cat1='||cat1name);
        --dbms_output.put_line('cat2='||cat2name);
        --dbms_output.put_line('cat3='||cat3name);
        --dbms_output.put_line('cat4='||cat4name);
        select id into v_parentid from medicalhierarchy where
          revision=p_revision and name=cat4name and parentid=
          (select id from medicalhierarchy where revision=p_revision and name=cat3name and parentid=
          (select id from medicalhierarchy where revision=p_revision and name=cat2name and parentid=
          (select id from medicalhierarchy where revision=p_revision and name=cat1name and parentid=
          (select id from medicalhierarchy where revision=p_revision and name='Root')
          )));
      end if;
      
      if (rec.label = 'TRUE') then
        billable := 'N';
      else
        billable := 'Y';
      end if;
  
      AMOUNTBOX1 :=0;
      AMOUNTBOX2 :=0;
      DROPDOWN1 :=0;
      DROPDOWN2 :=0;
      DROPDOWN3 :=0;
      DATEBOX1 :=0;
     
      iString := 'insert into medicalhierarchy (id,name,codetype,description,parentid,billable,commonname,revision,GREENFLAG,YELLOWFLAG,REDFLAG,
        DATAFIELD1,DATAFIELD1TYPE,DATAFIELD1REF,DATAFIELD2,DATAFIELD2TYPE,DATAFIELD2REF,Depth,DATAFIELD3,DATAFIELD3TYPE,DATAFIELD3REF,DATAFIELD4,DATAFIELD4TYPE,DATAFIELD4REF,
        DATAFIELD5,DATAFIELD5TYPE,DATAFIELD5REF,DATAFIELD6,DATAFIELD6TYPE,DATAFIELD6REF,DATAFIELD7,DATAFIELD7TYPE,DATAFIELD7REF,DATAFIELD8,DATAFIELD8TYPE,DATAFIELD8REF)
        values ('||hid||', '''||rec.codevalue||''', '''||rec.codetype||''', '''||replace(rec.description,'''','''''')||''','||v_parentid||','''||billable||''','''||replace(rec.SHORTNAME,'''','''''')||''','''
        ||p_revision||''','''||replace(rec.GREENFLAG,'''','''''')||''','''||replace(rec.YELLOWFLAG,'''','''''')||''','''||replace(rec.REDFLAG,'''','''''')||''','''||
        'Legend'',''LOVS'',560, ''Transcript'',''Text'',null';
      
      if (v_depth = 2) then
        --the code branch only has 2 levels
        iString := iString ||',' || v_depth;
      else
        iString := iString ||',null';
      end if;
      
      if (rec.AMOUNTBOX1='TRUE' and rec.LABELAMOUNTBOX1 is not null) then
        AMOUNTBOX1:=1;
        iString := iString || ',''' || rec.LABELAMOUNTBOX1 || ''',''Number'',null';
      end if;
      if (rec.AMOUNTBOX2='TRUE' and rec.LABELAMOUNTBOX2 is not null) then
        AMOUNTBOX2:=1;
        iString := iString || ',''' || rec.LABELAMOUNTBOX2 || ''',''Number'',null';
      end if;
      if (rec.DROPDOWN1='TRUE' and rec.LABELDROPDOWN1 is not null and rec.VALUESDROPDOWN1 is not null) then
        DROPDOWN1:=1;
        iString := iString || ',''' || rec.LABELDROPDOWN1 || ''',''LOVS'','||rec.VALUESDROPDOWN1;
      end if;
      if (rec.DROPDOWN2='TRUE' and rec.LABELDROPDOWN2 is not null and rec.VALUESDROPDOWN2 is not null) then
        DROPDOWN2:=1;
        iString := iString || ',''' || rec.LABELDROPDOWN2 || ''',''LOVS'','||rec.VALUESDROPDOWN2;
      end if;
      if (rec.DROPDOWN3='TRUE' and rec.LABELDROPDOWN3 is not null and rec.VALUESDROPDOWN3 is not null) then
        DROPDOWN3:=1;
        iString := iString || ',''' || rec.LABELDROPDOWN3 || ''',''LOVS'','||rec.VALUESDROPDOWN3;
      end if;
      if (rec.DATEBOX1='TRUE' and rec.DATEBOX1LABEL is not null) then
        DATEBOX1:=1;
        iString := iString || ',''' || rec.DATEBOX1LABEL || ''',''Date'',null';
      end if;
      
      --insert code
      case (AMOUNTBOX1 +AMOUNTBOX2 +DROPDOWN1 +DROPDOWN2 +DROPDOWN3 +DATEBOX1)
      when 0 then
        iString := iString || ',null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)';
      when 1 then
        iString := iString || ',null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)';
      when 2 then
        iString := iString || ',null,null,null,null,null,null,null,null,null,null,null,null)';
      when 3 then
        iString := iString || ',null,null,null,null,null,null,null,null,null)';
      when 4 then
        iString := iString || ',null,null,null,null,null,null)';
      when 5 then
        iString := iString || ',null,null,null)';
      when 6 then
        iString := iString || ')';
      end case;
      --dbms_output.put_line(iString);
      execute immediate iString;
      hid := hid + 1;
      
      /*rec.VALUESDROPDOWN1
      rec.VALUESDROPDOWN2
      rec.VALUESDROPDOWN3
      */
      
      IF mod(hid, 1000) = 0 THEN
        dbms_output.put_line(hid);
        -- Commit every 1000 records
        COMMIT;
      END IF;
    end loop;
  EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    delete from medicalhierarchy where revision=p_revision;
    commit;
    dbms_output.put_line(iString);
    raise;
  END LOAD_MEDICAL_HIERARCHY;
 
  PROCEDURE APPEND_PCS_CODE_TO_HIERARCHY (p_revision varchar2) AS
    cat1name varchar2(100);
    cat2name varchar2(100);
    cat3name varchar2(100);
    hid integer;
    cat1id integer;
    cat2id integer;
    cat3id integer;
    p_parentid integer;
    billable varchar2(1) := 'Y';
    codename varchar2(10);
    v_codeid integer;
    
    CURSOR cat1
    IS
      SELECT DISTINCT category1 catname FROM PCSCAT ORDER BY 1;
  
    CURSOR cat2(cat1 VARCHAR2)
    IS
      SELECT DISTINCT category2 catname    FROM PCSCAT
      WHERE category2 IS NOT NULL    AND category1    =cat1
      ORDER BY 1;
  
    CURSOR cat3(cat1 VARCHAR2, cat2 VARCHAR2)
    IS
      SELECT DISTINCT category3 catname    FROM PCSCAT
      WHERE category3 IS NOT NULL    AND category1    =cat1    AND category2    =cat2
      ORDER BY 1;
  
    CURSOR codes IS
      SELECT * FROM PCSCODES WHERE BILLABLE=1 ORDER BY ID;
  BEGIN
    --get next ID number
    select max(id)+1 into hid from medicalhierarchy;
    
    --find Procedures category
    select id into p_parentid from medicalhierarchy where revision=p_revision and name='Procedures';
    
    --level 1
    for rec1 in cat1 loop
      cat1name := rec1.catname;
      insert into medicalhierarchy (id,name,parentid,billable,revision,codetype) values (hid,cat1name,p_parentid,'N',p_revision, 'ICD-10-PCS');
      cat1id := hid;
      hid := hid + 1;
      --level 2
      for rec2 in cat2(cat1name) loop
        cat2name := rec2.catname;
        insert into medicalhierarchy (id,name,parentid,billable,revision,codetype) values (hid,cat2name,cat1id,'N',p_revision, 'ICD-10-PCS');
        cat2id := hid;
        hid := hid + 1;
        --level 3
        for rec3 in cat3(cat1name,cat2name) loop
            cat3name := rec3.catname;
            insert into medicalhierarchy (id,name,parentid,billable,revision,codetype) values (hid,cat3name,cat2id,'N',p_revision, 'ICD-10-PCS');
            cat3id := hid;
            hid := hid + 1;
          end loop;
      end loop;
      commit;
    end loop;
   
    --codes
    for rec in codes loop
      cat1name := rec.category1;
      cat2name := rec.category2;
      cat3name := rec.category3;
      codename := rec.codevalue;
     
      select id into p_parentid from medicalhierarchy where
          revision=p_revision and name=cat3name and parentid=
          (select id from medicalhierarchy where revision=p_revision and name=cat2name and parentid=
          (select id from medicalhierarchy where revision=p_revision and name=cat1name and parentid=
          (select id from medicalhierarchy where revision=p_revision and name='Procedures')
          ));
  
      insert into medicalhierarchy (id,name,codetype,description,parentid,billable,commonname,revision,GREENFLAG,YELLOWFLAG,REDFLAG,
        DATAFIELD1,DATAFIELD1TYPE,DATAFIELD1REF,DATAFIELD2,DATAFIELD2TYPE,DATAFIELD2REF)
        values (hid, codename, 'ICD-10-PCS', replace(rec.description,'''',''''''),p_parentid,billable,null,p_revision,null,null,null,'Legend','LOVS',560,
        'Status','LOVS',660);
      
      hid := hid + 1;
      
      IF mod(hid, 1000) = 0 THEN
        dbms_output.put_line(hid);
        -- Commit every 1000 records
        COMMIT;
      END IF;
    end loop;
  EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    --delete from medicalhierarchy where revision=p_revision and codetype='ICD-10-PCS';
    dbms_output.put_line(cat1name||'-'||cat2name||'-'||cat3name||'-'||codename);
    raise;
  END APPEND_PCS_CODE_TO_HIERARCHY;
 
  PROCEDURE GENERATE_RANGE_LOVS AS
    v_lovlabel LOVS.lovlabel%TYPE;
    v_lovvalues varchar2(4000);
    v_lovid LOVS.lovid%TYPE;
    v_count integer;
    
    cursor c_lov is
      select * from stage_range_lovs;
      
    cursor c_lovvalues (p_lovvalues varchar2) is
      select regexp_substr(p_lovvalues,'[^|]+', 1, level) lovvalues from dual
        connect by regexp_substr(p_lovvalues,'[^|]+', 1, level) is not null;
      
  BEGIN
    for r_lov in c_lov loop
      v_lovlabel := r_lov.lovlabel;
      v_lovvalues := r_lov.lovvalues;
      
      Begin
        select lovid into v_lovid from LOVS where lovlabel=v_lovlabel;
        --existing LOV
        update lovs set notes=v_lovvalues where lovid=v_lovid;
        delete from lovvalues where lovid=v_lovid;
        commit;
        v_count := 10;
        for r_lovvalues in c_lovvalues(v_lovvalues) loop
          insert into lovvalues (lovid, lovvalue, sequence) values (v_lovid, r_lovvalues.lovvalues, v_count);
          v_count := v_count + 10;
        end loop;
        commit;
      exception
      when no_data_found then
        --new LOV
        select lovs_seq.nextval into v_lovid from dual;
        insert into lovs (lovid, lovlabel, sequence, notes) values (v_lovid, v_lovlabel, 1, v_lovvalues);
        v_count := 10;
        for r_lovvalues in c_lovvalues(v_lovvalues) loop
          insert into lovvalues (lovid, lovvalue, sequence) values (v_lovid, replace(replace(r_lovvalues.lovvalues,'[',''),']',''), v_count);
          v_count := v_count + 10;
        end loop;
        commit;
      end;
      
    end loop;
    
  END GENERATE_RANGE_LOVS;
 
  PROCEDURE APPEND_MEDICAL_HIERARCHY (p_revision varchar2, p_simulate boolean default true, p_verbose boolean default true) AS
    cat1name varchar2(100);
    cat2name varchar2(100);
    cat3name varchar2(100);
    cat4name varchar2(100);
    hid integer;
    rootid integer;
    cat1id integer;
    cat2id integer;
    cat3id integer;
    cat4id integer;
    v_parentid integer;
    v_parentid_old integer;
    v_codeid integer;
    billable varchar2(1);
    AMOUNTBOX1 integer :=0;
    AMOUNTBOX2 integer :=0;
    DROPDOWN1 integer :=0;
    DROPDOWN2 integer :=0;
    DROPDOWN3 integer :=0;
    DROPDOWN4 integer :=0;
    DROPDOWN5 integer :=0;
    COMBOBOX1 integer :=0;
    COMBOBOX2 integer :=0;
    DATEBOX1 integer :=0;
    DATEBOX2 integer :=0;
    TRANSCRIPT INTEGER := 0;
    DESCRIPTION INTEGER := 0;
    OTHERNOTES INTEGER := 0;
    YEARFIRSTDIAG INTEGER := 0;
    LEGEND INTEGER := 0;
    v_legend integer;
    COMBOBOXNOTE INTEGER := 0;
    v_comboboxnote integer;
    v_description_label varchar2(200) := 'Description';
    iString varchar2(8000);
    v_path varchar2(500);
    v_depth integer := 0;
    v_pointer integer;
    v_new_code_count integer := 0;
    v_update_code_count integer := 0;
    v_new_cat_count integer := 0;
    too_many_fields EXCEPTION;
    
    CURSOR cat1
    IS
      SELECT DISTINCT category1 catname FROM STAGE_CODES ORDER BY 1;
  
    CURSOR cat2(cat1 VARCHAR2)
    IS
      SELECT DISTINCT category2 catname    FROM STAGE_CODES
      WHERE category2 IS NOT NULL    AND category1    =cat1
      ORDER BY 1;
  
    CURSOR cat3(cat1 VARCHAR2, cat2 VARCHAR2)
    IS
      SELECT DISTINCT category3 catname    FROM STAGE_CODES
      WHERE category3 IS NOT NULL    AND category1    =cat1    AND category2    =cat2
      ORDER BY 1;
  
    CURSOR cat4(cat1 VARCHAR2, cat2 VARCHAR2, cat3 VARCHAR2)
    IS
      SELECT DISTINCT category4 catname    FROM STAGE_CODES
      WHERE category4 IS NOT NULL    AND category1    =cat1    AND category2    =cat2    AND category3    =cat3
      ORDER BY 1;
      
    CURSOR codes IS
      SELECT * FROM STAGE_CODES ORDER BY category1,category2,category3,category4,codevalue;
  BEGIN
    if p_simulate=true then
      dbms_output.put_line('*** Simulate only. No change will be made in hierarchy. ***');
    end if;
    
    --get next ID number
    select max(id)+1 into hid from medicalhierarchy;
    
    --insert Root node if not exist
    BEGIN
      select id into rootid from medicalhierarchy where name='Root' and revision=p_revision;
    Exception
    when no_data_found then
      insert into medicalhierarchy (id,name,parentid,billable,revision) values (hid,'Root',null,'N',p_revision);
      rootid := hid;
      hid := hid + 1;
      v_new_cat_count := v_new_cat_count + 1;
    end;
    
    --level 1
    for rec1 in cat1 loop
      cat1name := rec1.catname;
      Begin
        select id into cat1id from medicalhierarchy where name=cat1name and parentid=rootid and revision=p_revision;
      Exception
      when no_data_found then
        insert into medicalhierarchy (id,name,parentid,billable,revision) values (hid,cat1name,rootid,'N',p_revision);
        cat1id := hid;
        hid := hid + 1;
        v_new_cat_count := v_new_cat_count + 1;
        dbms_output.put_line('New category 1: '||cat1name);
      end;
      --level 2
      for rec2 in cat2(cat1name) loop
        cat2name := rec2.catname;
        Begin
          select id into cat2id from medicalhierarchy where name=cat2name and parentid=cat1id and revision=p_revision;
        Exception
        when no_data_found then
          insert into medicalhierarchy (id,name,parentid,billable,revision) values (hid,cat2name,cat1id,'N',p_revision);
          cat2id := hid;
          hid := hid + 1;
          v_new_cat_count := v_new_cat_count + 1;
          dbms_output.put_line('New category 2: '||cat2name);
        end;
        --level 3
        for rec3 in cat3(cat1name,cat2name) loop
          cat3name := rec3.catname;
          Begin
            select id into cat3id from medicalhierarchy where name=cat3name and parentid=cat2id and revision=p_revision;
          Exception
          when no_data_found then
            insert into medicalhierarchy (id,name,parentid,billable,revision) values (hid,cat3name,cat2id,'N',p_revision);
            cat3id := hid;
            hid := hid + 1;
            v_new_cat_count := v_new_cat_count + 1;
            dbms_output.put_line('New category 3: '||cat3name);
          end;
          --level 4
          for rec4 in cat4(cat1name,cat2name,cat3name) loop
            cat4name := rec4.catname;
            Begin
              select id into cat4id from medicalhierarchy where name=cat4name and parentid=cat3id and revision=p_revision;
            Exception
            when no_data_found then
              insert into medicalhierarchy (id,name,parentid,billable,revision) values (hid,cat4name,cat3id,'N',p_revision);
              cat4id := hid;
              hid := hid + 1;
              v_new_cat_count := v_new_cat_count + 1;
              dbms_output.put_line('New category 4: '||cat4name);
            end;
          end loop;
        end loop;
      end loop;
    end loop;
    
    --codes
    for rec in codes loop
      cat1name := rec.category1;
      cat2name := rec.category2;
      cat3name := rec.category3;
      cat4name := rec.category4;
      --get parentid
      if (cat2name is null) then
        --dbms_output.put_line('cat1='||cat1name);
        --the code branch only has 2 levels
        v_depth := 2;
        select id into v_parentid from medicalhierarchy where
          revision=p_revision and name=cat1name and parentid=
          (select id from medicalhierarchy where revision=p_revision and name='Root');
      elsif (cat3name is null) then
        --dbms_output.put_line('cat1='||cat1name);
        --dbms_output.put_line('cat2='||cat2name);
        select id into v_parentid from medicalhierarchy where
          revision=p_revision and name=cat2name and parentid=
          (select id from medicalhierarchy where revision=p_revision and name=cat1name and parentid=
          (select id from medicalhierarchy where revision=p_revision and name='Root')
          );
      elsif (cat4name is null) then
        --dbms_output.put_line('cat1='||cat1name);
        --dbms_output.put_line('cat2='||cat2name);
        --dbms_output.put_line('cat3='||cat3name);
        select id into v_parentid from medicalhierarchy where
          revision=p_revision and name=cat3name and parentid=
          (select id from medicalhierarchy where revision=p_revision and name=cat2name and parentid=
          (select id from medicalhierarchy where revision=p_revision and name=cat1name and parentid=
          (select id from medicalhierarchy where revision=p_revision and name='Root')
          ));
      else    
        --dbms_output.put_line('cat1='||cat1name);
        --dbms_output.put_line('cat2='||cat2name);
        --dbms_output.put_line('cat3='||cat3name);
        --dbms_output.put_line('cat4='||cat4name);
        select id into v_parentid from medicalhierarchy where
          revision=p_revision and name=cat4name and parentid=
          (select id from medicalhierarchy where revision=p_revision and name=cat3name and parentid=
          (select id from medicalhierarchy where revision=p_revision and name=cat2name and parentid=
          (select id from medicalhierarchy where revision=p_revision and name=cat1name and parentid=
          (select id from medicalhierarchy where revision=p_revision and name='Root')
          )));
      end if;
      
      if (rec.label = 'TRUE') then
        billable := 'N';
      else
        billable := 'Y';
      end if;
  
      AMOUNTBOX1 :=0;
      AMOUNTBOX2 :=0;
      DROPDOWN1 :=0;
      DROPDOWN2 :=0;
      DROPDOWN3 :=0;
      DROPDOWN4 :=0;
      DROPDOWN5 :=0;
      COMBOBOX1 :=0;
      COMBOBOX2 :=0;
      DATEBOX1 :=0;
      DATEBOX2 :=0;
      TRANSCRIPT := 0;
      DESCRIPTION := 0;
      YEARFIRSTDIAG := 0;
      LEGEND := 0;
      COMBOBOXNOTE := 0;
      OTHERNOTES := 0;
     
      --Legend and combo box note
      --SPINE-21 add combo box note as first field or right after legend field
      Case cat1name
        When 'Family History' Then
          LEGEND := 0;
          COMBOBOXNOTE := 1;
          v_comboboxnote := 5402;
        When 'Disease' Then
          LEGEND := 0;
          COMBOBOXNOTE := 1;
          v_comboboxnote := 5401;
        When 'Symptoms' Then
          LEGEND := 0;
          COMBOBOXNOTE := 1;
          v_comboboxnote := 5401;
        When 'Injuries' Then
          LEGEND := 0;
          COMBOBOXNOTE := 1;
          v_comboboxnote := 5401;
        When 'General Diagnostic Tests' Then
          v_legend := 5403;
          LEGEND := 1;
          COMBOBOXNOTE := 1;
          v_comboboxnote := 5402;
        When 'Biochemistry' Then
          v_legend := 5403;
          LEGEND := 1;
          COMBOBOXNOTE := 1;
          v_comboboxnote := 5402;
        When 'Endoscopy' Then
          v_legend := 5403;
          LEGEND := 1;
          COMBOBOXNOTE := 1;
          v_comboboxnote := 5402;
        When 'Imaging' Then
          v_legend := 5403;
          LEGEND := 1;
          COMBOBOXNOTE := 1;
          v_comboboxnote := 5402;
        When 'Microbiology' Then
          v_legend := 5403;
          LEGEND := 1;
          COMBOBOXNOTE := 1;
          v_comboboxnote := 5402;
        When 'Procedures' Then
          LEGEND := 0;
          COMBOBOXNOTE := 1;
          v_comboboxnote := 5401;
        When 'Drugs & Medications' Then
          LEGEND := 0;
          COMBOBOXNOTE := 1;
          v_comboboxnote := 5401;
        When 'General Health' Then
          v_legend := 5404;
          LEGEND := 1;
          COMBOBOXNOTE := 1;
          v_comboboxnote := 5401;
        When 'Cardiovascular Tests' Then
          v_legend := 5403;
          LEGEND := 1;
          COMBOBOXNOTE := 1;
          v_comboboxnote := 5402;
        When 'Cardiovascular' Then
          v_legend := 5403;
          LEGEND := 1;
          COMBOBOXNOTE := 1;
          v_comboboxnote := 5402;
        When 'Restrictions' Then
          LEGEND := 0;
          COMBOBOXNOTE := 1;
          v_comboboxnote := 5401;
        When 'Lab Tests' Then
          v_legend := 5403;
          LEGEND := 1;
          COMBOBOXNOTE := 1;
          v_comboboxnote := 5402;
        Else
          LEGEND := 0;
          COMBOBOXNOTE := 1;
          v_comboboxnote := 5402;
      End Case;
      
      Begin
        --check if code exists
        select id into v_codeid from medicalhierarchy where name=rec.codevalue and linktoid is null and revision=p_revision and codetype=rec.codetype;
        
        --code exists, get original parent id
        select parentid into v_parentid_old from medicalhierarchy where id=v_codeid;
        
        if p_simulate=false then
          update medicalhierarchy set description=null,billable=null,commonname=null,GREENFLAG=null,YELLOWFLAG=null,REDFLAG=null,Depth=null,
            DATAFIELD1=null,DATAFIELD1TYPE=null,DATAFIELD1REF=null,DATAFIELD2=null,DATAFIELD2TYPE=null,DATAFIELD2REF=null,
            DATAFIELD3=null,DATAFIELD3TYPE=null,DATAFIELD3REF=null,DATAFIELD4=null,DATAFIELD4TYPE=null,DATAFIELD4REF=null,
            DATAFIELD5=null,DATAFIELD5TYPE=null,DATAFIELD5REF=null,DATAFIELD6=null,DATAFIELD6TYPE=null,DATAFIELD6REF=null,
            DATAFIELD7=null,DATAFIELD7TYPE=null,DATAFIELD7REF=null,DATAFIELD8=null,DATAFIELD8TYPE=null,DATAFIELD8REF=null,
            DATAFIELD9=null,DATAFIELD9TYPE=null,DATAFIELD9REF=null,DATAFIELD10=null,DATAFIELD10TYPE=null,DATAFIELD10REF=null,
            DATAFIELD11=null,DATAFIELD11TYPE=null,DATAFIELD11REF=null,DATAFIELD12=null,DATAFIELD12TYPE=null,DATAFIELD12REF=null,
            DATAFIELD13=null,DATAFIELD13TYPE=null,DATAFIELD13REF=null,DATAFIELD14=null,DATAFIELD14TYPE=null,DATAFIELD14REF=null, --IWN-1037 Add 8 more data fields to HIERARCHY_UTILS
            DATAFIELD15=null,DATAFIELD15TYPE=null,DATAFIELD15REF=null,DATAFIELD16=null,DATAFIELD16TYPE=null,DATAFIELD16REF=null,
            DATAFIELD17=null,DATAFIELD17TYPE=null,DATAFIELD17REF=null,DATAFIELD18=null,DATAFIELD18TYPE=null,DATAFIELD18REF=null,
            DATAFIELD19=null,DATAFIELD19TYPE=null,DATAFIELD19REF=null,DATAFIELD20=null,DATAFIELD20TYPE=null,DATAFIELD20REF=null,
            DATAFIELD21=null,DATAFIELD21TYPE=null,DATAFIELD21REF=null,DATAFIELD22=null,DATAFIELD22TYPE=null,DATAFIELD22REF=null, --IWN-1178 Add 12 more data fields to related database tables and views
            DATAFIELD23=null,DATAFIELD23TYPE=null,DATAFIELD23REF=null,DATAFIELD24=null,DATAFIELD24TYPE=null,DATAFIELD24REF=null,
            DATAFIELD25=null,DATAFIELD25TYPE=null,DATAFIELD25REF=null,DATAFIELD26=null,DATAFIELD26TYPE=null,DATAFIELD26REF=null,
            DATAFIELD27=null,DATAFIELD27TYPE=null,DATAFIELD27REF=null,DATAFIELD28=null,DATAFIELD28TYPE=null,DATAFIELD28REF=null,
            DATAFIELD29=null,DATAFIELD29TYPE=null,DATAFIELD29REF=null,DATAFIELD30=null,DATAFIELD30TYPE=null,DATAFIELD30REF=null,
            DATAFIELD31=null,DATAFIELD31TYPE=null,DATAFIELD31REF=null,DATAFIELD32=null,DATAFIELD32TYPE=null,DATAFIELD32REF=null
            where id=v_codeid;
        end if;
        
        iString := 'update medicalhierarchy set ';
        
        if (v_depth = 2) then
          --the code branch only has 2 levels
          iString := iString ||'depth=' || v_depth || ' ';
        else
          iString := iString ||'depth=null ';
        end if;
        
        if (v_parentid_old = v_parentid) then
          if p_verbose = true then
            dbms_output.put_line('Code '||cat1name||'/'||cat2name||'/'||cat3name||'/'||cat4name||'/'||rec.codevalue||' exists. Updating.');
          end if;
        else
          --category path changed
          select path into v_path from medicalhierarchy_leaf_level_v where hid=v_codeid;
          if p_verbose = true then
            dbms_output.put_line('Code '||rec.codevalue||' exists. Moving from '|| v_path ||' to '||cat1name||'/'||cat2name||'/'||cat3name||'/'||cat4name||' and Updating.');
          end if;
          iString := iString ||', parentid=' || v_parentid || ' ';
        end if;
        
        iString := iString || ', description='''||replace(rec.description,'''','''''')||''', billable='''||billable||''', commonname='''||replace(rec.SHORTNAME,'''','''''')
                           ||''',GREENFLAG='''||replace(rec.GREENFLAG,'''','''''')||''',YELLOWFLAG='''||replace(rec.YELLOWFLAG,'''','''''')||''',REDFLAG='''||replace(rec.REDFLAG,'''','''''')||'''';
 
        v_pointer := 1;
        
        --Legend?
        if (LEGEND=1) then
          iString := iString || ', DATAFIELD'||v_pointer||'=''Legend'', DATAFIELD'||v_pointer||'TYPE=''LOVS'', DATAFIELD'||v_pointer||'REF='||v_legend;
          v_pointer := v_pointer + 1;
        end if;
        
        --Combo box note?
        -- SPINE-21 add combo box note as first field or right after legend field
        if (COMBOBOXNOTE=1) then
          iString := iString || ', DATAFIELD'||v_pointer||'=''Note'', DATAFIELD'||v_pointer||'TYPE=''Combo'', DATAFIELD'||v_pointer||'REF=' || v_comboboxnote;
          v_pointer := v_pointer + 1;
        end if;
 
        --Transcript?
        if (rec.NOTRANSCRIPTIONBOX='FALSE') then
          iString := iString || ', DATAFIELD'||v_pointer||'=''Transcript'', DATAFIELD'||v_pointer||'TYPE=''Text'', DATAFIELD'||v_pointer||'REF=null';
          v_pointer := v_pointer + 1;
          TRANSCRIPT := 1;
        end if;
 
        if (rec.AMOUNTBOX1='TRUE' and rec.LABELAMOUNTBOX1 is not null) then
          AMOUNTBOX1:=1;
          iString := iString || ', DATAFIELD'||v_pointer||'=''' || rec.LABELAMOUNTBOX1 || ''', DATAFIELD'||v_pointer||'TYPE=''Number'', DATAFIELD'||v_pointer||'REF=null';
          v_pointer := v_pointer + 1;
        end if;
        if (rec.AMOUNTBOX2='TRUE' and rec.LABELAMOUNTBOX2 is not null) then
          AMOUNTBOX2:=1;
          iString := iString || ', DATAFIELD'||v_pointer||'=''' || rec.LABELAMOUNTBOX2 || ''', DATAFIELD'||v_pointer||'TYPE=''Number'', DATAFIELD'||v_pointer||'REF=null';
          v_pointer := v_pointer + 1;
        end if;
        if (rec.DROPDOWN1='TRUE' and rec.LABELDROPDOWN1 is not null and rec.VALUESDROPDOWN1 is not null) then
          DROPDOWN1:=1;
          iString := iString || ', DATAFIELD'||v_pointer||'=''' || rec.LABELDROPDOWN1 || ''', DATAFIELD'||v_pointer||'TYPE=''LOVS'', DATAFIELD'||v_pointer||'REF=' || rec.VALUESDROPDOWN1;
          v_pointer := v_pointer + 1;
        end if;
        if (rec.DROPDOWN2='TRUE' and rec.LABELDROPDOWN2 is not null and rec.VALUESDROPDOWN2 is not null) then
          DROPDOWN2:=1;
          iString := iString || ', DATAFIELD'||v_pointer||'=''' || rec.LABELDROPDOWN2 || ''', DATAFIELD'||v_pointer||'TYPE=''LOVS'', DATAFIELD'||v_pointer||'REF=' || rec.VALUESDROPDOWN2;
          v_pointer := v_pointer + 1;
        end if;
        if (rec.DROPDOWN3='TRUE' and rec.LABELDROPDOWN3 is not null and rec.VALUESDROPDOWN3 is not null) then
          DROPDOWN3:=1;
          iString := iString || ', DATAFIELD'||v_pointer||'=''' || rec.LABELDROPDOWN3 || ''', DATAFIELD'||v_pointer||'TYPE=''LOVS'', DATAFIELD'||v_pointer||'REF=' || rec.VALUESDROPDOWN3;
          v_pointer := v_pointer + 1;
        end if;
        if (rec.DROPDOWN4='TRUE' and rec.LABELDROPDOWN4 is not null and rec.VALUESDROPDOWN4 is not null) then
          DROPDOWN4:=1;
          iString := iString || ', DATAFIELD'||v_pointer||'=''' || rec.LABELDROPDOWN4 || ''', DATAFIELD'||v_pointer||'TYPE=''LOVS'', DATAFIELD'||v_pointer||'REF=' || rec.VALUESDROPDOWN4;
          v_pointer := v_pointer + 1;
        end if;
        if (rec.DROPDOWN5='TRUE' and rec.LABELDROPDOWN5 is not null and rec.VALUESDROPDOWN5 is not null) then
          DROPDOWN5:=1;
          iString := iString || ', DATAFIELD'||v_pointer||'=''' || rec.LABELDROPDOWN5 || ''', DATAFIELD'||v_pointer||'TYPE=''LOVS'', DATAFIELD'||v_pointer||'REF=' || rec.VALUESDROPDOWN5;
          v_pointer := v_pointer + 1;
        end if;
        
        --Combo box 1?
        if (rec.COMBOBOX1='TRUE' and rec.LabelComboBox1 is not null and rec.ValuesComboBox1 is not null) then
          COMBOBOX1:=1;
          iString := iString || ', DATAFIELD'||v_pointer||'=''' || rec.LabelComboBox1 || ''', DATAFIELD'||v_pointer||'TYPE=''Combo'', DATAFIELD'||v_pointer||'REF=' || rec.ValuesComboBox1;
          v_pointer := v_pointer + 1;
        end if;
        
        --Combo box 2?
        if (rec.COMBOBOX2='TRUE' and rec.LabelComboBox2 is not null and rec.ValuesComboBox2 is not null) then
          COMBOBOX2:=1;
          iString := iString || ', DATAFIELD'||v_pointer||'=''' || rec.LabelComboBox2 || ''', DATAFIELD'||v_pointer||'TYPE=''Combo'', DATAFIELD'||v_pointer||'REF=' || rec.ValuesComboBox2;
          v_pointer := v_pointer + 1;
        end if;
        
        if (rec.DATEBOX1='TRUE' and rec.DATEBOX1LABEL is not null) then
          DATEBOX1:=1;
          iString := iString || ', DATAFIELD'||v_pointer||'=''' || rec.DATEBOX1LABEL || ''', DATAFIELD'||v_pointer||'TYPE=''Date'', DATAFIELD'||v_pointer||'REF=null';
          v_pointer := v_pointer + 1;
        end if;
        if (rec.DATEBOX2='TRUE' and rec.DATEBOX2LABEL is not null) then
          DATEBOX2:=1;
          iString := iString || ', DATAFIELD'||v_pointer||'=''' || rec.DATEBOX2LABEL || ''', DATAFIELD'||v_pointer||'TYPE=''Date'', DATAFIELD'||v_pointer||'REF=null';
          v_pointer := v_pointer + 1;
        end if;
        --Description?
        if (rec.OPENDESCRIPTIONBOX='TRUE') then
          if (rec.OpenDescriptionBoxLabel = '') then
            v_description_label := 'Description';
          else
            v_description_label := rec.OpenDescriptionBoxLabel;
          end if;
          iString := iString || ', DATAFIELD'||v_pointer||'='''||v_description_label||''', DATAFIELD'||v_pointer||'TYPE=''Text'', DATAFIELD'||v_pointer||'REF=null';
          v_pointer := v_pointer + 1;
          DESCRIPTION := 1;
        end if;
        
        -- SPINE-26 Add Year of First Diagnosis Number box as last field for Disease and Injuries
        if (cat1name='Disease' or cat1name='Injuries') then
          YEARFIRSTDIAG := 1;
          iString := iString || ', DATAFIELD'||v_pointer||'=''Year of First Diagnosis'', DATAFIELD'||v_pointer||'TYPE=''Number'', DATAFIELD'||v_pointer||'REF=null';
          v_pointer := v_pointer + 1;
        end if;
        
        --SPINE-98: add an Other Notes field to all spine codes, regardless of category
        --if OpenDescriptionBoxLabel is not Other Notes and there is available data field, add Other Notes as last field
        if ((rec.OPENDESCRIPTIONBOX='FALSE' or (rec.OPENDESCRIPTIONBOX='TRUE' and rec.OpenDescriptionBoxLabel != 'Other Notes')) and v_pointer <= 12) then
          OTHERNOTES := 1;
          iString := iString || ', DATAFIELD'||v_pointer||'=''Other Notes'', DATAFIELD'||v_pointer||'TYPE=''Text'', DATAFIELD'||v_pointer||'REF=null';
          v_pointer := v_pointer + 1;
        end if;
        
        iString := iString || ' where id='|| v_codeid;
        
        if v_pointer > 21 then
          raise too_many_fields;
        end if;
        
        if p_simulate=false then
          execute immediate iString;
        end if;
        v_update_code_count := v_update_code_count + 1;
      Exception
      WHEN too_many_fields THEN
        raise too_many_fields;
      when no_data_found then
        --new code
        if p_verbose = true then
          dbms_output.put_line('New Code '||cat1name||'/'||cat2name||'/'||cat3name||'/'||cat4name||'/'||rec.codevalue||'. Inserting.');
        end if;
        iString := 'insert into medicalhierarchy (id,name,codetype,description,parentid,billable,commonname,revision,GREENFLAG,YELLOWFLAG,REDFLAG,Depth,
          DATAFIELD1,DATAFIELD1TYPE,DATAFIELD1REF,DATAFIELD2,DATAFIELD2TYPE,DATAFIELD2REF,DATAFIELD3,DATAFIELD3TYPE,DATAFIELD3REF,DATAFIELD4,DATAFIELD4TYPE,DATAFIELD4REF,
          DATAFIELD5,DATAFIELD5TYPE,DATAFIELD5REF,DATAFIELD6,DATAFIELD6TYPE,DATAFIELD6REF,DATAFIELD7,DATAFIELD7TYPE,DATAFIELD7REF,DATAFIELD8,DATAFIELD8TYPE,DATAFIELD8REF,
          DATAFIELD9,DATAFIELD9TYPE,DATAFIELD9REF,DATAFIELD10,DATAFIELD10TYPE,DATAFIELD10REF,DATAFIELD11,DATAFIELD11TYPE,DATAFIELD11REF,DATAFIELD12,DATAFIELD12TYPE,DATAFIELD12REF,
		  DATAFIELD13,DATAFIELD13TYPE,DATAFIELD13REF,DATAFIELD14,DATAFIELD14TYPE,DATAFIELD14REF,DATAFIELD15,DATAFIELD15TYPE,DATAFIELD15REF,DATAFIELD16,DATAFIELD16TYPE,DATAFIELD16REF,
		  DATAFIELD17,DATAFIELD17TYPE,DATAFIELD17REF,DATAFIELD18,DATAFIELD18TYPE,DATAFIELD18REF,DATAFIELD19,DATAFIELD19TYPE,DATAFIELD19REF,DATAFIELD20,DATAFIELD20TYPE,DATAFIELD20REF,
		  DATAFIELD21,DATAFIELD21TYPE,DATAFIELD21REF,DATAFIELD22,DATAFIELD22TYPE,DATAFIELD22REF,DATAFIELD23,DATAFIELD23TYPE,DATAFIELD23REF,DATAFIELD24,DATAFIELD24TYPE,DATAFIELD24REF,
		  DATAFIELD25,DATAFIELD25TYPE,DATAFIELD25REF,DATAFIELD26,DATAFIELD26TYPE,DATAFIELD26REF,DATAFIELD27,DATAFIELD27TYPE,DATAFIELD27REF,DATAFIELD28,DATAFIELD28TYPE,DATAFIELD28REF,
		  DATAFIELD29,DATAFIELD29TYPE,DATAFIELD29REF,DATAFIELD30,DATAFIELD30TYPE,DATAFIELD30REF,DATAFIELD31,DATAFIELD31TYPE,DATAFIELD31REF,DATAFIELD32,DATAFIELD32TYPE,DATAFIELD32REF)
          values ('||hid||', '''||rec.codevalue||''', '''||rec.codetype||''', '''||replace(rec.description,'''','''''')||''','||v_parentid||','''||billable||''','''||replace(rec.SHORTNAME,'''','''''')||''','''
          ||p_revision||''','''||replace(rec.GREENFLAG,'''','''''')||''','''||replace(rec.YELLOWFLAG,'''','''''')||''','''||replace(rec.REDFLAG,'''','''''')||'''';
        
        if (v_depth = 2) then
          --the code branch only has 2 levels
          iString := iString ||',' || v_depth;
        else
          iString := iString ||',null';
        end if;
        
        --Legend?
        if (LEGEND=1) then
          iString := iString || ',''Legend'',''LOVS'',' || v_legend;
        end if;
        
        --Combo box note?
        -- SPINE-21 add combo box note as first field or right after legend field
        if (COMBOBOXNOTE=1) then
           iString := iString || ',''Note'',''Combo'','||v_comboboxnote;
        end if;
 
        --Transcript?
        if (rec.NOTRANSCRIPTIONBOX='FALSE') then
          iString := iString || ',''Transcript'',''Text'',null';
          TRANSCRIPT := 1;
        end if;
        
        if (rec.AMOUNTBOX1='TRUE' and rec.LABELAMOUNTBOX1 is not null) then
          AMOUNTBOX1:=1;
          iString := iString || ',''' || rec.LABELAMOUNTBOX1 || ''',''Number'',null';
        end if;
        if (rec.AMOUNTBOX2='TRUE' and rec.LABELAMOUNTBOX2 is not null) then
          AMOUNTBOX2:=1;
          iString := iString || ',''' || rec.LABELAMOUNTBOX2 || ''',''Number'',null';
        end if;
        if (rec.DROPDOWN1='TRUE' and rec.LABELDROPDOWN1 is not null and rec.VALUESDROPDOWN1 is not null) then
          DROPDOWN1:=1;
          iString := iString || ',''' || rec.LABELDROPDOWN1 || ''',''LOVS'','||rec.VALUESDROPDOWN1;
        end if;
        if (rec.DROPDOWN2='TRUE' and rec.LABELDROPDOWN2 is not null and rec.VALUESDROPDOWN2 is not null) then
          DROPDOWN2:=1;
          iString := iString || ',''' || rec.LABELDROPDOWN2 || ''',''LOVS'','||rec.VALUESDROPDOWN2;
        end if;
        if (rec.DROPDOWN3='TRUE' and rec.LABELDROPDOWN3 is not null and rec.VALUESDROPDOWN3 is not null) then
          DROPDOWN3:=1;
          iString := iString || ',''' || rec.LABELDROPDOWN3 || ''',''LOVS'','||rec.VALUESDROPDOWN3;
        end if;
        if (rec.DROPDOWN4='TRUE' and rec.LABELDROPDOWN4 is not null and rec.VALUESDROPDOWN4 is not null) then
          DROPDOWN4:=1;
          iString := iString || ',''' || rec.LABELDROPDOWN4 || ''',''LOVS'','||rec.VALUESDROPDOWN4;
        end if;
        if (rec.DROPDOWN5='TRUE' and rec.LABELDROPDOWN5 is not null and rec.VALUESDROPDOWN5 is not null) then
          DROPDOWN5:=1;
          iString := iString || ',''' || rec.LABELDROPDOWN5 || ''',''LOVS'','||rec.VALUESDROPDOWN5;
        end if;
        
        --combo box 1?
        if (rec.ComboBox1='TRUE' and rec.LabelComboBox1 is not null and rec.ValuesComboBox1 is not null) then
          COMBOBOX1:=1;
          iString := iString || ',''' || rec.LabelComboBox1 || ''',''Combo'','||rec.ValuesComboBox1;
        end if;
        
        --combo box 2?
        if (rec.ComboBox2='TRUE' and rec.LabelComboBox2 is not null and rec.ValuesComboBox2 is not null) then
          COMBOBOX2:=1;
          iString := iString || ',''' || rec.LabelComboBox2 || ''',''Combo'','||rec.ValuesComboBox2;
        end if;
        
        if (rec.DATEBOX1='TRUE' and rec.DATEBOX1LABEL is not null) then
          DATEBOX1:=1;
          iString := iString || ',''' || rec.DATEBOX1LABEL || ''',''Date'',null';
        end if;
        if (rec.DATEBOX2='TRUE' and rec.DATEBOX2LABEL is not null) then
          DATEBOX2:=1;
          iString := iString || ',''' || rec.DATEBOX2LABEL || ''',''Date'',null';
        end if;
        --Description?
        if (rec.OPENDESCRIPTIONBOX='TRUE') then
          DESCRIPTION:=1;
          if (rec.OpenDescriptionBoxLabel = '') then
            v_description_label := 'Description';
          else
            v_description_label := rec.OpenDescriptionBoxLabel;
          end if;
          iString := iString || ','''||v_description_label||''',''Text'',null';
        end if;
        
        -- SPINE-26 Add Year of First Diagnosis Number box as last field for Disease and Injuries
        if (cat1name='Disease' or cat1name='Injuries') then
          YEARFIRSTDIAG := 1;
          iString := iString || ',''Year of First Diagnosis'',''Number'',null';
        end if;
 
        --SPINE-98: add an Other Notes field to all spine codes, regardless of category
        --if OpenDescriptionBoxLabel is not Other Notes and there is available data field, add Other Notes as last field
		--IWN-1037 Add 8 more data fields to HIERARCHY_UTILS
        if ((rec.OPENDESCRIPTIONBOX='FALSE' or (rec.OPENDESCRIPTIONBOX='TRUE' and rec.OpenDescriptionBoxLabel != 'Other Notes')) and
            LEGEND +TRANSCRIPT +AMOUNTBOX1 +AMOUNTBOX2 +DROPDOWN1 +DROPDOWN2 +DROPDOWN3 +DROPDOWN4 
            +DROPDOWN5 +COMBOBOX1 +COMBOBOX2 +DATEBOX1 +DATEBOX2 +DESCRIPTION +YEARFIRSTDIAG +COMBOBOXNOTE <=19) then 
          OTHERNOTES := 1;
          iString := iString || ',''Other Notes'',''Text'',null';
        end if;

        --insert code
        case (LEGEND +TRANSCRIPT +AMOUNTBOX1 +AMOUNTBOX2 +DROPDOWN1 +DROPDOWN2 +DROPDOWN3 +DROPDOWN4 +DROPDOWN5 +COMBOBOX1 +COMBOBOX2 +DATEBOX1 +DATEBOX2 +DESCRIPTION +YEARFIRSTDIAG +COMBOBOXNOTE +OTHERNOTES)
        when 0 then
          iString := iString || ',null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)';
        when 1 then
          iString := iString || ',null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)';
        when 2 then
          iString := iString || ',null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)';
        when 3 then
          iString := iString || ',null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)';
        when 4 then
          iString := iString || ',null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)';
        when 5 then
          iString := iString || ',null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)';
        when 6 then
          iString := iString || ',null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)';
        when 7 then
          iString := iString || ',null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)';
        when 8 then
          iString := iString || ',null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)';
        when 9 then
          iString := iString || ',null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)';
        when 10 then
          iString := iString || ',null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)';
        when 11 then
          iString := iString || ',null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)';
        when 12 then
          iString := iString || ',null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)';
        when 13 then
          iString := iString || ',null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)';
        when 14 then
          iString := iString || ',null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)';
        when 15 then
          iString := iString || ',null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)';
        when 16 then
          iString := iString || ',null,null,null,null,null,null,null,null,null,null,null,null)';
        when 17 then
          iString := iString || ',null,null,null,null,null,null,null,null,null)';
        when 18 then
          iString := iString || ',null,null,null,null,null,null)';
        when 19 then
          iString := iString || ',null,null,null)';
        when 20 then
          iString := iString || ')';
        else
          raise too_many_fields;
        end case;
        
        --dbms_output.put_line(iString);
        if p_simulate=false then
          execute immediate iString;
        end if;
        hid := hid + 1;
        v_new_code_count := v_new_code_count + 1;
      end;      
      
      IF mod(hid, 1000) = 0 THEN
        dbms_output.put_line(hid);
        -- Commit every 1000 records
        if p_simulate=false then
          COMMIT;
        END IF;
      end if;
    end loop;
    dbms_output.put_line('New codes added: '||v_new_code_count);
    dbms_output.put_line('Codes updated: '||v_update_code_count);
    dbms_output.put_line('New categories added: '||v_new_cat_count);
    
    if p_simulate=true then
      dbms_output.put_line('*** Simulate only. No change was made in hierarchy. ***');
      rollback;
    end if;
    
  EXCEPTION
  WHEN too_many_fields THEN
    ROLLBACK;
    dbms_output.put_line('Too many data fields!!!');
    dbms_output.put_line(iString);
    raise;  	
  WHEN OTHERS THEN
    ROLLBACK;
    dbms_output.put_line('New codes added: '||v_new_code_count);
    dbms_output.put_line('Codes updated: '||v_update_code_count);
    dbms_output.put_line('New categories added: '||v_new_cat_count);
    dbms_output.put_line(iString);
    raise;
  END APPEND_MEDICAL_HIERARCHY;
 
  PROCEDURE NDC_GROUPING (p_revision varchar2) AS
    v_code varchar2(20);
    v_code_to_update varchar2(20) := '';
    v_alt_codes varchar2(4000) := '';
    v_alt_count integer;
    v_group varchar2(4000);
    v_group_pre varchar2(4000) := ' ';
    cursor cur_group is
      select * from ndc_group order by id;
  begin
    for rec_group in cur_group loop
      v_code := rec_group.productndc;
      v_group := rec_group.groupname;
      if (upper(v_group) <> upper(v_group_pre)) then
        insert into NDC_UPDATE values (v_code_to_update, v_alt_codes);
        v_alt_count := 0;
        v_alt_codes := '';
        v_code_to_update := v_code;
        v_group_pre := v_group;
      else
        v_alt_count := v_alt_count + 1;
        if (v_alt_count = 1) then
          v_alt_codes := v_code;
        elsif (v_alt_count <= 10) then
          v_alt_codes := v_alt_codes || ',' || v_code;
        end if;
        insert into NDC_DELETE values (v_code);
      end if;
      
      IF mod(rec_group.id, 1000) = 0 THEN
        -- Commit every 1000 records
        COMMIT;
      END IF;
      
    end loop;
    commit;
  EXCEPTION
  WHEN OTHERS THEN
    --dbms_output.put_line(iString);
    raise;
  end NDC_GROUPING;
  
  PROCEDURE NDC_GROUPING2 (p_revision varchar2) AS
    v_code varchar2(20);
    v_code_to_update varchar2(20) := '';
    v_alt_codes varchar2(4000) := '';
    v_alt_count integer;
    v_group varchar2(4000);
    v_group_pre varchar2(4000) := ' ';
    cursor cur_group is
      select * from ndc_group2 order by groupname,id;
  begin
    for rec_group in cur_group loop
      v_code := rec_group.name;
      v_group := rec_group.groupname;
      if (upper(v_group) <> upper(v_group_pre)) then
        insert into NDC_UPDATE2 values (v_code_to_update, v_alt_codes);
        v_alt_count := 0;
        v_alt_codes := '';
        v_code_to_update := v_code;
        v_group_pre := v_group;
      else
        v_alt_count := v_alt_count + 1;
        if (v_alt_count = 1) then
          v_alt_codes := v_code;
        elsif (v_alt_count <= 10) then
          v_alt_codes := v_alt_codes || ',' || v_code;
        end if;
        insert into NDC_DELETE2 values (v_code);
      end if;
      
      IF mod(rec_group.id, 1000) = 0 THEN
        -- Commit every 1000 records
        COMMIT;
      END IF;
      
    end loop;
    commit;
  EXCEPTION
  WHEN OTHERS THEN
    --dbms_output.put_line(iString);
    raise;
  end NDC_GROUPING2;
  
  -- Copy a revision to a new revision
  PROCEDURE COPY_REVISION (p_revision_from varchar2, p_revision_to varchar2) AS
    max_hid integer;
	root_hid integer;
    rev_exist varchar2(1) := 'N';
    conflict_revision EXCEPTION;
  Begin
    -- get max id number
    select max(id) into max_hid from medicalhierarchy;
	select id into root_hid from medicalhierarchy where revision=p_revision_from and name='Root';
	
    Begin
      -- check if p_revision_to already exists
      select 'Y' into rev_exist from medicalhierarchy where name='Root' and revision=p_revision_to;
      dbms_output.put_line('Revision '||p_revision_to||' exists!');
      raise conflict_revision;
    Exception
    WHEN NO_DATA_FOUND THEN
      -- p_revision_to not exist
      rev_exist := 'N';
    WHEN conflict_revision THEN
      raise conflict_revision;
    End;
    
    execute immediate 'truncate table medicalhierarchy_staging';
    insert into medicalhierarchy_staging select * from medicalhierarchy where revision=p_revision_from;
    commit;
    update medicalhierarchy_staging set id=id-root_hid+max_hid+10000, parentid=parentid-root_hid+max_hid+10000, revision=p_revision_to;
    commit;
    insert into medicalhierarchy select * from medicalhierarchy_staging;
    commit;
    dbms_output.put_line('Revision copied.');
  End COPY_REVISION;
  
  -- Copy a revision to a new revision
  PROCEDURE COPY_EXCLUSION (p_clientid_from number, p_clientid_to number, p_revision_from varchar2, p_revision_to varchar2) AS
    rev_exist varchar2(1) := 'N';
    conflict_revision EXCEPTION;
  Begin
    Begin
      -- check if p_revision_to already exists
      select 'Y' into rev_exist from medicalhierarchy_exclusion where clientid=p_clientid_to and revision=p_revision_to;
      dbms_output.put_line('Client ID '||p_clientid_to||' Revision '||p_revision_to||' exists!');
      raise conflict_revision;
    Exception
    WHEN NO_DATA_FOUND THEN
      -- p_revision_to not exist
      rev_exist := 'N';
    WHEN conflict_revision THEN
      raise conflict_revision;
    End;
    
    insert into medicalhierarchy_exclusion (clientid,revision,codename,codetype,scale) 
      select p_clientid_to,p_revision_to,codename,codetype,scale from medicalhierarchy_exclusion 
      where clientid=p_clientid_from and revision=p_revision_from;
    commit;
    dbms_output.put_line('Exclusion list copied.');
  End COPY_EXCLUSION;
  
  -- p_simulate is true if not updating database
  PROCEDURE APPEND_EXCLUSION (p_clientid number, p_revision varchar2, p_simulate boolean default true, p_verbose boolean default true) As
    counter_added integer := 0;
    counter_exist integer := 0;
    counter_updated integer := 0;
    counter_deleted integer := 0;
    
    cursor c_stage is
      select p_clientid clientid, p_revision revision, s.codevalue, s.codetype, s.scale scale_s, e.scale scale_e
        from stage_codes s, medicalhierarchy_exclusion e where e.clientid(+) = p_clientid and s.codevalue = e.codename(+) and s.codetype = e.codetype(+);
  Begin
    for r_stage in c_stage loop
      if (r_stage.scale_s = 0 and r_stage.scale_e is null) then
      -- code not in exclusion table for the client, code needs to be excluded
        insert into MEDICALHIERARCHY_EXCLUSION (clientid, revision, codename, codetype, scale)
          values (r_stage.clientid, r_stage.revision, r_stage.codevalue, r_stage.codetype, r_stage.scale_s);
        if p_verbose = true then
          dbms_output.put_line('New excluded code '||r_stage.codevalue||' inserted for revision '||p_revision||' for client '||p_clientid||'.');
        end if;
        counter_added := counter_added + 1;
      elsif (r_stage.scale_s > 0 and r_stage.scale_e is null) then
      -- code not in exclusion table for the client, but needs to be non-excluded (no need to add to list for default client 0)
        if (p_clientid != 0) then
          insert into MEDICALHIERARCHY_EXCLUSION (clientid, revision, codename, codetype, scale)
            values (r_stage.clientid, r_stage.revision, r_stage.codevalue, r_stage.codetype, r_stage.scale_s);
          if p_verbose = true then
            dbms_output.put_line('New non-excluded code '||r_stage.codevalue||' inserted for revision '||p_revision||' for client '||p_clientid||'.');
          end if;
          counter_added := counter_added + 1;
        else
          if p_verbose = true then
            dbms_output.put_line('New non-excluded code '||r_stage.codevalue||' skipped for revision '||p_revision||' for default client '||p_clientid||'.');
          end if;
        end if;
      elsif (r_stage.scale_s = 0 and r_stage.scale_e = 0) then
      -- code already excluded for the client, no change needed
        if p_verbose = true then
            dbms_output.put_line('Existing excluded code '||r_stage.codevalue||' for revision '||p_revision||' for client '||p_clientid||'.');
        end if;
        counter_exist := counter_exist + 1;
      elsif (r_stage.scale_s = 0 and r_stage.scale_e > 0) then
        -- code not excluded for the client, but needs to be excluded
        update MEDICALHIERARCHY_EXCLUSION set scale=r_stage.scale_s
          where clientid=p_clientid and revision=p_revision and codename=r_stage.codevalue and codetype=r_stage.codetype;
        if p_verbose = true then
            dbms_output.put_line('Existing non-excluded code '||r_stage.codevalue||' is excluded for revision '||p_revision||' for client '||p_clientid||'.');
        end if;
        counter_updated := counter_updated + 1;
      elsif (r_stage.scale_s > 0 and r_stage.scale_e = 0) then
      -- code excluded for the client, but needs to be non-excluded
        if (p_clientid != 0) then
          -- for regular clients, keep code in table as non-excluded
          update MEDICALHIERARCHY_EXCLUSION set scale=r_stage.scale_s
            where clientid=p_clientid and revision=p_revision and codename=r_stage.codevalue and codetype=r_stage.codetype;
          if p_verbose = true then
              dbms_output.put_line('Existing excluded code '||r_stage.codevalue||' is non-excluded for revision '||p_revision||' for client '||p_clientid||'.');
          end if;
          counter_updated := counter_updated + 1;
        else
          -- for default client, remove the code from table
          delete from MEDICALHIERARCHY_EXCLUSION
            where clientid=p_clientid and revision=p_revision and codename=r_stage.codevalue and codetype=r_stage.codetype;
          if p_verbose = true then
              dbms_output.put_line('Existing excluded code '||r_stage.codevalue||' removed for revision '||p_revision||' for default client '||p_clientid||'.');
          end if;
          counter_deleted := counter_deleted + 1;
        end if;
      elsif (r_stage.scale_s > 0 and r_stage.scale_e = r_stage.scale_s) then
      -- code already non-excluded for the client, no change to scale, no change needed
        if p_verbose = true then
            dbms_output.put_line('Existing non-excluded code '||r_stage.codevalue||' for revision '||p_revision||' for client '||p_clientid||'.');
        end if;
        counter_exist := counter_exist + 1;
      elsif (r_stage.scale_s > 0 and r_stage.scale_e > 0) then
        -- code already non-excluded for the client, scale changed
        update MEDICALHIERARCHY_EXCLUSION set scale=r_stage.scale_s
          where clientid=p_clientid and revision=p_revision and codename=r_stage.codevalue and codetype=r_stage.codetype;
        if p_verbose = true then
            dbms_output.put_line('Existing non-excluded code '||r_stage.codevalue||' with scale change for revision '||p_revision||' for client '||p_clientid||'.');
        end if;
        counter_updated := counter_updated + 1;
      end if;
    end loop;
    
    dbms_output.put_line('Added '||counter_added);
    dbms_output.put_line('Updated '||counter_updated);
    dbms_output.put_line('Exist '||counter_exist);
    dbms_output.put_line('Deleted '||counter_deleted);
    
    if p_simulate=false then
      COMMIT;
    else
      dbms_output.put_line('*** Simulate only. No change was made in hierarchy. ***');
      rollback;
    end if;   
    
  End APPEND_EXCLUSION;
  
  -- p_simulate is true if not updating database
  PROCEDURE APPEND_CRITICAL (p_clientid number, p_clientname varchar2, p_simulate boolean default true, p_verbose boolean default true) As
    counter_added integer := 0;
    counter_updated integer := 0;
    counter_deleted integer := 0;
    
    v_scale integer;
    
    cursor c_stage23 is
      select p_clientid clientid, p_clientname clientname, '2012' version,
             codevalue, description, codetype, scale
        from stage_codes where scale > 1;
    cursor c_stage01 is
      select p_clientid clientid, p_clientname clientname, '2012' version,
             codevalue, description, codetype, scale
        from stage_codes where scale <= 1;
  Begin
    --if scale is 2 or 3, add to list
    for r_stage in c_stage23 loop
      Begin
        --check if the code exist in the list and get its scale value
        select scale into v_scale from criticalicdlist
          where clientid = r_stage.clientid 
          and clientname = r_stage.clientname 
          and version = r_stage.version 
          and code_alias = r_stage.codevalue 
          and code_type = r_stage.codetype;
        
        --update it if scale changes
        if v_scale <> r_stage.scale then
          update criticalicdlist set scale=r_stage.scale
            where clientid = r_stage.clientid 
            and clientname = r_stage.clientname 
            and version = r_stage.version 
            and code_alias = r_stage.codevalue 
            and code_type = r_stage.codetype;
          counter_updated := counter_updated + 1;
          if p_verbose = true then
            dbms_output.put_line('Code '||r_stage.codevalue||' updated to '||r_stage.scale||'.');
          end if;
        end if;
      Exception
      WHEN NO_DATA_FOUND THEN
        insert into criticalicdlist (CLIENTNAME, CODE_TYPE, VERSION, CODE_ALIAS, DESCRIPTION, SCALE, CLIENTID)
          values (r_stage.CLIENTNAME, r_stage.CODETYPE, r_stage.VERSION, r_stage.CODEValue, r_stage.DESCRIPTION, r_stage.SCALE, r_stage.CLIENTID);
        counter_added := counter_added + 1;
        if p_verbose = true then
          dbms_output.put_line('Code '||r_stage.codevalue||' inserted as '||r_stage.scale||'.');
        end if;
      WHEN OTHERS THEN
        rollback;
        dbms_output.put_line(r_stage.codevalue||' '||SQLCODE||' '||SQLERRM); 
      End;
    end loop;
 
    --if scale is lowered from 2-3 to 0-1, need to remove from critical list
    for r_stage in c_stage01 loop
      Begin
        --check if the code exist in the list and get its scale value
        select scale into v_scale from criticalicdlist
          where clientid = r_stage.clientid 
          and clientname = r_stage.clientname 
          and version = r_stage.version 
          and code_alias = r_stage.codevalue 
          and code_type = r_stage.codetype;
        
        --delete if scale was 2 or 3
        if v_scale > 1 then
          delete from criticalicdlist
            where clientid = r_stage.clientid 
            and clientname = r_stage.clientname 
            and version = r_stage.version 
            and code_alias = r_stage.codevalue 
            and code_type = r_stage.codetype;
          counter_deleted := counter_deleted + 1;
          if p_verbose = true then
            dbms_output.put_line('Code '||r_stage.codevalue||' deleted from critical list.');
          end if;
        end if;
      Exception
      WHEN NO_DATA_FOUND THEN
        null;
      WHEN OTHERS THEN
        rollback;
        dbms_output.put_line(r_stage.codevalue||' '||SQLCODE||' '||SQLERRM); 
      End;
    end loop;
 
    dbms_output.put_line('Added '||counter_added);
    dbms_output.put_line('Updated '||counter_updated);
    dbms_output.put_line('Deleted '||counter_deleted);
    
    if p_simulate=false then
      COMMIT;
    else
      dbms_output.put_line('*** Simulate only. No change was made in hierarchy. ***');
      rollback;
    end if;   
  End APPEND_CRITICAL;
  
  -- This is a new version of hierarchy loading procedure. APPEND_MEDICAL_HIERARCHY is the older version.
  -- append into medicalhierarchy table from STAGE_SPINE table
  -- all codes are SYN type
  -- p_simulate is true if not updating database
  -- p_verbose is true will show dbms output for every code processed
  PROCEDURE APPEND_SPINE (p_revision varchar2, p_simulate boolean default true, p_verbose boolean default true) AS
    cat1name varchar2(100);
    cat2name varchar2(100);
    cat3name varchar2(100);
    cat4name varchar2(100);
    hid integer;
    rootid integer;
    cat1id integer;
    cat2id integer;
    cat3id integer;
    cat4id integer;
    v_parentid integer;
    v_parentid_old integer;
    v_codeid integer;

	VALUE1LABEL integer :=0;
	VALUE1_UNITS integer :=0;
	VALUE2LABEL integer :=0;
	VALUE2_UNITS integer :=0;
	VALUE3LABEL integer :=0;
	VALUE3_UNITS integer :=0;
	VALUE4LABEL integer :=0;
	VALUE4_UNITS integer :=0;
	VALUE5LABEL integer :=0;
	VALUE5_UNITS integer :=0;
	VALUE6LABEL integer :=0;
	VALUE6_UNITS integer :=0;
	VALUE7LABEL integer :=0;
	VALUE7_UNITS integer :=0;
	VALUE8LABEL integer :=0;
	VALUE8_UNITS integer :=0;
	VALUE9LABEL integer :=0;
	VALUE9_UNITS integer :=0;
	TEXT1LABEL integer :=0;
	TEXT2LABEL integer :=0;
	TEXT3LABEL integer :=0;
	TEXT4LABEL integer :=0;
	LIST1LABEL integer :=0;
	LIST2LABEL integer :=0;
	LIST3LABEL integer :=0;
	LIST4LABEL integer :=0;
	LIST5LABEL integer :=0;
	LIST6LABEL integer :=0;
	LIST7LABEL integer :=0;
	LIST8LABEL integer :=0;
	LIST9LABEL integer :=0;
	COMBO1LABEL integer :=0;
	COMBO2LABEL integer :=0;
	COMBO3LABEL integer :=0;
	DATE1 integer :=0;
	DATE2 integer :=0;
	DATE3 integer :=0;
	DATE4 integer :=0;
	DATE5 integer :=0;
	DATE6 integer :=0;

    iString varchar2(8000);
    v_path varchar2(500);
    v_depth integer := 0;
    v_pointer integer;
    v_new_code_count integer := 0;
    v_update_code_count integer := 0;
    v_new_cat_count integer := 0;
    too_many_fields EXCEPTION;
    
    CURSOR cat1
    IS
      SELECT DISTINCT category1 catname FROM STAGE_SPINE ORDER BY 1;
  
    CURSOR cat2(cat1 VARCHAR2)
    IS
      SELECT DISTINCT category2 catname    FROM STAGE_SPINE
      WHERE category2 IS NOT NULL    AND category1    =cat1
      ORDER BY 1;
  
    CURSOR cat3(cat1 VARCHAR2, cat2 VARCHAR2)
    IS
      SELECT DISTINCT category3 catname    FROM STAGE_SPINE
      WHERE category3 IS NOT NULL    AND category1    =cat1    AND category2    =cat2
      ORDER BY 1;
  
    CURSOR cat4(cat1 VARCHAR2, cat2 VARCHAR2, cat3 VARCHAR2)
    IS
      SELECT DISTINCT category4 catname    FROM STAGE_SPINE
      WHERE category4 IS NOT NULL    AND category1    =cat1    AND category2    =cat2    AND category3    =cat3
      ORDER BY 1;
      
    CURSOR codes IS
      SELECT * FROM STAGE_SPINE ORDER BY category1,category2,category3,category4,SynId;
  BEGIN
    if p_simulate=true then
      dbms_output.put_line('*** Simulate only. No change will be made in hierarchy. ***');
    end if;
    
    --get next ID number
    select max(id)+1 into hid from medicalhierarchy;
    
    --insert Root node if not exist
    BEGIN
      select id into rootid from medicalhierarchy where name='Root' and revision=p_revision;
    Exception
    when no_data_found then
      insert into medicalhierarchy (id,name,parentid,billable,revision) values (hid,'Root',null,'N',p_revision);
      rootid := hid;
      hid := hid + 1;
      v_new_cat_count := v_new_cat_count + 1;
    end;
    
    --level 1
    for rec1 in cat1 loop
      cat1name := rec1.catname;
      Begin
        select id into cat1id from medicalhierarchy where name=cat1name and parentid=rootid and revision=p_revision;
      Exception
      when no_data_found then
        insert into medicalhierarchy (id,name,parentid,billable,revision) values (hid,cat1name,rootid,'N',p_revision);
        cat1id := hid;
        hid := hid + 1;
        v_new_cat_count := v_new_cat_count + 1;
        dbms_output.put_line('New category 1: '||cat1name);
      end;
      --level 2
      for rec2 in cat2(cat1name) loop
        cat2name := rec2.catname;
        Begin
          select id into cat2id from medicalhierarchy where name=cat2name and parentid=cat1id and revision=p_revision;
        Exception
        when no_data_found then
          insert into medicalhierarchy (id,name,parentid,billable,revision) values (hid,cat2name,cat1id,'N',p_revision);
          cat2id := hid;
          hid := hid + 1;
          v_new_cat_count := v_new_cat_count + 1;
          dbms_output.put_line('New category 2: '||cat2name);
        end;
        --level 3
        for rec3 in cat3(cat1name,cat2name) loop
          cat3name := rec3.catname;
          Begin
            select id into cat3id from medicalhierarchy where name=cat3name and parentid=cat2id and revision=p_revision;
          Exception
          when no_data_found then
            insert into medicalhierarchy (id,name,parentid,billable,revision) values (hid,cat3name,cat2id,'N',p_revision);
            cat3id := hid;
            hid := hid + 1;
            v_new_cat_count := v_new_cat_count + 1;
            dbms_output.put_line('New category 3: '||cat3name);
          end;
          --level 4
          for rec4 in cat4(cat1name,cat2name,cat3name) loop
            cat4name := rec4.catname;
            Begin
              select id into cat4id from medicalhierarchy where name=cat4name and parentid=cat3id and revision=p_revision;
            Exception
            when no_data_found then
              insert into medicalhierarchy (id,name,parentid,billable,revision) values (hid,cat4name,cat3id,'N',p_revision);
              cat4id := hid;
              hid := hid + 1;
              v_new_cat_count := v_new_cat_count + 1;
              dbms_output.put_line('New category 4: '||cat4name);
            end;
          end loop;
        end loop;
      end loop;
    end loop;
    
    --codes
    for rec in codes loop
      cat1name := rec.category1;
      cat2name := rec.category2;
      cat3name := rec.category3;
      cat4name := rec.category4;
      --get parentid
      if (cat2name is null) then
        --dbms_output.put_line('cat1='||cat1name);
        --the code branch only has 2 levels
        --v_depth := 2;
        select id into v_parentid from medicalhierarchy where
          revision=p_revision and name=cat1name and parentid=
          (select id from medicalhierarchy where revision=p_revision and name='Root');
      elsif (cat3name is null) then
        --dbms_output.put_line('cat1='||cat1name);
        --dbms_output.put_line('cat2='||cat2name);
        select id into v_parentid from medicalhierarchy where
          revision=p_revision and name=cat2name and parentid=
          (select id from medicalhierarchy where revision=p_revision and name=cat1name and parentid=
          (select id from medicalhierarchy where revision=p_revision and name='Root')
          );
      elsif (cat4name is null) then
        --dbms_output.put_line('cat1='||cat1name);
        --dbms_output.put_line('cat2='||cat2name);
        --dbms_output.put_line('cat3='||cat3name);
        select id into v_parentid from medicalhierarchy where
          revision=p_revision and name=cat3name and parentid=
          (select id from medicalhierarchy where revision=p_revision and name=cat2name and parentid=
          (select id from medicalhierarchy where revision=p_revision and name=cat1name and parentid=
          (select id from medicalhierarchy where revision=p_revision and name='Root')
          ));
      else    
        --dbms_output.put_line('cat1='||cat1name);
        --dbms_output.put_line('cat2='||cat2name);
        --dbms_output.put_line('cat3='||cat3name);
        --dbms_output.put_line('cat4='||cat4name);
        select id into v_parentid from medicalhierarchy where
          revision=p_revision and name=cat4name and parentid=
          (select id from medicalhierarchy where revision=p_revision and name=cat3name and parentid=
          (select id from medicalhierarchy where revision=p_revision and name=cat2name and parentid=
          (select id from medicalhierarchy where revision=p_revision and name=cat1name and parentid=
          (select id from medicalhierarchy where revision=p_revision and name='Root')
          )));
      end if;
      
		VALUE1LABEL :=0;
		VALUE1_UNITS :=0;
		VALUE2LABEL :=0;
		VALUE2_UNITS :=0;
		VALUE3LABEL :=0;
		VALUE3_UNITS :=0;
		VALUE4LABEL :=0;
		VALUE4_UNITS :=0;
		VALUE5LABEL :=0;
		VALUE5_UNITS :=0;
		VALUE6LABEL :=0;
		VALUE6_UNITS :=0;
		VALUE7LABEL :=0;
		VALUE7_UNITS :=0;
		VALUE8LABEL :=0;
		VALUE8_UNITS :=0;
		VALUE9LABEL :=0;
		VALUE9_UNITS :=0;
		TEXT1LABEL :=0;
		TEXT2LABEL :=0;
		TEXT3LABEL :=0;
		TEXT4LABEL :=0;
		LIST1LABEL :=0;
		LIST2LABEL :=0;
		LIST3LABEL :=0;
		LIST4LABEL :=0;
		LIST5LABEL :=0;
		LIST6LABEL :=0;
		LIST7LABEL :=0;
		LIST8LABEL :=0;
		LIST9LABEL :=0;
		COMBO1LABEL :=0;
		COMBO2LABEL :=0;
		COMBO3LABEL :=0;
		DATE1 :=0;
		DATE2 :=0;
		DATE3 :=0;
		DATE4 :=0;
		DATE5 :=0;
		DATE6 :=0;
	
      Begin
        --check if code exists
        select id into v_codeid from medicalhierarchy where name=rec.SynId and revision=p_revision and codetype='SYN';
        
        --code exists, get original parent id
        select parentid into v_parentid_old from medicalhierarchy where id=v_codeid;
        
        if p_simulate=false then
          update medicalhierarchy set description=null,billable=null,commonname=null,GREENFLAG=null,YELLOWFLAG=null,REDFLAG=null,Depth=null,
            DATAFIELD1=null,DATAFIELD1TYPE=null,DATAFIELD1REF=null,DATAFIELD2=null,DATAFIELD2TYPE=null,DATAFIELD2REF=null,
            DATAFIELD3=null,DATAFIELD3TYPE=null,DATAFIELD3REF=null,DATAFIELD4=null,DATAFIELD4TYPE=null,DATAFIELD4REF=null,
            DATAFIELD5=null,DATAFIELD5TYPE=null,DATAFIELD5REF=null,DATAFIELD6=null,DATAFIELD6TYPE=null,DATAFIELD6REF=null,
            DATAFIELD7=null,DATAFIELD7TYPE=null,DATAFIELD7REF=null,DATAFIELD8=null,DATAFIELD8TYPE=null,DATAFIELD8REF=null,
            DATAFIELD9=null,DATAFIELD9TYPE=null,DATAFIELD9REF=null,DATAFIELD10=null,DATAFIELD10TYPE=null,DATAFIELD10REF=null,
            DATAFIELD11=null,DATAFIELD11TYPE=null,DATAFIELD11REF=null,DATAFIELD12=null,DATAFIELD12TYPE=null,DATAFIELD12REF=null,
            DATAFIELD13=null,DATAFIELD13TYPE=null,DATAFIELD13REF=null,DATAFIELD14=null,DATAFIELD14TYPE=null,DATAFIELD14REF=null, --IWN-1037 Add 8 more data fields to HIERARCHY_UTILS
            DATAFIELD15=null,DATAFIELD15TYPE=null,DATAFIELD15REF=null,DATAFIELD16=null,DATAFIELD16TYPE=null,DATAFIELD16REF=null,
            DATAFIELD17=null,DATAFIELD17TYPE=null,DATAFIELD17REF=null,DATAFIELD18=null,DATAFIELD18TYPE=null,DATAFIELD18REF=null,
            DATAFIELD19=null,DATAFIELD19TYPE=null,DATAFIELD19REF=null,DATAFIELD20=null,DATAFIELD20TYPE=null,DATAFIELD20REF=null,
            DATAFIELD21=null,DATAFIELD21TYPE=null,DATAFIELD21REF=null,DATAFIELD22=null,DATAFIELD22TYPE=null,DATAFIELD22REF=null, --IWN-1178 Add 12 more data fields to related database tables and views
            DATAFIELD23=null,DATAFIELD23TYPE=null,DATAFIELD23REF=null,DATAFIELD24=null,DATAFIELD24TYPE=null,DATAFIELD24REF=null,
            DATAFIELD25=null,DATAFIELD25TYPE=null,DATAFIELD25REF=null,DATAFIELD26=null,DATAFIELD26TYPE=null,DATAFIELD26REF=null,
            DATAFIELD27=null,DATAFIELD27TYPE=null,DATAFIELD27REF=null,DATAFIELD28=null,DATAFIELD28TYPE=null,DATAFIELD28REF=null,
            DATAFIELD29=null,DATAFIELD29TYPE=null,DATAFIELD29REF=null,DATAFIELD30=null,DATAFIELD30TYPE=null,DATAFIELD30REF=null,
            DATAFIELD31=null,DATAFIELD31TYPE=null,DATAFIELD31REF=null,DATAFIELD32=null,DATAFIELD32TYPE=null,DATAFIELD32REF=null
            where id=v_codeid;
        end if;
        
        iString := 'update medicalhierarchy set ';
        
        if (v_depth = 2) then
          --the code branch only has 2 levels
          iString := iString ||'depth=' || v_depth || ' ';
        else
          iString := iString ||'depth=null ';
        end if;
        
        if (v_parentid_old = v_parentid) then
          if p_verbose = true then
            dbms_output.put_line('Code '||cat1name||'/'||cat2name||'/'||cat3name||'/'||cat4name||'/'||rec.SynId||' exists. Updating.');
          end if;
        else
          --category path changed
          select path into v_path from medicalhierarchy_leaf_level_v where hid=v_codeid;
          if p_verbose = true then
            dbms_output.put_line('Code '||rec.SynId||' exists. Moving from '|| v_path ||' to '||cat1name||'/'||cat2name||'/'||cat3name||'/'||cat4name||' and Updating.');
          end if;
          iString := iString ||', parentid=' || v_parentid || ' ';
        end if;
        
        iString := iString || ', description='''||replace(rec.SYNID_DESCRIPTION,'''','''''')||''', commonname='''||replace(rec.SHORTNAME,'''','''''')
                           ||''',GREENFLAG='''||replace(rec.HELP,'''','''''')||'''';
 
        v_pointer := 1;
        
        if (rec.VALUE1LABEL is not null) then
          VALUE1LABEL:=1;
          iString := iString || ', DATAFIELD'||v_pointer||'=''' || Remove_SynId_Prefix(rec.VALUE1LABEL) || ''', DATAFIELD'||v_pointer||'TYPE=''Number'', DATAFIELD'||v_pointer||'REF=null';
          v_pointer := v_pointer + 1;
        end if;
        if (rec.VALUE1_UNITS is not null) then
          VALUE1_UNITS:=1;
          iString := iString || ', DATAFIELD'||v_pointer||'=''' || Remove_SynId_Prefix(rec.VALUE1LABEL)||'_Units' || ''', DATAFIELD'||v_pointer||'TYPE=''LOVS'', DATAFIELD'||v_pointer||'REF=' || rec.VALUE1_UNITS;
          v_pointer := v_pointer + 1;
        end if;
        if (rec.VALUE2LABEL is not null) then
          VALUE2LABEL:=1;
          iString := iString || ', DATAFIELD'||v_pointer||'=''' || Remove_SynId_Prefix(rec.VALUE2LABEL) || ''', DATAFIELD'||v_pointer||'TYPE=''Number'', DATAFIELD'||v_pointer||'REF=null';
          v_pointer := v_pointer + 1;
        end if;
        if (rec.VALUE2_UNITS is not null) then
          VALUE2_UNITS:=1;
          iString := iString || ', DATAFIELD'||v_pointer||'=''' || Remove_SynId_Prefix(rec.VALUE2LABEL)||'_Units' || ''', DATAFIELD'||v_pointer||'TYPE=''LOVS'', DATAFIELD'||v_pointer||'REF=' || rec.VALUE2_UNITS;
          v_pointer := v_pointer + 1;
        end if;
        if (rec.VALUE3LABEL is not null) then
          VALUE3LABEL:=1;
          iString := iString || ', DATAFIELD'||v_pointer||'=''' || Remove_SynId_Prefix(rec.VALUE3LABEL) || ''', DATAFIELD'||v_pointer||'TYPE=''Number'', DATAFIELD'||v_pointer||'REF=null';
          v_pointer := v_pointer + 1;
        end if;
        if (rec.VALUE3_UNITS is not null) then
          VALUE3_UNITS:=1;
          iString := iString || ', DATAFIELD'||v_pointer||'=''' || Remove_SynId_Prefix(rec.VALUE3LABEL)||'_Units' || ''', DATAFIELD'||v_pointer||'TYPE=''LOVS'', DATAFIELD'||v_pointer||'REF=' || rec.VALUE3_UNITS;
          v_pointer := v_pointer + 1;
        end if;
        if (rec.VALUE4LABEL is not null) then
          VALUE4LABEL:=1;
          iString := iString || ', DATAFIELD'||v_pointer||'=''' || Remove_SynId_Prefix(rec.VALUE4LABEL) || ''', DATAFIELD'||v_pointer||'TYPE=''Number'', DATAFIELD'||v_pointer||'REF=null';
          v_pointer := v_pointer + 1;
        end if;
        if (rec.VALUE4_UNITS is not null) then
          VALUE4_UNITS:=1;
          iString := iString || ', DATAFIELD'||v_pointer||'=''' || Remove_SynId_Prefix(rec.VALUE4LABEL)||'_Units' || ''', DATAFIELD'||v_pointer||'TYPE=''LOVS'', DATAFIELD'||v_pointer||'REF=' || rec.VALUE4_UNITS;
          v_pointer := v_pointer + 1;
        end if;
        if (rec.VALUE5LABEL is not null) then
          VALUE5LABEL:=1;
          iString := iString || ', DATAFIELD'||v_pointer||'=''' || Remove_SynId_Prefix(rec.VALUE5LABEL) || ''', DATAFIELD'||v_pointer||'TYPE=''Number'', DATAFIELD'||v_pointer||'REF=null';
          v_pointer := v_pointer + 1;
        end if;
        if (rec.VALUE5_UNITS is not null) then
          VALUE5_UNITS:=1;
          iString := iString || ', DATAFIELD'||v_pointer||'=''' || Remove_SynId_Prefix(rec.VALUE5LABEL)||'_Units' || ''', DATAFIELD'||v_pointer||'TYPE=''LOVS'', DATAFIELD'||v_pointer||'REF=' || rec.VALUE5_UNITS;
          v_pointer := v_pointer + 1;
        end if;
        if (rec.VALUE6LABEL is not null) then
          VALUE6LABEL:=1;
          iString := iString || ', DATAFIELD'||v_pointer||'=''' || Remove_SynId_Prefix(rec.VALUE6LABEL) || ''', DATAFIELD'||v_pointer||'TYPE=''Number'', DATAFIELD'||v_pointer||'REF=null';
          v_pointer := v_pointer + 1;
        end if;
        if (rec.VALUE6_UNITS is not null) then
          VALUE6_UNITS:=1;
          iString := iString || ', DATAFIELD'||v_pointer||'=''' || Remove_SynId_Prefix(rec.VALUE6LABEL)||'_Units' || ''', DATAFIELD'||v_pointer||'TYPE=''LOVS'', DATAFIELD'||v_pointer||'REF=' || rec.VALUE6_UNITS;
          v_pointer := v_pointer + 1;
        end if;
        if (rec.VALUE7LABEL is not null) then
          VALUE7LABEL:=1;
          iString := iString || ', DATAFIELD'||v_pointer||'=''' || Remove_SynId_Prefix(rec.VALUE7LABEL) || ''', DATAFIELD'||v_pointer||'TYPE=''Number'', DATAFIELD'||v_pointer||'REF=null';
          v_pointer := v_pointer + 1;
        end if;
        if (rec.VALUE7_UNITS is not null) then
          VALUE7_UNITS:=1;
          iString := iString || ', DATAFIELD'||v_pointer||'=''' || Remove_SynId_Prefix(rec.VALUE7LABEL)||'_Units' || ''', DATAFIELD'||v_pointer||'TYPE=''LOVS'', DATAFIELD'||v_pointer||'REF=' || rec.VALUE7_UNITS;
          v_pointer := v_pointer + 1;
        end if;
        if (rec.VALUE8LABEL is not null) then
          VALUE8LABEL:=1;
          iString := iString || ', DATAFIELD'||v_pointer||'=''' || Remove_SynId_Prefix(rec.VALUE8LABEL) || ''', DATAFIELD'||v_pointer||'TYPE=''Number'', DATAFIELD'||v_pointer||'REF=null';
          v_pointer := v_pointer + 1;
        end if;
        if (rec.VALUE8_UNITS is not null) then
          VALUE8_UNITS:=1;
          iString := iString || ', DATAFIELD'||v_pointer||'=''' || Remove_SynId_Prefix(rec.VALUE8LABEL)||'_Units' || ''', DATAFIELD'||v_pointer||'TYPE=''LOVS'', DATAFIELD'||v_pointer||'REF=' || rec.VALUE8_UNITS;
          v_pointer := v_pointer + 1;
        end if;
        if (rec.VALUE9LABEL is not null) then
          VALUE9LABEL:=1;
          iString := iString || ', DATAFIELD'||v_pointer||'=''' || Remove_SynId_Prefix(rec.VALUE9LABEL) || ''', DATAFIELD'||v_pointer||'TYPE=''Number'', DATAFIELD'||v_pointer||'REF=null';
          v_pointer := v_pointer + 1;
        end if;
        if (rec.VALUE9_UNITS is not null) then
          VALUE9_UNITS:=1;
          iString := iString || ', DATAFIELD'||v_pointer||'=''' || Remove_SynId_Prefix(rec.VALUE9LABEL)||'_Units' || ''', DATAFIELD'||v_pointer||'TYPE=''LOVS'', DATAFIELD'||v_pointer||'REF=' || rec.VALUE9_UNITS;
          v_pointer := v_pointer + 1;
        end if;

        if (rec.TEXT1LABEL is not null) then
          TEXT1LABEL:=1;
          iString := iString || ', DATAFIELD'||v_pointer||'=''' || Remove_SynId_Prefix(rec.TEXT1LABEL) || ''', DATAFIELD'||v_pointer||'TYPE=''Text'', DATAFIELD'||v_pointer||'REF=null';
          v_pointer := v_pointer + 1;
        end if;
        if (rec.TEXT2LABEL is not null) then
          TEXT2LABEL:=1;
          iString := iString || ', DATAFIELD'||v_pointer||'=''' || Remove_SynId_Prefix(rec.TEXT2LABEL) || ''', DATAFIELD'||v_pointer||'TYPE=''Text'', DATAFIELD'||v_pointer||'REF=null';
          v_pointer := v_pointer + 1;
        end if;
        if (rec.TEXT3LABEL is not null) then
          TEXT3LABEL:=1;
          iString := iString || ', DATAFIELD'||v_pointer||'=''' || Remove_SynId_Prefix(rec.TEXT3LABEL) || ''', DATAFIELD'||v_pointer||'TYPE=''Text'', DATAFIELD'||v_pointer||'REF=null';
          v_pointer := v_pointer + 1;
        end if;
        if (rec.TEXT4LABEL is not null) then
          TEXT4LABEL:=1;
          iString := iString || ', DATAFIELD'||v_pointer||'=''' || Remove_SynId_Prefix(rec.TEXT4LABEL) || ''', DATAFIELD'||v_pointer||'TYPE=''Text'', DATAFIELD'||v_pointer||'REF=null';
          v_pointer := v_pointer + 1;
        end if;

        if (rec.LIST1LABEL is not null and rec.LIST1VALUES is not null) then
          LIST1LABEL:=1;
          iString := iString || ', DATAFIELD'||v_pointer||'=''' || Remove_SynId_Prefix(rec.LIST1LABEL) || ''', DATAFIELD'||v_pointer||'TYPE=''LOVS'', DATAFIELD'||v_pointer||'REF=' || rec.LIST1VALUES;
          v_pointer := v_pointer + 1;
        end if;
        if (rec.LIST2LABEL is not null and rec.LIST2VALUES is not null) then
          LIST2LABEL:=1;
          iString := iString || ', DATAFIELD'||v_pointer||'=''' || Remove_SynId_Prefix(rec.LIST2LABEL) || ''', DATAFIELD'||v_pointer||'TYPE=''LOVS'', DATAFIELD'||v_pointer||'REF=' || rec.LIST2VALUES;
          v_pointer := v_pointer + 1;
        end if;
        if (rec.LIST3LABEL is not null and rec.LIST3VALUES is not null) then
          LIST3LABEL:=1;
          iString := iString || ', DATAFIELD'||v_pointer||'=''' || Remove_SynId_Prefix(rec.LIST3LABEL) || ''', DATAFIELD'||v_pointer||'TYPE=''LOVS'', DATAFIELD'||v_pointer||'REF=' || rec.LIST3VALUES;
          v_pointer := v_pointer + 1;
        end if;
        if (rec.LIST4LABEL is not null and rec.LIST4VALUES is not null) then
          LIST4LABEL:=1;
          iString := iString || ', DATAFIELD'||v_pointer||'=''' || Remove_SynId_Prefix(rec.LIST4LABEL) || ''', DATAFIELD'||v_pointer||'TYPE=''LOVS'', DATAFIELD'||v_pointer||'REF=' || rec.LIST4VALUES;
          v_pointer := v_pointer + 1;
        end if;
        if (rec.LIST5LABEL is not null and rec.LIST5VALUES is not null) then
          LIST5LABEL:=1;
          iString := iString || ', DATAFIELD'||v_pointer||'=''' || Remove_SynId_Prefix(rec.LIST5LABEL) || ''', DATAFIELD'||v_pointer||'TYPE=''LOVS'', DATAFIELD'||v_pointer||'REF=' || rec.LIST5VALUES;
          v_pointer := v_pointer + 1;
        end if;
        if (rec.LIST6LABEL is not null and rec.LIST6VALUES is not null) then
          LIST6LABEL:=1;
          iString := iString || ', DATAFIELD'||v_pointer||'=''' || Remove_SynId_Prefix(rec.LIST6LABEL) || ''', DATAFIELD'||v_pointer||'TYPE=''LOVS'', DATAFIELD'||v_pointer||'REF=' || rec.LIST6VALUES;
          v_pointer := v_pointer + 1;
        end if;
        if (rec.LIST7LABEL is not null and rec.LIST7VALUES is not null) then
          LIST7LABEL:=1;
          iString := iString || ', DATAFIELD'||v_pointer||'=''' || Remove_SynId_Prefix(rec.LIST7LABEL) || ''', DATAFIELD'||v_pointer||'TYPE=''LOVS'', DATAFIELD'||v_pointer||'REF=' || rec.LIST7VALUES;
          v_pointer := v_pointer + 1;
        end if;
        if (rec.LIST8LABEL is not null and rec.LIST8VALUES is not null) then
          LIST8LABEL:=1;
          iString := iString || ', DATAFIELD'||v_pointer||'=''' || Remove_SynId_Prefix(rec.LIST8LABEL) || ''', DATAFIELD'||v_pointer||'TYPE=''LOVS'', DATAFIELD'||v_pointer||'REF=' || rec.LIST8VALUES;
          v_pointer := v_pointer + 1;
        end if;
        if (rec.LIST9LABEL is not null and rec.LIST9VALUES is not null) then
          LIST9LABEL:=1;
          iString := iString || ', DATAFIELD'||v_pointer||'=''' || Remove_SynId_Prefix(rec.LIST9LABEL) || ''', DATAFIELD'||v_pointer||'TYPE=''LOVS'', DATAFIELD'||v_pointer||'REF=' || rec.LIST9VALUES;
          v_pointer := v_pointer + 1;
        end if;

        --Combo boxes?
        if (rec.COMBO1LABEL is not null and rec.COMBO1VALUES is not null) then
          COMBO1LABEL:=1;
          iString := iString || ', DATAFIELD'||v_pointer||'=''' || Remove_SynId_Prefix(rec.COMBO1LABEL) || ''', DATAFIELD'||v_pointer||'TYPE=''Combo'', DATAFIELD'||v_pointer||'REF=' || rec.COMBO1VALUES;
          v_pointer := v_pointer + 1;
        end if;
        if (rec.COMBO2LABEL is not null and rec.COMBO2VALUES is not null) then
          COMBO2LABEL:=1;
          iString := iString || ', DATAFIELD'||v_pointer||'=''' || Remove_SynId_Prefix(rec.COMBO2LABEL) || ''', DATAFIELD'||v_pointer||'TYPE=''Combo'', DATAFIELD'||v_pointer||'REF=' || rec.COMBO2VALUES;
          v_pointer := v_pointer + 1;
        end if;
        if (rec.COMBO3LABEL is not null and rec.COMBO3VALUES is not null) then
          COMBO3LABEL:=1;
          iString := iString || ', DATAFIELD'||v_pointer||'=''' || Remove_SynId_Prefix(rec.COMBO3LABEL) || ''', DATAFIELD'||v_pointer||'TYPE=''Combo'', DATAFIELD'||v_pointer||'REF=' || rec.COMBO3VALUES;
          v_pointer := v_pointer + 1;
        end if;
        
        if (rec.DATE1 is not null) then
          DATE1:=1;
          iString := iString || ', DATAFIELD'||v_pointer||'=''' || Remove_SynId_Prefix(rec.DATE1) || ''', DATAFIELD'||v_pointer||'TYPE=''Date'', DATAFIELD'||v_pointer||'REF=null';
          v_pointer := v_pointer + 1;
        end if;
        if (rec.DATE2 is not null) then
          DATE2:=1;
          iString := iString || ', DATAFIELD'||v_pointer||'=''' || Remove_SynId_Prefix(rec.DATE2) || ''', DATAFIELD'||v_pointer||'TYPE=''Date'', DATAFIELD'||v_pointer||'REF=null';
          v_pointer := v_pointer + 1;
        end if;
        if (rec.DATE3 is not null) then
          DATE3:=1;
          iString := iString || ', DATAFIELD'||v_pointer||'=''' || Remove_SynId_Prefix(rec.DATE3) || ''', DATAFIELD'||v_pointer||'TYPE=''Date'', DATAFIELD'||v_pointer||'REF=null';
          v_pointer := v_pointer + 1;
        end if;
        if (rec.DATE4 is not null) then
          DATE4:=1;
          iString := iString || ', DATAFIELD'||v_pointer||'=''' || Remove_SynId_Prefix(rec.DATE4) || ''', DATAFIELD'||v_pointer||'TYPE=''Date'', DATAFIELD'||v_pointer||'REF=null';
          v_pointer := v_pointer + 1;
        end if;
        if (rec.DATE5 is not null) then
          DATE5:=1;
          iString := iString || ', DATAFIELD'||v_pointer||'=''' || Remove_SynId_Prefix(rec.DATE5) || ''', DATAFIELD'||v_pointer||'TYPE=''Date'', DATAFIELD'||v_pointer||'REF=null';
          v_pointer := v_pointer + 1;
        end if;
        if (rec.DATE6 is not null) then
          DATE6:=1;
          iString := iString || ', DATAFIELD'||v_pointer||'=''' || Remove_SynId_Prefix(rec.DATE6) || ''', DATAFIELD'||v_pointer||'TYPE=''Date'', DATAFIELD'||v_pointer||'REF=null';
          v_pointer := v_pointer + 1;
        end if;

        iString := iString || ' where id='|| v_codeid;
        
		--IWN-1037 Add 8 more data fields to HIERARCHY_UTILS
		--IWN-1178 Add 12 more data fields to related database tables and views
        if v_pointer > 33 then
          raise too_many_fields;
        end if;
        
        if p_simulate=false then
          execute immediate iString;
        end if;
        v_update_code_count := v_update_code_count + 1;
      Exception
      WHEN too_many_fields THEN
        raise too_many_fields;
      when no_data_found then
        --new code
        if p_verbose = true then
          dbms_output.put_line('New Code '||cat1name||'/'||cat2name||'/'||cat3name||'/'||cat4name||'/'||rec.SynId||'. Inserting.');
        end if;
		--IWN-1037 Add 8 more data fields to HIERARCHY_UTILS
        iString := 'insert into medicalhierarchy (id,name,codetype,description,parentid,commonname,revision,GREENFLAG,Depth,
          DATAFIELD1,DATAFIELD1TYPE,DATAFIELD1REF,DATAFIELD2,DATAFIELD2TYPE,DATAFIELD2REF,DATAFIELD3,DATAFIELD3TYPE,DATAFIELD3REF,DATAFIELD4,DATAFIELD4TYPE,DATAFIELD4REF,
          DATAFIELD5,DATAFIELD5TYPE,DATAFIELD5REF,DATAFIELD6,DATAFIELD6TYPE,DATAFIELD6REF,DATAFIELD7,DATAFIELD7TYPE,DATAFIELD7REF,DATAFIELD8,DATAFIELD8TYPE,DATAFIELD8REF,
          DATAFIELD9,DATAFIELD9TYPE,DATAFIELD9REF,DATAFIELD10,DATAFIELD10TYPE,DATAFIELD10REF,DATAFIELD11,DATAFIELD11TYPE,DATAFIELD11REF,DATAFIELD12,DATAFIELD12TYPE,DATAFIELD12REF,
		  DATAFIELD13,DATAFIELD13TYPE,DATAFIELD13REF,DATAFIELD14,DATAFIELD14TYPE,DATAFIELD14REF,DATAFIELD15,DATAFIELD15TYPE,DATAFIELD15REF,DATAFIELD16,DATAFIELD16TYPE,DATAFIELD16REF, 
		  DATAFIELD17,DATAFIELD17TYPE,DATAFIELD17REF,DATAFIELD18,DATAFIELD18TYPE,DATAFIELD18REF,DATAFIELD19,DATAFIELD19TYPE,DATAFIELD19REF,DATAFIELD20,DATAFIELD20TYPE,DATAFIELD20REF,
		  DATAFIELD21,DATAFIELD21TYPE,DATAFIELD21REF,DATAFIELD22,DATAFIELD22TYPE,DATAFIELD22REF,DATAFIELD23,DATAFIELD23TYPE,DATAFIELD23REF,DATAFIELD24,DATAFIELD24TYPE,DATAFIELD24REF,
		  DATAFIELD25,DATAFIELD25TYPE,DATAFIELD25REF,DATAFIELD26,DATAFIELD26TYPE,DATAFIELD26REF,DATAFIELD27,DATAFIELD27TYPE,DATAFIELD27REF,DATAFIELD28,DATAFIELD28TYPE,DATAFIELD28REF,
		  DATAFIELD29,DATAFIELD29TYPE,DATAFIELD29REF,DATAFIELD30,DATAFIELD30TYPE,DATAFIELD30REF,DATAFIELD31,DATAFIELD31TYPE,DATAFIELD31REF,DATAFIELD32,DATAFIELD32TYPE,DATAFIELD32REF)
          values ('||hid||', '''||rec.SynId||''', '''||'SYN'||''', '''||replace(rec.SYNID_DESCRIPTION,'''','''''')||''','||v_parentid||','''||replace(rec.SHORTNAME,'''','''''')||''','''
          ||p_revision||''','''||replace(rec.HELP,'''','''''')||'''';
        
        if (v_depth = 2) then
          --the code branch only has 2 levels
          iString := iString ||',' || v_depth;
        else
          iString := iString ||',null';
        end if;
        
        if (rec.VALUE1LABEL is not null) then
          VALUE1LABEL:=1;
          iString := iString || ',''' || Remove_SynId_Prefix(rec.VALUE1LABEL) || ''',''Number'',null';
        end if;
        if (rec.VALUE1_UNITS is not null) then
          VALUE1_UNITS:=1;
          iString := iString || ',''' || Remove_SynId_Prefix(rec.VALUE1LABEL)||'_Units' || ''',''LOVS'','||rec.VALUE1_UNITS;
        end if;
        if (rec.VALUE2LABEL is not null) then
          VALUE2LABEL:=1;
          iString := iString || ',''' || Remove_SynId_Prefix(rec.VALUE2LABEL) || ''',''Number'',null';
        end if;
        if (rec.VALUE2_UNITS is not null) then
          VALUE2_UNITS:=1;
          iString := iString || ',''' || Remove_SynId_Prefix(rec.VALUE2LABEL)||'_Units' || ''',''LOVS'','||rec.VALUE2_UNITS;
        end if;
        if (rec.VALUE3LABEL is not null) then
          VALUE3LABEL:=1;
          iString := iString || ',''' || Remove_SynId_Prefix(rec.VALUE3LABEL) || ''',''Number'',null';
        end if;
        if (rec.VALUE3_UNITS is not null) then
          VALUE3_UNITS:=1;
          iString := iString || ',''' || Remove_SynId_Prefix(rec.VALUE3LABEL)||'_Units' || ''',''LOVS'','||rec.VALUE3_UNITS;
        end if;
        if (rec.VALUE4LABEL is not null) then
          VALUE4LABEL:=1;
          iString := iString || ',''' || Remove_SynId_Prefix(rec.VALUE4LABEL) || ''',''Number'',null';
        end if;
        if (rec.VALUE4_UNITS is not null) then
          VALUE4_UNITS:=1;
          iString := iString || ',''' || Remove_SynId_Prefix(rec.VALUE4LABEL)||'_Units' || ''',''LOVS'','||rec.VALUE4_UNITS;
        end if;
        if (rec.VALUE5LABEL is not null) then
          VALUE5LABEL:=1;
          iString := iString || ',''' || Remove_SynId_Prefix(rec.VALUE5LABEL) || ''',''Number'',null';
        end if;
        if (rec.VALUE5_UNITS is not null) then
          VALUE5_UNITS:=1;
          iString := iString || ',''' || Remove_SynId_Prefix(rec.VALUE5LABEL)||'_Units' || ''',''LOVS'','||rec.VALUE5_UNITS;
        end if;
        if (rec.VALUE6LABEL is not null) then
          VALUE6LABEL:=1;
          iString := iString || ',''' || Remove_SynId_Prefix(rec.VALUE6LABEL) || ''',''Number'',null';
        end if;
        if (rec.VALUE6_UNITS is not null) then
          VALUE6_UNITS:=1;
          iString := iString || ',''' || Remove_SynId_Prefix(rec.VALUE6LABEL)||'_Units' || ''',''LOVS'','||rec.VALUE6_UNITS;
        end if;
        if (rec.VALUE7LABEL is not null) then
          VALUE7LABEL:=1;
          iString := iString || ',''' || Remove_SynId_Prefix(rec.VALUE7LABEL) || ''',''Number'',null';
        end if;
        if (rec.VALUE7_UNITS is not null) then
          VALUE7_UNITS:=1;
          iString := iString || ',''' || Remove_SynId_Prefix(rec.VALUE7LABEL)||'_Units' || ''',''LOVS'','||rec.VALUE7_UNITS;
        end if;
        if (rec.VALUE8LABEL is not null) then
          VALUE8LABEL:=1;
          iString := iString || ',''' || Remove_SynId_Prefix(rec.VALUE8LABEL) || ''',''Number'',null';
        end if;
        if (rec.VALUE8_UNITS is not null) then
          VALUE8_UNITS:=1;
          iString := iString || ',''' || Remove_SynId_Prefix(rec.VALUE8LABEL)||'_Units' || ''',''LOVS'','||rec.VALUE8_UNITS;
        end if;
        if (rec.VALUE9LABEL is not null) then
          VALUE9LABEL:=1;
          iString := iString || ',''' || Remove_SynId_Prefix(rec.VALUE9LABEL) || ''',''Number'',null';
        end if;
        if (rec.VALUE9_UNITS is not null) then
          VALUE9_UNITS:=1;
          iString := iString || ',''' || Remove_SynId_Prefix(rec.VALUE9LABEL)||'_Units' || ''',''LOVS'','||rec.VALUE9_UNITS;
        end if;

        if (rec.TEXT1LABEL is not null) then
          TEXT1LABEL:=1;
          iString := iString || ',''' || Remove_SynId_Prefix(rec.TEXT1LABEL) || ''',''Text'',null';
        end if;
        if (rec.TEXT2LABEL is not null) then
          TEXT2LABEL:=1;
          iString := iString || ',''' || Remove_SynId_Prefix(rec.TEXT2LABEL) || ''',''Text'',null';
        end if;
        if (rec.TEXT3LABEL is not null) then
          TEXT3LABEL:=1;
          iString := iString || ',''' || Remove_SynId_Prefix(rec.TEXT3LABEL) || ''',''Text'',null';
        end if;
        if (rec.TEXT4LABEL is not null) then
          TEXT4LABEL:=1;
          iString := iString || ',''' || Remove_SynId_Prefix(rec.TEXT4LABEL) || ''',''Text'',null';
        end if;

        if (rec.LIST1LABEL is not null and rec.LIST1VALUES is not null) then
          LIST1LABEL:=1;
          iString := iString || ',''' || Remove_SynId_Prefix(rec.LIST1LABEL) || ''',''LOVS'','||rec.LIST1VALUES;
        end if;
        if (rec.LIST2LABEL is not null and rec.LIST2VALUES is not null) then
          LIST2LABEL:=1;
          iString := iString || ',''' || Remove_SynId_Prefix(rec.LIST2LABEL) || ''',''LOVS'','||rec.LIST2VALUES;
        end if;
        if (rec.LIST3LABEL is not null and rec.LIST3VALUES is not null) then
          LIST3LABEL:=1;
          iString := iString || ',''' || Remove_SynId_Prefix(rec.LIST3LABEL) || ''',''LOVS'','||rec.LIST3VALUES;
        end if;
        if (rec.LIST4LABEL is not null and rec.LIST4VALUES is not null) then
          LIST4LABEL:=1;
          iString := iString || ',''' || Remove_SynId_Prefix(rec.LIST4LABEL) || ''',''LOVS'','||rec.LIST4VALUES;
        end if;
        if (rec.LIST5LABEL is not null and rec.LIST5VALUES is not null) then
          LIST5LABEL:=1;
          iString := iString || ',''' || Remove_SynId_Prefix(rec.LIST5LABEL) || ''',''LOVS'','||rec.LIST5VALUES;
        end if;
        if (rec.LIST6LABEL is not null and rec.LIST6VALUES is not null) then
          LIST6LABEL:=1;
          iString := iString || ',''' || Remove_SynId_Prefix(rec.LIST6LABEL) || ''',''LOVS'','||rec.LIST6VALUES;
        end if;
        if (rec.LIST7LABEL is not null and rec.LIST7VALUES is not null) then
          LIST7LABEL:=1;
          iString := iString || ',''' || Remove_SynId_Prefix(rec.LIST7LABEL) || ''',''LOVS'','||rec.LIST7VALUES;
        end if;
        if (rec.LIST8LABEL is not null and rec.LIST8VALUES is not null) then
          LIST8LABEL:=1;
          iString := iString || ',''' || Remove_SynId_Prefix(rec.LIST8LABEL) || ''',''LOVS'','||rec.LIST8VALUES;
        end if;
        if (rec.LIST9LABEL is not null and rec.LIST9VALUES is not null) then
          LIST9LABEL:=1;
          iString := iString || ',''' || Remove_SynId_Prefix(rec.LIST9LABEL) || ''',''LOVS'','||rec.LIST9VALUES;
        end if;
        
        --combo boxes?
        if (rec.COMBO1LABEL is not null and rec.COMBO1VALUES is not null) then
          COMBO1LABEL:=1;
          iString := iString || ',''' || Remove_SynId_Prefix(rec.COMBO1LABEL) || ''',''Combo'','||rec.COMBO1VALUES;
        end if;
        if (rec.COMBO2LABEL is not null and rec.COMBO2VALUES is not null) then
          COMBO2LABEL:=1;
          iString := iString || ',''' || Remove_SynId_Prefix(rec.COMBO2LABEL) || ''',''Combo'','||rec.COMBO2VALUES;
        end if;
        if (rec.COMBO3LABEL is not null and rec.COMBO3VALUES is not null) then
          COMBO3LABEL:=1;
          iString := iString || ',''' || Remove_SynId_Prefix(rec.COMBO3LABEL) || ''',''Combo'','||rec.COMBO3VALUES;
        end if;
       
        if (rec.DATE1 is not null) then
          DATE1:=1;
          iString := iString || ',''' || Remove_SynId_Prefix(rec.DATE1) || ''',''Date'',null';
        end if;
        if (rec.DATE2 is not null) then
          DATE2:=1;
          iString := iString || ',''' || Remove_SynId_Prefix(rec.DATE2) || ''',''Date'',null';
        end if;
        if (rec.DATE3 is not null) then
          DATE3:=1;
          iString := iString || ',''' || Remove_SynId_Prefix(rec.DATE3) || ''',''Date'',null';
        end if;
        if (rec.DATE4 is not null) then
          DATE4:=1;
          iString := iString || ',''' || Remove_SynId_Prefix(rec.DATE4) || ''',''Date'',null';
        end if;
        if (rec.DATE5 is not null) then
          DATE5:=1;
          iString := iString || ',''' || Remove_SynId_Prefix(rec.DATE5) || ''',''Date'',null';
        end if;
        if (rec.DATE6 is not null) then
          DATE6:=1;
          iString := iString || ',''' || Remove_SynId_Prefix(rec.DATE6) || ''',''Date'',null';
        end if;


        --insert code
        case (VALUE1LABEL +VALUE1_UNITS +VALUE2LABEL +VALUE2_UNITS +VALUE3LABEL +VALUE3_UNITS +VALUE4LABEL +VALUE4_UNITS +VALUE5LABEL +VALUE5_UNITS +VALUE6LABEL +VALUE6_UNITS +VALUE7LABEL +VALUE7_UNITS +VALUE8LABEL +VALUE8_UNITS +VALUE9LABEL +VALUE9_UNITS +TEXT1LABEL +TEXT2LABEL +TEXT3LABEL +TEXT4LABEL +LIST1LABEL +LIST2LABEL +LIST3LABEL +LIST4LABEL +LIST5LABEL +LIST6LABEL +LIST7LABEL +LIST8LABEL +LIST9LABEL +COMBO1LABEL +COMBO2LABEL +COMBO3LABEL +DATE1 +DATE2 +DATE3 +DATE4 +DATE5 +DATE6)
        when 0 then
          iString := iString || ',null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)';
        when 1 then
          iString := iString || ',null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)';
        when 2 then
          iString := iString || ',null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)';
        when 3 then
          iString := iString || ',null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)';
        when 4 then
          iString := iString || ',null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)';
        when 5 then
          iString := iString || ',null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)';
        when 6 then
          iString := iString || ',null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)';
        when 7 then
          iString := iString || ',null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)';
        when 8 then
          iString := iString || ',null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)';
        when 9 then
          iString := iString || ',null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)';
        when 10 then
          iString := iString || ',null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)';
        when 11 then
          iString := iString || ',null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)';
        when 12 then
          iString := iString || ',null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)';
        when 13 then
          iString := iString || ',null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)';
        when 14 then
          iString := iString || ',null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)';
        when 15 then
          iString := iString || ',null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)';
        when 16 then
          iString := iString || ',null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)';
        when 17 then
          iString := iString || ',null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)';
        when 18 then
          iString := iString || ',null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)';
        when 19 then
          iString := iString || ',null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)';
        when 20 then
          iString := iString || ',null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)';
        when 21 then
          iString := iString || ',null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)';
        when 22 then
          iString := iString || ',null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)';
        when 23 then
          iString := iString || ',null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)';
        when 24 then
          iString := iString || ',null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)';
        when 25 then
          iString := iString || ',null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)';
        when 26 then
          iString := iString || ',null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)';
        when 27 then
          iString := iString || ',null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)';
        when 28 then
          iString := iString || ',null,null,null,null,null,null,null,null,null,null,null,null)';
        when 29 then
          iString := iString || ',null,null,null,null,null,null,null,null,null)';
        when 30 then
          iString := iString || ',null,null,null,null,null,null)';
        when 31 then
          iString := iString || ',null,null,null)';
        when 32 then
          iString := iString || ')';
        else
          raise too_many_fields;
        end case;
        
        --dbms_output.put_line(iString);
        if p_simulate=false then
          execute immediate iString;
        end if;
        hid := hid + 1;
        v_new_code_count := v_new_code_count + 1;
      end;      
      
      IF mod(hid, 1000) = 0 THEN
        dbms_output.put_line(hid);
        -- Commit every 1000 records
        if p_simulate=false then
          COMMIT;
        END IF;
      end if;
    end loop;
    dbms_output.put_line('New codes added: '||v_new_code_count);
    dbms_output.put_line('Codes updated: '||v_update_code_count);
    dbms_output.put_line('New categories added: '||v_new_cat_count);
    
    if p_simulate=true then
      dbms_output.put_line('*** Simulate only. No change was made in hierarchy. ***');
      rollback;
    end if;
    
  EXCEPTION
  WHEN too_many_fields THEN
    ROLLBACK;
    dbms_output.put_line('Too many data fields!!!');
    dbms_output.put_line(iString);
    raise;  	
  WHEN OTHERS THEN
    ROLLBACK;
    dbms_output.put_line('New codes added: '||v_new_code_count);
    dbms_output.put_line('Codes updated: '||v_update_code_count);
    dbms_output.put_line('New categories added: '||v_new_cat_count);
    dbms_output.put_line(iString);
    raise;
  END APPEND_SPINE;

  -- This is a new version of hierarchy loading procedure.
  -- It only updates the core record, not altering any data fields.
  -- p_simulate is true if not updating database
  -- p_verbose is true will show dbms output for every code processed
  PROCEDURE APPEND_SPINE_CORE (p_revision varchar2, p_simulate boolean default true, p_verbose boolean default true) AS
    cat1name varchar2(100);
    cat2name varchar2(100);
    cat3name varchar2(100);
    cat4name varchar2(100);
    hid integer;
    rootid integer;
    cat1id integer;
    cat2id integer;
    cat3id integer;
    cat4id integer;
    v_parentid integer;
    v_parentid_old integer;
    v_codeid integer;

    iString varchar2(8000);
    v_path varchar2(500);
    v_depth integer := 0;
    v_pointer integer;
    v_new_code_count integer := 0;
    v_update_code_count integer := 0;
    v_new_cat_count integer := 0;
    
    CURSOR cat1
    IS
      SELECT DISTINCT category1 catname FROM STAGE_SPINE ORDER BY 1;
  
    CURSOR cat2(cat1 VARCHAR2)
    IS
      SELECT DISTINCT category2 catname    FROM STAGE_SPINE
      WHERE category2 IS NOT NULL    AND category1    =cat1
      ORDER BY 1;
  
    CURSOR cat3(cat1 VARCHAR2, cat2 VARCHAR2)
    IS
      SELECT DISTINCT category3 catname    FROM STAGE_SPINE
      WHERE category3 IS NOT NULL    AND category1    =cat1    AND category2    =cat2
      ORDER BY 1;
  
    CURSOR cat4(cat1 VARCHAR2, cat2 VARCHAR2, cat3 VARCHAR2)
    IS
      SELECT DISTINCT category4 catname    FROM STAGE_SPINE
      WHERE category4 IS NOT NULL    AND category1    =cat1    AND category2    =cat2    AND category3    =cat3
      ORDER BY 1;
      
    CURSOR codes IS
      SELECT * FROM STAGE_SPINE ORDER BY category1,category2,category3,category4,SynId;
  BEGIN
    if p_simulate=true then
      dbms_output.put_line('*** Simulate only. No change will be made in hierarchy. ***');
    end if;
    
    --get next ID number
    select max(id)+1 into hid from medicalhierarchy;
    
    --insert Root node if not exist
    BEGIN
      select id into rootid from medicalhierarchy where name='Root' and revision=p_revision;
    Exception
    when no_data_found then
      insert into medicalhierarchy (id,name,parentid,billable,revision) values (hid,'Root',null,'N',p_revision);
      rootid := hid;
      hid := hid + 1;
      v_new_cat_count := v_new_cat_count + 1;
    end;
    
    --level 1
    for rec1 in cat1 loop
      cat1name := rec1.catname;
      Begin
        select id into cat1id from medicalhierarchy where name=cat1name and parentid=rootid and revision=p_revision;
      Exception
      when no_data_found then
        insert into medicalhierarchy (id,name,parentid,billable,revision) values (hid,cat1name,rootid,'N',p_revision);
        cat1id := hid;
        hid := hid + 1;
        v_new_cat_count := v_new_cat_count + 1;
        dbms_output.put_line('New category 1: '||cat1name);
      end;
      --level 2
      for rec2 in cat2(cat1name) loop
        cat2name := rec2.catname;
        Begin
          select id into cat2id from medicalhierarchy where name=cat2name and parentid=cat1id and revision=p_revision;
        Exception
        when no_data_found then
          insert into medicalhierarchy (id,name,parentid,billable,revision) values (hid,cat2name,cat1id,'N',p_revision);
          cat2id := hid;
          hid := hid + 1;
          v_new_cat_count := v_new_cat_count + 1;
          dbms_output.put_line('New category 2: '||cat2name);
        end;
        --level 3
        for rec3 in cat3(cat1name,cat2name) loop
          cat3name := rec3.catname;
          Begin
            select id into cat3id from medicalhierarchy where name=cat3name and parentid=cat2id and revision=p_revision;
          Exception
          when no_data_found then
            insert into medicalhierarchy (id,name,parentid,billable,revision) values (hid,cat3name,cat2id,'N',p_revision);
            cat3id := hid;
            hid := hid + 1;
            v_new_cat_count := v_new_cat_count + 1;
            dbms_output.put_line('New category 3: '||cat3name);
          end;
          --level 4
          for rec4 in cat4(cat1name,cat2name,cat3name) loop
            cat4name := rec4.catname;
            Begin
              select id into cat4id from medicalhierarchy where name=cat4name and parentid=cat3id and revision=p_revision;
            Exception
            when no_data_found then
              insert into medicalhierarchy (id,name,parentid,billable,revision) values (hid,cat4name,cat3id,'N',p_revision);
              cat4id := hid;
              hid := hid + 1;
              v_new_cat_count := v_new_cat_count + 1;
              dbms_output.put_line('New category 4: '||cat4name);
            end;
          end loop;
        end loop;
      end loop;
    end loop;
    
    --codes
    for rec in codes loop
      cat1name := rec.category1;
      cat2name := rec.category2;
      cat3name := rec.category3;
      cat4name := rec.category4;
      --get parentid
      if (cat2name is null) then
        --dbms_output.put_line('cat1='||cat1name);
        select id into v_parentid from medicalhierarchy where
          revision=p_revision and name=cat1name and parentid=
          (select id from medicalhierarchy where revision=p_revision and name='Root');
      elsif (cat3name is null) then
        --dbms_output.put_line('cat1='||cat1name);
        --dbms_output.put_line('cat2='||cat2name);
        select id into v_parentid from medicalhierarchy where
          revision=p_revision and name=cat2name and parentid=
          (select id from medicalhierarchy where revision=p_revision and name=cat1name and parentid=
          (select id from medicalhierarchy where revision=p_revision and name='Root')
          );
      elsif (cat4name is null) then
        --dbms_output.put_line('cat1='||cat1name);
        --dbms_output.put_line('cat2='||cat2name);
        --dbms_output.put_line('cat3='||cat3name);
        select id into v_parentid from medicalhierarchy where
          revision=p_revision and name=cat3name and parentid=
          (select id from medicalhierarchy where revision=p_revision and name=cat2name and parentid=
          (select id from medicalhierarchy where revision=p_revision and name=cat1name and parentid=
          (select id from medicalhierarchy where revision=p_revision and name='Root')
          ));
      else    
        --dbms_output.put_line('cat1='||cat1name);
        --dbms_output.put_line('cat2='||cat2name);
        --dbms_output.put_line('cat3='||cat3name);
        --dbms_output.put_line('cat4='||cat4name);
        select id into v_parentid from medicalhierarchy where
          revision=p_revision and name=cat4name and parentid=
          (select id from medicalhierarchy where revision=p_revision and name=cat3name and parentid=
          (select id from medicalhierarchy where revision=p_revision and name=cat2name and parentid=
          (select id from medicalhierarchy where revision=p_revision and name=cat1name and parentid=
          (select id from medicalhierarchy where revision=p_revision and name='Root')
          )));
      end if;
      
      Begin
        --check if code exists
        select id into v_codeid from medicalhierarchy where name=rec.SynId and revision=p_revision and codetype='SYN';
        
        --code exists, get original parent id
        select parentid into v_parentid_old from medicalhierarchy where id=v_codeid;
        
        if p_simulate=false then
          update medicalhierarchy set description=null,billable=null,commonname=null,GREENFLAG=null,YELLOWFLAG=null,REDFLAG=null,Depth=null
            where id=v_codeid;
        end if;
        
        iString := 'update medicalhierarchy set ';
        
        iString := iString ||'depth=null ';
        
        if (v_parentid_old = v_parentid) then
          if p_verbose = true then
            dbms_output.put_line('Code '||cat1name||'/'||cat2name||'/'||cat3name||'/'||cat4name||'/'||rec.SynId||' exists. Updating.');
          end if;
        else
          --category path changed
          select path into v_path from medicalhierarchy_leaf_level_v where hid=v_codeid;
          if p_verbose = true then
            dbms_output.put_line('Code '||rec.SynId||' exists. Moving from '|| v_path ||' to '||cat1name||'/'||cat2name||'/'||cat3name||'/'||cat4name||' and Updating.');
          end if;
          iString := iString ||', parentid=' || v_parentid || ' ';
        end if;
        
        iString := iString || ', description='''||replace(rec.SYNID_DESCRIPTION,'''','''''')||''', commonname='''||replace(rec.SHORTNAME,'''','''''')
                           ||''',GREENFLAG='''||replace(rec.HELP,'''','''''')||'''';
 
        iString := iString || ' where id='|| v_codeid;
        
        if p_simulate=false then
          execute immediate iString;
        end if;
        v_update_code_count := v_update_code_count + 1;
      Exception
      when no_data_found then
        --new code
        if p_verbose = true then
          dbms_output.put_line('New Code '||cat1name||'/'||cat2name||'/'||cat3name||'/'||cat4name||'/'||rec.SynId||'. Inserting.');
        end if;
		--IWN-1037 Add 8 more data fields to HIERARCHY_UTILS
        iString := 'insert into medicalhierarchy (id,name,codetype,description,parentid,commonname,revision,GREENFLAG,Depth)
          values ('||hid||', '''||rec.SynId||''', '''||'SYN'||''', '''||replace(rec.SYNID_DESCRIPTION,'''','''''')||''','||v_parentid||','''||replace(rec.SHORTNAME,'''','''''')||''','''
          ||p_revision||''','''||replace(rec.HELP,'''','''''')||'''';
        
        iString := iString ||',null)';
        
        --dbms_output.put_line(iString);
        if p_simulate=false then
          execute immediate iString;
        end if;
        hid := hid + 1;
        v_new_code_count := v_new_code_count + 1;
      end;      
      
      IF mod(hid, 1000) = 0 THEN
        dbms_output.put_line(hid);
        -- Commit every 1000 records
        if p_simulate=false then
          COMMIT;
        END IF;
      end if;
    end loop;
    dbms_output.put_line('New codes added: '||v_new_code_count);
    dbms_output.put_line('Codes updated: '||v_update_code_count);
    dbms_output.put_line('New categories added: '||v_new_cat_count);
    
    if p_simulate=true then
      dbms_output.put_line('*** Simulate only. No change was made in hierarchy. ***');
      rollback;
    end if;
    
  EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    dbms_output.put_line('New codes added: '||v_new_code_count);
    dbms_output.put_line('Codes updated: '||v_update_code_count);
    dbms_output.put_line('New categories added: '||v_new_cat_count);
    dbms_output.put_line(iString);
    raise;
  END APPEND_SPINE_CORE;

  -- Remove prefix from field names
  -- for example, SUB2.BeginTreatmentDate => BeginTreatmentDate
  Function Remove_SynId_Prefix (p_fieldname varchar2) return varchar2
  As
  Begin
  	return substr(p_fieldname, instr(p_fieldname, '.') + 1,length(p_fieldname) - instr(p_fieldname, '.'));
  End Remove_SynId_Prefix;

  -- p_simulate is true if not updating database
  PROCEDURE APPEND_SPINE_EXCLUSION (p_clientid number, p_revision varchar2, p_simulate boolean default true, p_verbose boolean default true) As
    counter_added integer := 0;
    counter_exist integer := 0;
    counter_updated integer := 0;
    counter_deleted integer := 0;
    
    cursor c_stage is
      select p_clientid clientid, p_revision revision, s.SynId codevalue, 'SYN' codetype, case when s.automated='TRUE' then 0 else 1 end scale_s, e.scale scale_e
        from stage_spine s, medicalhierarchy_exclusion e where e.clientid(+) = p_clientid and s.SynId = e.codename(+) and 'SYN' = e.codetype(+);
  Begin
    for r_stage in c_stage loop
      if (r_stage.scale_s = 0 and r_stage.scale_e is null) then
      -- code not in exclusion table for the client, code needs to be excluded
        insert into MEDICALHIERARCHY_EXCLUSION (clientid, revision, codename, codetype, scale)
          values (r_stage.clientid, r_stage.revision, r_stage.codevalue, r_stage.codetype, r_stage.scale_s);
        if p_verbose = true then
          dbms_output.put_line('New excluded code '||r_stage.codevalue||' inserted for revision '||p_revision||' for client '||p_clientid||'.');
        end if;
        counter_added := counter_added + 1;
      elsif (r_stage.scale_s > 0 and r_stage.scale_e is null) then
      -- code not in exclusion table for the client, but needs to be non-excluded (no need to add to list for default client 0)
        if (p_clientid != 0) then
          insert into MEDICALHIERARCHY_EXCLUSION (clientid, revision, codename, codetype, scale)
            values (r_stage.clientid, r_stage.revision, r_stage.codevalue, r_stage.codetype, r_stage.scale_s);
          if p_verbose = true then
            dbms_output.put_line('New non-excluded code '||r_stage.codevalue||' inserted for revision '||p_revision||' for client '||p_clientid||'.');
          end if;
          counter_added := counter_added + 1;
        else
          if p_verbose = true then
            dbms_output.put_line('New non-excluded code '||r_stage.codevalue||' skipped for revision '||p_revision||' for default client '||p_clientid||'.');
          end if;
        end if;
      elsif (r_stage.scale_s = 0 and r_stage.scale_e = 0) then
      -- code already excluded for the client, no change needed
        if p_verbose = true then
            dbms_output.put_line('Existing excluded code '||r_stage.codevalue||' for revision '||p_revision||' for client '||p_clientid||'.');
        end if;
        counter_exist := counter_exist + 1;
      elsif (r_stage.scale_s = 0 and r_stage.scale_e > 0) then
        -- code not excluded for the client, but needs to be excluded
        update MEDICALHIERARCHY_EXCLUSION set scale=r_stage.scale_s
          where clientid=p_clientid and revision=p_revision and codename=r_stage.codevalue and codetype=r_stage.codetype;
        if p_verbose = true then
            dbms_output.put_line('Existing non-excluded code '||r_stage.codevalue||' is excluded for revision '||p_revision||' for client '||p_clientid||'.');
        end if;
        counter_updated := counter_updated + 1;
      elsif (r_stage.scale_s > 0 and r_stage.scale_e = 0) then
      -- code excluded for the client, but needs to be non-excluded
        if (p_clientid != 0) then
          -- for regular clients, keep code in table as non-excluded
          update MEDICALHIERARCHY_EXCLUSION set scale=r_stage.scale_s
            where clientid=p_clientid and revision=p_revision and codename=r_stage.codevalue and codetype=r_stage.codetype;
          if p_verbose = true then
              dbms_output.put_line('Existing excluded code '||r_stage.codevalue||' is non-excluded for revision '||p_revision||' for client '||p_clientid||'.');
          end if;
          counter_updated := counter_updated + 1;
        else
          -- for default client, remove the code from table
          delete from MEDICALHIERARCHY_EXCLUSION
            where clientid=p_clientid and revision=p_revision and codename=r_stage.codevalue and codetype=r_stage.codetype;
          if p_verbose = true then
              dbms_output.put_line('Existing excluded code '||r_stage.codevalue||' removed for revision '||p_revision||' for default client '||p_clientid||'.');
          end if;
          counter_deleted := counter_deleted + 1;
        end if;
      elsif (r_stage.scale_s > 0 and r_stage.scale_e = r_stage.scale_s) then
      -- code already non-excluded for the client, no change to scale, no change needed
        if p_verbose = true then
            dbms_output.put_line('Existing non-excluded code '||r_stage.codevalue||' for revision '||p_revision||' for client '||p_clientid||'.');
        end if;
        counter_exist := counter_exist + 1;
      elsif (r_stage.scale_s > 0 and r_stage.scale_e > 0) then
        -- code already non-excluded for the client, scale changed
        update MEDICALHIERARCHY_EXCLUSION set scale=r_stage.scale_s
          where clientid=p_clientid and revision=p_revision and codename=r_stage.codevalue and codetype=r_stage.codetype;
        if p_verbose = true then
            dbms_output.put_line('Existing non-excluded code '||r_stage.codevalue||' with scale change for revision '||p_revision||' for client '||p_clientid||'.');
        end if;
        counter_updated := counter_updated + 1;
      end if;
    end loop;
    
    dbms_output.put_line('Added '||counter_added);
    dbms_output.put_line('Updated '||counter_updated);
    dbms_output.put_line('Exist '||counter_exist);
    dbms_output.put_line('Deleted '||counter_deleted);
    
    if p_simulate=false then
      COMMIT;
    else
      dbms_output.put_line('*** Simulate only. No change was made in hierarchy. ***');
      rollback;
    end if;   
    
  End APPEND_SPINE_EXCLUSION;
 
 
--- For usage by QERMIT or stand-alone MetaRule validator.
--- Checks that requested combinations of SYNID, LABEL and VALUE is valid.
--- if not, generate error and provide helpful examples 
  FUNCTION VALIDATE_METARULE(
    p_spine IN VARCHAR2,
    p_SYNID IN VARCHAR2,
	p_label in varchar2,
	p_value in varchar2)
--- to Test
--- select HIERARCHY_UTILS.validate_metarule( '3.0.SCR.MUNICH','MAD','Adrenal_Part','Cortex') from dual; 
   
    
   RETURN VARCHAR2
    
        IS
    
	   v_spine varchar2(20);
       v_synid_Count number;
	   v_label_Count number;
	   v_DataField varchar2(200);
	   v_lovid number;
	   v_value_Count number;
	   v_sql varchar2(200);
	   v_Return varchar2(4000);
	   lf varchar2(5) default chr(10);
	   div varchar2(100);  
	   
  BEGIN
  	
	 DIV := LF || '-------------------------------------------------------------------' || LF;


    --- Use the most complete (longest) Spine revision that the SYNID can be found in
	 --- Check SYNID  
	   v_spine := P_SPINE||'%' ;
	   Select Count(*)  into v_synid_count 
	   From Medicalhierarchy
	   Where Revision like v_SPINE and name = P_SYNID;	

        IF   v_synid_count = 0 	 
		  then	 
	      --- try using only the prefix portion of spine to ensure compatible spines are used
	        v_spine := substr(P_SPINE,1,4)||'%' ;
	        --- Check SYNID  
	        Select Count(*)  into v_synid_count 
	        From Medicalhierarchy
	        Where Revision like v_SPINE and name = P_SYNID;
	   
	        -- If not in specific Spine, any spine
	        IF   v_synid_count = 0 
	          then
		        v_SPINE := '%';
	            Select Count(*)  into v_synid_count 
	            From Medicalhierarchy
       	        Where Revision like v_SPINE and name = P_SYNID;
		     END IF;
		END IF;	    
	   
     --- Check Label
        Select Count(*) into v_label_count
		From Medicalhierarchy_field_label_v
        Where Revision like v_SPINE
        And Name = P_SYNID
        And Datafield_Label=P_label; 

	  		   
      --- Check Value
	  
	  -- Get the DataFieldRef number (necessary to links to the LOV and LOVVALUES)
	   BEGIN
	    Select Datafield into v_DataField 
		From Medicalhierarchy_Field_Label_V 
		Where Revision like v_SPINE
           And Name = P_SYNID 
		   and datafield_label=P_LABEL;
		EXCEPTION
		  	when others then null;
		END; 		   


	  --- Get the LOV ID
	      v_sql := 'Select ' || v_DataField ||'REF From Medicalhierarchy 
		     Where Revision like ''' || v_SPINE || ''' And Name = ''' || P_SYNID ||'''';
		  
		   BEGIN 
            Execute Immediate V_Sql Into v_LOVID;
			-- v_return := v_sql;
		   EXCEPTION
		    	when others then v_LOVID := null;
		    END; 
		   

	   
	-- See if the DataFieldValue exists with the LOV Values
	    Select Count(*) into v_value_count 
	    From Lovvalues Where Lovid= v_LOVID
        and lovvalue = P_VALUE;

      --- Format Response
	 CASE
	   --- everything is correct	
	   WHEN v_synid_count>=1 and v_label_count>=1 and v_value_count>=1
	    THEN
		v_Return := v_Return || 'OK - ' || P_SYNID || ': "' || P_LABEL || '" =  "' || P_VALUE || '" is valid for spine like ' || v_SPINE; 
		
	   --- Synid and Label is good.  only the value is incorrect	
       WHEN v_synid_count>=1 and v_label_count>=1
	     THEN v_Return := v_Return || DIV || 'ERROR - "' || P_SYNID || '" : "' || P_LABEL || '" = "' || P_VALUE || '" is NOT valid.'; 
		 v_Return := v_Return || LF || '  Value of: "' || P_VALUE || '" is invalid for spine like ' || v_SPINE;

		 v_Return := v_return || LF || '  VALID "VALUE" CHOICES FOR "' || P_LABEL || '" ARE:';
		 FOR A IN 
		  (Select lovvalue from lovvalues where lovid=v_lovid) 
		   LOOP
             v_Return := v_return || lf || '   * ' || A.LOVVALUE;
           End LOOP;
	       v_Return := v_Return || LF;  -- Add LF to end;
	   
	   --- Only the Synid is good	
       WHEN v_synid_count>=1 
	    THEN
        v_Return := v_Return || DIV || 'ERROR - "' || P_SYNID || '" : "' || P_LABEL || '" = "' || P_VALUE || '" is NOT valid.';
		v_Return := v_Return || LF || '  Label of: "' || P_LABEL|| '" is invalid for spine like ' || v_SPINE;
		
	 	  --- display Valid Labels for this SYNID;
		  v_Return := v_return || lf || '  VALID "LABEL" CHOICES FOR "' || P_SYNID || '" ARE:';
		  FOR A IN 
		    (Select datafield_label 
			   From Medicalhierarchy_Field_Label_V 
			   Where Revision like v_SPINE
			   And Name = P_SYNID order by datafield_label)
     		LOOP
			  v_Return := v_return || lf || '   * ' || A.DATAFIELD_LABEL;
	    	END LOOP;	
            v_Return := v_Return || LF;  -- Add LF to end;

	   --- Not even the Synid is good	
       WHEN v_synid_count=0 
	    THEN
        v_Return := v_Return || DIV || 'ERROR - "' || P_SYNID || '": "' || P_LABEL || '" = "' || P_VALUE || '" is NOT valid.';
		v_Return := v_Return || lf || '  SYNID of: "' || P_SYNID || '" is invalid for SPINE types like: "' || v_SPINE ||'"';
		
      --- should not end up here, but just in case
       ELSE
 	v_Return := v_Return || DIV  || 'ERROR - "' || P_SYNID || '": "' || P_LABEL || '" = "' || P_VALUE || '" is NOT valid for spine like ' || v_SPINE; 
	
				  
      END CASE;	
	   
  
   return v_return;
       
  END VALIDATE_METARULE;	
   

 
--- For usage by QERMIT or stand-alone MetaRule validator.
--- Checks that requested combinations of CODETYPE and VALUE is valid.
--- If it is, returns the description
--- if not, return an error 
  FUNCTION VALIDATE_METACODE(
    p_CODETYPE IN VARCHAR2,
    p_CODEVALUE IN VARCHAR2)
--- to Test
--- select HIERARCHY_UTILS.validate_metacode( 'ICD9CMCODE','C74.92') from dual; 
   
    
   RETURN VARCHAR2
    
        IS
    
	   v_return varchar2(4000);
	   v_desc varchar2(4000);
	   v_sql varchar2(500);
	   v_codetype varchar2(20);
	   lf varchar2(5) default chr(10);

      BEGIN
            
     --- Convert MetaRules Type to match those in Master_codes
	 CASE
	 	WHEN P_CODETYPE = 'ICD10CMCode' then v_codetype := 'ICD-10-CM';
		WHEN P_CODETYPE = 'ICD9CMCode' then v_codetype := 'ICD-9-CM';
	    ELSE v_codetype := null;
	 END CASE;	

	 --- Build Query to check code description
	  	 v_sql := 
  	     'Select description 
	     From Mastercodes
         Where Code=''' || P_CODEVALUE || ''' And
             Code_Type=''' || v_CODETYPE || '''
             and rownum=1';

	   BEGIN
		 Execute Immediate V_Sql Into v_Desc;	 
	   EXCEPTION
	 	  	when others then v_desc := null;
	   END;
			  

      CASE 
	  	WHEN v_codetype = 'ICD-9-CM'
		    -- No ICD9 lookup.  Assume is always correct
		   then v_return := 'OK = Assume ICD9 value "' || P_CODEVALUE  || '" is correct'; 

		
	   	WHEN v_codetype is NULL
		   then v_return := LF || 'ERROR - "' || P_CODEVALUE || '". "' || P_codetype ||
			              '"  CodeType is not recognized. ' ;
		
		WHEN v_desc is NULL
		   then v_return := LF || 'ERROR - "' || P_CODEVALUE || '" (' || v_codetype ||
			              ')  is NOT valid. ' ;

        WHEN v_desc is NOT NULL
	       then v_return := 'OK - "' || P_CODEVALUE || '" (' || v_codetype ||
		                  ') ' ||  v_desc || '  is valid. ';

        --- Just in case
        ELSE v_return := LF || 'ERROR - Unexpected: "' || P_CODEVALUE || '" (' || v_codetype ||
			              ')  is NOT valid. ' ;


	  END CASE; 						 

     -- for debugging
	 --v_return := v_return || v_sql;  
  
   return v_return;
       
  END VALIDATE_METACODE;	
  
  PROCEDURE LOAD_CONTROL_LOVS AS
    v_lovlabel LOVS.lovlabel%TYPE;
    v_lovvalues varchar2(4000);
    v_lovid LOVS.lovid%TYPE;
    v_count integer;
    
    cursor c_lov is
      select distinct control_name from control_values where control_name is not null;
      
    cursor c_lovvalues (p_lov varchar2) is
      select control_value, VALUE_DES from control_values where upper(trim(control_name)) = upper(p_lov) order by valuesid;
      
  BEGIN
    for r_lov in c_lov loop
      v_lovlabel := trim(r_lov.control_name);
      
      Begin
        select lovid into v_lovid from LOVS where lovlabel=v_lovlabel;
        --existing LOV
		dbms_output.put_line('Updating: '||v_lovlabel);
        delete from lovvalues where lovid=v_lovid;
        commit;
        v_count := 10;
        for r_lovvalues in c_lovvalues(v_lovlabel) loop
          insert into lovvalues (lovid, lovvalue, sequence, notes) values (v_lovid, replace(replace(r_lovvalues.control_value,'[',''),']',''), v_count, r_lovvalues.VALUE_DES);
          v_count := v_count + 10;
        end loop;
        commit;
      exception
      when no_data_found then
        --new LOV
        dbms_output.put_line('Creating: '||v_lovlabel);
        select lovs_seq.nextval into v_lovid from dual;
        insert into lovs (lovid, lovlabel, sequence) values (v_lovid, v_lovlabel, 1);
        v_count := 10;
        for r_lovvalues in c_lovvalues(v_lovlabel) loop
          insert into lovvalues (lovid, lovvalue, sequence, notes) values (v_lovid, replace(replace(r_lovvalues.control_value,'[',''),']',''), v_count, r_lovvalues.VALUE_DES);
          v_count := v_count + 10;
        end loop;
        commit;
      end;
      
    end loop;
    
  END LOAD_CONTROL_LOVS;
  
  PROCEDURE APPEND_SPINE_CONTROLS (p_revision varchar2, p_simulate boolean default true, p_verbose boolean default true) AS
    v_codeid integer;

    iString varchar2(8000);
    v_lov integer := 0;
    v_pointer integer;
    v_update_code_count integer := 0;
    too_many_fields EXCEPTION;
    
    cursor c_synid is
      select distinct synid from control_to_synid where synid is not null order by synid;
      
    cursor c_controls (p_synid varchar2) is
      select s.synid, n.control_name, n.report_label, n.control_type, nvl(n.wf_order,s.wf_order) from 
      control_to_synid s, control_names n
      where s.synid is not null and upper(trim(s.control_name)) = upper(trim(n.control_name)) and trim(s.synid) = p_synid
      order by s.synid, n.wf_order, s.wf_order;
  BEGIN
    if p_simulate=true then
      dbms_output.put_line('*** Simulate only. No change will be made in hierarchy. ***');
    end if;
    
    --codes
    for rec in c_synid loop
      Begin
        --check if code exists
        select id into v_codeid from medicalhierarchy where name=trim(rec.SynId) and revision=p_revision and depth is null;
                
        if p_simulate=false then
          update medicalhierarchy set 
            DATAFIELD1=null,DATAFIELD1TYPE=null,DATAFIELD1REF=null,DATAFIELD2=null,DATAFIELD2TYPE=null,DATAFIELD2REF=null,
            DATAFIELD3=null,DATAFIELD3TYPE=null,DATAFIELD3REF=null,DATAFIELD4=null,DATAFIELD4TYPE=null,DATAFIELD4REF=null,
            DATAFIELD5=null,DATAFIELD5TYPE=null,DATAFIELD5REF=null,DATAFIELD6=null,DATAFIELD6TYPE=null,DATAFIELD6REF=null,
            DATAFIELD7=null,DATAFIELD7TYPE=null,DATAFIELD7REF=null,DATAFIELD8=null,DATAFIELD8TYPE=null,DATAFIELD8REF=null,
            DATAFIELD9=null,DATAFIELD9TYPE=null,DATAFIELD9REF=null,DATAFIELD10=null,DATAFIELD10TYPE=null,DATAFIELD10REF=null,
            DATAFIELD11=null,DATAFIELD11TYPE=null,DATAFIELD11REF=null,DATAFIELD12=null,DATAFIELD12TYPE=null,DATAFIELD12REF=null,
            DATAFIELD13=null,DATAFIELD13TYPE=null,DATAFIELD13REF=null,DATAFIELD14=null,DATAFIELD14TYPE=null,DATAFIELD14REF=null, --IWN-1037 Add 8 more data fields to HIERARCHY_UTILS
            DATAFIELD15=null,DATAFIELD15TYPE=null,DATAFIELD15REF=null,DATAFIELD16=null,DATAFIELD16TYPE=null,DATAFIELD16REF=null,
            DATAFIELD17=null,DATAFIELD17TYPE=null,DATAFIELD17REF=null,DATAFIELD18=null,DATAFIELD18TYPE=null,DATAFIELD18REF=null,
            DATAFIELD19=null,DATAFIELD19TYPE=null,DATAFIELD19REF=null,DATAFIELD20=null,DATAFIELD20TYPE=null,DATAFIELD20REF=null,
            DATAFIELD21=null,DATAFIELD21TYPE=null,DATAFIELD21REF=null,DATAFIELD22=null,DATAFIELD22TYPE=null,DATAFIELD22REF=null, --IWN-1178 Add 12 more data fields to related database tables and views
            DATAFIELD23=null,DATAFIELD23TYPE=null,DATAFIELD23REF=null,DATAFIELD24=null,DATAFIELD24TYPE=null,DATAFIELD24REF=null,
            DATAFIELD25=null,DATAFIELD25TYPE=null,DATAFIELD25REF=null,DATAFIELD26=null,DATAFIELD26TYPE=null,DATAFIELD26REF=null,
            DATAFIELD27=null,DATAFIELD27TYPE=null,DATAFIELD27REF=null,DATAFIELD28=null,DATAFIELD28TYPE=null,DATAFIELD28REF=null,
            DATAFIELD29=null,DATAFIELD29TYPE=null,DATAFIELD29REF=null,DATAFIELD30=null,DATAFIELD30TYPE=null,DATAFIELD30REF=null,
            DATAFIELD31=null,DATAFIELD31TYPE=null,DATAFIELD31REF=null,DATAFIELD32=null,DATAFIELD32TYPE=null,DATAFIELD32REF=null
            where id=v_codeid;
        end if;

        v_pointer := 1;
  	    iString := 'update medicalhierarchy set DISPLAYRANK=DISPLAYRANK ';
				
        --loop thru controls
		for r_control in c_controls(rec.SynId) loop
          begin
			  --IWN-1178 Add 12 more data fields to related database tables and views
			  if v_pointer = 33 then
				raise too_many_fields;
			  end if;
			
			  if (r_control.control_type = 'Numeric' or r_control.control_type = 'Value') then
				iString := iString || ', DATAFIELD'||v_pointer||'=''' || trim(r_control.report_label) || ''', DATAFIELD'||v_pointer||'TYPE=''Number'', DATAFIELD'||v_pointer||'REF=null';
				
			  elsif (r_control.control_type = 'Text') then
				iString := iString || ', DATAFIELD'||v_pointer||'=''' || trim(r_control.report_label) || ''', DATAFIELD'||v_pointer||'TYPE=''Text'', DATAFIELD'||v_pointer||'REF=null';
				
			  elsif (r_control.control_type = 'List' or r_control.control_type = 'List Units') then
				select lovid into v_lov from lovs where upper(lovlabel) = upper(trim(r_control.control_name));
				iString := iString || ', DATAFIELD'||v_pointer||'=''' || trim(r_control.report_label) || ''', DATAFIELD'||v_pointer||'TYPE=''LOVS'', DATAFIELD'||v_pointer||'REF=' || v_lov;
				
			  elsif (r_control.control_type = 'Combo') then
				select lovid into v_lov from lovs where upper(lovlabel) = upper(trim(r_control.control_name));
				iString := iString || ', DATAFIELD'||v_pointer||'=''' || trim(r_control.report_label) || ''', DATAFIELD'||v_pointer||'TYPE=''Combo'', DATAFIELD'||v_pointer||'REF=' || v_lov;
				
			  elsif (r_control.control_type = 'Date') then
				iString := iString || ', DATAFIELD'||v_pointer||'=''' || trim(r_control.report_label) || ''', DATAFIELD'||v_pointer||'TYPE=''Date'', DATAFIELD'||v_pointer||'REF=null';
				
			  end if;
	
			  v_pointer := v_pointer + 1;
	
		  Exception
		  when no_data_found then
			dbms_output.put_line('Control '||r_control.control_name||' not found for SynID '||rec.SynId);
		  end;      
	    end loop;
        iString := iString || ' where id='|| v_codeid;
		
	    if p_simulate=false then
		  execute immediate iString;
		  commit;
	    end if;

        v_update_code_count := v_update_code_count + 1;
      Exception
      WHEN too_many_fields THEN
        dbms_output.put_line('Too many data fields for SynID ' || rec.SynId);
      when no_data_found then
        dbms_output.put_line('SynID '||rec.SynId||' not found!');
      end;      
      
    end loop;

    dbms_output.put_line('Codes updated: '||v_update_code_count);
    if p_simulate=true then
      dbms_output.put_line('*** Simulate only. No change was made in hierarchy. ***');
      rollback;
    end if;
    
  EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    dbms_output.put_line('Codes updated: '||v_update_code_count);
    dbms_output.put_line(iString);
    raise;
  END APPEND_SPINE_CONTROLS;

END HIERARCHY_UTILS;
/