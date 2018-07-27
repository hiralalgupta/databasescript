--------------------------------------------------------
--  DDL for Procedure SHOW_APEX_ERROR
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "SNX_IWS2"."SHOW_APEX_ERROR" 
  -- Program name - SHOW_APEX_ERROR
  -- Created 11-5-2012 R Benzell
  -- REturns/shows error t
  --
  -- Typical Usage - add to Procedures just before final END;
  --   EXCEPTION WHEN OTHERS THEN SHOW_APEX_ERROR('optonal message');
/*** to Test    
  begin
    LOG_APEX_ERROR(123,'test action','Error happened here');
  end;
***/
  -- Update History: 

           (
            P_CONTENT    IN VARCHAR2 default NULL
            )
         IS
 
   
         v_Message varchar2(32000);

         BEGIN
       
         --- Generate message with Standard oracle trace info
             v_MESSAGE:= SUBSTR(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
                              CHR(13) || 
                              SQLERRM,1,4000);
                  

          htp.p(P_CONTENT|| ' ' || v_MESSAGE);


       END;

/

