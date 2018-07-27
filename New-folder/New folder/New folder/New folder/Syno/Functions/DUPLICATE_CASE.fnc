--------------------------------------------------------
--  DDL for Function DUPLICATE_CASE
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SNX_IWS2"."DUPLICATE_CASE" (
      old_CASEID IN NUMBER )
    RETURN NUMBER
  AS
    new_caseid    NUMBER;
    old_pageid    NUMBER;
    new_pageid    NUMBER;
    old_dpentryid NUMBER;
    new_dpentryid NUMBER;
    new_dpcid     NUMBER;
    CURSOR cur_case
    IS
      SELECT * FROM cases WHERE caseid=old_CASEID;
    CURSOR cur_page(p_caseid NUMBER)
    IS
      SELECT * FROM pages WHERE caseid=p_caseid;
    CURSOR cur_dpentry(p_pageid NUMBER)
    IS
      SELECT * FROM dpentries WHERE pageid=p_pageid;
    CURSOR cur_dpcode(p_dpentryid NUMBER)
    IS
      SELECT * FROM dpentrycodes WHERE dpentryid=p_dpentryid;
  BEGIN
    FOR rec_case IN cur_case
    LOOP
      SELECT cases_seq.nextval INTO new_caseid FROM dual;
      INSERT
      INTO cases
        (
          CASEID,
          CLIENTID,
          PRIORITY,
          RECEIPTTIMESTAMP,
          ORIGINALCONTENTID,
          PAPERSIZE,
          FILESIZE,
          APPLICANTNAME,
          APPLICANTPOSTALCODE,
          USERID,
          STAGEID,
          ASSIGNMENTTIMESTAMP,
          STAGESTARTTIMESTAMP,
          TOTALPAGES,
          TOTALDOCUMENTS,
          DELETEDPAGECOUNT,
          DATAPOINTCOUNT,
          IMAGEREJECTREASON,
          IMRSDELIVERYTIMESTAMP,
          IMRDDELIVERYTIMESTAMP,
          IMRSCONTENTID,
          SUBMISSIONTYPE,
          PRIORORIGINALCONTENTID,
          ISTEST,
          ISANONYMOUS,
          ISPURGED,
          VERSION,
          IMRSVERSION,
          STATUS,
          LANGUAGEID,
          CLIENTFILENAME,
          NOTES,
          CLIENTCASENUMBER,
          CREATED_TIMESTAMP,
          CREATED_USERID,
          CREATED_STAGEID,
          UPDATED_TIMESTAMP,
          UPDATED_USERID,
          UPDATED_STAGEID,
          DID,
          ASSIGNEDBY,
          ISINTERNALTEST,
          IMRDCONTENTID,
          DEBUG,
          LAST_BILLED_TIMESTAMP,
          CODE_TYPE,
          CODE_VERSION
        )
        VALUES
        (
          new_caseid,
          rec_case.CLIENTID,
          rec_case.PRIORITY,
          rec_case.RECEIPTTIMESTAMP,
          rec_case.ORIGINALCONTENTID,
          rec_case.PAPERSIZE,
          rec_case.FILESIZE,
          rec_case.APPLICANTNAME,
          rec_case.APPLICANTPOSTALCODE,
          rec_case.USERID,
          rec_case.STAGEID,
          rec_case.ASSIGNMENTTIMESTAMP,
          rec_case.STAGESTARTTIMESTAMP,
          rec_case.TOTALPAGES,
          rec_case.TOTALDOCUMENTS,
          rec_case.DELETEDPAGECOUNT,
          rec_case.DATAPOINTCOUNT,
          rec_case.IMAGEREJECTREASON,
          rec_case.IMRSDELIVERYTIMESTAMP,
          rec_case.IMRDDELIVERYTIMESTAMP,
          rec_case.IMRSCONTENTID,
          rec_case.SUBMISSIONTYPE,
          rec_case.PRIORORIGINALCONTENTID,
          rec_case.ISTEST,
          rec_case.ISANONYMOUS,
          rec_case.ISPURGED,
          rec_case.VERSION,
          rec_case.IMRSVERSION,
          rec_case.STATUS,
          rec_case.LANGUAGEID,
          rec_case.CLIENTFILENAME,
          rec_case.NOTES,
          rec_case.CLIENTCASENUMBER,
          rec_case.CREATED_TIMESTAMP,
          rec_case.CREATED_USERID,
          rec_case.CREATED_STAGEID,
          rec_case.UPDATED_TIMESTAMP,
          rec_case.UPDATED_USERID,
          rec_case.UPDATED_STAGEID,
          rec_case.DID,
          rec_case.ASSIGNEDBY,
          rec_case.ISINTERNALTEST,
          rec_case.IMRDCONTENTID,
          rec_case.DEBUG,
          rec_case.LAST_BILLED_TIMESTAMP,
          rec_case.CODE_TYPE,
          rec_case.CODE_VERSION
        );
      FOR rec_page IN cur_page
      (
        old_caseid
      )
      LOOP
        old_pageid := rec_page.pageid;
        SELECT pages_seq.nextval INTO new_pageid FROM dual;
        INSERT
        INTO pages
          (
            PAGEID,
            CASEID,
            ORIGINALPAGENUMBER,
            DOCUMENTTYPEID,
            DOCUMENTDATE,
            SUBDOCUMENTORDER,
            FINALPAGENUMBER,
            SUBDOCUMENTPAGENUMBER,
            ORIENTATION,
            ISDELETED,
            DELETEREASON,
            SUSPENDNOTE,
            ISCOMPLETED,
            COMPLETETIMESTAMP,
            HASDATAPOINT,
            ISBADHANDWRITING,
            SPCONTENTID,
            CREATED_TIMESTAMP,
            CREATED_USERID,
            CREATED_STAGEID,
            UPDATED_TIMESTAMP,
            UPDATED_USERID,
            UPDATED_STAGEID,
            DID
          )
          VALUES
          (
            new_pageid,
            new_caseid,
            rec_page.ORIGINALPAGENUMBER,
            rec_page.DOCUMENTTYPEID,
            rec_page.DOCUMENTDATE,
            rec_page.SUBDOCUMENTORDER,
            rec_page.FINALPAGENUMBER,
            rec_page.SUBDOCUMENTPAGENUMBER,
            rec_page.ORIENTATION,
            rec_page.ISDELETED,
            rec_page.DELETEREASON,
            rec_page.SUSPENDNOTE,
            rec_page.ISCOMPLETED,
            rec_page.COMPLETETIMESTAMP,
            rec_page.HASDATAPOINT,
            rec_page.ISBADHANDWRITING,
            rec_page.SPCONTENTID,
            rec_page.CREATED_TIMESTAMP,
            rec_page.CREATED_USERID,
            rec_page.CREATED_STAGEID,
            rec_page.UPDATED_TIMESTAMP,
            rec_page.UPDATED_USERID,
            rec_page.UPDATED_STAGEID,
            rec_page.DID
          );
        FOR rec_dpentry IN cur_dpentry
        (
          old_pageid
        )
        LOOP
          old_dpentryid := rec_dpentry.dpentryid;
          SELECT dpentries_seq.nextval INTO new_dpentryid FROM dual;
          INSERT
          INTO dpentries
            (
              DPENTRYID,
              PAGEID,
              SECTIONNUMBER,
              DPFORMENTITYID,
              ENTRYTRANSCRIPTION,
              DATADATE,
              STATUS,
              CREATED_TIMESTAMP,
              CREATED_USERID,
              CREATED_STAGEID,
              UPDATED_TIMESTAMP,
              UPDATED_USERID,
              UPDATED_STAGEID,
              ISCOMPLETED,
              ISDELETED,
              REQUIRECODE,
              SUSPENDNOTE
            )
            VALUES
            (
              new_dpentryid,
              new_pageid,
              rec_dpentry.SECTIONNUMBER,
              rec_dpentry.DPFORMENTITYID,
              rec_dpentry.ENTRYTRANSCRIPTION,
              rec_dpentry.DATADATE,
              rec_dpentry.STATUS,
              rec_dpentry.CREATED_TIMESTAMP,
              rec_dpentry.CREATED_USERID,
              rec_dpentry.CREATED_STAGEID,
              rec_dpentry.UPDATED_TIMESTAMP,
              rec_dpentry.UPDATED_USERID,
              rec_dpentry.UPDATED_STAGEID,
              rec_dpentry.ISCOMPLETED,
              rec_dpentry.ISDELETED,
              rec_dpentry.REQUIRECODE,
              rec_dpentry.SUSPENDNOTE
            );
          FOR rec_dpcode IN cur_dpcode
          (
            old_dpentryid
          )
          LOOP
            SELECT DPENTRYCODES_SEQ.nextval INTO new_dpcid FROM dual;
            INSERT
            INTO dpentrycodes
              (
                DPECID,
                DPENTRYID,
                CODE,
                CODETYPE,
                CODEDESC,
                ISHIDDEN,
                CONFIDENCE,
                STATUS,
                ISCRITICAL,
                CREATED_TIMESTAMP,
                CREATED_USERID,
                CREATED_STAGEID,
                UPDATED_TIMESTAMP,
                UPDATED_USERID,
                UPDATED_STAGEID,
                CODEID,
                VERSION
              )
              VALUES
              (
                new_dpcid,
                new_dpentryid,
                rec_dpcode.CODE,
                rec_dpcode.CODETYPE,
                rec_dpcode.CODEDESC,
                rec_dpcode.ISHIDDEN,
                rec_dpcode.CONFIDENCE,
                rec_dpcode.STATUS,
                rec_dpcode.ISCRITICAL,
                rec_dpcode.CREATED_TIMESTAMP,
                rec_dpcode.CREATED_USERID,
                rec_dpcode.CREATED_STAGEID,
                rec_dpcode.UPDATED_TIMESTAMP,
                rec_dpcode.UPDATED_USERID,
                rec_dpcode.UPDATED_STAGEID,
                rec_dpcode.CODEID,
                rec_dpcode.VERSION
              );
          END LOOP;
        END LOOP;
      END LOOP;
    END LOOP;
    commit;
    RETURN new_caseid;
  END DUPLICATE_CASE;

/

