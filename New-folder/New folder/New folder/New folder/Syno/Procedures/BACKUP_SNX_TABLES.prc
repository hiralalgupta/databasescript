--------------------------------------------------------
--  DDL for Procedure BACKUP_SNX_TABLES
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "SNX_IWS2"."BACKUP_SNX_TABLES" 
     --- Copy a Snodex Table into a backup table with a specified BK suffix
     --- Updated 6-26-2011 - Log progress and time into EMR_REPLICATE_LOG
         (
          P_BK     in varchar2 default '0'
          )
         AS
     /*** to test
     begin
      BACKUP_SNX_TABLES(1);
     end;
     ***/
      
       v_bk varchar2(5);
       v_Sql varchar2(2000);
       v_out varchar2(32000);
      v_DATE DATE;
      v_DATE_END DATE;
      v_started_on date;
      v_completed_on date;
      v_seconds number;
      V_MAINCOUNT number;
      V_COPYCOUNT number;
      ---v_rec_count number;
      v_table_name varchar2(35);
      v_message varchar2(250);
      v_error varchar2(4000);
  BEGIN 
      v_bk := P_BK;
   --- Find and Process Each Table
    for A in
      (
      SELECT
        table_name SNX_TableName,
        table_name || '_BK' || v_bk NEW_TABLENAME
        from user_tables
       where table_name not like 'APEX$%'
         and table_name not like '%_BK%'
       ORDER BY table_name
       )
    loop
      v_table_name := a.SNX_TABLENAME;
      htp.p(sysdate || ' creating ' || a.NEW_TABLENAME || '...');
  
      v_SQL := 'Create table ' || a.NEW_TABLENAME ||
            ' as select * from ' || a.SNX_TABLENAME;
      htp.p(v_SQL);
      --- Exception Stanza to cleanly handle situtions where remote table does not exist
        v_started_on := sysdate;
        v_CopyCount := 0;
        EXECUTE IMMEDIATE v_sql;
        EXECUTE IMMEDIATE 'select count(*) from ' || a.SNX_TABLENAME  into v_MainCount;
                                  
        EXECUTE IMMEDIATE 'select count(*) from ' || a.NEW_TABLENAME into v_CopyCount;
        v_completed_on := sysdate;
        v_seconds := (v_completed_on-v_started_on)*(1440*60);
        --select count(*) into v_CopyCount from a.NEW_TABLENAME;
        htp.p(v_MainCount || ' records in ' || a.SNX_TABLENAME);
        htp.p(v_CopyCount || ' records in ' || a.NEW_TABLENAME);
   
      htp.p('Copy Completed at: ' || sysdate );
      htp.p('=====================================================================');
      --- clear output for next table
      htp.p('------------------------------------------------------------------------------');
    end loop;
  --- Catch errors and show their line numbers
    EXCEPTION WHEN OTHERS THEN LOG_APEX_ERROR(16);
   END;

/

