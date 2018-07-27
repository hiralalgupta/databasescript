--------------------------------------------------------
--  DDL for Function MATRIX_XML_HEALTHMAINT
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SNX_IWS2"."MATRIX_XML_HEALTHMAINT" 
    (   P_CASEID  number   ,
        P_LF varchar2  ) 
    
    -- Created 10-6-2012 R Benzell
    -- called by GEN_MATRIX_XML
    -- Edited and completed 10-8-12 Denis
    
        RETURN CLOB
    
        IS
    

        v_Str CLOB;
        v_CaseId number;
        LF varchar2(5);
      
       
          
            BEGIN
                
      v_CaseId := P_CaseId;
      LF := P_LF;
        

-----------------------------------
v_Str := v_Str || '<HealthMaintenance>' || LF;

v_Str := v_Str || '   <lastPhysicalExam>' || LF;
v_Str := v_Str || '        <date>' ||  Get_InfoPathData('Health_Maintenance_Date',v_CaseId,'ST') || '</date>'  || LF;
v_Str := v_Str || '        <label>Date of Last Physical Exam</label>'  ||  LF;
v_Str := v_Str || '   </lastPhysicalExam>'  || LF;


v_Str := v_Str || '   <seeDoctorRegularly>'  || LF;
v_Str := v_Str || '    <title>Do you see a doctor regularly?</title>'  || LF;
v_Str := v_Str || '    <value>' ||  Get_InfoPathData('Health_Maintenance_Dr_Regularly',v_CaseId,'ST') || '</value>'  || LF;

v_Str := v_Str || '        <secondaryQuestions>' || LF;
v_Str := v_Str || '            <title>PCP</title>'  || LF;
v_Str := v_Str || '            <value>' ||  Get_InfoPathData('Health_Maintenance_PCP',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '        </secondaryQuestions>' || LF;
v_Str := v_Str || '        <secondaryQuestions>'  || LF;
v_Str := v_Str || '            <title>Specialist</title>'  || LF;
v_Str := v_Str || '            <value>' ||  Get_InfoPathData('Health_Maintenance_Specialist',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '        </secondaryQuestions>' || LF;
v_Str := v_Str || '   </seeDoctorRegularly>'  || LF;


v_Str := v_Str || '   <screenList>' || LF;
v_Str := v_Str || '        <title>Health maintenance</title>'  || LF;
v_Str := v_Str || '        <items>' || LF;
v_Str := v_Str || '            <title>LDL-C</title>'  || LF;
v_Str := v_Str || '            <comments>' ||  Get_InfoPathData('Health_Maintenance_LDL_Box',v_CaseId,'ST') || '</comments>'  || LF;
v_Str := v_Str || '            <commentsTitle>result, if known</commentsTitle>'  || LF;
v_Str := v_Str || '            <status>' ||  Get_InfoPathData('Health_Maintenance_LDL',v_CaseId,'ST') || '</status>'  || LF;
v_Str := v_Str || '            <date>' ||  Get_InfoPathData('Health_Maintenance_LDL_Date',v_CaseId,'ST') || '</date>'  || LF;
v_Str := v_Str || '        </items>' || LF;

v_Str := v_Str || '        <items>' || LF;
v_Str := v_Str || '            <title>Flu vaccine</title>'  || LF;
v_Str := v_Str || '            <comments/>'  || LF;
v_Str := v_Str || '            <commentsTitle></commentsTitle>'  || LF;
v_Str := v_Str || '            <status>' || Get_InfoPathData('Health_Maintenance_Flu',v_CaseId,'ST') || '</status>'  || LF;
v_Str := v_Str || '            <date>' ||  Get_InfoPathData('Health_Maintenance_Flu_Date',v_CaseId,'ST') || '</date>'  || LF;
v_Str := v_Str || '        </items>' || LF;

v_Str := v_Str || '        <items>' || LF;
v_Str := v_Str || '            <title>Pneumonia Vaccine (no date needed)</title>'  || LF;
v_Str := v_Str || '            <comments/>' || LF;
v_Str := v_Str || '            <commentsTitle/>'  || LF;
v_Str := v_Str || '            <status>' ||  Get_InfoPathData('Health_Maintenance_Pneumonia',v_CaseId,'ST') || '</status>'  || LF;
v_Str := v_Str || '            <date/>'  || LF;
--v_Str := v_Str || '            <notesList>' ||  Get_InfoPathData('Health_Maintenance_Pneumonia',v_CaseId,'ST') || '</notesList>'  || LF;
v_Str := v_Str || '        </items>' || LF;

v_Str := v_Str || '        <items>' || LF;
v_Str := v_Str || '            <title>Spirometry (for COPD dx, age>40)</title>'  || LF;
v_Str := v_Str || '            <comments>' ||  Get_InfoPathData('Health_Maintenance_Spirometry_Box',v_CaseId,'ST') || '</comments>'  || LF;
v_Str := v_Str || '            <commentsTitle>Dr.</commentsTitle>'  || LF;
v_Str := v_Str || '            <status>' ||  Get_InfoPathData('Health_Maintenance_Spirometry',v_CaseId,'ST') || '</status>'  || LF;
v_Str := v_Str || '            <date>' ||  Get_InfoPathData('Health_Maintenance_Spirometry_Date',v_CaseId,'ST') || '</date>'  || LF;
--v_Str := v_Str || '            <notesList>' ||  Get_InfoPathData('Health_Maintenance_Spirometry_Date',v_CaseId,'ST') || '</notesList>'  || LF;
v_Str := v_Str || '        </items>' || LF;

v_Str := v_Str || '        <items>' || LF;
v_Str := v_Str || '            <title>Eye exam for glaucoma by specialist (age>=65)</title>'  || LF;
v_Str := v_Str || '            <comments>' ||  Get_InfoPathData('Health_Maintenance_Eye_Box',v_CaseId,'ST') || '</comments>'  || LF;
v_Str := v_Str || '            <commentsTitle>Dr.</commentsTitle>'  || LF;
v_Str := v_Str || '            <status>' ||  Get_InfoPathData('Health_Maintenance_Eye',v_CaseId,'ST') || '</status>'  || LF;
v_Str := v_Str || '            <date>' ||  Get_InfoPathData('Health_Maintenance_Eye_Date',v_CaseId,'ST') || '</date>'  || LF;
--v_Str := v_Str || '            <notesList>' ||  Get_InfoPathData('Health_Maintenance_Eye_Date',v_CaseId,'ST') || '</notesList>'  || LF;
v_Str := v_Str || '        </items>' || LF;

v_Str := v_Str || '        <items>' || LF;
v_Str := v_Str || '            <title>Eye exam by specialist</title>'  || LF;
v_Str := v_Str || '            <comments>' ||  Get_InfoPathData('Health_Maintenance_Eye_Specialist_Box',v_CaseId,'ST') || '</comments>'  || LF;
v_Str := v_Str || '            <commentsTitle>Dr.</commentsTitle>'  || LF;
v_Str := v_Str || '            <status>' ||  Get_InfoPathData('Health_Maintenance_Eye_Specialist',v_CaseId,'ST') || '</status>'  || LF;
v_Str := v_Str || '            <date>' ||  Get_InfoPathData('Health_Maintenance_Eye_Specialist_Date',v_CaseId,'ST') || '</date>'  || LF;
v_Str := v_Str || '        </items>' || LF;

v_Str := v_Str || '   </screenList>' || LF;

v_Str := v_Str || '   <screenList>' || LF;

v_Str := v_Str || '        <title>WOMEN</title>'  || LF;

v_Str := v_Str || '        <items>' ||  LF;
v_Str := v_Str || '            <title>Mammogram (age 40-49)</title>'  || LF;
v_Str := v_Str || '            <comments>' ||  Get_InfoPathData('Health_Maintenance_Mammogram_Box',v_CaseId,'ST') || '</comments>'  || LF;
v_Str := v_Str || '            <commentsTitle>Dr.</commentsTitle>'  || LF;
v_Str := v_Str || '            <status>' ||  Get_InfoPathData('Health_Maintenance_Mammogram',v_CaseId,'ST') || '</status>'  || LF;
v_Str := v_Str || '            <date>' ||  Get_InfoPathData('Health_Maintenance_Mammogram_Date',v_CaseId,'ST') || '</date>'  || LF;
v_Str := v_Str || '        </items>' ||  LF;

v_Str := v_Str || '        <items>' ||  LF;
v_Str := v_Str || '            <title>History of Mastectomy</title>'  || LF;
v_Str := v_Str || '            <comments/>'  || LF;
v_Str := v_Str || '            <commentsTitle/>'  || LF;
v_Str := v_Str || '            <status>' ||  Get_InfoPathData('Health_Maintenance_Mastectomy',v_CaseId,'ST') || '</status>'  || LF;
v_Str := v_Str || '            <date>' ||  Get_InfoPathData('Health_Maintenance_Mastectomy_Date',v_CaseId,'ST') || '</date>'  || LF;

v_Str := v_Str || '            <notesList>' || LF;
v_Str := v_Str || '                  <title>R</title>'  || LF;
v_Str := v_Str || '                  <value>' ||  Get_InfoPathData('Health_Maintenance_Mastectomy_R',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '            </notesList>' || LF;
v_Str := v_Str || '            <notesList>' || LF;
v_Str := v_Str || '                  <title>L</title>'  || LF;
v_Str := v_Str || '                  <value>' ||  Get_InfoPathData('Health_Maintenance_Mastectomy_L',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '            </notesList>' || LF;
v_Str := v_Str || '            <notesList>' || LF;
v_Str := v_Str || '                  <title>Bilateral</title>'  || LF;
v_Str := v_Str || '                  <value>' ||  Get_InfoPathData('Health_Maintenance_Mastectomy_Bi',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '            </notesList>' || LF;

v_Str := v_Str || '        </items>' ||  LF;

v_Str := v_Str || '        <items>' ||  LF;
v_Str := v_Str || '            <title>Bone density test</title>'  || LF;
v_Str := v_Str || '            <comments>' ||  Get_InfoPathData('Health_Maintenance_Bone_Box',v_CaseId,'ST') || '</comments>'  || LF;
v_Str := v_Str || '            <commentsTitle>Dr.</commentsTitle>'  || LF;
v_Str := v_Str || '            <status>' ||  Get_InfoPathData('Health_Maintenance_Bone',v_CaseId,'ST') || '</status>'  || LF;
v_Str := v_Str || '            <date>' ||  Get_InfoPathData('Health_Maintenance_Bone_Date',v_CaseId,'ST') || '</date>'  || LF;
v_Str := v_Str || '        </items>' ||  LF;

v_Str := v_Str || '   </screenList>' || LF;

v_Str := v_Str || '   <screenList>' || LF;

v_Str := v_Str || '        <desc>Check all drug monitoring that applies</desc>'  || LF;
v_Str := v_Str || '        <title>Drug Monitoring</title>'  || LF;

v_Str := v_Str || '        <items>' || LF;
v_Str := v_Str || '            <title>ACEI/ARB/digoxin/diuretics(K, BUN/creatinine</title>'  || LF;
v_Str := v_Str || '            <comments/>' || LF;
v_Str := v_Str || '            <commentsTitle/>' || LF;
v_Str := v_Str || '            <status>' ||  Get_InfoPathData('Health_Maintenance_ACEI',v_CaseId,'ST') || '</status>'  || LF;
v_Str := v_Str || '            <date>' ||  Get_InfoPathData('Health_Maintenance_ACEI_Date',v_CaseId,'ST') || '</date>'  || LF;
v_Str := v_Str || '        </items>' || LF;

v_Str := v_Str || '        <items>' || LF;
v_Str := v_Str || '            <title>anticonvulsants(levels)</title>'  || LF;
v_Str := v_Str || '            <comments/>' || LF;
v_Str := v_Str || '            <commentsTitle/>'  || LF;
v_Str := v_Str || '            <status>' ||  Get_InfoPathData('Health_Maintenance_Anticonvultsants',v_CaseId,'ST') || '</status>'  || LF;
v_Str := v_Str || '            <date>' ||  Get_InfoPathData('Health_Maintenance_Anticonvultsants_Date',v_CaseId,'ST') || '</date>'  || LF;
v_Str := v_Str || '        </items>' || LF;

v_Str := v_Str || '        <items>' || LF;
v_Str := v_Str || '            <title>statins</title>'  || LF;
v_Str := v_Str || '            <comments/>' || LF;
v_Str := v_Str || '            <commentsTitle/>'  || LF;
v_Str := v_Str || '            <status>' ||  Get_InfoPathData('Health_Maintenance_Statins',v_CaseId,'ST') || '</status>'  || LF;
v_Str := v_Str || '            <date>' ||  Get_InfoPathData('Health_Maintenance_Statins_Date',v_CaseId,'ST') || '</date>'  || LF;
v_Str := v_Str || '            <notesList>' || LF;
v_Str := v_Str || '                  <title>Lipid Levels</title>'  || LF;
v_Str := v_Str || '                  <value>' ||  Get_InfoPathData('Health_Maintenance_Statins_Lipid',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '            </notesList>' || LF;
v_Str := v_Str || '            <notesList>' || LF;
v_Str := v_Str || '                  <title>LFTs</title>'  || LF;
v_Str := v_Str || '                  <value>' ||  Get_InfoPathData('Health_Maintenance_Statins_LFT',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '            </notesList>' || LF;
v_Str := v_Str || '        </items>' || LF;

v_Str := v_Str || '        <items>' || LF;
v_Str := v_Str || '            <title>anticoagulants (PT/INR)</title>'  || LF;
v_Str := v_Str || '            <comments/>' || LF;
v_Str := v_Str || '            <commentsTitle/>'  || LF;
v_Str := v_Str || '            <status>' ||  Get_InfoPathData('Health_Maintenance_Anticoag',v_CaseId,'ST') || '</status>'  || LF;
v_Str := v_Str || '            <date>' ||  Get_InfoPathData('Health_Maintenance_Anticoag_Date',v_CaseId,'ST') || '</date>'  || LF;
v_Str := v_Str || '        </items>' || LF;

v_Str := v_Str || '   </screenList>' || LF;

v_Str := v_Str || '   <screenList>' || LF;

v_Str := v_Str || '        <title>Colon CA Screen</title>'  || LF;

v_Str := v_Str || '        <items>' || LF;
v_Str := v_Str || '            <title>Colonoscopy</title>'  || LF;
v_Str := v_Str || '            <comments>' ||  Get_InfoPathData('Health_Maintenance_Colon_Colonoscopy_Box',v_CaseId,'ST') || '</comments>'  || LF;
v_Str := v_Str || '            <commentsTitle>Dr.</commentsTitle>'  || LF;
v_Str := v_Str || '            <status>' ||  Get_InfoPathData('Health_Maintenance_Colon_Colonoscopy',v_CaseId,'ST') || '</status>'  || LF;
v_Str := v_Str || '            <date>' ||  Get_InfoPathData('Health_Maintenance_Colon_Date',v_CaseId,'ST') || '</date>'  || LF;
v_Str := v_Str || '        </items>' || LF;

v_Str := v_Str || '        <items>' || LF;
v_Str := v_Str || '            <title>Sigmoidoscopy</title>'  || LF;
v_Str := v_Str || '            <comments>' ||  Get_InfoPathData('Health_Maintenance_Colon_Sigm_Box',v_CaseId,'ST') || '</comments>'  || LF;
v_Str := v_Str || '            <commentsTitle>Dr.</commentsTitle>'  || LF;
v_Str := v_Str || '            <status>' ||  Get_InfoPathData('Health_Maintenance_Colon_Sigm',v_CaseId,'ST') || '</status>'  || LF;
v_Str := v_Str || '            <date>' ||  Get_InfoPathData('Health_Maintenance_Colon_Sigm_date',v_CaseId,'ST') || '</date>'  || LF;
v_Str := v_Str || '        </items>' || LF;

v_Str := v_Str || '        <items>' || LF;
v_Str := v_Str || '            <title>Fecal Occult Blood Test</title>'  || LF;
v_Str := v_Str || '            <comments>' ||  Get_InfoPathData('Health_Maintenance_Colon_Fecal_Box',v_CaseId,'ST') || '</comments>'  || LF;
v_Str := v_Str || '            <commentsTitle>Dr.</commentsTitle>'  || LF;
v_Str := v_Str || '            <status>' ||  Get_InfoPathData('Health_Maintenance_Colon_Fecal',v_CaseId,'ST') || '</status>'  || LF;
v_Str := v_Str || '            <date>' ||  Get_InfoPathData('Health_Maintenance_Colon_Fecal_Date',v_CaseId,'ST') || '</date>'  || LF;
v_Str := v_Str || '        </items>' || LF;

v_Str := v_Str || '   </screenList>' || LF;

v_Str := v_Str || '</HealthMaintenance>' || LF;

------------------------------------

       RETURN v_Str;
       
       EXCEPTION WHEN OTHERS THEN
            v_Str := SUBSTR(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
                              CHR(13) ||
                              SQLERRM,1,4000); 
           
       END;

/

