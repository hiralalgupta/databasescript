--------------------------------------------------------
--  DDL for Function XMLTEST1
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SNX_IWS2"."XMLTEST1" 
    (   P_CASEID          number   default 1884 ,
        P_LF varchar2 default chr(10)||chr(13) ) 
    
    -- Created 10-6-2012 R Benzell
    -- called by ClientXMLgenerator
    -- Updated
    -- 10-13-2011 R Benzell
    -- to Test:  select XMLTEST1(1884) from dual
  

    
        RETURN CLOB
    
        IS
    

        v_Str CLOB;
        v_CaseId number;
        LF varchar2(5);
      
       
          
            BEGIN
                
      v_CaseId := P_CaseId;
      LF := P_LF;
        
        v_Str := v_Str || '<HRALocation>' ||  Get_InfoPathData('',v_CaseId,'ST') || '</HRALocation>'  || LF;

v_Str := v_Str || '   <hraLocation>' ||  Get_InfoPathData('',v_CaseId,'ST') || '</hraLocation>'  || LF;

v_Str := v_Str || '        <locationType>' ||  Get_InfoPathData('HRA_Home',v_CaseId,'ST') || '</locationType>'  || LF;
v_Str := v_Str || '        <locationSubType>' ||  Get_InfoPathData('HRA_Home',v_CaseId,'ST') || '</locationSubType>'  || LF;
v_Str := v_Str || '        <locationName>' ||  Get_InfoPathData('HRA_Home',v_CaseId,'ST') || '</locationName>'  || LF;

v_Str := v_Str || '   <hraLocation>' ||  Get_InfoPathData('HRA_Home',v_CaseId,'ST') || '</hraLocation>'  || LF;

v_Str := v_Str || '        <locationType>' ||  Get_InfoPathData('HRA_SNF',v_CaseId,'ST') || '</locationType>'  || LF;
v_Str := v_Str || '        <locationSubType>' ||  Get_InfoPathData('HRA_SNF_PAC',v_CaseId,'ST') || '</locationSubType>'  || LF;
v_Str := v_Str || '        <locationName>' ||  Get_InfoPathData('HRA_SNF_Name',v_CaseId,'ST') || '</locationName>'  || LF;

v_Str := v_Str || '   <hraLocation>' ||  Get_InfoPathData('HRA_SNF_Name',v_CaseId,'ST') || '</hraLocation>'  || LF;

v_Str := v_Str || '        <locationType>' ||  Get_InfoPathData('HRA_SNF',v_CaseId,'ST') || '</locationType>'  || LF;
v_Str := v_Str || '        <locationSubType>' ||  Get_InfoPathData('HRA_SNF_LTC',v_CaseId,'ST') || '</locationSubType>'  || LF;
v_Str := v_Str || '        <locationName>' ||  Get_InfoPathData('HRA_SNF_Name',v_CaseId,'ST') || '</locationName>'  || LF;

v_Str := v_Str || '   <hraLocation>' ||  Get_InfoPathData('HRA_SNF_Name',v_CaseId,'ST') || '</hraLocation>'  || LF;

v_Str := v_Str || '        <locationType>' ||  Get_InfoPathData('HRA_SNF',v_CaseId,'ST') || '</locationType>'  || LF;
v_Str := v_Str || '        <locationSubType>' ||  Get_InfoPathData('HRA_SNF',v_CaseId,'ST') || '</locationSubType>'  || LF;
v_Str := v_Str || '        <locationName>' ||  Get_InfoPathData('HRA_SNF_Name',v_CaseId,'ST') || '</locationName>'  || LF;

v_Str := v_Str || '   <hraLocation>' ||  Get_InfoPathData('HRA_SNF_Name',v_CaseId,'ST') || '</hraLocation>'  || LF;

v_Str := v_Str || '        <locationType>' ||  Get_InfoPathData('HRA_SNF_ESRD',v_CaseId,'ST') || '</locationType>'  || LF;
v_Str := v_Str || '        <locationSubType>' ||  Get_InfoPathData('HRA_SNF_ESRD',v_CaseId,'ST') || '</locationSubType>'  || LF;
v_Str := v_Str || '        <locationName>' ||  Get_InfoPathData('HRA_SNF_ESRD',v_CaseId,'ST') || '</locationName>'  || LF;

       RETURN v_Str;
       
       EXCEPTION WHEN OTHERS THEN
            v_Str := SUBSTR(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
                              CHR(13) ||
                              SQLERRM,1,4000); 
           
       END;

/

