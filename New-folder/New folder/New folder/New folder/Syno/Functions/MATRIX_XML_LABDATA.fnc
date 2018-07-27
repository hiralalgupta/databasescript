--------------------------------------------------------
--  DDL for Function MATRIX_XML_LABDATA
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SNX_IWS2"."MATRIX_XML_LABDATA" 
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
v_Str := v_Str || '  <LabData>'  || LF;
v_Str := v_Str || '   <review>' || LF;
v_Str := v_Str || '    <title>No lab data available</title>'  || LF;
v_Str := v_Str || '    <value>' ||  Get_InfoPathData('Lab_Data_No_Data',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '   </review>' || LF;
v_Str := v_Str || '   <labTests>' || LF;
v_Str := v_Str || '    <units>' ||  Get_InfoPathData('',v_CaseId,'ST') || '</units>'  || LF;
v_Str := v_Str || '    <title>Bun</title>'  || LF;
v_Str := v_Str || '    <result>' ||  Get_InfoPathData('Lab_Data_Bun_1',v_CaseId,'ST') || '</result>'  || LF;
v_Str := v_Str || '    <date>' ||  Get_InfoPathData('Lab_Data_Bun_Date',v_CaseId,'ST') || '</date>'  || LF;
v_Str := v_Str || '   </labTests>'  || LF;
v_Str := v_Str || '   <labTests>' || LF;
v_Str := v_Str || '    <units>' || '' || '</units>'  || LF;
v_Str := v_Str || '    <title>Creatinine</title>'  || LF;
v_Str := v_Str || '    <result>' ||  Get_InfoPathData('Lab_Data_Creatinine',v_CaseId,'ST') || '</result>'  || LF;
v_Str := v_Str || '    <date>' ||  Get_InfoPathData('Lab_Data_Creatinine_Date',v_CaseId,'ST') || '</date>'  || LF;
v_Str := v_Str || '   </labTests>' || LF;
v_Str := v_Str || '   <labTests>' || LF;
v_Str := v_Str || '    <units>' || '' || '</units>'  || LF;
v_Str := v_Str || '    <title>Estimated GFR</title>'  || LF;
v_Str := v_Str || '    <result>' ||  Get_InfoPathData('Lab_Data_GFR_1',v_CaseId,'ST') || '</result>'  || LF;
v_Str := v_Str || '    <date>' ||  Get_InfoPathData('Lab_Data_GFR_date_1',v_CaseId,'ST') || '</date>'  || LF;
v_Str := v_Str || '   </labTests>' || LF;
v_Str := v_Str || '   <labTests>' || LF;
v_Str := v_Str || '    <units>' || '' || '</units>'  || LF;
v_Str := v_Str || '    <title>Estimated GFR</title>'  || LF;
v_Str := v_Str || '    <result>' ||  Get_InfoPathData('Lab_Data_GFR_2',v_CaseId,'ST') || '</result>'  || LF;
v_Str := v_Str || '    <date>' ||  Get_InfoPathData('Lab_Data_GFR_date_2',v_CaseId,'ST') || '</date>'  || LF;
v_Str := v_Str || '   </labTests>' || LF;
v_Str := v_Str || '   <labTests>' || LF;
v_Str := v_Str || '    <units>' || '' || '</units>'  || LF;
v_Str := v_Str || '    <title>HbA1c</title>'  || LF;
v_Str := v_Str || '    <result>' ||  Get_InfoPathData('Lab_Data_HbA1c',v_CaseId,'ST') || '</result>'  || LF;
v_Str := v_Str || '    <date>' ||  Get_InfoPathData('Lab_Data_HbA1c_date',v_CaseId,'ST') || '</date>'  || LF;
v_Str := v_Str || '   </labTests>' || LF;
v_Str := v_Str || '   <labTests>' || LF;
v_Str := v_Str || '    <units>' || '' || '</units>'  || LF;
v_Str := v_Str || '    <title>Fasting Blood Sugar</title>'  || LF;
v_Str := v_Str || '    <result>' ||  Get_InfoPathData('Lab_Data_Fasting',v_CaseId,'ST') || '</result>'  || LF;
v_Str := v_Str || '    <date>' ||  Get_InfoPathData('Lab_Data_Fasting_date',v_CaseId,'ST') || '</date>'  || LF;
v_Str := v_Str || '   </labTests>' || LF;
v_Str := v_Str || '   <labTests>' || LF;
v_Str := v_Str || '    <units>' || '' || '</units>'  || LF;
v_Str := v_Str || '    <title>LDL-C</title>'  || LF;
v_Str := v_Str || '    <result>' ||  Get_InfoPathData('Lab_Data_LDL',v_CaseId,'ST') || '</result>'  || LF;
v_Str := v_Str || '    <date>' ||  Get_InfoPathData('Lab_Data_LDL_date',v_CaseId,'ST') || '</date>'  || LF;
v_Str := v_Str || '   </labTests>' || LF;
v_Str := v_Str || '   <labTests>' || LF;
v_Str := v_Str || '    <units>' || '' || '</units>'  || LF;
v_Str := v_Str || '    <title>Serum Albumin</title>'  || LF;
v_Str := v_Str || '    <result>' ||  Get_InfoPathData('Lab_Data_Serum_Albumin',v_CaseId,'ST') || '</result>'  || LF;
v_Str := v_Str || '    <date>' ||  Get_InfoPathData('Lab_Data_Serum_Albumin_Date',v_CaseId,'ST') || '</date>'  || LF;
v_Str := v_Str || '   </labTests>' || LF;
v_Str := v_Str || '   <labTests>' || LF;
v_Str := v_Str || '    <units>' || '' || '</units>'  || LF;
v_Str := v_Str || '    <title>Hgb</title>'  || LF;
v_Str := v_Str || '    <result>' ||  Get_InfoPathData('Lab_Data_Hgb',v_CaseId,'ST') || '</result>'  || LF;
v_Str := v_Str || '    <date>' ||  Get_InfoPathData('Lab_Data_Hgb_date',v_CaseId,'ST') || '</date>'  || LF;
v_Str := v_Str || '   </labTests>' || LF;
v_Str := v_Str || '   <labTests>' || LF;
v_Str := v_Str || '    <units>' || '' || '</units>'  || LF;
v_Str := v_Str || '    <title>Hct</title>'  || LF;
v_Str := v_Str || '    <result>' ||  Get_InfoPathData('Lab_Data_Hct',v_CaseId,'ST') || '</result>'  || LF;
v_Str := v_Str || '    <date>' ||  Get_InfoPathData('Lab_Data_Hct_date',v_CaseId,'ST') || '</date>'  || LF;
v_Str := v_Str || '   </labTests>' || LF;
v_Str := v_Str || '   <labTests>' || LF;
v_Str := v_Str || '    <units>' || '' || '</units>'  || LF;
v_Str := v_Str || '    <title>WBC</title>'  || LF;
v_Str := v_Str || '    <result>' ||  Get_InfoPathData('Lab_Data_WBC',v_CaseId,'ST') || '</result>'  || LF;
v_Str := v_Str || '    <date>' ||  Get_InfoPathData('Lab_Data_WBC_date',v_CaseId,'ST') || '</date>'  || LF;
v_Str := v_Str || '   </labTests>' || LF;
v_Str := v_Str || '   <labTests>' || LF;
v_Str := v_Str || '    <units>' || '' || '</units>'  || LF;
v_Str := v_Str || '    <title>Platelets</title>'  || LF;
v_Str := v_Str || '    <result>' ||  Get_InfoPathData('Lab_Data_Platelets',v_CaseId,'ST') || '</result>'  || LF;
v_Str := v_Str || '    <date>' ||  Get_InfoPathData('Lab_Data_Platelets_Date',v_CaseId,'ST') || '</date>'  || LF;
v_Str := v_Str || '   </labTests>' || LF;
v_Str := v_Str || '   <labTests>' || LF;
v_Str := v_Str || '    <units>' || '' || '</units>'  || LF;
v_Str := v_Str || '    <title>Platelets</title>'  || LF;
v_Str := v_Str || '    <result>' ||  Get_InfoPathData('Lab_Data_Slot',v_CaseId,'ST') || '</result>'  || LF;
v_Str := v_Str || '    <date>' ||  Get_InfoPathData('Lab_Data_Slot_date',v_CaseId,'ST') || '</date>'  || LF;
v_Str := v_Str || '   </labTests>' || LF;
v_Str := v_Str || '   <diagnosticTests>' || LF;
v_Str := v_Str || '    <units>' ||  Get_InfoPathData('',v_CaseId,'ST') || '</units>'  || LF;
v_Str := v_Str || '    <title>EKG</title>'  || LF;
v_Str := v_Str || '    <result>' ||  Get_InfoPathData('Lab_Diag_Ekg',v_CaseId,'ST') || '</result>'  || LF;
v_Str := v_Str || '    <date>' ||  Get_InfoPathData('Lab_Diag_Ekg_Date',v_CaseId,'ST') || '</date>'  || LF;
v_Str := v_Str || '   </diagnosticTests>' || LF;
v_Str := v_Str || '   <diagnosticTests>' || LF;
v_Str := v_Str || '    <units>' || '' || '</units>'  || LF;
v_Str := v_Str || '    <title>CXR</title>'  || LF;
v_Str := v_Str || '    <result>' ||  Get_InfoPathData('Lab_Diag_CXR',v_CaseId,'ST') || '</result>'  || LF;
v_Str := v_Str || '    <date>' ||  Get_InfoPathData('Lab_Diag_CXR_Date',v_CaseId,'ST') || '</date>'  || LF;
v_Str := v_Str || '   </diagnosticTests>' || LF;
v_Str := v_Str || '   <diagnosticTests>' || LF;
v_Str := v_Str || '    <units>' || '' || '</units>'  || LF;
v_Str := v_Str || '    <title>Echo</title>'  || LF;
v_Str := v_Str || '    <result>' ||  Get_InfoPathData('Lab_Diag_Echo',v_CaseId,'ST') || '</result>'  || LF;
v_Str := v_Str || '    <date>' ||  Get_InfoPathData('Lab_Diag_Echo_date',v_CaseId,'ST') || '</date>'  || LF;
v_Str := v_Str || '   </diagnosticTests>' || LF;
v_Str := v_Str || '   <diagnosticTests>' || LF;
v_Str := v_Str || '    <units>' || '' || '</units>'  || LF;
v_Str := v_Str || '    <title>MRI</title>'  || LF;
v_Str := v_Str || '    <result>' ||  Get_InfoPathData('Lab_Diag_MRI',v_CaseId,'ST') || '</result>'  || LF;
v_Str := v_Str || '    <date>' ||  Get_InfoPathData('Lab_Diag_MRI_date',v_CaseId,'ST') || '</date>'  || LF;
v_Str := v_Str || '   </diagnosticTests>' || LF;
v_Str := v_Str || '   <diagnosticTests>' || LF;
v_Str := v_Str || '    <units>' || '' || '</units>'  || LF;
v_Str := v_Str || '    <title>CT</title>'  || LF;
v_Str := v_Str || '    <result>' ||  Get_InfoPathData('Lab_Diag_CT',v_CaseId,'ST') || '</result>'  || LF;
v_Str := v_Str || '    <date>' ||  Get_InfoPathData('Lab_Diag_CT_date',v_CaseId,'ST') || '</date>'  || LF;
v_Str := v_Str || '   </diagnosticTests>' || LF;
v_Str := v_Str || '   <diagnosticTests>' || LF;
v_Str := v_Str || '    <units>' || '' || '</units>'  || LF;
v_Str := v_Str || '    <title>Other</title>'  || LF;
v_Str := v_Str || '    <result>' ||  Get_InfoPathData('Lab_Diag_Other',v_CaseId,'ST') || '</result>'  || LF;
v_Str := v_Str || '    <date>' ||  Get_InfoPathData('Lab_Diag_Other_date',v_CaseId,'ST') || '</date>'  || LF;
v_Str := v_Str || '   </diagnosticTests>' || LF;
v_Str := v_Str || '  </LabData>'  || LF;

------------------------------------


       RETURN v_Str;
       
       EXCEPTION WHEN OTHERS THEN
            v_Str := SUBSTR(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
                              CHR(13) ||
                              SQLERRM,1,4000); 
           
       END;

/

