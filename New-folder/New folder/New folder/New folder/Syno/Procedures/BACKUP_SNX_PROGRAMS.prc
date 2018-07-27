--------------------------------------------------------
--  DDL for Procedure BACKUP_SNX_PROGRAMS
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "SNX_IWS2"."BACKUP_SNX_PROGRAMS" 
     --- Generate DDL SQL script that can be run on a blank Oracle schema
     --- and populate all the Programs and functions
     --- Created On:  10-3-2011 R Benzell
     --- Update History
          
         AS
     /*** to test
     begin
        BACKUP_SNX_PROGRAMS();
        --snx_apex_dev.BACKUP_SNX_PROGRAMS();
     end;
     ***/
       v_BackupSQL CLOB;
       v_text varchar2(32000);
       v_LF varchar2(2) default chr(13)||chr(10);
       v_MSG varchar2(32000);
       I number default 0;
  
       begin
   ---- Initialize DDL SQLPlus runtime environment commands
    v_BackupSQL := 'set define off'    || v_LF ||
             'set echo on'       || v_LF ||
             'spool SYS_MIG.lst';
  
 
     v_BackupSQL := v_BackupSQL ||v_LF ||
    ' ---------- functions --------' || v_LF;
    I := 0;
    for A in
      ( select OBJECT_NAME from user_objects where object_type = 'FUNCTION' order by OBJECT_NAME )
    loop
          I := I+1;
          v_text := dbms_metadata.GET_DDL('FUNCTION',A.object_name) ||v_LF ||'/'||v_LF||v_LF ;
          htp.p(v_text);
          v_BackupSQL := v_BackupSQL || v_text;
    end loop;
    v_MSG := v_MSG || to_char(I) || ' Function DDLs Processed.  '||v_LF||v_LF;
 
    v_BackupSQL := v_BackupSQL || v_LF ||
   ' --------- procedures ---------' || v_LF;
    I := 0;
    for A in
      ( select OBJECT_NAME from user_objects where object_type = 'PROCEDURE' order by OBJECT_NAME )
    loop
          I := I+1;
          v_text := dbms_metadata.GET_DDL('PROCEDURE',A.object_name) ||v_LF ||'/'||v_LF||v_LF ;
          htp.p(v_text);
          v_BackupSQL := v_BackupSQL || v_text;
    end loop;
    v_MSG := v_MSG || to_char(I) || ' Procedure DDLs Processed.  ' ||v_LF||v_LF;
 
htp.p('---------------------------------------------------------------');
     htp.p('message ' || length(v_MSG));
    htp.p('htp file size: ' || length(v_BackupSQL));
    dbms_output.put_line('dbms file size: ' || length(v_BackupSQL) );
    dbms_output.put_line(v_BackupSQL);
    htp.p(v_BackupSQL);
    
     
  --- Catch errors and show their line numbers
     EXCEPTION WHEN OTHERS THEN LOG_APEX_ERROR(0);
   END;

/

