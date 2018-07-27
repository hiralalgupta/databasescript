--------------------------------------------------------
--  DDL for Function MATRIX_XML_HEALTHBEHV
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SNX_IWS2"."MATRIX_XML_HEALTHBEHV" 
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

v_Str := v_Str || '   <HealthBehaviors>' || LF;

v_Str := v_Str || '   <physicalHealth>'  || LF;
v_Str := v_Str || '        <groupTitle>Compared to two years ago, my physical health is the:</groupTitle>'  || LF;
v_Str := v_Str || '        <value>' ||  Get_InfoPathData('Health_Behaviors_Physical_Better+Health_Behaviors_Physical_Same +Health_Behaviors_Physical_Worse',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '   </physicalHealth>'  || LF;

v_Str := v_Str || '   <mentalHealth>' || LF;
v_Str := v_Str || '        <groupTitle>Compared to two years ago, my mental health is the:</groupTitle>'  || LF;
v_Str := v_Str || '        <value>' ||  Get_InfoPathData('Health_Behaviors_Mental_Better + Health_Behaviors_Mental_Same + Health_Behaviors_Mental_Worse',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '   </mentalHealth>' || LF;

v_Str := v_Str || '   <exercise>' || LF;
v_Str := v_Str || '        <educated>' || LF;
v_Str := v_Str || '            <title>Educated patient about the importance of exercise.</title>'  || LF;
v_Str := v_Str || '            <value>' ||  Get_InfoPathData('Health_Behaviors_Educate',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '        </educated>' || LF;
v_Str := v_Str || '        <activityGoals>'  || LF;
v_Str := v_Str || '            <title>Set activity goals with the patient</title>'  || LF;
v_Str := v_Str || '            <value>' ||  Get_InfoPathData('Health_Behaviors_Goals',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '        </activityGoals>'  || LF;
v_Str := v_Str || '        <exerciseQuestion>' || LF;
v_Str := v_Str || '            <title>On average, how often do you exercise?</title>'  || LF;
v_Str := v_Str || '                  <items>' || LF;
v_Str := v_Str || '                    <label>days/week</label>'  || LF;
v_Str := v_Str || '                    <quantity>' ||  Get_InfoPathData('Health_Behaviors_Exercise_Days',v_CaseId,'ST') || '</quantity>'  || LF;
v_Str := v_Str || '                  </items>' || LF;
v_Str := v_Str || '                  <items>' || LF;
v_Str := v_Str || '                    <label>minutes at a time.</label>'  || LF;
v_Str := v_Str || '                    <quantity>' ||  Get_InfoPathData('Health_Behaviorsl_Exercise_Minutes',v_CaseId,'ST') || '</quantity>'  || LF;
v_Str := v_Str || '                  </items>' || LF;
v_Str := v_Str || '        </exerciseQuestion>' || LF;
v_Str := v_Str || '   </exercise>' || LF;

v_Str := v_Str || '   <drugUse>' || LF;
v_Str := v_Str || '        <currentUse>' || LF;
v_Str := v_Str || '            <title>Do you currently use any street drugs or take prescription medications that were not prescribed for you or take prescription medications in larger amounts than were prescribed?</title>'  || LF;
v_Str := v_Str || '            <value>' ||  Get_InfoPathData('Health_Behaviors_Drugs_Current',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '        </currentUse>' || LF;
v_Str := v_Str || '        <whatDrugs>'  || LF;
v_Str := v_Str || '            <title>What drugs/meds?</title>'  || LF;
v_Str := v_Str || '            <answer>' ||  Get_InfoPathData('Health_Behaviors_Drugs_Current_Box',v_CaseId,'ST') || '</answer>'  || LF;
v_Str := v_Str || '            <value>' ||  Get_InfoPathData('Health_Behaviors_Drugs_Current_Box',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '        </whatDrugs>'  || LF;

v_Str := v_Str || '        <educated>'  || LF;
v_Str := v_Str || '           <title>Educated the patient about risks of substance abuse.</title>'  || LF;
v_Str := v_Str || '           <value>' ||  Get_InfoPathData('Health_Behaviors_Drugs_Current_Educate',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '        </educated>'  || LF;
v_Str := v_Str || '        <refer>'   || LF;
v_Str := v_Str || '            <title>Refer for ongoing monitoring and care.</title>'  || LF;
v_Str := v_Str || '            <value>' ||  Get_InfoPathData('Health_Behaviors_Drugs_Current_Refer',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '        </refer>'   || LF;
v_Str := v_Str || '   </drugUse>' || LF;

v_Str := v_Str || '   <tobaccoUse>'  || LF;
v_Str := v_Str || '        <pastUse>' || LF;
v_Str := v_Str || '            <title>Have you ever smoked or chewed tobacco?</title>'  || LF;
v_Str := v_Str || '            <value>' ||  Get_InfoPathData('Health_Behaviors_Ever_Smoked',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '               <quantityGroup>' || LF;
v_Str := v_Str || '                  <title>What year did you quit?</title>'  || LF;
v_Str := v_Str || '                  <value>' ||  Get_InfoPathData('Health_Behaviors_Smoke_Quit',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '                       <items>' || LF;
v_Str := v_Str || '                         <label>(#packs/day)</label>'  || LF;
v_Str := v_Str || '                         <quantity>' ||  Get_InfoPathData('Health_Behaviors_Smoke_Packs',v_CaseId,'ST') || '</quantity>'  || LF;
v_Str := v_Str || '                       </items>' || LF;
v_Str := v_Str || '                       <items>' || LF;
v_Str := v_Str || '                         <label>(# years)</label>'  || LF;
v_Str := v_Str || '                         <quantity>' ||  Get_InfoPathData('Health_Behaviors_Smoke_Years',v_CaseId,'ST') || '</quantity>'  || LF;
v_Str := v_Str || '                       </items>' || LF;
v_Str := v_Str || '               </quantityGroup>' || LF;
v_Str := v_Str || '        </pastUse>' || LF;
v_Str := v_Str || '        <educated>' || LF;
v_Str := v_Str || '            <title>Advised patient to stop smoking and avoid tobacco</title>'  || LF;  
v_Str := v_Str || '            <value>' ||  Get_InfoPathData('Health_Behaviors_Smoke_Advised',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '        </educated>' || LF;
v_Str := v_Str || '        <discussedMedications>' ||  Get_InfoPathData('Health_Behaviors_Smoke_Cessation',v_CaseId,'ST') || '</discussedMedications>'  || LF;
v_Str := v_Str || '        <discussedStrategies>' ||  Get_InfoPathData('Health_Behaviors_Smoke_Cessation_Strategies',v_CaseId,'ST') || '</discussedStrategies>'  || LF;
v_Str := v_Str || '   </tobaccoUse>'  || LF;

v_Str := v_Str || '   <alcoholUse>'  || LF;
v_Str := v_Str || '        <currentUse>' || LF;
v_Str := v_Str || '            <title>Do you sometimes drink beer, wine or other alcoholic beverages?</title>'  || LF;
v_Str := v_Str || '            <value>' ||  Get_InfoPathData('Health_Behaviors_Alcohol',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '        </currentUse>' || LF;
v_Str := v_Str || '        <quantityDay>' ||  Get_InfoPathData('Health_Behaviors_Alcohol_Drinks',v_CaseId,'ST') || '</quantityDay>'  || LF;
v_Str := v_Str || '        <quantityWeek>' || LF;
v_Str := v_Str || '            <title>How many drinks of alcohol do you have per week?</title>'  || LF;
v_Str := v_Str || '            <value>' ||  Get_InfoPathData('Health_Behaviors_Alcohol_Drinks_4',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '        </quantityWeek>' || LF;
v_Str := v_Str || '        <educated>' || LF;
v_Str := v_Str || '            <title>Educated patient about risks of alcohol abuse.</title>'  || LF;
v_Str := v_Str || '            <value>' ||  Get_InfoPathData('Health_Behaviors_Alcohol_Educate',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '        </educated>' || LF;
v_Str := v_Str || '        <refer>' || LF;
v_Str := v_Str || '            <title>Refer for ongoing monitoring and care</title>'  || LF;
v_Str := v_Str || '            <value>' ||  Get_InfoPathData('Health_Behaviors_Alcohol_Refer',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '        </refer>' || LF;
v_Str := v_Str || '   </alcoholUse>'  || LF;

v_Str := v_Str || '   <stdRisk>' || LF;
v_Str := v_Str || '        <title>Are you at risk for HIV/AIDs or other sexually transmitted diseases?</title>'  || LF;
v_Str := v_Str || '        <value>' ||  Get_InfoPathData('Health_Behaviors_STD',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '   </stdRisk>' || LF;

v_Str := v_Str || '   <stdTested>' || LF;
v_Str := v_Str || '        <title>Have you been tested</title>'  || LF;
v_Str := v_Str || '        <value>' ||  Get_InfoPathData('Health_Behaviors_STD_Tested',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '   </stdTested>' || LF;

v_Str := v_Str || '   </HealthBehaviors>' || LF;
------------------------------------


       RETURN v_Str;
       
       EXCEPTION WHEN OTHERS THEN
            v_Str := SUBSTR(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
                              CHR(13) ||
                              SQLERRM,1,4000); 
           
       END;

/

