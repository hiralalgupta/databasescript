--------------------------------------------------------
--  DDL for Function MATRIX_XML_FALLRISK
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SNX_IWS2"."MATRIX_XML_FALLRISK" 
    (   P_CASEID  number   ,
        P_LF varchar2  ) 
    
    -- Created 10-6-2012 R Benzell
    -- called by GEN_MATRIX_XML
    -- edited and completed 10-8-12 Denis
    
        RETURN CLOB
    
        IS
    

        v_Str CLOB;
        v_CaseId number;
        LF varchar2(5);
      
       
          
            BEGIN
                
      v_CaseId := P_CaseId;
      LF := P_LF;
        

-----------------------------------

v_Str := v_Str || ' <FallRisk>' || LF;

v_Str := v_Str || '   <diagnosis>' || LF;
v_Str := v_Str || '        <title>History of falling or fall risk</title>'  || LF;
v_Str := v_Str || '        <value>' ||  Get_InfoPathData('Fall_Risk_History',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '   </diagnosis>' || LF;

v_Str := v_Str || '   <total>' ||  Get_InfoPathData('Fall_Risk_4_Responses_No + Fall_Risk_4_Responses_Yes',v_CaseId,'ST') || '</total>'  || LF;

v_Str := v_Str || '   <questions>' || LF;
v_Str := v_Str || '        <title>Age>=65</title>'  || LF;
v_Str := v_Str || '        <value>' ||  Get_InfoPathData('Fall_Risk_Age65+ Fall_Risk_Age65_No',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '   </questions>' || LF;
v_Str := v_Str || '   <questions>'  || LF;
v_Str := v_Str || '        <title>3 or More Co-morbidities</title>'  || LF;
v_Str := v_Str || '        <value>' ||  Get_InfoPathData('Fall_Risk_comorbidities+ Fall_Risk_comorbidities_No',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '   </questions>' || LF;
v_Str := v_Str || '   <questions>' || LF;
v_Str := v_Str || '        <title>Prior History of Falls Within 3 Months</title>'  || LF;
v_Str := v_Str || '        <value>' ||  Get_InfoPathData('Fall_Risk_Prior_Falls + Fall_Risk_Prior_Falls_No',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '   </questions>' || LF;
v_Str := v_Str || '   <questions>' || LF;
v_Str := v_Str || '        <title>Incontinence</title>'  || LF;
v_Str := v_Str || '        <value>' ||  Get_InfoPathData('Fall_Risk_Incontinence+ Fall_Risk_Incontinence_No',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '   </questions>' || LF;
v_Str := v_Str || '   <questions>' || LF;
v_Str := v_Str || '        <title>Visual Impairment</title>'  || LF;
v_Str := v_Str || '        <value>' ||  Get_InfoPathData('#NAME?',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '   </questions>' || LF;
v_Str := v_Str || '   <questions>' || LF;
v_Str := v_Str || '        <title>Impaired Functional Mobility</title>'  || LF;
v_Str := v_Str || '        <value>' ||  Get_InfoPathData('Fall_Risk_Impaired_Functionality+ Fall_Risk_Impaired_Functionality_No++',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '   </questions>' || LF;
v_Str := v_Str || '   <questions>' || LF;
v_Str := v_Str || '        <title>Environmental Hazards</title>'  || LF;
v_Str := v_Str || '        <value>' ||  Get_InfoPathData('Fall_Risk_Environmental_Hazards+ Fall_Risk_Environmental_Hazards_No',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '   </questions>' || LF;
v_Str := v_Str || '   <questions>'|| LF;
v_Str := v_Str || '        <title>Poly Pharmacy (4 or More Prescriptions)</title>'  || LF;
v_Str := v_Str || '        <value>' ||  Get_InfoPathData('Fall_Risk_Poly+ Fall_Risk_Poly_No',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '   </questions>' || LF;
v_Str := v_Str || '   <questions>' || LF;
v_Str := v_Str || '        <title>Pain Impacting Level of Function</title>'  || LF;
v_Str := v_Str || '        <value>' ||  Get_InfoPathData('Fall_Risk_Pain+ Fall_Risk_Pain_No',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '   </questions>' || LF;
v_Str := v_Str || '   <questions>' || LF;
v_Str := v_Str || '        <title>Cognitive Impairment</title>'  || LF;
v_Str := v_Str || '        <value>' ||  Get_InfoPathData('Fall_Risk_Cog+ Fall_Risk_Cog_No',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '   </questions>' || LF;
v_Str := v_Str || ' </FallRisk>' || LF;

------------------------------------


       RETURN v_Str;
       
       EXCEPTION WHEN OTHERS THEN
            v_Str := SUBSTR(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
                              CHR(13) ||
                              SQLERRM,1,4000); 
           
       END;

/

