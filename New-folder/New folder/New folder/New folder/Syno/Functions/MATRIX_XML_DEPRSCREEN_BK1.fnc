--------------------------------------------------------
--  DDL for Function MATRIX_XML_DEPRSCREEN_BK1
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SNX_IWS2"."MATRIX_XML_DEPRSCREEN_BK1" 
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
v_Str := v_Str || '   <sectionTitle>Repositioning in Chair or Bed Independent</sectionTitle>'  || LF;
v_Str := v_Str || '   <DepressionScreen>' || LF;
v_Str := v_Str || '   <sectionTitle>Treatment</sectionTitle>'  || LF;
v_Str := v_Str || '   <groupedQuestions>' ||  Get_InfoPathData('Depr_Screen_Treatment',v_CaseId,'ST') || LF;
v_Str := v_Str || '        <groupTitle>Unable to Complete due to:</groupTitle>'  || LF;
v_Str := v_Str || '        <questions>' || LF;
v_Str := v_Str || '            <Title>Unable to Complete due to:</Title>'  || LF;
v_Str := v_Str || '            <Value>' ||  Get_InfoPathData('Depr_Screen_Incomplete_Reason',v_CaseId,'ST') || '</Value>'  || LF;
v_Str := v_Str || '        </questions>' || LF;
v_Str := v_Str || '        <questions>' || LF;
v_Str := v_Str || '            <Title>Unable to Complete due to:</Title>'  || LF;
v_Str := v_Str || '            <Value>' ||  Get_InfoPathData('Depr_Screen_Incomplete_Reason',v_CaseId,'ST') || '</Value>'  || LF;
v_Str := v_Str || '        </questions>' || LF;
v_Str := v_Str || '        <questions>' || LF;
v_Str := v_Str || '            <Title>Unable to Complete due to:</Title>'  || LF;
v_Str := v_Str || '            <Value>' ||  Get_InfoPathData('Depr_Screen_Incomplete_Reason',v_CaseId,'ST') || '</Value>'  || LF;
v_Str := v_Str || '        </questions>' || LF;
v_Str := v_Str || '        <questions>' || LF;
v_Str := v_Str || '            <Title>Unable to Complete due to:</Title>'  || LF;
v_Str := v_Str || '            <Value>' ||  Get_InfoPathData('Depr_Screen_Incomplete_Reason',v_CaseId,'ST') || '</Value>'  || LF;
v_Str := v_Str || '        </questions>' || LF;
v_Str := v_Str || '    </groupedQuestions>'  || LF;
v_Str := v_Str || '    <ratingSection>'  || LF;
v_Str := v_Str || '        <sectionTitle>Over last 14 days, how often have you been bothered by…</sectionTitle>'  || LF;
v_Str := v_Str || '           <ratings>'  || LF;
v_Str := v_Str || '         <ratingTitle>Little interest or pleasure in doing things</ratingTitle>'  || LF;
v_Str := v_Str || '         <rating>' ||  Get_InfoPathData('Depr_Screen_Little_Interest',v_CaseId,'ST') || '</rating>'  || LF;
v_Str := v_Str || '           </ratings>'  || LF;
v_Str := v_Str || '           <ratings>'  || LF;
v_Str := v_Str || '         <ratingTitle>Feeling down, depressed or hopeless</ratingTitle>'  || LF;
v_Str := v_Str || '         <rating>' ||  Get_InfoPathData('Depr_Screen_Feeling_Down',v_CaseId,'ST') || '</rating>'  || LF;
v_Str := v_Str || '           </ratings>'  || LF;
v_Str := v_Str || '           <ratings>'  || LF;
v_Str := v_Str || '         <ratingTitle>Trouble falling asleep, staying asleep, or sleeping too much</ratingTitle>'  || LF;
v_Str := v_Str || '         <rating>' ||  Get_InfoPathData('Depr_Screen_Sleep',v_CaseId,'ST') || '</rating>'  || LF;
v_Str := v_Str || '           </ratings>'  || LF;
v_Str := v_Str || '           <ratings>'  || LF;
v_Str := v_Str || '         <ratingTitle>Feeling tired or having little energy</ratingTitle>'  || LF;
v_Str := v_Str || '         <rating>' ||  Get_InfoPathData('Depr_Screen_Energy',v_CaseId,'ST') || '</rating>'  || LF;
v_Str := v_Str || '           </ratings>'  || LF;
v_Str := v_Str || '           <ratings>'  || LF;
v_Str := v_Str || '         <ratingTitle>Poor appetite or overeating</ratingTitle>'  || LF;
v_Str := v_Str || '         <rating>' ||  Get_InfoPathData('Depr_Screen_Appetite',v_CaseId,'ST') || '</rating>'  || LF;
v_Str := v_Str || '           </ratings>'  || LF;
v_Str := v_Str || '           <ratings>'  || LF;
v_Str := v_Str || '         <ratingTitle>Feeling bad about yourself, feeling that your are a failure, or feeling that you have let yourself or your family down</ratingTitle>'  || LF;
v_Str := v_Str || '         <rating>' ||  Get_InfoPathData('Depr_Screen_Feeling_Bad',v_CaseId,'ST') || '</rating>'  || LF;
v_Str := v_Str || '           </ratings>'  || LF;
v_Str := v_Str || '           <ratings>'  || LF;
v_Str := v_Str || '         <ratingTitle>Trouble concentrating on such things as reading the newspaper or watching TV</ratingTitle>'  || LF;
v_Str := v_Str || '         <rating>' ||  Get_InfoPathData('Depr_Screen_Concentration',v_CaseId,'ST') || '</rating>'  || LF;
v_Str := v_Str || '           </ratings>'  || LF;
v_Str := v_Str || '           <ratings>'  || LF;
v_Str := v_Str || '         <ratingTitle>Moving or speaking so slowly that other people could have noticed, or being so fidgety or restless that you have moving around a lot more than usual</ratingTitle>'  || LF;
v_Str := v_Str || '         <rating>' ||  Get_InfoPathData('Depr_Screen_Abnormal',v_CaseId,'ST') || '</rating>'  || LF;
v_Str := v_Str || '           </ratings>'  || LF;
v_Str := v_Str || '        <phq85TotalScore>' ||  Get_InfoPathData('Depr_Screen_Severity_Score',v_CaseId,'ST') || '</phq85TotalScore>'  || LF;
v_Str := v_Str || '        </ratingSection>'  || LF;
v_Str := v_Str || '        <section1Questions>'  || LF;
v_Str := v_Str || '           <groupTitle>'  || || '</groupTitle>' || LF;
v_Str := v_Str || '           <questions>'  || LF;
v_Str := v_Str || '         <title>Does patient have a history of the diagnosis of a mixed disorder? (bipolar disease or manic depression)?</title>'  || LF;
v_Str := v_Str || '         <value>' ||  Get_InfoPathData('Depr_Screen_History',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '           </questions>'  || LF;
v_Str := v_Str || '           <questions>'  || LF;
v_Str := v_Str || '         <title>Are patient~s symptoms directly due to medication, substance abuse, or an untreated medical condition (such as hypothyroidism)?</title>'  || LF;
v_Str := v_Str || '         <value>' ||  Get_InfoPathData('Depr_Screen_Due_to_Meds',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '           </questions>'  || LF;
v_Str := v_Str || '        <managementPlan>' ||  Get_InfoPathData('Depr_Screen_Due_to_Meds',v_CaseId,'ST') || '</managementPlan>'  || LF;
v_Str := v_Str || '        </section1Questions>'  || LF;
v_Str := v_Str || '        <section2Questions>'  || LF;
v_Str := v_Str || '           <groupTitle>'  || || '</groupTitle>' || LF;
v_Str := v_Str || '           <questions>'  || LF;
v_Str := v_Str || '         <title>Do the patient~s symptoms cause significant distress or impairment?</title>'  || LF;
v_Str := v_Str || '         <value>' ||  Get_InfoPathData('Depr_Screen_Distress',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '           </questions>'  || LF;
v_Str := v_Str || '           <questions>'  || LF;
v_Str := v_Str || '         <title>Does the patient have at least 5 scores in the shaded area on the Depression screen above included at least one of the for question 1 or 2?</title>'  || LF;
v_Str := v_Str || '         <value>' ||  Get_InfoPathData('Depr_Screen_Score_5',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '           </questions>'  || LF;
v_Str := v_Str || '        <managementPlan>' ||  Get_InfoPathData('Depr_Screen_PHQ_Plan_M1                        Depr_Screen_PHQ_Plan_M2                      Depr_Screen_PHQ_Plan_M3                       Depr_Screen_PHQ_Plan_R1                        Depr_Screen_PHQ_Plan_R2                        Depr_Screen_PHQ_Plan_E1                        Depr_Screen_PHQ_Plan_E2                       Depr_Screen_PHQ_Plan_E3                        Depr_Screen_PHQ_Plan_E4                        Depr_Screen_PHQ_Plan_E5',v_CaseId,'ST') || '</managementPlan>'  || LF;
v_Str := v_Str || '        </section2Questions>'  || LF;
v_Str := v_Str || '        <section3Questions>'  || LF;
v_Str := v_Str || '           <groupTitle>'  || || '</groupTitle>' || LF;
v_Str := v_Str || '           <questions>'  || LF;
v_Str := v_Str || '         <title>Does the patient have a history of hospitalization for severe depression?</title>'  || LF;
v_Str := v_Str || '         <value>' ||  Get_InfoPathData('Depr_Screen_Hosp_Depr',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '           </questions>'  || LF;
v_Str := v_Str || '           <questions>'  || LF;
v_Str := v_Str || '         <title>Have one or more attempts to stop anti-depressant medication led to severe relapse of depression?</title>'  || LF;
v_Str := v_Str || '         <value>' ||  Get_InfoPathData('Depr_Screen_Lapse_Depr',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '           </questions>'  || LF;
v_Str := v_Str || '           <questions>'  || LF;
v_Str := v_Str || '         <title>For this patient taking medication to treat depression, the answer to (c) or (d) is Yes. This patient meets the criteria and has the diagnosis of major depression</title>'  || LF;
v_Str := v_Str || '         <value>' ||  Get_InfoPathData('Depr_Screen_Major_Depr',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '           </questions>'  || LF;
v_Str := v_Str || '        <managementPlan>' ||  Get_InfoPathData('Depr_Screen_Major_Depr_Plan_M1                        Depr_Screen_Major_Depr_Plan_M2                      Depr_Screen_Major_Depr_Plan_M3                       Depr_Screen_Major_Depr_Plan_R1                        Depr_Screen_Major_Depr_Plan_R2                        Depr_Screen_Major_Depr_Plan_E1                        Depr_Screen_Major_Depr_Plan_E2                       Depr_Screen_Major_Depr_Plan_E3                        Depr_Screen_Major_Depr_Plan_E4                        Depr_Screen_Major_Depr_Plan_E5',v_CaseId,'ST') || '</managementPlan>'  || LF;
v_Str := v_Str || '        </section3Questions>'  || LF;
v_Str := v_Str || '        <section4Questions>'  || LF;
v_Str := v_Str || '           <groupTitle>'  || || '</groupTitle>' || LF;
v_Str := v_Str || '           <questions>'  || LF;
v_Str := v_Str || '         <title>If the patient does not meet the criteria above for the diagnosis of major depression, but has a risk score ? 5 takes medication to treat depression, then the patient meets the criteria for the diagnosis of depression.</title>'  || LF;
v_Str := v_Str || '         <value>' ||  Get_InfoPathData('Depr_Screen_Depr',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '           </questions>'  || LF;
v_Str := v_Str || '        <managementPlan>' ||  Get_InfoPathData('Depr_Screen_Depr_Plan_M1                        Depr_Screen_Depr_Plan_M2                      Depr_Screen_Depr_Plan_M3                       Depr_Screen_Depr_Plan_R1                        Depr_Screen_Depr_Plan_R2                        Depr_Screen_Depr_Plan_E1                        Depr_Screen_Depr_Plan_E2                       Depr_Screen_Depr_Plan_E3                        Depr_Screen_Depr_Plan_E4                        Depr_Screen_Depr_Plan_E5',v_CaseId,'ST') || '</managementPlan>'  || LF;
v_Str := v_Str || '        </section4Questions>'  || LF;
v_Str := v_Str || '   </DepressionScreen>' || LF;



------------------------------------


       RETURN v_Str;
       
       EXCEPTION WHEN OTHERS THEN
            v_Str := SUBSTR(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
                              CHR(13) ||
                              SQLERRM,1,4000);
           
       END;

/

