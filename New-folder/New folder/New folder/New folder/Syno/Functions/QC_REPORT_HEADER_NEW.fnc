--------------------------------------------------------
--  DDL for Function QC_REPORT_HEADER_NEW
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SNX_IWS2"."QC_REPORT_HEADER_NEW" 
    (P_CASEID NUMBER default null,
     P_VIEW VARCHAR2 default 'OP',
     P_FORMAT VARCHAR2 default null)
    
    -- Created 11-5-2012 R Benzell
    -- Used by Associated QC reports to generate report headers
    
    -- to test:  select QC_REPORT_HEADER(2047) from dual;
    -- Update History 
    
    
        RETURN Varchar2
    
        IS
    
       v_ClientName varchar2(100);
       v_ClientFileName varchar2(100);
       v_TotalPages number;
       v_TotalOpportunity number;
       v_TotalErrorCount number;
       v_Efficiency number;

       v_Sep varchar2(5);
       I number;

       v_StageId number;

       v_OP_lastAssignedDateTime timestamp; 
       v_OP_lastAssignedDate varchar2(10);
       v_OP_lastAssignedTime varchar2(10);

       v_QA_lastAssignedDateTime timestamp; 
       v_QA_lastAssignedDate varchar2(10);
       v_QA_lastAssignedTime varchar2(10);

       --v_OP_UserId_List varchar2(32000);
       --v_OP_UserName_List varchar2(32000);
       --v_OP_UserFullName_List varchar2(32000);

       v_OP_UserId number;
       v_OP_UserName varchar2(35);
       v_OP_UserFullName varchar2(100);

       v_QA_UserId number;
       v_QA_UserName varchar2(35);
       v_QA_UserFullName varchar2(100);


       v_Return varchar2(1000);


        BEGIN
        
     -- Obtain Case-level information
        BEGIN
        select B.clientname,A.CLIENTFILENAME,A.TOTALPAGES
            into v_ClientName, v_CLIENTFILENAME,v_totalPages
        from CASES A,
             CLIENTS B
        where A.caseid= P_CASEID
              AND B.CLIENTID = A.CLIENTID;    
         EXCEPTION WHEN OTHERS THEN null;
        END;

     --- View-specific determinations
    CASE
       WHEN P_VIEW = 'OP' THEN
         v_StageId := 6;

       WHEN P_VIEW = 'QC1' THEN
         v_StageId := 7;


       WHEN P_VIEW = 'COMP' THEN
         v_StageId := 6;

       ELSE
         v_StageId := 6;
         --v_OP_UserId_List := '-';
         --v_OP_UserName_List := '-';
         --v_OP_UserFullName_List := '-';
    END CASE;
         
       --Return just the LAST OP users who worked on this case
       BEGIN
        select a.userid,b.username,b.firstname || ' ' || b.lastname fullname
           into v_OP_UserId, v_OP_UserName, v_OP_UserFullName
          from CASEHISTORYSUM A,
                USERS B
          WHERE B.USERID = A.USERID
          and CHID = (select max(CHID) 
                      from casehistorysum where caseid=P_CASEID
              and stageid=6 and userid is not null);
         EXCEPTION WHEN OTHERS THEN null;
        END;

       --Return just the LAST QA users who worked on this case
       BEGIN
        select a.userid,b.username,b.firstname || ' ' || b.lastname fullname
           into v_QA_UserId, v_QA_UserName, v_QA_UserFullName
          from CASEHISTORYSUM A,
                USERS B
          WHERE B.USERID = A.USERID
          and CHID = (select max(CHID) 
                      from casehistorysum where caseid=P_CASEID
              and stageid=7 and userid is not null);
         EXCEPTION WHEN OTHERS THEN null;
        END;


        --- Determine the final OP date/time this step was worked on
       BEGIN
        select max(ASSIGNMENTCOMPLETIONTIMESTAMP) 
          into  v_OP_lastAssignedDateTime  
          from casehistorysum where caseid=P_CASEID
          and stageid=6 and userid is not null;
          v_OP_lastAssignedDate := to_char(v_OP_lastAssignedDateTime,'YYYY-MM-DD'); 
          v_OP_lastAssignedTime := to_char(v_OP_lastAssignedDateTime,'HH:MIpm'); 
         EXCEPTION WHEN OTHERS THEN null;
        END;

        --- Determine the final QA date/time this step was worked on
       BEGIN
        select max(ASSIGNMENTCOMPLETIONTIMESTAMP) 
          into  v_QA_lastAssignedDateTime  
          from casehistorysum where caseid=P_CASEID
          and stageid=7 and userid is not null;
          v_QA_lastAssignedDate := to_char(v_QA_lastAssignedDateTime,'YYYY-MM-DD'); 
          v_QA_lastAssignedTime := to_char(v_QA_lastAssignedDateTime,'HH:MIpm'); 
         EXCEPTION WHEN OTHERS THEN null;
        END;


 --- Determine the Total Opportunity 
   select sum(OPPORTUNITY_COUNT) into v_TotalOpportunity from
    ( select    
       OPPORTUNITY_COUNT(
          FINALPAGENUMBER,
          SECTIONNUMBER,
          CODENAME,
          DATADATE,
          DATAFIELD1VALUE,
          DATAFIELD2VALUE,
          DATAFIELD3VALUE,
          DATAFIELD4VALUE,    
          DATAFIELD5VALUE,    
          DATAFIELD6VALUE,
          DATAFIELD7VALUE,
          DATAFIELD8VALUE,
          DATAFIELD9VALUE,    
          DATAFIELD10VALUE,
          DATAFIELD11VALUE,
          DATAFIELD12VALUE  )   
              OPPORTUNITY_COUNT 
     from  DPENTRYPAGES_VIEW  where caseid=P_CASEID );

--- For CompView, Determine the Total Errors and Efficients
  IF P_VIEW = 'COMP' then
    select sum( DP_CHANGE_COUNT) into v_TotalErrorCount
     from
      (select DP_change_count(DPENTRYID) DP_CHANGE_COUNT
       from DPENTRYPAGES_VIEW where caseid=P_CASEID);

 
      v_Efficiency := round(100 - (( v_TotalErrorCount/v_TotalOpportunity)*100),1);

   END IF;
       

  --- construct the Header as a HTML table
         v_Return := '<hr style="height:15px; width:100%; color:#aaa; background-color:#aaa;"/>' ||
                     '<table cellspacing="1" cellpadding="5" border="1">' ||
                       '<tr>'  ||
                         '<td> <b>Client Name: </b>  '    ||  v_ClientName       || '  </td> ' ||
                         '<td> <b>File Name: </b>  '      ||  v_ClientFileName   || ' </td>  ' ||
                         '<td> <b>Total Pages: </b> '     ||  v_TotalPages       || '  </td> ' ||
                         '<td> <b>OP Date Processed: </b>  ' ||  v_OP_lastAssignedDate || ' </td> ' ||
                       '</tr>' ||
                       '<tr>'  ||
                         '<td> <b>Case ID: </b>  '        || to_char(P_CASEID)   || '  </td>  ' ||
                         '<td> <b>OP User Name(s): </b>  '   ||  v_OP_UserName         || '  </td>  ' ||
                         '<td> <b>OP User Id(s): </b>  '     ||  v_OP_Userid           || '  </td>  ' ||
                         '<td> <b>OP Time Processed: </b>  ' ||  v_OP_lastAssignedTime || '  </td>  ' ||
                       '</tr>' ||
                       '<tr>'  ||
                         '<td> <b>Total No. Of Data Points: </b>  ' || DATAPOINT_COUNT(P_CASEID)  || ' </td> ' ||
                         '<td> <b>Total Opportunity: </b>  '        || v_TotalOpportunity      || ' </td> ';

        --- some tallies are only for the Comp view
         IF P_VIEW = 'COMP' then
             v_Return := v_return ||
               '<td> <b>Total Error Count: </b>  ' || v_TotalErrorCount     || ' </td> ' ||
                '<td> <b>Quality Efficiency (%): </b>  ' || v_Efficiency      || ' </td> ';
         END IF;    

         v_Return := v_return || '</tr>'  ||
             '</table>';
        
  
         return v_Return;

      EXCEPTION WHEN OTHERS THEN SHOW_APEX_ERROR('');

      END;



/

