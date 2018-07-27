--------------------------------------------------------
--  DDL for Function QC_REPORT_HEADER
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SNX_IWS2"."QC_REPORT_HEADER" 
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

       v_OP2_lastAssignedDateTime timestamp; 
       v_OP2_lastAssignedDate varchar2(10);
       v_OP2_lastAssignedTime varchar2(10);

       v_QC1_lastAssignedDateTime timestamp; 
       v_QC1_lastAssignedDate varchar2(10);
       v_QC1_lastAssignedTime varchar2(10);

       --v_OP2_UserId_List varchar2(32000);
       --v_OP2_UserName_List varchar2(32000);
       --v_OP2_UserFullName_List varchar2(32000);

       v_OP2_UserId number;
       v_OP2_UserName varchar2(35);
       v_OP2_UserFullName varchar2(100);

       v_QC1_UserId number;
       v_QC1_UserName varchar2(35);
       v_QC1_UserFullName varchar2(100);


       v_Return varchar2(1000);


        BEGIN
            
    -- Obtain Case-level information from CASE_STATS cube
        BEGIN
        select B.clientname,
               A.CLIENT_FILENAME,
               A.TOTAL_PAGES,
               ERROR_COUNT,
               QUALITY_EFFICIENCY,
               OP2_USERID,
               OP2_FINISHED_ON,
               QC1_USERID,
               QC1_FINISHED_ON,
               OPPORTUNITY_COUNT  
            into 
               v_ClientName, 
               v_CLIENTFILENAME,
               v_totalPages,
               v_TotalErrorCount,
               v_Efficiency,
               v_OP2_UserId,
               v_OP2_lastAssignedDateTime,
               v_QC1_UserId,
               v_QC1_lastAssignedDateTime,
               v_TotalOpportunity
        from CASE_STATS A,
             CLIENTS B
        where A.caseid= P_CASEID
              AND B.CLIENTID = A.CLIENTID;    
         EXCEPTION WHEN OTHERS THEN null;
        END;     

       --- format separate date/times
          v_OP2_lastAssignedDate := to_char(v_OP2_lastAssignedDateTime,'YYYY-MM-DD'); 
          v_OP2_lastAssignedTime := to_char(v_OP2_lastAssignedDateTime,'HH:MIpm'); 

          v_QC1_lastAssignedDate := to_char(v_QC1_lastAssignedDateTime,'YYYY-MM-DD'); 
          v_QC1_lastAssignedTime := to_char(v_QC1_lastAssignedDateTime,'HH:MIpm'); 




       --Return just the LAST OP usersname who worked on this case
       BEGIN
        select b.username,b.firstname || ' ' || b.lastname fullname
           into v_OP2_UserName, v_OP2_UserFullName
          from   USERS B WHERE B.USERID = v_OP2_UserId;
         EXCEPTION WHEN OTHERS THEN null;
        END;

      --Return just the LAST OP usersname who worked on this case
       BEGIN
        select b.username,b.firstname || ' ' || b.lastname fullname
           into v_QC1_UserName, v_QC1_UserFullName
          from   USERS B WHERE B.USERID = v_QC1_UserId;
         EXCEPTION WHEN OTHERS THEN null;
        END;




  --- construct the Header as a HTML table - common to all views
        v_Return := '<hr style="height:15px; width:100%; color:#aaa; background-color:#aaa;"/>' ||
                     '<table cellspacing="1" cellpadding="5" border="1">' ||
                       '<tr>'  ||
                         '<td> <b>Client Name: </b>  '    ||  v_ClientName       || '  </td> ' ||
                         '<td> <b>File Name: </b>  '      ||  v_ClientFileName   || ' </td>  ';

-- view-dependent info
   CASE
   WHEN P_VIEW = 'OP' THEN
             v_Return := v_Return ||
                         '<td> <b>Total Pages: </b> '     ||  v_TotalPages       || '  </td> ' ||
                         '<td> <b>Date Processed: </b>  ' ||  v_OP2_lastAssignedDate || ' </td> ' ||
                       '</tr>' ||
                       '<tr>'  ||
                         '<td> <b>Case ID: </b>  '        || to_char(P_CASEID)   || '  </td>  ' ||
                         '<td> <b>User Name(Step2 OP): </b>  '   ||  v_OP2_UserFullName         || '  </td>  ' ||
       '<td> <b>User Id(Step2 OP): </b>  '     ||  v_OP2_UserName || ' ('||v_OP2_Userid || ')  </td>  ' ||
                         '<td> <b>Time Saved: </b>  ' ||  v_OP2_lastAssignedTime || '  </td>  ' ||
                       '</tr>' ||
                       '<tr>'  ||
                         '<td> <b>Total No. Of Data Points: </b>  ' || DATAPOINT_COUNT(P_CASEID)  || ' </td> ' ||
                         '<td> <b>Total Opportunity: </b>  '        || v_TotalOpportunity      || ' </td> ';


   WHEN P_VIEW = 'QC1' THEN
                    v_Return := v_Return ||
                         '<td> <b>Total Pages: </b> '     ||  v_TotalPages       || '  </td> ' ||
                         '<td> <b>Date Processed: </b>  ' ||  v_QC1_lastAssignedDate || ' </td> ' ||
                       '</tr>' ||
                       '<tr>'  ||
                         '<td> <b>Case ID: </b>  '        || to_char(P_CASEID)   || '  </td>  ' ||
                         '<td> <b>User Name(Step2 QC1): </b>  '  ||  v_QC1_UserFullName         || '  </td>  ' ||
                         '<td> <b>User Id(Step2 QC1): </b>  '    ||  v_QC1_UserName  || ' (' || v_QC1_Userid || ') </td>  ' ||
                         '<td> <b>Time Saved: </b>  ' ||  v_QC1_lastAssignedTime || '  </td>  ' ||
                       '</tr>' ||
                       '<tr>'  ||
                         '<td> <b>Total No. Of Data Points: </b>  ' || DATAPOINT_COUNT(P_CASEID)  || ' </td> ' ||
                         '<td> <b>Total Opportunity: </b>  '        || v_TotalOpportunity      || ' </td> ';
  

        --- some tallies are only for the Comp view
        WHEN P_VIEW = 'COMP' then
                 v_Return := v_return ||
                         '<td> <b>Case ID: </b>  '        || to_char(P_CASEID)   || '  </td>  ' ||
                         '<td> <b>Total Pages: </b> '     ||  v_TotalPages       || '  </td> ' ||
                       '</tr>' ||
                       '<tr>'  ||
                         '<td> <b>User Name(Step2 OP): </b>  '    ||  v_OP2_UserFullName         || '  </td>  ' ||
                         '<td> <b>Date & Time File Saved: </b>  ' ||  v_OP2_lastAssignedDate  || ' ' ||
                                                                      v_OP2_lastAssignedTime  || ' </td> ' ||
                         '<td> <b>User Name(Step2 QC1): </b>  '  ||  v_QC1_UserFullName         || '  </td>  ' ||
                         '<td> <b>Date & Time File Saved: </b>  ' ||  v_QC1_lastAssignedDate || ' ' ||
                                                                      v_QC1_lastAssignedTime || '  </td>  ' ||
                       '</tr>' ||
                       '<tr>'  ||
                         '<td> <b>Total No. Of Data Points: </b>  ' || DATAPOINT_COUNT(P_CASEID)  || ' </td> ' ||
                         '<td> <b>Total Opportunity: </b>  '        || v_TotalOpportunity      || ' </td> ' ||
                         '<td> <b>Total Error Count: </b>  '        || v_TotalErrorCount     || ' </td> ' ||
                         '<td> <b>Quality Efficiency (%): </b>  '   || v_Efficiency      || ' </td> ';

          ELSE
              
              V_REturn := 'view ' || P_VIEW || ' not recognized.';
        
          END CASE;

      -- end table - common to all views
         v_Return := v_return || '</tr>'  ||
             '</table>';
        
  
         return v_Return;

      EXCEPTION WHEN OTHERS THEN SHOW_APEX_ERROR('');

      END;



/

