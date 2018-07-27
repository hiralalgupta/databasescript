--------------------------------------------------------
--  DDL for Function MATRIX_XML_FUNCSTATUS
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SNX_IWS2"."MATRIX_XML_FUNCSTATUS" 
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

v_Str := v_Str || '  <FunctionalStatus>' || LF; 
v_Str := v_Str || '   <adlAssist>' || LF;
v_Str := v_Str || '        <sectionTitle>ADL Assist</sectionTitle>'  || LF;
v_Str := v_Str || '        <sectionDesc>' ||  Get_InfoPathData('none',v_CaseId,'ST') || '</sectionDesc>'  || LF;
v_Str := v_Str || '        <groupedQuestions>' || LF; 
v_Str := v_Str || '            <groupTitle>Ambulation</groupTitle>'  || LF;
v_Str := v_Str || '            <questions>' || LF;
v_Str := v_Str || '                  <title>Cane</title>'  || LF;
v_Str := v_Str || '                  <value>' ||  Get_InfoPathData('ADL_Ambulation_Cane',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '            </questions>' || LF;
v_Str := v_Str || '            <questions>' || LF;
v_Str := v_Str || '                  <title>Walker</title>'  || LF;
v_Str := v_Str || '                  <value>' ||  Get_InfoPathData('ADL_Ambulation_Walker',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '            </questions>' || LF;
v_Str := v_Str || '            <questions>' || LF;
v_Str := v_Str || '                  <title>Wheel Chair</title>'  || LF;
v_Str := v_Str || '                  <value>' ||  Get_InfoPathData('ADL_Ambulation_WC',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '            </questions>' || LF;
v_Str := v_Str || '            <questions>' || LF;
v_Str := v_Str || '                  <title>Geri-Chair</title>'  || LF;
v_Str := v_Str || '                  <value>' ||  Get_InfoPathData('ADL_Ambulation_Geri_Chair',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '            </questions>' || LF;
v_Str := v_Str || '            <questions>' || LF;
v_Str := v_Str || '                  <title>Bed bound</title>'  || LF;
v_Str := v_Str || '                  <value>' ||  Get_InfoPathData('ADL_Ambulation_Bed',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '            </questions>' || LF;
v_Str := v_Str || '        </groupedQuestions>' || LF; 
v_Str := v_Str || '        <groupedQuestions>' || LF; 
v_Str := v_Str || '            <groupTitle>Toileting</groupTitle>'  || LF;
v_Str := v_Str || '            <questions>' || LF;
v_Str := v_Str || '                  <title>Colostomy</title>'  || LF;
v_Str := v_Str || '                  <value>' ||  Get_InfoPathData('ADL_Toilet_Colostomy',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '            </questions>' || LF;
v_Str := v_Str || '            <questions>' || LF;
v_Str := v_Str || '                  <title>Ileostomy</title>'  || LF;
v_Str := v_Str || '                  <value>' ||  Get_InfoPathData('ADL_Toilet_Ileostomy',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '            </questions>' || LF;
v_Str := v_Str || '            <questions>' || LF;
v_Str := v_Str || '                  <title>Foley Cath.</title>'  || LF;
v_Str := v_Str || '                  <value>' ||  Get_InfoPathData('ADL_Toilet_Foley',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '            </questions>' || LF;
v_Str := v_Str || '            <questions>' || LF;
v_Str := v_Str || '                  <title>Suprapubic Cath</title>'  || LF;
v_Str := v_Str || '                  <value>' ||  Get_InfoPathData('ADL_Toilet_Suprapublic',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '            </questions>' || LF;
v_Str := v_Str || '            <questions>' || LF;
v_Str := v_Str || '                  <title>Protective Undergarments</title>'  || LF;
v_Str := v_Str || '                  <value>' ||  Get_InfoPathData('ADL_Toilet_Briefs',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '            </questions>' || LF;
v_Str := v_Str || '        </groupedQuestions>' || LF; 
v_Str := v_Str || '        <groupedQuestions>' || LF; 
v_Str := v_Str || '            <groupTitle>Feeding</groupTitle>'  || LF;
v_Str := v_Str || '            <questions>' || LF;
v_Str := v_Str || '                  <title>Fed</title>'  || LF;
v_Str := v_Str || '                  <value>' ||  Get_InfoPathData('ADL_Feeding_Fed',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '            </questions>' || LF;
v_Str := v_Str || '            <questions>' || LF;
v_Str := v_Str || '                  <title>Peg</title>'  || LF;
v_Str := v_Str || '                  <value>' ||  Get_InfoPathData('ADL_Feeding_Peg',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '            </questions>' || LF;
v_Str := v_Str || '            <questions>' || LF;
v_Str := v_Str || '                  <title>Ng</title>'  || LF;
v_Str := v_Str || '                  <value>' ||  Get_InfoPathData('ADL_Feeding_Ng',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '            </questions>' || LF;
v_Str := v_Str || '            <questions>' || LF;
v_Str := v_Str || '                  <title>TPN</title>'  || LF;
v_Str := v_Str || '                  <value>' ||  Get_InfoPathData('ADL_Feeding_TPN',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '            </questions>' || LF;
v_Str := v_Str || '        </groupedQuestions>' || LF; 
v_Str := v_Str || '        <groupedQuestions>' || LF; 
v_Str := v_Str || '            <groupTitle>Transfers</groupTitle>'  || LF;
v_Str := v_Str || '            <questions>' || LF;
v_Str := v_Str || '                  <title>Transfer Board</title>'  || LF;
v_Str := v_Str || '                  <value>' ||  Get_InfoPathData('ADL_Transfer_Board',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '            </questions>' || LF;
v_Str := v_Str || '            <questions>' || LF;
v_Str := v_Str || '                  <title>Lift</title>'  || LF;
v_Str := v_Str || '                  <value>' ||  Get_InfoPathData('ADL_Transfer_Lift',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '            </questions>' || LF;
v_Str := v_Str || '            <questions>' || LF;
v_Str := v_Str || '                  <title>Assist 1 person/2 person</title>'  || LF;
v_Str := v_Str || '                  <value>' ||  Get_InfoPathData('ADL_Transfer_Assist',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '            </questions>' || LF;
v_Str := v_Str || '        </groupedQuestions>' || LF;
v_Str := v_Str || '   </adlAssist>' || LF;
v_Str := v_Str || '        <Status>' || LF;
v_Str := v_Str || '         <title>Functional Status - Modified Katz Basic Activities of Daily Living</title>'  || LF;
v_Str := v_Str || '         <value>' ||  Get_InfoPathData('none',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '            <questions>' || LF;
v_Str := v_Str || '                  <title>Bathing (Sponge bath, tub bath, or shower) Independent?</title>'  || LF;
v_Str := v_Str || '                  <value>' ||  Get_InfoPathData('Functional_Status_Bathing',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '            </questions>' || LF;
v_Str := v_Str || '            <questions> '|| LF;
v_Str := v_Str || '                  <title>Dressing</title>'  || LF;
v_Str := v_Str || '                  <value>' ||  Get_InfoPathData('Functional_Status_Dressing',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '            </questions>' || LF;
v_Str := v_Str || '            <questions>'|| LF;
v_Str := v_Str || '                  <title>Toileting</title>'  || LF;
v_Str := v_Str || '                  <value>' ||  Get_InfoPathData('Functional_Status_Toileting',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '            </questions>' || LF;
v_Str := v_Str || '            <questions>' || LF;
v_Str := v_Str || '                  <title>Transferring</title>'  || LF;
v_Str := v_Str || '                  <value>' ||  Get_InfoPathData('Functional_Status_Transferring',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '            </questions>' || LF;
v_Str := v_Str || '            <questions>' || LF;
v_Str := v_Str || '                  <title>Continence</title>'  || LF;
v_Str := v_Str || '                  <value>' ||  Get_InfoPathData('Functional_Status_Continence',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '            </questions>' || LF;
v_Str := v_Str || '            <questions>' || LF;
v_Str := v_Str || '                  <title>Feeding</title>'  || LF;
v_Str := v_Str || '                  <value>' ||  Get_InfoPathData('Functional_Status_Feeding',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '            </questions>' || LF;
v_Str := v_Str || '            <questions>' || LF;
v_Str := v_Str || '                  <title>Repositioning in Chair or Bed Independent</title>'  || LF;
v_Str := v_Str || '                  <value>' ||  Get_InfoPathData('Functional_Status_Repositioning',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '            </questions> '|| LF;
v_Str := v_Str || '        </Status>' || LF;
v_Str := v_Str || '  </FunctionalStatus>' || LF; 



------------------------------------


       RETURN v_Str;
       
       EXCEPTION WHEN OTHERS THEN
            v_Str := SUBSTR(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
                              CHR(13) ||
                              SQLERRM,1,4000); 
           
       END;

/

