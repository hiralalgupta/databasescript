--------------------------------------------------------
--  DDL for Function MATRIX_XML_NUTRIDIAG
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SNX_IWS2"."MATRIX_XML_NUTRIDIAG" 
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

v_Str := v_Str || '<NutritionalDiagnosis>' || LF;

v_Str := v_Str || '   <diagnosis>' || LF;

v_Str := v_Str || '        <label>BMI</label>'  || LF;
v_Str := v_Str || '        <title>Obesity (if BMI > 30 kg/m2)</title>'  || LF;
v_Str := v_Str || '        <value>' ||  Get_InfoPathData('Lab_Data_Obesity',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '        <managementPlan>' ||  Get_InfoPathData('Lab_Data_Plan_E1 +Lab_Data_Plan_E2 +Lab_Data_Plan_E3 +Lab_Data_Plan_E4 +Lab_Data_Plan_E5 +Lab_Data_Plan_M1 +Lab_Data_Plan_M2 +Lab_Data_Plan_M3 +Lab_Data_Plan_R1 +Lab_Data_Plan_R2',v_CaseId,'ST') || '</managementPlan>'  || LF;
v_Str := v_Str || '   </diagnosis>'|| LF;

v_Str := v_Str || '   <diagnosis>'|| LF;
v_Str := v_Str || '        <label>BMI</label>'  || LF;
v_Str := v_Str || '        <title>Morbid obesity (if BMI if > 39 kg/m2)</title>'  || LF;
v_Str := v_Str || '        <value>' ||  Get_InfoPathData('Lab_Data_Morbid_Obesity',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '        <managementPlan>' ||  Get_InfoPathData('Lab_Data_Plan_E1 +Lab_Data_Plan_E2 +Lab_Data_Plan_E3 +Lab_Data_Plan_E4 +Lab_Data_Plan_E5 +Lab_Data_Plan_M1 +Lab_Data_Plan_M2 +Lab_Data_Plan_M3 +Lab_Data_Plan_R1 +Lab_Data_Plan_R2',v_CaseId,'ST') || '</managementPlan>'  || LF;
v_Str := v_Str || '   </diagnosis>'|| LF;

v_Str := v_Str || '   <diagnosis>'|| LF;
v_Str := v_Str || '        <label>BMI</label>'  || LF;
v_Str := v_Str || '        <title>Malnutrition (mild to moderate) (BMI ? 18.5 with albumin &amp;lt; 3.5g/dl and unintentional weight loss > 10% in past 6 months.)</title>'  || LF;
v_Str := v_Str || '        <value>' ||  Get_InfoPathData('Lab_Data_Malnutrition',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '        <managementPlan>' ||  Get_InfoPathData('Lab_Data_Plan_E1 +Lab_Data_Plan_E2 +Lab_Data_Plan_E3 +Lab_Data_Plan_E4 +Lab_Data_Plan_E5 +Lab_Data_Plan_M1 +Lab_Data_Plan_M2 +Lab_Data_Plan_M3 +Lab_Data_Plan_R1 +Lab_Data_Plan_R2',v_CaseId,'ST') || '</managementPlan>'  || LF;
v_Str := v_Str || '   </diagnosis>'|| LF;

v_Str := v_Str || '   <diagnosis>'|| LF;
v_Str := v_Str || '        <label>BMI</label>'  || LF;
v_Str := v_Str || '        <title>Malnutrition (severe) (BMI ? 17.5 with documented poor calorie intake, weakness, debilitation, and signs of cachexia or severe muscle wasting on exam.)</title>'  || LF;
v_Str := v_Str || '        <value>' ||  Get_InfoPathData('Lab_Data_Malnutrition_Severe',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '        <managementPlan>' ||  Get_InfoPathData('Lab_Data_Plan_E1 +Lab_Data_Plan_E2 +Lab_Data_Plan_E3 +Lab_Data_Plan_E4 +Lab_Data_Plan_E5 +Lab_Data_Plan_M1 +Lab_Data_Plan_M2 +Lab_Data_Plan_M3 +Lab_Data_Plan_R1 +Lab_Data_Plan_R2',v_CaseId,'ST') || '</managementPlan>'  || LF;
v_Str := v_Str || '   </diagnosis>'|| LF;
v_Str := v_Str || '</NutritionalDiagnosis>' || LF;
------------------------------------


       RETURN v_Str;
       
       EXCEPTION WHEN OTHERS THEN
            v_Str := SUBSTR(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
                              CHR(13) ||
                              SQLERRM,1,4000); 
           
       END;

/

