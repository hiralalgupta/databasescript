--------------------------------------------------------
--  DDL for Function MATRIX_XML_SIGNATURE_BK1
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SNX_IWS2"."MATRIX_XML_SIGNATURE_BK1" 
    (   P_CASEID  number   ,
        P_LF varchar2  ) 
    
    -- Created 10-6-2012 R Benzell
    -- called by GEN_MATRIX_XML

    
        RETURN CLOB
    
        IS
    

        v_Str CLOB;
        v_CaseId number;
        LF varchar2(5);
      
       
          
            BEGIN
                
      v_CaseId := P_CaseId;
      LF := P_LF;
        

-----------------------------------


v_Str := v_Str || '   <reviewers>' ||  Get_InfoPathData('',v_CaseId,'ST') || '</reviewers>'  || LF;

v_Str := v_Str || '        <type>' ||  Get_InfoPathData('none',v_CaseId,'ST') || '</type>'  || LF;
v_Str := v_Str || '        <friendlyType>' ||  Get_InfoPathData('none',v_CaseId,'ST') || '</friendlyType>'  || LF;
v_Str := v_Str || '        <dateOfService>' ||  Get_InfoPathData('Name_Sig_Provider_Date',v_CaseId,'ST') || '</dateOfService>'  || LF;
v_Str := v_Str || '        <signature64>' ||  Get_InfoPathData('',v_CaseId,'ST') || '</signature64>'  || LF;
v_Str := v_Str || '        <signature64>' ||  Get_InfoPathData('Name_Sig_Provider_Name',v_CaseId,'ST') || '</signature64>'  || LF;
v_Str := v_Str || '        <credentials>'  || LF;

v_Str := v_Str || '         <title>Provider</title>'  || LF;

v_Str := v_Str || '         <value>' ||  Get_InfoPathData('Name_Sig_Provider_MD                   Name_Sig_Provider_DO      Name_Sig_Provider_NP              Name_Sig_Provider_PA',v_CaseId,'ST') || '</value>'  || LF;

v_Str := v_Str || '   <reviewers>'  || LF;

v_Str := v_Str || '        <signature64>' ||  Get_InfoPathData('',v_CaseId,'ST') || '</signature64>'  || LF;
v_Str := v_Str || '        <signature64>' ||  Get_InfoPathData('Name_Sig_Co_Signing_Provider_Name',v_CaseId,'ST') || '</signature64>'  || LF;

v_Str := v_Str || '   <reviewers>'  || LF;

v_Str := v_Str || '        <signature64>' ||  Get_InfoPathData('',v_CaseId,'ST') || '</signature64>'  || LF;
v_Str := v_Str || '        <signature64>' ||  Get_InfoPathData('Name_Sig_QA_Reviewer_Name',v_CaseId,'ST') || '</signature64>'  || LF;

v_Str := v_Str || '   <reviewers>'  || LF;

v_Str := v_Str || '        <signature64>' ||  Get_InfoPathData('',v_CaseId,'ST') || '</signature64>'  || LF;
v_Str := v_Str || '        <signature64>' ||  Get_InfoPathData('Name_Sig_Coder_Name',v_CaseId,'ST') || '</signature64>'  || LF;



------------------------------------


       RETURN v_Str;
       
       EXCEPTION WHEN OTHERS THEN
            v_Str := SUBSTR(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
                              CHR(13) ||
                              SQLERRM,1,4000); 
           
       END;

/

