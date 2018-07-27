--------------------------------------------------------
--  DDL for Function MATRIX_XML_INFOSOURCE
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SNX_IWS2"."MATRIX_XML_INFOSOURCE" (
      P_CASEID NUMBER ,
      P_LF     VARCHAR2 )
    -- Created 10-6-2012 R Benzell
    -- called by GEN_MATRIX_XML
    RETURN CLOB
  IS
    v_Str CLOB;
    v_CaseId NUMBER;
    LF       VARCHAR2(5);
  BEGIN
    v_CaseId := P_CaseId;
    LF       := P_LF;
    -----------------------------------
    v_Str := v_Str || '  <InformationSource>' || LF;    
    v_Str := v_Str || '   <source>' || LF;
    v_Str := v_Str || '    <title>Patient</title>' || LF;
    v_Str := v_Str || '    <value>' || Get_InfoPathData('IS_Patient',v_CaseId,'ST') || '</value>' || LF;
    v_Str := v_Str || '    <desc>' || '' || '</desc>' || LF;
    v_Str := v_Str || '   </source>' || LF;
    v_Str := v_Str || '   <source>' || LF;
    v_Str := v_Str || '    <title>Medical Record</title>' || LF;
    v_Str := v_Str || '    <value>' || Get_InfoPathData('IS_Medical_Record',v_CaseId,'ST') || '</value>' || LF;
    v_Str := v_Str || '    <desc>' || '' || '</desc>' || LF;
    v_Str := v_Str || '   </source>' || LF;
    v_Str := v_Str || '   <source>' || LF;
    v_Str := v_Str || '    <title>Other</title>' || LF;
    v_Str := v_Str || '    <value>' || Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
    v_Str := v_Str || '    <desc>' || Get_InfoPathData('IS_Other_Box',v_CaseId,'ST') || '</desc>' || LF;
    v_Str := v_Str || '   </source>' || LF;
    v_Str := v_Str || '   <diagnosis>' || Get_InfoPathData('None',v_CaseId,'ST') || LF;
    v_Str := v_Str || '    <title>Diabetes</title>' || LF;
    v_Str := v_Str || '    <value>' || Get_InfoPathData('IS_Diabetes',v_CaseId,'ST') || '</value>' || LF;
    v_Str := v_Str || '   </diagnosis>' || LF;
    v_Str := v_Str || '   <diagnosis>' || LF;
    v_Str := v_Str || '    <title>Cancer</title>' || LF;
    v_Str := v_Str || '    <value>' || Get_InfoPathData('IS_Cancer',v_CaseId,'ST') || '</value>' || LF;
    v_Str := v_Str || '    <followupQuestions>' || LF;
    v_Str := v_Str || '     <title>The patient currently has cancer present?</title>' || LF;
    v_Str := v_Str || '     <value>' || Get_InfoPathData('IS_Cancer_Current',v_CaseId,'ST') || '</value>' || LF;
    v_Str := v_Str || '     </followupQuestions>' || LF;
    v_Str := v_Str || '     <followupQuestions>' || LF;
    v_Str := v_Str || '      <title>The patient is currently on a treatment regimen such as chemotherapy or radiation therapy?</title>' || LF;
    v_Str := v_Str || '      <value>' || Get_InfoPathData('IS_Cancer_Treatment',v_CaseId,'ST') || '</value>' || LF;
    v_Str := v_Str || '     </followupQuestions>' || LF;
    v_Str := v_Str || '     <followupQuestions>' || LF;
    v_Str := v_Str || '      <title>The patient is on other anti-cancer treatment (e.g. tamoxifen or lupron)?</title>' || LF;
    v_Str := v_Str || '      <value>' || Get_InfoPathData('IS_Cancer_Other_Treatment',v_CaseId,'ST') || '</value>' || LF;
    v_Str := v_Str || '      <secondaryQuestions>' || LF;
    v_Str := v_Str || '       <title>List</title>' || LF;
    v_Str := v_Str || '       <value>' || '' || '</value>' || LF;
    v_Str := v_Str || '       <Othervalue>' || Get_InfoPathData('IS_Cancer_Other_Treatment_List',v_CaseId,'ST') || '</Othervalue>' || LF;
    v_Str := v_Str || '      </secondaryQuestions>' || LF;
    v_Str := v_Str || '     </followupQuestions>' || LF;
    v_Str := v_Str || '     <followupQuestions>' || LF;
    v_Str := v_Str || '      <title>The patient currently has metastatic cancer present?</title>' || LF;
    v_Str := v_Str || '      <value>' || Get_InfoPathData('IS_Cancer_Metastatic_Treatment',v_CaseId,'ST') || '</value>' || LF;
    v_Str := v_Str || '      <secondaryQuestions>' || LF;
    v_Str := v_Str || '       <title>' || '' || '</title>' || LF;
    v_Str := v_Str || '       <value>' || '' || '</value>' || LF;
    v_Str := v_Str || '       <Othervalue>' || Get_InfoPathData('IS_Cancer_Metastatic_Treatment',v_CaseId,'ST') || '</Othervalue>' || LF;
    v_Str := v_Str || '      </secondaryQuestions>' || LF;
    v_Str := v_Str || '     </followupQuestions>' || LF;
    v_Str := v_Str || '     <followupQuestions>' || LF;
    v_Str := v_Str || '      <title>' || '' || '</title>' || LF;
    v_Str := v_Str || '      <value>' || '' || '</value>' || LF;
    v_Str := v_Str || '      <secondaryQuestions>' || LF;    
    v_Str := v_Str || '       <title>' || '' || '</title>' || LF;
    v_Str := v_Str || '       <answer>' || '' || '</answer>' || LF;
    v_Str := v_Str || '       <value>' || '' || '</value>' || LF;
    v_Str := v_Str || '       <managementPlan>' || '' || '</managementPlan>' || LF;
    v_Str := v_Str || '      </secondaryQuestions>' || LF;    
    v_Str := v_Str || '      <secondaryQuestions>' || LF;    
    v_Str := v_Str || '       <title>' || '' || '</title>' || LF;
    v_Str := v_Str || '       <answer>' || '' || '</answer>' || LF;
    v_Str := v_Str || '       <value>' || '' || '</value>' || LF;
    v_Str := v_Str || '       <otherValue>' || '' || '</otherValue>' || LF;
    v_Str := v_Str || '       <managementPlan>' || '' || '</managementPlan>' || LF;
    v_Str := v_Str || '      </secondaryQuestions>' || LF; 
    v_Str := v_Str || '     </followupQuestions>' || LF;
    v_Str := v_Str || '     <followupQuestions>' || LF;
    v_Str := v_Str || '      <title>' || '' || '</title>' || LF;
    v_Str := v_Str || '      <value>' || '' || '</value>' || LF;
    v_Str := v_Str || '      <managementPlan>' || '' || '</managementPlan>' || LF;
    v_Str := v_Str || '      <secondaryQuestions>' || LF;    
    v_Str := v_Str || '       <title>' || '' || '</title>' || LF;
    v_Str := v_Str || '       <answer>' || '' || '</answer>' || LF;
    v_Str := v_Str || '       <value>' || '' || '</value>' || LF;
    v_Str := v_Str || '      </secondaryQuestions>' || LF;    
    v_Str := v_Str || '     </followupQuestions>' || LF;
    v_Str := v_Str || '     <followupQuestions>' || LF;
    v_Str := v_Str || '      <title>' || '' || '</title>' || LF;
    v_Str := v_Str || '      <value>' || '' || '</value>' || LF;
    v_Str := v_Str || '      <secondaryQuestions>' || LF;    
    v_Str := v_Str || '       <title>' || '' || '</title>' || LF;
    v_Str := v_Str || '       <value>' || '' || '</value>' || LF;
    v_Str := v_Str || '      </secondaryQuestions>' || LF;    
    v_Str := v_Str || '     </followupQuestions>' || LF;
    v_Str := v_Str || '   </diagnosis>' || LF;
    v_Str := v_Str || '   <diagnosis>' || LF;
    v_Str := v_Str || '    <title>Have you ever been diagnosed with CHF?</title>' || LF;
    v_Str := v_Str || '    <value>' || Get_InfoPathData('IS_CHF',v_CaseId,'ST') || '</value>' || LF;
    v_Str := v_Str || '   </diagnosis>' || LF;
    v_Str := v_Str || '   <diagnosis>' || LF;
    v_Str := v_Str || '    <title>Have you ever been diagnosed with MI?</title>' || LF;
    v_Str := v_Str || '    <value>' || Get_InfoPathData('IS_MI',v_CaseId,'ST') || '</value>' || LF;
    v_Str := v_Str || '   </diagnosis>' || LF;
    v_Str := v_Str || '   <diagnosis>' || LF;
    v_Str := v_Str || '    <title>Have you ever been diagnosed with Angina?</title>' || LF;
    v_Str := v_Str || '    <value>' || Get_InfoPathData('IS_Angina',v_CaseId,'ST') || '</value>' || LF;
    v_Str := v_Str || '   </diagnosis>' || LF;
    v_Str := v_Str || '   <diagnosis>' || LF;
    v_Str := v_Str || '    <title>Have you ever been diagnosed with Atrial fibrillation?</title>' || LF;
    v_Str := v_Str || '    <value>' || Get_InfoPathData('IS_Atrial_Fibrillation',v_CaseId,'ST') || '</value>' || LF;
    v_Str := v_Str || '   </diagnosis>' || LF;
    v_Str := v_Str || '   <diagnosis>' || LF;
    v_Str := v_Str || '    <title>Have you ever had an amputation?</title>' || LF;
    v_Str := v_Str || '    <value>' || Get_InfoPathData('IS_Amputation',v_CaseId,'ST') || '</value>' || LF;
    v_Str := v_Str || '    <followupQuestions>' || LF;
    v_Str := v_Str || '     <title>' || '' || '</title>' || LF;
    v_Str := v_Str || '     <value>' || '' || '</value>' || LF;
    v_Str := v_Str || '     <otherValue>' || '' || '</otherValue>' || LF;
    v_Str := v_Str || '     <secondaryQuestions>' || LF;    
    v_Str := v_Str || '      <title>' || '' || '</title>' || LF;
    v_Str := v_Str || '      <answer>' || '' || '</answer>' || LF;
    v_Str := v_Str || '      <value>' || '' || '</value>' || LF;
    v_Str := v_Str || '     </secondaryQuestions>' || LF;    
    v_Str := v_Str || '    </followupQuestions>' || LF;
    v_Str := v_Str || '    <followupQuestions>' || LF;
    v_Str := v_Str || '     <title>' || '' || '</title>' || LF;
    v_Str := v_Str || '     <value>' || '' || '</value>' || LF;
    v_Str := v_Str || '     <otherValue>' || '' || '</otherValue>' || LF;
    v_Str := v_Str || '     <secondaryQuestions>' || LF;    
    v_Str := v_Str || '      <title>' || '' || '</title>' || LF;
    v_Str := v_Str || '      <answer>' || '' || '</answer>' || LF;
    v_Str := v_Str || '      <value>' || '' || '</value>' || LF;
    v_Str := v_Str || '     </secondaryQuestions>' || LF;    
    v_Str := v_Str || '    </followupQuestions>' || LF;
    v_Str := v_Str || '    <followupQuestions>' || LF;
    v_Str := v_Str || '     <title>' || '' || '</title>' || LF;
    v_Str := v_Str || '     <value>' || '' || '</value>' || LF;
    v_Str := v_Str || '     <otherValue>' || '' || '</otherValue>' || LF;
    v_Str := v_Str || '     <secondaryQuestions>' || LF;    
    v_Str := v_Str || '      <title>' || '' || '</title>' || LF;
    v_Str := v_Str || '      <answer>' || '' || '</answer>'|| LF;
    v_Str := v_Str || '      <value>' || '' || '</value>' || LF;
    v_Str := v_Str || '      <otherValue>' || '' || '</otherValue>' ||LF;    
    v_Str := v_Str || '     </secondaryQuestions>' || LF;     
    v_Str := v_Str || '    </followupQuestions>' || LF;  
    v_Str := v_Str || '   </diagnosis>' || LF;   
    v_Str := v_Str || '  </InformationSource>' || LF; 

    ------------------------------------
    RETURN v_Str;
  EXCEPTION
  WHEN OTHERS THEN
    v_Str := SUBSTR(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || CHR(13) || SQLERRM,1,4000);
  END;

/

