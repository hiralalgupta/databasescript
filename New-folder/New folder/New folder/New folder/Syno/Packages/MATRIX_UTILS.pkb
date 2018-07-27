create or replace
PACKAGE BODY MATRIX_UTILS
--- Update History
--- 10-11-2012 R Benzell - change all Date Fields to 'DT' format on Get_InfoPathData calls
--- 10-26-2012 R Benzell - Various corrections to Get_InfoPathData and 'MP' calls
--- 12-17-2012 R Benzell - updates to comply with XSD schema changes.
---                        Added <hcin>, removed unused ManagementPlans
---                        Consolidated <addendumMedications> into <currentMedications>
---                        Added <desc> to <ScreenList>
---                        Added <notesList> placeholders under <HealthMaintenance>
---                        Relocated <bladderControl> to top of <focusedSystemReview>
---                        Correct <extradata> to <extraData>  uppercase “D”
---                        Removed redundant <o2sat> field
---                        Removed   <bloodpressure>/<title> field  
---                        Added <pulseType> field (not mapped, no corresponding form fields)
---                        Added <secondaryQuestions> node to <weightLoss>
---                        Use <value> instead of <answer> in painscale
---                        <DiabeticScreen>, node <diagnosis>/<followupQuestions>:    Use <value> tag instead of <answer>
---                                          <diagnosis>/<secondaryQuestions>, added  <value> tag
---                        Added <groupedQuestions> placeholder in <providerAssessment>
-- 12-18-2012 R Benzell - dual-pathed PatientId content to HCIN
---                       renamed <advanceIllness> to <advancedIllness>
---                       <Othervalue> to <otherValue> 
--                        changed medicalHistoryDiagnosis to be element
-- 12-27-2012 R Benzell - corrected <houseSafety> spelling
--                        removed sunsetted <answer> from <whatDrugs>
--                        renamed <FunctionalStatus>/<Status> to <status>
--                        renamed <FocusedSystemReview> to <FocusedSystemReview>
--                        renamed <bladdercontrol> <bladderControl>
--                        changed Heart Attack/MI date to be <extraValues>/<value>
--                        remove blank secondaryQuestions just before "Ulnar Questions"
--                        altered "<NutrionalRisk>" to be a title/value
--                        relocated ManagementPlan that were under <NutritionalDiagnosis>
-- 1-2-2013 R Benzell     implemented <subDiagnosis> and </subDiagnosis> separation properly
--                        Changed <person> under <PCPMember> to be an enclosing tag      
--                        renamed <medicalHistorydiagnosis> to <medicalHistoryDiagnosis> and added <isChronicXml> child
--                        swapped location of <label> and <date> under Last Physical Exam
--                        Added "unable to complete" to FocusedReviewofSystem
--                        swapped locations of bmi and pulsetype
--                        moved <rating> to be under element <isCorrect>
--                        added missing  </subDiagnosis> under <title>Pathological Fracture Vertebra, 
--                        added missing </diagnosis> under  <title>Other Significant Diagnoses
--                        standardized to <followupQuestions>
--                        swapped <title> and <answer> under  "Arrhythmia Type:"
--                        removed duplicate managementPlan under 'above knee' and 'knee'
--                        deactivated <signature64>
-- 1-3-2013 R Benzell     renamed and relocated <medicationReview> to <medicineReviewed>
--                        removed <printedName>
--                        under <medicalHistoryDiagnosis>, added <history> and <historyType>, populate with Medical_History_Diagnosis
-- 1-31-2013 R Benzell    changed <followupQuestions> to <followUpQuestions>
--                        Under <FallRisk> change <total> back to <totalTitle>
--                        reinserted blank <npMemberInfo> 
-- 2-20-2013 R Benzell    Adjustements based on Matrix 2-14 feedback:    
--                        reverted to <followupQuestions> (rolled back from <followUpQuestions>)  
--                        reverted to <isChronicXml> (rolled back from <isChronic>)
--                        implemented <quantityWeek>/<label>How many drinks of alcohol do you have per week?<quantity>
--                        implemented <otherFindings>/<label>Other pertinent findings on physical exam</label><date> stanza
--                        implemented <title>Heart Attack/MI</title>/<value>/<date>'
-- 2-27-2013 R Benzell    Added empty <hraLocation>/<locationName> for home and ESRD 
--                        Removed <address2> from <patientinfo> frm 3:30 meeting.  Then put it back in based on 6pm email
--                        Added <doesMemberHavePCP> empty tag
--                        Replace <PCPMember> with <PrimaryCareDoctor>
--                        moved <managementPlan>[]</managementPlan> to be under <secondaryQuestions>
--                        <title> is required in <MedicalHistory>
--                        translate <medicineReviewed> type YN10
--                        added <title>, <value> as empty tags under <medicationManagement> 
--                        removed <groupDesc/> from <communityMobility>
--                        Changed <quantity> under <exerciseQuestion> to INT-999
--                        Change <value> under <tobaccoUse>/<quantityGroup>/<value> to INT-999
--                        Change all other quantity tags to INT-999
--                        Change PhysicalExam - bloodPressures - Systolic, diastolic - normal xxx/xxx - if empty, -999/-999
--                        changed the following to INT-999:  <pulse>, <respiration>, <weight>, <usualWeight>, <heightFeet>, <heightInches>, <bmi>
--                        PhysicalExam - weightLoss - managementPlan is not required
--                        Swapped <value> and <rating> under Mental Status Screen- Mini Cog Test  
--                        DepressionScreen/RatingSection - removed depressionDescription 
--                        DepressionScreen - managementPlan is not required under all section2Questions and section4Questions
--                        In PhysicalExam only sections - <followupQuestions> should be <followUpQuestion>
-- 2-28-2013 R Benzell    Strip non-numeric chars from INT-999 and blood pressures BPD and BPS
--                        Moved <advancedIllness> just after <advanceDirective> 
--                        Treat spaces-only values same as null in INT-999 evaluation
--                        Removed <currentUse> from tobacco 
--                        Added <pulseType>, but Before BMI
--                        Use <value> instead of <answer> with masses, 
--                        added empty required <value> or <answers> in multiple locations:
--                          masses consitency, onO2, Carotid bruits, Ophthalmic Complications, Peripheral Angiopathy (peripheral arterial vascular disease
--                          Other Diabetic Complications,
--                       Return only 1 HRA location
--                       Eliminated DepressionScreen Treatment Status group 
--                       changed "DepressionScreen incomplete" to have 4 distinct Questions Groups
-- 3-1-2013 R Benzell   Under <DiabeticScreen>, broke apart   <questions>/  <title>,<status>, <value>, <date> stanzas into 
--                           multiple  <questions>/  <title>,<status> pairs 
--                      Under <BMI:> and <Serum Albumin:> removed <followupQuestions> and <managementPlan>
--                      Removed <groupedQuestions> from "Provider's Assessment and Diagnosis of the Patient"
--                      Removed followupQuestions from "Valve Options"
--                      reactivated <signature64>
--                      changed <specialityCare>  <specialtyCare> (sic) and removed <address> from stanza
--                      Removed <managementPlan> from under <fallRisk>
--                      changed <secondaryQuestion> to  <followupQuestions> in <diagnosis>Hemiparesis,Hemiplegia
--                      added <value> tag under <diagnsois><subDiagnosis>"other" 
--                      remove uneeded <relationship><typedesc> under <memberinfo>
--                      Changed <secondaryQuestion> to <followupQuestions> in "Dementia in Alzheimer''s with Behavioral Disturbance"
--                             and in "Unspecified Dementia with behavioral disturbance"
--                     Received new XSD
--                      removed <address2> from <patient> and <memberinfo>
--                      removed <pulsetype>
--                     Fixed INT-999 to not allow  just - or --
--                     Removed sunsetted header info
-- 3-8-2013 R Benzell  Truncate numeric INT-999 to remove decimal portion
--                    If non-trimable non-numeric values present, return -555
--                     Change <ratings> under depressionScreen to be INT-999
-- 3-11-2013 R Benzell set <NutritionalHealth><total> to be INT-999
--                     Recursive call of Matrix_Utils.Get_InfoPathData with INT-999 on Blood Pressure numerator and denominator
--                     Improved handling of extraneous spaces and dashes on BloodPressures
-- 3-13-2013 R Benzell  Rule Clarification:  -555 for blanks/no values
--                                           -999 for transcription issues and ranges
--                      transposed -555 and -999 from previous logic
--                      Added differentiation between -555 and -999 on type 'YN10'											 





  /* To test Usage:
  set serveroutput on
  begin
    MATRIX_UTILS.GEN_MATRIX_XML(2345,chr(10));
  end;
  
 -- Full XML output can be validated against HRA-Wrapper-Schema.xsd stored in InfoPath Repository
 -- by changing the opening <HRAExchange> tag to be:
 -- <HRAExchange xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="file:///C:/Data/INNODATA/matrix/HRA-Wrapper-Schema.xsd">
  
 --- To unit test variable conversion: 
 select Matrix_Utils.Get_InfoPathData('123/45',-999,'ST') from dual;
 select Matrix_Utils.Get_InfoPathData('123/45',-999,'INT-999') from dual;
 select Matrix_Utils.Get_InfoPathData('123/45',-999,'BPD') from dual;
 select Matrix_Utils.Get_InfoPathData('123/45',-999,'BPS') from dual;
  */

AS
PROCEDURE GEN_MATRIX_XML(
    P_CASEID IN NUMBER,
    P_LF in varchar2 DEFAULT chr(10)||chr(13))
AS
  v_Xml CLOB;
  v_OriginalPdfFileName varchar2(500);
  v_NameValueCount number;
BEGIN

  dbms_output.put_line('Starting to generate Matrix XML generated for case at '|| 
     to_char(sysdate,'YYYY-MM-DD HH:MI.ss PM') || '...');
 
--- check that we have a good case with data in it
  select count(*) into v_NameValueCount
    from INFOPATHDATA where caseid=P_CASEID;
  If  v_NameValueCount = 0 then  
     dbms_output.put_line('ERROR: No Name/Value Pairs for this case in INFOPATHDATA table');
  END IF;

--- and for testing, that the output placeholder exists
  BEGIN
  select OriginalPdfFileName into v_OriginalPdfFileName
    from batchpayload where caseid=P_CASEID;
  EXCEPTION
    WHEN OTHERS THEN dbms_output.put_line('ERROR: Unable to find PDF filename in BATCHPAYLOAD table');
    raise;
  END;  
  
 
  v_Xml := '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>';
  --v_Xml := v_xml || '<caseData>' || P_LF;
  --v_Xml := v_xml || '  <caseid>' || P_CASEID || '</caseid>' || P_LF;
  --v_Xml := v_xml || '  <createdOn>' || to_char(systimestamp,'MM-DD-YYYY HH:MI.SSpm') || '</createdOn>' || P_LF;
  --v_Xml := v_xml || '  <version>' || '1.00' || '</version>' || P_LF;
  --v_Xml := v_xml || '  <OriginalPdfFileName>' || v_OriginalPdfFileName || '</OriginalPdfFileName>' || P_LF;
  --v_Xml := v_xml || '  <xmlcontent>' || P_LF;
  v_Xml := v_xml || '    <HealthRiskManagement>' || P_LF;
  v_Xml := v_Xml || MATRIX_UTILS.MATRIX_XML_HRALOCATION(P_CASEID,P_LF);
  v_Xml := v_Xml || MATRIX_UTILS.MATRIX_XML_PATIENTINFO(P_CASEID,P_LF); 
  v_Xml := v_Xml || MATRIX_UTILS.MATRIX_XML_PCPMEMBER(P_CASEID,P_LF);
  v_Xml := v_Xml || MATRIX_UTILS.MATRIX_XML_PATIENTOBS(P_CASEID,P_LF);
  v_Xml := v_Xml || MATRIX_UTILS.MATRIX_XML_INFOSOURCE(P_CASEID,P_LF);
  v_Xml := v_Xml || MATRIX_UTILS.MATRIX_XML_MEDHISTORY(P_CASEID,P_LF);
  v_Xml := v_Xml || MATRIX_UTILS.MATRIX_XML_ADMISSIONHIST(P_CASEID,P_LF);
  --dbms_output.put_line('ADMISSIONHIST='||length(v_xml));
  
  v_Xml := v_Xml || MATRIX_UTILS.MATRIX_XML_HEALTHMAINT(P_CASEID,P_LF);
  v_Xml := v_Xml || MATRIX_UTILS.MATRIX_XML_PERSANDSOC(P_CASEID,P_LF);
  v_Xml := v_Xml || MATRIX_UTILS.MATRIX_XML_HEALTHBEHV(P_CASEID,P_LF); 
  v_Xml := v_Xml || MATRIX_UTILS.MATRIX_XML_FUNCSTATUS(P_CASEID,P_LF);
  --dbms_output.put_line('FUNCSTATUS='||length(v_xml));
  
  v_Xml := v_Xml || MATRIX_UTILS.MATRIX_XML_DEPRSCREEN(P_CASEID,P_LF);
  --  dbms_output.put_line('DEPRSCREEN='||length(v_xml));
  
  v_Xml := v_Xml || MATRIX_UTILS.MATRIX_XML_FOCUSREVIEW(P_CASEID,P_LF);
   -- dbms_output.put_line('FOCUSREVIEW='||length(v_xml));

   --dbms_output.put_line('xxPHYEXAM='||length(MATRIX_UTILS.MATRIX_XML_PHYEXAM(P_CASEID,P_LF)));
  v_Xml := v_Xml || MATRIX_UTILS.MATRIX_XML_PHYEXAM(P_CASEID,P_LF);  
   -- dbms_output.put_line('PHYEXAM='||length(v_xml));
  
  v_Xml := v_Xml || MATRIX_UTILS.MATRIX_XML_LABDATA(P_CASEID,P_LF);
    --dbms_output.put_line('LABDATA='||length(v_xml));
  
  v_Xml := v_Xml || MATRIX_UTILS.MATRIX_XML_DIABETICSCREEN(P_CASEID,P_LF);
  v_Xml := v_Xml || MATRIX_UTILS.MATRIX_XML_NUTRIHEALTH(P_CASEID,P_LF);
  v_Xml := v_Xml || MATRIX_UTILS.MATRIX_XML_NUTRIDIAG(P_CASEID,P_LF);
  v_Xml := v_Xml || MATRIX_UTILS.MATRIX_XML_FALLRISK(P_CASEID,P_LF);
  v_Xml := v_Xml || MATRIX_UTILS.MATRIX_XML_PROVASSMT(P_CASEID,P_LF);
  v_Xml := v_Xml || MATRIX_UTILS.MATRIX_XML_SIGNATURE(P_CASEID,P_LF);
  v_Xml := v_Xml || MATRIX_UTILS.MATRIX_XML_MGMTREFER(P_CASEID,P_LF);
  v_Xml := v_xml || '    </HealthRiskManagement>' || P_LF;
  --v_Xml := v_xml || '  </xmlcontent>' || P_LF;
  --v_Xml := v_xml || '</caseData>' || P_LF;
  
  --insert the XML clob into BATCHPAYLOAD table for the case
  -- also note the updated timestamp
  UPDATE BATCHPAYLOAD SET xmldata = v_Xml, 
                       UPDATED_TIMESTAMP = systimestamp            
                      WHERE caseid = P_CASEID;
  COMMIT;
  dbms_output.put_line('Matrix XML generated for case '|| P_CASEID || 
    ' finished at ' || to_char(sysdate,'YYYY-MM-DD HH:MI.ss PM') );
  
  --- Catch errors and show their line numbers
EXCEPTION
WHEN OTHERS THEN
  --null;
   dbms_output.put_line(SUBSTR(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
                              CHR(13) || SQLERRM,1,4000));
  LOG_APEX_ERROR(16); --need to define new action for this error
  --RAISE;
END GEN_MATRIX_XML;



FUNCTION   Get_InfoPathData (

    P_NODENAME VARCHAR2 DEFAULT NULL, -- Normally NODENAME for selection from INFOPATHDATA when CASEID is passed
    P_Caseid   Number Default Null,   -- If -999, use P_NODENAME as directly passed String to processing. 
    P_Format   Varchar2 Default 'ST') --ST=String, DT=Date, TF=true/false, YN=yes/no, MF=male/female, MP=management plan, 01= 01 Boolean
                                      -- BPS/BPD  Blood pressure Systolic/Diastolic,  -- YN10=1 or 0 or -999
                                      -- INT-999 Performs Integer value data scrubbing.
									  -- If pure number, return trunc, if not pure number, strip CHARs.   otherwise, return -999
									  -- Can be invoked directly on passed strings instead of performing a lookup INFOPATHDATA 
									  -- Used in this recursive fashion for BPS/BPD numerator/denominator scrubbng 
                                        
									 
									 
                                      
  
/**- 10-22-2012 added 0/1 Boolean
  -- 2-27-13 R Benzell added YN10
  
  -- to Test on DEV:  select Matrix_Utils.Get_InfoPathData('Matrix_Utils.Get_InfoPathData_NEW1,4,3,'STV') from dual
  set serveroutput on;
   select Matrix_Utils.Get_InfoPathData('PA_Neuro_Aphasia_Plan_E1
+PA_Neuro_Aphasia_Plan_E2
+Fall_Risk_History_Plan_E3
+PA_Neuro_Aphasia_Plan_E4
+Fall_Risk_History_Plan_E5
+Fall_Risk_History_Plan_M1
+Fall_Risk_History_Plan_M2
+Fall_Risk_History_Plan_M3
+PA_Neuro_Aphasia_Plan_R1
+PA_Neuro_Aphasia_Plan_R2',v_CaseId,'MP') from dual


'Fall_Risk_History_Plan_E1
+Fall_Risk_History_Plan_E2
+Fall_Risk_History_Plan_E3
+Fall_Risk_History_Plan_E4
+Fall_Risk_History_Plan_E5
+Fall_Risk_History_Plan_M1
+Fall_Risk_History_Plan_M2
+Fall_Risk_History_Plan_M3
+Fall_Risk_History_Plan_R1
+Fall_Risk_History_Plan_R2
***/
  
  RETURN VARCHAR2
IS
  v_Return   VARCHAR2(32000);
  v_Value    VARCHAR2(1000);
  v_Format   VARCHAR2(10);
  v_PlanType varchar2(2);
  v_NodeName VARCHAR2(8000);
  v_TrimNode VARCHAR2(8000);
  J          INTEGER;
  PARM_Arr2 HTMLDB_APPLICATION_GLOBAL.VC_ARR2;
	BEGIN
		
  --- Set Default values and Initialize Format Flags
  IF P_Format = 'TF' THEN
    v_Return :='false';
	v_Format := P_FORMAT;
  END IF;
  
  IF P_Format = 'YN' THEN
    v_Return :='no';
    v_Format := P_FORMAT;
  END IF;

  IF P_Format = 'YN10' OR P_Format = 'INT-999' OR P_Format = 'BPD' OR P_Format = 'BPS' THEN
    v_Return :='-555';   -- default replacement for null
    v_Format := P_FORMAT;
  END IF;


  IF P_Format = '01' THEN
    v_Return :='0';
    v_Format := P_FORMAT;
  END IF;
  
  -----------------------------------------------------------------------------------
  --- Parse line based on "+" character
  -----------------------------------------------------------------------------------
  --- Drop CR/LF and spaces
   v_TrimNode := trim(REPLACE(P_NodeName,chr(10),''));
   v_TrimNode := REPLACE(v_TrimNode,chr(13),'');
   v_TrimNode := REPLACE(v_TrimNode,' ','');
  -- dbms_output.put_line('>>>'||v_TrimNode||'<<<');

  PARM_Arr2 := HTMLDB_UTIL.STRING_TO_TABLE(v_TrimNode,'+');
  FOR J     IN 1..PARM_arr2.count
  LOOP
    v_NodeName := trim(upper(PARM_arr2(J)));

    --- If multi-parm, but type string, convert to CT (concatenate)
    IF PARM_arr2.count >= 2 AND P_FORMAT = 'ST' THEN
      v_Format         := 'CT';
    ELSE
      v_Format := P_FORMAT;
    END IF;
   --dbms_output.put_line(J||' - ' || v_NodeName || ': ' || v_format || ' - ' || v_value ||' - ' || v_return);
    
    -----------------------------------------------------------------------------------
    Case
     -- Qucktest mode, IF Caseid = -999 P_NODENAME as input string
     When P_Caseid = -999 Then
      v_Value :=  P_NODENAME; 
    
      --- Date - convert YYYY-MM-DD to MM/DD/YYYY
    WHEN P_FORMAT='DT' THEN
      BEGIN
       -- SELECT trim(NODEVALUE)
        SELECT replace(replace(trim(NODEVALUE),chr(10),''),chr(13),'')  -- remove any CR/LF in data
        INTO v_Value
        FROM INFOPATHDATA
        WHERE upper(NODENAME) = v_NODENAME
        AND CASEID            =P_CASEID;
        if v_Value is Not NULL
          then v_value  := SUBSTR(v_value,6,2) || '/' || SUBSTR(v_value,9,2) || '/' || SUBSTR(v_value,1,4) ;
          else v_value := '';  -- No date, just leave blank
        end if;  
      EXCEPTION
      WHEN OTHERS THEN
        v_RETURN := NULL;
      END;
  

  
      --- Standard String, Date, any other format
      --WHEN P_FORMAT='ST' or P_FORMAT='CT' then
    ELSE
      BEGIN
         SELECT replace(replace(trim(NODEVALUE),chr(10),''),chr(13),'')  -- remove any CR/LF in data
        INTO v_Value
        FROM INFOPATHDATA
        WHERE upper(NODENAME) = v_NODENAME
        AND CASEID            =P_CASEID;
      EXCEPTION
      WHEN OTHERS THEN
        v_Value :=  NULL;
      END;
      --ELSE
      --  v_Value := NULL;
    END CASE;
    -----------------------------------------------------------------------------------
    --- CT Build Concatenated values as necessary, generate format of "[p1,p2,p3...]"
    -----------------------------------------------------------------------------------
    CASE
      --- append with a trailing ,
    WHEN v_FORMAT='CT' AND v_value IS NOT NULL THEN
      v_Return  := v_Return || v_value || ',';
      --when v_FORMAT='CT' and J = 1
      --- Initialize results with [
      --  then v_Return :=  '[' || v_value ;
      --when v_FORMAT='CT' and J < PARM_arr2.count and v_value is not null
      --- Then append results with comma
      -- then v_Return := v_Return  || ',' || v_value ;
      --when v_FORMAT='CT' and J = PARM_arr2.count and v_value is not null
      --- Then append results with comma
      -- then v_Return := v_Return  || ',' || v_value || ']';
      --when v_FORMAT='CT' and J = PARM_arr2.count and v_value is null
      --- Then just close bracked
      -- then v_Return := v_Return  ||  ']';

      --------------------------------------------
      --- 0/1 - Boolean - make 1 if any element is populated
      ----------------------------------------------------
    WHEN v_FORMAT='01' AND v_Value IS NOT NULL THEN
      v_Return  := '1';
      
     --------------------------------------------
      --- True/False - make true if any element is populated
      ----------------------------------------------------
    WHEN v_FORMAT='TF' AND v_Value IS NOT NULL THEN
      v_Return  := 'true';
       
      --------------------------------------------
      --- Yes/No - make yes if any element is populated
      ----------------------------------------------------
    WHEN v_FORMAT='YN' AND v_Value IS NOT NULL THEN
      v_Return  := 'yes';

      --------------------------------------------
      --- YN10 - Yes=1, N=0, anything else=-999
      ----------------------------------------------------
    WHEN v_FORMAT='YN10' AND upper(substr(v_Value,1,1)) = 'Y' 
	 THEN  v_Return  := '1';

    WHEN v_FORMAT='YN10' AND upper(substr(v_Value,1,1)) = 'N' 
	  THEN v_Return  := '0';

    WHEN v_FORMAT='YN10' AND v_value is null THEN
      v_Return  := '-555';  -- default replacement for null

    WHEN v_FORMAT='YN10'  THEN
      v_Return  := '-999';  -- default replacement for anything else

      --------------------------------------------
      --- INT-999 - Core Number, or -999
	  --- rules for INT-999
	  --- no value or blanks -> return -999
	  --- drop chars fromnon-numeric that be trimmed without modifing corenumber ( 150ft -> 150)
	  --- items with dashes, slashes, or all chars  that cannot be removed - -> -555
	  --- decimal numbers -> truncate
      ----------------------------------------------------\
	
	---   no value or blanks -> return -999
    WHEN V_Format='INT-999' And (V_Value Is Null Or Length(Trim(V_Value))=0 ) 
	    THEN  v_Return  := '-555';     -- default replacement for null
		

    --- there is something present, ultimately either return corenumber or -555
	WHEN v_FORMAT='INT-999' 
	 
	  --THEN v_Return  := to_char(TO_NUMBER_SNX(trim(v_value)));
	 --- remove chars, see if 
	  THEN 
	  	
	  --- Perform a simple stripping of the chars	
    --- leave - . and slashes
		V_Return :=  Regexp_Replace(V_Value,'[^0-9./-]');
	
	
	  --- Nothing left, must have been all Chars.  Return -999 flag	
    	IF (V_Return Is Null Or Length(Trim(V_Return))=0 ) 
	      THEN  v_Return  := '-999';  -- unexpected chars
		END IF;  	
    
   --- Catch any other combinations of -, / or . or other oddities that create invalid numerics
   --- If to_number works, value is a valid number
    Begin
     V_Return := To_Number(V_Return);
     Exception
      When Others Then 
       V_Return := '-999';  -- unexpected chars
    END;
    
     --- Must either real number or -555 or -999 at this point
     --- If decimal, truncate
     v_Return := trunc(v_Return);


      --------------------------------------------
      --- M/F - make M first element is populated,F if second element is populated
      ----------------------------------------------------
    WHEN v_FORMAT='MF' AND v_Value IS NOT NULL AND J=1 THEN
      v_Return  := v_return||'M';
    WHEN v_FORMAT='MF' AND v_Value IS NOT NULL AND J=2 THEN
      v_Return  := v_return||'F';
      --- Non-concatenation

    WHEN v_FORMAT='DT' OR v_FORMAT='ST' THEN
      v_Return  := v_Value;

    -- management plan results need to be in format of: [M2, R1, E1, E3] 
    -- Just check first char for "t" instead of 'true' since there are special chars creeping in with + across multiple lines
    WHEN v_FORMAT='MP' AND substr(v_Value,1,1) ='t' THEN
       v_PlanType := SUBSTR(v_Nodename,LENGTH( v_Nodename)-1,2);
       v_Return := v_Return ||  V_PlanType ||',';
       
      --v__Return  := v_Return || regexp_substr(v_NODENAME,'[^_]+', 1, LENGTH(regexp_replace(v_NODENAME,'[^_]',''))+1) || ',';
      --v_Return := SUBSTR(v_return,1,LENGTH(v_return)-1);
      --v_Return := '[' || v_Return || ']';

      --v_Return := '[' || v_Nodename || ': '|| v_value || '='|| V_PlanType || ']';
      --v_Return := v_Return || J || '-' || v_Nodename || ': '||substr(v_Value,1,1) || '='|| V_PlanType ||',';

     
     WHEN v_FORMAT='MP' THEN   
       null;
       --v_Return := '[>>>' || v_value || '<<<]';

   --- No Blood Pressures
    WHEN P_FORMAT='BPS' AND (v_Value IS NULL OR length(trim(v_value))=0 ) THEN
        v_RETURN := '-555';  -- null replacement

    WHEN P_FORMAT='BPD' AND (v_Value IS NULL OR length(trim(v_value))=0 ) THEN
        v_RETURN := '-555';  -- null replacement
	   
       
    --- Blood Pressure Systolic/diastolic
	--- In INfopath, we store the BP in a single field, like 110/80.
	--- in client XML, we need to parse that into 2 discreen fields, returned separately:  110  and 80 
	--- Also exclude any non-numeric values  
    WHEN P_FORMAT='BPS' THEN --AND (v_Value IS NULL OR length(trim(v_value))=0 ) THEN
	   	v_value := REGEXP_REPLACE(trim(v_value),'( ){2,}', ' ');  -- collapse multiple spaces into single
        v_value := replace(trim(v_value),' ','/');                -- replace "middle" spaces replace with / for parsing
		v_value := replace(trim(v_value),'-','/');                -- replace "middle" dashes with / for parsing
		v_value := REGEXP_REPLACE(trim(v_value),'(/){2,}', '/');  -- collapse multiple slashes  into single
        v_value := trim(substr(v_value,1,instr(v_value,'/')-1));  --- numbers to left of Slash
		
	  --- Recursively call the INT-999 variation 	
		v_Return := Matrix_Utils.Get_InfoPathData(v_value,-999,'INT-999');
		


    WHEN P_FORMAT='BPD' THEN  --(v_Value IS NULL OR length(trim(v_value))=0 ) THEN
		v_value := REGEXP_REPLACE(trim(v_value),'( ){2,}', ' ');  -- collapse multiple spaces into single
        v_value := replace(trim(v_value),' ','/');                -- "middle" spaces replace with / for parsing
		v_value := replace(trim(v_value),'-','/');                -- replace "middle" dashes with / for parsing
		v_value := REGEXP_REPLACE(trim(v_value),'(/){2,}', '/');  -- collapse multiple slashes  into single
        v_value := trim(substr(v_value,instr(v_value,'/')+1));    -- numbers to right of Slash
		
	  --- Recursively call the INT-999 variation 	
		v_Return := Matrix_Utils.Get_InfoPathData(v_value,-999,'INT-999');
		


      
    ELSE
      NULL; --v_Return := v_Value;
    END CASE;
  END LOOP; -- Looping through each "+"
  -- Wrap concatenated string, remove trailing ,
  IF v_FORMAT ='CT' OR v_FORMAT = 'MP' THEN
    v_Return := SUBSTR(v_return,1,LENGTH(v_return)-1);
    v_Return := '[' || v_Return || ']';
  END IF;
  
  RETURN v_Return;
  
EXCEPTION
WHEN OTHERS THEN
  v_Return := SUBSTR(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || CHR(13) || SQLERRM,1,3900);
  dbms_output.put_line('Matrix_Utils.Get_InfoPathData ERROR=' || v_Return);
  RAISE;
END Get_InfoPathData;




FUNCTION MATRIX_XML_ADMISSIONHIST(
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
  v_Str := v_Str || '   <AdmissionHistory>' || LF;
  
  v_Str := v_Str || '   <psychiatricAdmissions>' || LF;
  v_Str := v_Str || '        <title>Psychiatric</title>' || LF;
  v_Str := v_Str || '          <admissions>' || LF;
  v_Str := v_Str || '            <reasonForAdmission>' || Matrix_Utils.Get_InfoPathData('Sig_Ill_Admin_History_Psych_Reason_1',v_CaseId,'ST') || '</reasonForAdmission>' || LF;
  v_Str := v_Str || '            <date>' || Matrix_Utils.Get_InfoPathData('Sig_Ill_Admin_History_Psych_Date_1',v_CaseId,'DT') || '</date>' || LF;
  v_Str := v_Str || '          </admissions>' || LF;
  --v_Str := v_Str || '            <reasonForAdmission>' ||  Matrix_Utils.Matrix_Utils.Get_InfoPathData('Sig_Ill_Admin_History_Psych_Reason_2',v_CaseId,'ST') || '</reasonForAdmission>'  || LF;
  --v_Str := v_Str || '            <date>' ||  Matrix_Utils.Get_InfoPathData('Sig_Ill_Admin_History_Psych_Date_2',v_CaseId,'ST') || '</date>'  || LF;
  v_Str := v_Str || '   </psychiatricAdmissions>' || LF;
  
  v_Str := v_Str || '   <rehabAdmissions>' || LF;
  v_Str := v_Str || '        <title>SNF/Rehab/Nursing Home</title>' || LF;
  v_Str := v_Str || '          <admissions>' || LF;
  v_Str := v_Str || '            <reasonForAdmission>' || Matrix_Utils.Get_InfoPathData('Sig_Ill_Admin_History_SNF_Reason_1',v_CaseId,'ST') || '</reasonForAdmission>' || LF;
  v_Str := v_Str || '            <date>' || Matrix_Utils.Get_InfoPathData('Sig_Ill_Admin_History_SNF_Date_1',v_CaseId,'DT') || '</date>' || LF;
  v_Str := v_Str || '          </admissions>' || LF;
  
  v_Str := v_Str || '          <admissions>' || LF;
  v_Str := v_Str || '            <reasonForAdmission>' ||  Matrix_Utils.Get_InfoPathData('Sig_Ill_Admin_History_SNF_Reason_2',v_CaseId,'ST') || '</reasonForAdmission>'  || LF;
  v_Str := v_Str || '            <date>' ||  Matrix_Utils.Get_InfoPathData('Sig_Ill_Admin_History_SNF_Date_2',v_CaseId,'DT') || '</date>'  || LF;
  v_Str := v_Str || '          </admissions>' || LF;
  v_Str := v_Str || '   </rehabAdmissions>' || LF;
  
  v_Str := v_Str || '   <medicalAdmissions>' || LF;
  v_Str := v_Str || '        <title>Medical (include nonsurgical fractures</title>' || LF;
  v_Str := v_Str || '          <admissions>' || LF;
  v_Str := v_Str || '            <reasonForAdmission>' || Matrix_Utils.Get_InfoPathData('Sig_Ill_Admin_History_Medical_Reason_1',v_CaseId,'ST') || '</reasonForAdmission>' || LF;
  v_Str := v_Str || '            <date>' || Matrix_Utils.Get_InfoPathData('Sig_Ill_Admin_History_Medical_Date_1',v_CaseId,'DT') || '</date>' || LF;
  v_Str := v_Str || '          </admissions>' || LF;
  
  v_Str := v_Str || '          <admissions>' || LF;
  v_Str := v_Str || '            <reasonForAdmission>' || Matrix_Utils.Get_InfoPathData('Sig_Ill_Admin_History_Medical_Reason_2',v_CaseId,'ST') || '</reasonForAdmission>' || LF;
  v_Str := v_Str || '            <date>' || Matrix_Utils.Get_InfoPathData('Sig_Ill_Admin_History_Medical_Date_2',v_CaseId,'DT') || '</date>' || LF;
  v_Str := v_Str || '          </admissions>' || LF;
  
  v_Str := v_Str || '          <admissions>' || LF;
  v_Str := v_Str || '            <reasonForAdmission>' ||  Matrix_Utils.Get_InfoPathData('Sig_Ill_Admin_History_Medical_Reason_3',v_CaseId,'ST') || '</reasonForAdmission>'  || LF;
  v_Str := v_Str || '            <date>' ||  Matrix_Utils.Get_InfoPathData('Sig_Ill_Admin_History_Medical_Date_3',v_CaseId,'DT') || '</date>'  || LF;
  v_Str := v_Str || '          </admissions>' || LF;
  
  v_Str := v_Str || '   </medicalAdmissions>' || LF;
  
  v_Str := v_Str || '   <surgeryAdmissions>' || LF;
  v_Str := v_Str || '        <title>Surgical (include fractures)</title>' || LF;
  v_Str := v_Str || '          <admissions>' || LF;
  v_Str := v_Str || '            <reasonForAdmission>' || Matrix_Utils.Get_InfoPathData('Sig_Ill_Admin_History_Surgical_Reason_1',v_CaseId,'ST') || '</reasonForAdmission>' || LF;
  v_Str := v_Str || '            <date>' || Matrix_Utils.Get_InfoPathData('Sig_Ill_Admin_History_Surgical_Date_1',v_CaseId,'DT') || '</date>' || LF;
  v_Str := v_Str || '          </admissions>' || LF;
  v_Str := v_Str || '          <admissions>' || LF;
  v_Str := v_Str || '            <reasonForAdmission>' ||  Matrix_Utils.Get_InfoPathData('Sig_Ill_Admin_History_Surgical_Reason_2',v_CaseId,'ST') || '</reasonForAdmission>'  || LF;
  v_Str := v_Str || '            <date>' ||  Matrix_Utils.Get_InfoPathData('Sig_Ill_Admin_History_Surgical_Date_2',v_CaseId,'DT') || '</date>'  || LF;
  v_Str := v_Str || '          </admissions>' || LF;
  v_Str := v_Str || '          <admissions>' || LF;
  v_Str := v_Str || '            <reasonForAdmission>' ||  Matrix_Utils.Get_InfoPathData('Sig_Ill_Admin_History_Surgical_Reason_3',v_CaseId,'ST') || '</reasonForAdmission>'  || LF;
  v_Str := v_Str || '            <date>' ||  Matrix_Utils.Get_InfoPathData('Sig_Ill_Admin_History_Surgical_Date_3',v_CaseId,'DT') || '</date>'  || LF;
  v_Str := v_Str || '          </admissions>' || LF;
  v_Str := v_Str || '   </surgeryAdmissions>' || LF;
  v_Str := v_Str || '   </AdmissionHistory>' || LF;
  ------------------------------------
  RETURN v_Str;
EXCEPTION
WHEN OTHERS THEN
  v_Str := SUBSTR(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || CHR(13) || SQLERRM,1,4000);
  RAISE;
END MATRIX_XML_ADMISSIONHIST;


FUNCTION MATRIX_XML_DEPRSCREEN(
    P_CASEID NUMBER ,
    P_LF     VARCHAR2 )
  -- Created 10-6-2012 R Benzell
  -- called by GEN_MATRIX_XML
  RETURN CLOB
IS
  v_Str CLOB;
  v_CaseId NUMBER;
  LF       VARCHAR2(5);
  v_Response varchar2(100);
  
BEGIN
  v_CaseId := P_CaseId;
  LF       := P_LF;
  -----------------------------------
  v_Str := v_Str || '<DepressionScreen>'|| LF;
  v_Str := v_Str || '   <sectionTitle>Depression Screen (PHQ-8)</sectionTitle>' || LF;
  
  --v_Str := v_Str || '   <groupedQuestions>'  || LF;
  --v_Str := v_Str || '        <groupTitle>Treatment Status</groupTitle>' || LF;
  --v_Str := v_Str || '        <questions>' || LF;
  --v_Str := v_Str || '            <title>Is Patient Currently Receiving Treatment for Depression?</title>' || LF;
  --v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('Depr_Screen_Treatment',v_CaseId,'TF') || '</value>' || LF;
  --v_Str := v_Str || '        </questions>' || LF;
  --v_Str := v_Str || '   </groupedQuestions>'  || LF;
  
  
  v_Str := v_Str || '   <groupedQuestions>'  || LF;
  v_Str := v_Str || '        <groupTitle>Unable to Complete due to:</groupTitle>' || LF;
    
  v_Response := Matrix_Utils.Get_InfoPathData('Depr_Screen_Incomplete',v_CaseId,'ST');

---  
  v_Str := v_Str || '        <questions>' || LF;
  v_Str := v_Str || '            <title>Unresponsive</title>' || LF;
     IF  v_Response = '1' then   v_Str := v_Str || '            <value>yes</value>' || LF;
                          else   v_Str := v_Str || '            <value></value>' || LF;
	 END IF;
  v_Str := v_Str || '        </questions>' || LF;

----
  v_Str := v_Str || '        <questions>' || LF;  
  v_Str := v_Str || '            <title>Uncooperative</title>' || LF;
     IF  v_Response = '2' then   v_Str := v_Str || '            <value>yes</value>' || LF;
                          else   v_Str := v_Str || '            <value></value>' || LF;
	 END IF;
  v_Str := v_Str || '        </questions>' || LF;

-----
  v_Str := v_Str || '        <questions>' || LF;  
  v_Str := v_Str || '            <title>Severe Dementia</title>' || LF;
     IF  v_Response = '3' then   v_Str := v_Str || '            <value>yes</value>' || LF;
                          else   v_Str := v_Str || '            <value></value>' || LF;
	 END IF;
  v_Str := v_Str || '        </questions>' || LF;

-----
  v_Str := v_Str || '        <questions>' || LF;  
  v_Str := v_Str || '            <title>Other Reason</title>' || LF;
     IF  v_Response = '4' then   v_Str := v_Str || '            <value>yes</value>' || LF;
                          else   v_Str := v_Str || '            <value></value>' || LF;
	 END IF;
  v_Str := v_Str || '        </questions>' || LF;
 v_Str := v_Str || '    </groupedQuestions>' || LF;    
  
 
  
  v_Str := v_Str || '    <ratingSection>' || LF;
  v_Str := v_Str || '        <sectionTitle>Over last 14 days, how often have you been bothered by ...</sectionTitle>' || LF;
  v_Str := v_Str || '           <ratings>' || LF;
  v_Str := v_Str || '         <ratingTitle>Little interest or pleasure in doing things</ratingTitle>' || LF;
  v_Str := v_Str || '         <rating>' || Matrix_Utils.Get_InfoPathData('Depr_Screen_Little_Interest',v_CaseId,'INT-999') || '</rating>' || LF;
  v_Str := v_Str || '           </ratings>' || LF;
  v_Str := v_Str || '           <ratings>' || LF;
  v_Str := v_Str || '         <ratingTitle>Feeling down, depressed or hopeless</ratingTitle>' || LF;
  v_Str := v_Str || '         <rating>' || Matrix_Utils.Get_InfoPathData('Depr_Screen_Feeling_Down',v_CaseId,'INT-999') || '</rating>' || LF;
  v_Str := v_Str || '           </ratings>' || LF;
  v_Str := v_Str || '           <ratings>' || LF;
  v_Str := v_Str || '         <ratingTitle>Trouble falling asleep, staying asleep, or sleeping too much</ratingTitle>' || LF;
  v_Str := v_Str || '         <rating>' || Matrix_Utils.Get_InfoPathData('Depr_Screen_Sleep',v_CaseId,'INT-999') || '</rating>' || LF;
  v_Str := v_Str || '           </ratings>' || LF;
  v_Str := v_Str || '           <ratings>' || LF;
  v_Str := v_Str || '         <ratingTitle>Feeling tired or having little energy</ratingTitle>' || LF;
  v_Str := v_Str || '         <rating>' || Matrix_Utils.Get_InfoPathData('Depr_Screen_Energy',v_CaseId,'INT-999') || '</rating>' || LF;
  v_Str := v_Str || '           </ratings>' || LF;
  v_Str := v_Str || '           <ratings>' || LF;
  v_Str := v_Str || '         <ratingTitle>Poor appetite or overeating</ratingTitle>' || LF;
  v_Str := v_Str || '         <rating>' || Matrix_Utils.Get_InfoPathData('Depr_Screen_Appetite',v_CaseId,'INT-999') || '</rating>' || LF;
  v_Str := v_Str || '           </ratings>' || LF;
  v_Str := v_Str || '           <ratings>' || LF;
  v_Str := v_Str || '         <ratingTitle>Feeling bad about yourself, feeling that your are a failure, or feeling that you have let yourself or your family down</ratingTitle>' || LF;
  v_Str := v_Str || '         <rating>' || Matrix_Utils.Get_InfoPathData('Depr_Screen_Feeling_Bad',v_CaseId,'INT-999') || '</rating>' || LF;
  v_Str := v_Str || '           </ratings>' || LF;
  v_Str := v_Str || '           <ratings>' || LF;
  v_Str := v_Str || '         <ratingTitle>Trouble concentrating on such things as reading the newspaper or watching TV</ratingTitle>' || LF;
  v_Str := v_Str || '         <rating>' || Matrix_Utils.Get_InfoPathData('Depr_Screen_Concentration',v_CaseId,'INT-999') || '</rating>' || LF;
  v_Str := v_Str || '           </ratings>' || LF;
  v_Str := v_Str || '           <ratings>' || LF;
  v_Str := v_Str || '         <ratingTitle>Moving or speaking so slowly that other people could have noticed, or being so fidgety or restless that you have moving around a lot more than usual</ratingTitle>' || LF;
  v_Str := v_Str || '         <rating>' || Matrix_Utils.Get_InfoPathData('Depr_Screen_Abnormal',v_CaseId,'INT-999') || '</rating>' || LF;
  v_Str := v_Str || '           </ratings>' || LF;

  v_Str := v_Str || '        <phq85TotalScore>' || Matrix_Utils.Get_InfoPathData('Depr_Screen_Severity_Score',v_CaseId,'INT-999') || '</phq85TotalScore>' || LF;
  --v_Str := v_Str || '        <depressionDescription>' || Matrix_Utils.Get_InfoPathData('Depr_Screen_Severity_1to4 + Depr_Screen_Severity_5to9 + Depr_Screen_Severity_10to14 + 
  -- Depr_Screen_Severity_15to19 +  Depr_Screen_Severity_20to24',v_CaseId,'ST') || '</depressionDescription>' || LF;
  v_Str := v_Str || '        </ratingSection>' || LF;
  
  v_Str := v_Str || '        <section1Questions>' || LF;
  v_Str := v_Str || '           <groupTitle>Answer these 2 questions for All Patients</groupTitle>' || LF;
  v_Str := v_Str || '           <questions>' || LF;
  v_Str := v_Str || '              <title>Does patient have a history of the diagnosis of a mixed disorder? (bipolar disease or manic depression)?</title>' || LF;
  v_Str := v_Str || '              <value>' || Matrix_Utils.Get_InfoPathData('Depr_Screen_History',v_CaseId,'YN') || '</value>' || LF;
  v_Str := v_Str || '           </questions>' || LF;
  
  v_Str := v_Str || '           <questions>' || LF;
  v_Str := v_Str || '              <title>Are patient''s symptoms directly due to medication, substance abuse, or an untreated medical condition (such as hypothyroidism)?</title>' || LF;
  v_Str := v_Str || '              <value>' || Matrix_Utils.Get_InfoPathData('Depr_Screen_Due_to_Meds',v_CaseId,'YN') || '</value>' || LF;
  v_Str := v_Str || '           </questions>' || LF;
  v_Str := v_Str || '        </section1Questions>' || LF;
  
  v_Str := v_Str || '        <section2Questions>' || LF;
  v_Str := v_Str || '          <groupTitle>Answer (a) and (b) Only For Patients with Total Score on PHQ-8 = 15:</groupTitle>' || LF;

  v_Str := v_Str || '           <questions>' || LF;
  v_Str := v_Str || '             <title>Does the patient have at least 5 scores in the shaded area on the Depression screen above included at least one of the for question 1 or 2?</title>' || LF;
  v_Str := v_Str || '             <value>' || Matrix_Utils.Get_InfoPathData('Depr_Screen_Score_5',v_CaseId,'YN') || '</value>' || LF;
  v_Str := v_Str || '           </questions>' || LF;


  v_Str := v_Str || '           <questions>' || LF;
  v_Str := v_Str || '             <title>Do the patient''s symptoms cause significant distress or impairment?</title>' || LF;
  v_Str := v_Str || '             <value>' || Matrix_Utils.Get_InfoPathData('Depr_Screen_Distress',v_CaseId,'YN') || '</value>' || LF;
  v_Str := v_Str || '           </questions>' || LF;
  
  v_Str := v_Str || '           <questions>' || LF;
  v_Str := v_Str || '              <title>If the PHQ-8 score is = 15 and the answers to both (a) and (b) are Yes, then patient meets criteria for the Diagnoses of major depression.</title>' || LF;
  v_Str := v_Str || '              <value>' || Matrix_Utils.Get_InfoPathData('Depr_Screen_PHQ_Score',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '           </questions>' || LF;
  
  --v_Str := v_Str || '           <managementPlan>' || Matrix_Utils.Get_InfoPathData('Depr_Screen_PHQ_Plan_M1+Depr_Screen_PHQ_Plan_M2+Depr_Screen_PHQ_Plan_M3+Depr_Screen_PHQ_Plan_R1+
  --                       Depr_Screen_PHQ_Plan_R2+Depr_Screen_PHQ_Plan_E1+Depr_Screen_PHQ_Plan_E2+Depr_Screen_PHQ_Plan_E3+Depr_Screen_PHQ_Plan_E4+
  --                       Depr_Screen_PHQ_Plan_E5',v_CaseId,'MP') || '</managementPlan>' || LF;
  v_Str := v_Str || '        </section2Questions>' || LF;
  
  v_Str := v_Str || '        <section3Questions>' || LF;
  v_Str := v_Str || '           <groupTitle>Answer (c), (d), and (e) Only for Patients taking medication to treat depression:</groupTitle>' || LF;
  v_Str := v_Str || '           <questions>' || LF;
  v_Str := v_Str || '             <title>Does the patient have a history of hospitalization for severe depression?</title>' || LF;
  v_Str := v_Str || '             <value>' || Matrix_Utils.Get_InfoPathData('Depr_Screen_Hosp_Depr',v_CaseId,'YN') || '</value>' || LF;
  v_Str := v_Str || '           </questions>' || LF;
  v_Str := v_Str || '           <questions>' || LF;
  v_Str := v_Str || '             <title>Have one or more attempts to stop anti-depressant medication led to severe relapse of depression?</title>' || LF;
  v_Str := v_Str || '             <value>' || Matrix_Utils.Get_InfoPathData('Depr_Screen_Lapse_Depr',v_CaseId,'YN') || '</value>' || LF;
  v_Str := v_Str || '           </questions>' || LF;
  v_Str := v_Str || '           <questions>' || LF;
  v_Str := v_Str || '             <title>For this patient taking medication to treat depression, the answer to (c) or (d) is Yes. This patient meets the criteria and has the diagnosis of major depression</title>' || LF;
  v_Str := v_Str || '             <value>' || Matrix_Utils.Get_InfoPathData('Depr_Screen_Major_Depr',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '           </questions>' || LF;
  v_Str := v_Str || '        <managementPlan>' || Matrix_Utils.Get_InfoPathData('Depr_Screen_Major_Depr_Plan_M1+Depr_Screen_Major_Depr_Plan_M2+Depr_Screen_Major_Depr_Plan_M3+Depr_Screen_Major_Depr_Plan_R1+Depr_Screen_Major_Depr_Plan_R2+Depr_Screen_Major_Depr_Plan_E1+Depr_Screen_Major_Depr_Plan_E2+Depr_Screen_Major_Depr_Plan_E3+Depr_Screen_Major_Depr_Plan_E4+Depr_Screen_Major_Depr_Plan_E5',v_CaseId,'MP') || '</managementPlan>' || LF;
  v_Str := v_Str || '        </section3Questions>' || LF;
    
  v_Str := v_Str || '        <section4Questions>' || LF;
  v_Str := v_Str || '           <groupTitle>Consider for Patients who do not meet the criteria above for major depression:</groupTitle>' || LF;
  v_Str := v_Str || '           <questions>' || LF;
  v_Str := v_Str || '             <title>If the patient does not meet the criteria above for the diagnosis of major depression, but has a risk score ? 5 takes medication to treat depression, then the patient meets the criteria for the diagnosis of depression.</title>' || LF;
  v_Str := v_Str || '             <value>' || Matrix_Utils.Get_InfoPathData('Depr_Screen_Depr',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '           </questions>' || LF;
  --v_Str := v_Str || '        <managementPlan>' || Matrix_Utils.Get_InfoPathData('Depr_Screen_Depr_Plan_M1+Depr_Screen_Depr_Plan_M2+Depr_Screen_Depr_Plan_M3+Depr_Screen_Depr_Plan_R1+Depr_Screen_Depr_Plan_R2+Depr_Screen_Depr_Plan_E1+Depr_Screen_Depr_Plan_E2+Depr_Screen_Depr_Plan_E3+Depr_Screen_Depr_Plan_E4+Depr_Screen_Depr_Plan_E5',v_CaseId,'MP') || '</managementPlan>' || LF;
  v_Str := v_Str || '        </section4Questions>' || LF;
  v_Str := v_Str || '   </DepressionScreen>' || LF;
  ------------------------------------
  RETURN v_Str;
EXCEPTION
WHEN OTHERS THEN
  v_Str := SUBSTR(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || CHR(13) || SQLERRM,1,4000);
  RAISE;
END MATRIX_XML_DEPRSCREEN;


FUNCTION MATRIX_XML_DIABETICSCREEN(
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
  v_Str := v_Str || '<DiabeticScreen>' || LF;
  v_Str := v_Str || '   <diagnosis>' || LF;
  v_Str := v_Str || '     <title>Diabetes Mellitus:</title>' || LF;
  v_Str := v_Str || '     <value>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '     <followupQuestions>' || LF;
  v_Str := v_Str || '       <title>Type</title>' || LF;
  v_Str := v_Str || '       <value>' || Matrix_Utils.Get_InfoPathData('Diabetes_Diag_Mellitus_type_1 + Diabetes_Diag_Mellitus_type_2',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '     </followupQuestions>' || LF;
  v_Str := v_Str || '   </diagnosis>' || lf;
  
  v_Str := v_Str || '   <diagnosis>' || LF;
  v_Str := v_Str || '     <title>Diabetes Mellitus: Controlled</title>' || LF;
  v_Str := v_Str || '     <value>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '     <followupQuestions>' || LF;
  v_Str := v_Str || '         <title>Controlled</title>' || LF;
  v_Str := v_Str || '         <value>' || Matrix_Utils.Get_InfoPathData('Diabetes_Diag_Controlled + Diabetes_Diag_Uncontrolled + Diabetes_Diag_Unknown',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '    </followupQuestions>' || LF;
  v_Str := v_Str || '      <managementPlan>' || Matrix_Utils.Get_InfoPathData('Diabetes_Diag_Mellitus_Plan_E1
+Diabetes_Diag_Mellitus_Plan_E2
+Diabetes_Diag_Mellitus_Plan_E3
+Diabetes_Diag_Mellitus_Plan_E4
+Diabetes_Diag_Mellitus_Plan_E5
+Diabetes_Diag_Mellitus_Plan_M1
+Diabetes_Diag_Mellitus_Plan_M2
+Diabetes_Diag_Mellitus_Plan_M3
+Diabetes_Diag_Mellitus_Plan_R1
+Diabetes_Diag_Mellitus_Plan_R2',v_CaseId,'MP') || '</managementPlan>' || LF;
  v_Str := v_Str || '   </diagnosis>' || lf;
  
  
  v_Str := v_Str || '   <diagnosis>' || LF;
  v_Str := v_Str || '     <title>Ophthalmic Complications</title>' || LF;
  v_Str := v_Str || '     <value>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '     <followupQuestions>' || LF;
  v_Str := v_Str || '         <title>Background Diabetic Retinopathy</title>' || LF;
  v_Str := v_Str || '         <value>' || Matrix_Utils.Get_InfoPathData('Diabetes_Background_Retinopathy',v_CaseId,'YN') || '</value>' || LF;
  v_Str := v_Str || '     </followupQuestions>' || LF;
  v_Str := v_Str || '     <followupQuestions>' || LF;
  v_Str := v_Str || '         <title>Proliferative Diabetic Retinopathy</title>' || LF;
  v_Str := v_Str || '         <value>' || Matrix_Utils.Get_InfoPathData('Diabetes_Proliferative_Retinopathy',v_CaseId,'YN') || '</value>' || LF;
  v_Str := v_Str || '            <secondaryQuestions>' || LF;
  v_Str := v_Str || '                  <title>Diabetic Macular/Retinal Edema (if clearly documented)</title>' || LF;
  v_Str := v_Str || '                  <answer></answer>' || LF;
  v_Str := v_Str || '                  <value>' || Matrix_Utils.Get_InfoPathData('Diabetes_Edema',v_CaseId,'YN') || '</value>' || LF;
  v_Str := v_Str || '            </secondaryQuestions>' || LF;
  v_Str := v_Str || '            <secondaryQuestions>' || LF;
  v_Str := v_Str || '                  <title>Specific Diagnosis if known:</title>' || LF;
  v_Str := v_Str || '                  <answer>' || Matrix_Utils.Get_InfoPathData('Diabetes_Edema_Diagnosis_Box',v_CaseId,'ST') || '</answer>' || LF;  
  v_Str := v_Str || '                  <value>' || Matrix_Utils.Get_InfoPathData('Diabetes_Edema_Diagnosis',v_CaseId,'YN') || '</value>' || LF;
  v_Str := v_Str || '            </secondaryQuestions>' || LF;
  v_Str := v_Str || '     </followupQuestions>' || LF;
  v_Str := v_Str || '     <managementPlan>' || Matrix_Utils.Get_InfoPathData('Diabetes_Retina_Plan_E1
+Diabetes_Retina_Plan_E2
+Diabetes_Retina_Plan_E3
+Diabetes_Retina_Plan_E4
+Diabetes_Retina_Plan_E5
+Diabetes_Retina_Plan_M1
+Diabetes_Retina_Plan_M2
+Diabetes_Retina_Plan_M3
+Diabetes_Retina_Plan_R1
+Diabetes_Retina_Plan_R2',v_CaseId,'MP') || '</managementPlan>' || LF;
  v_Str := v_Str || '   </diagnosis>' || lf;
  
  v_Str := v_Str || '   <diagnosis>' || LF;
  v_Str := v_Str || '     <title>Peripheral Circulatory Complications</title>' || LF;
  v_Str := v_Str || '     <value>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '     <followupQuestions>' || LF;
  v_Str := v_Str || '         <title>Peripheral Angiopathy (peripheral arterial vascular disease - PVD)</title>' || LF;
  v_Str := v_Str || '         <value>' || Matrix_Utils.Get_InfoPathData('Diabetes_Diag_Peripheral_Angiopathy',v_CaseId,'YN') || '</value>' || LF;
  v_Str := v_Str || '     </followupQuestions>' || LF;
  v_Str := v_Str || '     <followupQuestions>' || LF;
  v_Str := v_Str || '         <title>Gangrene</title>' || LF;
  v_Str := v_Str || '         <value>' || Matrix_Utils.Get_InfoPathData('Diabetes_Diag_Gangrene',v_CaseId,'YN') || '</value>' || LF;
  v_Str := v_Str || '            <secondaryQuestions>' || LF;
  v_Str := v_Str || '                  <title>Specify:</title>' || LF;
  v_Str := v_Str || '                  <answer>' || Matrix_Utils.Get_InfoPathData('Diabetes_Diag_Gangrene_Specify',v_CaseId,'ST') || '</answer>' || LF;
  v_Str := v_Str || '                  <value>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '            </secondaryQuestions>' || LF;
  v_Str := v_Str || '     </followupQuestions>' || LF;
  v_Str := v_Str || '     <followupQuestions>' || LF;
  v_Str := v_Str || '         <title>Amputation</title>' || LF;
  v_Str := v_Str || '         <value>' || Matrix_Utils.Get_InfoPathData('Diabetes_Diag_Amputation',v_CaseId,'YN') || '</value>' || LF;
  v_Str := v_Str || '            <secondaryQuestions>' || LF;
  v_Str := v_Str || '                  <title>Amputation location</title>' || LF;
  v_Str := v_Str || '                  <answer>' || Matrix_Utils.Get_InfoPathData('Diabetes_Diag_Amputation_Location',v_CaseId,'ST') || '</answer>' || LF;
  v_Str := v_Str || '                  <value></value>' || LF;
  v_Str := v_Str || '            </secondaryQuestions>' || LF;
  v_Str := v_Str || '     </followupQuestions>' || LF;
  v_Str := v_Str || '     <managementPlan>' || Matrix_Utils.Get_InfoPathData('
+Diabetes_Diag_Peripheral_Plan_E1
+Diabetes_Diag_Peripheral_Plan_E2
+Diabetes_Diag_Peripheral_Plan_E3
+Diabetes_Diag_Peripheral_Plan_E4
+Diabetes_Diag_Peripheral_Plan_E5
+Diabetes_Diag_Peripheral_Plan_M1
+Diabetes_Diag_Peripheral_Plan_M2
+Diabetes_Diag_Peripheral_Plan_M3
+Diabetes_Diag_Peripheral_Plan_R1
+Diabetes_Diag_Peripheral_Plan_R2',v_CaseId,'MP') || '</managementPlan>' || LF;
  v_Str := v_Str || '   </diagnosis>' || lf;
  
  v_Str := v_Str || '   <diagnosis>' || LF;
  v_Str := v_Str || '     <title>Renal Complications</title>' || LF;
  v_Str := v_Str || '     <value>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '     <followupQuestions>' || LF;
  v_Str := v_Str || '         <title>Diabetic Nephropathy</title>' || LF;
  v_Str := v_Str || '         <value>' || Matrix_Utils.Get_InfoPathData('Diabetes_Nephropathy',v_CaseId,'YN') || '</value>' || LF;
  v_Str := v_Str || '     </followupQuestions>' || LF;
  v_Str := v_Str || '     <followupQuestions>' || LF;
  v_Str := v_Str || '         <title>Chronic Kidney Disease</title>' || LF;
  v_Str := v_Str || '         <value>' || Matrix_Utils.Get_InfoPathData('Diabetes_Kidney_Disease',v_CaseId,'YN') || '</value>' || LF;
  v_Str := v_Str || '            <secondaryQuestions>' || LF;
  v_Str := v_Str || '                  <title>Stage</title>' || LF;
  v_Str := v_Str || '                  <answer>' || Matrix_Utils.Get_InfoPathData('Diabetes_Kidney_Disease_Stage',v_CaseId,'YN') || '</answer>' || LF;
  v_Str := v_Str || '                  <value>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '            </secondaryQuestions>' || LF;
  v_Str := v_Str || '            <secondaryQuestions>' || LF;
  v_Str := v_Str || '                  <title>Currently on dialysis</title>' || LF;
  v_Str := v_Str || '                  <answer>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</answer>' || LF;
  v_Str := v_Str || '                  <value>' || Matrix_Utils.Get_InfoPathData('Diabetes_On_Dialysis',v_CaseId,'YN') || '</value>' || LF;
  v_Str := v_Str || '            </secondaryQuestions>' || LF;
  v_Str := v_Str || '     </followupQuestions>' || LF;
  v_Str := v_Str || '     <managementPlan>' || Matrix_Utils.Get_InfoPathData('Diabetes_Kidney_Plan_E1
+Diabetes_Kidney_Plan_E2
+Diabetes_Kidney_Plan_E3
+Diabetes_Kidney_Plan_E4
+Diabetes_Kidney_Plan_E5
+Diabetes_Kidney_Plan_M1
+Diabetes_Kidney_Plan_M2
+Diabetes_Kidney_Plan_M3
+Diabetes_Kidney_Plan_R1
+Diabetes_Kidney_Plan_R2',v_CaseId,'MP') || '</managementPlan>' || LF;
  v_Str := v_Str || '   </diagnosis>' || lf;
  
  v_Str := v_Str || '   <diagnosis>' || LF;
  v_Str := v_Str || '    <title>Long Term (Current) Use of Insulin</title>' || LF;
  v_Str := v_Str || '    <value>' || Matrix_Utils.Get_InfoPathData('Diabetes_Use_Insulin',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '    <managementPlan>' || Matrix_Utils.Get_InfoPathData('Diabetes_Use_Insulin_Plan_E1
+Diabetes_Use_Insulin_Plan_E2
+Diabetes_Use_Insulin_Plan_E3
+Diabetes_Use_Insulin_Plan_E4
+Diabetes_Use_Insulin_Plan_E5
+Diabetes_Use_Insulin_Plan_M1
+Diabetes_Use_Insulin_Plan_M2
+Diabetes_Use_Insulin_Plan_M3
+Diabetes_Use_Insulin_Plan_R1
+Diabetes_Use_Insulin_Plan_R2',v_CaseId,'MP') || '</managementPlan>' || LF;
  
  v_Str := v_Str || '   </diagnosis>' || lf;
  
  v_Str := v_Str || '   <diagnosis>' || LF;
  v_Str := v_Str || '        <title>Other Diabetic Complications</title>' || LF;
  v_Str := v_Str || '        <value>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '     <followupQuestions>' || LF;
  v_Str := v_Str || '         <title>Diabetic Ulcer</title>' || LF;
  v_Str := v_Str || '         <value>' || Matrix_Utils.Get_InfoPathData('Diabetes_NonPressure_Ulcer',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '            <secondaryQuestions>' || LF;
  v_Str := v_Str || '                  <title>Site</title>' || LF;
  v_Str := v_Str || '                  <answer>' || Matrix_Utils.Get_InfoPathData('Diabetes_NonPressure_Ulcer_Site',v_CaseId,'ST') || '</answer>' || LF;
  v_Str := v_Str || '                  <value>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '            </secondaryQuestions>' || LF;
  v_Str := v_Str || '     </followupQuestions>' || LF;
  v_Str := v_Str || '     <followupQuestions>' || LF;
  v_Str := v_Str || '         <title>Diabetic Hypoglycemia (acute)</title>' || LF;
  v_Str := v_Str || '         <value>' || Matrix_Utils.Get_InfoPathData('Diabetes_Hypoglycemia',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '     </followupQuestions>' || LF;
  v_Str := v_Str || '     <managementPlan>' || Matrix_Utils.Get_InfoPathData('Diabetes_NonPressure_Ulcer_Plan_E1
+Diabetes_NonPressure_Ulcer_Plan_E2
+Diabetes_NonPressure_Ulcer_Plan_E3
+Diabetes_NonPressure_Ulcer_Plan_E4
+Diabetes_NonPressure_Ulcer_Plan_E5
+Diabetes_NonPressure_Ulcer_Plan_M1
+Diabetes_NonPressure_Ulcer_Plan_M2
+Diabetes_NonPressure_Ulcer_Plan_M3
+Diabetes_NonPressure_Ulcer_Plan_R1
+Diabetes_NonPressure_Ulcer_Plan_R2',v_CaseId,'MP') || '</managementPlan>' || LF;
  v_Str := v_Str || '   </diagnosis>' || lf;
  
  v_Str := v_Str || '   <diagnosis>' || LF;
  v_Str := v_Str || '        <title>Neurologic Complications</title>' || LF;
  v_Str := v_Str || '        <value>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '     <followupQuestions>' || LF;
  v_Str := v_Str || '         <title>Diabetic Peripheral Neuropathy</title>' || LF;
  v_Str := v_Str || '         <value>' || Matrix_Utils.Get_InfoPathData('Diabetes_Diag_Peripheral_Neuropathy',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '     </followupQuestions>' || LF;
  v_Str := v_Str || '     <followupQuestions>' || LF;
  v_Str := v_Str || '         <title>Diabetic Autonomic Neuropathy</title>' || LF;
  v_Str := v_Str || '         <value>' || Matrix_Utils.Get_InfoPathData('Diabetes_Diag_Autonomic_Neuropathy',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '            <secondaryQuestions>' || LF;
  v_Str := v_Str || '                  <title>Gastroparesis</title>' || LF;
  v_Str := v_Str || '                  <answer>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</answer>' || LF;  
  v_Str := v_Str || '                  <value>' || Matrix_Utils.Get_InfoPathData('Diabetes_Diag_Gastroparesis',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '            </secondaryQuestions>' || LF;
  v_Str := v_Str || '            <secondaryQuestions>' || LF;
  v_Str := v_Str || '                  <title>Other:</title>' || LF;
  v_Str := v_Str || '                  <answer>' || Matrix_Utils.Get_InfoPathData('Diabetes_Diag_Other_Box',v_CaseId,'ST') || '</answer>' || LF;
  v_Str := v_Str || '                  <value>' || Matrix_Utils.Get_InfoPathData('Diabetes_Diag_Other',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '            </secondaryQuestions>' || LF;
  v_Str := v_Str || '     </followupQuestions>' || LF;
  v_Str := v_Str || '     <managementPlan>' || Matrix_Utils.Get_InfoPathData('Diabetes_Diag_Neuro_Plan_1_E1
+Diabetes_Diag_Neuro_Plan_1_E2
+Diabetes_Diag_Neuro_Plan_1_E3
+Diabetes_Diag_Neuro_Plan_1_E4
+Diabetes_Diag_Neuro_Plan_1_E5
+Diabetes_Diag_Neuro_Plan_1_M1
+Diabetes_Diag_Neuro_Plan_1_M2
+Diabetes_Diag_Neuro_Plan_1_M3
+Diabetes_Diag_Neuro_Plan_1_R1
+Diabetes_Diag_Neuro_Plan_1_R2',v_CaseId,'MP') || '</managementPlan>' || LF;
  v_Str := v_Str || '   </diagnosis>' || lf;
  
  
  v_Str := v_Str || '   <screenGroups>' || LF;
  v_Str := v_Str || '        <title>Diabetic neurologic complications: peripheral neuropathy</title>' || LF;
  v_Str := v_Str || '        <value>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        <questions>' || LF;
  v_Str := v_Str || '           <title>On questioning patient notes experiencing numbness and/or tingling in hands or feet</title>' || LF;
  v_Str := v_Str || '           <value>' || Matrix_Utils.Get_InfoPathData('Diabetes_Peripheral_Numbness',v_CaseId,'YN') || '</value>' || LF;
  v_Str := v_Str || '        </questions>' || LF;
  v_Str := v_Str || '        <questions>' || LF;
  v_Str := v_Str || '           <title>On exam has decreased sensation in feet</title>' || LF;
  v_Str := v_Str || '           <value>' || Matrix_Utils.Get_InfoPathData('Diabetes_Peripheral_Sensation',v_CaseId,'YN') || '</value>' || LF;
  v_Str := v_Str || '        </questions>' || LF;
  v_Str := v_Str || '        <questions>' || LF;
  v_Str := v_Str || '           <title>Has been prescribed medicine to treat peripheral neuropathy symptoms</title>' || LF;
  v_Str := v_Str || '           <value>' || Matrix_Utils.Get_InfoPathData('Diabetes_Peripheral_Medication',v_CaseId,'YN') || '</value>' || LF;
  v_Str := v_Str || '        </questions>' || LF;
  v_Str := v_Str || '   </screenGroups>' || LF;
  v_Str := v_Str || '   <screenGroups>' || LF;
  v_Str := v_Str || '        <title>Diabetic neurologic complications: autonomic neuropathy</title>' || LF;
  v_Str := v_Str || '        <value>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;  
  v_Str := v_Str || '        <questions>' || LF;
  v_Str := v_Str || '           <title>Gives history of wide swings in blood pressure or temperature</title>' || LF;
  v_Str := v_Str || '           <value>' || Matrix_Utils.Get_InfoPathData('Diabetes_Autonomic_Swings',v_CaseId,'YN') || '</value>' || LF;
  v_Str := v_Str || '        </questions>' || LF;
  v_Str := v_Str || '        <questions>' || LF;
  v_Str := v_Str || '           <title>Gives history of difficulty digesting meals because stomach doesn''t empty properly</title>' || LF;
  v_Str := v_Str || '           <value>' || Matrix_Utils.Get_InfoPathData('Diabetes_Autonomic_Digesting',v_CaseId,'YN') || '</value>' || LF;
  v_Str := v_Str || '        </questions>' || LF;
  v_Str := v_Str || '   </screenGroups>' || LF;
  v_Str := v_Str || '   <screenGroups>' || LF;
  v_Str := v_Str || '        <title>Diabetic cirulatory complications: peripheral vascular disease on exam of the lower extremities and feet</title>' || LF;
  v_Str := v_Str || '        <value>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        <questions>' || LF;
  v_Str := v_Str || '           <title>Has decreased pulses</title>' || LF;
  v_Str := v_Str || '           <value>' || Matrix_Utils.Get_InfoPathData('Diabetes_Circulatory_Decreased_Pulses',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </questions>' || LF;
  v_Str := v_Str || '        <questions>' || LF;
  v_Str := v_Str || '           <title>Has decreased temperature, hair loss, and thin shiny skin consistent with arterial insufficiency</title>' || LF;
  v_Str := v_Str || '           <value>' || Matrix_Utils.Get_InfoPathData('Diabetes_Circulatory_Decreased_Temp',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </questions>' || LF;
  v_Str := v_Str || '        <questions>' || LF;
  v_Str := v_Str || '         <title>Has evidence of arterial ulcer</title>' || LF;
  v_Str := v_Str || '         <value>' || Matrix_Utils.Get_InfoPathData('Diabetes_Circulatory_Arterial_Ulcer',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '            <extraData>' || LF;
  v_Str := v_Str || '                  <title>Location:</title>' || LF;
  v_Str := v_Str || '                  <value>' || Matrix_Utils.Get_InfoPathData('Diabetes_Circulatory_Arterial_Ulcer_Location',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '            </extraData>' || LF;
  v_Str := v_Str || '        </questions>' || LF;
  v_Str := v_Str || '        <questions>' || LF;
  v_Str := v_Str || '         <title>Has evidence of gangrene</title>' || LF;
  v_Str := v_Str || '         <value>' || Matrix_Utils.Get_InfoPathData('Diabetes_Circulatory_Gangrene',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '            <extraData>' || LF;
  v_Str := v_Str || '                  <title>Location:</title>' || LF;
  v_Str := v_Str || '                  <value>' || Matrix_Utils.Get_InfoPathData('Diabetes_Circulatory_Gangrene_Location',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '            </extraData>' || LF;
  v_Str := v_Str || '        </questions>' || LF;
  v_Str := v_Str || '        <questions>' || LF;
  v_Str := v_Str || '         <title>Has evidence of amputation resulting from poor circulation</title>' || LF;
  v_Str := v_Str || '         <value>' || Matrix_Utils.Get_InfoPathData('Diabetes_Circulatory_Amputation',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '            <extraData>' || LF;
  v_Str := v_Str || '                  <title>Location:</title>' || LF;
  v_Str := v_Str || '                  <value>' || Matrix_Utils.Get_InfoPathData('Diabetes_Circulatory_Amputation_Location',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '            </extraData>' || LF;
  v_Str := v_Str || '        </questions>' || LF;
  v_Str := v_Str || '        <questions>' || LF;
  v_Str := v_Str || '           <title>Provides history consistent with intermittent claudication</title>' || LF;
  v_Str := v_Str || '           <value>' || Matrix_Utils.Get_InfoPathData('Diabetes_Circulatory_Claudication',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </questions>' || LF;
  v_Str := v_Str || '        <questions>' || LF;
  v_Str := v_Str || '           <title>Has been prescribed medicine to try to improve peripheral circulation</title>' || LF;
  v_Str := v_Str || '           <value>' || Matrix_Utils.Get_InfoPathData('Diabetes_Circulatory_Medication',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </questions>' || LF;
  v_Str := v_Str || '        <questions>' || LF;
  v_Str := v_Str || '           <title>Has a history of vascular surgery to improve peripheral circulation</title>' || LF;
  v_Str := v_Str || '           <value>' || Matrix_Utils.Get_InfoPathData('Diabetes_Circulatory_Surgery',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </questions>' || LF;
  v_Str := v_Str || '   </screenGroups>' || LF;
  
  v_Str := v_Str || '   <screenGroups>' || LF;
  v_Str := v_Str || '        <title>Diabetic ophthalmic complications: retinopathy</title>' || LF;
  v_Str := v_Str || '        <value>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        <questions>' || LF;
  v_Str := v_Str || '         <title>Has been diagnosed by an eye specialist</title>' || LF;
  v_Str := v_Str || '         <value>' || Matrix_Utils.Get_InfoPathData('Diabetes_Ophthalmic_Diagnosed',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '            <extraData>' || LF;
  v_Str := v_Str || '                  <title>specific diagnosis known?</title>' || LF;
  v_Str := v_Str || '                  <value>' || Matrix_Utils.Get_InfoPathData('Diabetes_Ophthalmic_Diagnosis',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '            </extraData>' || LF;
  v_Str := v_Str || '        </questions>' || LF;
  v_Str := v_Str || '        <questions>' || LF;
  v_Str := v_Str || '           <title>Has received treatment such as laser treatment for diabetic retinal disease</title>' || LF;
  v_Str := v_Str || '           <value>' || Matrix_Utils.Get_InfoPathData('Diabetes_Ophthalmic_Treatment',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </questions>' || LF;
  v_Str := v_Str || '        <questions>' || LF;
  v_Str := v_Str || '           <title>Is blind as a result of diabetic retinopathy</title>' || LF;
  v_Str := v_Str || '           <value>' || Matrix_Utils.Get_InfoPathData('Diabetes_Ophthalmic_Blind',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </questions>' || LF;
  v_Str := v_Str || '   </screenGroups>' || LF;
  
  v_Str := v_Str || '   <screenGroups>' || LF;
  v_Str := v_Str || '        <title>Diabetic renal complications: nephropathy</title>' || LF;
  v_Str := v_Str || '        <value>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        <questions>' || LF;
  v_Str := v_Str || '           <title>Has been diagnosised with chronic kidney disease due to diabetes</title>' || LF;
  v_Str := v_Str || '           <value>' || Matrix_Utils.Get_InfoPathData('Diabetes_Renal_Kidney_Disease',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </questions>' || LF;
  v_Str := v_Str || '        <questions>' || LF;
  v_Str := v_Str || '           <title>Has been advised to take medication or modify diet due to kidney disease</title>' || LF;
  v_Str := v_Str || '           <value>' || Matrix_Utils.Get_InfoPathData('Diabetes_Renal_Medication',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </questions>' || LF;
  v_Str := v_Str || '        <questions>' || LF;
  v_Str := v_Str || '           <title>Has been told there is excess protein or albumin in urine</title>' || LF;
  v_Str := v_Str || '           <value>' || Matrix_Utils.Get_InfoPathData('Diabetes_Renal_Excess_Protein',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </questions>' || LF;
  v_Str := v_Str || '        <questions>' || LF;
  v_Str := v_Str || '           <title>Is currently treated with dialysis</title>' || LF;
  v_Str := v_Str || '           <value>' || Matrix_Utils.Get_InfoPathData('Diabetes_Renal_Treated',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </questions>' || LF;
  v_Str := v_Str || '        <questions>' || LF;
  v_Str := v_Str || '           <title>Is currently treated with dialysis</title>' || LF;
  v_Str := v_Str || '           <value>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </questions>' || LF;
  v_Str := v_Str || '   </screenGroups>' || LF;
  
  v_Str := v_Str || '   <testingGroup>' || LF;
  v_Str := v_Str || '        <desc></desc>' || LF;
  v_Str := v_Str || '        <title>Does the patient have regular testing of (check all that apply):</title>' || LF;
  
  /***
  v_Str := v_Str || '        <questions>' || LF;
  v_Str := v_Str || '         <title>Self-monitoring blood glucose</title>' || LF;
  v_Str := v_Str || '         <status>' || Matrix_Utils.Get_InfoPathData('Diabetes_Blood_Sugar',v_CaseId,'YN') || '</status>' || LF;
  v_Str := v_Str || '         <value>' || Matrix_Utils.Get_InfoPathData('Diabetes_Blood_Sugar_Result',v_CaseId,'YN') || '</value>' || LF;
  v_Str := v_Str || '         <date>' || Matrix_Utils.Get_InfoPathData('Diabetes_Blood_Sugar_Result_Date',v_CaseId,'DT') || '</date>' || LF;
  v_Str := v_Str || '            <secondaryQuestions>' || LF;
  v_Str := v_Str || '               <title>self-testing</title>' || LF;
  v_Str := v_Str || '               <answer>' || Matrix_Utils.Get_InfoPathData('Diabetes_Blood_Sugar_Self',v_CaseId,'TF') || '</answer>' || LF;
  v_Str := v_Str || '            </secondaryQuestions>' || LF;
  v_Str := v_Str || '        </questions>' || LF;
 **/ 
  
  v_Str := v_Str || '        <questions>' || LF;
  v_Str := v_Str || '         <title>Self-monitoring blood glucose</title>' || LF;
  v_Str := v_Str || '         <status>' || Matrix_Utils.Get_InfoPathData('Diabetes_Blood_Sugar',v_CaseId,'YN') || '</status>' || LF;
  v_Str := v_Str || '        </questions>' || LF; 

  v_Str := v_Str || '        <questions>' || LF;
  v_Str := v_Str || '         <title>Self-monitoring blood glucose result</title>' || LF;  
  v_Str := v_Str || '         <status>' || Matrix_Utils.Get_InfoPathData('Diabetes_Blood_Sugar_Result',v_CaseId,'YN') || '</status>' || LF;
  v_Str := v_Str || '        </questions>' || LF;
 
  v_Str := v_Str || '        <questions>' || LF;
  v_Str := v_Str || '         <title>Self-monitoring blood glucose result date</title>' || LF;   
  v_Str := v_Str || '         <status>' || Matrix_Utils.Get_InfoPathData('Diabetes_Blood_Sugar_Result_Date',v_CaseId,'DT') || '</status>' || LF;
  v_Str := v_Str || '        </questions>' || LF;
 
  v_Str := v_Str || '        <questions>' || LF;
  v_Str := v_Str || '         <title>Self-monitoring blood glucose self-testing</title>' || LF;   
  v_Str := v_Str || '         <status>' || Matrix_Utils.Get_InfoPathData('Diabetes_Blood_Sugar_Self',v_CaseId,'TF') || '</status>' || LF;
  v_Str := v_Str || '        </questions>' || LF;

/**
v_Str := v_Str || '        <questions>' || LF;
  v_Str := v_Str || '         <title>HbA1c</title>' || LF;
  v_Str := v_Str || '         <status>' || Matrix_Utils.Get_InfoPathData('Diabetes_HbA1C',v_CaseId,'YN') || '</status>' || LF;
  v_Str := v_Str || '         <value>' || Matrix_Utils.Get_InfoPathData('Diabetes_HbA1C_Result',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '         <date>' || Matrix_Utils.Get_InfoPathData('Diabetes_HbA1C_Result_Date',v_CaseId,'DT') || '</date>' || LF;
  v_Str := v_Str || '        </questions>' || LF;
 **/   
  
  v_Str := v_Str || '        <questions>' || LF;
  v_Str := v_Str || '         <title>HbA1c</title>' || LF;
  v_Str := v_Str || '         <status>' || Matrix_Utils.Get_InfoPathData('Diabetes_HbA1C',v_CaseId,'YN') || '</status>' || LF;
  v_Str := v_Str || '        </questions>' || LF;
  
  v_Str := v_Str || '        <questions>' || LF;
  v_Str := v_Str || '         <title>HbA1c result</title>' || LF;  
  v_Str := v_Str || '         <status>' || Matrix_Utils.Get_InfoPathData('Diabetes_HbA1C_Result',v_CaseId,'ST') || '</status>' || LF;
  v_Str := v_Str || '        </questions>' || LF;

  v_Str := v_Str || '        <questions>' || LF;
  v_Str := v_Str || '         <title>HbA1c result date</title>' || LF;
  v_Str := v_Str || '         <status>' || Matrix_Utils.Get_InfoPathData('Diabetes_HbA1C_Result_Date',v_CaseId,'DT') || '</status>' || LF;
  v_Str := v_Str || '        </questions>' || LF;

/**
  v_Str := v_Str || '        <questions>' || LF;
  v_Str := v_Str || '          <title>Urine for protein</title>' || LF;
  v_Str := v_Str || '          <status>' || Matrix_Utils.Get_InfoPathData('Diabetes_Protein',v_CaseId,'YN') || '</status>' || LF;
  v_Str := v_Str || '          <value>' || Matrix_Utils.Get_InfoPathData('Diabetes_Protein_Result',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '          <date>' || Matrix_Utils.Get_InfoPathData('Diabetes_Protein_Result_Date',v_CaseId,'DT') || '</date>' || LF;
  v_Str := v_Str || '        </questions>' || LF;
***/
  
  v_Str := v_Str || '        <questions>' || LF;
  v_Str := v_Str || '          <title>Urine for protein</title>' || LF;
  v_Str := v_Str || '          <status>' || Matrix_Utils.Get_InfoPathData('Diabetes_Protein',v_CaseId,'YN') || '</status>' || LF;
  v_Str := v_Str || '        </questions>' || LF;

  v_Str := v_Str || '        <questions>' || LF;  
  v_Str := v_Str || '          <title>Urine for protein result</title>' || LF;  
  v_Str := v_Str || '          <status>' || Matrix_Utils.Get_InfoPathData('Diabetes_Protein_Result',v_CaseId,'ST') || '</status>' || LF;
  v_Str := v_Str || '        </questions>' || LF;

  v_Str := v_Str || '        <questions>' || LF;
  v_Str := v_Str || '          <title>Urine for protein date</title>' || LF;  
  v_Str := v_Str || '          <status>' || Matrix_Utils.Get_InfoPathData('Diabetes_Protein_Result_Date',v_CaseId,'DT') || '</status>' || LF;
  v_Str := v_Str || '        </questions>' || LF;
  
/***
  v_Str := v_Str || '        <questions>' || LF;
  v_Str := v_Str || '         <title>Cholesterol/LDL-C</title>' || LF;
  v_Str := v_Str || '         <status>' || Matrix_Utils.Get_InfoPathData('Diabetes_LDL',v_CaseId,'YN') || '</status>' || LF;
  v_Str := v_Str || '         <value>' || Matrix_Utils.Get_InfoPathData('Diabetes_LDL_Result',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '         <date>' || Matrix_Utils.Get_InfoPathData('Diabetes_LDL_Result_Date',v_CaseId,'DT') || '</date>' || LF;
  v_Str := v_Str || '        </questions>' || LF;
**/  

  v_Str := v_Str || '        <questions>' || LF;
  v_Str := v_Str || '         <title>Cholesterol/LDL-C</title>' || LF;
  v_Str := v_Str || '         <status>' || Matrix_Utils.Get_InfoPathData('Diabetes_LDL',v_CaseId,'YN') || '</status>' || LF;
  v_Str := v_Str || '        </questions>' || LF;

  v_Str := v_Str || '        <questions>' || LF;
  v_Str := v_Str || '         <title>Cholesterol/LDL-C result</title>' || LF;
  v_Str := v_Str || '         <status>' || Matrix_Utils.Get_InfoPathData('Diabetes_LDL_Result',v_CaseId,'ST') || '</status>' || LF;
  v_Str := v_Str || '        </questions>' || LF;

  v_Str := v_Str || '        <questions>' || LF;  
  v_Str := v_Str || '         <title>Cholesterol/LDL-C date</title>' || LF;  
  v_Str := v_Str || '         <status>' || Matrix_Utils.Get_InfoPathData('Diabetes_LDL_Result_Date',v_CaseId,'DT') || '</status>' || LF;
  v_Str := v_Str || '        </questions>' || LF;

/***  
  v_Str := v_Str || '        <questions>' || LF;
  v_Str := v_Str || '         <title>Diabetic foot exam</title>' || LF;
  v_Str := v_Str || '         <status>' || Matrix_Utils.Get_InfoPathData('Diabetes_Foot_Exam',v_CaseId,'YN') || '</status>' || LF;
  v_Str := v_Str || '         <value>' || Matrix_Utils.Get_InfoPathData('Diabetes_Foot_Exam_Result',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '         <date>' || Matrix_Utils.Get_InfoPathData('Diabetes_Foot_Exam_Result_Date',v_CaseId,'DT') || '</date>' || LF;
  v_Str := v_Str || '        </questions>' || LF;
**/  

  v_Str := v_Str || '        <questions>' || LF;
  v_Str := v_Str || '         <title>Diabetic foot exam</title>' || LF;
  v_Str := v_Str || '         <status>' || Matrix_Utils.Get_InfoPathData('Diabetes_Foot_Exam',v_CaseId,'YN') || '</status>' || LF;
  v_Str := v_Str || '        </questions>' || LF;

  v_Str := v_Str || '        <questions>' || LF;  
  v_Str := v_Str || '         <title>Diabetic foot exam result</title>' || LF;  
  v_Str := v_Str || '         <status>' || Matrix_Utils.Get_InfoPathData('Diabetes_Foot_Exam_Result',v_CaseId,'ST') || '</status>' || LF;
  v_Str := v_Str || '        </questions>' || LF;

  v_Str := v_Str || '        <questions>' || LF; 
  v_Str := v_Str || '         <title>Diabetic foot exam date</title>' || LF;  
  v_Str := v_Str || '         <status>' || Matrix_Utils.Get_InfoPathData('Diabetes_Foot_Exam_Result_Date',v_CaseId,'DT') || '</status>' || LF;
  v_Str := v_Str || '        </questions>' || LF;

/**  
  v_Str := v_Str || '        <questions>' || LF;
  v_Str := v_Str || '         <title>Dilated or retinal eye exam by an eye specialist</title>' || LF;
  v_Str := v_Str || '         <status>' || Matrix_Utils.Get_InfoPathData('Diabetes_Eye_Exam',v_CaseId,'YN') || '</status>' || LF;
  v_Str := v_Str || '         <value>' || Matrix_Utils.Get_InfoPathData('Diabetes_Eye_Exam_Result',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '         <date>' || Matrix_Utils.Get_InfoPathData('Diabetes_Eye_Exam_Result_Date',v_CaseId,'DT') || '</date>' || LF;
  v_Str := v_Str || '        </questions>' || LF;
  v_Str := v_Str || '   </testingGroup>' || LF;
**/  

  v_Str := v_Str || '        <questions>' || LF;
  v_Str := v_Str || '         <title>Dilated or retinal eye exam by an eye specialist</title>' || LF;
  v_Str := v_Str || '         <status>' || Matrix_Utils.Get_InfoPathData('Diabetes_Eye_Exam',v_CaseId,'YN') || '</status>' || LF;
  v_Str := v_Str || '        </questions>' || LF;

  v_Str := v_Str || '        <questions>' || LF; 
  v_Str := v_Str || '         <title>Dilated or retinal eye exam by an eye specialist result</title>' || LF;  
  v_Str := v_Str || '         <status>' || Matrix_Utils.Get_InfoPathData('Diabetes_Eye_Exam_Result',v_CaseId,'ST') || '</status>' || LF;
  v_Str := v_Str || '        </questions>' || LF;

  v_Str := v_Str || '        <questions>' || LF; 
  v_Str := v_Str || '         <title>Dilated or retinal eye exam by an eye specialist date</title>' || LF;  
  v_Str := v_Str || '         <status>' || Matrix_Utils.Get_InfoPathData('Diabetes_Eye_Exam_Result_Date',v_CaseId,'DT') || '</status>' || LF;
  v_Str := v_Str || '        </questions>' || LF;
  
  v_Str := v_Str || '   </testingGroup>' || LF;

  
  v_Str := v_Str || '</DiabeticScreen>' || LF;
  ------------------------------------
  RETURN v_Str;
EXCEPTION
WHEN OTHERS THEN
  v_Str := SUBSTR(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || CHR(13) || SQLERRM,1,4000);
  RAISE;
END MATRIX_XML_DIABETICSCREEN;

FUNCTION MATRIX_XML_FALLRISK(
    P_CASEID NUMBER ,
    P_LF     VARCHAR2 )
  -- Created 10-6-2012 R Benzell
  -- called by GEN_MATRIX_XML
  -- edited and completed 10-8-12 Denis
  RETURN CLOB
IS
  v_Str CLOB;
  v_CaseId NUMBER;
  LF       VARCHAR2(5);
BEGIN
  v_CaseId := P_CaseId;
  LF       := P_LF;
  -----------------------------------
  v_Str := v_Str || ' <FallRisk>' || LF;
  v_Str := v_Str || '   <diagnosis>' || LF;
  v_Str := v_Str || '        <title>History of falling or fall risk</title>' || LF; 
  v_Str := v_Str || '        <value>' || Matrix_Utils.Get_InfoPathData('Fall_Risk_History',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '   </diagnosis>' || LF;
--MG--<total> was paired up with the wrong Field Name. Immediately following the commented line below is my correction.
--  v_Str := v_Str || '   <total>' || Matrix_Utils.Get_InfoPathData('Fall_Risk_4_Responses_No + Fall_Risk_4_Responses_Yes',v_CaseId,'ST') || '</total>' || LF;
  v_Str := v_Str || '   <totalTitle>' || Matrix_Utils.Get_InfoPathData('Fall_Risk_Responses',v_CaseId,'ST') || '</totalTitle>' || LF;

/**  
    v_Str := v_Str || '        <managementPlan>' || Matrix_Utils.Get_InfoPathData('Fall_Risk_History_Plan_E1
+Fall_Risk_History_Plan_E2
+Fall_Risk_History_Plan_E3
+Fall_Risk_History_Plan_E4
+Fall_Risk_History_Plan_E5
+Fall_Risk_History_Plan_M1
+Fall_Risk_History_Plan_M2
+Fall_Risk_History_Plan_M3
+Fall_Risk_History_Plan_R1
+Fall_Risk_History_Plan_R2',v_CaseId,'MP') || '</managementPlan>' || LF;
**/
  
  v_Str := v_Str || '   <questions>' || LF;
  v_Str := v_Str || '        <title>Age>=65</title>' || LF;
  v_Str := v_Str || '        <value>' || Matrix_Utils.Get_InfoPathData('Fall_Risk_Age65+ Fall_Risk_Age65_No',v_CaseId,'YN') || '</value>' || LF;
  v_Str := v_Str || '   </questions>' || LF;
  v_Str := v_Str || '   <questions>' || LF;
  v_Str := v_Str || '        <title>3 or More Co-morbidities</title>' || LF;
  v_Str := v_Str || '        <value>' || Matrix_Utils.Get_InfoPathData('Fall_Risk_comorbidities+ Fall_Risk_comorbidities_No',v_CaseId,'YN') || '</value>' || LF;
  v_Str := v_Str || '   </questions>' || LF;
  v_Str := v_Str || '   <questions>' || LF;
  v_Str := v_Str || '        <title>Prior History of Falls Within 3 Months</title>' || LF;
  v_Str := v_Str || '        <value>' || Matrix_Utils.Get_InfoPathData('Fall_Risk_Prior_Falls + Fall_Risk_Prior_Falls_No',v_CaseId,'YN') || '</value>' || LF;
  v_Str := v_Str || '   </questions>' || LF;
  v_Str := v_Str || '   <questions>' || LF;
  v_Str := v_Str || '        <title>Incontinence</title>' || LF;
  v_Str := v_Str || '        <value>' || Matrix_Utils.Get_InfoPathData('Fall_Risk_Incontinence+ Fall_Risk_Incontinence_No',v_CaseId,'YN') || '</value>' || LF;
  v_Str := v_Str || '   </questions>' || LF;
  v_Str := v_Str || '   <questions>' || LF;
  v_Str := v_Str || '        <title>Visual Impairment</title>' || LF;
  v_Str := v_Str || '        <value>' || Matrix_Utils.Get_InfoPathData('Fall_Risk_Visual_Impairment+ Fall_Risk_Visual_Impairment_No?',v_CaseId,'YN') || '</value>' || LF;
  v_Str := v_Str || '   </questions>' || LF;
  v_Str := v_Str || '   <questions>' || LF;
  v_Str := v_Str || '        <title>Impaired Functional Mobility</title>' || LF;
  v_Str := v_Str || '        <value>' || Matrix_Utils.Get_InfoPathData('Fall_Risk_Impaired_Functionality+ Fall_Risk_Impaired_Functionality_No',v_CaseId,'YN') || '</value>' || LF;
  v_Str := v_Str || '   </questions>' || LF;
  v_Str := v_Str || '   <questions>' || LF;
  v_Str := v_Str || '        <title>Environmental Hazards</title>' || LF;
  v_Str := v_Str || '        <value>' || Matrix_Utils.Get_InfoPathData('Fall_Risk_Environmental_Hazards+ Fall_Risk_Environmental_Hazards_No',v_CaseId,'YN') || '</value>' || LF;
  v_Str := v_Str || '   </questions>' || LF;
  v_Str := v_Str || '   <questions>'|| LF;
  v_Str := v_Str || '        <title>Poly Pharmacy (4 or More Prescriptions)</title>' || LF;
  v_Str := v_Str || '        <value>' || Matrix_Utils.Get_InfoPathData('Fall_Risk_Poly+ Fall_Risk_Poly_No',v_CaseId,'YN') || '</value>' || LF;
  v_Str := v_Str || '   </questions>' || LF;
  v_Str := v_Str || '   <questions>' || LF;
  v_Str := v_Str || '        <title>Pain Impacting Level of Function</title>' || LF;
  v_Str := v_Str || '        <value>' || Matrix_Utils.Get_InfoPathData('Fall_Risk_Pain+ Fall_Risk_Pain_No',v_CaseId,'YN') || '</value>' || LF;
  v_Str := v_Str || '   </questions>' || LF;
  v_Str := v_Str || '   <questions>' || LF;
  v_Str := v_Str || '        <title>Cognitive Impairment</title>' || LF;
  v_Str := v_Str || '        <value>' || Matrix_Utils.Get_InfoPathData('Fall_Risk_Cog+ Fall_Risk_Cog_No',v_CaseId,'YN') || '</value>' || LF;
  v_Str := v_Str || '   </questions>' || LF;
  
  v_Str := v_Str || '   <questions>' || LF;
  v_Str := v_Str || '        <title>Are there ? 4 YES Responses (CONSIDERED AT RISK FOR FALLING)?</title>' || LF;
  v_Str := v_Str || '        <value>' || Matrix_Utils.Get_InfoPathData('Fall_Risk_4_Responses_Yes+ Fall_Risk_4_Responses_No',v_CaseId,'YN') || '</value>' || LF;
  v_Str := v_Str || '   </questions>' || LF;
  
  v_Str := v_Str || ' </FallRisk>' || LF;
  ------------------------------------
  RETURN v_Str;
EXCEPTION
WHEN OTHERS THEN
  v_Str := SUBSTR(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || CHR(13) || SQLERRM,1,4000);
  RAISE;
END MATRIX_XML_FALLRISK;

FUNCTION MATRIX_XML_FOCUSREVIEW(
    P_CASEID NUMBER ,
    P_LF     VARCHAR2 )
  -- Created 10-6-2012 R Benzell
  -- called by GEN_MATRIX_XML
  -- Edited and completed 10-8-12 Denis
  RETURN CLOB
IS
  v_Str CLOB;
  v_CaseId NUMBER;
  LF       VARCHAR2(5);
BEGIN
  v_CaseId := P_CaseId;
  LF       := P_LF;
  -----------------------------------
  v_Str := v_Str || ' <FocusedSystemsReview>' || LF;
  
  
  

  
  v_Str := v_Str || '   <items>' || LF;
  v_Str := v_Str || '     <title>Constitutional</title>' || LF;
  v_Str := v_Str || '     <value/>' || LF;
  v_Str := v_Str || '        <questions>' || LF;
  v_Str := v_Str || '            <title>Fatigue</title>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('Focused_Review_Fatigue',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </questions>' || LF;
  v_Str := v_Str || '        <questions>' || LF;
  v_Str := v_Str || '            <title>Weakness</title>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('Focused_Review_Weakness',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </questions>' || LF;
  v_Str := v_Str || '   </items>' || LF;
  
  v_Str := v_Str || '   <items>' || LF;
  v_Str := v_Str || '        <title>Respiratory</title>' || LF;
  v_Str := v_Str || '        <value/>' || LF;
  v_Str := v_Str || '        <questions>' || LF;
  v_Str := v_Str || '            <title>Bronchitis</title>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('Focused_Review_Bronchitis',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </questions>' || LF;
  v_Str := v_Str || '        <questions>' || LF;
  v_Str := v_Str || '            <title>Emphysema</title>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('Focused_Review_Emphysema',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </questions>' || LF;
  v_Str := v_Str || '        <questions>' || LF;
  v_Str := v_Str || '            <title>COPD</title>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('Focused_Review_COPD',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </questions>' || LF;
  v_Str := v_Str || '        <questions>' || LF;
  v_Str := v_Str || '            <title>Chronic Cough</title>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('Focused_Review_Cough',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </questions>' || LF;
  v_Str := v_Str || '        <questions>' || LF;
  v_Str := v_Str || '            <title>Coughing up blood</title>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('Focused_Review_Blood',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </questions>' || LF;
  v_Str := v_Str || '        <questions>' || LF;
  v_Str := v_Str || '            <title>Shortness of breath</title>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('Focused_Review_Breath',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </questions>' || LF;
  v_Str := v_Str || '        <questions>' || LF;
  v_Str := v_Str || '            <title>Asthma or Wheezing</title>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('Focused_Review_Asthma',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </questions>' || LF;
  v_Str := v_Str || '        <questions>' || LF;
  v_Str := v_Str || '            <title>Tuberculosis</title>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('Focused_Review_TB',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </questions>' || LF;
  v_Str := v_Str || '   </items>' || LF;
  v_Str := v_Str || '   <items>' || LF;
  v_Str := v_Str || '        <title>HEENT</title>' || LF;
  v_Str := v_Str || '        <value/>' || LF;
  v_Str := v_Str || '        <questions>' || LF;
  v_Str := v_Str || '            <title>Glaucoma</title>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('Focused_Review_Glaucoma',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </questions>' || LF;
  v_Str := v_Str || '        <questions>' || LF;
  v_Str := v_Str || '            <title>Blind</title>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('Focused_Review_Blind',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </questions>' || LF;
  v_Str := v_Str || '        <questions>' || LF;
  v_Str := v_Str || '            <title>Vision Impaired</title>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('Focused_Review_Vision_Impaired',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </questions>' || LF;
  v_Str := v_Str || '        <questions>' || LF;
  v_Str := v_Str || '            <title>Hearing Impaired</title>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('Focused_Review_Hearing_Impaired',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </questions>' || LF;
  v_Str := v_Str || '        <questions>' || LF;
  v_Str := v_Str || '            <title>Hoarseness</title>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('Focused_Review_Hoarseness',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </questions>' || LF;
  v_Str := v_Str || '        <questions>' || LF;
  v_Str := v_Str || '            <title>Difficulty swallowing</title>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('Focused_Review_Swallow',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </questions>' || LF;
  v_Str := v_Str || '        <questions>' || LF;
  v_Str := v_Str || '            <title>Lesions in mouth</title>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('Focused_Review_Lesions',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </questions>' || LF;
  v_Str := v_Str || '   </items>' || LF;
  v_Str := v_Str || '   <items>' || LF;
  v_Str := v_Str || '        <title>Genitourinary</title>' || LF;
  v_Str := v_Str || '        <value/>' || LF;
  v_Str := v_Str || '        <questions>' || LF;
  v_Str := v_Str || '            <title>Blood in urine</title>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('Focused_Review_Blood_Urine',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </questions>' || LF;
  v_Str := v_Str || '        <questions>' || LF;
  v_Str := v_Str || '            <title>Frequency</title>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('Focused_Review_Frequency',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '         </questions>' || LF;
  v_Str := v_Str || '         <questions>' || LF;
  v_Str := v_Str || '            <title>Urgency</title>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('Focused_Review_Urgency',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </questions>' || LF;
  v_Str := v_Str || '        <questions>' || LF;
  v_Str := v_Str || '            <title>Kidney Disease</title>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('Focused_Review_Kidney',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </questions>' || LF;
  v_Str := v_Str || '   </items>' || LF;
  v_Str := v_Str || '   <items>' || LF;
  v_Str := v_Str || '        <title>Skin</title>' || LF;
  v_Str := v_Str || '        <value/>' || LF;
  v_Str := v_Str || '        <questions>' || LF;
  v_Str := v_Str || '            <title>Skin Lesions/Changes</title>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('Focused_Review_Skin_Lesions',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </questions>' || LF;
  v_Str := v_Str || '        <questions>' || LF;
  v_Str := v_Str || '            <title>Decubitus (Pressure) Ulcer</title>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('Focused_Review_Skin_Decubitus +',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </questions>' || LF;
  v_Str := v_Str || '        <questions>' || LF;
  v_Str := v_Str || '            <title>Vascular (non-pressure) Ulcer</title>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('Focused_Review_Skin_Vascular',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </questions>' || LF;
  v_Str := v_Str || '        <questions>' || LF;
  v_Str := v_Str || '            <title>Rashes</title>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('Focused_Review_Skin_Rashes',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </questions>' || LF;
  v_Str := v_Str || '        <questions>' || LF;
  v_Str := v_Str || '            <title>Skin Cancer</title>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('Focused_Review_Skin_Cancer',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '            <extraData>' || LF;
  v_Str := v_Str || '                  <title>Type:</title>' || LF;
  v_Str := v_Str || '                  <value>' || Matrix_Utils.Get_InfoPathData('Focused_Review_Skin_Cancer_type',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '            </extraData>' || LF;
  v_Str := v_Str || '            <extraData>' || LF;
  v_Str := v_Str || '                  <title>Location:</title>' || LF;
  v_Str := v_Str || '                  <value>' || Matrix_Utils.Get_InfoPathData('Focused_Review_Skin_Cancer_Location',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '            </extraData>' || LF;
  v_Str := v_Str || '        </questions>' || LF;
  v_Str := v_Str || '   </items>' || LF;
  v_Str := v_Str || '   <items>' || LF;
  v_Str := v_Str || '        <title>Gastrointestinal</title>' || LF;
  v_Str := v_Str || '        <value/>' || LF;
  v_Str := v_Str || '        <questions>' || LF;
  v_Str := v_Str || '            <title>HeartBurn</title>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('Focused_Review_Heart_Burn',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </questions>' || LF;
  v_Str := v_Str || '        <questions>' || LF;
  v_Str := v_Str || '            <title>GERD</title>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('Focused_Review_Heart_Burn',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </questions>' || LF;
  v_Str := v_Str || '        <questions>' || LF;
  v_Str := v_Str || '            <title>Peptic ulcers</title>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('Focused_Review_Peptic',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </questions>' || LF;
  v_Str := v_Str || '        <questions>' || LF;
  v_Str := v_Str || '            <title>Change in bowel movements</title>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('Focused_Review_BMS',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </questions>' || LF;
  v_Str := v_Str || '        <questions>' || LF;
  v_Str := v_Str || '            <title>Blood in stool(GI Bleed)</title>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('Focused_Review_Stool',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </questions>' || LF;
  v_Str := v_Str || '        <questions>' || LF;
  v_Str := v_Str || '            <title>Constipation</title>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('Focused_Review_Constipation',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </questions>' || LF;
  v_Str := v_Str || '        <questions>' || LF;
  v_Str := v_Str || '            <title>Incontinence of stool</title>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('Focused_Review_Incontinence',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </questions>' || LF;
  v_Str := v_Str || '        <questions>' || LF;
  v_Str := v_Str || '            <title>Liver disease</title>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('Focused_Review_Liver',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </questions>' || LF;
  v_Str := v_Str || '   </items>' || LF;
  v_Str := v_Str || '   <items>' || LF;
  v_Str := v_Str || '        <title>Cardiovascular</title>' || LF;
  v_Str := v_Str || '        <value/>' || LF;
  v_Str := v_Str || '        <questions>' || LF;
  v_Str := v_Str || '            <title>Heart Attack/MI</title>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('Focused_Review_Heart',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '            <date>'  || Matrix_Utils.Get_InfoPathData('Focused_Review_Heart_Date',v_CaseId,'DT') || '</date>' || LF;
  v_Str := v_Str || '        </questions>' || LF;
  v_Str := v_Str || '        <questions>' || LF;
  v_Str := v_Str || '            <title>Chest pain on exertion</title>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('Focused_Review_Chest',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </questions>' || LF;
  v_Str := v_Str || '        <questions>' || LF;
  v_Str := v_Str || '            <title>Heart Failure</title>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('Focused_Review_Heart_Failure',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </questions>' || LF;
  v_Str := v_Str || '        <questions>' || LF;
  v_Str := v_Str || '            <title>Hypertension</title>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('Focused_Review_Hypertension',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </questions>' || LF;
  v_Str := v_Str || '        <questions>' || LF;
  v_Str := v_Str || '            <title>Hyperlipidemia</title>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('Focused_Review_Hyperlipidemia',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </questions>' || LF;
  v_Str := v_Str || '        <questions>' || LF;
  v_Str := v_Str || '            <title>Dyspnea on exertion</title>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('Focused_Review_Dyspnea',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </questions>' || LF;
  v_Str := v_Str || '        <questions>' || LF;
  v_Str := v_Str || '            <title>Dyspnea lying flat</title>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('Focused_Review_Dyspnea_Flat',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </questions>' || LF;
  v_Str := v_Str || '        <questions>' || LF;
  v_Str := v_Str || '            <title>Dyspnea at night(PND)</title>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('Focused_Review_Dyspnea_Night',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </questions>' || LF;
  v_Str := v_Str || '        <questions>' || LF;
  v_Str := v_Str || '            <title>Edema in legs</title>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('Focused_Review_Edema',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </questions>' || LF;
  v_Str := v_Str || '        <questions>' || LF;
  v_Str := v_Str || '            <title>Leg pain with walking</title>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('Focused_Review_Leg_Pain',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </questions>' || LF;
  v_Str := v_Str || '        <questions>' || LF;
  v_Str := v_Str || '            <title>Palpitations/Irregular heartbeat</title>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('Focused_Review_Palpitations',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </questions>' || LF;
  v_Str := v_Str || '        <questions>' || LF;
  v_Str := v_Str || '            <title>Heart valve problems</title>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('Focused_Review_Valve',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </questions>' || LF;
  v_Str := v_Str || '   </items>' || LF;
  v_Str := v_Str || '   <items>' || LF;
  v_Str := v_Str || '        <title>HematologyOncology</title>' || LF;
  v_Str := v_Str || '        <value/>' || LF;
  v_Str := v_Str || '        <questions>' || LF;
  v_Str := v_Str || '            <title>Anemia (low red blood cell count)</title>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('Focused_Review_Anemia',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </questions>' || LF;
  v_Str := v_Str || '        <questions>' || LF;
  v_Str := v_Str || '            <title>Easily Bruised or Bleeding</title>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('Focused_Review_Easily_Bruised',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </questions>' || LF;
  v_Str := v_Str || '        <questions>' || LF;
  v_Str := v_Str || '            <title>Swollen Lymph Nodes</title>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('Focused_Review_Swollen_Lymph',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </questions>' || LF;
  v_Str := v_Str || '        <questions>' || LF;
  v_Str := v_Str || '            <title>Leukemia</title>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('Focused_Review_Leukemia',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '           <extraData>' || LF;
  v_Str := v_Str || '              <title>Type</title>' || LF;
  v_Str := v_Str || '              <value>' || Matrix_Utils.Get_InfoPathData('Focused_Review_Leukemia_Box',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '           </extraData>' || LF;
  v_Str := v_Str || '        </questions>' || LF;
  v_Str := v_Str || '        <questions>' || LF;
  v_Str := v_Str || '           <title>Lymphoma</title>' || LF;
  v_Str := v_Str || '           <value>' || Matrix_Utils.Get_InfoPathData('Focused_Review_Lymphoma',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '           <extraData>' || LF;
  v_Str := v_Str || '              <title>Type</title>' || LF;
  v_Str := v_Str || '              <value>' || Matrix_Utils.Get_InfoPathData('Focused_Review_Lymphoma_Box',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '           </extraData>' || LF;
  v_Str := v_Str || '        </questions>' || LF;
  v_Str := v_Str || '   </items>' || LF;
  v_Str := v_Str || '   <items>' || LF;
  v_Str := v_Str || '        <title>Musculoskeletal</title>' || LF;
  v_Str := v_Str || '        <value/>' || LF;
  v_Str := v_Str || '        <questions>' || LF;
  v_Str := v_Str || '           <title>Rheumatoid Arthritis (RA)</title>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('Focused_Review_RA',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </questions>' || LF;
  v_Str := v_Str || '        <questions>' || LF;
  v_Str := v_Str || '            <title>Osteoarthritis(OA or DJD)</title>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('Focused_Review_Osteoarthritis',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </questions>' || LF;
  v_Str := v_Str || '        <questions>' || LF;
  v_Str := v_Str || '            <title>Fracture/Injury</title>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('Focused_Review_Fracture',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '            <extraData>' || LF;
  v_Str := v_Str || '                  <title>Location R/L</title>' || LF;
  v_Str := v_Str || '                  <value>' || Matrix_Utils.Get_InfoPathData('Focused_Review_Fracture',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '            </extraData>' || LF;
  v_Str := v_Str || '            <extraData>' || LF;
  v_Str := v_Str || '                  <title>Location</title>' || LF;
  v_Str := v_Str || '                  <value>' || Matrix_Utils.Get_InfoPathData('Focused_Review_Fracture_Location',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '            </extraData>' || LF;
  v_Str := v_Str || '        </questions>' || LF;
  v_Str := v_Str || '        <questions>' || LF;
  v_Str := v_Str || '            <title>Joint stiffness</title>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('Focused_Review_Joint_Stiffness',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </questions>' || LF;
  v_Str := v_Str || '        <questions>' || LF;
  v_Str := v_Str || '            <title>Joint Pain</title>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('Focused_Review_Joint_Pain',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </questions>' || LF;
  
  v_Str := v_Str || '        <questions>' || LF;
  v_Str := v_Str || '            <title>Back Pain</title>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('Focused_Review_Back_Pain',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </questions>' || LF;
  
  v_Str := v_Str || '        <questions>' || LF;
  v_Str := v_Str || '            <title>Amputation</title>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('Focused_Review_Amputation',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '            <extraData>' || LF;
  v_Str := v_Str || '                  <title>Additional Information</title>' || LF;
  v_Str := v_Str || '                  <value>' || Matrix_Utils.Get_InfoPathData('Focused_Review_Amputation_Box',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '            </extraData>' || LF;
  v_Str := v_Str || '        </questions>' || LF;
  
  
  v_Str := v_Str || '        <questions>' || LF;
  v_Str := v_Str || '            <title>Osteoporosis</title>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('Focused_Review_Osteoporsis',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </questions>' || LF;
  
  v_Str := v_Str || '        <questions>' || LF;
  v_Str := v_Str || '            <title>Gout</title>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('Focused_Review_Gout',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </questions>' || LF;
  v_Str := v_Str || '   </items>' || LF;
  v_Str := v_Str || '   <items>' || LF;
  v_Str := v_Str || '        <title>Neurology</title>' || LF;
  v_Str := v_Str || '        <value/>' || LF;
  v_Str := v_Str || '        <questions>' || LF;
  v_Str := v_Str || '            <title>Stroke or TIA</title>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('Focused_Review_Stroke',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </questions>' || LF;
  v_Str := v_Str || '        <questions>' || LF;
  v_Str := v_Str || '            <title>Dementia</title>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('Focused_Review_Dementia',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </questions>' || LF;
  v_Str := v_Str || '        <questions>' || LF;
  v_Str := v_Str || '            <title>Memory Change</title>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('Focused_Review_Memory_Change',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </questions>' || LF;
  v_Str := v_Str || '        <questions>' || LF;
  v_Str := v_Str || '            <title>Numbness or tingling in hands or feet</title>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('Focused_Review_Numb_Hands',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '            <extraData>' || LF;
  v_Str := v_Str || '                  <title>Type</title>' || LF;
  v_Str := v_Str || '                  <value>' || Matrix_Utils.Get_InfoPathData('Focused_Review_Numb_Hands_Bilateral +Focused_Review_Numb_Hands_Unilateral',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '            </extraData>' || LF;
  v_Str := v_Str || '        </questions>' || LF;
  v_Str := v_Str || '        <questions>' || LF;
  v_Str := v_Str || '            <title>Trouble Walking</title>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('Focused_Review_Neuro_Trouble_Walking',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </questions>' || LF;
  v_Str := v_Str || '        <questions>' || LF;
  v_Str := v_Str || '            <title>Paralysis</title>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('Focused_Review_Neuro_Paralysis',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </questions>' || LF;
  v_Str := v_Str || '        <questions>' || LF;
  v_Str := v_Str || '            <title>Tremors</title>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('Focused_Review_Tremors',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </questions>' || LF;
  v_Str := v_Str || '        <questions>' || LF;
  v_Str := v_Str || '            <title>Seizures</title>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('Focused_Review_Seizures',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </questions>' || LF;
  v_Str := v_Str || '        <questions>' || LF;
  v_Str := v_Str || '            <title>Parkinson''s Disease</title>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('Focused_Review_Parkinsons',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </questions>' || LF;
  v_Str := v_Str || '   </items>' || LF;
  v_Str := v_Str || '   <items>' || LF;
  v_Str := v_Str || '        <title>Endocrine</title>' || LF;
  v_Str := v_Str || '        <value/>' || LF;
  v_Str := v_Str || '        <questions>' || LF;
  v_Str := v_Str || '            <title>Thyroid Disorder</title>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('Focused_Review_Thyroid',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </questions>' || LF;
  v_Str := v_Str || '        <questions>' || LF;
  v_Str := v_Str || '            <title>Diabetes</title>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('Focused_Review_Diabetes',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </questions>' || LF;
  v_Str := v_Str || '   </items>' || LF;
  v_Str := v_Str || '   <items>' || LF;
  v_Str := v_Str || '        <title>Psychiatric</title>' || LF;
  v_Str := v_Str || '        <value/>' || LF;
  v_Str := v_Str || '        <questions>' || LF;
  v_Str := v_Str || '            <title>Bipolar disorder diagnosed</title>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('Focused_Review_Bipolar',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </questions>' || LF;
  v_Str := v_Str || '        <questions>' || LF;
  v_Str := v_Str || '            <title>Anxiety/excessive nervousness</title>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('Focused_Review_Anxiety',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </questions>' || LF;
  v_Str := v_Str || '        <questions>' || LF;
  v_Str := v_Str || '            <title>Hallucinations</title>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('Focused_Review_Hallucinations',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </questions>' || LF;
  v_Str := v_Str || '        <questions>' || LF;
  v_Str := v_Str || '            <title>Schizophrenia</title>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('Focused_Review_Schizophrenia',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </questions>' || LF;
  v_Str := v_Str || '   </items>' || LF;
  
  v_Str := v_Str || '   <groupedQuestions>'  || LF;
  v_Str := v_Str || '        <groupTitle>Unable to Complete due to:</groupTitle>' || LF;
  v_Str := v_Str || '        <groupDesc></groupDesc>' || LF;
  
  v_Str := v_Str || '        <questions>' || LF;
  v_Str := v_Str || '            <title>Not able to obtain due to:</title>' || LF;
  v_Str := v_Str || '            <value></value>' || LF;
  v_Str := v_Str || '        </questions>' || LF; 
  
  v_Str := v_Str || '        <questions>' || LF;
  v_Str := v_Str || '            <title>Unresponsive</title>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('Focused_Review_Unable_Unresponsive',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </questions>' || LF; 

  v_Str := v_Str || '        <questions>' || LF;
  v_Str := v_Str || '            <title>Uncooperative</title>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('Focused_Review_Unable_Uncooperative',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </questions>' || LF; 

  v_Str := v_Str || '        <questions>' || LF;
  v_Str := v_Str || '            <title>Severe Dementia</title>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('Focused_Review_Unable_Dementia',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </questions>' || LF; 

  v_Str := v_Str || '        <questions>' || LF;
  v_Str := v_Str || '            <title>Other reason</title>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('Focused_Review_Unable_Other',v_CaseId,'ST') || '</value>' || LF;
  --v_Str := v_Str || '            <extraData>' || LF;
  --v_Str := v_Str || '                  <title>Reason</title>' || LF;
  v_Str := v_Str || '            <optionalValue>' || Matrix_Utils.Get_InfoPathData('Focused_Review_Unable_Other_Box',v_CaseId,'ST') || '</optionalValue>' || LF;
  --v_Str := v_Str || '            </extraData>' || LF;
  v_Str := v_Str || '        </questions>' || LF;
  v_Str := v_Str || '    </groupedQuestions>' || LF;
  
  
  
  v_Str := v_Str || '   <bladderControl>' || LF;
  v_Str := v_Str || '        <items>' || LF;
  v_Str := v_Str || '            <title>In the past 6 months have you accidentally leaked urine?</title>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('Bladder_Leaked',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </items>' || LF;
  v_Str := v_Str || '        <items>' || LF;
  v_Str := v_Str || '            <title>Is the urinary leakage a problem for you?</title>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('Bladder_Leaked_Problem',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </items>' || LF;
  v_Str := v_Str || '        <items>' || LF;
  v_Str := v_Str || '            <title>Educated the patient about the causes of urinary incontinence</title>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('Bladder_Incontinence_Educated',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '        </items>' || LF;
  v_Str := v_Str || '        <items>' || LF;
  v_Str := v_Str || '            <title>Discussed the roles of training, exercises, and medication</title>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('Bladder_Training',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '        </items>' || LF;
  
  v_Str := v_Str || '        <items>' || LF;
  v_Str := v_Str || '            <title>Provided education about non-pharmaceutical mechanisms</title>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('Bladder_Pharma',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '        </items>' || LF;
  
  v_Str := v_Str || '        <items>' || LF;
  v_Str := v_Str || '            <title>Advised to follow up with PCP for ongoing care</title>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('Bladder_PCP_Advised',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '        </items>' || LF;
  v_Str := v_Str || '   </bladderControl>' || LF;
  
  
  v_Str := v_Str || ' </FocusedSystemsReview>' || LF;
  ------------------------------------
  RETURN v_Str;
EXCEPTION
WHEN OTHERS THEN
  v_Str := SUBSTR(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || CHR(13) || SQLERRM,1,4000);
  RAISE;
END MATRIX_XML_FOCUSREVIEW;

FUNCTION MATRIX_XML_FUNCSTATUS(
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
  v_Str := v_Str || '  <FunctionalStatus>' || LF;
  v_Str := v_Str || '   <adlAssist>' || LF;
  v_Str := v_Str || '        <sectionTitle>ADL Assist</sectionTitle>' || LF;
  v_Str := v_Str || '        <sectionDesc>' || Matrix_Utils.Get_InfoPathData('none',v_CaseId,'ST') || '</sectionDesc>' || LF;
  v_Str := v_Str || '        <groupedQuestions>' || LF;
  v_Str := v_Str || '            <groupTitle>Ambulation</groupTitle>' || LF;
  v_Str := v_Str || '            <questions>' || LF;
  v_Str := v_Str || '                  <title>Cane</title>' || LF;
  v_Str := v_Str || '                  <value>' || Matrix_Utils.Get_InfoPathData('ADL_Ambulation_Cane',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '            </questions>' || LF;
  v_Str := v_Str || '            <questions>' || LF;
  v_Str := v_Str || '                  <title>Walker</title>' || LF;
  v_Str := v_Str || '                  <value>' || Matrix_Utils.Get_InfoPathData('ADL_Ambulation_Walker',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '            </questions>' || LF;
  v_Str := v_Str || '            <questions>' || LF;
  v_Str := v_Str || '                  <title>Wheel Chair</title>' || LF;
  v_Str := v_Str || '                  <value>' || Matrix_Utils.Get_InfoPathData('ADL_Ambulation_WC',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '            </questions>' || LF;
  v_Str := v_Str || '            <questions>' || LF;
  v_Str := v_Str || '                  <title>Geri-Chair</title>' || LF;
  v_Str := v_Str || '                  <value>' || Matrix_Utils.Get_InfoPathData('ADL_Ambulation_Geri_Chair',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '            </questions>' || LF;
  v_Str := v_Str || '            <questions>' || LF;
  v_Str := v_Str || '                  <title>Bed bound</title>' || LF;
  v_Str := v_Str || '                  <value>' || Matrix_Utils.Get_InfoPathData('ADL_Ambulation_Bed',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '            </questions>' || LF;
  v_Str := v_Str || '        </groupedQuestions>' || LF;
  v_Str := v_Str || '        <groupedQuestions>' || LF;
  v_Str := v_Str || '            <groupTitle>Toileting</groupTitle>' || LF;
  v_Str := v_Str || '            <questions>' || LF;
  v_Str := v_Str || '                  <title>Colostomy</title>' || LF;
  v_Str := v_Str || '                  <value>' || Matrix_Utils.Get_InfoPathData('ADL_Toilet_Colostomy',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '            </questions>' || LF;
  v_Str := v_Str || '            <questions>' || LF;
  v_Str := v_Str || '                  <title>Ileostomy</title>' || LF;
  v_Str := v_Str || '                  <value>' || Matrix_Utils.Get_InfoPathData('ADL_Toilet_Ileostomy',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '            </questions>' || LF;
  v_Str := v_Str || '            <questions>' || LF;
  v_Str := v_Str || '                  <title>Foley Cath.</title>' || LF;
  v_Str := v_Str || '                  <value>' || Matrix_Utils.Get_InfoPathData('ADL_Toilet_Foley',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '            </questions>' || LF;
  v_Str := v_Str || '            <questions>' || LF;
  v_Str := v_Str || '                  <title>Suprapubic Cath</title>' || LF;
  v_Str := v_Str || '                  <value>' || Matrix_Utils.Get_InfoPathData('ADL_Toilet_Suprapublic',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '            </questions>' || LF;
  v_Str := v_Str || '            <questions>' || LF;
  v_Str := v_Str || '                  <title>Protective Undergarments</title>' || LF;
  v_Str := v_Str || '                  <value>' || Matrix_Utils.Get_InfoPathData('ADL_Toilet_Briefs',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '            </questions>' || LF;
  v_Str := v_Str || '        </groupedQuestions>' || LF;
  v_Str := v_Str || '        <groupedQuestions>' || LF;
  v_Str := v_Str || '            <groupTitle>Feeding</groupTitle>' || LF;
  v_Str := v_Str || '            <questions>' || LF;
  v_Str := v_Str || '                  <title>Fed</title>' || LF;
  v_Str := v_Str || '                  <value>' || Matrix_Utils.Get_InfoPathData('ADL_Feeding_Fed',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '            </questions>' || LF;
  v_Str := v_Str || '            <questions>' || LF;
  v_Str := v_Str || '                  <title>Peg</title>' || LF;
  v_Str := v_Str || '                  <value>' || Matrix_Utils.Get_InfoPathData('ADL_Feeding_Peg',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '            </questions>' || LF;
  v_Str := v_Str || '            <questions>' || LF;
  v_Str := v_Str || '                  <title>Ng</title>' || LF;
  v_Str := v_Str || '                  <value>' || Matrix_Utils.Get_InfoPathData('ADL_Feeding_Ng',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '            </questions>' || LF;
  v_Str := v_Str || '            <questions>' || LF;
  v_Str := v_Str || '                  <title>TPN</title>' || LF;
  v_Str := v_Str || '                  <value>' || Matrix_Utils.Get_InfoPathData('ADL_Feeding_TPN',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '            </questions>' || LF;
  v_Str := v_Str || '        </groupedQuestions>' || LF;
  v_Str := v_Str || '        <groupedQuestions>' || LF;
  v_Str := v_Str || '            <groupTitle>Transfers</groupTitle>' || LF;
  v_Str := v_Str || '            <questions>' || LF;
  v_Str := v_Str || '                  <title>Transfer Board</title>' || LF;
  v_Str := v_Str || '                  <value>' || Matrix_Utils.Get_InfoPathData('ADL_Transfer_Board',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '            </questions>' || LF;
  v_Str := v_Str || '            <questions>' || LF;
  v_Str := v_Str || '                  <title>Lift</title>' || LF;
  v_Str := v_Str || '                  <value>' || Matrix_Utils.Get_InfoPathData('ADL_Transfer_Lift',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '            </questions>' || LF;
  v_Str := v_Str || '            <questions>' || LF;
  v_Str := v_Str || '                  <title>Assist 1 person/2 person</title>' || LF;
  v_Str := v_Str || '                  <value>' || Matrix_Utils.Get_InfoPathData('ADL_Transfer_Assist',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '            </questions>' || LF;
  v_Str := v_Str || '        </groupedQuestions>' || LF;
  v_Str := v_Str || '   </adlAssist>' || LF;
  v_Str := v_Str || '        <status>' || LF;
  v_Str := v_Str || '         <title>Functional Status - Modified Katz Basic Activities of Daily Living</title>' || LF;
  v_Str := v_Str || '         <value>' || Matrix_Utils.Get_InfoPathData('none',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '            <questions>' || LF;
  v_Str := v_Str || '                  <title>Bathing (Sponge bath, tub bath, or shower) Independent?</title>' || LF;
  v_Str := v_Str || '                  <value>' || Matrix_Utils.Get_InfoPathData('Functional_Status_Bathing',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '            </questions>' || LF;
  v_Str := v_Str || '            <questions> '|| LF;
  v_Str := v_Str || '                  <title>Dressing</title>' || LF;
  v_Str := v_Str || '                  <value>' || Matrix_Utils.Get_InfoPathData('Functional_Status_Dressing',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '            </questions>' || LF;
  v_Str := v_Str || '            <questions>'|| LF;
  v_Str := v_Str || '                  <title>Toileting</title>' || LF;
  v_Str := v_Str || '                  <value>' || Matrix_Utils.Get_InfoPathData('Functional_Status_Toileting',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '            </questions>' || LF;
  v_Str := v_Str || '            <questions>' || LF;
  v_Str := v_Str || '                  <title>Transferring</title>' || LF;
  v_Str := v_Str || '                  <value>' || Matrix_Utils.Get_InfoPathData('Functional_Status_Transferring',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '            </questions>' || LF;
  v_Str := v_Str || '            <questions>' || LF;
  v_Str := v_Str || '                  <title>Continence</title>' || LF;
  v_Str := v_Str || '                  <value>' || Matrix_Utils.Get_InfoPathData('Functional_Status_Continence',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '            </questions>' || LF;
  v_Str := v_Str || '            <questions>' || LF;
  v_Str := v_Str || '                  <title>Feeding</title>' || LF;
  v_Str := v_Str || '                  <value>' || Matrix_Utils.Get_InfoPathData('Functional_Status_Feeding',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '            </questions>' || LF;
  v_Str := v_Str || '            <questions>' || LF;
  v_Str := v_Str || '                  <title>Repositioning in Chair or Bed Independent</title>' || LF;
  v_Str := v_Str || '                  <value>' || Matrix_Utils.Get_InfoPathData('Functional_Status_Repositioning',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '            </questions> '|| LF;
  v_Str := v_Str || '        </status>' || LF;
  v_Str := v_Str || '  </FunctionalStatus>' || LF;
  ------------------------------------
  RETURN v_Str;
EXCEPTION
WHEN OTHERS THEN
  v_Str := SUBSTR(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || CHR(13) || SQLERRM,1,4000);
  RAISE;
END MATRIX_XML_FUNCSTATUS;

FUNCTION MATRIX_XML_HEALTHBEHV(
    P_CASEID NUMBER ,
    P_LF     VARCHAR2 )
  -- Created 10-6-2012 R Benzell
  -- called by GEN_MATRIX_XML
  -- edited and completed 10-8-12 Denis
  RETURN CLOB
IS
  v_Str CLOB;
  v_CaseId NUMBER;
  LF       VARCHAR2(5);
BEGIN
  v_CaseId := P_CaseId;
  LF       := P_LF;
  -----------------------------------
  v_Str := v_Str || '   <HealthBehaviors>' || LF;
  
  v_Str := v_Str || '   <physicalHealth>' || LF;
  v_Str := v_Str || '        <groupTitle>Compared to two years ago, my physical health is the:</groupTitle>' || LF;
  v_Str := v_Str || '        <value>' || Matrix_Utils.Get_InfoPathData('Health_Behaviors_Physical_Better+Health_Behaviors_Physical_Same +Health_Behaviors_Physical_Worse',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '   </physicalHealth>' || LF;
  
  v_Str := v_Str || '   <mentalHealth>' || LF;
  v_Str := v_Str || '        <groupTitle>Compared to two years ago, my mental health is the:</groupTitle>' || LF;
  v_Str := v_Str || '        <value>' || Matrix_Utils.Get_InfoPathData('Health_Behaviors_Mental_Better + Health_Behaviors_Mental_Same + Health_Behaviors_Mental_Worse',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '   </mentalHealth>' || LF;
  
  v_Str := v_Str || '   <exercise>' || LF;
  v_Str := v_Str || '        <educated>' || LF;
  v_Str := v_Str || '            <title>Educated patient about the importance of exercise.</title>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('Health_Behaviors_Educate',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '        </educated>' || LF;
  v_Str := v_Str || '        <activityGoals>' || LF;
  v_Str := v_Str || '            <title>Set activity goals with the patient</title>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('Health_Behaviors_Goals',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '        </activityGoals>' || LF;
  v_Str := v_Str || '        <exerciseQuestion>' || LF;
  v_Str := v_Str || '            <title>On average, how often do you exercise?</title>' || LF;
  v_Str := v_Str || '                  <items>' || LF;
  v_Str := v_Str || '                    <label>days/week</label>' || LF;
  v_Str := v_Str || '                    <quantity>' || Matrix_Utils.Get_InfoPathData('Health_Behaviors_Exercise_Days',v_CaseId,'INT-999') || '</quantity>' || LF;
  v_Str := v_Str || '                  </items>' || LF;
  v_Str := v_Str || '                  <items>' || LF;
  v_Str := v_Str || '                    <label>minutes at a time.</label>' || LF;
  v_Str := v_Str || '                    <quantity>' || Matrix_Utils.Get_InfoPathData('Health_Behaviorsl_Exercise_Minutes',v_CaseId,'INT-999') || '</quantity>' || LF;
  v_Str := v_Str || '                  </items>' || LF;
  v_Str := v_Str || '        </exerciseQuestion>' || LF;
  v_Str := v_Str || '   </exercise>' || LF;
  
  v_Str := v_Str || '   <drugUse>' || LF;
  v_Str := v_Str || '        <currentUse>' || LF;
  v_Str := v_Str || '            <title>Do you currently use any street drugs or take prescription medications that were not prescribed for you or take prescription medications in larger amounts than were prescribed?</title>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('Health_Behaviors_Drugs_Current',v_CaseId,'YN') || '</value>' || LF;
  v_Str := v_Str || '        </currentUse>' || LF;
  v_Str := v_Str || '        <whatDrugs>' || LF;
  v_Str := v_Str || '            <title>What drugs/meds?</title>' || LF;
  --v_Str := v_Str || '            <answer>' || Matrix_Utils.Get_InfoPathData('Health_Behaviors_Drugs_Current_Box',v_CaseId,'ST') || '</answer>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('Health_Behaviors_Drugs_Current_Box',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </whatDrugs>' || LF;
  v_Str := v_Str || '        <educated>' || LF;
  v_Str := v_Str || '           <title>Educated the patient about risks of substance abuse.</title>' || LF;
  v_Str := v_Str || '           <value>' || Matrix_Utils.Get_InfoPathData('Health_Behaviors_Drugs_Current_Educate',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '        </educated>' || LF;
  v_Str := v_Str || '        <refer>' || LF;
  v_Str := v_Str || '            <title>Refer for ongoing monitoring and care.</title>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('Health_Behaviors_Drugs_Current_Refer',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '        </refer>' || LF;
  v_Str := v_Str || '   </drugUse>' || LF;
  
  v_Str := v_Str || '   <tobaccoUse>' || LF;
  v_Str := v_Str || '        <pastUse>' || LF;
  v_Str := v_Str || '            <title>Have you ever smoked or chewed tobacco?</title>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('Health_Behaviors_Ever_Smoked',v_CaseId,'YN') || '</value>' || LF;
  v_Str := v_Str || '               <quantityGroup>' || LF;
  v_Str := v_Str || '                  <title>What year did you quit?</title>' || LF;
  v_Str := v_Str || '                  <value>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'INT-999') || '</value>' || LF;
  v_Str := v_Str || '                       <items>' || LF;
  v_Str := v_Str || '                         <label>(#packs/day)</label>' || LF;
  v_Str := v_Str || '                         <quantity>' || Matrix_Utils.Get_InfoPathData('Health_Behaviors_Smoke_Packs',v_CaseId,'INT-999') || '</quantity>' || LF;
  v_Str := v_Str || '                       </items>' || LF;
  v_Str := v_Str || '                       <items>' || LF;
  v_Str := v_Str || '                         <label>(# years)</label>' || LF;
  v_Str := v_Str || '                         <quantity>' || Matrix_Utils.Get_InfoPathData('Health_Behaviors_Smoke_Years',v_CaseId,'INT-999') || '</quantity>' || LF;
  v_Str := v_Str || '                       </items>' || LF;
  v_Str := v_Str || '               </quantityGroup>' || LF;
  v_Str := v_Str || '        </pastUse>' || LF;
  --v_Str := v_Str || '        <currentUse>' || LF;
  --v_Str := v_Str || '            <title>Do you currently smoke or chew tobacco</title>' || LF;
  --v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('Health_Behaviors_Smoke',v_CaseId,'YN') || '</value>' || LF;
  --v_Str := v_Str || '        </currentUse>' || LF;

  v_Str := v_Str || '        <educated>' || LF;
  v_Str := v_Str || '            <title>Advised patient to stop smoking and avoid tobacco</title>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('Health_Behaviors_Smoke_Advised',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '        </educated>' || LF;
  v_Str := v_Str || '        <discussedMedications>' || Matrix_Utils.Get_InfoPathData('Health_Behaviors_Smoke_Cessation',v_CaseId,'TF') || '</discussedMedications>' || LF;
  v_Str := v_Str || '        <discussedStrategies>' || Matrix_Utils.Get_InfoPathData('Health_Behaviors_Smoke_Cessation_Strategies',v_CaseId,'TF') || '</discussedStrategies>' || LF;
  v_Str := v_Str || '   </tobaccoUse>' || LF;
  
  v_Str := v_Str || '   <alcoholUse>' || LF;
  v_Str := v_Str || '        <currentUse>' || LF;
  v_Str := v_Str || '            <title>Do you sometimes drink beer, wine or other alcoholic beverages?</title>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('Health_Behaviors_Alcohol',v_CaseId,'YN') || '</value>' || LF;
  v_Str := v_Str || '        </currentUse>' || LF;
  v_Str := v_Str || '        <quantityDay>' || Matrix_Utils.Get_InfoPathData('Health_Behaviors_Alcohol_Drinks',v_CaseId,'INT-999') || '</quantityDay>' || LF;
  v_Str := v_Str || '        <quantityWeek>' || LF;
  v_Str := v_Str || '            <label>How many drinks of alcohol do you have per week?</label>' || LF;
  v_Str := v_Str || '            <quantity>' || Matrix_Utils.Get_InfoPathData('Health_Behaviors_Alcohol_Drinks_4',v_CaseId,'INT-999') || '</quantity>' || LF;
  v_Str := v_Str || '        </quantityWeek>' || LF;
  v_Str := v_Str || '        <educated>' || LF;
  v_Str := v_Str || '            <title>Educated patient about risks of alcohol abuse.</title>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('Health_Behaviors_Alcohol_Educate',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '        </educated>' || LF;
  v_Str := v_Str || '        <refer>' || LF;
  v_Str := v_Str || '            <title>Refer for ongoing monitoring and care</title>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('Health_Behaviors_Alcohol_Refer',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '        </refer>' || LF;
  v_Str := v_Str || '   </alcoholUse>' || LF;
  v_Str := v_Str || '   <stdRisk>' || LF;
  v_Str := v_Str || '        <title>Are you at risk for HIV/AIDs or other sexually transmitted diseases?</title>' || LF;
  v_Str := v_Str || '        <value>' || Matrix_Utils.Get_InfoPathData('Health_Behaviors_STD',v_CaseId,'YN') || '</value>' || LF;
  v_Str := v_Str || '   </stdRisk>' || LF;
  v_Str := v_Str || '   <stdTested>' || LF;
  v_Str := v_Str || '        <title>Have you been tested</title>' || LF;
  v_Str := v_Str || '        <value>' || Matrix_Utils.Get_InfoPathData('Health_Behaviors_STD_Tested',v_CaseId,'YN') || '</value>' || LF;
  v_Str := v_Str || '   </stdTested>' || LF;
  v_Str := v_Str || '   </HealthBehaviors>' || LF;
  ------------------------------------
  RETURN v_Str;
EXCEPTION
WHEN OTHERS THEN
  v_Str := SUBSTR(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || CHR(13) || SQLERRM,1,3900);
  dbms_output.put_line('ERROR='||v_str);
  RAISE;
END MATRIX_XML_HEALTHBEHV;



FUNCTION MATRIX_XML_HEALTHMAINT(
    P_CASEID NUMBER ,
    P_LF     VARCHAR2 )
  -- Created 10-6-2012 R Benzell
  -- called by GEN_MATRIX_XML
  -- Edited and completed 10-8-12 Denis
  RETURN CLOB
IS
  v_Str CLOB;
  v_CaseId NUMBER;
  LF       VARCHAR2(5);
BEGIN
  v_CaseId := P_CaseId;
  LF       := P_LF;
  -----------------------------------
  v_Str := v_Str || '<HealthMaintenance>' || LF;
  v_Str := v_Str || '   <lastPhysicalExam>' || LF;
  v_Str := v_Str || '        <label>Date of Last Physical Exam</label>' || LF;
  v_Str := v_Str || '        <date>' || Matrix_Utils.Get_InfoPathData('Health_Maintenance_Date',v_CaseId,'DT') || '</date>' || LF;
  v_Str := v_Str || '   </lastPhysicalExam>' || LF;
  v_Str := v_Str || '   <seeDoctorRegularly>' || LF;
  v_Str := v_Str || '    <title>Do you see a doctor regularly?</title>' || LF;
  v_Str := v_Str || '    <value>' || Matrix_Utils.Get_InfoPathData('Health_Maintenance_Dr_Regularly',v_CaseId,'YN') || '</value>' || LF;
  v_Str := v_Str || '        <secondaryQuestions>' || LF;
  v_Str := v_Str || '            <title>PCP</title>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('Health_Maintenance_PCP',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </secondaryQuestions>' || LF;
  v_Str := v_Str || '        <secondaryQuestions>' || LF;
  v_Str := v_Str || '            <title>Specialist</title>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('Health_Maintenance_Specialist',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </secondaryQuestions>' || LF;
  v_Str := v_Str || '   </seeDoctorRegularly>' || LF;
  v_Str := v_Str || '   <screenList>' || LF;
  v_Str := v_Str || '        <desc></desc>' || LF;  --xxx added for new Schema, no mapping info yet know
  v_Str := v_Str || '        <title>Health maintenance</title>' || LF;
  v_Str := v_Str || '        <items>' || LF;
  v_Str := v_Str || '            <title>LDL-C</title>' || LF;
  v_Str := v_Str || '            <comments>' || Matrix_Utils.Get_InfoPathData('Health_Maintenance_LDL_Box',v_CaseId,'ST') || '</comments>' || LF;
  v_Str := v_Str || '            <commentsTitle>result, if known</commentsTitle>' || LF;
  v_Str := v_Str || '            <status>' || Matrix_Utils.Get_InfoPathData('Health_Maintenance_LDL',v_CaseId,'ST') || '</status>' || LF;
  v_Str := v_Str || '            <date>' || Matrix_Utils.Get_InfoPathData('Health_Maintenance_LDL_Date',v_CaseId,'DT') || '</date>' || LF;
  v_Str := v_Str || '        </items>' || LF;
  v_Str := v_Str || '        <items>' || LF;
  v_Str := v_Str || '            <title>Flu vaccine</title>' || LF;
  v_Str := v_Str || '            <comments/>' || LF;
  v_Str := v_Str || '            <commentsTitle></commentsTitle>' || LF;
  v_Str := v_Str || '            <status>' || Matrix_Utils.Get_InfoPathData('Health_Maintenance_Flu',v_CaseId,'ST') || '</status>' || LF;
  v_Str := v_Str || '            <date>' || Matrix_Utils.Get_InfoPathData('Health_Maintenance_Flu_Date',v_CaseId,'DT') || '</date>' || LF;
  v_Str := v_Str || '        </items>' || LF;
  v_Str := v_Str || '        <items>' || LF;
  v_Str := v_Str || '            <title>Pneumonia Vaccine (no date needed)</title>' || LF;
  v_Str := v_Str || '            <comments/>' || LF;
  v_Str := v_Str || '            <commentsTitle/>' || LF;
  v_Str := v_Str || '            <status>' || Matrix_Utils.Get_InfoPathData('Health_Maintenance_Pneumonia',v_CaseId,'ST') || '</status>' || LF;
  v_Str := v_Str || '            <date/>' || LF;
  --v_Str := v_Str || '            <notesList>' ||  Matrix_Utils.Get_InfoPathData('Health_Maintenance_Pneumonia',v_CaseId,'ST') || '</notesList>'  || LF;
  v_Str := v_Str || '            <notesList>' || LF; --- xxx awaiting client mapping info for <noteList>
  v_Str := v_Str || '               <title></title>' || LF;
  v_Str := v_Str || '               <value></value>' || LF;
  v_Str := v_Str || '            </notesList>' || LF;
  v_Str := v_Str || '        </items>' || LF;
  v_Str := v_Str || '        <items>' || LF;
  v_Str := v_Str || '            <title>Spirometry (for COPD dx, age>40)</title>' || LF;
  v_Str := v_Str || '            <comments>' || Matrix_Utils.Get_InfoPathData('Health_Maintenance_Spirometry_Box',v_CaseId,'ST') || '</comments>' || LF;
  v_Str := v_Str || '            <commentsTitle>Dr.</commentsTitle>' || LF;
  v_Str := v_Str || '            <status>' || Matrix_Utils.Get_InfoPathData('Health_Maintenance_Spirometry',v_CaseId,'ST') || '</status>' || LF;
  v_Str := v_Str || '            <date>' || Matrix_Utils.Get_InfoPathData('Health_Maintenance_Spirometry_Date',v_CaseId,'DT') || '</date>' || LF;
  --v_Str := v_Str || '            <notesList>' ||  Matrix_Utils.Get_InfoPathData('Health_Maintenance_Spirometry_date',v_CaseId,'DT') || '</notesList>'  || LF;
  v_Str := v_Str || '            <notesList>' || LF; --- xxx awaiting client mapping info for <noteList>
  v_Str := v_Str || '               <title></title>' || LF;
  v_Str := v_Str || '               <value></value>' || LF;
  v_Str := v_Str || '            </notesList>' || LF;

  v_Str := v_Str || '        </items>' || LF;
  v_Str := v_Str || '        <items>' || LF;
  v_Str := v_Str || '            <title>Eye exam for glaucoma by specialist (age>=65)</title>' || LF;
  v_Str := v_Str || '            <comments>' || Matrix_Utils.Get_InfoPathData('Health_Maintenance_Eye_Box',v_CaseId,'ST') || '</comments>' || LF;
  v_Str := v_Str || '            <commentsTitle>Dr.</commentsTitle>' || LF;
  v_Str := v_Str || '            <status>' || Matrix_Utils.Get_InfoPathData('Health_Maintenance_Eye',v_CaseId,'ST') || '</status>' || LF;
  v_Str := v_Str || '            <date>' || Matrix_Utils.Get_InfoPathData('Health_Maintenance_Eye_Date',v_CaseId,'DT') || '</date>' || LF;
  --v_Str := v_Str || '            <notesList>' ||  Matrix_Utils.Get_InfoPathData('Health_Maintenance_Eye_date',v_CaseId,'DT') || '</notesList>'  || LF;
  v_Str := v_Str || '            <notesList>' || LF; --- xxx awaiting client mapping info for <noteList>
  v_Str := v_Str || '               <title></title>' || LF;
  v_Str := v_Str || '               <value></value>' || LF;
  v_Str := v_Str || '            </notesList>' || LF;

  v_Str := v_Str || '        </items>' || LF;
  v_Str := v_Str || '        <items>' || LF;
  v_Str := v_Str || '            <title>Eye exam by specialist</title>' || LF;
  v_Str := v_Str || '            <comments>' || Matrix_Utils.Get_InfoPathData('Health_Maintenance_Eye_Specialist_Box',v_CaseId,'ST') || '</comments>' || LF;
  v_Str := v_Str || '            <commentsTitle>Dr.</commentsTitle>' || LF;
  v_Str := v_Str || '            <status>' || Matrix_Utils.Get_InfoPathData('Health_Maintenance_Eye_Specialist',v_CaseId,'ST') || '</status>' || LF;
  v_Str := v_Str || '            <date>' || Matrix_Utils.Get_InfoPathData('Health_Maintenance_Eye_Specialist_Date',v_CaseId,'DT') || '</date>' || LF;
  v_Str := v_Str || '            <notesList>' || LF; --- xxx awaiting client mapping info for <noteList>
  v_Str := v_Str || '               <title></title>' || LF;
  v_Str := v_Str || '               <value></value>' || LF;
  v_Str := v_Str || '            </notesList>' || LF;

  v_Str := v_Str || '        </items>' || LF;
  v_Str := v_Str || '   </screenList>' || LF;
  v_Str := v_Str || '   <screenList>' || LF;
  v_Str := v_Str || '        <desc></desc>' || LF;  --xxx added for new Schema, no mapping info yet know
  v_Str := v_Str || '        <title>WOMEN</title>' || LF;
  v_Str := v_Str || '        <items>' || LF;
  v_Str := v_Str || '            <title>Mammogram (age 40-49)</title>' || LF;
  v_Str := v_Str || '            <comments>' || Matrix_Utils.Get_InfoPathData('Health_Maintenance_Mammogram_Box',v_CaseId,'ST') || '</comments>' || LF;
  v_Str := v_Str || '            <commentsTitle>Dr.</commentsTitle>' || LF;
  v_Str := v_Str || '            <status>' || Matrix_Utils.Get_InfoPathData('Health_Maintenance_Mammogram',v_CaseId,'YN') || '</status>' || LF;
  v_Str := v_Str || '            <date>' || Matrix_Utils.Get_InfoPathData('Health_Maintenance_Mammogram_Date',v_CaseId,'DT') || '</date>' || LF;
  v_Str := v_Str || '            <notesList>' || LF; --- xxx awaiting client mapping info for <noteList>
  v_Str := v_Str || '               <title></title>' || LF;
  v_Str := v_Str || '               <value></value>' || LF;
  v_Str := v_Str || '            </notesList>' || LF;

  v_Str := v_Str || '        </items>' || LF;
  v_Str := v_Str || '        <items>' || LF;
  v_Str := v_Str || '            <title>History of Mastectomy</title>' || LF;
  v_Str := v_Str || '            <comments/>' || LF;
  v_Str := v_Str || '            <commentsTitle/>' || LF;
  v_Str := v_Str || '            <status>' || Matrix_Utils.Get_InfoPathData('Health_Maintenance_Mastectomy',v_CaseId,'YN') || '</status>' || LF;
  v_Str := v_Str || '            <date>' || Matrix_Utils.Get_InfoPathData('Health_Maintenance_Mastectomy_Date',v_CaseId,'DT') || '</date>' || LF;
  v_Str := v_Str || '            <notesList>' || LF;
  v_Str := v_Str || '                  <title>R</title>' || LF;
  v_Str := v_Str || '                  <value>' || Matrix_Utils.Get_InfoPathData('Health_Maintenance_Mastectomy_R',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '            </notesList>' || LF;
  v_Str := v_Str || '            <notesList>' || LF;
  v_Str := v_Str || '                  <title>L</title>' || LF;
  v_Str := v_Str || '                  <value>' || Matrix_Utils.Get_InfoPathData('Health_Maintenance_Mastectomy_L',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '            </notesList>' || LF;
  v_Str := v_Str || '            <notesList>' || LF;
  v_Str := v_Str || '                  <title>Bilateral</title>' || LF;
  v_Str := v_Str || '                  <value>' || Matrix_Utils.Get_InfoPathData('Health_Maintenance_Mastectomy_Bi',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '            </notesList>' || LF;
  v_Str := v_Str || '        </items>' || LF;
  v_Str := v_Str || '        <items>' || LF;
  v_Str := v_Str || '            <title>Bone density test</title>' || LF;
  v_Str := v_Str || '            <comments>' || Matrix_Utils.Get_InfoPathData('Health_Maintenance_Bone_Box',v_CaseId,'ST') || '</comments>' || LF;
  v_Str := v_Str || '            <commentsTitle>Dr.</commentsTitle>' || LF;
  v_Str := v_Str || '            <status>' || Matrix_Utils.Get_InfoPathData('Health_Maintenance_Bone',v_CaseId,'ST') || '</status>' || LF;
  v_Str := v_Str || '            <date>' || Matrix_Utils.Get_InfoPathData('Health_Maintenance_Bone_Date',v_CaseId,'DT') || '</date>' || LF;
  v_Str := v_Str || '        </items>' || LF;
  v_Str := v_Str || '   </screenList>' || LF;
  
  v_Str := v_Str || '   <screenList>' || LF;
  v_Str := v_Str || '        <desc>Check all drug monitoring that applies</desc>' || LF;
  v_Str := v_Str || '        <title>Drug Monitoring</title>' || LF;
  v_Str := v_Str || '        <items>' || LF;
  v_Str := v_Str || '            <title>ACEI/ARB/digoxin/diuretics(K, BUN/creatinine</title>' || LF;
  v_Str := v_Str || '            <comments/>' || LF;
  v_Str := v_Str || '            <commentsTitle/>' || LF;
  v_Str := v_Str || '            <status>' || Matrix_Utils.Get_InfoPathData('Health_Maintenance_ACEI',v_CaseId,'ST') || '</status>' || LF;
  v_Str := v_Str || '            <date>' || Matrix_Utils.Get_InfoPathData('Health_Maintenance_ACEI_Date',v_CaseId,'DT') || '</date>' || LF;
  v_Str := v_Str || '        </items>' || LF;
  
  v_Str := v_Str || '        <items>' || LF;
  v_Str := v_Str || '            <title>anticonvulsants(levels)</title>' || LF;
  v_Str := v_Str || '            <comments/>' || LF;
  v_Str := v_Str || '            <commentsTitle/>' || LF;
  v_Str := v_Str || '            <status>' || Matrix_Utils.Get_InfoPathData('Health_Maintenance_Anticonvultsants',v_CaseId,'ST') || '</status>' || LF;
  v_Str := v_Str || '            <date>' || Matrix_Utils.Get_InfoPathData('Health_Maintenance_Anticonvultsants_Date',v_CaseId,'DT') || '</date>' || LF;
  v_Str := v_Str || '        </items>' || LF;
  
  v_Str := v_Str || '        <items>' || LF;
  v_Str := v_Str || '            <title>statins</title>' || LF;
  v_Str := v_Str || '            <comments/>' || LF;
  v_Str := v_Str || '            <commentsTitle/>' || LF;
  v_Str := v_Str || '            <status>' || Matrix_Utils.Get_InfoPathData('Health_Maintenance_Statins',v_CaseId,'ST') || '</status>' || LF;
  v_Str := v_Str || '            <date>' || Matrix_Utils.Get_InfoPathData('Health_Maintenance_Statins_date',v_CaseId,'DT') || '</date>' || LF;
  v_Str := v_Str || '            <notesList>' || LF;
  v_Str := v_Str || '                  <title>Lipid Levels</title>' || LF;
  v_Str := v_Str || '                  <value>' || Matrix_Utils.Get_InfoPathData('Health_Maintenance_Statins_Lipid',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '            </notesList>' || LF;
  v_Str := v_Str || '            <notesList>' || LF;
  v_Str := v_Str || '                  <title>LFTs</title>' || LF;
  v_Str := v_Str || '                  <value>' || Matrix_Utils.Get_InfoPathData('Health_Maintenance_Statins_LFT',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '            </notesList>' || LF;
  v_Str := v_Str || '        </items>' || LF;
  
  v_Str := v_Str || '        <items>' || LF;
  v_Str := v_Str || '            <title>anticoagulants (PT/INR)</title>' || LF;
  v_Str := v_Str || '            <comments/>' || LF;
  v_Str := v_Str || '            <commentsTitle/>' || LF;
  v_Str := v_Str || '            <status>' || Matrix_Utils.Get_InfoPathData('Health_Maintenance_Anticoag',v_CaseId,'ST') || '</status>' || LF;
  v_Str := v_Str || '            <date>' || Matrix_Utils.Get_InfoPathData('Health_Maintenance_Anticoag_date',v_CaseId,'DT') || '</date>' || LF;
  v_Str := v_Str || '            <notesList>' || LF;
  v_Str := v_Str || '                  <title>PT</title>' || LF;
  v_Str := v_Str || '                  <value>' || Matrix_Utils.Get_InfoPathData('Health_Maintenance_Anticoag_PT',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '            </notesList>' || LF;
  v_Str := v_Str || '            <notesList>' || LF;
  v_Str := v_Str || '                  <title>INR</title>' || LF;
  v_Str := v_Str || '                  <value>' || Matrix_Utils.Get_InfoPathData('Health_Maintenance_Anticoag_INR',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '            </notesList>' || LF;
  v_Str := v_Str || '        </items>' || LF;
  v_Str := v_Str || '   </screenList>' || LF;
  
  v_Str := v_Str || '   <screenList>' || LF;
  v_Str := v_Str || '        <desc>(age 50-75)</desc>' || LF;  --xxx added for new Schema, no mapping info yet know
  v_Str := v_Str || '        <title>Colon CA Screen</title>' || LF;
  v_Str := v_Str || '        <items>' || LF;
  v_Str := v_Str || '            <title>Colonoscopy</title>' || LF;
  v_Str := v_Str || '            <comments>' || Matrix_Utils.Get_InfoPathData('Health_Maintenance_Colon_Colonoscopy_Box',v_CaseId,'ST') || '</comments>' || LF;
  v_Str := v_Str || '            <commentsTitle>Dr.</commentsTitle>' || LF;
  v_Str := v_Str || '            <status>' || Matrix_Utils.Get_InfoPathData('Health_Maintenance_Colon_Colonoscopy',v_CaseId,'ST') || '</status>' || LF;
  v_Str := v_Str || '            <date>' || Matrix_Utils.Get_InfoPathData('Health_Maintenance_Colon_date',v_CaseId,'DT') || '</date>' || LF;
  v_Str := v_Str || '            <notesList>' || LF; --- xxx awaiting client mapping info for <noteList>
  v_Str := v_Str || '               <title></title>' || LF;
  v_Str := v_Str || '               <value></value>' || LF;
  v_Str := v_Str || '            </notesList>' || LF;
 
  v_Str := v_Str || '        </items>' || LF;
  v_Str := v_Str || '        <items>' || LF;
  v_Str := v_Str || '            <title>Sigmoidoscopy</title>' || LF;
  v_Str := v_Str || '            <comments>' || Matrix_Utils.Get_InfoPathData('Health_Maintenance_Colon_Sigm_Box',v_CaseId,'ST') || '</comments>' || LF;
  v_Str := v_Str || '            <commentsTitle>Dr.</commentsTitle>' || LF;
  v_Str := v_Str || '            <status>' || Matrix_Utils.Get_InfoPathData('Health_Maintenance_Colon_Sigm',v_CaseId,'ST') || '</status>' || LF;
  v_Str := v_Str || '            <date>' || Matrix_Utils.Get_InfoPathData('Health_Maintenance_Colon_Sigm_date',v_CaseId,'DT') || '</date>' || LF;
  v_Str := v_Str || '            <notesList>' || LF; --- xxx awaiting client mapping info for <noteList>
  v_Str := v_Str || '               <title></title>' || LF;
  v_Str := v_Str || '               <value></value>' || LF;
  v_Str := v_Str || '            </notesList>' || LF;
  v_Str := v_Str || '        </items>' || LF;
  v_Str := v_Str || '        <items>' || LF;
  v_Str := v_Str || '            <title>Fecal Occult Blood Test</title>' || LF;
  v_Str := v_Str || '            <comments>' || Matrix_Utils.Get_InfoPathData('Health_Maintenance_Colon_Fecal_Box',v_CaseId,'ST') || '</comments>' || LF;
  v_Str := v_Str || '            <commentsTitle>Dr.</commentsTitle>' || LF;
  v_Str := v_Str || '            <status>' || Matrix_Utils.Get_InfoPathData('Health_Maintenance_Colon_Fecal',v_CaseId,'ST') || '</status>' || LF;
  v_Str := v_Str || '            <date>' || Matrix_Utils.Get_InfoPathData('Health_Maintenance_Colon_Fecal_date',v_CaseId,'DT') || '</date>' || LF;
  v_Str := v_Str || '            <notesList>' || LF; --- xxx awaiting client mapping info for <noteList>
  v_Str := v_Str || '               <title></title>' || LF;
  v_Str := v_Str || '               <value></value>' || LF;
  v_Str := v_Str || '            </notesList>' || LF;
  v_Str := v_Str || '        </items>' || LF;
  v_Str := v_Str || '   </screenList>' || LF;
  v_Str := v_Str || '</HealthMaintenance>' || LF;
  ------------------------------------
  RETURN v_Str;
EXCEPTION
WHEN OTHERS THEN
  v_Str := SUBSTR(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || CHR(13) || SQLERRM,1,4000);
  RAISE;
END MATRIX_XML_HEALTHMAINT;

---------------------------------------------------------------------
---------------------------------------------------------------------
FUNCTION MATRIX_XML_HRALocation(
    P_CASEID NUMBER ,
    P_LF     VARCHAR2)
  -- Created 10-6-2012 R Benzell
  -- typically called by GEN_MATRIX_XML
  -- select MATRIX_XML_HRALocation(1884,chr(10)) from dual
  -- Update History
  RETURN CLOB
IS
  v_Str CLOB;
  v_CaseId NUMBER;
  LF       VARCHAR2(5);
BEGIN
  v_CaseId := P_CaseId;
  LF       := P_LF;
  -----------------------------------
  v_Str                                         := v_Str || ' <HRALocation>' || LF;
  
  
--- Only 1 HRA location to be returned, even if user selected multiples.  If so, just use the first provided
CASE  
  WHEN Matrix_Utils.Get_InfoPathData('HRA_Home',v_CaseId,'ST') IS NOT NULL THEN
    v_Str                                       := v_Str || '   <hraLocation>' || LF;
    v_Str                                       := v_Str || '        <locationType>Home</locationType>' || LF;
    --v_Str := v_Str || '        <locationSubType>' || Matrix_Utils.Get_InfoPathData('HRA_Home',v_CaseId,'ST') || '</locationSubType>' || LF;
    v_Str := v_Str || '        <locationName>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</locationName>' || LF;
    v_Str := v_Str || '   </hraLocation>' || LF;
  
  
  WHEN  Matrix_Utils.Get_InfoPathData('HRA_SNF_PAC',v_CaseId,'ST') IS NOT NULL THEN
    v_Str                                          := v_Str || '   <hraLocation>' || LF;
    v_Str                                          := v_Str || '        <locationType>SNF</locationType>' || LF;
    v_Str                                          := v_Str || '        <locationSubType>PAC</locationSubType>' || LF;
    v_Str                                          := v_Str || '        <locationName>' || Matrix_Utils.Get_InfoPathData('HRA_SNF_PAC',v_CaseId,'ST') || '</locationName>' || LF;
    v_Str                                          := v_Str || '   </hraLocation>' || LF;
  
  
  WHEN  Matrix_Utils.Get_InfoPathData('HRA_SNF_LTC',v_CaseId,'ST') IS NOT NULL THEN
    v_Str                                          := v_Str || '   <hraLocation>' || LF;
    v_Str                                          := v_Str || '        <locationType>SNF</locationType>' || LF;
    v_Str                                          := v_Str || '        <locationSubType>LTC</locationSubType>' || LF;
    v_Str                                          := v_Str || '        <locationName>' || Matrix_Utils.Get_InfoPathData('HRA_SNF_LTC',v_CaseId,'ST') || '</locationName>' || LF;
    v_Str                                          := v_Str || '   </hraLocation>' || LF;
  
  
  WHEN  Matrix_Utils.Get_InfoPathData('HRA_SNF_ESRD',v_CaseId,'ST') IS NOT NULL THEN
    v_Str                                           := v_Str || '   <hraLocation>' || LF;
    v_Str                                           := v_Str || '        <locationType>ESRD</locationType>' || LF;
    --    v_Str := v_Str || '        <locationSubType>' || Matrix_Utils.Get_InfoPathData('HRA_SNF_ESRD',v_CaseId,'ST') || '</locationSubType>' || LF;
    v_Str := v_Str || '        <locationName>' || Matrix_Utils.Get_InfoPathData('HRA_SNF_ESRD',v_CaseId,'ST') || '</locationName>' || LF;
    v_Str := v_Str || '   </hraLocation>' || LF;
	
  ELSE	
    v_Str := v_Str || '   <hraLocation>' || LF;
    v_Str := v_Str || '        <locationType></locationType>' || LF;
    v_Str := v_Str || '        <locationName></locationName>' || LF;
    v_Str := v_Str || '   </hraLocation>' || LF;

  
 END CASE;
  
  v_Str := v_Str || ' </HRALocation>' || LF;
  ---------
  RETURN v_Str;
EXCEPTION
WHEN OTHERS THEN
  v_Str := SUBSTR(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || CHR(13) || SQLERRM,1,4000);
  RAISE;
END MATRIX_XML_HRALocation;

FUNCTION MATRIX_XML_INFOSOURCE(
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
  v_Str := v_Str || '    <value>' || Matrix_Utils.Get_InfoPathData('IS_Patient',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '    <desc>' || '' || '</desc>' || LF;
  v_Str := v_Str || '   </source>' || LF;
  v_Str := v_Str || '   <source>' || LF;
  v_Str := v_Str || '    <title>Medical Record</title>' || LF;
  v_Str := v_Str || '    <value>' || Matrix_Utils.Get_InfoPathData('IS_Medical_Record',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '    <desc>' || '' || '</desc>' || LF;
  v_Str := v_Str || '   </source>' || LF;
  
  v_Str := v_Str || '   <source>' || LF;
  v_Str := v_Str || '    <title>Other</title>' || LF;
  v_Str := v_Str || '    <value>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '    <desc>' || Matrix_Utils.Get_InfoPathData('IS_Other_Box',v_CaseId,'TF') || '</desc>' || LF;
  v_Str := v_Str || '   </source>' || LF;
  
  v_Str := v_Str || '   <diagnosis>' || Matrix_Utils.Get_InfoPathData('None',v_CaseId,'ST') || LF;
  v_Str := v_Str || '    <title>Diabetes</title>' || LF;
  v_Str := v_Str || '    <value>' || Matrix_Utils.Get_InfoPathData('IS_Diabetes',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '   </diagnosis>' || LF;
  
  v_Str := v_Str || '   <diagnosis>' || LF;
  v_Str := v_Str || '    <title>Cancer</title>' || LF;
  v_Str := v_Str || '    <value>' || Matrix_Utils.Get_InfoPathData('IS_Cancer',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '    <followupQuestions>' || LF;
  v_Str := v_Str || '       <title>The patient currently has cancer present?</title>' || LF;
  v_Str := v_Str || '       <answer>' || Matrix_Utils.Get_InfoPathData('xxx',v_CaseId,'ST') || '</answer>' || LF;
  v_Str := v_Str || '       <value>' || Matrix_Utils.Get_InfoPathData('IS_Cancer_Current',v_CaseId,'YN') || '</value>' || LF;
  v_Str := v_Str || '       <otherValue>' || Matrix_Utils.Get_InfoPathData('xxx',v_CaseId,'ST') || '</otherValue>' || LF;
  v_Str := v_Str || '     </followupQuestions>' || LF;
  v_Str := v_Str || '     <followupQuestions>' || LF;
  v_Str := v_Str || '      <title>The patient is currently on a treatment regimen such as chemotherapy or radiation therapy?</title>' || LF;
  v_Str := v_Str || '      <value>' || Matrix_Utils.Get_InfoPathData('IS_Cancer_Treatment',v_CaseId,'YN') || '</value>' || LF;
  v_Str := v_Str || '     </followupQuestions>' || LF;
  v_Str := v_Str || '     <followupQuestions>' || LF;
  v_Str := v_Str || '      <title>The patient is on other anti-cancer treatment (e.g. tamoxifen or lupron)?</title>' || LF;
  v_Str := v_Str || '      <value>' || Matrix_Utils.Get_InfoPathData('IS_Cancer_Other_Treatment',v_CaseId,'YN') || '</value>' || LF;
  v_Str := v_Str || '      <secondaryQuestions>' || LF;
  v_Str := v_Str || '       <title>List</title>' || LF;
  v_Str := v_Str || '       <value>' || '' || '</value>' || LF;
  v_Str := v_Str || '       <otherValue>' || Matrix_Utils.Get_InfoPathData('IS_Cancer_Other_Treatment_List',v_CaseId,'ST') || '</otherValue>' || LF;
  v_Str := v_Str || '      </secondaryQuestions>' || LF;
  v_Str := v_Str || '     </followupQuestions>' || LF;
  v_Str := v_Str || '     <followupQuestions>' || LF;
  v_Str := v_Str || '      <title>The patient currently has metastatic cancer present?</title>' || LF;
  v_Str := v_Str || '      <value>' || Matrix_Utils.Get_InfoPathData('IS_Cancer_Metastatic_Treatment',v_CaseId,'YN') || '</value>' || LF;
  v_Str := v_Str || '      <secondaryQuestions>' || LF;
--MG--Filled in <title> value
  v_Str := v_Str || '       <title>Location</title>' || LF;
  v_Str := v_Str || '       <value>' || '' || '</value>' || LF;
--MG-- updated <othervalue> field name
  v_Str := v_Str || '       <otherValue>' || Matrix_Utils.Get_InfoPathData('IS_Cancer_Metastatic_Treatment_Location',v_CaseId,'ST') || '</otherValue>' || LF;
  v_Str := v_Str || '      </secondaryQuestions>' || LF;
  v_Str := v_Str || '     </followupQuestions>' || LF;
--MG--Populate the Diagnoses Table within the "Information Source" section of the infopath doc.  Changes made to this section span 34 lines.
  v_Str := v_Str || '     <followupQuestions>' || LF;
  
  v_Str := v_Str || '      <title>Primary Cancer (Active) Diagnosis</title>' || LF;
  v_Str := v_Str || '      <value>' || Matrix_Utils.Get_InfoPathData('IS_Cancer_Active',v_CaseId,'YN') || '</value>' || LF;
  v_Str := v_Str || '      <secondaryQuestions>' || LF;
  v_Str := v_Str || '       <title>Primary Cancer location/type</title>' || LF;
  v_Str := v_Str || '       <answer>' || Matrix_Utils.Get_InfoPathData('IS_Cancer_Active_Type',v_CaseId,'YN') || '</answer>' || LF;
  v_Str := v_Str || '       <value>' || '' || '</value>' || LF;
  v_Str := v_Str || '      </secondaryQuestions>' || LF;
  v_Str := v_Str || '      <secondaryQuestions>' || LF;
  v_Str := v_Str || '       <title>' || '' || '</title>' || LF;
  v_Str := v_Str || '       <answer>' || '' || '</answer>' || LF;
  v_Str := v_Str || '       <value>' || '' || '</value>' || LF;
  v_Str := v_Str || '       <otherValue>' || '' || '</otherValue>' || LF;
  --v_Str := v_Str || '       <managementPlan>' || '' || '</managementPlan>' || LF;
  v_Str := v_Str || '      </secondaryQuestions>' || LF;
  v_Str := v_Str || '     </followupQuestions>' || LF;
  v_Str := v_Str || '     <followupQuestions>' || LF;
  v_Str := v_Str || '      <title>Metastatic Cancer (Active) Diagnosis</title>' || LF;
  v_Str := v_Str || '      <value>' || Matrix_Utils.Get_InfoPathData('IS_Metastic_Cancer_Active',v_CaseId,'YN') || '</value>' || LF;
  --v_Str := v_Str || '      <managementPlan>' || '' || '</managementPlan>' || LF;
  v_Str := v_Str || '      <secondaryQuestions>' || LF;
  v_Str := v_Str || '       <title>Location</title>' || LF;
  v_Str := v_Str || '       <answer>' || Matrix_Utils.Get_InfoPathData('IS_Metastatic_Cancer_Location',v_CaseId,'ST') || '</answer>' || LF;
  v_Str := v_Str || '       <value>' || '' || '</value>' || LF;
  v_Str := v_Str || '      </secondaryQuestions>' || LF;
  v_Str := v_Str || '     </followupQuestions>' || LF;
  v_Str := v_Str || '     <followupQuestions>' || LF;
  v_Str := v_Str || '      <title>History of Cancer</title>' || LF;
  v_Str := v_Str || '      <value>' || Matrix_Utils.Get_InfoPathData('IS_History_Cancer',v_CaseId,'YN') || '</value>' || LF;
  v_Str := v_Str || '      <secondaryQuestions>' || LF;
  v_Str := v_Str || '       <title>Location</title>' || LF;
  v_Str := v_Str || '       <value>' || Matrix_Utils.Get_InfoPathData('IS_History_Cancer_Location',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '      <managementPlan>' || Matrix_Utils.Get_InfoPathData('IS_History_Diagnosis_Plan_E1
+IS_History_Diagnosis_Plan_E2
+IS_History_Diagnosis_Plan_E3
+IS_History_Diagnosis_Plan_E4
+IS_History_Diagnosis_Plan_E5
+IS_History_Diagnosis_Plan_M1
+IS_History_Diagnosis_Plan_M2
+IS_History_Diagnosis_Plan_M3
+IS_History_Diagnosis_Plan_R1
+IS_History_Diagnosis_Plan_R2',v_CaseId,'MP') || '</managementPlan>' || LF;
  v_Str := v_Str || '      </secondaryQuestions>' || LF;
  
  v_Str := v_Str || '     </followupQuestions>' || LF;
  
  
  
  
--MG--End of changes made.
  v_Str := v_Str || '   </diagnosis>' || LF;
  v_Str := v_Str || '   <diagnosis>' || LF;
  v_Str := v_Str || '    <title>Have you ever been diagnosed with CHF?</title>' || LF;
  v_Str := v_Str || '    <value>' || Matrix_Utils.Get_InfoPathData('IS_CHF',v_CaseId,'YN') || '</value>' || LF;
  v_Str := v_Str || '   </diagnosis>' || LF;
  v_Str := v_Str || '   <diagnosis>' || LF;
  v_Str := v_Str || '    <title>Have you ever been diagnosed with MI?</title>' || LF;
  v_Str := v_Str || '    <value>' || Matrix_Utils.Get_InfoPathData('IS_MI',v_CaseId,'YN') || '</value>' || LF;
  v_Str := v_Str || '   </diagnosis>' || LF;
  v_Str := v_Str || '   <diagnosis>' || LF;
  v_Str := v_Str || '    <title>Have you ever been diagnosed with Angina?</title>' || LF;
  v_Str := v_Str || '    <value>' || Matrix_Utils.Get_InfoPathData('IS_Angina',v_CaseId,'YN') || '</value>' || LF;
  v_Str := v_Str || '   </diagnosis>' || LF;
  v_Str := v_Str || '   <diagnosis>' || LF;
  v_Str := v_Str || '    <title>Have you ever been diagnosed with Atrial fibrillation?</title>' || LF;
  v_Str := v_Str || '    <value>' || Matrix_Utils.Get_InfoPathData('IS_Atrial_Fibrillation',v_CaseId,'YN') || '</value>' || LF;
  v_Str := v_Str || '   </diagnosis>' || LF;
  v_Str := v_Str || '   <diagnosis>' || LF;
  v_Str := v_Str || '    <title>Have you ever had an amputation?</title>' || LF;
  v_Str := v_Str || '    <value>' || Matrix_Utils.Get_InfoPathData('IS_Amputation',v_CaseId,'YN') || '</value>' || LF;


  v_Str := v_Str || '   </diagnosis>' || LF;
  v_Str := v_Str || '  </InformationSource>' || LF;
  ------------------------------------
  RETURN v_Str;
EXCEPTION
WHEN OTHERS THEN
  v_Str := SUBSTR(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || CHR(13) || SQLERRM,1,4000);
  RAISE;
END MATRIX_XML_INFOSOURCE;

FUNCTION MATRIX_XML_LABDATA(
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
  v_Str := v_Str || '  <LabData>' || LF;
  v_Str := v_Str || '   <review>' || LF;
  v_Str := v_Str || '    <title>No lab data available</title>' || LF;
  v_Str := v_Str || '    <value>' || Matrix_Utils.Get_InfoPathData('Lab_Data_No_Data',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '   </review>' || LF;
  v_Str := v_Str || '   <labTests>' || LF;
  v_Str := v_Str || '    <units>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</units>' || LF;
  v_Str := v_Str || '    <title>Bun</title>' || LF;
  v_Str := v_Str || '    <result>' || Matrix_Utils.Get_InfoPathData('Lab_Data_Bun_1',v_CaseId,'ST') || '</result>' || LF;
  v_Str := v_Str || '    <date>' || Matrix_Utils.Get_InfoPathData('Lab_Data_Bun_date',v_CaseId,'DT') || '</date>' || LF;
  v_Str := v_Str || '   </labTests>' || LF;
  v_Str := v_Str || '   <labTests>' || LF;
  v_Str := v_Str || '    <units>' || '' || '</units>' || LF;
  v_Str := v_Str || '    <title>Creatinine</title>' || LF;
  v_Str := v_Str || '    <result>' || Matrix_Utils.Get_InfoPathData('Lab_Data_Creatinine',v_CaseId,'ST') || '</result>' || LF;
  v_Str := v_Str || '    <date>' || Matrix_Utils.Get_InfoPathData('Lab_Data_Creatinine_date',v_CaseId,'DT') || '</date>' || LF;
  v_Str := v_Str || '   </labTests>' || LF;
  v_Str := v_Str || '   <labTests>' || LF;
  v_Str := v_Str || '    <units>' || '' || '</units>' || LF;
  v_Str := v_Str || '    <title>Estimated GFR</title>' || LF;
  v_Str := v_Str || '    <result>' || Matrix_Utils.Get_InfoPathData('Lab_Data_GFR_1',v_CaseId,'ST') || '</result>' || LF;
  v_Str := v_Str || '    <date>' || Matrix_Utils.Get_InfoPathData('Lab_Data_GFR_date_1',v_CaseId,'ST') || '</date>' || LF;
  v_Str := v_Str || '   </labTests>' || LF;
  v_Str := v_Str || '   <labTests>' || LF;
  v_Str := v_Str || '    <units>' || '' || '</units>' || LF;
  v_Str := v_Str || '    <title>Estimated GFR</title>' || LF;
  v_Str := v_Str || '    <result>' || Matrix_Utils.Get_InfoPathData('Lab_Data_GFR_2',v_CaseId,'ST') || '</result>' || LF;
  v_Str := v_Str || '    <date>' || Matrix_Utils.Get_InfoPathData('Lab_Data_GFR_date_2',v_CaseId,'ST') || '</date>' || LF;
  v_Str := v_Str || '   </labTests>' || LF;
  v_Str := v_Str || '   <labTests>' || LF;
  v_Str := v_Str || '    <units>' || '' || '</units>' || LF;
  v_Str := v_Str || '    <title>HbA1c</title>' || LF;
  v_Str := v_Str || '    <result>' || Matrix_Utils.Get_InfoPathData('Lab_Data_HbA1c',v_CaseId,'ST') || '</result>' || LF;
  v_Str := v_Str || '    <date>' || Matrix_Utils.Get_InfoPathData('Lab_Data_HbA1c_date',v_CaseId,'DT') || '</date>' || LF;
  v_Str := v_Str || '   </labTests>' || LF;
  v_Str := v_Str || '   <labTests>' || LF;
  v_Str := v_Str || '    <units>' || '' || '</units>' || LF;
  v_Str := v_Str || '    <title>Fasting Blood Sugar</title>' || LF;
  v_Str := v_Str || '    <result>' || Matrix_Utils.Get_InfoPathData('Lab_Data_Fasting',v_CaseId,'ST') || '</result>' || LF;
  v_Str := v_Str || '    <date>' || Matrix_Utils.Get_InfoPathData('Lab_Data_Fasting_date',v_CaseId,'DT') || '</date>' || LF;
  v_Str := v_Str || '   </labTests>' || LF;
  v_Str := v_Str || '   <labTests>' || LF;
  v_Str := v_Str || '    <units>' || '' || '</units>' || LF;
  v_Str := v_Str || '    <title>LDL-C</title>' || LF;
  v_Str := v_Str || '    <result>' || Matrix_Utils.Get_InfoPathData('Lab_Data_LDL',v_CaseId,'ST') || '</result>' || LF;
  v_Str := v_Str || '    <date>' || Matrix_Utils.Get_InfoPathData('Lab_Data_LDL_date',v_CaseId,'DT') || '</date>' || LF;
  v_Str := v_Str || '   </labTests>' || LF;
  v_Str := v_Str || '   <labTests>' || LF;
  v_Str := v_Str || '    <units>' || '' || '</units>' || LF;
  v_Str := v_Str || '    <title>Serum Albumin</title>' || LF;
  v_Str := v_Str || '    <result>' || Matrix_Utils.Get_InfoPathData('Lab_Data_Serum_Albumin',v_CaseId,'ST') || '</result>' || LF;
  v_Str := v_Str || '    <date>' || Matrix_Utils.Get_InfoPathData('Lab_Data_Serum_Albumin_date',v_CaseId,'DT') || '</date>' || LF;
  v_Str := v_Str || '   </labTests>' || LF;
  v_Str := v_Str || '   <labTests>' || LF;
  v_Str := v_Str || '    <units>' || '' || '</units>' || LF;
  v_Str := v_Str || '    <title>Hgb</title>' || LF;
  v_Str := v_Str || '    <result>' || Matrix_Utils.Get_InfoPathData('Lab_Data_Hgb',v_CaseId,'ST') || '</result>' || LF;
  v_Str := v_Str || '    <date>' || Matrix_Utils.Get_InfoPathData('Lab_Data_Hgb_date',v_CaseId,'DT') || '</date>' || LF;
  v_Str := v_Str || '   </labTests>' || LF;
  v_Str := v_Str || '   <labTests>' || LF;
  v_Str := v_Str || '    <units>' || '' || '</units>' || LF;
  v_Str := v_Str || '    <title>Hct</title>' || LF;
  v_Str := v_Str || '    <result>' || Matrix_Utils.Get_InfoPathData('Lab_Data_Hct',v_CaseId,'ST') || '</result>' || LF;
  v_Str := v_Str || '    <date>' || Matrix_Utils.Get_InfoPathData('Lab_Data_Hct_date',v_CaseId,'DT') || '</date>' || LF;
  v_Str := v_Str || '   </labTests>' || LF;
  v_Str := v_Str || '   <labTests>' || LF;
  v_Str := v_Str || '    <units>' || '' || '</units>' || LF;
  v_Str := v_Str || '    <title>WBC</title>' || LF;
  v_Str := v_Str || '    <result>' || Matrix_Utils.Get_InfoPathData('Lab_Data_WBC',v_CaseId,'ST') || '</result>' || LF;
  v_Str := v_Str || '    <date>' || Matrix_Utils.Get_InfoPathData('Lab_Data_WBC_date',v_CaseId,'DT') || '</date>' || LF;
  v_Str := v_Str || '   </labTests>' || LF;
  v_Str := v_Str || '   <labTests>' || LF;
  v_Str := v_Str || '    <units>' || '' || '</units>' || LF;
  v_Str := v_Str || '    <title>Platelets</title>' || LF;
  v_Str := v_Str || '    <result>' || Matrix_Utils.Get_InfoPathData('Lab_Data_Platelets',v_CaseId,'ST') || '</result>' || LF;
  v_Str := v_Str || '    <date>' || Matrix_Utils.Get_InfoPathData('Lab_Data_Platelets_date',v_CaseId,'DT') || '</date>' || LF;
  v_Str := v_Str || '   </labTests>' || LF;
  v_Str := v_Str || '   <labTests>' || LF;
  v_Str := v_Str || '    <units>' || '' || '</units>' || LF;
  v_Str := v_Str || '    <title>Platelets</title>' || LF;
  v_Str := v_Str || '    <result>' || Matrix_Utils.Get_InfoPathData('Lab_Data_Slot',v_CaseId,'ST') || '</result>' || LF;
  v_Str := v_Str || '    <date>' || Matrix_Utils.Get_InfoPathData('Lab_Data_Slot_date',v_CaseId,'DT') || '</date>' || LF;
  v_Str := v_Str || '   </labTests>' || LF;
  v_Str := v_Str || '   <diagnosticTests>' || LF;
  v_Str := v_Str || '    <units>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</units>' || LF;
  v_Str := v_Str || '    <title>EKG</title>' || LF;
  v_Str := v_Str || '    <result>' || Matrix_Utils.Get_InfoPathData('Lab_Diag_Ekg',v_CaseId,'ST') || '</result>' || LF;
  v_Str := v_Str || '    <date>' || Matrix_Utils.Get_InfoPathData('Lab_Diag_Ekg_date',v_CaseId,'DT') || '</date>' || LF;
  v_Str := v_Str || '   </diagnosticTests>' || LF;
  v_Str := v_Str || '   <diagnosticTests>' || LF;
  v_Str := v_Str || '    <units>' || '' || '</units>' || LF;
  v_Str := v_Str || '    <title>CXR</title>' || LF;
  v_Str := v_Str || '    <result>' || Matrix_Utils.Get_InfoPathData('Lab_Diag_CXR',v_CaseId,'ST') || '</result>' || LF;
  v_Str := v_Str || '    <date>' || Matrix_Utils.Get_InfoPathData('Lab_Diag_CXR_date',v_CaseId,'DT') || '</date>' || LF;
  v_Str := v_Str || '   </diagnosticTests>' || LF;
  v_Str := v_Str || '   <diagnosticTests>' || LF;
  v_Str := v_Str || '    <units>' || '' || '</units>' || LF;
  v_Str := v_Str || '    <title>Echo</title>' || LF;
  v_Str := v_Str || '    <result>' || Matrix_Utils.Get_InfoPathData('Lab_Diag_Echo',v_CaseId,'ST') || '</result>' || LF;
  v_Str := v_Str || '    <date>' || Matrix_Utils.Get_InfoPathData('Lab_Diag_Echo_date',v_CaseId,'DT') || '</date>' || LF;
  v_Str := v_Str || '   </diagnosticTests>' || LF;
 
  v_Str := v_Str || '   <diagnosticTests>' || LF;
  v_Str := v_Str || '    <units>' || '' || '</units>' || LF;
  v_Str := v_Str || '    <title>MRI</title>' || LF;
  v_Str := v_Str || '    <result>' || Matrix_Utils.Get_InfoPathData('Lab_Diag_MRI',v_CaseId,'ST') || '</result>' || LF;
  v_Str := v_Str || '    <date>' || Matrix_Utils.Get_InfoPathData('Lab_Diag_MRI_date',v_CaseId,'DT') || '</date>' || LF;
  v_Str := v_Str || '   </diagnosticTests>' || LF;
 
  v_Str := v_Str || '   <diagnosticTests>' || LF;
  v_Str := v_Str || '    <units>' || '' || '</units>' || LF;
  v_Str := v_Str || '    <title>CT</title>' || LF;
  v_Str := v_Str || '    <result>' || Matrix_Utils.Get_InfoPathData('Lab_Diag_CT',v_CaseId,'ST') || '</result>' || LF;
  v_Str := v_Str || '    <date>' || Matrix_Utils.Get_InfoPathData('Lab_Diag_CT_date',v_CaseId,'DT') || '</date>' || LF;
  v_Str := v_Str || '   </diagnosticTests>' || LF;
  
  v_Str := v_Str || '   <diagnosticTests>' || LF;
  v_Str := v_Str || '    <units>' || '' || '</units>' || LF;
  v_Str := v_Str || '    <title>Other</title>' || LF;
  v_Str := v_Str || '    <result>' || Matrix_Utils.Get_InfoPathData('Lab_Diag_Other',v_CaseId,'ST') || '</result>' || LF;
  v_Str := v_Str || '    <date>' || Matrix_Utils.Get_InfoPathData('Lab_Diag_Other_date',v_CaseId,'DT') || '</date>' || LF;
  v_Str := v_Str || '   </diagnosticTests>' || LF;

  v_Str := v_Str || '  </LabData>' || LF;
  ------------------------------------
  RETURN v_Str;
EXCEPTION
WHEN OTHERS THEN
  v_Str := SUBSTR(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || CHR(13) || SQLERRM,1,4000);
  RAISE;
END MATRIX_XML_LABDATA;

FUNCTION MATRIX_XML_MEDHISTORY(
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
  v_Str := v_Str || '<MedicalHistory>' || LF;
  v_Str := v_Str || '<title></title>' || LF;

  v_Str := v_Str || ' <medicalHistoryDiagnosis>' || LF;
  v_Str := v_Str || '   <history>' ||  Matrix_Utils.Get_InfoPathData('Medical_History_Diagnosis_1',v_CaseId,'ST') || '</history>'  || LF;
  v_Str := v_Str || '   <historyType>' ||  Matrix_Utils.Get_InfoPathData('Medical_History_Diagnosis_1_A+Medical_History_Diagnosis_1_I',v_CaseId,'ST') || '</historyType>'  || LF;
  v_Str := v_Str || '   <isChronicXml>' ||  Matrix_Utils.Get_InfoPathData('Medical_History_Diagnosis_1_C',v_CaseId,'ST') || '</isChronicXml>'  || LF;
  v_Str := v_Str || ' </medicalHistoryDiagnosis>' || LF;

  v_Str := v_Str || ' <medicalHistoryDiagnosis>' || LF;
  v_Str := v_Str || '   <history>' ||  Matrix_Utils.Get_InfoPathData('Medical_History_Diagnosis_2',v_CaseId,'ST') || '</history>'  || LF;
  v_Str := v_Str || '   <historyType>' ||  Matrix_Utils.Get_InfoPathData('Medical_History_Diagnosis_2_A+Medical_History_Diagnosis_2_I',v_CaseId,'ST') || '</historyType>'  || LF;
  v_Str := v_Str || '   <isChronicXml>' ||  Matrix_Utils.Get_InfoPathData('Medical_History_Diagnosis_2_C',v_CaseId,'ST') || '</isChronicXml>'  || LF;
  v_Str := v_Str || ' </medicalHistoryDiagnosis>' || LF;

  v_Str := v_Str || ' <medicalHistoryDiagnosis>' || LF;
  v_Str := v_Str || '   <history>' ||  Matrix_Utils.Get_InfoPathData('Medical_History_Diagnosis_3',v_CaseId,'ST') || '</history>'  || LF;
  v_Str := v_Str || '   <historyType>' ||  Matrix_Utils.Get_InfoPathData('Medical_History_Diagnosis_3_A+Medical_History_Diagnosis_3_I',v_CaseId,'ST') || '</historyType>'  || LF;
  v_Str := v_Str || '   <isChronicXml>' ||  Matrix_Utils.Get_InfoPathData('Medical_History_Diagnosis_3_C',v_CaseId,'ST') || '</isChronicXml>'  || LF;
  v_Str := v_Str || ' </medicalHistoryDiagnosis>' || LF;

  v_Str := v_Str || ' <medicalHistoryDiagnosis>' || LF;
  v_Str := v_Str || '   <history>' ||  Matrix_Utils.Get_InfoPathData('Medical_History_Diagnosis_4',v_CaseId,'ST') || '</history>'  || LF;
  v_Str := v_Str || '   <historyType>' ||  Matrix_Utils.Get_InfoPathData('Medical_History_Diagnosis_4_A+Medical_History_Diagnosis_4_I',v_CaseId,'ST') || '</historyType>'  || LF;
  v_Str := v_Str || '   <isChronicXml>' ||  Matrix_Utils.Get_InfoPathData('Medical_History_Diagnosis_4_C',v_CaseId,'ST') || '</isChronicXml>'  || LF;
  v_Str := v_Str || ' </medicalHistoryDiagnosis>' || LF;

  v_Str := v_Str || ' <medicalHistoryDiagnosis>' || LF;
  v_Str := v_Str || '   <history>' ||  Matrix_Utils.Get_InfoPathData('Medical_History_Diagnosis_5',v_CaseId,'ST') || '</history>'  || LF;
  v_Str := v_Str || '   <historyType>' ||  Matrix_Utils.Get_InfoPathData('Medical_History_Diagnosis_5_A+Medical_History_Diagnosis_5_I',v_CaseId,'ST') || '</historyType>'  || LF;
  v_Str := v_Str || '   <isChronicXml>' ||  Matrix_Utils.Get_InfoPathData('Medical_History_Diagnosis_5_C',v_CaseId,'ST') || '</isChronicXml>'  || LF;
  v_Str := v_Str || ' </medicalHistoryDiagnosis>' || LF;

  v_Str := v_Str || ' <medicalHistoryDiagnosis>' || LF;
  v_Str := v_Str || '   <history>' ||  Matrix_Utils.Get_InfoPathData('Medical_History_Diagnosis_6',v_CaseId,'ST') || '</history>'  || LF;
  v_Str := v_Str || '   <historyType>' ||  Matrix_Utils.Get_InfoPathData('Medical_History_Diagnosis_6_A+Medical_History_Diagnosis_6_I',v_CaseId,'ST') || '</historyType>'  || LF;
  v_Str := v_Str || '   <isChronicXml>' ||  Matrix_Utils.Get_InfoPathData('Medical_History_Diagnosis_6_C',v_CaseId,'ST') || '</isChronicXml>'  || LF;
  v_Str := v_Str || ' </medicalHistoryDiagnosis>' || LF;

  v_Str := v_Str || ' <medicalHistoryDiagnosis>' || LF;
  v_Str := v_Str || '   <history>' ||  Matrix_Utils.Get_InfoPathData('Medical_History_Diagnosis_7',v_CaseId,'ST') || '</history>'  || LF;
  v_Str := v_Str || '   <historyType>' ||  Matrix_Utils.Get_InfoPathData('Medical_History_Diagnosis_7_A+Medical_History_Diagnosis_7_I',v_CaseId,'ST') || '</historyType>'  || LF;
  v_Str := v_Str || '   <isChronicXml>' ||  Matrix_Utils.Get_InfoPathData('Medical_History_Diagnosis_7_C',v_CaseId,'ST') || '</isChronicXml>'  || LF;
  v_Str := v_Str || ' </medicalHistoryDiagnosis>' || LF;

  v_Str := v_Str || ' <medicalHistoryDiagnosis>' || LF;
  v_Str := v_Str || '   <history>' ||  Matrix_Utils.Get_InfoPathData('Medical_History_Diagnosis_8',v_CaseId,'ST') || '</history>'  || LF;
  v_Str := v_Str || '   <historyType>' ||  Matrix_Utils.Get_InfoPathData('Medical_History_Diagnosis_8_A+Medical_History_Diagnosis_8_I',v_CaseId,'ST') || '</historyType>'  || LF;
  v_Str := v_Str || '   <isChronicXml>' ||  Matrix_Utils.Get_InfoPathData('Medical_History_Diagnosis_8_C',v_CaseId,'ST') || '</isChronicXml>'  || LF;
  v_Str := v_Str || ' </medicalHistoryDiagnosis>' || LF;

  v_Str := v_Str || ' <medicalHistoryDiagnosis>' || LF;
  v_Str := v_Str || '   <history>' ||  Matrix_Utils.Get_InfoPathData('Medical_History_Diagnosis_9',v_CaseId,'ST') || '</history>'  || LF;
  v_Str := v_Str || '   <historyType>' ||  Matrix_Utils.Get_InfoPathData('Medical_History_Diagnosis_9_A+Medical_History_Diagnosis_9_I',v_CaseId,'ST') || '</historyType>'  || LF;
  v_Str := v_Str || '   <isChronicXml>' ||  Matrix_Utils.Get_InfoPathData('Medical_History_Diagnosis_9_C',v_CaseId,'ST') || '</isChronicXml>'  || LF;
  v_Str := v_Str || ' </medicalHistoryDiagnosis>' || LF;

  v_Str := v_Str || ' <medicalHistoryDiagnosis>' || LF;
  v_Str := v_Str || '   <history>' ||  Matrix_Utils.Get_InfoPathData('Medical_History_Diagnosis_10',v_CaseId,'ST') || '</history>'  || LF;
  v_Str := v_Str || '   <historyType>' ||  Matrix_Utils.Get_InfoPathData('Medical_History_Diagnosis_10_A+Medical_History_Diagnosis_10_I',v_CaseId,'ST') || '</historyType>'  || LF;
  v_Str := v_Str || '   <isChronicXml>' ||  Matrix_Utils.Get_InfoPathData('Medical_History_Diagnosis_10_C',v_CaseId,'ST') || '</isChronicXml>'  || LF;
  v_Str := v_Str || ' </medicalHistoryDiagnosis>' || LF;

  v_Str := v_Str || ' <medicalHistoryDiagnosis>' || LF;
  v_Str := v_Str || '   <history>' ||  Matrix_Utils.Get_InfoPathData('Medical_History_Diagnosis_11',v_CaseId,'ST') || '</history>'  || LF;
  v_Str := v_Str || '   <historyType>' ||  Matrix_Utils.Get_InfoPathData('Medical_History_Diagnosis_11_A+Medical_History_Diagnosis_11_I',v_CaseId,'ST') || '</historyType>'  || LF;
  v_Str := v_Str || '   <isChronicXml>' ||  Matrix_Utils.Get_InfoPathData('Medical_History_Diagnosis_11_C',v_CaseId,'ST') || '</isChronicXml>'  || LF;
  v_Str := v_Str || ' </medicalHistoryDiagnosis>' || LF;

  v_Str := v_Str || ' <medicalHistoryDiagnosis>' || LF;
  v_Str := v_Str || '   <history>' ||  Matrix_Utils.Get_InfoPathData('Medical_History_Diagnosis_12',v_CaseId,'ST') || '</history>'  || LF;
  v_Str := v_Str || '   <historyType>' ||  Matrix_Utils.Get_InfoPathData('Medical_History_Diagnosis_12_A+Medical_History_Diagnosis_12_I',v_CaseId,'ST') || '</historyType>'  || LF;
  v_Str := v_Str || '   <isChronicXml>' ||  Matrix_Utils.Get_InfoPathData('Medical_History_Diagnosis_12_C',v_CaseId,'ST') || '</isChronicXml>'  || LF;
  v_Str := v_Str || ' </medicalHistoryDiagnosis>' || LF;

  v_Str := v_Str || ' <medicalHistoryDiagnosis>' || LF;
  v_Str := v_Str || '   <history>' ||  Matrix_Utils.Get_InfoPathData('Medical_History_Diagnosis_13',v_CaseId,'ST') || '</history>'  || LF;
  v_Str := v_Str || '   <historyType>' ||  Matrix_Utils.Get_InfoPathData('Medical_History_Diagnosis_13_A+Medical_History_Diagnosis_13_I',v_CaseId,'ST') || '</historyType>'  || LF;
  v_Str := v_Str || '   <isChronicXml>' ||  Matrix_Utils.Get_InfoPathData('Medical_History_Diagnosis_13_C',v_CaseId,'ST') || '</isChronicXml>'  || LF;
  v_Str := v_Str || ' </medicalHistoryDiagnosis>' || LF;

  v_Str := v_Str || ' <medicalHistoryDiagnosis>' || LF;
  v_Str := v_Str || '   <history>' ||  Matrix_Utils.Get_InfoPathData('Medical_History_Diagnosis_14',v_CaseId,'ST') || '</history>'  || LF;
  v_Str := v_Str || '   <historyType>' ||  Matrix_Utils.Get_InfoPathData('Medical_History_Diagnosis_14_A+Medical_History_Diagnosis_14_I',v_CaseId,'ST') || '</historyType>'  || LF;
  v_Str := v_Str || '   <isChronicXml>' ||  Matrix_Utils.Get_InfoPathData('Medical_History_Diagnosis_14_C',v_CaseId,'ST') || '</isChronicXml>'  || LF;
  v_Str := v_Str || ' </medicalHistoryDiagnosis>' || LF;

  v_Str := v_Str || ' <medicalHistoryDiagnosis>' || LF;
  v_Str := v_Str || '   <history>' ||  Matrix_Utils.Get_InfoPathData('Medical_History_Diagnosis_15',v_CaseId,'ST') || '</history>'  || LF;
  v_Str := v_Str || '   <historyType>' ||  Matrix_Utils.Get_InfoPathData('Medical_History_Diagnosis_15_A+Medical_History_Diagnosis_15_I',v_CaseId,'ST') || '</historyType>'  || LF;
  v_Str := v_Str || '   <isChronicXml>' ||  Matrix_Utils.Get_InfoPathData('Medical_History_Diagnosis_15_C',v_CaseId,'ST') || '</isChronicXml>'  || LF;
  v_Str := v_Str || ' </medicalHistoryDiagnosis>' || LF;

--- Addendum Diagnosis
  v_Str := v_Str || ' <medicalHistoryDiagnosis>' || LF;
  v_Str := v_Str || '   <history>' ||  Matrix_Utils.Get_InfoPathData('Addendum_Add_Med_Diag_1',v_CaseId,'ST') || '</history>'  || LF;
  v_Str := v_Str || '   <historyType>' ||  Matrix_Utils.Get_InfoPathData('Addendum_Add_Med_Diag_1_A+Addendum_Add_Med_Diag_1_I',v_CaseId,'ST') || '</historyType>'  || LF;
  v_Str := v_Str || '   <isChronicXml>' ||  Matrix_Utils.Get_InfoPathData('Addendum_Add_Med_Diag_1_C',v_CaseId,'ST') || '</isChronicXml>'  || LF;
  v_Str := v_Str || ' </medicalHistoryDiagnosis>' || LF;

  v_Str := v_Str || ' <medicalHistoryDiagnosis>' || LF;
  v_Str := v_Str || '   <history>' ||  Matrix_Utils.Get_InfoPathData('Addendum_Add_Med_Diag_2',v_CaseId,'ST') || '</history>'  || LF;
  v_Str := v_Str || '   <historyType>' ||  Matrix_Utils.Get_InfoPathData('Addendum_Add_Med_Diag_2_A+Addendum_Add_Med_Diag_2_I',v_CaseId,'ST') || '</historyType>'  || LF;
  v_Str := v_Str || '   <isChronicXml>' ||  Matrix_Utils.Get_InfoPathData('Addendum_Add_Med_Diag_2_C',v_CaseId,'ST') || '</isChronicXml>'  || LF;
  v_Str := v_Str || ' </medicalHistoryDiagnosis>' || LF;

  v_Str := v_Str || ' <medicalHistoryDiagnosis>' || LF;
  v_Str := v_Str || '   <history>' ||  Matrix_Utils.Get_InfoPathData('Addendum_Add_Med_Diag_3',v_CaseId,'ST') || '</history>'  || LF;
  v_Str := v_Str || '   <historyType>' ||  Matrix_Utils.Get_InfoPathData('Addendum_Add_Med_Diag_3_A+Addendum_Add_Med_Diag_3_I',v_CaseId,'ST') || '</historyType>'  || LF;
  v_Str := v_Str || '   <isChronicXml>' ||  Matrix_Utils.Get_InfoPathData('Addendum_Add_Med_Diag_3_C',v_CaseId,'ST') || '</isChronicXml>'  || LF;
  v_Str := v_Str || ' </medicalHistoryDiagnosis>' || LF;

  v_Str := v_Str || ' <medicalHistoryDiagnosis>' || LF;
  v_Str := v_Str || '   <history>' ||  Matrix_Utils.Get_InfoPathData('Addendum_Add_Med_Diag_4',v_CaseId,'ST') || '</history>'  || LF;
  v_Str := v_Str || '   <historyType>' ||  Matrix_Utils.Get_InfoPathData('Addendum_Add_Med_Diag_4_A+Addendum_Add_Med_Diag_4_I',v_CaseId,'ST') || '</historyType>'  || LF;
  v_Str := v_Str || '   <isChronicXml>' ||  Matrix_Utils.Get_InfoPathData('Addendum_Add_Med_Diag_4_C',v_CaseId,'ST') || '</isChronicXml>'  || LF;
  v_Str := v_Str || ' </medicalHistoryDiagnosis>' || LF;

  v_Str := v_Str || ' <medicalHistoryDiagnosis>' || LF;
  v_Str := v_Str || '   <history>' ||  Matrix_Utils.Get_InfoPathData('Addendum_Add_Med_Diag_5',v_CaseId,'ST') || '</history>'  || LF;
  v_Str := v_Str || '   <historyType>' ||  Matrix_Utils.Get_InfoPathData('Addendum_Add_Med_Diag_5_A+Addendum_Add_Med_Diag_5_I',v_CaseId,'ST') || '</historyType>'  || LF;
  v_Str := v_Str || '   <isChronicXml>' ||  Matrix_Utils.Get_InfoPathData('Addendum_Add_Med_Diag_5_C',v_CaseId,'ST') || '</isChronicXml>'  || LF;
  v_Str := v_Str || ' </medicalHistoryDiagnosis>' || LF;
					 
					 

  v_Str := v_Str || '   <drugAllergy>' || LF;
  v_Str := v_Str || '        <drugAllergy>' || Matrix_Utils.Get_InfoPathData('Drug_Allergies_1 + Drug_Allergies_2',v_CaseId,'ST') || '</drugAllergy>' || LF;
  v_Str := v_Str || '        <noKnownAllergies>' || Matrix_Utils.Get_InfoPathData('Drug_Allergies_None',v_CaseId,'TF') || '</noKnownAllergies>' || LF;
  v_Str := v_Str || '   </drugAllergy>' || LF;
  v_Str := v_Str || '   <currentMedication>' || LF;
 -- v_Str := v_Str || '        <medicationReview>' || LF;
  --v_Str := v_Str || '           <title>I have reviewed each medication with the patient</title>'  || LF;
 -- v_Str := v_Str || '           <value>' || Matrix_Utils.Get_InfoPathData('Current_Medication_Reviewed',v_CaseId,'YN') || '</value>' || LF;
 -- v_Str := v_Str || '        </medicationReview>' || LF;

  v_Str := v_Str || '        <medications>' || LF;
  v_Str := v_Str || '            <title>' || Matrix_Utils.Get_InfoPathData('Current_Drug_1',v_CaseId,'ST') || '</title>' || LF;
  v_Str := v_Str || '            <dosage>' || Matrix_Utils.Get_InfoPathData('Current_Dose_1',v_CaseId,'ST') || '</dosage>' || LF;
  v_Str := v_Str || '            <frequency>' || Matrix_Utils.Get_InfoPathData('Current_Freq_1',v_CaseId,'ST') || '</frequency>' || LF;
  v_Str := v_Str || '            <route>' || Matrix_Utils.Get_InfoPathData('Current_Route_1',v_CaseId,'ST') || '</route>' || LF;
                        -- RAB 10-22-2012 changed spelling from assosiatedDiagnosis to associatedDiagnosis throughout
  v_Str := v_Str || '            <associatedDiagnosis>' || Matrix_Utils.Get_InfoPathData('Current_Associate_Diagnosis_1',v_CaseId,'ST') || '</associatedDiagnosis>' || LF;
  v_Str := v_Str || '            <managementPlan>' || Matrix_Utils.Get_InfoPathData('Current_Management_1_M1 + Current_Management_1_M2 + Current_Management_1_M3 + Current_Management_1_R1',v_CaseId,'MP') || '</managementPlan>' || LF;
  v_Str := v_Str || '            <medicineCompliance>' || Matrix_Utils.Get_InfoPathData('Current_Taken_1',v_CaseId,'TF') || '</medicineCompliance>' || LF;
  v_Str := v_Str || '        </medications>' || LF;
  v_Str := v_Str || '        <medications>' || LF;
  v_Str := v_Str || '            <title>' || Matrix_Utils.Get_InfoPathData('Current_Drug_2',v_CaseId,'ST') || '</title>' || LF;
  v_Str := v_Str || '            <dosage>' || Matrix_Utils.Get_InfoPathData('Current_Dose_2',v_CaseId,'ST') || '</dosage>' || LF;
  v_Str := v_Str || '            <frequency>' || Matrix_Utils.Get_InfoPathData('Current_Freq_2',v_CaseId,'ST') || '</frequency>' || LF;
  v_Str := v_Str || '            <route>' || Matrix_Utils.Get_InfoPathData('Current_Route_2',v_CaseId,'ST') || '</route>' || LF;
  v_Str := v_Str || '            <associatedDiagnosis>' || Matrix_Utils.Get_InfoPathData('Current_Associate_Diagnosis_2',v_CaseId,'ST') || '</associatedDiagnosis>' || LF;
  v_Str := v_Str || '            <managementPlan>' || Matrix_Utils.Get_InfoPathData('Current_Management_2_M1 + Current_Management_2_M2 + Current_Management_2_M3 + Current_Management_2_R1',v_CaseId,'MP') || '</managementPlan>' || LF;
  v_Str := v_Str || '            <medicineCompliance>' || Matrix_Utils.Get_InfoPathData('Current_Taken_2',v_CaseId,'TF') || '</medicineCompliance>' || LF;
  v_Str := v_Str || '        </medications>' || LF;
  v_Str := v_Str || '        <medications>' || LF;
  v_Str := v_Str || '            <title>' || Matrix_Utils.Get_InfoPathData('Current_Drug_3',v_CaseId,'ST') || '</title>' || LF;
  v_Str := v_Str || '            <dosage>' || Matrix_Utils.Get_InfoPathData('Current_Dose_3',v_CaseId,'ST') || '</dosage>' || LF;
  v_Str := v_Str || '            <frequency>' || Matrix_Utils.Get_InfoPathData('Current_Freq_3',v_CaseId,'ST') || '</frequency>' || LF;
  v_Str := v_Str || '            <route>' || Matrix_Utils.Get_InfoPathData('Current_Route_3',v_CaseId,'ST') || '</route>' || LF;
  v_Str := v_Str || '            <associatedDiagnosis>' || Matrix_Utils.Get_InfoPathData('Current_Associate_Diagnosis_3',v_CaseId,'ST') || '</associatedDiagnosis>' || LF;
  v_Str := v_Str || '            <managementPlan>' || Matrix_Utils.Get_InfoPathData('Current_Management_3_M1 + Current_Management_3_M2 + Current_Management_3_M3 + Current_Management_3_R1',v_CaseId,'MP') || '</managementPlan>' || LF;
  v_Str := v_Str || '            <medicineCompliance>' || Matrix_Utils.Get_InfoPathData('Current_Taken_3',v_CaseId,'TF') || '</medicineCompliance>' || LF;
  v_Str := v_Str || '        </medications>' || LF;
  v_Str := v_Str || '        <medications>' || LF;
  v_Str := v_Str || '            <title>' || Matrix_Utils.Get_InfoPathData('Current_Drug_4',v_CaseId,'ST') || '</title>' || LF;
  v_Str := v_Str || '            <dosage>' || Matrix_Utils.Get_InfoPathData('Current_Dose_4',v_CaseId,'ST') || '</dosage>' || LF;
  v_Str := v_Str || '            <frequency>' || Matrix_Utils.Get_InfoPathData('Current_Freq_4',v_CaseId,'ST') || '</frequency>' || LF;
  v_Str := v_Str || '            <route>' || Matrix_Utils.Get_InfoPathData('Current_Route_4',v_CaseId,'ST') || '</route>' || LF;
  v_Str := v_Str || '            <associatedDiagnosis>' || Matrix_Utils.Get_InfoPathData('Current_Associate_Diagnosis_4',v_CaseId,'ST') || '</associatedDiagnosis>' || LF;
  v_Str := v_Str || '            <managementPlan>' || Matrix_Utils.Get_InfoPathData('Current_Management_4_M1 + Current_Management_4_M2 + Current_Management_4_M3 + Current_Management_4_R1',v_CaseId,'MP') || '</managementPlan>' || LF;
  v_Str := v_Str || '            <medicineCompliance>' || Matrix_Utils.Get_InfoPathData('Current_Taken_4',v_CaseId,'TF') || '</medicineCompliance>' || LF;
  v_Str := v_Str || '        </medications>' || LF;
  v_Str := v_Str || '        <medications>' || LF;
  v_Str := v_Str || '            <title>' || Matrix_Utils.Get_InfoPathData('Current_Drug_5',v_CaseId,'ST') || '</title>' || LF;
  v_Str := v_Str || '            <dosage>' || Matrix_Utils.Get_InfoPathData('Current_Dose_5',v_CaseId,'ST') || '</dosage>' || LF;
  v_Str := v_Str || '            <frequency>' || Matrix_Utils.Get_InfoPathData('Current_Freq_5',v_CaseId,'ST') || '</frequency>' || LF;
  v_Str := v_Str || '            <route>' || Matrix_Utils.Get_InfoPathData('Current_Route_5',v_CaseId,'ST') || '</route>' || LF;
  v_Str := v_Str || '            <associatedDiagnosis>' || Matrix_Utils.Get_InfoPathData('Current_Associate_Diagnosis_5',v_CaseId,'ST') || '</associatedDiagnosis>' || LF;
  v_Str := v_Str || '            <managementPlan>' || Matrix_Utils.Get_InfoPathData('Current_Management_5_M1 + Current_Management_5_M2 + Current_Management_5_M3 + Current_Management_5_R1',v_CaseId,'MP') || '</managementPlan>' || LF;
  v_Str := v_Str || '            <medicineCompliance>' || Matrix_Utils.Get_InfoPathData('Current_Taken_5',v_CaseId,'TF') || '</medicineCompliance>' || LF;
  v_Str := v_Str || '        </medications>' || LF;
  v_Str := v_Str || '        <medications>' || LF;
  v_Str := v_Str || '            <title>' || Matrix_Utils.Get_InfoPathData('Current_Drug_6',v_CaseId,'ST') || '</title>' || LF;
  v_Str := v_Str || '            <dosage>' || Matrix_Utils.Get_InfoPathData('Current_Dose_6',v_CaseId,'ST') || '</dosage>' || LF;
  v_Str := v_Str || '            <frequency>' || Matrix_Utils.Get_InfoPathData('Current_Freq_6',v_CaseId,'ST') || '</frequency>' || LF;
  v_Str := v_Str || '            <route>' || Matrix_Utils.Get_InfoPathData('Current_Route_6',v_CaseId,'ST') || '</route>' || LF;
  v_Str := v_Str || '            <associatedDiagnosis>' || Matrix_Utils.Get_InfoPathData('Current_Associate_Diagnosis_6',v_CaseId,'ST') || '</associatedDiagnosis>' || LF;
  v_Str := v_Str || '            <managementPlan>' || Matrix_Utils.Get_InfoPathData('Current_Management_6_M1 + Current_Management_6_M2 + Current_Management_6_M3 + Current_Management_6_R1',v_CaseId,'MP') || '</managementPlan>' || LF;
  v_Str := v_Str || '            <medicineCompliance>' || Matrix_Utils.Get_InfoPathData('Current_Taken_6',v_CaseId,'TF') || '</medicineCompliance>' || LF;
  v_Str := v_Str || '        </medications>' || LF;
  v_Str := v_Str || '        <medications>' || LF;
  v_Str := v_Str || '            <title>' || Matrix_Utils.Get_InfoPathData('Current_Drug_7',v_CaseId,'ST') || '</title>' || LF;
  v_Str := v_Str || '            <dosage>' || Matrix_Utils.Get_InfoPathData('Current_Dose_7',v_CaseId,'ST') || '</dosage>' || LF;
  v_Str := v_Str || '            <frequency>' || Matrix_Utils.Get_InfoPathData('Current_Freq_7',v_CaseId,'ST') || '</frequency>' || LF;
  v_Str := v_Str || '            <route>' || Matrix_Utils.Get_InfoPathData('Current_Route_7',v_CaseId,'ST') || '</route>' || LF;
  v_Str := v_Str || '            <associatedDiagnosis>' || Matrix_Utils.Get_InfoPathData('Current_Associate_Diagnosis_7',v_CaseId,'ST') || '</associatedDiagnosis>' || LF;
  v_Str := v_Str || '            <managementPlan>' || Matrix_Utils.Get_InfoPathData('Current_Management_7_M1 + Current_Management_7_M2 + Current_Management_7_M3 + Current_Management_7_R1',v_CaseId,'MP') || '</managementPlan>' || LF;
  v_Str := v_Str || '            <medicineCompliance>' || Matrix_Utils.Get_InfoPathData('Current_Taken_7',v_CaseId,'TF') || '</medicineCompliance>' || LF;
  v_Str := v_Str || '        </medications>' || LF;
  v_Str := v_Str || '        <medications>' || LF;
  v_Str := v_Str || '            <title>' || Matrix_Utils.Get_InfoPathData('Current_Drug_8',v_CaseId,'ST') || '</title>' || LF;
  v_Str := v_Str || '            <dosage>' || Matrix_Utils.Get_InfoPathData('Current_Dose_8',v_CaseId,'ST') || '</dosage>' || LF;
  v_Str := v_Str || '            <frequency>' || Matrix_Utils.Get_InfoPathData('Current_Freq_8',v_CaseId,'ST') || '</frequency>' || LF;
  v_Str := v_Str || '            <route>' || Matrix_Utils.Get_InfoPathData('Current_Route_8',v_CaseId,'ST') || '</route>' || LF;
  v_Str := v_Str || '            <associatedDiagnosis>' || Matrix_Utils.Get_InfoPathData('Current_Associate_Diagnosis_8',v_CaseId,'ST') || '</associatedDiagnosis>' || LF;
  v_Str := v_Str || '            <managementPlan>' || Matrix_Utils.Get_InfoPathData('Current_Management_8_M1 + Current_Management_8_M2 + Current_Management_8_M3 + Current_Management_8_R1',v_CaseId,'MP') || '</managementPlan>' || LF;
  v_Str := v_Str || '            <medicineCompliance>' || Matrix_Utils.Get_InfoPathData('Current_Taken_8',v_CaseId,'TF') || '</medicineCompliance>' || LF;
  v_Str := v_Str || '        </medications>' || LF;
  v_Str := v_Str || '        <medications>' || LF;
  v_Str := v_Str || '            <title>' || Matrix_Utils.Get_InfoPathData('Current_Drug_9',v_CaseId,'ST') || '</title>' || LF;
  v_Str := v_Str || '            <dosage>' || Matrix_Utils.Get_InfoPathData('Current_Dose_9',v_CaseId,'ST') || '</dosage>' || LF;
  v_Str := v_Str || '            <frequency>' || Matrix_Utils.Get_InfoPathData('Current_Freq_9',v_CaseId,'ST') || '</frequency>' || LF;
  v_Str := v_Str || '            <route>' || Matrix_Utils.Get_InfoPathData('Current_Route_9',v_CaseId,'ST') || '</route>' || LF;
  v_Str := v_Str || '            <associatedDiagnosis>' || Matrix_Utils.Get_InfoPathData('Current_Associate_Diagnosis_9',v_CaseId,'ST') || '</associatedDiagnosis>' || LF;
  v_Str := v_Str || '            <managementPlan>' || Matrix_Utils.Get_InfoPathData('Current_Management_9_M1 + Current_Management_9_M2 + Current_Management_9_M3 + Current_Management_9_R1',v_CaseId,'MP') || '</managementPlan>' || LF;
  v_Str := v_Str || '            <medicineCompliance>' || Matrix_Utils.Get_InfoPathData('Current_Taken_9',v_CaseId,'TF') || '</medicineCompliance>' || LF;
  v_Str := v_Str || '        </medications>' || LF;
  v_Str := v_Str || '        <medications>' || LF;
  v_Str := v_Str || '            <title>' || Matrix_Utils.Get_InfoPathData('Current_Drug_10',v_CaseId,'ST') || '</title>' || LF;
  v_Str := v_Str || '            <dosage>' || Matrix_Utils.Get_InfoPathData('Current_Dose_10',v_CaseId,'ST') || '</dosage>' || LF;
  v_Str := v_Str || '            <frequency>' || Matrix_Utils.Get_InfoPathData('Current_Freq_10',v_CaseId,'ST') || '</frequency>' || LF;
  v_Str := v_Str || '            <route>' || Matrix_Utils.Get_InfoPathData('Current_Route_10',v_CaseId,'ST') || '</route>' || LF;
  v_Str := v_Str || '            <associatedDiagnosis>' || Matrix_Utils.Get_InfoPathData('Current_Associate_Diagnosis_10',v_CaseId,'ST') || '</associatedDiagnosis>' || LF;
  v_Str := v_Str || '            <managementPlan>' || Matrix_Utils.Get_InfoPathData('Current_Management_10_M1 + Current_Management_10_M2 + Current_Management_10_M3 + Current_Management_10_R1',v_CaseId,'MP') || '</managementPlan>' || LF;
  v_Str := v_Str || '            <medicineCompliance>' || Matrix_Utils.Get_InfoPathData('Current_Taken_10',v_CaseId,'TF') || '</medicineCompliance>' || LF;
  v_Str := v_Str || '        </medications>' || LF;
  v_Str := v_Str || '        <medications>' || LF;
  v_Str := v_Str || '            <title>' || Matrix_Utils.Get_InfoPathData('Current_Drug_11',v_CaseId,'ST') || '</title>' || LF;
  v_Str := v_Str || '            <dosage>' || Matrix_Utils.Get_InfoPathData('Current_Dose_11',v_CaseId,'ST') || '</dosage>' || LF;
  v_Str := v_Str || '            <frequency>' || Matrix_Utils.Get_InfoPathData('Current_Freq_11',v_CaseId,'ST') || '</frequency>' || LF;
  v_Str := v_Str || '            <route>' || Matrix_Utils.Get_InfoPathData('Current_Route_11',v_CaseId,'ST') || '</route>' || LF;
  v_Str := v_Str || '            <associatedDiagnosis>' || Matrix_Utils.Get_InfoPathData('Current_Associate_Diagnosis_11',v_CaseId,'ST') || '</associatedDiagnosis>' || LF;
  v_Str := v_Str || '            <managementPlan>' || Matrix_Utils.Get_InfoPathData('Current_Management_11_M1 + Current_Management_11_M2 + Current_Management_11_M3 + Current_Management_11_R1',v_CaseId,'MP') || '</managementPlan>' || LF;
  v_Str := v_Str || '            <medicineCompliance>' || Matrix_Utils.Get_InfoPathData('Current_Taken_11',v_CaseId,'TF') || '</medicineCompliance>' || LF;
  v_Str := v_Str || '        </medications>' || LF;
  v_Str := v_Str || '        <medications>' || LF;
  v_Str := v_Str || '            <title>' || Matrix_Utils.Get_InfoPathData('Current_Drug_12',v_CaseId,'ST') || '</title>' || LF;
  v_Str := v_Str || '            <dosage>' || Matrix_Utils.Get_InfoPathData('Current_Dose_12',v_CaseId,'ST') || '</dosage>' || LF;
  v_Str := v_Str || '            <frequency>' || Matrix_Utils.Get_InfoPathData('Current_Freq_12',v_CaseId,'ST') || '</frequency>' || LF;
  v_Str := v_Str || '            <route>' || Matrix_Utils.Get_InfoPathData('Current_Route_12',v_CaseId,'ST') || '</route>' || LF;
  v_Str := v_Str || '            <associatedDiagnosis>' || Matrix_Utils.Get_InfoPathData('Current_Associate_Diagnosis_12',v_CaseId,'ST') || '</associatedDiagnosis>' || LF;
  v_Str := v_Str || '            <managementPlan>' || Matrix_Utils.Get_InfoPathData('Current_Management_12_M1 + Current_Management_12_M2 + Current_Management_12_M3 + Current_Management_12_R1',v_CaseId,'MP') || '</managementPlan>' || LF;
  v_Str := v_Str || '            <medicineCompliance>' || Matrix_Utils.Get_InfoPathData('Current_Taken_12',v_CaseId,'TF') || '</medicineCompliance>' || LF;
  v_Str := v_Str || '        </medications>' || LF;
  v_Str := v_Str || '        <medications>' || LF;
  v_Str := v_Str || '            <title>' || Matrix_Utils.Get_InfoPathData('Current_Drug_13',v_CaseId,'ST') || '</title>' || LF;
  v_Str := v_Str || '            <dosage>' || Matrix_Utils.Get_InfoPathData('Current_Dose_13',v_CaseId,'ST') || '</dosage>' || LF;
  v_Str := v_Str || '            <frequency>' || Matrix_Utils.Get_InfoPathData('Current_Freq_13',v_CaseId,'ST') || '</frequency>' || LF;
  v_Str := v_Str || '            <route>' || Matrix_Utils.Get_InfoPathData('Current_Route_13',v_CaseId,'ST') || '</route>' || LF;
  v_Str := v_Str || '            <associatedDiagnosis>' || Matrix_Utils.Get_InfoPathData('Current_Associate_Diagnosis_13',v_CaseId,'ST') || '</associatedDiagnosis>' || LF;
  v_Str := v_Str || '            <managementPlan>' || Matrix_Utils.Get_InfoPathData('Current_Management_13_M1 + Current_Management_13_M2 + Current_Management_13_M3 + Current_Management_13_R1',v_CaseId,'MP') || '</managementPlan>' || LF;
  v_Str := v_Str || '            <medicineCompliance>' || Matrix_Utils.Get_InfoPathData('Current_Taken_13',v_CaseId,'TF') || '</medicineCompliance>' || LF;
  v_Str := v_Str || '        </medications>' || LF;
  v_Str := v_Str || '        <medications>' || LF;
  v_Str := v_Str || '            <title>' || Matrix_Utils.Get_InfoPathData('Current_Drug_14',v_CaseId,'ST') || '</title>' || LF;
  v_Str := v_Str || '            <dosage>' || Matrix_Utils.Get_InfoPathData('Current_Dose_14',v_CaseId,'ST') || '</dosage>' || LF;
  v_Str := v_Str || '            <frequency>' || Matrix_Utils.Get_InfoPathData('Current_Freq_14',v_CaseId,'ST') || '</frequency>' || LF;
  v_Str := v_Str || '            <route>' || Matrix_Utils.Get_InfoPathData('Current_Route_14',v_CaseId,'ST') || '</route>' || LF;
  v_Str := v_Str || '            <associatedDiagnosis>' || Matrix_Utils.Get_InfoPathData('Current_Associate_Diagnosis_14',v_CaseId,'ST') || '</associatedDiagnosis>' || LF;
  v_Str := v_Str || '            <managementPlan>' || Matrix_Utils.Get_InfoPathData('Current_Management_14_M1 + Current_Management_14_M2 + Current_Management_14_M3 + Current_Management_14_R1',v_CaseId,'MP') || '</managementPlan>' || LF;
  v_Str := v_Str || '            <medicineCompliance>' || Matrix_Utils.Get_InfoPathData('Current_Taken_14',v_CaseId,'TF') || '</medicineCompliance>' || LF;
  v_Str := v_Str || '        </medications>' || LF;
  v_Str := v_Str || '        <medications>' || LF;
  v_Str := v_Str || '            <title>' || Matrix_Utils.Get_InfoPathData('Current_Drug_15',v_CaseId,'ST') || '</title>' || LF;
  v_Str := v_Str || '            <dosage>' || Matrix_Utils.Get_InfoPathData('Current_Dose_15',v_CaseId,'ST') || '</dosage>' || LF;
  v_Str := v_Str || '            <frequency>' || Matrix_Utils.Get_InfoPathData('Current_Freq_15',v_CaseId,'ST') || '</frequency>' || LF;
  v_Str := v_Str || '            <route>' || Matrix_Utils.Get_InfoPathData('Current_Route_15',v_CaseId,'ST') || '</route>' || LF;
  v_Str := v_Str || '            <associatedDiagnosis>' || Matrix_Utils.Get_InfoPathData('Current_Associate_Diagnosis_15',v_CaseId,'ST') || '</associatedDiagnosis>' || LF;
  v_Str := v_Str || '            <managementPlan>' || Matrix_Utils.Get_InfoPathData('Current_Management_15_M1 + Current_Management_15_M2 + Current_Management_15_M3 + Current_Management_15_R1',v_CaseId,'MP') || '</managementPlan>' || LF;
  v_Str := v_Str || '            <medicineCompliance>' || Matrix_Utils.Get_InfoPathData('Current_Taken_15',v_CaseId,'TF') || '</medicineCompliance>' || LF;
  v_Str := v_Str || '        </medications>' || LF;
  v_Str := v_Str || '        <medications>' || LF;
  v_Str := v_Str || '            <title>' || Matrix_Utils.Get_InfoPathData('Current_Drug_16',v_CaseId,'ST') || '</title>' || LF;
  v_Str := v_Str || '            <dosage>' || Matrix_Utils.Get_InfoPathData('Current_Dose_16',v_CaseId,'ST') || '</dosage>' || LF;
  v_Str := v_Str || '            <frequency>' || Matrix_Utils.Get_InfoPathData('Current_Freq_16',v_CaseId,'ST') || '</frequency>' || LF;
  v_Str := v_Str || '            <route>' || Matrix_Utils.Get_InfoPathData('Current_Route_16',v_CaseId,'ST') || '</route>' || LF;
  v_Str := v_Str || '            <associatedDiagnosis>' || Matrix_Utils.Get_InfoPathData('Current_Associate_Diagnosis_16',v_CaseId,'ST') || '</associatedDiagnosis>' || LF;
  v_Str := v_Str || '            <managementPlan>' || Matrix_Utils.Get_InfoPathData('Current_Management_16_M1 + Current_Management_16_M2 + Current_Management_16_M3 + Current_Management_16_R1',v_CaseId,'MP') || '</managementPlan>' || LF;
  v_Str := v_Str || '            <medicineCompliance>' || Matrix_Utils.Get_InfoPathData('Current_Taken_16',v_CaseId,'TF') || '</medicineCompliance>' || LF;
  v_Str := v_Str || '        </medications>' || LF;
  v_Str := v_Str || '        <medications>' || LF;
  v_Str := v_Str || '            <title>' || Matrix_Utils.Get_InfoPathData('Current_Drug_17',v_CaseId,'ST') || '</title>' || LF;
  v_Str := v_Str || '            <dosage>' || Matrix_Utils.Get_InfoPathData('Current_Dose_17',v_CaseId,'ST') || '</dosage>' || LF;
  v_Str := v_Str || '            <frequency>' || Matrix_Utils.Get_InfoPathData('Current_Freq_17',v_CaseId,'ST') || '</frequency>' || LF;
  v_Str := v_Str || '            <route>' || Matrix_Utils.Get_InfoPathData('Current_Route_17',v_CaseId,'ST') || '</route>' || LF;
  v_Str := v_Str || '            <associatedDiagnosis>' || Matrix_Utils.Get_InfoPathData('Current_Associate_Diagnosis_17',v_CaseId,'ST') || '</associatedDiagnosis>' || LF;
  v_Str := v_Str || '            <managementPlan>' || Matrix_Utils.Get_InfoPathData('Current_Management_17_M1 + Current_Management_17_M2 + Current_Management_17_M3 + Current_Management_17_R1',v_CaseId,'MP') || '</managementPlan>' || LF;
  v_Str := v_Str || '            <medicineCompliance>' || Matrix_Utils.Get_InfoPathData('Current_Taken_17',v_CaseId,'TF') || '</medicineCompliance>' || LF;
  v_Str := v_Str || '        </medications>' || LF;
  v_Str := v_Str || '        <medications>' || LF;
  v_Str := v_Str || '            <title>' || Matrix_Utils.Get_InfoPathData('Current_Drug_18',v_CaseId,'ST') || '</title>' || LF;
  v_Str := v_Str || '            <dosage>' || Matrix_Utils.Get_InfoPathData('Current_Dose_18',v_CaseId,'ST') || '</dosage>' || LF;
  v_Str := v_Str || '            <frequency>' || Matrix_Utils.Get_InfoPathData('Current_Freq_18',v_CaseId,'ST') || '</frequency>' || LF;
  v_Str := v_Str || '            <route>' || Matrix_Utils.Get_InfoPathData('Current_Route_18',v_CaseId,'ST') || '</route>' || LF;
  v_Str := v_Str || '            <associatedDiagnosis>' || Matrix_Utils.Get_InfoPathData('Current_Associate_Diagnosis_18',v_CaseId,'ST') || '</associatedDiagnosis>' || LF;
  v_Str := v_Str || '            <managementPlan>' || Matrix_Utils.Get_InfoPathData('Current_Management_18_M1 + Current_Management_18_M2 + Current_Management_18_M3 + Current_Management_18_R1',v_CaseId,'MP') || '</managementPlan>' || LF;
  v_Str := v_Str || '            <medicineCompliance>' || Matrix_Utils.Get_InfoPathData('Current_Taken_18',v_CaseId,'TF') || '</medicineCompliance>' || LF;
  v_Str := v_Str || '        </medications>' || LF;
  v_Str := v_Str || '        <medications>' || LF;
  v_Str := v_Str || '            <title>' || Matrix_Utils.Get_InfoPathData('Current_Drug_19',v_CaseId,'ST') || '</title>' || LF;
  v_Str := v_Str || '            <dosage>' || Matrix_Utils.Get_InfoPathData('Current_Dose_19',v_CaseId,'ST') || '</dosage>' || LF;
  v_Str := v_Str || '            <frequency>' || Matrix_Utils.Get_InfoPathData('Current_Freq_19',v_CaseId,'ST') || '</frequency>' || LF;
  v_Str := v_Str || '            <route>' || Matrix_Utils.Get_InfoPathData('Current_Route_19',v_CaseId,'ST') || '</route>' || LF;
  v_Str := v_Str || '            <associatedDiagnosis>' || Matrix_Utils.Get_InfoPathData('Current_Associate_Diagnosis_19',v_CaseId,'ST') || '</associatedDiagnosis>' || LF;
  v_Str := v_Str || '            <managementPlan>' || Matrix_Utils.Get_InfoPathData('Current_Management_19_M1 + Current_Management_19_M2 + Current_Management_19_M3 + Current_Management_19_R1',v_CaseId,'MP') || '</managementPlan>' || LF;
  v_Str := v_Str || '            <medicineCompliance>' || Matrix_Utils.Get_InfoPathData('Current_Taken_19',v_CaseId,'TF') || '</medicineCompliance>' || LF;
  v_Str := v_Str || '        </medications>' || LF;
  v_Str := v_Str || '        <medications>' || LF;
  v_Str := v_Str || '            <title>' || Matrix_Utils.Get_InfoPathData('Current_Drug_20',v_CaseId,'ST') || '</title>' || LF;
  v_Str := v_Str || '            <dosage>' || Matrix_Utils.Get_InfoPathData('Current_Dose_20',v_CaseId,'ST') || '</dosage>' || LF;
  v_Str := v_Str || '            <frequency>' || Matrix_Utils.Get_InfoPathData('Current_Freq_20',v_CaseId,'ST') || '</frequency>' || LF;
  v_Str := v_Str || '            <route>' || Matrix_Utils.Get_InfoPathData('Current_Route_20',v_CaseId,'ST') || '</route>' || LF;
  v_Str := v_Str || '            <associatedDiagnosis>' || Matrix_Utils.Get_InfoPathData('Current_Associate_Diagnosis_20',v_CaseId,'ST') || '</associatedDiagnosis>' || LF;
  v_Str := v_Str || '            <managementPlan>' || Matrix_Utils.Get_InfoPathData('Current_Management_20_M1 + Current_Management_20_M2 + Current_Management_20_M3 + Current_Management_20_R1',v_CaseId,'MP') || '</managementPlan>' || LF;
  v_Str := v_Str || '            <medicineCompliance>' || Matrix_Utils.Get_InfoPathData('Current_Taken_20',v_CaseId,'TF') || '</medicineCompliance>' || LF;
  v_Str := v_Str || '        </medications>' || LF;

--  Addendum Medications
  v_Str := v_Str || '        <medications>' || LF;
  v_Str := v_Str || '            <title>' || Matrix_Utils.Get_InfoPathData('Addendum_Add_Cur_Drug_1',v_CaseId,'ST') || '</title>' || LF;
  v_Str := v_Str || '            <dosage>' || Matrix_Utils.Get_InfoPathData('Addendum_Add_Cur_Dose_1',v_CaseId,'ST') || '</dosage>' || LF;
  v_Str := v_Str || '            <frequency>' || Matrix_Utils.Get_InfoPathData('Addendum_Add_Cur_Freq_1',v_CaseId,'ST') || '</frequency>' || LF;
  v_Str := v_Str || '            <route>' || Matrix_Utils.Get_InfoPathData('Addendum_Add_Cur_Route_1',v_CaseId,'ST') || '</route>' || LF;
  v_Str := v_Str || '            <associatedDiagnosis>' || Matrix_Utils.Get_InfoPathData('Addendum_Add_Cur_Assoc_1',v_CaseId,'ST') || '</associatedDiagnosis>' || LF;
  v_Str := v_Str || '            <managementPlan>' || Matrix_Utils.Get_InfoPathData('Addendum_Add_Cur_Med_1_Plan_M1 + Addendum_Add_Cur_Med_1_Plan_M2 + Addendum_Add_Cur_Med_1_Plan_M3 + Addendum_Add_Cur_Med_1_Plan_R1',v_CaseId,'MP') || '</managementPlan>' || LF;
  v_Str := v_Str || '            <medicineCompliance>' || Matrix_Utils.Get_InfoPathData('Addendum_Add_Cur_Taken_1',v_CaseId,'TF') || '</medicineCompliance>' || LF;
  v_Str := v_Str || '        </medications>' || LF;
  v_Str := v_Str || '        <medications>' || LF;
  v_Str := v_Str || '            <title>' || Matrix_Utils.Get_InfoPathData('Addendum_Add_Cur_Drug_2',v_CaseId,'ST') || '</title>' || LF;
  v_Str := v_Str || '            <dosage>' || Matrix_Utils.Get_InfoPathData('Addendum_Add_Cur_Dose_2',v_CaseId,'ST') || '</dosage>' || LF;
  v_Str := v_Str || '            <frequency>' || Matrix_Utils.Get_InfoPathData('Addendum_Add_Cur_Freq_2',v_CaseId,'ST') || '</frequency>' || LF;
  v_Str := v_Str || '            <route>' || Matrix_Utils.Get_InfoPathData('Addendum_Add_Cur_Route_2',v_CaseId,'ST') || '</route>' || LF;
  v_Str := v_Str || '            <associatedDiagnosis>' || Matrix_Utils.Get_InfoPathData('Addendum_Add_Cur_Assoc_2',v_CaseId,'ST') || '</associatedDiagnosis>' || LF;
  v_Str := v_Str || '            <managementPlan>' || Matrix_Utils.Get_InfoPathData('Addendum_Add_Cur_Med_2_Plan_M1 + Addendum_Add_Cur_Med_2_Plan_M2 + Addendum_Add_Cur_Med_2_Plan_M3 + Addendum_Add_Cur_Med_2_Plan_R1',v_CaseId,'MP') || '</managementPlan>' || LF;
  v_Str := v_Str || '            <medicineCompliance>' || Matrix_Utils.Get_InfoPathData('Addendum_Add_Cur_Taken_2',v_CaseId,'TF') || '</medicineCompliance>' || LF;
  v_Str := v_Str || '        </medications>' || LF;
  v_Str := v_Str || '        <medications>' || LF;
  v_Str := v_Str || '            <title>' || Matrix_Utils.Get_InfoPathData('Addendum_Add_Cur_Drug_3',v_CaseId,'ST') || '</title>' || LF;
  v_Str := v_Str || '            <dosage>' || Matrix_Utils.Get_InfoPathData('Addendum_Add_Cur_Dose_3',v_CaseId,'ST') || '</dosage>' || LF;
  v_Str := v_Str || '            <frequency>' || Matrix_Utils.Get_InfoPathData('Addendum_Add_Cur_Freq_3',v_CaseId,'ST') || '</frequency>' || LF;
  v_Str := v_Str || '            <route>' || Matrix_Utils.Get_InfoPathData('Addendum_Add_Cur_Route_3',v_CaseId,'ST') || '</route>' || LF;
  v_Str := v_Str || '            <associatedDiagnosis>' || Matrix_Utils.Get_InfoPathData('Addendum_Add_Cur_Assoc_3',v_CaseId,'ST') || '</associatedDiagnosis>' || LF;
  v_Str := v_Str || '            <managementPlan>' || Matrix_Utils.Get_InfoPathData('Addendum_Add_Cur_Med_3_Plan_M1 + Addendum_Add_Cur_Med_3_Plan_M2 + Addendum_Add_Cur_Med_3_Plan_M3 + Addendum_Add_Cur_Med_3_Plan_R1',v_CaseId,'MP') || '</managementPlan>' || LF;
  v_Str := v_Str || '            <medicineCompliance>' || Matrix_Utils.Get_InfoPathData('Addendum_Add_Cur_Taken_3',v_CaseId,'TF') || '</medicineCompliance>' || LF;
  v_Str := v_Str || '        </medications>' || LF;
  v_Str := v_Str || '        <medications>' || LF;
  v_Str := v_Str || '            <title>' || Matrix_Utils.Get_InfoPathData('Addendum_Add_Cur_Drug_4',v_CaseId,'ST') || '</title>' || LF;
  v_Str := v_Str || '            <dosage>' || Matrix_Utils.Get_InfoPathData('Addendum_Add_Cur_Dose_4',v_CaseId,'ST') || '</dosage>' || LF;
  v_Str := v_Str || '            <frequency>' || Matrix_Utils.Get_InfoPathData('Addendum_Add_Cur_Freq_4',v_CaseId,'ST') || '</frequency>' || LF;
  v_Str := v_Str || '            <route>' || Matrix_Utils.Get_InfoPathData('Addendum_Add_Cur_Route_4',v_CaseId,'ST') || '</route>' || LF;
  v_Str := v_Str || '            <associatedDiagnosis>' || Matrix_Utils.Get_InfoPathData('Addendum_Add_Cur_Assoc_4',v_CaseId,'ST') || '</associatedDiagnosis>' || LF;
  v_Str := v_Str || '            <managementPlan>' || Matrix_Utils.Get_InfoPathData('Addendum_Add_Cur_Med_4_Plan_M1 + Addendum_Add_Cur_Med_4_Plan_M2 + Addendum_Add_Cur_Med_4_Plan_M3 + Addendum_Add_Cur_Med_4_Plan_R1',v_CaseId,'MP') || '</managementPlan>' || LF;
  v_Str := v_Str || '            <medicineCompliance>' || Matrix_Utils.Get_InfoPathData('Addendum_Add_Cur_Taken_4',v_CaseId,'TF') || '</medicineCompliance>' || LF;
  v_Str := v_Str || '        </medications>' || LF;
  v_Str := v_Str || '        <medications>' || LF;
  v_Str := v_Str || '            <title>' || Matrix_Utils.Get_InfoPathData('Addendum_Add_Cur_Drug_5',v_CaseId,'ST') || '</title>' || LF;
  v_Str := v_Str || '            <dosage>' || Matrix_Utils.Get_InfoPathData('Addendum_Add_Cur_Dose_5',v_CaseId,'ST') || '</dosage>' || LF;
  v_Str := v_Str || '            <frequency>' || Matrix_Utils.Get_InfoPathData('Addendum_Add_Cur_Freq_5',v_CaseId,'ST') || '</frequency>' || LF;
  v_Str := v_Str || '            <route>' || Matrix_Utils.Get_InfoPathData('Addendum_Add_Cur_Route_5',v_CaseId,'ST') || '</route>' || LF;
  v_Str := v_Str || '            <associatedDiagnosis>' || Matrix_Utils.Get_InfoPathData('Addendum_Add_Cur_Assoc_5',v_CaseId,'ST') || '</associatedDiagnosis>' || LF;
  v_Str := v_Str || '            <managementPlan>' || Matrix_Utils.Get_InfoPathData('Addendum_Add_Cur_Med_5_Plan_M1 + Addendum_Add_Cur_Med_5_Plan_M2 + Addendum_Add_Cur_Med_5_Plan_M3 + Addendum_Add_Cur_Med_5_Plan_R1',v_CaseId,'MP') || '</managementPlan>' || LF;
  v_Str := v_Str || '            <medicineCompliance>' || Matrix_Utils.Get_InfoPathData('Addendum_Add_Cur_Taken_5',v_CaseId,'TF') || '</medicineCompliance>' || LF;
  v_Str := v_Str || '        </medications>' || LF;
  v_Str := v_Str || '        <medications>' || LF;
  v_Str := v_Str || '            <title>' || Matrix_Utils.Get_InfoPathData('Addendum_Add_Cur_Drug_6',v_CaseId,'ST') || '</title>' || LF;
  v_Str := v_Str || '            <dosage>' || Matrix_Utils.Get_InfoPathData('Addendum_Add_Cur_Dose_6',v_CaseId,'ST') || '</dosage>' || LF;
  v_Str := v_Str || '            <frequency>' || Matrix_Utils.Get_InfoPathData('Addendum_Add_Cur_Freq_6',v_CaseId,'ST') || '</frequency>' || LF;
  v_Str := v_Str || '            <route>' || Matrix_Utils.Get_InfoPathData('Addendum_Add_Cur_Route_6',v_CaseId,'ST') || '</route>' || LF;
  v_Str := v_Str || '            <associatedDiagnosis>' || Matrix_Utils.Get_InfoPathData('Addendum_Add_Cur_Assoc_6',v_CaseId,'ST') || '</associatedDiagnosis>' || LF;
  v_Str := v_Str || '            <managementPlan>' || Matrix_Utils.Get_InfoPathData('Addendum_Add_Cur_Med_6_Plan_M1 + Addendum_Add_Cur_Med_6_Plan_M2 + Addendum_Add_Cur_Med_6_Plan_M3 + Addendum_Add_Cur_Med_6_Plan_R1',v_CaseId,'MP') || '</managementPlan>' || LF;
  v_Str := v_Str || '            <medicineCompliance>' || Matrix_Utils.Get_InfoPathData('Addendum_Add_Cur_Taken_6',v_CaseId,'TF') || '</medicineCompliance>' || LF;
  v_Str := v_Str || '        </medications>' || LF;

  v_Str := v_Str || '   </currentMedication>' || LF;

  v_Str := v_Str || '   <medicineReviewed>' || Matrix_Utils.Get_InfoPathData('Current_Medication_Reviewed',v_CaseId,'YN10') || '</medicineReviewed>' || LF;

  v_Str := v_Str || '   <medicationManagement>' || LF;
  -- RAB 10-22-2012 Dropped per 10-18-2012 8:29 AM feedback from David Watson <dwatson@matrixhealth.net>
  --v_Str := v_Str || '        <title>Medication Management Not Applicable because in LTC</title>' || LF;
  --v_Str := v_Str || '        <value>' || Matrix_Utils.Get_InfoPathData(' Med_Mgmt_LTC ',v_CaseId,'TF') || '</value>' || LF;
  
  -- RAB 2-27-13 - added title/value as empty tags
  v_Str := v_Str || '        <title></title>' || LF;
  v_Str := v_Str || '        <value></value>' || LF;
  v_Str := v_Str || '        <questions>' || LF;
  v_Str := v_Str || '         <title>Able to obtain all of your prescribed medicines</title>' || LF;
  v_Str := v_Str || '         <value>' || Matrix_Utils.Get_InfoPathData('Med_Mgmt_Obtain_Med',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '            <secondaryQuestions>' || LF;
  v_Str := v_Str || '                  <title>If no, is it because you cannot afford your medicines?</title>' || LF;
  v_Str := v_Str || '                  <value>' || Matrix_Utils.Get_InfoPathData('Med_Mgmt_Cannot_Afford_Med',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '            </secondaryQuestions>' || LF;
  v_Str := v_Str || '        </questions>' || LF;
  v_Str := v_Str || '        <questions>' || LF;
  v_Str := v_Str || '         <title>Independently takes medication in correct doses at the correct time?</title>' || LF;
  v_Str := v_Str || '         <value>' || Matrix_Utils.Get_InfoPathData('Med_Mgmt_Independant_Dosage',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '            <secondaryQuestions>' || LF;
  v_Str := v_Str || '                  <title>Takes responsibility if medication is prepared in advance in separate dosages?</title>' || LF;
  v_Str := v_Str || '                  <value>' || Matrix_Utils.Get_InfoPathData('Med_Mgmt_Seperate_Dosage',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '            </secondaryQuestions>' || LF;
  v_Str := v_Str || '            <secondaryQuestions>' || LF;
  v_Str := v_Str || '                  <title>Is not capable of taking medication without assistance?</title>' || LF;
  v_Str := v_Str || '                  <value>' || Matrix_Utils.Get_InfoPathData('Med_Mgmt_Needs_Assistance',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '            </secondaryQuestions>' || LF;
  v_Str := v_Str || '        </questions>' || LF;
  v_Str := v_Str || '   </medicationManagement>' || LF;





  --v_Str := v_Str || ' </medicalHistorydiagnosis>' || LF;
  v_Str := v_Str || '</MedicalHistory>' || LF;
  ------------------------------------
  RETURN v_Str;
EXCEPTION
WHEN OTHERS THEN
  v_Str := SUBSTR(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || CHR(13) || SQLERRM,1,4000);
  RAISE;
END MATRIX_XML_MEDHISTORY;

FUNCTION MATRIX_XML_MGMTREFER(
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
  v_Str := v_Str || '<ManagementReferral>' || LF;
  v_Str := v_Str || '   <timeSensitive>' || Matrix_Utils.Get_InfoPathData('Summary_Time',v_CaseId,'TF') || '</timeSensitive>' || LF;
  v_Str := v_Str || '   <dateOfEval>' || Matrix_Utils.Get_InfoPathData('Summary_date',v_CaseId,'DT') || '</dateOfEval>' || LF;
  v_Str := v_Str || '   <providerOptOut>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</providerOptOut>' || LF;
  v_Str := v_Str || '   <agreeToPlanFollowUp>' || Matrix_Utils.Get_InfoPathData('Summary_Member',v_CaseId,'TF') || '</agreeToPlanFollowUp>' || LF;

  v_Str := v_Str || '   <npMemberInfo></npMemberInfo>' || LF;

  v_Str := v_Str || '   <memberInfo>' || LF;
  v_Str := v_Str || '        <firstName>' || Matrix_Utils.Get_InfoPathData('Summary_Member_Name',v_CaseId,'ST') || '</firstName>' || LF;
  v_Str := v_Str || '        <lastName>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</lastName>' || LF;
  v_Str := v_Str || '        <phone>' || Matrix_Utils.Get_InfoPathData('Summary_Member_Phone',v_CaseId,'ST') || '</phone>' || LF;
  v_Str := v_Str || '        <address>' || LF;
  v_Str := v_Str || '            <address1>' || Matrix_Utils.Get_InfoPathData('Summary_Member_Address',v_CaseId,'ST') || '</address1>' || LF;
  --v_Str := v_Str || '            <address2>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</address2>' || LF;
  v_Str := v_Str || '            <city>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</city>' || LF;
  v_Str := v_Str || '            <country>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</country>' || LF;
  v_Str := v_Str || '            <state>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</state>' || LF;
  v_Str := v_Str || '            <suite>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</suite>' || LF;
  v_Str := v_Str || '            <zipCode>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</zipCode>' || LF;
  v_Str := v_Str || '        </address>' || LF;
--  v_Str := v_Str || '        <relationship>' || Matrix_Utils.Get_InfoPathData('Summary_Member_Contact_Relationship',v_CaseId,'ST') || '</relationship>' || LF;
--  v_Str := v_Str || '        <typeDesc>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</typeDesc>' || LF;
  v_Str := v_Str || '   </memberInfo>' || LF;
  v_Str := v_Str || '   <additionalInfo>' || Matrix_Utils.Get_InfoPathData('Summary_Additional_Info',v_CaseId,'ST') || '</additionalInfo>' || LF;
  v_Str := v_Str || '   <livingWith>' || Matrix_Utils.Get_InfoPathData('Summary_Lives_Alone 
+ Summary_Lives_Children 
+ Summary_Lives_Friend 
+ Summary_Lives_Other
+ Summary_Lives_Sibling 
+ Summary_Lives_Spouse 
+ Summary_Lives_Unrelated_Adult',v_CaseId,'MP') || '</livingWith>' || LF;
  v_Str := v_Str || '   <communityMobility>' || Matrix_Utils.Get_InfoPathData('Summary_Mobility_Assist + Summary_Mobility_Homebound + Summary_Mobility_Independent',v_CaseId,'MP') || '</communityMobility>' || LF;
  v_Str := v_Str || '   <specialtyCare>'|| LF;
  v_Str := v_Str || '        <firstName>' || Matrix_Utils.Get_InfoPathData('Summary_SCP',v_CaseId,'ST') || '</firstName>' || LF;
  v_Str := v_Str || '        <lastName>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</lastName>' || LF;
  v_Str := v_Str || '        <phone>' || Matrix_Utils.Get_InfoPathData('Summary_SCP_Phone',v_CaseId,'ST') || '</phone>' || LF;

/**  
  v_Str := v_Str || '        <address>' || LF;
  v_Str := v_Str || '            <address1>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</address1>' || LF;
  v_Str := v_Str || '            <address2>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</address2>' || LF;
  v_Str := v_Str || '            <city>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</city>' || LF;
  v_Str := v_Str || '            <country>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</country>' || LF;
  v_Str := v_Str || '            <state>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</state>' || LF;
  v_Str := v_Str || '            <suite>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</suite>' || LF;
  v_Str := v_Str || '            <zipCode>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</zipCode>' || LF;
  v_Str := v_Str || '        </address>' || LF;
**/  
  
  v_Str := v_Str || '        <contactType>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</contactType>' || LF;
  v_Str := v_Str || '        <relationship>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</relationship>' || LF;
  v_Str := v_Str || '        <typeDesc>' || Matrix_Utils.Get_InfoPathData('Summary_SCP_Type_1',v_CaseId,'ST') || '</typeDesc>' || LF;
  v_Str := v_Str || '   </specialtyCare>'|| LF;
  v_Str := v_Str || '   <sections>' || LF;
  v_Str := v_Str || '        <sectionTitle>UNMET NEEDS PROMPTING CARE MANAGEMENT REFERRAL</sectionTitle>' || LF;
  v_Str := v_Str || '        <groupedQuestions>' || LF;
  v_Str := v_Str || '            <groupTitle>Medical</groupTitle>' || LF;
  v_Str := v_Str || '            <questions>' || LF;
  v_Str := v_Str || '                  <title>COPD</title>' || LF;
  v_Str := v_Str || '                  <value>' || Matrix_Utils.Get_InfoPathData('Summary_COPD',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '            </questions>' || LF;
  v_Str := v_Str || '            <questions>' || LF;
  v_Str := v_Str || '                  <title>Asthma</title>' || LF;
  v_Str := v_Str || '                  <value>' || Matrix_Utils.Get_InfoPathData('Summary_Asthma',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '            </questions>' || LF;
  v_Str := v_Str || '            <questions>' || LF;
  v_Str := v_Str || '                  <title>Cancer</title>' || LF;
  v_Str := v_Str || '                  <value>' || Matrix_Utils.Get_InfoPathData('Summary_Cancer',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '            </questions>' || LF;
  v_Str := v_Str || '            <questions>' || LF;
  v_Str := v_Str || '                  <title>CHF</title>' || LF;
  v_Str := v_Str || '                  <value>' || Matrix_Utils.Get_InfoPathData('Summary_CHF',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '            </questions>' || LF;
  v_Str := v_Str || '            <questions>' || LF;
  v_Str := v_Str || '                  <title>CKD</title>' || LF;
  v_Str := v_Str || '                  <value>' || Matrix_Utils.Get_InfoPathData('Summary_CKD',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '            </questions>' || LF;
  v_Str := v_Str || '            <questions>' || LF;
  v_Str := v_Str || '                  <title>Pain</title>' || LF;
  v_Str := v_Str || '                  <value>' || Matrix_Utils.Get_InfoPathData('Summary_Pain',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '            </questions>' || LF;
  v_Str := v_Str || '            <questions>' || LF;
  v_Str := v_Str || '                  <title>CAD</title>' || LF;
  v_Str := v_Str || '                  <value>' || Matrix_Utils.Get_InfoPathData('Summary_CAD',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '            </questions>' || LF;
  v_Str := v_Str || '            <questions>' || LF;
  v_Str := v_Str || '                  <title>Diabetes</title>' || LF;
  v_Str := v_Str || '                  <value>' || Matrix_Utils.Get_InfoPathData('Summary_Diabetes',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '            </questions>' || LF;
  v_Str := v_Str || '            <questions>' || LF;
  v_Str := v_Str || '                  <title>Weight loss/gain</title>' || LF;
  v_Str := v_Str || '                  <value>' || Matrix_Utils.Get_InfoPathData('Summary_Weight_Loss',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '            </questions>' || LF;
  v_Str := v_Str || '            <questions>' || LF;
  v_Str := v_Str || '                  <title>Co-morbidities not controlled</title>' || LF;
  v_Str := v_Str || '                  <value>' || Matrix_Utils.Get_InfoPathData('Summary_comorbidities',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '            </questions>' || LF;
  v_Str := v_Str || '            <questions>' || LF;
  v_Str := v_Str || '                  <title>Care coordination needed</title>' || LF;
  v_Str := v_Str || '                  <value>' || Matrix_Utils.Get_InfoPathData('Summary_Care',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '            </questions>' || LF;
  v_Str := v_Str || '            <questions>' || LF;
  v_Str := v_Str || '                  <title>Reports physical health worse</title>' || LF;
  v_Str := v_Str || '                  <value>' || Matrix_Utils.Get_InfoPathData('Summary_Reports',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '            </questions>' || LF;
  v_Str := v_Str || '            <questions>' || LF;
  v_Str := v_Str || '                  <title>Goals of care not defined/determined</title>' || LF;
  v_Str := v_Str || '                  <value>' || Matrix_Utils.Get_InfoPathData('Summary_Goals',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '            </questions>' || LF;
  v_Str := v_Str || '            <questions>' || LF;
  v_Str := v_Str || '                  <title>Continues to smoke</title>' || LF;
  v_Str := v_Str || '                  <value>' || Matrix_Utils.Get_InfoPathData('Summary_Continues',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '            </questions>' || LF;
  v_Str := v_Str || '            <questions>' || LF;
  v_Str := v_Str || '                  <title>May be Hospice appropriate</title>' || LF;
  v_Str := v_Str || '                  <value>' || Matrix_Utils.Get_InfoPathData('Summary_Hospice',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '            </questions>' || LF;
  v_Str := v_Str || '            <questions>' || LF;
  v_Str := v_Str || '                  <title>Lacks knowledge about conditions</title>' || LF;
  v_Str := v_Str || '                  <value>' || Matrix_Utils.Get_InfoPathData('Summary_Lacks_Knowledge',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '            </questions>' || LF;
  v_Str := v_Str || '            <questions>' || LF;
  v_Str := v_Str || '                  <title>Other</title>' || LF;
  v_Str := v_Str || '                  <value>' || Matrix_Utils.Get_InfoPathData('Summary_Medical_Other',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '                  <optionalLabel>Describe Other</optionalLabel>' || LF;
  v_Str := v_Str || '                  <optionalValue>' || Matrix_Utils.Get_InfoPathData('Summary_Medical_Other_Box',v_CaseId,'ST') || '</optionalValue>' || LF;
  v_Str := v_Str || '            </questions>' || LF;
  v_Str := v_Str || '        </groupedQuestions>' || LF;
  v_Str := v_Str || '        <groupedQuestions>' || LF;
  v_Str := v_Str || '            <groupTitle>Medications</groupTitle>' || LF;
  v_Str := v_Str || '            <questions>' || LF;
  v_Str := v_Str || '                  <title>>=5 prescription meds</title>' || LF;
  v_Str := v_Str || '                  <value>' || Matrix_Utils.Get_InfoPathData('Summary_Prescriptions',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '            </questions>' || LF;
  v_Str := v_Str || '            <questions>' || LF;
  v_Str := v_Str || '                  <title>Patient unsure of rational, schedule, dosages, red flags</title>' || LF;
  v_Str := v_Str || '                  <value>' || Matrix_Utils.Get_InfoPathData('Summary_PT',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '            </questions>' || LF;
  v_Str := v_Str || '            <questions>' || LF;
  v_Str := v_Str || '                  <title>Multiple medications from multiple physicians</title>' || LF;
  v_Str := v_Str || '                  <value>' || Matrix_Utils.Get_InfoPathData('Summary_Multiple',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '            </questions>' || LF;
  v_Str := v_Str || '            <questions>' || LF;
  v_Str := v_Str || '                  <title>Not tolerating side effects</title>' || LF;
  v_Str := v_Str || '                  <value>' || Matrix_Utils.Get_InfoPathData('Summary_Side_Effects',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '            </questions>' || LF;
  v_Str := v_Str || '            <questions>' || LF;
  v_Str := v_Str || '                  <title>Not taking meds as Rx''d</title>' || LF;
  v_Str := v_Str || '                  <value>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '                  <followUps>' || LF;
  v_Str := v_Str || '                         <title>Oral Hypoglycemics</title>' || LF;
  v_Str := v_Str || '                         <value>' || Matrix_Utils.Get_InfoPathData('Summary_Oral',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '                  </followUps>' || LF;
  v_Str := v_Str || '                  <followUps>' || LF;
  v_Str := v_Str || '                         <title>Statins</title>' || LF;
  v_Str := v_Str || '                         <value>' || Matrix_Utils.Get_InfoPathData('Summary_Statins',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '                  </followUps>' || LF;
  v_Str := v_Str || '                  <followUps>' || LF;
  v_Str := v_Str || '                         <title>Blood Pressure</title>' || LF;
  v_Str := v_Str || '                         <value>' || Matrix_Utils.Get_InfoPathData('Summary_BP',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '                         <followUps>' || LF;
  v_Str := v_Str || '                             <title>ACE/ARB</title>' || LF;
  v_Str := v_Str || '                             <value>' || Matrix_Utils.Get_InfoPathData('Summary_ACE',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '                         </followUps>' || LF;
  v_Str := v_Str || '                  </followUps>' || LF;
  v_Str := v_Str || '            </questions>' || LF;
  v_Str := v_Str || '            <questions>' || LF;
  v_Str := v_Str || '                  <title>Different agent may be better for senior</title>' || LF;
  v_Str := v_Str || '                  <value>' || Matrix_Utils.Get_InfoPathData(' Summary_Agent ',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '                  <optionalLabel></optionalLabel>' || LF;
  v_Str := v_Str || '                  <optionalValue>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</optionalValue>' || LF;
  v_Str := v_Str || '            </questions>' || LF;
  v_Str := v_Str || '        </groupedQuestions>' || LF;
  v_Str := v_Str || '        <groupedQuestions>' || LF;
  v_Str := v_Str || '            <groupTitle>Mental Health</groupTitle>' || LF;
  v_Str := v_Str || '            <questions>' || LF;
  v_Str := v_Str || '                  <title>Depression Scale:</title>' || LF;
  v_Str := v_Str || '                  <value>' || Matrix_Utils.Get_InfoPathData('Summary_Depression',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '                  <optionalLabel>Describe Other</optionalLabel>' || LF;
  v_Str := v_Str || '                  <optionalValue>' || Matrix_Utils.Get_InfoPathData('Summary_Depression_Box',v_CaseId,'ST') || '</optionalValue>' || LF;
  v_Str := v_Str || '            </questions>' || LF;
  v_Str := v_Str || '            <questions>' || LF;
  v_Str := v_Str || '                  <title>Positive ETOH/Drug Screen</title>' || LF;
  v_Str := v_Str || '                  <value>' || Matrix_Utils.Get_InfoPathData('Summary_ETOH',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '            </questions>' || LF;
  v_Str := v_Str || '            <questions>' || LF;
  v_Str := v_Str || '                  <title>Anxiety</title>' || LF;
  v_Str := v_Str || '                  <value>' || Matrix_Utils.Get_InfoPathData('Summary_Anxiety',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '            </questions>' || LF;
  v_Str := v_Str || '            <questions>' || LF;
  v_Str := v_Str || '                  <title>Other</title>' || LF;
  v_Str := v_Str || '                  <value>' || Matrix_Utils.Get_InfoPathData('Summary_MH_Other',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '                  <optionalLabel>Describe Other</optionalLabel>' || LF;
  v_Str := v_Str || '                  <optionalValue>' || Matrix_Utils.Get_InfoPathData('Summary_MH_Other_Box',v_CaseId,'ST') || '</optionalValue>' || LF;
  v_Str := v_Str || '            </questions>' || LF;
  v_Str := v_Str || '            <questions>' || LF;
  v_Str := v_Str || '                  <title>Currently Active</title>' || LF;
  v_Str := v_Str || '                  <value>' || Matrix_Utils.Get_InfoPathData('Summary_Active',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '                  <followUps>' || LF;
  v_Str := v_Str || '                         <title>Currently Active</title>' || LF;
  v_Str := v_Str || '                         <value>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '                  </followUps>' || LF;
  v_Str := v_Str || '            </questions>' || LF;
  v_Str := v_Str || '            <questions>' || LF;
  v_Str := v_Str || '                  <title>Degree of Impairment</title>' || LF;
  v_Str := v_Str || '                  <value>' || Matrix_Utils.Get_InfoPathData('Summary_Impairment',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '                  <followUps>' || LF;
  v_Str := v_Str || '                         <title>Degree of Impairment</title>' || LF;
  v_Str := v_Str || '                         <value>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '                  </followUps>' || LF;
  v_Str := v_Str || '            </questions>' || LF;
  v_Str := v_Str || '            <questions>' || LF;
  v_Str := v_Str || '                  <title>Reports mental health worse</title>' || LF;
  v_Str := v_Str || '                  <value>' || Matrix_Utils.Get_InfoPathData('Summary_MH_Worse',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '            </questions>' || LF;
  v_Str := v_Str || '            <questions>' || LF;
  v_Str := v_Str || '                  <title>Behavioral Health</title>' || LF;
  v_Str := v_Str || '                  <value>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '                  <optionalValue>' || Matrix_Utils.Get_InfoPathData('Summary_Mental_Status_Box',v_CaseId,'ST') || '</optionalValue>' || LF;
  v_Str := v_Str || '            </questions>' || LF;
  v_Str := v_Str || '            <questions>' || LF;
  v_Str := v_Str || '                  <title>Dementia</title>' || LF;
  v_Str := v_Str || '                  <value>' || Matrix_Utils.Get_InfoPathData('Summary_Dementia',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '            </questions>' || LF;
  v_Str := v_Str || '            <questions>' || LF;
  v_Str := v_Str || '                  <title>Confusion</title>' || LF;
  v_Str := v_Str || '                  <value>' || Matrix_Utils.Get_InfoPathData('Summary_Confusion',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '            </questions>' || LF;
  v_Str := v_Str || '            <questions>' || LF;
  v_Str := v_Str || '                  <title>Refuses/has refused assistance</title>' || LF;
  v_Str := v_Str || '                  <value>' || Matrix_Utils.Get_InfoPathData('Summary_Refuses',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '            </questions>' || LF;
  v_Str := v_Str || '        </groupedQuestions>' || LF;
  v_Str := v_Str || '        <groupedQuestions>' || LF;
  v_Str := v_Str || '            <groupTitle>Functional Ability</groupTitle>' || LF;
  v_Str := v_Str || '            <questions>' || LF;
  v_Str := v_Str || '                  <title>Unable to see</title>' || LF;
  v_Str := v_Str || '                  <value>' || Matrix_Utils.Get_InfoPathData('Summary_Unable_to_See',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '            </questions>' || LF;
  v_Str := v_Str || '            <questions>' || LF;
  v_Str := v_Str || '                  <title>Unable to hear</title>' || LF;
  v_Str := v_Str || '                  <value>' || Matrix_Utils.Get_InfoPathData('Summary_Unable_to_Hear',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '            </questions>' || LF;
  v_Str := v_Str || '            <questions>' || LF;
  v_Str := v_Str || '                  <title>Hx of falls/fall risk</title>' || LF;
  v_Str := v_Str || '                  <value>' || Matrix_Utils.Get_InfoPathData('Summary_HX',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '            </questions>' || LF;
  v_Str := v_Str || '            <questions>' || LF;
  v_Str := v_Str || '                  <title>3 or more ADL dependencies</title>' || LF;
  v_Str := v_Str || '                  <value>' || Matrix_Utils.Get_InfoPathData('Summary_ADL',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '            </questions>' || LF;
  v_Str := v_Str || '            <questions>' || LF;
  v_Str := v_Str || '                  <title>Unable prepare/secure food</title>' || LF;
  v_Str := v_Str || '                  <value>' || Matrix_Utils.Get_InfoPathData('Summary_Unable_Food',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '            </questions>' || LF;
  v_Str := v_Str || '            <questions>' || LF;
  v_Str := v_Str || '                  <title>Unable to manage meds</title>' || LF;
  v_Str := v_Str || '                  <value>' || Matrix_Utils.Get_InfoPathData('Summary_Unable_Meds',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '            </questions>' || LF;
  v_Str := v_Str || '            <questions>' || LF;
  v_Str := v_Str || '                  <title>Unable to self-manage</title>' || LF;
  v_Str := v_Str || '                  <value>' || Matrix_Utils.Get_InfoPathData('Summary_Unable_Self_Manage',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '            </questions>' || LF;
  v_Str := v_Str || '            <questions>' || LF;
  v_Str := v_Str || '                  <title>Support</title>' || LF;
  v_Str := v_Str || '                  <followUps>' || LF;
  v_Str := v_Str || '                         <title>Caregiver availability</title>' || LF;
  v_Str := v_Str || '                         <value>' || Matrix_Utils.Get_InfoPathData('Summary_Caregiver_Availability',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '                  </followUps>' || LF;
  v_Str := v_Str || '                  <followUps>' || LF;
  v_Str := v_Str || '                         <title>Caregiver capability</title>' || LF;
  v_Str := v_Str || '                         <value>' || Matrix_Utils.Get_InfoPathData('Summary_Caregiver_Capability',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '                  </followUps>' || LF;
  v_Str := v_Str || '                  <followUps>' || LF;
  v_Str := v_Str || '                         <title>Lack of family support</title>' || LF;
  v_Str := v_Str || '                         <value>' || Matrix_Utils.Get_InfoPathData('Summary_Lack_Support',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '                  </followUps>' || LF;
  v_Str := v_Str || '                  <followUps>' || LF;
  v_Str := v_Str || '                         <title>Social isolation</title>' || LF;
  v_Str := v_Str || '                         <value>' || Matrix_Utils.Get_InfoPathData('Summary_Social_Isolation',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '                  </followUps>' || LF;
  v_Str := v_Str || '            </questions>' || LF;
  v_Str := v_Str || '            <questions>' || LF;
  v_Str := v_Str || '                  <title>Other</title>' || LF;
  v_Str := v_Str || '                  <followUps>' || LF;
  v_Str := v_Str || '                         <title>Financial instability</title>' || LF;
  v_Str := v_Str || '                         <value>' || Matrix_Utils.Get_InfoPathData('Summary_Financial_Instability',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '                         <followUps>'|| LF;
  v_Str := v_Str || '                           <title>Unable to afford medication</title>' || LF;
  v_Str := v_Str || '                           <value>' || Matrix_Utils.Get_InfoPathData('Summary_Unable_Medication',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '                         </followUps>' || LF;
  v_Str := v_Str || '                  </followUps>' || LF;
  v_Str := v_Str || '                  <followUps>' || LF;
  v_Str := v_Str || '                         <title>Housing instability</title>' || LF;
  v_Str := v_Str || '                         <value>' || Matrix_Utils.Get_InfoPathData('Summary_Housing_Instability',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '                  </followUps>' || LF;
  v_Str := v_Str || '                  <followUps>' || LF;
  v_Str := v_Str || '                         <title>Transportation challenges</title>' || LF;
  v_Str := v_Str || '                         <value>' || Matrix_Utils.Get_InfoPathData('Summary_Transportation',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '                  </followUps>' || LF;
  v_Str := v_Str || '            </questions>' || LF;
  v_Str := v_Str || '        </groupedQuestions>' || LF;
  v_Str := v_Str || '        <groupedQuestions>' || LF;
  v_Str := v_Str || '            <groupTitle>Utilization</groupTitle>' || LF;
  v_Str := v_Str || '            <questions>' || LF;
  v_Str := v_Str || '                  <title>Poor PCP access</title>' || LF;
  v_Str := v_Str || '                  <value>' || Matrix_Utils.Get_InfoPathData('Summary_Poor_PCP',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '            </questions>' || LF;
  v_Str := v_Str || '            <questions>' || LF;
  v_Str := v_Str || '                  <title>>=3 ER visits in last 3 months</title>' || LF;
  v_Str := v_Str || '                  <value>' || Matrix_Utils.Get_InfoPathData('Summary_ER',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '                  <followUps>' || LF;
  v_Str := v_Str || '                         <title>Reason:</title>' || LF;
  v_Str := v_Str || '                         <value>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '                         <optionalLabel>Reason:</optionalLabel>' || LF;
  v_Str := v_Str || '                         <optionalValue>' || Matrix_Utils.Get_InfoPathData('Summary_ER_Visit_1',v_CaseId,'ST') || '</optionalValue>' || LF;
  v_Str := v_Str || '                  </followUps>' || LF;
  v_Str := v_Str || '                  <followUps>' || LF;
  v_Str := v_Str || '                         <title>Reason:</title>' || LF;
  v_Str := v_Str || '                         <value>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '                         <optionalLabel>Reason:</optionalLabel>' || LF;
  v_Str := v_Str || '                         <optionalValue>' || Matrix_Utils.Get_InfoPathData('Summary_ER_Visit_2',v_CaseId,'ST') || '</optionalValue>' || LF;
  v_Str := v_Str || '                  </followUps>' || LF;
  v_Str := v_Str || '            </questions>' || LF;
  v_Str := v_Str || '            <questions>' || LF;
  v_Str := v_Str || '                  <title>>=2 IP stay last 6 months</title>' || LF;
  v_Str := v_Str || '                  <value>' || Matrix_Utils.Get_InfoPathData('Summary_IP',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '                  <followUps>' || LF;
  v_Str := v_Str || '                         <title>Reason:</title>' || LF;
  v_Str := v_Str || '                         <value>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '                         <optionalLabel>Reason:</optionalLabel>' || LF;
  v_Str := v_Str || '                         <optionalValue>' || Matrix_Utils.Get_InfoPathData('Summary_IP_Visit_1',v_CaseId,'ST') || '</optionalValue>' || LF;
  v_Str := v_Str || '                  </followUps>' || LF;
  v_Str := v_Str || '                  <followUps>' || LF;
  v_Str := v_Str || '                         <title>Reason:</title>' || LF;
  v_Str := v_Str || '                         <value>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '                         <optionalLabel>Reason:</optionalLabel>' || LF;
  v_Str := v_Str || '                         <optionalValue>' || Matrix_Utils.Get_InfoPathData('Summary_IP_Visit_2',v_CaseId,'ST') || '</optionalValue>' || LF;
  v_Str := v_Str || '                  </followUps>' || LF;
  v_Str := v_Str || '            </questions>' || LF;
  v_Str := v_Str || '            <questions>' || LF;
  v_Str := v_Str || '                  <title>Rehab discharge last 30 days</title>' || LF;
  v_Str := v_Str || '                  <value>' || Matrix_Utils.Get_InfoPathData('Summary_Rehab_Discharge',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '            </questions>' || LF;
  v_Str := v_Str || '        </groupedQuestions>' || LF;
  v_Str := v_Str || '    </sections>' || LF;
  v_Str := v_Str || '    <sections>' || LF;
  v_Str := v_Str || '        <sectionTitle>ADDITIONAL ACTIVITY</sectionTitle>' || LF;
  v_Str := v_Str || '        <groupedQuestions>' || LF;
  v_Str := v_Str || '            <groupTitle>Education/Counseling Provided</groupTitle>' || LF;
  v_Str := v_Str || '            <questions>' || LF;
  v_Str := v_Str || '                  <title>Disease/Condition</title>' || LF;
  v_Str := v_Str || '                  <value>' || Matrix_Utils.Get_InfoPathData('Summary_Disease',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '                  <optionalLabel>Specify:</optionalLabel>' || LF;
  v_Str := v_Str || '                  <optionalValue>' || Matrix_Utils.Get_InfoPathData('Summary_Disease_Box',v_CaseId,'ST') || '</optionalValue>' || LF;
  v_Str := v_Str || '            </questions>' || LF;
  v_Str := v_Str || '            <questions>' || LF;
  v_Str := v_Str || '                  <title>Medication</title>' || LF;
  v_Str := v_Str || '                  <value>' || Matrix_Utils.Get_InfoPathData('Summary_Medication',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '            </questions>' || LF;
  v_Str := v_Str || '            <questions>' || LF;
  v_Str := v_Str || '                  <title>Preventative Services Schedule</title>' || LF;
  v_Str := v_Str || '                  <value>' || Matrix_Utils.Get_InfoPathData('Summary_PSS',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '            </questions>' || LF;
  v_Str := v_Str || '            <questions>' || LF;
  v_Str := v_Str || '                  <title>Risk Reduction</title>' || LF;
  v_Str := v_Str || '                  <value>' || Matrix_Utils.Get_InfoPathData('Summary_Risk',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '                  <followUps>' || LF;
  v_Str := v_Str || '                         <title>Falls</title>' || LF;
  v_Str := v_Str || '                         <value>' || Matrix_Utils.Get_InfoPathData('Summary_Falls',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '                  </followUps>' || LF;
  v_Str := v_Str || '                  <followUps>' || LF;
  v_Str := v_Str || '                         <title>Smoking/ETOH</title>' || LF;
  v_Str := v_Str || '                         <value>' || Matrix_Utils.Get_InfoPathData('Summary_Smoking',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '                  </followUps>' || LF;
  v_Str := v_Str || '                  <followUps>' || LF;
  v_Str := v_Str || '                         <title>Home Safety</title>' || LF;
  v_Str := v_Str || '                         <value>' || Matrix_Utils.Get_InfoPathData('Summary_Home_Safety',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '                         <optionalLabel>Specify:</optionalLabel>' || LF;
  v_Str := v_Str || '                         <optionalValue>' || Matrix_Utils.Get_InfoPathData('Summary_Home_Safety_Box',v_CaseId,'ST') || '</optionalValue>' || LF;
  v_Str := v_Str || '                  </followUps>' || LF;
  v_Str := v_Str || '                  <followUps>' || LF;
  v_Str := v_Str || '                         <title>Other</title>' || LF;
  v_Str := v_Str || '                         <value>' || Matrix_Utils.Get_InfoPathData('Summary_Education_Other',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '                         <optionalLabel>Specify:</optionalLabel>' || LF;
  v_Str := v_Str || '                         <optionalValue>' || Matrix_Utils.Get_InfoPathData('Summary_Education_Other_Box',v_CaseId,'ST') || '</optionalValue>' || LF;
  v_Str := v_Str || '                  </followUps>' || LF;
  v_Str := v_Str || '            </questions>' || LF;
  v_Str := v_Str || '            <questions>' || LF;
  v_Str := v_Str || '                  <title>Wellness</title>' || LF;
  v_Str := v_Str || '                  <value>' || Matrix_Utils.Get_InfoPathData('Summary_Wellness',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '                  <followUps>' || LF;
  v_Str := v_Str || '                         <title>Physical Activity</title>' || LF;
  v_Str := v_Str || '                         <value>' || Matrix_Utils.Get_InfoPathData('Summary_Physical_Activity',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '                  </followUps>' || LF;
  v_Str := v_Str || '                  <followUps>' || LF;
  v_Str := v_Str || '                         <title>Nutrition</title>' || LF;
  v_Str := v_Str || '                         <value>' || Matrix_Utils.Get_InfoPathData('Summary_Nutrition',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '                  </followUps>' || LF;
  v_Str := v_Str || '                  <followUps>' || LF;
  v_Str := v_Str || '                         <title>Bladder Control</title>' || LF;
  v_Str := v_Str || '                         <value>' || Matrix_Utils.Get_InfoPathData('Summary_Bladder_Control',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '                  </followUps>' || LF;
  v_Str := v_Str || '            </questions>' || LF;
  v_Str := v_Str || '        </groupedQuestions>' || LF;
  v_Str := v_Str || '        <groupedQuestions>' || LF;
  v_Str := v_Str || '            <groupTitle>PCP Communication</groupTitle>' || LF;
  v_Str := v_Str || '            <questions>' || LF;
  v_Str := v_Str || '                  <title>Spoke with</title>' || LF;
  v_Str := v_Str || '                  <value>' || Matrix_Utils.Get_InfoPathData('Summary_Spoke_With',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '                  <followUps>' || LF;
  v_Str := v_Str || '                         <title>Spoke with</title>' || LF;
  v_Str := v_Str || '                         <value>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '                  </followUps>' || LF;
  v_Str := v_Str || '                  <followUps>' || LF;
  v_Str := v_Str || '                         <title>Spoke with</title>' || LF;
  v_Str := v_Str || '                         <value>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '                         <optionalValue>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</optionalValue>' || LF;
  v_Str := v_Str || '                  </followUps>' || LF;
  v_Str := v_Str || '            </questions>' || LF;
  v_Str := v_Str || '            <questions>' || LF;
  v_Str := v_Str || '                  <title>Left Message</title>' || LF;
  v_Str := v_Str || '                  <value>' || Matrix_Utils.Get_InfoPathData('Summary_Left_Message',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '                  <followUps>' || LF;
  v_Str := v_Str || '                         <title>Date</title>' || LF;
  v_Str := v_Str || '                         <value>' || Matrix_Utils.Get_InfoPathData('Summary_Left_Message_date',v_CaseId,'DT') || '</value>' || LF;
  v_Str := v_Str || '                  </followUps>' || LF;
  v_Str := v_Str || '                  <followUps>' || LF;
  v_Str := v_Str || '                         <title>Name</title>' || LF;
  v_Str := v_Str || '                         <value>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '                         <optionalValue>' || Matrix_Utils.Get_InfoPathData('Summary_Name_Box',v_CaseId,'ST') || '</optionalValue>' || LF;
  v_Str := v_Str || '                  </followUps>' || LF;
  v_Str := v_Str || '            </questions>' || LF;
  v_Str := v_Str || '            <questions>' || LF;
  v_Str := v_Str || '                  <title>Medications</title>' || LF;
  v_Str := v_Str || '                  <value>' || Matrix_Utils.Get_InfoPathData('Summary_Medications_PCP',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '                  <followUps>' || LF;
  v_Str := v_Str || '                         <title>Side effects</title>' || LF;
  v_Str := v_Str || '                         <value>' || Matrix_Utils.Get_InfoPathData('Summary_PCP_Side_Effects',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '                  </followUps>' || LF;
  v_Str := v_Str || '                  <followUps>' || LF;
  v_Str := v_Str || '                         <title>Dosage related</title>' || LF;
  v_Str := v_Str || '                         <value>' || Matrix_Utils.Get_InfoPathData('Summary_Dosage',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '                  </followUps>' || LF;
  v_Str := v_Str || '                  <followUps>' || LF;
  v_Str := v_Str || '                         <title>Non-compliance</title>' || LF;
  v_Str := v_Str || '                         <value>' || Matrix_Utils.Get_InfoPathData('Summary_Non_Compliance',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '                  </followUps>' || LF;
  v_Str := v_Str || '            </questions>' || LF;
  v_Str := v_Str || '            <questions>' || LF;
  v_Str := v_Str || '                  <title>Symptoms/Positive Screens</title>' || LF;
  v_Str := v_Str || '                  <value>' || Matrix_Utils.Get_InfoPathData('Summary_Symptoms',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '                  <optionalLabel>Specify:</optionalLabel>' || LF;
  v_Str := v_Str || '                  <optionalValue>' || Matrix_Utils.Get_InfoPathData('Summary_Specify_Box',v_CaseId,'ST') || '</optionalValue>' || LF;
  v_Str := v_Str || '            </questions>' || LF;
  v_Str := v_Str || '            <questions>' || LF;
  v_Str := v_Str || '                  <title>Tests, Vaccines, Screens</title>' || LF;
  v_Str := v_Str || '                  <value>' || Matrix_Utils.Get_InfoPathData('Summary_Tests',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '                  <followUps>' || LF;
  v_Str := v_Str || '                         <title>Cholesterol</title>' || LF;
  v_Str := v_Str || '                         <value>' || Matrix_Utils.Get_InfoPathData('Summary_Cholesterol',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '                  </followUps>' || LF;
  v_Str := v_Str || '                  <followUps>' || LF;
  v_Str := v_Str || '                         <title>Colorect</title>' || LF;
  v_Str := v_Str || '                         <value>' || Matrix_Utils.Get_InfoPathData('Summary_Colorect',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '                  </followUps>' || LF;
  v_Str := v_Str || '                  <followUps>' || LF;
  v_Str := v_Str || '                         <title>Mamm</title>' || LF;
  v_Str := v_Str || '                         <value>' || Matrix_Utils.Get_InfoPathData('Summary_Mamm',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '                  </followUps>' || LF;
  v_Str := v_Str || '                  <followUps>' || LF;
  v_Str := v_Str || '                         <title>Flu/pneumo</title>' || LF;
  v_Str := v_Str || '                         <value>' || Matrix_Utils.Get_InfoPathData('Summary_Flu',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '                  </followUps>' || LF;
  v_Str := v_Str || '                  <followUps>' || LF;
  v_Str := v_Str || '                         <title>Other</title>' || LF;
  v_Str := v_Str || '                         <value>' || Matrix_Utils.Get_InfoPathData('Summary_PCP_Other',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '                         <optionalLabel>Specify Other:</optionalLabel>' || LF;
  v_Str := v_Str || '                         <optionalValue>' || Matrix_Utils.Get_InfoPathData('Summary_PCP_Other_Box',v_CaseId,'ST') || '</optionalValue>' || LF;
  v_Str := v_Str || '                  </followUps>' || LF;
  v_Str := v_Str || '            </questions>' || LF;
  v_Str := v_Str || '            <questions>' || LF;
  v_Str := v_Str || '                  <title>Outcome</title>' || LF;
  v_Str := v_Str || '                  <value>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '                  <followUps>' || LF;
  v_Str := v_Str || '                         <title>Will see patient</title>' || LF;
  v_Str := v_Str || '                         <value>' || Matrix_Utils.Get_InfoPathData('Summary_See_Patient',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '                  </followUps>' || LF;
  v_Str := v_Str || '                  <followUps>' || LF;
  v_Str := v_Str || '                         <title>Will call patient</title>' || LF;
  v_Str := v_Str || '                         <value>' || Matrix_Utils.Get_InfoPathData('Summary_Call_Patient',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '                  </followUps>' || LF;
  v_Str := v_Str || '                  <followUps>' || LF;
  v_Str := v_Str || '                         <title>Will generate referral</title>' || LF;
  v_Str := v_Str || '                         <value>' || Matrix_Utils.Get_InfoPathData('Summary_Referral',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '                         <followUps>' || LF;
  v_Str := v_Str || '                           <title>Spec</title>' || LF;
  v_Str := v_Str || '                           <value>' || Matrix_Utils.Get_InfoPathData('Summary_Spec',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '                         </followUps>' || LF;
  v_Str := v_Str || '                         <followUps>'|| LF;
  v_Str := v_Str || '                           <title>SW</title>' || LF;
  v_Str := v_Str || '                           <value>' || Matrix_Utils.Get_InfoPathData('Summary_SW',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '                         </followUps>' || LF;
  v_Str := v_Str || '                         <followUps>' || LF;
  v_Str := v_Str || '                           <title>PT</title>' || LF;
  v_Str := v_Str || '                           <value>' || Matrix_Utils.Get_InfoPathData('Summary_Outcome_PT',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '                         </followUps>' || LF;
  v_Str := v_Str || '                         <followUps>' || LF;
  v_Str := v_Str || '                           <title>HH</title>' || LF;
  v_Str := v_Str || '                           <value>' || Matrix_Utils.Get_InfoPathData('Summary_HH',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '                         </followUps>' || LF;
  v_Str := v_Str || '                  </followUps>' || LF;
  v_Str := v_Str || '            </questions>' || LF;
  v_Str := v_Str || '        </groupedQuestions>' || LF;
  v_Str := v_Str || '        <groupedQuestions>' || LF;
  v_Str := v_Str || '            <groupTitle>NP Directed Referral(s)</groupTitle>' || LF;
  v_Str := v_Str || '            <questions>' || LF;
  v_Str := v_Str || '                  <title>Emergent Medical Needs</title>' || LF;
  v_Str := v_Str || '                  <value>' || Matrix_Utils.Get_InfoPathData('Summary_Medical_Need',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '                  <followUps>' || LF;
  v_Str := v_Str || '                         <title>911 Called</title>' || LF;
  v_Str := v_Str || '                         <value>' || Matrix_Utils.Get_InfoPathData('Summary_911',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '                  </followUps>' || LF;
  v_Str := v_Str || '                  <followUps>' || LF;
  v_Str := v_Str || '                         <title>Other Transport</title>' || LF;
  v_Str := v_Str || '                         <value>' || Matrix_Utils.Get_InfoPathData('Summary_Other_Transport',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '                  </followUps>' || LF;
  v_Str := v_Str || '                  <followUps>' || LF;
  v_Str := v_Str || '                         <title>PCP Notified</title>' || LF;
  v_Str := v_Str || '                         <value>' || Matrix_Utils.Get_InfoPathData('Summary_Notified',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '                  </followUps>' || LF;
--MG--Add "Summary_Notified_Box" as the value below <optionalvalue> 
  v_Str := v_Str || '                  <optionalValue>' || Matrix_Utils.Get_InfoPathData('Summary_Notified_Box',v_CaseId,'ST') || '</optionalValue>' || LF;
  v_Str := v_Str || '            </questions>' || LF;
  v_Str := v_Str || '            <questions>' || LF;
  v_Str := v_Str || '                  <title>Reason</title>' || LF;
--MG--Replace "Summary_Notified_Box" with "Summary_Cust_Serv_Referral"
  v_Str := v_Str || '                  <value>' || Matrix_Utils.Get_InfoPathData('Summary_Cust_Serv_Referral',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '            </questions>' || LF;
  v_Str := v_Str || '            <questions>' || LF;
  v_Str := v_Str || '                  <title>Linkages to Community Based Services</title>' || LF;
  v_Str := v_Str || '                  <value>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '                  <followUps>' || LF;
  v_Str := v_Str || '                         <title>Meals on Wheels</title>' || LF;
  v_Str := v_Str || '                         <value>' || Matrix_Utils.Get_InfoPathData('Summary_Meals',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '                  </followUps>' || LF;
  v_Str := v_Str || '                  <followUps>' || LF;
  v_Str := v_Str || '                         <title>Local agency for aging</title>' || LF;
  v_Str := v_Str || '                         <value>' || Matrix_Utils.Get_InfoPathData('Summary_Agency',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '                  </followUps>' || LF;
  v_Str := v_Str || '                  <followUps>' || LF;
  v_Str := v_Str || '                         <title>Services for low income seniors</title>' || LF;
  v_Str := v_Str || '                         <value>' || Matrix_Utils.Get_InfoPathData('Summary_Seniors',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '                  </followUps>' || LF;
  v_Str := v_Str || '            </questions>' || LF;
  v_Str := v_Str || '            <questions>' || LF;
  v_Str := v_Str || '                  <title>Linkages to Advocacy Services</title>' || LF;
  v_Str := v_Str || '                  <value>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '                  <followUps>' || LF;
  v_Str := v_Str || '                         <title>Adult Protective Services</title>' || LF;
  v_Str := v_Str || '                         <value>' || Matrix_Utils.Get_InfoPathData('Summary_APS',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '                  </followUps>' || LF;
  v_Str := v_Str || '            </questions>' || LF;
  v_Str := v_Str || '        </groupedQuestions>' || LF;
  v_Str := v_Str || '    </sections>' || LF;
  v_Str := v_Str || '</ManagementReferral>' || LF;
  ------------------------------------
  RETURN v_Str;
EXCEPTION
WHEN OTHERS THEN
  v_Str := SUBSTR(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || CHR(13) || SQLERRM,1,4000);
  RAISE;
END MATRIX_XML_MGMTREFER;

FUNCTION MATRIX_XML_NUTRIDIAG(
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
  v_Str := v_Str || '<NutritionalDiagnosis>' || LF;
  
  /**
  v_Str := v_Str || '   <diagnosis>' || LF;
  v_Str := v_Str || '        <label>Obesity</label>' || LF;
  v_Str := v_Str || '        <title>if BMI &gt; 30 kg/m2</title>' || LF;
  v_Str := v_Str || '        <value>' || Matrix_Utils.Get_InfoPathData('Lab_Data_Obesity',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '        <followupQuestions>'|| LF;
  v_Str := v_Str || '            <title>BMI</title>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('Lab_Data_Obesity_BMI',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </followupQuestions>'|| LF; 
  v_Str := v_Str || '   </diagnosis>'|| LF;
  **/
  
  v_Str := v_Str || '   <diagnosis>' || LF;
  v_Str := v_Str || '        <label>Obesity</label>' || LF;
  v_Str := v_Str || '        <title>if BMI &gt; 30 kg/m2</title>' || LF;
  v_Str := v_Str || '        <value>' || Matrix_Utils.Get_InfoPathData('Lab_Data_Obesity',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '   </diagnosis>'|| LF;
  
--  v_Str := v_Str || '   <diagnosis>' || LF;
--  v_Str := v_Str || '        <label>Obesity</label>' || LF;
--  v_Str := v_Str || '        <title>BMI</title>' || LF;
--  v_Str := v_Str || '        <value>' || Matrix_Utils.Get_InfoPathData('Lab_Data_Obesity_BMI',v_CaseId,'INT-999') || '</value>' || LF;
--  v_Str := v_Str || '   </diagnosis>'|| LF;
  
  
  v_Str := v_Str || '   <diagnosis>'|| LF;
  v_Str := v_Str || '        <label>Morbid obesity</label>' || LF;
  v_Str := v_Str || '        <title>if BMI if &gt; 39 kg/m2)</title>' || LF;
  v_Str := v_Str || '        <value>' || Matrix_Utils.Get_InfoPathData('Lab_Data_Morbid_Obesity',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '   </diagnosis>'|| LF;

--  v_Str := v_Str || '        <followupQuestions>'|| LF;
--  v_Str := v_Str || '            <title>BMI</title>' || LF;
--  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('Lab_Data_Morbid_Obesity_BMI_Box',v_CaseId,'INT-999') || '</value>' || LF;
--  v_Str := v_Str || '        </followupQuestions>'|| LF; 
--  v_Str := v_Str || '   </diagnosis>'|| LF;
  
  v_Str := v_Str || '   <diagnosis>'|| LF;
  v_Str := v_Str || '        <label>Serum Albumin:</label>' || LF;
  v_Str := v_Str || '        <title>Malnutrition (mild to moderate) (BMI &lt;= 18.5 with albumin &amp;lt; 3.5g/dl and unintentional weight loss &gt; 10% in past 6 months.)</title>' || LF;
  v_Str := v_Str || '        <value>' || Matrix_Utils.Get_InfoPathData('Lab_Data_Malnutrition',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '   </diagnosis>'|| LF;

/***  
  v_Str := v_Str || '        <followupQuestions>'|| LF;
  v_Str := v_Str || '            <title>Most recent serum Albumin</title>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('Lab_Data_Malnutrition_Mild_Serum_Albumin',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '            <units>g/dl</units>' || LF;
  v_Str := v_Str || '        </followupQuestions>'|| LF; 
  v_Str := v_Str || '        <managementPlan>' || Matrix_Utils.Get_InfoPathData('Lab_Data_Plan_E1 +Lab_Data_Plan_E2 +Lab_Data_Plan_E3 +Lab_Data_Plan_E4 +Lab_Data_Plan_E5 +Lab_Data_Plan_M1 +Lab_Data_Plan_M2 +Lab_Data_Plan_M3 +Lab_Data_Plan_R1 +Lab_Data_Plan_R2',
                              v_CaseId,'MP') || '</managementPlan>' || LF;
  v_Str := v_Str || '   </diagnosis>'|| LF;  
 ***/ 
  
  v_Str := v_Str || '   <diagnosis>'|| LF;
  v_Str := v_Str || '        <label>Serum Albumin:</label>' || LF;
  v_Str := v_Str || '        <title>Malnutrition (severe) BMI &lt;= 17.5 with documented poor calorie intake, weakness, debilitation, and signs of cachexia or severe muscle wasting on exam.)</title>' || LF;
  v_Str := v_Str || '        <value>' || Matrix_Utils.Get_InfoPathData('Lab_Data_Malnutrition_Severe',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '   </diagnosis>'|| LF;
 /** 
  v_Str := v_Str || '   <managementPlan>' || Matrix_Utils.Get_InfoPathData('Lab_Data_Plan_E1 
  +Lab_Data_Plan_E2 
  +Lab_Data_Plan_E3 
  +Lab_Data_Plan_E4 
  +Lab_Data_Plan_E5 
  +Lab_Data_Plan_M1 
  +Lab_Data_Plan_M2 
  +Lab_Data_Plan_M3 
  +Lab_Data_Plan_R1 
  +Lab_Data_Plan_R2',v_CaseId,'MPT') || '</managementPlan>' || LF;
 **/ 
 -- v_Str := v_Str || '   </diagnosis>'|| LF;



  v_Str := v_Str || '</NutritionalDiagnosis>' || LF;
  ------------------------------------
  RETURN v_Str;
EXCEPTION
WHEN OTHERS THEN
  v_Str := SUBSTR(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || CHR(13) || SQLERRM,1,4000);
  RAISE;
END MATRIX_XML_NUTRIDIAG;FUNCTION MATRIX_XML_NUTRIHEALTH(
    P_CASEID NUMBER ,
    P_LF     VARCHAR2 )
  -- Created 10-6-2012 R Benzell
  -- called by GEN_MATRIX_XML
  -- Edited and completed 10-8-12 Denis
  RETURN CLOB
IS
  v_Str CLOB;
  v_CaseId NUMBER;
  LF       VARCHAR2(5);
BEGIN
  v_CaseId := P_CaseId;
  LF       := P_LF;
  -----------------------------------
  v_Str := v_Str || '<NutritionalHealth>' || LF;
  v_Str := v_Str || '   <total>' || Matrix_Utils.Get_InfoPathData('Nutri_Check_Score',v_CaseId,'INT-999') || '</total>' || LF;
--  v_Str := v_Str || '   <NutritionalRisk>' || Matrix_Utils.Get_InfoPathData('Nutri_Check_Risk_High+Nutri_Check_Risk_Low+Nutri_Check_Risk_Moderate'
--         ,v_CaseId,'MP') || '</NutritionalRisk>' || LF;

  v_Str := v_Str || '   <questions>' || LF;
  v_Str := v_Str || '        <title>Nutrional Risk</title>' || LF;
  v_Str := v_Str || '        <value>' || Matrix_Utils.Get_InfoPathData('Nutri_Check_Risk_High+Nutri_Check_Risk_Low+Nutri_Check_Risk_Moderate'
                  ,v_CaseId,'MP') || '</value>' || LF;
  v_Str := v_Str || '   </questions>' || LF;

  v_Str := v_Str || '   <questions>' || LF;
  v_Str := v_Str || '        <title>Changed food due to illness or condition</title>' || LF;
  v_Str := v_Str || '        <value>' || Matrix_Utils.Get_InfoPathData('Nutri_Check_Ill_No+Nutri_Check_Ill_Yes',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '   </questions>' || LF;
  v_Str := v_Str || '   <questions>' || LF;
  v_Str := v_Str || '        <title>Eat fewer than 2 meals per day</title>' || LF;
  v_Str := v_Str || '        <value>' || Matrix_Utils.Get_InfoPathData('Nutri_Check_Meals_No+Nutri_Check_Meals_Yes',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '   </questions>' || LF;
  v_Str := v_Str || '   <questions>' || LF;
  v_Str := v_Str || '        <title>Eat few fruits, veggies, or milk products</title>' || LF;
  v_Str := v_Str || '        <value>' || Matrix_Utils.Get_InfoPathData('Nutri_Check_Few_No+ Nutri_Check_Few_Yes',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '   </questions>' || LF;
  v_Str := v_Str || '   <questions>' || LF;
  v_Str := v_Str || '        <title>3 or more drinks of beer, liquor, wine daily</title>' || LF;
  v_Str := v_Str || '        <value>' || Matrix_Utils.Get_InfoPathData('Nutri_Check_Drinks_No+Nutri_Check_Drinks_Yes',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '   </questions>' || LF;
  v_Str := v_Str || '   <questions>' || LF;
  v_Str := v_Str || '        <title>Tooth or mouth problem</title>' || LF;
  v_Str := v_Str || '        <value>' || Matrix_Utils.Get_InfoPathData('Nutri_Check_Tooth_No+Nutri_Check_Tooth_Yes',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '   </questions>' || LF;
  v_Str := v_Str || '   <questions>' || LF;
  v_Str := v_Str || '        <title>Not enough money to buy food</title>' || LF;
  v_Str := v_Str || '        <value>' || Matrix_Utils.Get_InfoPathData('Nutri_Check_Money_No+Nutri_Check_Money_Yes',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '   </questions>' || LF;
  v_Str := v_Str || '   <questions>' || LF;
  v_Str := v_Str || '        <title>Eat alone</title>' || LF;
  v_Str := v_Str || '        <value>' || Matrix_Utils.Get_InfoPathData('Nutri_Check_Alone_No+Nutri_Check_Alone_Yes',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '   </questions>' || LF;
  v_Str := v_Str || '   <questions>' || LF;
  v_Str := v_Str || '        <title>3 or more drugs per day</title>' || LF;
  v_Str := v_Str || '        <value>' || Matrix_Utils.Get_InfoPathData('Nutri_Check_Drugs_No+Nutri_Check_Drugs_Yes',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '   </questions>' || LF;
  
  v_Str := v_Str || '   <questions>' || LF;
  v_Str := v_Str || '        <title>Weight Change of 10 lbs in 6 months</title>' || LF;
  v_Str := v_Str || '        <value>' || Matrix_Utils.Get_InfoPathData('Nutri_Check_Weight_Change_No+Nutri_Check_Weight_Change_Yes',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '   </questions>' || LF;
  
  v_Str := v_Str || '   <questions>' || LF;
  v_Str := v_Str || '        <title>Weight Change of 10 lbs in 6 months</title>' || LF;
  v_Str := v_Str || '        <value>' || Matrix_Utils.Get_InfoPathData('Nutri_Check_Weight_Change_No+Nutri_Check_Weight_Change_Yes+',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '   </questions>' || LF;
  
  v_Str := v_Str || '   <questions>' || LF;
  v_Str := v_Str || '        <title>Weight Gain or Loss?</title>' || LF;
  v_Str := v_Str || '        <value>' || Matrix_Utils.Get_InfoPathData('Nutri_Check_Weight_Gain+Nutri_Check_Weight_Loss',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '   </questions>' || LF;
  
  v_Str := v_Str || '   <questions>' || LF;
  v_Str := v_Str || '        <title>Weight Change Intentional</title>' || LF;
  v_Str := v_Str || '        <value>' || Matrix_Utils.Get_InfoPathData('Nutri_Check_Weight_Intentional_Yes+Nutri_Check_Weight_Intentional_No',v_CaseId,'YN') || '</value>' || LF;
  v_Str := v_Str || '   </questions>' || LF;
    
  v_Str := v_Str || '   <questions>' || LF;
  v_Str := v_Str || '        <title>Not always able to shop, cook or feed themselves</title>' || LF;
  v_Str := v_Str || '        <value>' || Matrix_Utils.Get_InfoPathData('Nutri_Check_Shop_No+ Nutri_Check_Shop_Yes',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '   </questions>' || LF;
  v_Str := v_Str || '</NutritionalHealth>' || LF;
  ------------------------------------
  RETURN v_Str;
EXCEPTION
WHEN OTHERS THEN
  v_Str := SUBSTR(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || CHR(13) || SQLERRM,1,4000);
  RAISE;
END MATRIX_XML_NUTRIHEALTH;

FUNCTION MATRIX_XML_PATIENTINFO(
    P_CASEID NUMBER ,
    P_LF     VARCHAR2 )
  -- Created 10-6-2012 R Benzell
  -- called by ClientXMLgenerator
  -- Updated
  -- 10-13-2011 R Benzell
  -- to Test:  select XMLTEST1(1884) from dual
  RETURN CLOB
IS
  v_Str CLOB;
  v_CaseId NUMBER;
  LF       VARCHAR2(5);
BEGIN
  v_CaseId := P_CaseId;
  LF       := P_LF;
  -----------------------------------
  
--MG--  
  
  
  v_Str := v_Str || '<PatientInfo>' || LF;
  v_Str := v_Str || '   <patient>' || LF;
  v_Str := v_Str || '        <patientId>' || Matrix_Utils.Get_InfoPathData('Patient_ID',v_CaseId,'ST') || '</patientId>' || LF;
   -- The payer-supplied HICN for the patient.  Synonym for PatientId
  v_Str := v_Str || '        <hicn>' ||     Matrix_Utils.Get_InfoPathData('Patient_ID',v_CaseId,'ST') || '</hicn>' || LF;
   
  v_Str := v_Str || '        <firstName>' || Matrix_Utils.Get_InfoPathData('Patient_First_Name',v_CaseId,'ST') || '</firstName>' || LF;
  v_Str := v_Str || '        <lastName>' || Matrix_Utils.Get_InfoPathData('Patient_Last_Name',v_CaseId,'ST') || '</lastName>' || LF;
  v_Str := v_Str || '        <phone>' || Matrix_Utils.Get_InfoPathData('Summary_Member_Phone',v_CaseId,'ST') || '</phone>' || LF;
  v_Str := v_Str || '        <address>' || LF;
  v_Str := v_Str || '            <address1>' || Matrix_Utils.Get_InfoPathData('Summary_Member_Address',v_CaseId,'ST') || '</address1>' || LF;
  --v_Str := v_Str || '            <address2>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</address2>' || LF;
  v_Str := v_Str || '            <city>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</city>' || LF;
  v_Str := v_Str || '            <country>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</country>' || LF;
  v_Str := v_Str || '            <state>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</state>' || LF;
  v_Str := v_Str || '            <suite>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</suite>' || LF;
  v_Str := v_Str || '            <zipCode>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</zipCode>' || LF;
  v_Str := v_Str || '        </address>' || Lf;
  v_Str := v_Str || '        <dob>' || Matrix_Utils.Get_InfoPathData('Patient_DOB',v_CaseId,'DT') || '</dob>' || LF;
  v_Str := v_Str || '        <gender>' || Matrix_Utils.Get_InfoPathData('Patient_Gender_Male+Patient_Gender_Female',v_CaseId,'MF') || '</gender>' || LF;
  v_Str := v_Str || '        <primaryLanguage>' || Matrix_Utils.Get_InfoPathData('Patient_Primary_Language',v_CaseId,'ST') || '</primaryLanguage>' || LF;
  v_Str := v_Str || '        <otherLanguage>' || Matrix_Utils.Get_InfoPathData('Patient_Primary_Language',v_CaseId,'ST') || '</otherLanguage>' || LF;
  v_Str := v_Str || '        <planName>' || Matrix_Utils.Get_InfoPathData('Plan_Name',v_CaseId,'ST') || '</planName>' || LF;
  v_Str := v_Str || '        <contacts>' || Lf;
  v_Str := v_Str || '            <firstName>' || Matrix_Utils.Get_InfoPathData('MI_Emergency_Contact_First_Name',v_CaseId,'ST') || '</firstName>' || LF;
  v_Str := v_Str || '            <lastName>' || Matrix_Utils.Get_InfoPathData('MI_Emergency_Contact_Last_Name',v_CaseId,'ST') || '</lastName>' || LF;
  v_Str := v_Str || '            <phone>' || Matrix_Utils.Get_InfoPathData('MI_Emergency_Contact_Phone',v_CaseId,'ST') || '</phone>' || LF;
  v_Str := v_Str || '            <address>' || LF;
  v_Str := v_Str || '              <address1>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</address1>' || LF;
  v_Str := v_Str || '              <address2>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</address2>' || LF;
  v_Str := v_Str || '              <city>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</city>' || LF;
  v_Str := v_Str || '              <country>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</country>' || LF;
  v_Str := v_Str || '              <state>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</state>' || LF;
  v_Str := v_Str || '              <suite>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</suite>' || LF;
  v_Str := v_Str || '              <zipCode>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</zipCode>' || LF;
  v_Str := v_Str || '            </address>' || Lf;
  v_Str := v_Str || '            <contactType>EMERGENCY</contactType>'||lf;
  v_Str := v_Str || '            <relationship>' || Matrix_Utils.Get_InfoPathData('MI_Emergency_Contact_Relationship',v_CaseId,'ST') || '</relationship>' || LF;
  v_Str := v_Str || '            <typeDesc>' || Matrix_Utils.Get_InfoPathData('MI_Emergency_Contact_Relationship',v_CaseId,'ST') || '</typeDesc>' || LF;
  v_Str := v_Str || '        </contacts>' || Lf;
  v_Str := v_Str || '        <contacts>' || Lf;
  v_Str := v_Str || '            <firstName>' || Matrix_Utils.Get_InfoPathData('MI_Healthcare_DPOA_First_Name',v_CaseId,'ST') || '</firstName>' || LF;
  v_Str := v_Str || '            <lastName>' || Matrix_Utils.Get_InfoPathData('MI_Healthcare_DPOA_Last_Name',v_CaseId,'ST') || '</lastName>' || LF;
  v_Str := v_Str || '            <phone>' || Matrix_Utils.Get_InfoPathData('MI_Healthcare_DPOA_Phone',v_CaseId,'ST') || '</phone>' || LF;
  v_Str := v_Str || '          <address>' || LF;
  v_Str := v_Str || '            <address1>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</address1>' || LF;
  v_Str := v_Str || '            <address2>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</address2>' || LF;
  v_Str := v_Str || '            <city>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</city>' || LF;
  v_Str := v_Str || '            <country>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</country>' || LF;
  v_Str := v_Str || '            <state>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</state>' || LF;
  v_Str := v_Str || '            <suite>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</suite>' || LF;
  v_Str := v_Str || '            <zipCode>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</zipCode>' || LF;
  v_Str := v_Str || '          </address>' || Lf;
  v_Str := v_Str || '            <contactType>HEALTHCARE_PROXY</contactType>'||lf;
  v_Str := v_Str || '            <relationship>' || Matrix_Utils.Get_InfoPathData('MI_Healthcare_DPOA_Relationship',v_CaseId,'ST') || '</relationship>' || LF;
  v_Str := v_Str || '            <typeDesc>' || Matrix_Utils.Get_InfoPathData('MI_Healthcare_DPOA_Relationship',v_CaseId,'ST') || '</typeDesc>' || LF;
  v_Str := v_Str || '         </contacts>' || Lf;
  v_Str := v_Str || '         <advanceDirective>' ||lf;
  v_Str := v_Str || '                 <exists>' ||lf;
  v_Str := v_Str || '                  <title>Has Advance Directives</title>' || LF;
  v_Str := v_Str || '                  <value>' || Matrix_Utils.Get_InfoPathData('MI_Has_Advanced_Directives',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '                 </exists>' ||lf;
  v_Str := v_Str || '                 <declinedDiscussion>' ||lf;
  v_Str := v_Str || '                  <title>Declines discussion of Advance Directives</title>' || LF;
  v_Str := v_Str || '                  <value>' || Matrix_Utils.Get_InfoPathData('MI_Decline_Discussion_Adv_Directives',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '                 </declinedDiscussion>' ||lf;
  v_Str := v_Str || '             <polstMolstType>' || LF;
  v_Str := v_Str || '                  <title>POLST/MOLST</title>' || LF;
  v_Str := v_Str || '                  <value>' || Matrix_Utils.Get_InfoPathData('MI_POLST_MOLST',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '             </polstMolstType>' || LF;
  v_Str := v_Str || '             <livingWillType>' || LF;
  v_Str := v_Str || '                  <title>Living Will</title>' || LF;
  v_Str := v_Str || '                  <value>' || Matrix_Utils.Get_InfoPathData('MI_Living_Will',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '               </livingWillType>' || LF;
  v_Str := v_Str || '                <dnrType>' || LF;
  v_Str := v_Str || '                  <title>DNR</title>' || LF;
  v_Str := v_Str || '                  <value>' || Matrix_Utils.Get_InfoPathData('MI_DNR',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '                </dnrType>' || LF;
  v_Str := v_Str || '       </advanceDirective>' ||lf;
  
  v_Str := v_Str || '        <advancedIllness>' ||lf;
  v_Str := v_Str || '               <hospice>' ||lf;
  v_Str := v_Str || '                  <title>Enrolled in Hospice</title>' || LF;
  v_Str := v_Str || '                  <value>' || Matrix_Utils.Get_InfoPathData('MI_Enrolled_Hospice',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '               </hospice>' ||lf;
  v_Str := v_Str || '              <palliative>' ||lf;
  v_Str := v_Str || '                  <title>Enrolled in Palliative Care Program</title>' || LF;
  v_Str := v_Str || '                  <value>' || Matrix_Utils.Get_InfoPathData('MI_Palliative_Care',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '              </palliative>' ||lf;
  v_Str := v_Str || '        </advancedIllness>' ||lf;
  
  
  v_Str := v_Str || '       <doesMemberHavePCP></doesMemberHavePCP>' ||lf;
  
   v_Str := v_Str || ' 
    <selfReportedDemos>
	<firstName></firstName>
	<lastName></lastName>
	<phone></phone>
	<address>
		<address1></address1>
		<address2></address2>
		<city></city>
		<country></country>
		<state></state>
		<suite></suite>
		<zipCode></zipCode>
	</address>
	<dob></dob>
	<gender></gender>
	<personId></personId>
</selfReportedDemos>' || lf;   -- empty tag placeholders
  
  v_Str := v_Str || ' </patient>' || LF;
  v_Str := v_Str || '</PatientInfo>' || LF;
  ------------------------------------
  RETURN v_Str;
EXCEPTION
WHEN OTHERS THEN
  v_Str := SUBSTR(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || CHR(13) || SQLERRM,1,4000);
  RAISE;
END MATRIX_XML_PATIENTINFO;

FUNCTION MATRIX_XML_PatientOBS(
    P_CASEID NUMBER,
    P_LF varchar2 DEFAULT chr(10)||chr(13))
  -- Created 10-6-2012 R Benzell
  -- called by ClientXMLgenerator
  -- Updated
  -- 10-13-2011 R Benzell
  -- to Test:  select XMLTEST1(1884) from dual
  RETURN CLOB
IS
  v_Str CLOB;
  v_CaseId NUMBER;
  LF       VARCHAR2(5);
BEGIN
  v_CaseId := P_CaseId;
  LF       := P_LF;
  -----------------------------------
  v_Str := v_Str || '<PatientObservation>' || LF;
  v_Str := v_Str || '  <observations>' || LF;
  v_Str := v_Str || '    <title>If SNF, reason for admission</title>' || LF;
  v_Str := v_Str || '    <value>' || Matrix_Utils.Get_InfoPathData('PO_Reason_For_Admission',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '  </observations>' || LF;
  v_Str := v_Str || '  <observations>' || LF;
  v_Str := v_Str || '    <title>Appearance</title>' || LF;
  v_Str := v_Str || '    <value>' || Matrix_Utils.Get_InfoPathData('PO_Appearance',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '  </observations>' || LF;
  v_Str := v_Str || '  <observations>' || LF;
  v_Str := v_Str || '    <title>Movement</title>' || LF;
  v_Str := v_Str || '    <value>' || Matrix_Utils.Get_InfoPathData('PO_Movement',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '  </observations>' || LF;
  v_Str := v_Str || '  <observations>' || LF;
  v_Str := v_Str || '    <title>Posture</title>' || LF;
  v_Str := v_Str || '    <value>' || Matrix_Utils.Get_InfoPathData('PO_Posture',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '  </observations>' || LF;
  v_Str := v_Str || '  <observations>' || LF;
  v_Str := v_Str || '    <title>Dress</title>' || LF;
  v_Str := v_Str || '    <value>' || Matrix_Utils.Get_InfoPathData('PO_Dress',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '  </observations>' || LF;
  v_Str := v_Str || '  <observations>' || LF;
  v_Str := v_Str || '    <title>Grooming/Hygiene</title>' || LF;
  v_Str := v_Str || '    <value>' || Matrix_Utils.Get_InfoPathData('PO_Grooming',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '  </observations>' || LF;
  v_Str := v_Str || '  <observations>' || LF;
  v_Str := v_Str || '    <title>Environment</title>' || LF;
  v_Str := v_Str || '    <value>' || Matrix_Utils.Get_InfoPathData('PO_Environment',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '  </observations>' || LF;
  v_Str := v_Str || '  <observations>' || LF;
  v_Str := v_Str || '    <title>Safety</title>' || LF;
  v_Str := v_Str || '    <value>' || Matrix_Utils.Get_InfoPathData('PO_Safety',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '  </observations>' || LF;
  v_Str := v_Str || '</PatientObservation>' || LF;
  ------------------------------------
  RETURN v_Str;
EXCEPTION
WHEN OTHERS THEN
  v_Str := SUBSTR(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || CHR(13) || SQLERRM,1,4000);
  RAISE;
END MATRIX_XML_PatientOBS;

FUNCTION MATRIX_XML_PCPMEMBER(
    P_CASEID NUMBER,
    P_LF varchar2 DEFAULT chr(10)||chr(13))
  -- Created 10-6-2012 R Benzell
  -- called by ClientXMLgenerator
  -- Updated
  -- 10-13-2011 R Benzell
  -- to Test:  select XMLTEST1(1884) from dual
  RETURN CLOB
IS
  v_Str CLOB;
  v_CaseId NUMBER;
  LF       VARCHAR2(5);
BEGIN
  v_CaseId := P_CaseId;
  LF       := P_LF;
  -----------------------------------
  v_Str := v_Str || ' <PrimaryCareDoctor>' || LF;
--  v_Str := v_Str || '   <person>' || Matrix_Utils.Get_InfoPathData('MI_Palliative_Care',v_CaseId,'ST') || '</person>' || LF;
  v_Str := v_Str || '   <person>'  || LF;
  v_Str := v_Str || '      <firstName>' || Matrix_Utils.Get_InfoPathData('MI_First_Name',v_CaseId,'ST') || '</firstName>' || LF;
  v_Str := v_Str || '      <lastName>' || Matrix_Utils.Get_InfoPathData('MI_Last_Name',v_CaseId,'ST') || '</lastName>' || LF;
  v_Str := v_Str || '      <phone>' || Matrix_Utils.Get_InfoPathData('MI_Phone',v_CaseId,'ST') || '</phone>' || LF;
  v_Str := v_Str || '      <address>' || LF;
  v_Str := v_Str || '        <address1>' || Matrix_Utils.Get_InfoPathData('MI_Address_Street',v_CaseId,'ST') || '</address1>' || LF;
  v_Str := v_Str || '        <address2>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</address2>' || LF;
  v_Str := v_Str || '        <city>' || Matrix_Utils.Get_InfoPathData('MI_Address_City',v_CaseId,'ST') || '</city>' || LF;
  v_Str := v_Str || '        <country>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</country>' || LF;
  v_Str := v_Str || '        <state>' || Matrix_Utils.Get_InfoPathData('MI_Address_State',v_CaseId,'ST') || '</state>' || LF;
  v_Str := v_Str || '        <suite>' || Matrix_Utils.Get_InfoPathData('MI_Address_Suite',v_CaseId,'ST') || '</suite>' || LF;
  v_Str := v_Str || '        <zipCode>' || Matrix_Utils.Get_InfoPathData('MI_Address_Zip',v_CaseId,'ST') || '</zipCode>' || LF;
  v_Str := v_Str || '      </address>' || LF;
  v_Str := v_Str || '      <contactType>PRIMARY</contactType>' || LF;
  v_Str := v_Str || '      <relationship>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</relationship>' || LF;
  v_Str := v_Str || '      <typeDesc>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</typeDesc>' || LF;
  v_Str := v_Str || '  </person>'  || LF;
  v_Str := v_Str || ' </PrimaryCareDoctor>' || LF;
  ------------------------------------
  RETURN v_Str;
EXCEPTION
WHEN OTHERS THEN
  v_Str := SUBSTR(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || CHR(13) || SQLERRM,1,4000);
  RAISE;
END MATRIX_XML_PCPMEMBER;

FUNCTION MATRIX_XML_PERSANDSOC(
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
  v_Str := v_Str || '<PersonalAndSocial>' || LF;
  v_Str := v_Str || '   <maritalStatus>' || Matrix_Utils.Get_InfoPathData('Personal_Social_Marital_Status',v_CaseId,'ST') || '</maritalStatus>' || LF;
  v_Str := v_Str || '   <occupation>' || Matrix_Utils.Get_InfoPathData('Personal_Social_History_Occup',v_CaseId,'ST') || '</occupation>' || LF;
  v_Str := v_Str || '   <retired>' || Matrix_Utils.Get_InfoPathData('Personal_Social_History_Retired',v_CaseId,'TF') || '</retired>' || LF;
  v_Str := v_Str || '   <livingWith>' || Matrix_Utils.Get_InfoPathData('Personal_Live_Alone+Personal_Live_With_Spouse+Personal_Live_Children+Personal_Live_Other_Adults+Personal_Live_Full_Time_Facility',v_CaseId,'ST') || '</livingWith>' || LF;
  v_Str := v_Str || '   <help>' || LF;
  v_Str := v_Str || '     <title>Who would you turn to for help if you had problems (with health, transporation, etc)?</title>' || LF;
  v_Str := v_Str || '     <value></value>' || LF;
  v_Str := v_Str || '     <questions>' || LF;
  v_Str := v_Str || '         <title>Rely On Self</title>' || LF;
  v_Str := v_Str || '         <value>' || Matrix_Utils.Get_InfoPathData('Personal_Help_Self',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '     </questions>' || LF;
  v_Str := v_Str || '     <questions>' || LF;
  v_Str := v_Str || '         <title>Spouse/Partner</title>' || LF;
  v_Str := v_Str || '         <value>' || Matrix_Utils.Get_InfoPathData('Personal_Help_Spouse',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '     </questions>' || LF;
  v_Str := v_Str || '     <questions>' || LF;
  v_Str := v_Str || '         <title>Children</title>' || LF;
  v_Str := v_Str || '         <value>' || Matrix_Utils.Get_InfoPathData('Personal_Help_Children',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '     </questions>' || LF;
  v_Str := v_Str || '     <questions>' || LF;
  v_Str := v_Str || '         <title>Other adult/sibling</title>' || LF;
  v_Str := v_Str || '         <value>' || Matrix_Utils.Get_InfoPathData('Personal_Help_Other_Adult',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '     </questions>' || LF;
  v_Str := v_Str || '     <questions>' || LF;
  v_Str := v_Str || '         <title>Other</title>' || LF;
  v_Str := v_Str || '         <value>' || Matrix_Utils.Get_InfoPathData('Personal_Help_Other',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '             <extraData>' || LF;
  v_Str := v_Str || '                  <title>Other</title>' || LF;
  v_Str := v_Str || '                  <value>' || Matrix_Utils.Get_InfoPathData('Personal_Help_Other_Box',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '             </extraData>' || LF;
  v_Str := v_Str || '     </questions>' || LF;
  v_Str := v_Str || '   </help>' || LF;
  v_Str := v_Str || '   <houseSafety>' || LF;
  v_Str := v_Str || '    <title></title>' || LF;
  v_Str := v_Str || '    <value></value>' || LF;
  v_Str := v_Str || '    <secondaryQuestions>' || LF;
  v_Str := v_Str || '        <title>Do you feel safe in your home?</title>' || LF;
  v_Str := v_Str || '        <value>' || Matrix_Utils.Get_InfoPathData('Personal_Safe',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '        <secondaryQuestions>' || LF;
  v_Str := v_Str || '           <title>Are you being abused by your partner or someone important to you?</title>' || LF;
  v_Str := v_Str || '           <value>' || Matrix_Utils.Get_InfoPathData('Personal_Abused',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '        </secondaryQuestions>' || LF;
  v_Str := v_Str || '        <secondaryQuestions>' || LF;
  v_Str := v_Str || '           <title>Within the past 12 months have you been hit, slapped, pushed or otherwise hurt by someone?</title>' || LF;
  v_Str := v_Str || '           <value>' || Matrix_Utils.Get_InfoPathData('Personal_Hit',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '        </secondaryQuestions>' || LF;
  v_Str := v_Str || '     </secondaryQuestions>' || LF;
  v_Str := v_Str || '   </houseSafety>' || LF;
  v_Str := v_Str || '   <communityMobility>' || LF;
  v_Str := v_Str || '        <groupTitle>How do you get around the community?</groupTitle>' || LF;
--  v_Str := v_Str || '        <groupDesc></groupDesc>' || LF;
  v_Str := v_Str || '        <questions>' || LF;
  v_Str := v_Str || '         <title>Independent</title>' || LF;
  v_Str := v_Str || '         <value>' || Matrix_Utils.Get_InfoPathData('Personal_Get_Around_Independent',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '        </questions>' || LF;
  v_Str := v_Str || '        <questions>' || LF;
  v_Str := v_Str || '         <title>With Assistance</title>' || LF;
  v_Str := v_Str || '         <value>' || Matrix_Utils.Get_InfoPathData('Personal_Get_Around_Assistance',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '        </questions>' || LF;
  v_Str := v_Str || '        <questions>' || LF;
  v_Str := v_Str || '         <title>Homebound</title>' || LF;
  v_Str := v_Str || '         <value>' || Matrix_Utils.Get_InfoPathData('Personal_Get_Around_Homeland',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '        </questions>' || LF;
  v_Str := v_Str || '   </communityMobility>' || LF;
  v_Str := v_Str || '   <spendTimeAlone>' || LF;
  v_Str := v_Str || '    <title>Do you feel you spend too much time alone?</title>' || LF;
  v_Str := v_Str || '    <value>' || Matrix_Utils.Get_InfoPathData('Personal_Alone',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '   </spendTimeAlone>' || LF;
  v_Str := v_Str || '</PersonalAndSocial>' || LF;
  ------------------------------------
  RETURN v_Str;
EXCEPTION
WHEN OTHERS THEN
  --v_Str := SUBSTR(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || CHR(13) || SQLERRM,1,4000);
   dbms_output.put_line('MATRIX_XML_PERSANDSOC:' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || CHR(13) || SQLERRM );
  RAISE;
END MATRIX_XML_PERSANDSOC;

FUNCTION MATRIX_XML_PHYEXAM(
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
  v_Str := v_Str || '   <PhysicalExam>' || LF;



--- Sitting #1
  v_Str := v_Str || '   <bloodPressures>'  || LF;
  --v_Str := v_Str || '        <title>Blood Pressure Sitting Right #1</title>' || LF;
  v_Str := v_Str || '        <leftOrRight>Left</leftOrRight>' || LF;
  v_Str := v_Str || '        <position>Sitting</position>' || LF;  
  v_Str := v_Str || '        <systolic>' || Matrix_Utils.Get_InfoPathData('Physical_BP_R',v_CaseId,'BPS') || '</systolic>' || LF;
  v_Str := v_Str || '        <diastolic>' || Matrix_Utils.Get_InfoPathData('Physical_BP_R',v_CaseId,'BPD') || '</diastolic>' || LF;
  v_Str := v_Str || '   </bloodPressures>' || LF;

  v_Str := v_Str || '   <bloodPressures>'  || LF;
  --v_Str := v_Str || '        <title>Blood Pressure Sitting Left #1</title>' || LF;
  v_Str := v_Str || '        <leftOrRight>Left</leftOrRight>' || LF;
  v_Str := v_Str || '        <position>Sitting</position>' || LF;    
  v_Str := v_Str || '        <systolic>' || Matrix_Utils.Get_InfoPathData('Physical_BP_L',v_CaseId,'BPS') || '</systolic>' || LF;
  v_Str := v_Str || '        <diastolic>' || Matrix_Utils.Get_InfoPathData('Physical_BP_L',v_CaseId,'BPD') || '</diastolic>' || LF;
  v_Str := v_Str || '   </bloodPressures>' || LF;

--- Sitting #2
  v_Str := v_Str || '   <bloodPressures>'  || LF;
  --v_Str := v_Str || '        <title>Blood Pressure Sitting Right #2</title>' || LF;
  v_Str := v_Str || '        <leftOrRight>Left</leftOrRight>' || LF;
  v_Str := v_Str || '        <position>Sitting</position>' || LF;  
  v_Str := v_Str || '        <systolic>' || Matrix_Utils.Get_InfoPathData('Physical_BP_R_2',v_CaseId,'BPS') || '</systolic>' || LF;
  v_Str := v_Str || '        <diastolic>' || Matrix_Utils.Get_InfoPathData('Physical_BP_R_2',v_CaseId,'BPD') || '</diastolic>' || LF;
  v_Str := v_Str || '   </bloodPressures>' || LF;

  v_Str := v_Str || '   <bloodPressures>'  || LF;
 -- v_Str := v_Str || '        <title>Blood Pressure Sitting Left #2</title>' || LF;
  v_Str := v_Str || '        <leftOrRight>Left</leftOrRight>' || LF;
  v_Str := v_Str || '        <position>Sitting</position>' || LF;  
  v_Str := v_Str || '        <systolic>' || Matrix_Utils.Get_InfoPathData('Physical_BP_L_2',v_CaseId,'BPS') || '</systolic>' || LF;
  v_Str := v_Str || '        <diastolic>' || Matrix_Utils.Get_InfoPathData('Physical_BP_L_2',v_CaseId,'BPD') || '</diastolic>' || LF;
  v_Str := v_Str || '   </bloodPressures>' || LF;

---- Standing #1
  v_Str := v_Str || '   <bloodPressures>'  || LF;
--  v_Str := v_Str || '        <title>Blood Pressure Standing Right #1</title>' || LF;
  v_Str := v_Str || '        <leftOrRight>Right</leftOrRight>' || LF;
  v_Str := v_Str || '        <position>Standing</position>' || LF;  
  v_Str := v_Str || '        <systolic>' || Matrix_Utils.Get_InfoPathData('Physical_BP_Standing_R',v_CaseId,'BPS') || '</systolic>' || LF;
  v_Str := v_Str || '        <diastolic>' || Matrix_Utils.Get_InfoPathData('Physical_BP_Standing_R',v_CaseId,'BPD') || '</diastolic>' || LF;
  v_Str := v_Str || '   </bloodPressures>' || LF;

  v_Str := v_Str || '   <bloodPressures>'  || LF;
--  v_Str := v_Str || '        <title>Blood Pressure Standing Left #1</title>' || LF;
  v_Str := v_Str || '        <leftOrRight>Left</leftOrRight>' || LF;
  v_Str := v_Str || '        <position>Standing</position>' || LF;  
  v_Str := v_Str || '        <systolic>' || Matrix_Utils.Get_InfoPathData('Physical_BP_Standing_L',v_CaseId,'BPS') || '</systolic>' || LF;
  v_Str := v_Str || '        <diastolic>' || Matrix_Utils.Get_InfoPathData('Physical_BP_Standing_L',v_CaseId,'BPD') || '</diastolic>' || LF;
  v_Str := v_Str || '   </bloodPressures>' || LF;

---- Standing #2
  v_Str := v_Str || '   <bloodPressures>'  || LF;
-- v_Str := v_Str || '        <title>Blood Pressure Standing Right #2</title>' || LF;
  v_Str := v_Str || '        <leftOrRight>Right</leftOrRight>' || LF;
  v_Str := v_Str || '        <position>Standing</position>' || LF;  
  v_Str := v_Str || '        <systolic>' || Matrix_Utils.Get_InfoPathData('Physical_BP_Standing_R_2',v_CaseId,'BPS') || '</systolic>' || LF;
  v_Str := v_Str || '        <diastolic>' || Matrix_Utils.Get_InfoPathData('Physical_BP_Standing_R_2',v_CaseId,'BPD') || '</diastolic>' || LF;
  v_Str := v_Str || '   </bloodPressures>' || LF;

  v_Str := v_Str || '   <bloodPressures>'  || LF;
--  v_Str := v_Str || '        <title>Blood Pressure Standing Left #2</title>' || LF;
  v_Str := v_Str || '        <leftOrRight>Left</leftOrRight>' || LF;
  v_Str := v_Str || '        <position>Standing</position>' || LF;  
  v_Str := v_Str || '        <systolic>' || Matrix_Utils.Get_InfoPathData('Physical_BP_Standing_L_2',v_CaseId,'BPS') || '</systolic>' || LF;
  v_Str := v_Str || '        <diastolic>' || Matrix_Utils.Get_InfoPathData('Physical_BP_Standing_L_2',v_CaseId,'BPD') || '</diastolic>' || LF;
  v_Str := v_Str || '   </bloodPressures>' || LF;

---- Supine #1
  v_Str := v_Str || '   <bloodPressures>'  || LF;
 -- v_Str := v_Str || '        <title>Blood Pressure Supine Right #1</title>' || LF;
  v_Str := v_Str || '        <leftOrRight>Right</leftOrRight>' || LF;
  v_Str := v_Str || '        <position>Supine</position>' || LF;  
  v_Str := v_Str || '        <systolic>' || Matrix_Utils.Get_InfoPathData('Physical_BP_Supine_R',v_CaseId,'BPS') || '</systolic>' || LF;
  v_Str := v_Str || '        <diastolic>' || Matrix_Utils.Get_InfoPathData('Physical_BP_Supine_R',v_CaseId,'BPD') || '</diastolic>' || LF;
  v_Str := v_Str || '   </bloodPressures>' || LF;

  v_Str := v_Str || '   <bloodPressures>'  || LF;
--  v_Str := v_Str || '        <title>Blood Pressure Supine Left #1</title>' || LF;
  v_Str := v_Str || '        <leftOrRight>Left</leftOrRight>' || LF;
  v_Str := v_Str || '        <position>Supine</position>' || LF;  
  v_Str := v_Str || '        <systolic>' || Matrix_Utils.Get_InfoPathData('Physical_BP_Supine_L',v_CaseId,'BPS') || '</systolic>' || LF;
  v_Str := v_Str || '        <diastolic>' || Matrix_Utils.Get_InfoPathData('Physical_BP_Supine_L',v_CaseId,'BPD') || '</diastolic>' || LF;
  v_Str := v_Str || '   </bloodPressures>' || LF;

---- Supine #2
  v_Str := v_Str || '   <bloodPressures>'  || LF;
--  v_Str := v_Str || '        <title>Blood Pressure Supine Right #2</title>' || LF;
  v_Str := v_Str || '        <leftOrRight>Right</leftOrRight>' || LF;
  v_Str := v_Str || '        <position>Supine</position>' || LF;  
  v_Str := v_Str || '        <systolic>' || Matrix_Utils.Get_InfoPathData('Physical_BP_Supine_R_2',v_CaseId,'BPS') || '</systolic>' || LF;
  v_Str := v_Str || '        <diastolic>' || Matrix_Utils.Get_InfoPathData('Physical_BP_Supine_R_2',v_CaseId,'BPD') || '</diastolic>' || LF;
  v_Str := v_Str || '   </bloodPressures>' || LF;

  v_Str := v_Str || '   <bloodPressures>'  || LF;
--  v_Str := v_Str || '        <title>Blood Pressure Supine Left #2</title>' || LF;
  v_Str := v_Str || '        <leftOrRight>Left</leftOrRight>' || LF;
  v_Str := v_Str || '        <position>Supine</position>' || LF;  
  v_Str := v_Str || '        <systolic>' || Matrix_Utils.Get_InfoPathData('Physical_BP_Supine_L_2',v_CaseId,'BPS') || '</systolic>' || LF;
  v_Str := v_Str || '        <diastolic>' || Matrix_Utils.Get_InfoPathData('Physical_BP_Supine_L_2',v_CaseId,'BPD') || '</diastolic>' || LF;
  v_Str := v_Str || '   </bloodPressures>' || LF;

  
  v_Str := v_Str || '   <pulse>' || Matrix_Utils.Get_InfoPathData('Physical_Pulse',v_CaseId,'INT-999') || '</pulse>' || LF;
  v_Str := v_Str || '   <respiration>' || Matrix_Utils.Get_InfoPathData('Physical_Resp',v_CaseId,'INT-999') || '</respiration>' || LF;
  v_Str := v_Str || '   <o2sat>' || '-555' || '</o2sat>' || LF;
  v_Str := v_Str || '   <weight>' || Matrix_Utils.Get_InfoPathData('Physical_Weight',v_CaseId,'INT-999') || '</weight>' || LF;
  v_Str := v_Str || '   <usualWeight>' || Matrix_Utils.Get_InfoPathData('Physical_Usual_WT',v_CaseId,'INT-999') || '</usualWeight>' || LF;
  v_Str := v_Str || '   <heightFeet>' || Matrix_Utils.Get_InfoPathData('Physical_Height',v_CaseId,'INT-999') || '</heightFeet>' || LF;
  v_Str := v_Str || '   <heightInches>' || Matrix_Utils.Get_InfoPathData('Physical_Height',v_CaseId,'INT-999') || '</heightInches>' || LF;
  
  --v_Str := v_Str || '   <pulseType>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</pulseType>' || LF;  -- not present in Form.  possible values: apical, radial
  v_Str := v_Str || '   <bmi>' || Matrix_Utils.Get_InfoPathData('Physical_BMI',v_CaseId,'INT-999') || '</bmi>' || LF;
    
  v_Str := v_Str || '   <weightLoss>' || LF;
  v_Str := v_Str || '    <title>Physical_Weight_Loss</title>' || LF;
  v_Str := v_Str || '    <value>' || Matrix_Utils.Get_InfoPathData('Physical_Weight_Loss',v_CaseId,'ST') || '</value>' || LF;
  
  v_Str := v_Str || '    <secondaryQuestions>' || LF;
  v_Str := v_Str || '       <title>Physical_Weight_Loss_Yes</title>' || LF;
  v_Str := v_Str || '       <value>' || Matrix_Utils.Get_InfoPathData('Physical_Weight_Loss_Yes',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '    </secondaryQuestions>' || LF;  
  v_Str := v_Str || '    <secondaryQuestions>' || LF;  
  v_Str := v_Str || '        <title>Physical_Weight_Loss_lbs_Over</title>' || LF;
  v_Str := v_Str || '        <value>' || Matrix_Utils.Get_InfoPathData('Physical_Weight_Loss_lbs_Over',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '    </secondaryQuestions>' || LF;

  v_Str := v_Str || '    <secondaryQuestions>' || LF;
  v_Str := v_Str || '       <title>Physical_Weight_Loss_From_Date</title>' || LF;
  v_Str := v_Str || '       <value>' || Matrix_Utils.Get_InfoPathData('Physical_Weight_Loss_From_date',v_CaseId,'DT') || '</value>' || LF;
  v_Str := v_Str || '    </secondaryQuestions>' || LF;

  v_Str := v_Str || '    <secondaryQuestions>' || LF;
  v_Str := v_Str || '       <title>Physical_Weight_Loss_To_Date</title>' || LF;
  v_Str := v_Str || '       <value>' || Matrix_Utils.Get_InfoPathData('Physical_Weight_Loss_To_date',v_CaseId,'DT') || '</value>' || LF;
  v_Str := v_Str || '    </secondaryQuestions>' || LF;
  --v_Str := v_Str || '    <managementPlan>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</managementPlan>' || LF;
  v_Str := v_Str || '   </weightLoss>' || LF;
  
  v_Str := v_Str || '   <pain>' || LF;
  v_Str := v_Str || '        <painScale>' || LF;
--  v_Str := v_Str || '            <label>No Pain 0 - 10 Worst Pain Imaginable</label>' || LF;
  v_Str := v_Str || '            <label>Pain Scale</label>' || LF;
  v_Str := v_Str || '            <quantity>' || Matrix_Utils.Get_InfoPathData('Physical_Pain_Scale',v_CaseId,'INT-999') || '</quantity>' || LF;
  v_Str := v_Str || '        </painScale>' || LF;
  
  v_Str := v_Str || '        <questions>' || LF;
  v_Str := v_Str || '          <title>Indicate location/quality/pattern of pain (if present):</title>' || LF;
  v_Str := v_Str || '          <value>' || Matrix_Utils.Get_InfoPathData('Physical_Pain_Location',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </questions>' || LF;
  
  v_Str := v_Str || '        <questions>' || LF;
  v_Str := v_Str || '         <title>No Intervention</title>' || LF;
  v_Str := v_Str || '          <value>' || Matrix_Utils.Get_InfoPathData('Physical_Pain_No_Intervention',v_CaseId,'TF') || '</value>' || LF;
  
  v_Str := v_Str || '           <secondaryQuestions>' || LF;
  v_Str := v_Str || '             <title>Lack of severity</title>' || LF;
  v_Str := v_Str || '             <value>' || Matrix_Utils.Get_InfoPathData('Physical_Pain_No_Intervention_Lack_Severity',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '           </secondaryQuestions>' || LF;
  
  v_Str := v_Str || '           <secondaryQuestions>' || LF;
  v_Str := v_Str || '             <title>Patient preference</title>' || LF;
  v_Str := v_Str || '             <value>' || Matrix_Utils.Get_InfoPathData('Physical_Pain_No_Intervention_Patient_Pref',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '          </secondaryQuestions>' || LF;
  v_Str := v_Str || '        </questions>' || LF;
  
  v_Str := v_Str || '        <questions>' || LF;
  v_Str := v_Str || '         <title>Intervention</title>' || LF;
  v_Str := v_Str || '          <value>' || Matrix_Utils.Get_InfoPathData('Physical_Pain_Intervention',v_CaseId,'TF') || '</value>' || LF;
  
  v_Str := v_Str || '           <secondaryQuestions>' || LF;
  v_Str := v_Str || '             <title>Pain medication discussed</title>' || LF;
  v_Str := v_Str || '             <value>' || Matrix_Utils.Get_InfoPathData(' Physical_Pain_Intervention_Medication',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '           </secondaryQuestions>' || LF;
  
  v_Str := v_Str || '           <secondaryQuestions>' || LF;
  v_Str := v_Str || '             <title>Psycho-social support</title>' || LF;
  v_Str := v_Str || '             <value>' || Matrix_Utils.Get_InfoPathData('Physical_Pain_Intervention_Support',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '          </secondaryQuestions>' || LF;
 
  v_Str := v_Str || '           <secondaryQuestions>' || LF;
  v_Str := v_Str || '             <title>Patient/family education</title>' || LF;
  v_Str := v_Str || '             <value>' || Matrix_Utils.Get_InfoPathData('Physical_Pain_Intervention_Education',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '          </secondaryQuestions>' || LF;
 
  v_Str := v_Str || '        </questions>' || LF;
  v_Str := v_Str || '   </pain>' || LF; 
  
  
  v_Str := v_Str || '   <mental>' || LF;
  v_Str := v_Str || '        <sectionTitle>Mental Status Screen- Mini Cog Test</sectionTitle>' || LF;
  --v_Str := v_Str || '        <groupedQuestions></groupedQuestions>' || LF;  --- xxx not sure what to map here
  v_Str := v_Str || '        <isCorrect>' || LF;
  v_Str := v_Str || '           <title># of right words (if 3 then stop-screen is negative)</title>' || LF;
  v_Str := v_Str || '           <value>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '           <rating>' || Matrix_Utils.Get_InfoPathData('Mental_Status_Score',v_CaseId,'INT-999') || '</rating>' || LF;
  v_Str := v_Str || '        </isCorrect>' || LF;

  v_Str := v_Str || '        <clockValid>' || LF;
  v_Str := v_Str || '           <title>The time is correct and the clock appears grossly normal</title>' || LF;
  v_Str := v_Str || '           <value>' || Matrix_Utils.Get_InfoPathData('Mental_Status_Time',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '        </clockValid>' || LF;
  v_Str := v_Str || '        <testValid>' ||  Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</testValid>'  || LF;
  --v_Str := v_Str || '        <instructions>' ||  Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</instructions>'  || LF;
  --v_Str := v_Str || '        <interpretation>' ||  Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</interpretation>'  || LF;
  v_Str := v_Str || '   </mental>' || LF;
  
  v_Str := v_Str || '   <sections>' || LF;
  v_Str := v_Str || '   <sectionTitle>General</sectionTitle>' || LF;
  v_Str := v_Str || '        <followUpQuestion>' || LF;
  v_Str := v_Str || '            <title>Distress Level</title>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('Physical_Gen_Distress',v_CaseId,'ST') || '</value>' || LF;
  --v_Str := v_Str || '            <answer>' ||  Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</answer>'  || LF;
  v_Str := v_Str || '        </followUpQuestion>' || LF;
  v_Str := v_Str || '        <followUpQuestion>' || LF;
  v_Str := v_Str || '            <title>Body Appearance</title>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('Physical_Gen_Body_Appearance',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </followUpQuestion>' || LF;
  v_Str := v_Str || '        <followUpQuestion>' || LF;
  v_Str := v_Str || '            <title>Responsiveness Level</title>' || LF;
--MG--In the line below, updated Physical_Gen_Cooperative to Physical_Gen_Cooperative1
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('Physical_Gen_Drowsy , Physical_Gen_Cooperative,  Physical_Gen_Combative ,  Physical_Gen_Alert,  Physical_Gen_Withdrawn,  Physical_Gen_Other',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </followUpQuestion>' || LF;
  v_Str := v_Str || '   </sections>' || LF;
  v_Str := v_Str || '   <sections>' || LF;
  v_Str := v_Str || '   <sectionTitle>EENT</sectionTitle>' || LF;
  v_Str := v_Str || '        <followUpQuestion>' || LF;
  v_Str := v_Str || '            <title>PERRLA</title>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('Physical_EENT_Perrla',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </followUpQuestion>' || LF;
  v_Str := v_Str || '        <followUpQuestion>' || LF;
  v_Str := v_Str || '            <title>Extra Occular Motion Intact</title>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('Physical_EENT_Extra_Ocular',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </followUpQuestion>' || LF;
  v_Str := v_Str || '        <followUpQuestion>' || LF;
  --v_Str := v_Str || '            <title>Oral Lesions</title>'  || LF;
  --v_Str := v_Str || '            <value>' ||  Matrix_Utils.Get_InfoPathData('Physical_EENT_Oral_Lesions',v_CaseId,'ST') || '</value>'  || LF;
  v_Str := v_Str || '          <secondaryQuestions>' || LF;
  v_Str := v_Str || '            <title>Location</title>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('Physical_EENT',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '          </secondaryQuestions>' || LF;
  v_Str := v_Str || '        </followUpQuestion>' || LF;
  v_Str := v_Str || '        <followUpQuestion>' || LF;
  v_Str := v_Str || '            <title>Teeth</title>' || LF;
  v_Str := v_Str || '            <answer>' || Matrix_Utils.Get_InfoPathData('Physical_EENT_Teeth_Dentures, Physical_EENT_Teeth_Edentulous,  Physical_EENT_Teeth_Intact,  Physical_EENT_Teeth_Missing', v_CaseId,'ST') || '</answer>' || LF;
  v_Str := v_Str || '        </followUpQuestion>' || LF;
  --MISSING
  --v_Str := v_Str || '        <followUpQuestion>' || LF;
  --v_Str := v_Str || '            <title>Oral Hygiene</title>'  || LF;
  --v_Str := v_Str || '        </followUpQuestion>' || LF;
  v_Str := v_Str || '   </sections>' || LF;
  v_Str := v_Str || '   <sections>' || LF;
  v_Str := v_Str || '   <sectionTitle>Neuro</sectionTitle>' || LF;
  v_Str := v_Str || '        <followUpQuestion>' || LF;
  v_Str := v_Str || '            <title>CN 2-12 Intact</title>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('Physical_Neuro_CN_Intact',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </followUpQuestion>' || LF;
  v_Str := v_Str || '        <followUpQuestion>' || LF;
  v_Str := v_Str || '            <title>Speech normal</title>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('Physical_Neuro_Speech',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '                <secondaryQuestions>' || LF;
  v_Str := v_Str || '                    <title>Abnormality</title>' || LF;
  -- MISSING ANSWER LINE
  v_Str := v_Str || '                    <value>' || Matrix_Utils.Get_InfoPathData('Physical_Neuro_Speech_Abnormality',v_CaseId,'ST') || '</value>' || LF;
  --MISSING OtherValue Line
  v_Str := v_Str || '                  </secondaryQuestions>' || LF;
  v_Str := v_Str || '        </followUpQuestion>' || LF;
  v_Str := v_Str || '        <followUpQuestion>' || LF;
  v_Str := v_Str || '            <title>Cerebellar exam: Normal finger to nose?</title>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('Physical_Neuro_Finger_to_Nose',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </followUpQuestion>' || LF;
  v_Str := v_Str || '        <followUpQuestion>' || LF;
  v_Str := v_Str || '            <title>Cerebellar exam: Balance normal (Romberg test)?</title>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('Physical_Neuro_Romberg_Test',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </followUpQuestion>' || LF;
  v_Str := v_Str || '        <followUpQuestion>' || LF;
  v_Str := v_Str || '            <title>Sensory exam: Right UE</title>' || LF;
  v_Str := v_Str || '            <answer>' || Matrix_Utils.Get_InfoPathData('Physical_Neuro_Sensory_Right_Normal_UE,  Physical_Neuro_Sensory_Right_Diminished_UE',v_CaseId,'ST') || '</answer>' || LF;
  v_Str := v_Str || '        </followUpQuestion>' || LF;
  v_Str := v_Str || '        <followUpQuestion>' || LF;
  v_Str := v_Str || '            <title>Sensory exam: Right LE</title>' || LF;
  v_Str := v_Str || '            <answer>' || Matrix_Utils.Get_InfoPathData('Physical_Neuro_Sensory_Right_Normal_LE, Physical_Neuro_Sensory_Right_Diminished_LE',v_CaseId,'ST') || '</answer>' || LF;
  v_Str := v_Str || '        </followUpQuestion>' || LF;
  v_Str := v_Str || '        <followUpQuestion>' || LF;
  v_Str := v_Str || '            <title>Sensory exam: Left UE</title>' || LF;
--MG--Updated the field below "Physical_Neuro_Sensory_Left_Diminshed_UE" by replacing the misspelled word "Diminshed" with "Diminished"
  v_Str := v_Str || '            <answer>' || Matrix_Utils.Get_InfoPathData('Physical_Neuro_Sensory_Left_Normal_UE, Physical_Neuro_Sensory_Left_Diminished_UE',v_CaseId,'ST') || '</answer>' || LF;
  v_Str := v_Str || '        </followUpQuestion>' || LF;
  v_Str := v_Str || '        <followUpQuestion>' || LF;
  v_Str := v_Str || '            <title>Sensory exam: Left LE</title>' || LF;
  v_Str := v_Str || '            <answer>' || Matrix_Utils.Get_InfoPathData('Physical_Neuro_Sensory_Left_Normal_LE Physical_Neuro_Sensory_Left_Diminished_LE',v_CaseId,'ST') || '</answer>' || LF;
  v_Str := v_Str || '        </followUpQuestion>' || LF;
  v_Str := v_Str || '        <followUpQuestion>' || LF;
  v_Str := v_Str || '            <title>Reflexes: Right Biceps</title>' || LF;
  v_Str := v_Str || '            <answer>' || Matrix_Utils.Get_InfoPathData('Physical_Neuro_Reflexes_Right_Normal_Biceps,  Physical_Neuro_Reflexes_Right_Diminished_Biceps',v_CaseId,'ST') || '</answer>' || LF;
  v_Str := v_Str || '        </followUpQuestion>' || LF;
  v_Str := v_Str || '        <followUpQuestion>' || LF;
  v_Str := v_Str || '            <title>Reflexes: Right Achilles</title>' || LF;
  v_Str := v_Str || '            <answer>' || Matrix_Utils.Get_InfoPathData('Physical_Neuro_Reflexes_Right_Normal_Achilles,  Physical_Neuro_Reflexes_Right_Diminished_Achilles',v_CaseId,'ST') || '</answer>' || LF;
  v_Str := v_Str || '        </followUpQuestion>' || LF;
  v_Str := v_Str || '        <followUpQuestion>' || LF;
  v_Str := v_Str || '            <title>Reflexes: Right Patellar</title>' || LF;
--MG--Updated the field below "Physical_Neuro_Reflexes_Left_Normal_Patellar" by replacing Left with Right as the title indicates.
  v_Str := v_Str || '            <answer>' || Matrix_Utils.Get_InfoPathData('Physical_Neuro_Reflexes_Right_Normal_Patellar,  Physical_Neuro_Reflexes_Right_Diminished_Patellar',v_CaseId,'ST') || '</answer>' || LF;
  v_Str := v_Str || '        </followUpQuestion>' || LF;
  v_Str := v_Str || '        <followUpQuestion>' || LF;
  v_Str := v_Str || '            <title>Reflexes: Left Biceps</title>' || LF;
  v_Str := v_Str || '            <answer>' || Matrix_Utils.Get_InfoPathData('Physical_Neuro_Reflexes_Left_Normal_Biceps,  Physical_Neuro_Reflexes_Left_Diminished_Biceps',v_CaseId,'ST') || '</answer>' || LF;
  v_Str := v_Str || '        </followUpQuestion>' || LF;
  v_Str := v_Str || '        <followUpQuestion>' || LF;
  v_Str := v_Str || '            <title>Reflexes: Left Achilles</title>' || LF;
  v_Str := v_Str || '            <answer>' || Matrix_Utils.Get_InfoPathData('Physical_Neuro_Reflexes_Left_Normal_Achilles,  Physical_Neuro_Reflexes_Left_Diminished_Achilles',v_CaseId,'ST') || '</answer>' || LF;
  v_Str := v_Str || '        </followUpQuestion>' || LF;
  v_Str := v_Str || '        <followUpQuestion>' || LF;
  v_Str := v_Str || '            <title>Reflexes: Left Patellar</title>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('Physical_Neuro_Reflexes_Left_Normal_Patellar, Physical_Neuro_Reflexes_Left_Diminished_Patellar',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </followUpQuestion>' || LF;
  v_Str := v_Str || '        <followUpQuestion>' || LF;
  v_Str := v_Str || '            <title>Strength: Right UE</title>' || LF;
  v_Str := v_Str || '            <answer>' || Matrix_Utils.Get_InfoPathData('Physical_Neuro_Strength_Right_Normal_UE,  Physical_Neuro_Strength_Right_Monoparesis_UE, Physical_Neuro_Strength_Right_Diminished_Monoplegia_UE',v_CaseId,'ST') || '</answer>' || LF;
  v_Str := v_Str || '        </followUpQuestion>' || LF;
  v_Str := v_Str || '        <followUpQuestion>' || LF;
  v_Str := v_Str || '            <title>Strength: Right LE</title>' || LF;
  v_Str := v_Str || '            <answer>' || Matrix_Utils.Get_InfoPathData('Physical_Neuro_Strength_Right_Normal_LE,  Physical_Neuro_Strength_Right_Diminished_Monoplegia_LE, Physical_Neuro_Strength_Right_Monoparesis_LE',v_CaseId,'ST') || '</answer>' || LF;
  v_Str := v_Str || '        </followUpQuestion>' || LF;
  v_Str := v_Str || '        <followUpQuestion>' || LF;
  v_Str := v_Str || '            <title>Strength: Left UE</title>' || LF;
  v_Str := v_Str || '            <answer>' || Matrix_Utils.Get_InfoPathData('Physical_Neuro_Strength_Left_Normal_UE,  Physical_Neuro_Strength_Left_Monoparesis_UE,  Physical_Neuro_Strength_Left_Diminished_Monoplegia_UE',v_CaseId,'ST') || '</answer>' || LF;
  v_Str := v_Str || '        </followUpQuestion>' || LF;
  v_Str := v_Str || '        <followUpQuestion>' || LF;
  v_Str := v_Str || '            <title>Strength: Left LE</title>' || LF;
  v_Str := v_Str || '            <answer>' || Matrix_Utils.Get_InfoPathData('Physical_Neuro_Strength_Left_Normal_LE, Physical_Neuro_Strength_Left_Diminished_Monoplegia_LE,  Physical_Neuro_Strength_Left_Monoparesis_LE',v_CaseId,'ST') || '</answer>' || LF;
  v_Str := v_Str || '        </followUpQuestion>' || LF;
  v_Str := v_Str || '        <followUpQuestion>' || LF;
  v_Str := v_Str || '            <title>Strength Right</title>' || LF;
  v_Str := v_Str || '            <answer>' || Matrix_Utils.Get_InfoPathData('Physical_Neuro_Strength_Right_Hemiplegia,  Physical_Neuro_Strength_Right_Hemiparesis',v_CaseId,'ST') || '</answer>' || LF;
  v_Str := v_Str || '        </followUpQuestion>' || LF;
  v_Str := v_Str || '        <followUpQuestion>' || LF;
  v_Str := v_Str || '            <title>Strength Left</title>' || LF;
  v_Str := v_Str || '            <answer>' || Matrix_Utils.Get_InfoPathData('Physical_Neuro_Strength_Left_Hemiplegia,  Physical_Neuro_Strength_Left_Hemiparesis',v_CaseId,'ST') || '</answer>' || LF;
  v_Str := v_Str || '        </followUpQuestion>' || LF;
  v_Str := v_Str || '        <followUpQuestion>' || LF;
  v_Str := v_Str || '            <title>Paraplegia</title>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('Physical_Neuro_Strength_Paraplegia',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </followUpQuestion>' || LF;
  v_Str := v_Str || '        <followUpQuestion>' || LF;
  v_Str := v_Str || '            <title>Quadriplegia</title>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('Physical_Neuro_Strength_Quadriplegia',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </followUpQuestion>' || LF;
  v_Str := v_Str || '        <followUpQuestion>' || LF;
  v_Str := v_Str || '            <title>Cogwheel rigidity</title>' || LF;
  v_Str := v_Str || '            <answer>' || Matrix_Utils.Get_InfoPathData('Physical_Neuro_Cogwheel',v_CaseId,'ST') || '</answer>' || LF;
  v_Str := v_Str || '        </followUpQuestion>' || LF;
  v_Str := v_Str || '        <followUpQuestion>' || LF;
  v_Str := v_Str || '            <title>Resting (pill rolling) tremor</title>' || LF;
  v_Str := v_Str || '            <answer>' || Matrix_Utils.Get_InfoPathData('Physical_Neuro_Cogwheel_Resting',v_CaseId,'ST') || '</answer>' || LF;
  v_Str := v_Str || '        </followUpQuestion>' || LF;
  v_Str := v_Str || '   </sections>' || LF;
  v_Str := v_Str || '   <sections>' || LF;
  
  
  v_Str := v_Str || '   <sectionTitle>Skin</sectionTitle>' || LF;
  v_Str := v_Str || '        <followUpQuestion>' || LF;
  v_Str := v_Str || '            <title>Rash</title>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('Physical_Skin_Rashes',v_CaseId,'YN') || '</value>' || LF;
  v_Str := v_Str || '                  <secondaryQuestions>' || LF;
  v_Str := v_Str || '                      <title>Describe/Add Color:</title>' || LF;
  v_Str := v_Str || '                      <value>' || Matrix_Utils.Get_InfoPathData('Physical_Skin_Rashes_Describe',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '                  </secondaryQuestions>' || LF;
  v_Str := v_Str || '        </followUpQuestion>' || LF;

  v_Str := v_Str || '        <followUpQuestion>' || LF;
  v_Str := v_Str || '            <title>Lesions</title>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('Physical_Skin_Lesions',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '                  <secondaryQuestions>' || LF;
  v_Str := v_Str || '                      <title>Describe/Add Temperature</title>' || LF;
  v_Str := v_Str || '                      <value>' ||  Matrix_Utils.Get_InfoPathData('Physical_Skin_Describe',v_CaseId,'ST') || '</value>'  || LF;
  v_Str := v_Str || '                  </secondaryQuestions>' || LF;
  v_Str := v_Str || '        </followUpQuestion>' || LF;

---Decubitus Ulcer(s) #1
  v_Str := v_Str || '        <followUpQuestion>' || LF;
  v_Str := v_Str || '          <title>Decubitus Ulcer(s)</title>' || LF;
  v_Str := v_Str || '          <value>' || Matrix_Utils.Get_InfoPathData('Physical_Skin_Decubitus',v_CaseId,'YN') || '</value>' || LF;
  v_Str := v_Str || '              <secondaryQuestions>' || LF;
  v_Str := v_Str || '                  <title>Healed</title>' || LF;
  v_Str := v_Str || '                   <value>' || Matrix_Utils.Get_InfoPathData('Physical_Skin_Decubitus_Healed',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '              </secondaryQuestions>' || LF;
  v_Str := v_Str || '              <secondaryQuestions>' || LF;
  v_Str := v_Str || '                     <title>Location(s) &amp; Stage(s):</title>' || LF;
  v_Str := v_Str || '                     <value>' || Matrix_Utils.Get_InfoPathData('Physical_Skin_Decubitus_Location',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '                  </secondaryQuestions>' || LF;
  v_Str := v_Str || '        </followUpQuestion>' || LF;

---Decubitus Ulcer(s) #2
  v_Str := v_Str || '        <followUpQuestion>' || LF;
  v_Str := v_Str || '          <title>Decubitus Ulcer(s)</title>' || LF;
  v_Str := v_Str || '          <value>' || Matrix_Utils.Get_InfoPathData('Physical_Skin_Decubitus_2',v_CaseId,'YN') || '</value>' || LF;
  v_Str := v_Str || '              <secondaryQuestions>' || LF;
  v_Str := v_Str || '                  <title>Healed</title>' || LF;
  v_Str := v_Str || '                   <value>' || Matrix_Utils.Get_InfoPathData('Physical_Skin_Decubitus_Healed_2',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '              </secondaryQuestions>' || LF;
  v_Str := v_Str || '              <secondaryQuestions>' || LF;
  v_Str := v_Str || '                     <title>Location(s) &amp; Stage(s):</title>' || LF;
  v_Str := v_Str || '                     <value>' || Matrix_Utils.Get_InfoPathData('Physical_Skin_Decubitus_Location_2',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '                  </secondaryQuestions>' || LF;
  v_Str := v_Str || '        </followUpQuestion>' || LF;
  
  v_Str := v_Str || '        <followUpQuestion>' || LF;
  v_Str := v_Str || '          <title>Arterial Ulcer(s)</title>' || LF;
  v_Str := v_Str || '          <value>' || Matrix_Utils.Get_InfoPathData('Physical_Skin_Arterial',v_CaseId,'YN') || '</value>' || LF;
  v_Str := v_Str || '              <secondaryQuestions>' || LF;
  v_Str := v_Str || '                  <title>Healed</title>' || LF;
  v_Str := v_Str || '                   <value>' || Matrix_Utils.Get_InfoPathData('Physical_Skin_Arterial_Healed',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '              </secondaryQuestions>' || LF;
  v_Str := v_Str || '              <secondaryQuestions>' || LF;
  v_Str := v_Str || '                     <title>Location(s):</title>' || LF;
  v_Str := v_Str || '                     <value>' || Matrix_Utils.Get_InfoPathData('Physical_Skin_Arterial_Box',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '                  </secondaryQuestions>' || LF;
  v_Str := v_Str || '        </followUpQuestion>' || LF;
  
  v_Str := v_Str || '        <followUpQuestion>' || LF;
  v_Str := v_Str || '          <title>Venous Ulcer(s)</title>' || LF;
  v_Str := v_Str || '          <value>' || Matrix_Utils.Get_InfoPathData('Physical_Skin_Venous',v_CaseId,'YN') || '</value>' || LF;
  v_Str := v_Str || '              <secondaryQuestions>' || LF;
  v_Str := v_Str || '                  <title>Healed</title>' || LF;
  v_Str := v_Str || '                   <value>' || Matrix_Utils.Get_InfoPathData('Physical_Skin_Venous_Healed',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '              </secondaryQuestions>' || LF;
  v_Str := v_Str || '              <secondaryQuestions>' || LF;
  v_Str := v_Str || '                     <title>Location(s):</title>' || LF;
  v_Str := v_Str || '                     <value>' || Matrix_Utils.Get_InfoPathData('Physical_Skin_Vascular_Box',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '                  </secondaryQuestions>' || LF;
  v_Str := v_Str || '        </followUpQuestion>' || LF;

  
  v_Str := v_Str || '        <followUpQuestion>' || LF;
  v_Str := v_Str || '          <title>Diabetic Ulcer(s)</title>' || LF;
  v_Str := v_Str || '          <value>' || Matrix_Utils.Get_InfoPathData('Physical_Skin_Diabetic',v_CaseId,'YN') || '</value>' || LF;
  v_Str := v_Str || '              <secondaryQuestions>' || LF;
  v_Str := v_Str || '                  <title>Healed</title>' || LF;
  v_Str := v_Str || '                   <value>' || Matrix_Utils.Get_InfoPathData('Physical_Skin_Diabetic_Healed',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '              </secondaryQuestions>' || LF;
  v_Str := v_Str || '              <secondaryQuestions>' || LF;
  v_Str := v_Str || '                     <title>Location(s):</title>' || LF;
  v_Str := v_Str || '                     <value>' || Matrix_Utils.Get_InfoPathData('Physical_Skin_Diabetic_Box',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '                  </secondaryQuestions>' || LF;
  v_Str := v_Str || '        </followUpQuestion>' || LF;
  
 
  
  v_Str := v_Str || '        <followUpQuestion>' || LF;
  v_Str := v_Str || '         <title>Surgical Incision</title>' || LF;
  v_Str := v_Str || '         <value>' || Matrix_Utils.Get_InfoPathData('Physical_Skin_Incision',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '                  <secondaryQuestions>' || LF;
  v_Str := v_Str || '                     <title>Location</title>' || LF;
  v_Str := v_Str || '                     <value>' || Matrix_Utils.Get_InfoPathData('Physical_Skin_Incision',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '                  </secondaryQuestions>' || LF;
  
  v_Str := v_Str || '                  <secondaryQuestions>' || LF;
  v_Str := v_Str || '                     <title>Clean, dry, intact</title>' || LF;
  v_Str := v_Str || '                     <value>' || Matrix_Utils.Get_InfoPathData('Physical_Skin_Incision_Clean',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '                  </secondaryQuestions>' || LF;
  
  v_Str := v_Str || '                  <secondaryQuestions>' || LF;
  v_Str := v_Str || '                     <title>Infected</title>' || LF;
  v_Str := v_Str || '                     <value>' || Matrix_Utils.Get_InfoPathData('Physical_Skin_Incision_Infected',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '                  </secondaryQuestions>' || LF;
  
  v_Str := v_Str || '                  <secondaryQuestions>' || LF;
  v_Str := v_Str || '                     <title>Dehisced</title>' || LF;
  v_Str := v_Str || '                     <value>' || Matrix_Utils.Get_InfoPathData('Physical_Skin_Incision_Dehisced',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '                  </secondaryQuestions>' || LF;
  
  v_Str := v_Str || '                  <secondaryQuestions>' || LF;
  v_Str := v_Str || '                     <title>Healed</title>' || LF;
  v_Str := v_Str || '                     <value>' || Matrix_Utils.Get_InfoPathData('Physical_Skin_Incision_Healed',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '                  </secondaryQuestions>' || LF;

  v_Str := v_Str || '        </followUpQuestion>' || LF;
  v_Str := v_Str || '   </sections>' || LF;
  
  
  v_Str := v_Str || '   <sections>' || LF;
  v_Str := v_Str || '   <sectionTitle>Musculoskeletal</sectionTitle>' || LF;
  v_Str := v_Str || '        <followUpQuestion>' || LF;
  v_Str := v_Str || '            <title>Full Range of Motion</title>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('Physical_MSkel_Motion',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '                  <secondaryQuestions>' || LF;
  v_Str := v_Str || '                         <title>List Limitations:</title>' || LF;
  v_Str := v_Str || '                         <answer>' || Matrix_Utils.Get_InfoPathData('Physical_MSkel_Motion_Limitation',v_CaseId,'ST') || '</answer>' || LF;
  v_Str := v_Str || '                         <value>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '                  </secondaryQuestions>' || LF;
  v_Str := v_Str || '        </followUpQuestion>' || LF;
  v_Str := v_Str || '        <followUpQuestion>' || LF;
  v_Str := v_Str || '            <title>Joints Normal</title>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('Physical_MSkel_Joints',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '                  <secondaryQuestions>' || LF;
  v_Str := v_Str || '                         <title>Abnormality</title>' || LF;
  v_Str := v_Str || '                         <answer>' || Matrix_Utils.Get_InfoPathData('Physical_MSkel_Joints_Abnormality',v_CaseId,'ST') || '</answer>' || LF;
  v_Str := v_Str || '                         <value>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '                  </secondaryQuestions>' || LF;
  v_Str := v_Str || '        </followUpQuestion>' || LF;
--  v_Str := v_Str || '        <followUpQuestion>' || LF;
--  v_Str := v_Str || '                  <secondaryQuestions>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</secondaryQuestions>' || LF;
  -- v_Str := v_Str || '        </followUpQuestion>' || LF;
  v_Str := v_Str || '        <followUpQuestion>' || LF;
  v_Str := v_Str || '            <title>Hands: Ulnar Deviation</title>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('Physical_MSkel_Hands_Ulnar',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </followUpQuestion>' || LF;
--  v_Str := v_Str || '        <followUpQuestion>' || LF;
--  v_Str := v_Str || '            <title>Hands: MCP joint bony enlargement</title>' || LF;
--  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
--  v_Str := v_Str || '        </followUpQuestion>' || LF;
  v_Str := v_Str || '        <followUpQuestion>' || LF;
  v_Str := v_Str || '            <title>PIP joint swelling</title>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('Physical_MSkel_Hands_Pip',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </followUpQuestion>' || LF;
  v_Str := v_Str || '        <followUpQuestion>' || LF;
  v_Str := v_Str || '            <title>DIP joint bony enlargement</title>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('Physical_MSkel_Hands_Dip',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </followUpQuestion>' || LF;
  v_Str := v_Str || '        <followUpQuestion>' || LF;
  v_Str := v_Str || '         <title>Amputation</title>' || LF;
  v_Str := v_Str || '              <answer>' || Matrix_Utils.Get_InfoPathData('Physical_MSkel_Amputation',v_CaseId,'ST') || '</answer>' || LF;
  --SHOULD BE OTHER TEXT: v_Str := v_Str || '                         <title>Location</title>'  || LF;
  v_Str := v_Str || '               <value>' || Matrix_Utils.Get_InfoPathData('Physical_MSkel_Left_Aka, Physical_MSkel_Left_Bka, Physical_MSkel_Left_Great_Toe,  Physical_MSkel_Left_Other_Toes,  
                                                                          Physical_MSkel_Right_Aka,  Physical_MSkel_Right_Bka,  Physical_MSkel_Right_Great_Toe,  Physical_MSkel_Right_Other_Toes',
																		   v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </followUpQuestion>' || LF;
  v_Str := v_Str || '        <followUpQuestion>' || LF;
  v_Str := v_Str || '            <title>Get up and Go</title>' || LF;
  v_Str := v_Str || '            <answer>' || Matrix_Utils.Get_InfoPathData('Physical_MSkel_Get_Up_Pass,  Physical_MSkel_Get_Up_Assessment,  Physical_MSkel_Get_Up_Perform',v_CaseId,'ST') || '</answer>' || LF;
  v_Str := v_Str || '        </followUpQuestion>' || LF;
  v_Str := v_Str || '   </sections>' || LF;
  v_Str := v_Str || '   <sections>' || LF;
  v_Str := v_Str || '   <sectionTitle>Abdomen</sectionTitle>' || LF;
  v_Str := v_Str || '        <followUpQuestion>' || LF;
  v_Str := v_Str || '            <title>Soft?</title>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('Physical_Abd_Soft',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </followUpQuestion>' || LF;
  v_Str := v_Str || '        <followUpQuestion>' || LF;
  v_Str := v_Str || '            <title>Non-tender?</title>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('Physical_Abd_Non_Tender',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </followUpQuestion>' || LF;
  v_Str := v_Str || '        <followUpQuestion>' || LF;
  v_Str := v_Str || '            <title>Distended?</title>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </followUpQuestion>' || LF;
  v_Str := v_Str || '        <followUpQuestion>' || LF;
  v_Str := v_Str || '            <title>Bowel sounds normal?</title>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('Physical_Abd_Bowel_Sounds_Normal',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </followUpQuestion>' || LF;
  v_Str := v_Str || '        <followUpQuestion>' || LF;
  v_Str := v_Str || '            <title>Masses?</title>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('Physical_Abd_Masses',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '                  <secondaryQuestions>' || LF;
  v_Str := v_Str || '                         <title>Select Location</title>' || LF;
  --v_Str := v_Str || '                         <answer>' || Matrix_Utils.Get_InfoPathData('Physical_Abd_Masses_Describe',v_CaseId,'ST') || '</answer>' || LF;
  v_Str := v_Str || '                         <value>' || Matrix_Utils.Get_InfoPathData('Physical_Abd_Masses_Describe',v_CaseId,'ST') || '</value>' || LF;
  -- MISSING VALUE
  v_Str := v_Str || '                  </secondaryQuestions>' || LF;
  v_Str := v_Str || '                  <secondaryQuestions>' || LF;
  v_Str := v_Str || '                         <title>Select Consistency</title>' || LF;
  v_Str := v_Str || '                         <answer>' ||  Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</answer>'  || LF;
  v_Str := v_Str || '                         <value>' ||  Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</value>'  || LF;
  --MISSING OTHERVALUE v_Str := v_Str || '                         <otherValue>' ||  Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</otherValue>'  || LF;
  v_Str := v_Str || '                  </secondaryQuestions>' || LF;
  v_Str := v_Str || '        </followUpQuestion>' || LF;
  v_Str := v_Str || '        <followUpQuestion>' || LF;
  v_Str := v_Str || '            <title>Presence of ostomies?</title>' || LF;
  v_Str := v_Str || '            <answer>' || Matrix_Utils.Get_InfoPathData('Physical_Abd_Presence_Peg
 +Physical_Abd_Presence_Colostomy
 +Physical_Abd_Presence_Ileostomy
 +Physical_Abd_Presence_Cystectomy',v_CaseId,'CT') || '</answer>' || LF;
  v_Str := v_Str || '        </followUpQuestion>' || LF;
  v_Str := v_Str || '   </sections>' || LF;
  v_Str := v_Str || '   <sections>' || LF;
  v_Str := v_Str || '   <sectionTitle>Pulmonary</sectionTitle>' || LF;
  v_Str := v_Str || '        <followUpQuestion>' || LF;
  v_Str := v_Str || '            <title>On O2</title>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('Physical_Pulm_O2',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '                  <secondaryQuestions>' || LF;
  v_Str := v_Str || '                         <title>How much O2 (liters/minute)?</title>' || LF;
  v_Str := v_Str || '                         <answer>' ||  Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</answer>'  || LF;
  v_Str := v_Str || '                         <value>' ||  Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</value>'  || LF;
  v_Str := v_Str || '                  </secondaryQuestions>' || LF;
  v_Str := v_Str || '                  <secondaryQuestions>' || LF;
  v_Str := v_Str || '                         <title>Is Continuous?</title>' || LF;
  v_Str := v_Str || '                         <answer>' || Matrix_Utils.Get_InfoPathData('Physical_Pulm_O2_Continuous',v_CaseId,'YN') || '</answer>' || LF;
  v_Str := v_Str || '                         <value>' ||  Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</value>'  || LF;
  v_Str := v_Str || '                  </secondaryQuestions>' || LF;
  v_Str := v_Str || '        </followUpQuestion>' || LF;
  v_Str := v_Str || '        <followUpQuestion>' || LF;
  v_Str := v_Str || '            <title>Lungs Clear Bilaterally</title>' || LF;
  v_Str := v_Str || '            <answer>' || Matrix_Utils.Get_InfoPathData('Physical_Pulm_Lungs_Clear',v_CaseId,'YN') || '</answer>' || LF;
  v_Str := v_Str || '        </followUpQuestion>' || LF;
  v_Str := v_Str || '        <followUpQuestion>' || LF;
  v_Str := v_Str || '            <title>Wheezes</title>' || LF;
  v_Str := v_Str || '            <answer>' || Matrix_Utils.Get_InfoPathData('Physical_Pulm_Lungs_Wheezes',v_CaseId,'TF') || '</answer>' || LF;
  v_Str := v_Str || '        </followUpQuestion>' || LF;
  v_Str := v_Str || '        <followUpQuestion>' || LF;
  v_Str := v_Str || '            <title>Rales</title>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('Physical_Pulm_Lungs_Rales',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '        </followUpQuestion>' || LF;
  v_Str := v_Str || '        <followUpQuestion>' || LF;
  v_Str := v_Str || '            <title>Rhonchi</title>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('Physical_Pulm_Lungs_Rhonchi',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '        </followUpQuestion>' || LF;
  v_Str := v_Str || '        <followUpQuestion>' || LF;
  v_Str := v_Str || '            <title>Respiratory Effort Normal</title>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('Physical_Pulm_Resp_Effort',v_CaseId,'YN') || '</value>' || LF;
  v_Str := v_Str || '        </followUpQuestion>' || LF;
  v_Str := v_Str || '        <followUpQuestion>' || LF;
  v_Str := v_Str || '            <title>Breath sounds decreased</title>' || LF;
  --MISSING VALUEv_Str := v_Str || '            <value>' ||  Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</value>'  || LF;
  v_Str := v_Str || '        </followUpQuestion>' || LF;
  v_Str := v_Str || '   </sections>' || LF;
  v_Str := v_Str || '   <sections>' || LF;
  v_Str := v_Str || '   <sectionTitle>Cardiovascular</sectionTitle>' || LF;
  v_Str := v_Str || '        <followUpQuestion>' || LF;
  v_Str := v_Str || '            <title>Heart Rhythm</title>' || LF;
  v_Str := v_Str || '            <answer>' || Matrix_Utils.Get_InfoPathData('Physical_CV_Heart_Regular,  Physical_CV_Heart_Irregular',v_CaseId,'ST') || '</answer>' || LF;
  v_Str := v_Str || '        </followUpQuestion>' || LF;
  v_Str := v_Str || '        <followUpQuestion>' || LF;
  v_Str := v_Str || '            <title>Murmur</title>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('Physical_CV_Murmur',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </followUpQuestion>' || LF;
  v_Str := v_Str || '        <followUpQuestion>' || LF;
  v_Str := v_Str || '            <title>Carotid bruits</title>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('Physical_CV_Carotid',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '                  <secondaryQuestions>' || LF;
  v_Str := v_Str || '                         <title>Right or Left?</title>' || LF;
  v_Str := v_Str || '                         <answer>' || Matrix_Utils.Get_InfoPathData('Physical_CV_Carotid_Right+Physical_CV_Carotid_Left',v_CaseId,'LF') || '</answer>' || LF;
  v_Str := v_Str || '                         <value>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '                  </secondaryQuestions>' || LF;
  v_Str := v_Str || '        </followUpQuestion>' || LF;
  v_Str := v_Str || '        <followUpQuestion>' || LF;
  v_Str := v_Str || '            <title>Jugular venous distension</title>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('Physical_CV_Carotid_Jugular',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </followUpQuestion>' || LF;
  
  v_Str := v_Str || '        <followUpQuestion>' || LF;
  v_Str := v_Str || '            <title>Lower Extremity Edema</title>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('Physical_CV_Edema',v_CaseId,'YN') || '</value>' || LF;

  v_Str := v_Str || '                  <secondaryQuestions>' || LF;
  v_Str := v_Str || '                         <title>1+</title>' || LF;
  v_Str := v_Str || '                         <answer>' || Matrix_Utils.Get_InfoPathData('Physical_CV_Edema_1',v_CaseId,'YN') || '</answer>' || LF;
  v_Str := v_Str || '                         <value>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '                  </secondaryQuestions>' || LF;

  v_Str := v_Str || '                  <secondaryQuestions>' || LF;
  v_Str := v_Str || '                         <title>2+</title>' || LF;
  v_Str := v_Str || '                         <answer>' || Matrix_Utils.Get_InfoPathData('Physical_CV_Edema_2',v_CaseId,'YN') || '</answer>' || LF;
  v_Str := v_Str || '                         <value>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '                  </secondaryQuestions>' || LF;

  v_Str := v_Str || '                  <secondaryQuestions>' || LF;
  v_Str := v_Str || '                         <title>3+</title>' || LF;
  v_Str := v_Str || '                         <answer>' || Matrix_Utils.Get_InfoPathData('Physical_CV_Edema_3',v_CaseId,'YN') || '</answer>' || LF;
  v_Str := v_Str || '                         <value>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '                  </secondaryQuestions>' || LF;
  v_Str := v_Str || '        </followUpQuestion>' || LF;

--  v_Str := v_Str || '                  <secondaryQuestions>' || LF;
--  v_Str := v_Str || '                         <title>Pitting Edema Type:</title>' || LF;
--  v_Str := v_Str || '                         <answer>' || Matrix_Utils.Get_InfoPathData('Physical_CV_Edema_1',v_CaseId,'ST') || '</answer>' || LF;
--  v_Str := v_Str || '                         <value>' || Matrix_Utils.Get_InfoPathData('Physical_CV_Edema_2',v_CaseId,'ST') || '</value>' || LF;
--  v_Str := v_Str || '                  </secondaryQuestions>' || LF;


  --v_Str := v_Str || '                  <secondaryQuestions>' ||  Matrix_Utils.Get_InfoPathData('Physical_CV_Edema_3',v_CaseId,'ST') || '</secondaryQuestions>'  || LF;
  --v_Str := v_Str || '                  <secondaryQuestions>' ||  Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</secondaryQuestions>'  || LF;
  v_Str := v_Str || '        <followUpQuestion>' || LF;
  v_Str := v_Str || '            <title>Lower extremity pulse: Right DP</title>' || LF;
  v_Str := v_Str || '            <answer>' || Matrix_Utils.Get_InfoPathData('Physical_CV_Pulses_Right_Normal_DP,  Physical_CV_Pulses_Right_Dimished_DP',v_CaseId,'ST') || '</answer>' || LF;
  v_Str := v_Str || '        </followUpQuestion>' || LF;
  v_Str := v_Str || '        <followUpQuestion>' || LF;
  v_Str := v_Str || '            <title>Lower extremity pulse: Right PT</title>' || LF;
  v_Str := v_Str || '            <answer>' || Matrix_Utils.Get_InfoPathData('Physical_CV_Pulses_Right_Normal_PT,  Physical_CV_Pulses_Right_Dimished_PT',v_CaseId,'ST') || '</answer>' || LF;
  v_Str := v_Str || '        </followUpQuestion>' || LF;
  v_Str := v_Str || '        <followUpQuestion>' || LF;
  v_Str := v_Str || '            <title>Lower extremity pulse: Left DP</title>' || LF;
  v_Str := v_Str || '            <answer>' || Matrix_Utils.Get_InfoPathData('Physical_CV_Pulses_Left_Normal_DP,  Physical_CV_Pulses_Left_Dimished_DP',v_CaseId,'ST') || '</answer>' || LF;
  v_Str := v_Str || '        </followUpQuestion>' || LF;
  v_Str := v_Str || '        <followUpQuestion>' || LF;
  v_Str := v_Str || '            <title>Lower extremity pulse: Left PT</title>' || LF;
  v_Str := v_Str || '            <answer>' || Matrix_Utils.Get_InfoPathData('Physical_CV_Pulses_Left_Normal_PT,  Physical_CV_Pulses_Left_Dimished_PT',v_CaseId,'ST') || '</answer>' || LF;
  v_Str := v_Str || '        </followUpQuestion>' || LF;
  v_Str := v_Str || '        <followUpQuestion>' || LF;
  v_Str := v_Str || '            <title>Arterio-venous (AV) fistula or graft</title>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('Physical_CV_AV',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </followUpQuestion>' || LF;
  v_Str := v_Str || '   </sections>' || LF;
  
  v_Str := v_Str || '   <sections>' || LF;
  v_Str := v_Str || '   <sectionTitle>Lymph</sectionTitle>' || LF;
  v_Str := v_Str || '        <followUpQuestion>' || LF;
  v_Str := v_Str || '            <title>Lymphadenopathy: neck</title>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('Physical_Lymph',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </followUpQuestion>' || LF;
  --v_Str := v_Str || '        <followUpQuestion>' || LF;
  --v_Str := v_Str || '            <title>Lymphadenopathy: axila</title>'  || LF;
  --MISSING VALUE v_Str := v_Str || '            <value>' ||  Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</value>'  || LF;
  --v_Str := v_Str || '        <followUpQuestion>' || LF;
  --v_Str := v_Str || '            <title>Lymphadenopathy: groin</title>'  || LF;
  --MISSING VALUE v_Str := v_Str || '            <value>' ||  Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</value>'  || LF;
  --v_Str := v_Str || '        </followUpQuestion>' || LF;
  v_Str := v_Str || '        <followUpQuestion>' || LF;
  v_Str := v_Str || '            <title>Lymphadenopathy: other</title>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('Physical_Lymph_Other_Specify',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '                  <secondaryQuestions>' || LF;
  v_Str := v_Str || '                         <title>Location</title>' || LF;
  v_Str := v_Str || '                         <answer>' ||  Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</answer>'  || LF;
  v_Str := v_Str || '                         <value>' ||  Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</value>'  || LF;
  v_Str := v_Str || '                  </secondaryQuestions>' || LF;
  v_Str := v_Str || '        </followUpQuestion>' || LF;
  v_Str := v_Str || '   </sections>' || LF;
  
  v_Str := v_Str || '   <sections>' || LF;
  v_Str := v_Str || '   <sectionTitle>Neck</sectionTitle>' || LF;
  v_Str := v_Str || '        <followUpQuestion>' || LF;
  v_Str := v_Str || '            <title>Surgical scar</title>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('Physical_Neck_Surg',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '                  <secondaryQuestions>' || LF;
  v_Str := v_Str || '                         <title>Location</title>' || LF;
  v_Str := v_Str || '                         <answer>' || Matrix_Utils.Get_InfoPathData('Physical_Neck_Surg_Location',v_CaseId,'ST') || '</answer>' || LF;
  v_Str := v_Str || '                         <value>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '                  </secondaryQuestions>' || LF;
  v_Str := v_Str || '        </followUpQuestion>' || LF;
  v_Str := v_Str || '        <followUpQuestion>' || LF;
  v_Str := v_Str || '            <title>Trachea midline</title>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('Physical_Neck_Trachea',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </followUpQuestion>' || LF;
  v_Str := v_Str || '        <followUpQuestion>' || LF;
  v_Str := v_Str || '            <title>Tracheostomy present</title>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('Physical_Neck_Tracheostomy',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </followUpQuestion>' || LF;
  v_Str := v_Str || '   </sections>' || LF;
  
  v_Str := v_Str || '   <otherFindings>' || LF;
  v_Str := v_Str || '      <label>Other pertinent findings on physical exam</label>' || LF;
  v_Str := v_Str || '      <date>' || Matrix_Utils.Get_InfoPathData('Physical_Psych_Repeating_Table',v_CaseId,'ST') 
                 || '</date>' || LF;  --- Artifact - is "date", not "data"  
  v_Str := v_Str || '    </otherFindings>' || LF;
  
  v_Str := v_Str || '   </PhysicalExam>' || LF;
  ------------------------------------
  RETURN v_Str;
EXCEPTION
WHEN OTHERS THEN
  dbms_output.put_line('MATRIX_XML_PHYEXAM:' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || CHR(13) || SQLERRM );
  --v_Str := v_str || SUBSTR(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || CHR(13) || SQLERRM,1,4000);
  
  RAISE;
END MATRIX_XML_PHYEXAM;



FUNCTION MATRIX_XML_PROVASSMT(
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
  v_Str := v_Str || '<ProviderAssessment>' || LF;



  v_Str := v_Str || ' <sectionTitle>Provider''s Assessment and Diagnosis of the Patient</sectionTitle>' || LF;
  --v_Str := v_Str || ' <groupedQuestions></groupedQuestions>'|| LF;  --- xxx Placeholder, no value mapped
  v_Str := v_Str || ' <sections>'|| LF;
  v_Str := v_Str || '   <title>Cardiovascular</title>' || LF;
  v_Str := v_Str || '   <diagnosis>'|| LF;
  v_Str := v_Str || '    <title>Hypertension</title>' || LF;
  v_Str := v_Str || '    <value>' || Matrix_Utils.Get_InfoPathData('PA_Cardio_Hypertension',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '        <followupQuestions>'|| LF;
  v_Str := v_Str || '            <title>Type:</title>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('PA_Cardio_Benign + PA_Cardio_Unspecified',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </followupQuestions>'|| LF;
   v_Str := v_Str || '        <managementPlan>' || Matrix_Utils.Get_InfoPathData('PA_Cardio_Plan_E1
+PA_Cardio_Plan_E2
+PA_Cardio_Plan_E3
+PA_Cardio_Plan_E4
+PA_Cardio_Plan_E5
+PA_Cardio_Plan_M1
+PA_Cardio_Plan_M2
+PA_Cardio_Plan_M3
+PA_Cardio_Plan_R1
+PA_Cardio_Plan_R2',v_CaseId,  'MP') || '</managementPlan>' || LF;

  
  
  v_Str := v_Str || '        <followupQuestions>' || LF;
  v_Str := v_Str || '            <title>Heart Disease related to hypertension:</title>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('PA_Cardio_Heart_Disease',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '        <managementPlan>' || Matrix_Utils.Get_InfoPathData('PA_Cardio_Heart_Disease_Plan_E1 
  + PA_Cardio_Heart_Disease_Plan_E2 
  + PA_Cardio_Heart_Disease_Plan_E3 
  + PA_Cardio_Heart_Disease_Plan_E4+ PA_Cardio_Heart_Disease_Plan_E5 
  + PA_Cardio_Heart_Disease_Plan_M1 + PA_Cardio_Heart_Disease_Plan_M2 
  + PA_Cardio_Heart_Disease_Plan_M3 + PA_Cardio_Heart_Disease_Plan_R1 
  + PA_Cardio_Heart_Disease_Plan_R2',v_CaseId,  'MP') || '</managementPlan>' || LF;
    v_Str := v_Str || '        </followupQuestions>'|| LF;
  
    v_Str := v_Str || '        <followupQuestions>' || LF;
    v_Str := v_Str || '            <title>Heart Failure</title>' || LF;
    v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('PA_Cardio_With_Heart_Failure + PA_Cardio_Without_Heart_Failure',v_CaseId,'TF') || '</value>' || LF;
	v_Str := v_Str || '        </followupQuestions>'|| LF;
    v_Str := v_Str || '        <managementPlan>' || Matrix_Utils.Get_InfoPathData('PA_Cardio_Heart_Failure_Plan_E1
+PA_Cardio_Heart_Failure_Plan_E2
+PA_Cardio_Heart_Failure_Plan_E3
+PA_Cardio_Heart_Failure_Plan_E4
+PA_Cardio_Heart_Failure_Plan_E5
+PA_Cardio_Heart_Failure_Plan_M1
+PA_Cardio_Heart_Failure_Plan_M2
+PA_Cardio_Heart_Failure_Plan_M3
+PA_Cardio_Heart_Failure_Plan_R1
+PA_Cardio_Heart_Failure_Plan_R2',v_CaseId,  'MP') || '</managementPlan>' || LF;

--I changed PA_Cardio_Plan_XX to PA_Cardio_Heart_Disease_Plan_XX.  PA_Cardio_Plan_XX should be matched up with "PA_Cardio_Hypertension" above
  v_Str := v_Str || '   </diagnosis>' || LF;
    
  v_Str := v_Str || '   <diagnosis>' || LF;
  v_Str := v_Str || '    <title>Congestive Heart Failure</title>' || LF;
  v_Str := v_Str || '    <value>' || Matrix_Utils.Get_InfoPathData('PA_Cardio_Congestive_Heart_Failure',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '    <managementPlan>' || Matrix_Utils.Get_InfoPathData('PA_Cardio_Congestive_Heart_Failure_Plan_E1' ||'+ PA_Cardio_Congestive_Heart_Failure_Plan_E2' ||'+ PA_Cardio_Congestive_Heart_Failure_Plan_E3' ||'+ PA_Cardio_Congestive_Heart_Failure_Plan_E4' ||'+ PA_Cardio_Congestive_Heart_Failure_Plan_E5' ||'+ PA_Cardio_Congestive_Heart_Failure_Plan_M1' ||'+ PA_Cardio_Congestive_Heart_Failure_Plan_M2' ||'+ PA_Cardio_Congestive_Heart_Failure_Plan_M3' ||'+ PA_Cardio_Congestive_Heart_Failure_Plan_R1' ||'+ PA_Cardio_Congestive_Heart_Failure_Plan_R2',v_CaseId,'ST') || '</managementPlan>' || LF;
  v_Str := v_Str || '   </diagnosis>' || LF;
  
  v_Str := v_Str || '   <diagnosis>' || LF;
  v_Str := v_Str || '    <title>Left Heart failure</title>' || LF;
  v_Str := v_Str || '    <value>' || Matrix_Utils.Get_InfoPathData('PA_Cardio_Left_Heart_Failure',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '        <managementPlan>' || Matrix_Utils.Get_InfoPathData('PA_Cardio_Left_Heart_Failure_Plan_E1' ||'+ PA_Cardio_Left_Heart_Failure_Plan_E2' ||'+ PA_Cardio_Left_Heart_Failure_Plan_E3' ||'+ PA_Cardio_Left_Heart_Failure_Plan_E4' ||'+ PA_Cardio_Left_Heart_Failure_Plan_E5' ||'+ PA_Cardio_Left_Heart_Failure_Plan_M1' ||'+ PA_Cardio_Left_Heart_Failure_Plan_M2' ||'+ PA_Cardio_Left_Heart_Failure_Plan_M3' ||'+ PA_Cardio_Left_Heart_Failure_Plan_R1' ||'+ PA_Cardio_Left_Heart_Failure_Plan_R2',v_CaseId,'MP') || '</managementPlan>' || LF;
  v_Str := v_Str || '   </diagnosis>' || LF;
  
  v_Str := v_Str || '   <diagnosis>' || LF;
  v_Str := v_Str || '        <title>Systolic Heart Failure</title>' || LF;
  v_Str := v_Str || '        <value>' || Matrix_Utils.Get_InfoPathData(' PA_Cardio_Systolic_Heart_Failure ',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '        <managementPlan>' || Matrix_Utils.Get_InfoPathData('PA_Cardio_Systolic_Heart_Failure_Plan_E1' ||'+ PA_Cardio_Systolic_Heart_Failure_Plan_E2' ||'+ PA_Cardio_Systolic_Heart_Failure_Plan_E3' ||'+ PA_Cardio_Systolic_Heart_Failure_Plan_E4' ||'+ PA_Cardio_Systolic_Heart_Failure_Plan_E5' ||'+ PA_Cardio_Systolic_Heart_Failure_Plan_M1' ||'+ PA_Cardio_Systolic_Heart_Failure_Plan_M2' ||'+ PA_Cardio_Systolic_Heart_Failure_Plan_M3' ||'+ PA_Cardio_Systolic_Heart_Failure_Plan_R1' ||'+ PA_Cardio_Systolic_Heart_Failure_Plan_R2',v_CaseId,'MP') || '</managementPlan>' || LF;
  v_Str := v_Str || '   </diagnosis>' || LF;
  
  v_Str := v_Str || '   <diagnosis>' || LF;
  v_Str := v_Str || '    <title>Diastolic Heart Failure</title>' || LF;
  v_Str := v_Str || '        <value>' || Matrix_Utils.Get_InfoPathData('PA_Cardio_Diastolic_Heart_Failure',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '        <managementPlan>' || Matrix_Utils.Get_InfoPathData('PA_Cardio_Diastolic_Heart_Failure_Plan_E1' ||'+ PA_Cardio_Diastolic_Heart_Failure_Plan_E2' ||'+ PA_Cardio_Diastolic_Heart_Failure_Plan_E3' ||'+ PA_Cardio_Diastolic_Heart_Failure_Plan_E4' ||'+ PA_Cardio_Diastolic_Heart_Failure_Plan_E5' ||'+ PA_Cardio_Diastolic_Heart_Failure_Plan_M1' ||'+ PA_Cardio_Diastolic_Heart_Failure_Plan_M2' ||'+ PA_Cardio_Diastolic_Heart_Failure_Plan_M3' ||'+ PA_Cardio_Diastolic_Heart_Failure_Plan_R1' ||'+ PA_Cardio_Diastolic_Heart_Failure_Plan_R2',v_CaseId,'MP') || '</managementPlan>' || LF;
  v_Str := v_Str || '   </diagnosis>' || LF;
  
  v_Str := v_Str || '   <diagnosis>' || LF;
  v_Str := v_Str || '    <title>Combined Systolic and Diastolic Heart Failure</title>' || LF;
  v_Str := v_Str || '    <value>' || Matrix_Utils.Get_InfoPathData('PA_Cardio_Combined_Heart_Failure',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '        <managementPlan>' || Matrix_Utils.Get_InfoPathData('PA_Cardio_Combined_Heart_Failure_Plan_E1' ||'+ PA_Cardio_Combined_Heart_Failure_Plan_E2' ||'+ PA_Cardio_Combined_Heart_Failure_Plan_E3' ||'+ PA_Cardio_Combined_Heart_Failure_Plan_E4' ||'+ PA_Cardio_Combined_Heart_Failure_Plan_E5' ||'+ PA_Cardio_Combined_Heart_Failure_Plan_M1' ||'+ PA_Cardio_Combined_Heart_Failure_Plan_M2' ||'+ PA_Cardio_Combined_Heart_Failure_Plan_M3' ||'+ PA_Cardio_Combined_Heart_Failure_Plan_R1' ||'+ PA_Cardio_Combined_Heart_Failure_Plan_R2',v_CaseId,'MP') || '</managementPlan>' || LF;
  v_Str := v_Str || '   </diagnosis>' || LF;
  
  v_Str := v_Str || '   <diagnosis>' || LF;
  v_Str := v_Str || '    <title>Cardiomyopathy</title>' || LF;
  v_Str := v_Str || '    <value>' || Matrix_Utils.Get_InfoPathData('PA_Cardio_Cardiomyopathy',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '        <managementPlan>' || Matrix_Utils.Get_InfoPathData('PA_Cardio_Cardiomyopathy_Plan_E1' ||'+ PA_Cardio_Cardiomyopathy_Plan_E2' ||'+ PA_Cardio_Cardiomyopathy_Plan_E3' ||'+ PA_Cardio_Cardiomyopathy_Plan_E4' ||'+ PA_Cardio_Cardiomyopathy_Plan_E5' ||'+ PA_Cardio_Cardiomyopathy_Plan_M1' ||'+ PA_Cardio_Cardiomyopathy_Plan_M2' ||'+ PA_Cardio_Cardiomyopathy_Plan_M3' ||'+ PA_Cardio_Cardiomyopathy_Plan_R1' ||'+ PA_Cardio_Cardiomyopathy_Plan_R2',v_CaseId,'MP') || '</managementPlan>' || LF;
  v_Str := v_Str || '   </diagnosis>' || LF;
  
  v_Str := v_Str || '   <diagnosis>' || LF;
  v_Str := v_Str || '    <title>Cardiomegaly</title>' || LF;
  v_Str := v_Str || '    <value>' || Matrix_Utils.Get_InfoPathData('PA_Cardio_Cardiomegaly',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '        <managementPlan>' || Matrix_Utils.Get_InfoPathData('PA_Cardio_Cardiomegaly_Plan_E1' ||'+ PA_Cardio_Cardiomegaly_Plan_E2' ||'+ PA_Cardio_Cardiomegaly_Plan_E3' ||'+ PA_Cardio_Cardiomegaly_Plan_E4' ||'+ PA_Cardio_Cardiomegaly_Plan_E5' ||'+ PA_Cardio_Cardiomegaly_Plan_M1' ||'+ PA_Cardio_Cardiomegaly_Plan_M2' ||'+ PA_Cardio_Cardiomegaly_Plan_M3' ||'+ PA_Cardio_Cardiomegaly_Plan_R1' ||'+ PA_Cardio_Cardiomegaly_Plan_R2',v_CaseId,'MP') || '</managementPlan>' || LF;
  v_Str := v_Str || '   </diagnosis>' || LF;
  
  v_Str := v_Str || '   <diagnosis>' || LF;
  v_Str := v_Str || '    <title>Edema (current only)</title>' || LF;
  v_Str := v_Str || '    <value>' || Matrix_Utils.Get_InfoPathData('PA_Cardio_Edema',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '        <managementPlan>' || Matrix_Utils.Get_InfoPathData('PA_Cardio_Edema_Plan_E1' ||'+ PA_Cardio_Edema_Plan_E2' ||'+ PA_Cardio_Edema_Plan_E3' ||'+ PA_Cardio_Edema_Plan_E4' ||'+ PA_Cardio_Edema_Plan_E5' ||'+ PA_Cardio_Edema_Plan_M1' ||'+ PA_Cardio_Edema_Plan_M2' ||'+ PA_Cardio_Edema_Plan_M3' ||'+ PA_Cardio_Edema_Plan_R1' ||'+ PA_Cardio_Edema_Plan_R2',v_CaseId,'MP') || '</managementPlan>' || LF;
  v_Str := v_Str || '   </diagnosis>' || LF;
  
  v_Str := v_Str || '   <diagnosis>' || LF;
  v_Str := v_Str || '    <title>Hypotension</title>' || LF;
  v_Str := v_Str || '    <value>' || Matrix_Utils.Get_InfoPathData('PA_Cardio_Hypotension',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '        <followupQuestions>' || LF;
  v_Str := v_Str || '            <title>Type:</title>' || LF;
  v_Str := v_Str || '            <answer>' || Matrix_Utils.Get_InfoPathData('PA_Cardio_Hypotension_Chronic',v_CaseId,'ST') || '</answer>' || LF;
  --v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('PA_Cardio_Hypotension_Chronic',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </followupQuestions>'|| LF;
  v_Str := v_Str || '        <followupQuestions>' || LF;
  v_Str := v_Str || '            <title>Type:</title>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('PA_Cardio_Hypotension_Orthostatic',v_CaseId,'ST') || '</value>' || LF;
  --v_Str := v_Str || '            <answer>' || Matrix_Utils.Get_InfoPathData('PA_Cardio_Hypotension_Orthostatic',v_CaseId,'ST') || '</answer>' || LF;
  v_Str := v_Str || '        </followupQuestions>'|| LF;
  v_Str := v_Str || '        <managementPlan>' || Matrix_Utils.Get_InfoPathData('PA_Cardio_Hypotension_Plan_E1' ||'+ PA_Cardio_Hypotension_Plan_E2' ||'+ PA_Cardio_Hypotension_Plan_E3' ||'+ PA_Cardio_Hypotension_Plan_E4' ||'+ PA_Cardio_Hypotension_Plan_E5' ||'+ PA_Cardio_Hypotension_Plan_M1' ||'+ PA_Cardio_Hypotension_Plan_M2' ||'+ PA_Cardio_Hypotension_Plan_M3' ||'+ PA_Cardio_Hypotension_Plan_R1' ||'+ PA_Cardio_Hypotension_Plan_R2',v_CaseId,'MP') || '</managementPlan>' || LF;
  v_Str := v_Str || '   </diagnosis>' || LF;
  
  v_Str := v_Str || '   <diagnosis>' || LF;
  v_Str := v_Str || '    <title>Syncope</title>' || LF;
  v_Str := v_Str || '        <value>' || Matrix_Utils.Get_InfoPathData('PA_Cardio_Syncope',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '        <managementPlan>' || Matrix_Utils.Get_InfoPathData('PA_Cardio_Syncope_Plan_E1' ||'+ PA_Cardio_Syncope_Plan_E2' ||'+ PA_Cardio_Syncope_Plan_E3' ||'+ PA_Cardio_Syncope_Plan_E4' ||'+ PA_Cardio_Syncope_Plan_E5' ||'+ PA_Cardio_Syncope_Plan_M1' ||'+ PA_Cardio_Syncope_Plan_M2' ||'+ PA_Cardio_Syncope_Plan_M3' ||'+ PA_Cardio_Syncope_Plan_R1' ||'+ PA_Cardio_Syncope_Plan_R2',v_CaseId,'MP') || '</managementPlan>' || LF;
  v_Str := v_Str || '   </diagnosis>' || LF;
  
  v_Str := v_Str || '   <diagnosis>' || LF;
  v_Str := v_Str || '        <title>Arrhythmia</title>' || LF;
  v_Str := v_Str || '        <value>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        <followupQuestions>' || LF;
  v_Str := v_Str || '         <title>Arrhythmia Type:</title>' || LF;
  --- check below line
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('PA_Cardio_Arrhythmia_Atrial_Fibrillation + PA_Cardio_Arrhythmia_Supraventricular_Tachycardia + PA_Cardio_Sick_Sinus_Syndrome',v_CaseId,'ST') || '</value>' || LF;
 -- v_Str := v_Str || '            <answer>' || Matrix_Utils.Get_InfoPathData('PA_Cardio_Arrhythmia_Atrial_Fibrillation + PA_Cardio_Arrhythmia_Supraventricular_Tachycardia + PA_Cardio_Sick_Sinus_Syndrome',v_CaseId,'ST') || '</answer>' || LF;
  v_Str := v_Str || '            <otherValue>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</otherValue>' || LF;
  v_Str := v_Str || '        </followupQuestions>'|| LF;
  v_Str := v_Str || '        <followupQuestions>' || LF;
  v_Str := v_Str || '            <title>Arrhythmia Type:</title>' || LF;
  v_Str := v_Str || '            <answer>' || 'Other' || '</answer>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('PA_Cardio_Arrhythmia_Other',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '            <otherValue>' || Matrix_Utils.Get_InfoPathData('PA_Cardio_Arrhythmia_Other_Box',v_CaseId,'ST') || '</otherValue>' || LF;
  v_Str := v_Str || '        </followupQuestions>'|| LF;
  v_Str := v_Str || '        <managementPlan>' || Matrix_Utils.Get_InfoPathData('PA_Cardio_Arrhythmia_Plan_E1' ||'+ PA_Cardio_Arrhythmia_Plan_E2' ||'+ PA_Cardio_Arrhythmia_Plan_E3' ||'+ PA_Cardio_Arrhythmia_Plan_E4' ||'+ PA_Cardio_Arrhythmia_Plan_E5' ||'+ PA_Cardio_Arrhythmia_Plan_M1' ||'+ PA_Cardio_Arrhythmia_Plan_M2' ||'+ PA_Cardio_Arrhythmia_Plan_M3' ||'+ PA_Cardio_Arrhythmia_Plan_R1' ||'+ PA_Cardio_Arrhythmia_Plan_R2',v_CaseId,'MP') || '</managementPlan>' || LF;
  v_Str := v_Str || '   </diagnosis>' || LF;
  
  v_Str := v_Str || '   <diagnosis>' || LF;
  v_Str := v_Str || '        <title>Ventricular Tachycardia</title>' || LF;
  v_Str := v_Str || '        <value>' || Matrix_Utils.Get_InfoPathData('PA_Cardio_Ventricular_Tachycardia',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '        <managementPlan>' || Matrix_Utils.Get_InfoPathData('PA_Cardio_Ventricular_Tachycardia_Plan_E1' ||'+ PA_Cardio_Ventricular_Tachycardia_Plan_E2' ||'+ PA_Cardio_Ventricular_Tachycardia_Plan_E3' ||'+ PA_Cardio_Ventricular_Tachycardia_Plan_E4' ||'+ PA_Cardio_Ventricular_Tachycardia_Plan_E5' ||'+ PA_Cardio_Ventricular_Tachycardia_Plan_M1' ||'+ PA_Cardio_Ventricular_Tachycardia_Plan_M2' ||'+ PA_Cardio_Ventricular_Tachycardia_Plan_M3' ||'+ PA_Cardio_Ventricular_Tachycardia_Plan_R1' ||'+ PA_Cardio_Ventricular_Tachycardia_Plan_R2',v_CaseId,'MP') || '</managementPlan>' || LF;
  v_Str := v_Str || '   </diagnosis>' || LF;
  
  v_Str := v_Str || '   <diagnosis>' || LF;
  v_Str := v_Str || '    <title>Pacemaker</title>' || LF;
  v_Str := v_Str || '    <value>' || Matrix_Utils.Get_InfoPathData('PA_Cardio_Pacemaker',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '        <followupQuestions>' || LF;
  v_Str := v_Str || '            <title>Specify Arryhthmia:</title>' || LF;
  v_Str := v_Str || '            <answer>' || 'Other' || '</answer>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('PA_Cardio_Pacemaker_Box',v_CaseId,'ST') || '</value>' || LF;  
  v_Str := v_Str || '            <otherValue>' || Matrix_Utils.Get_InfoPathData('PA_Cardio_Pacemaker_Box',v_CaseId,'ST') || '</otherValue>' || LF;
  v_Str := v_Str || '        </followupQuestions>'|| LF;
  v_Str := v_Str || '        <managementPlan>' || Matrix_Utils.Get_InfoPathData('PA_Cardio_Pacemaker_Plan_E1' ||'+ PA_Cardio_Pacemaker_Plan_E2' ||'+ PA_Cardio_Pacemaker_Plan_E3' ||'+ PA_Cardio_Pacemaker_Plan_E4' ||'+ PA_Cardio_Pacemaker_Plan_E5' ||'+ PA_Cardio_Pacemaker_Plan_M1' ||'+ PA_Cardio_Pacemaker_Plan_M2' ||'+ PA_Cardio_Pacemaker_Plan_M3' ||'+ PA_Cardio_Pacemaker_Plan_R1' ||'+ PA_Cardio_Pacemaker_Plan_R2',v_CaseId,'MP') || '</managementPlan>' || LF;
  v_Str := v_Str || '   </diagnosis>' || LF;
  
  v_Str := v_Str || '   <diagnosis>' || LF;
  v_Str := v_Str || '    <title>Defibrillator/AICD</title>' || LF;
  v_Str := v_Str || '    <value>' || Matrix_Utils.Get_InfoPathData('PA_Cardio_Defibrillator',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '        <followupQuestions>' || LF;
  v_Str := v_Str || '            <title>Specify Reason:</title>' || LF;
  v_Str := v_Str || '            <answer>' || 'Other' || '</answer>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('PA_Cardio_Defibrillator_Box',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '            <otherValue>' || Matrix_Utils.Get_InfoPathData('PA_Cardio_Defibrillator_Box',v_CaseId,'ST') || '</otherValue>' || LF;
  v_Str := v_Str || '        </followupQuestions>'|| LF;
  v_Str := v_Str || '        <managementPlan>' || Matrix_Utils.Get_InfoPathData('PA_Cardio_Defibrillator_Plan_E1' ||'+ PA_Cardio_Defibrillator_Plan_E2' ||'+ PA_Cardio_Defibrillator_Plan_E3' ||'+ PA_Cardio_Defibrillator_Plan_E4' ||'+ PA_Cardio_Defibrillator_Plan_E5' ||'+ PA_Cardio_Defibrillator_Plan_M1' ||'+ PA_Cardio_Defibrillator_Plan_M2' ||'+ PA_Cardio_Defibrillator_Plan_M3' ||'+ PA_Cardio_Defibrillator_Plan_R1' ||'+ PA_Cardio_Defibrillator_Plan_R2',v_CaseId,'MP') || '</managementPlan>' || LF;
  v_Str := v_Str || '   </diagnosis>' || LF;
  
  v_Str := v_Str || '   <diagnosis>' || LF;
  v_Str := v_Str || '    <title>Coronary Artery Disease (CAD)</title>' || LF;
  v_Str := v_Str || '    <value>' || Matrix_Utils.Get_InfoPathData('PA_Cardio_CAD',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '        <managementPlan>' || Matrix_Utils.Get_InfoPathData('PA_Cardio_CAD_Plan_E1' ||'+ PA_Cardio_CAD_Plan_E2' ||'+ PA_Cardio_CAD_Plan_E3' ||'+ PA_Cardio_CAD_Plan_E4' ||'+ PA_Cardio_CAD_Plan_E5' ||'+ PA_Cardio_CAD_Plan_M1' ||'+ PA_Cardio_CAD_Plan_M2' ||'+ PA_Cardio_CAD_Plan_M3' ||'+ PA_Cardio_CAD_Plan_R1' ||'+ PA_Cardio_CAD_Plan_R2',v_CaseId,'MP') || '</managementPlan>' || LF;
  v_Str := v_Str || '   </diagnosis>' || LF;
  
  v_Str := v_Str || '   <diagnosis>' || LF;
  v_Str := v_Str || '    <title>Old Myocardial Infarction(>8 weeks old)</title>' || LF;
  v_Str := v_Str || '    <value>' || Matrix_Utils.Get_InfoPathData('PA_Cardio_Old_Myocardial_Infarction',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '        <managementPlan>' || Matrix_Utils.Get_InfoPathData('PA_Cardio_Old_Myocardial_Infarction_Plan_E1                                                  
+ PA_Cardio_Old_Myocardial_Infarction_Plan_E2                                                  
+ PA_Cardio_Old_Myocardial_Infarction_Plan_E3                                                  
+ PA_Cardio_Old_Myocardial_Infarction_Plan_E4                                                  
+ PA_Cardio_Old_Myocardial_Infarction_Plan_E5                                                  
+ PA_Cardio_Old_Myocardial_Infarction_Plan_M1                                                  
+ PA_Cardio_Old_Myocardial_Infarction_Plan_M2                                                  
+ PA_Cardio_Old_Myocardial_Infarction_Plan_M3                                                  
+ PA_Cardio_Old_Myocardial_Infarction_Plan_R1                                                  
+ PA_Cardio_Old_Myocardial_Infarction_Plan_R2',v_CaseId,
  'MP') || '</managementPlan>' || LF;
  v_Str := v_Str || '   </diagnosis>' || LF;
  
  v_Str := v_Str || '   <diagnosis>' || LF;
  v_Str := v_Str || '    <title>Recent Myocardial Infarction (&amp;lt; 8 weeks old)</title>' || LF;
  v_Str := v_Str || '    <value>' || Matrix_Utils.Get_InfoPathData('PA_Cardio_Recent_Myocardial_Infarction',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '        <managementPlan>' || Matrix_Utils.Get_InfoPathData(
  'PA_Cardio_Recent_Myocardial_Infarction_Plan_E1                                                  
+ PA_Cardio_Recent_Myocardial_Infarction_Plan_E2                                                  
+ PA_Cardio_Recent_Myocardial_Infarction_Plan_E3                                                  
+ PA_Cardio_Recent_Myocardial_Infarction_Plan_E4                                                  
+ PA_Cardio_Recent_Myocardial_Infarction_Plan_E5                                                  
+ PA_Cardio_Recent_Myocardial_Infarction_Plan_M1                                                  
+ PA_Cardio_Recent_Myocardial_Infarction_Plan_M2                                                  
+ PA_Cardio_Recent_Myocardial_Infarction_Plan_M3                                                  
+ PA_Cardio_Recent_Myocardial_Infarction_Plan_R1                                                  
+ PA_Cardio_Recent_Myocardial_Infarction_Plan_R2',v_CaseId,'MP') || '</managementPlan>' || LF;
  v_Str := v_Str || '   </diagnosis>' || LF;
  
  v_Str := v_Str || '   <diagnosis>' || LF;
  v_Str := v_Str || '    <title>Angina (active or chronic  on medication)</title>' || LF;
  v_Str := v_Str || '    <value>' || Matrix_Utils.Get_InfoPathData('PA_Cardio_Angina',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '        <managementPlan>' || Matrix_Utils.Get_InfoPathData('PA_Cardio_Angina_Plan_E1                                                  
+ PA_Cardio_Angina_Plan_E2                                                  
+ PA_Cardio_Angina_Plan_E3                                                  
+ PA_Cardio_Angina_Plan_E4                                                  
+ PA_Cardio_Angina_Plan_E5                                                  
+ PA_Cardio_Angina_Plan_M1                                                  
+ PA_Cardio_Angina_Plan_M2                                                  
+ PA_Cardio_Angina_Plan_M3                                                  
+ PA_Cardio_Angina_Plan_R1                                                  
+ PA_Cardio_Angina_Plan_R2',v_CaseId,'MP') || '</managementPlan>' || LF;
  v_Str := v_Str || '   </diagnosis>' || LF;
  
  v_Str := v_Str || '   <diagnosis>' || LF;
  v_Str := v_Str || '    <title>Angina (inactive  not on meds  no cardiac chest pain symptoms)</title>' || LF;
  v_Str := v_Str || '    <value>' || Matrix_Utils.Get_InfoPathData('PA_Cardio_Angina_Inactive',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '        <managementPlan>' || Matrix_Utils.Get_InfoPathData('PA_Cardio_Angina_Inactive_Plan_E1                                                  
+ PA_Cardio_Angina_Inactive_Plan_E2                                                  
+ PA_Cardio_Angina_Inactive_Plan_E3                                                  
+ PA_Cardio_Angina_Inactive_Plan_E4                                                  
+ PA_Cardio_Angina_Inactive_Plan_E5                                                  
+ PA_Cardio_Angina_Inactive_Plan_M1                                                  
+ PA_Cardio_Angina_Inactive_Plan_M2                                                  
+ PA_Cardio_Angina_Inactive_Plan_M3                                                  
+ PA_Cardio_Angina_Inactive_Plan_R1                                                  
+ PA_Cardio_Angina_Inactive_Plan_R2',v_CaseId,'MP') || '</managementPlan>' || LF;
  v_Str := v_Str || '   </diagnosis>' || LF;
  
  v_Str := v_Str || '   <diagnosis>' || LF;
  v_Str := v_Str || '    <title>History of CABG (or S/P CABG)</title>' || LF;
  v_Str := v_Str || '    <value>' || Matrix_Utils.Get_InfoPathData('PA_Cardio_CABG',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '        <managementPlan>' || Matrix_Utils.Get_InfoPathData('PA_Cardio_CABG_Plan_E1                                                  
+ PA_Cardio_CABG_Plan_E2                                                  
+ PA_Cardio_CABG_Plan_E3
+ PA_Cardio_CABG_Plan_E4
+ PA_Cardio_CABG_Plan_E5
+ PA_Cardio_CABG_Plan_M1
+ PA_Cardio_CABG_Plan_M2
+ PA_Cardio_CABG_Plan_M3
+ PA_Cardio_CABG_Plan_R1
+ PA_Cardio_CABG_Plan_R2',v_CaseId,'MP') || '</managementPlan>' || LF;

  v_Str := v_Str || '   </diagnosis>' || LF;
  
  v_Str := v_Str || '   <diagnosis>' || LF;
  v_Str := v_Str || '    <title>History of PTCA (or stent)</title>' || LF;
  v_Str := v_Str || '    <value>' || Matrix_Utils.Get_InfoPathData('PA_Cardio_PTCA',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '   </diagnosis>' || LF;
  
  v_Str := v_Str || '   <diagnosis>' || LF;
  v_Str := v_Str || '    <title>Peripheral Vascular Disease (PVD) (peripheral arterial disease)</title>' || LF;
  v_Str := v_Str || '    <value>' || Matrix_Utils.Get_InfoPathData('PA_Cardio_PVD',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '        <managementPlan>' || Matrix_Utils.Get_InfoPathData('PA_Cardio_PVD_E1                                                  
+ PA_Cardio_PVD_E2                                                  
+ PA_Cardio_PVD_E3                                                  
+ PA_Cardio_PVD_E4                                                  
+ PA_Cardio_PVD_E5                                                  
+ PA_Cardio_PVD_M1                                                  
+ PA_Cardio_PVD_M2                                                  
+ PA_Cardio_PVD_M3                                                  
+ PA_Cardio_PVD_R1                                                  
+ PA_Cardio_PVD_R2',v_CaseId,'MP') || '</managementPlan>' || LF;
  v_Str := v_Str || '   </diagnosis>' || LF;
  
  v_Str := v_Str || '   <diagnosis>' || LF;
  v_Str := v_Str || '        <title>Atherosclerosis of Extremities:</title>' || LF;
  v_Str := v_Str || '        <value>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        <followupQuestions>' || LF;
  v_Str := v_Str || '            <title>Type:</title>' || LF;
  v_Str := v_Str || '            <answer>' || Matrix_Utils.Get_InfoPathData('PA_Cardio_Atherosclerosis_Asymptomatic',v_CaseId,'ST') || '</answer>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </followupQuestions>'|| LF;
  v_Str := v_Str || '        <followupQuestions>' || LF;
  v_Str := v_Str || '            <title>Type:</title>' || LF;
  v_Str := v_Str || '            <answer>' || Matrix_Utils.Get_InfoPathData('PA_Cardio_Atherosclerosis_Claudication  
+PA_Cardio_Atherosclerosis_Gangrene  
+PA_Cardio_Atherosclerosis_Rest_Pain  
+PA_Cardio_Atherosclerosis_Ulceration  
+PA_Cardio_Atherosclerosis_Amputation',v_CaseId,'MP') || '</answer>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </followupQuestions>'|| LF;
  v_Str := v_Str || '        <managementPlan>' || Matrix_Utils.Get_InfoPathData('PA_Cardio_Atherosclerosis_Extrem_Plan_E1                                                  
+ PA_Cardio_Atherosclerosis_Extrem_Plan_E2                                                  
+ PA_Cardio_Atherosclerosis_Extrem_Plan_E3                                                  
+ PA_Cardio_Atherosclerosis_Extrem_Plan_E4                                                  
+ PA_Cardio_Atherosclerosis_Extrem_Plan_E5                                                  
+ PA_Cardio_Atherosclerosis_Extrem_Plan_M1                                                  
+ PA_Cardio_Atherosclerosis_Extrem_Plan_M2                                                  
+ PA_Cardio_Atherosclerosis_Extrem_Plan_M3                                                  
+ PA_Cardio_Atherosclerosis_Extrem_Plan_R1                                                  
+ PA_Cardio_Atherosclerosis_Extrem_Plan_R2',v_CaseId,'MP') || '</managementPlan>' ||
  LF;
  v_Str := v_Str || '   </diagnosis>' || LF;
  
  v_Str := v_Str || '   <diagnosis>' || LF;
  v_Str := v_Str || '    <title>Atherosclerosis of</title>' || LF;
  v_Str := v_Str || '    <value>' || Matrix_Utils.Get_InfoPathData('PA_Cardio_Atherosclerosis',v_CaseId,'TF') || '</value>' || LF;
 -- v_Str := v_Str || '   <subDiagnosis>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</subDiagnosis>' || LF;
  v_Str := v_Str || '    <title>Aorta</title>' || LF;
  v_Str := v_Str || '    <value>' || Matrix_Utils.Get_InfoPathData('PA_Cardio_Atherosclerosis_Aorta',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '        <managementPlan>' || Matrix_Utils.Get_InfoPathData('PA_Cardio_Atherosclerosis_Plan_E1                                                  
+ PA_Cardio_Atherosclerosis_Plan_E2                                                  
+ PA_Cardio_Atherosclerosis_Plan_E3                                                  
+ PA_Cardio_Atherosclerosis_Plan_E4                                                  
+ PA_Cardio_Atherosclerosis_Plan_E5                                                  
+ PA_Cardio_Atherosclerosis_Plan_M1                                                  
+ PA_Cardio_Atherosclerosis_Plan_M2                                                  
+ PA_Cardio_Atherosclerosis_Plan_M3                                                  
+ PA_Cardio_Atherosclerosis_Plan_R1                                                  
+ PA_Cardio_Atherosclerosis_Plan_R2',v_CaseId,'MP') || '</managementPlan>' || LF;
 -- v_Str := v_Str || '   <subDiagnosis>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</subDiagnosis>' || LF;
  v_Str := v_Str || '    <title>Renal Artery</title>' || LF;
  v_Str := v_Str || '    <value>' || Matrix_Utils.Get_InfoPathData('PA_Cardio_Atherosclerosis_Renal_Artery',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '        <managementPlan>' || Matrix_Utils.Get_InfoPathData('PA_Cardio_Atherosclerosis_Plan_E1                                                  
+ PA_Cardio_Atherosclerosis_Plan_E2                                                  
+ PA_Cardio_Atherosclerosis_Plan_E3                                                  
+ PA_Cardio_Atherosclerosis_Plan_E4                                                  
+ PA_Cardio_Atherosclerosis_Plan_E5                                                  
+ PA_Cardio_Atherosclerosis_Plan_M1                                                  
+ PA_Cardio_Atherosclerosis_Plan_M2                                                  
+ PA_Cardio_Atherosclerosis_Plan_M3                                                  
+ PA_Cardio_Atherosclerosis_Plan_R1                                                  
+ PA_Cardio_Atherosclerosis_Plan_R2',v_CaseId,'MP') || '</managementPlan>' || LF;
 -- v_Str := v_Str || '   <subDiagnosis>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</subDiagnosis>' || LF;
  v_Str := v_Str || '    <title>Carotid Artery</title>' || LF;
  v_Str := v_Str || '    <value>' || Matrix_Utils.Get_InfoPathData('PA_Cardio_Atherosclerosis_Carotid_Artery',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '        <managementPlan>' || Matrix_Utils.Get_InfoPathData('PA_Cardio_Atherosclerosis_Plan_E1                                                  
+ PA_Cardio_Atherosclerosis_Plan_E2                                                  
+ PA_Cardio_Atherosclerosis_Plan_E3                                                  
+ PA_Cardio_Atherosclerosis_Plan_E4                                                  
+ PA_Cardio_Atherosclerosis_Plan_E5                                                  
+ PA_Cardio_Atherosclerosis_Plan_M1                                                  
+ PA_Cardio_Atherosclerosis_Plan_M2                                                  
+ PA_Cardio_Atherosclerosis_Plan_M3                                                  
+ PA_Cardio_Atherosclerosis_Plan_R1                                                  
+ PA_Cardio_Atherosclerosis_Plan_R2',v_CaseId,'MP') || '</managementPlan>' || LF;
  v_Str := v_Str || '   </diagnosis>' || LF;
  
  v_Str := v_Str || '   <diagnosis>' || LF;
  v_Str := v_Str || '        <title>Aortic Aneurysm (current) Without Rupture</title>' || LF;
  v_Str := v_Str || '        <value>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
 -- v_Str := v_Str || '   <subDiagnosis>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</subDiagnosis>' || LF;
  v_Str := v_Str || '    <title>Thoracic</title>' || LF;
  v_Str := v_Str || '    <value>' || Matrix_Utils.Get_InfoPathData('PA_Cardio_Aortic_No_Rupture_Thoracic',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '        <managementPlan>' || Matrix_Utils.Get_InfoPathData('PA_Cardio_Aortic_Plan_E1                                                  
+ PA_Cardio_Aortic_Plan_E2                                                  
+ PA_Cardio_Aortic_Plan_E3                                                  
+ PA_Cardio_Aortic_Plan_E4                                                  
+ PA_Cardio_Aortic_Plan_E5                                                  
+ PA_Cardio_Aortic_Plan_M1                                                  
+ PA_Cardio_Aortic_Plan_M2                                                  
+ PA_Cardio_Aortic_Plan_M3                                                  
+ PA_Cardio_Aortic_Plan_R1                                                  
+ PA_Cardio_Aortic_Plan_R2',v_CaseId,'MP') || '</managementPlan>' || LF;
 -- v_Str := v_Str || '   <subDiagnosis>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</subDiagnosis>' || LF;
  v_Str := v_Str || '    <title>Abdominal</title>' || LF;
  v_Str := v_Str || '    <value>' || Matrix_Utils.Get_InfoPathData('PA_Cardio_Aortic_No_Rupture_Abdominal',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '        <managementPlan>' || Matrix_Utils.Get_InfoPathData('PA_Cardio_Aortic_Plan_E1                                                  
+ PA_Cardio_Aortic_Plan_E2                                                  
+ PA_Cardio_Aortic_Plan_E3                                                  
+ PA_Cardio_Aortic_Plan_E4                                                  
+ PA_Cardio_Aortic_Plan_E5                                                  
+ PA_Cardio_Aortic_Plan_M1                                                  
+ PA_Cardio_Aortic_Plan_M2                                                  
+ PA_Cardio_Aortic_Plan_M3                                                  
+ PA_Cardio_Aortic_Plan_R1                                                  
+ PA_Cardio_Aortic_Plan_R2',v_CaseId,'MP') || '</managementPlan>' || LF;
  v_Str := v_Str || '   </diagnosis>' || LF;
  
  v_Str := v_Str || '   <diagnosis>' || LF;
  v_Str := v_Str || '    <title>Current Venous Thrombosis/ Embolism (on Rx &amp;lt;3 months)</title>' || LF;
  v_Str := v_Str || '    <value>' || Matrix_Utils.Get_InfoPathData('PA_Cardio_Venous_Thrombosis',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '        <managementPlan>' || Matrix_Utils.Get_InfoPathData('PA_Cardio_Venous_Thrombosis_Plan_E1                                                  
+ PA_Cardio_Venous_Thrombosis_Plan_E2                                                  
+ PA_Cardio_Venous_Thrombosis_Plan_E3                                                  
+ PA_Cardio_Venous_Thrombosis_Plan_E4                                                  
+ PA_Cardio_Venous_Thrombosis_Plan_E5                                                  
+ PA_Cardio_Venous_Thrombosis_Plan_M1                                                  
+ PA_Cardio_Venous_Thrombosis_Plan_M2                                                  
+ PA_Cardio_Venous_Thrombosis_Plan_M3                                                  
+ PA_Cardio_Venous_Thrombosis_Plan_R1                                                  
+ PA_Cardio_Venous_Thrombosis_Plan_R2',v_CaseId,'MP') || '</managementPlan>' || LF;
  v_Str := v_Str || '   </diagnosis>' || LF;
  
  v_Str := v_Str || '   <diagnosis>' || LF;
  v_Str := v_Str || '        <title>History of Venous Thrombosis/ Embolism on Rx or S/P IVC filter</title>' || LF;
  v_Str := v_Str || '        <value>' || Matrix_Utils.Get_InfoPathData('PA_Cardio_History_Venous_Thrombosis',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '        <managementPlan>' || Matrix_Utils.Get_InfoPathData('PA_Cardio_History_Venous_Thrombosis_Plan_E1                                                  
+ PA_Cardio_History_Venous_Thrombosis_Plan_E2                                                  
+ PA_Cardio_History_Venous_Thrombosis_Plan_E3                                                  
+ PA_Cardio_History_Venous_Thrombosis_Plan_E4                                                  
+ PA_Cardio_History_Venous_Thrombosis_Plan_E5                                                  
+ PA_Cardio_History_Venous_Thrombosis_Plan_M1                                                  
+ PA_Cardio_History_Venous_Thrombosis_Plan_M2                                                  
+ PA_Cardio_History_Venous_Thrombosis_Plan_M3                                                  
+ PA_Cardio_History_Venous_Thrombosis_Plan_R1                                                  
+ PA_Cardio_History_Venous_Thrombosis_Plan_R2',v_CaseId,
  'MP') || '</managementPlan>' || LF;
  v_Str := v_Str || '   </diagnosis>' || LF;
  
  v_Str := v_Str || '   <diagnosis>' || LF;
  v_Str := v_Str || '    <title>Valve Disorder</title>' || LF;
  v_Str := v_Str || '    <value>' || Matrix_Utils.Get_InfoPathData('PA_Cardio_Valve_Disorder',v_CaseId,'TF') || '</value>' || LF;
  --v_Str := v_Str || '   <subDiagnosis>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</subDiagnosis>' || LF;
  v_Str := v_Str || '   <subDiagnosis>'  || LF;
  v_Str := v_Str || '        <title>Valve</title>' || LF;
  v_Str := v_Str || '        <value>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        <followupQuestions>' || LF;
  v_Str := v_Str || '            <title>Valve Options:</title>' || LF;
  -- need to check the answer node for these 6 tags
  v_Str := v_Str || '            <answer>' || Matrix_Utils.Get_InfoPathData('PA_Cardio_Valve_Disorder_Mitral',v_CaseId,'ST') || '</answer>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </followupQuestions>'|| LF;
  v_Str := v_Str || '        <followupQuestions>' || LF;
  v_Str := v_Str || '            <title>Valve Options:</title>' || LF;
  v_Str := v_Str || '            <answer>' || Matrix_Utils.Get_InfoPathData('PA_Cardio_Valve_Disorder_Aortic',v_CaseId,'ST') || '</answer>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </followupQuestions>'|| LF;
  v_Str := v_Str || '        <followupQuestions>' || LF;
  v_Str := v_Str || '            <title>Valve Options:</title>' || LF;
  v_Str := v_Str || '            <answer>' || Matrix_Utils.Get_InfoPathData('PA_Cardio_Valve_Disorder_Tricuspid',v_CaseId,'ST') || '</answer>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </followupQuestions>'|| LF;
  v_Str := v_Str || '        <followupQuestions>' || LF;
  v_Str := v_Str || '            <title>Valve Options:</title>' || LF;
  v_Str := v_Str || '            <answer>' || Matrix_Utils.Get_InfoPathData('PA_Cardio_Valve_Disorder_Pulmonary',v_CaseId,'ST') || '</answer>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </followupQuestions>'|| LF;
  v_Str := v_Str || '   </subDiagnosis>'  || LF;
  v_Str := v_Str || '   <subDiagnosis>'  || LF;
 -- v_Str := v_Str || '   <subDiagnosis>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</subDiagnosis>' || LF;
  v_Str := v_Str || '        <title>Type:</title>' || LF;
  v_Str := v_Str || '        <value>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        <followupQuestions>' || LF;
  v_Str := v_Str || '            <title>Type Options:</title>' || LF;
  v_Str := v_Str || '            <answer>' || Matrix_Utils.Get_InfoPathData('PA_Cardio_Valve_Disorder_Insufficiency',v_CaseId,'ST') || '</answer>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </followupQuestions>'|| LF;
  v_Str := v_Str || '        <followupQuestions>' || LF;
  v_Str := v_Str || '            <title>Type Options:</title>' || LF;
  v_Str := v_Str || '            <answer>' || Matrix_Utils.Get_InfoPathData('PA_Cardio_Valve_Disorder_Stenosis',v_CaseId,'ST') || '</answer>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </followupQuestions>'|| LF;
 v_Str := v_Str || '   </subDiagnosis>'  || LF; 
  v_Str := v_Str || '        <managementPlan>' || Matrix_Utils.Get_InfoPathData('PA_Cardio_Valve_Disorder_Plan_E1                                                  
+ PA_Cardio_Valve_Disorder_Plan_E2                                                  
+ PA_Cardio_Valve_Disorder_Plan_E3                                                  
+ PA_Cardio_Valve_Disorder_Plan_E4                                                  
+ PA_Cardio_Valve_Disorder_Plan_E5                                                  
+ PA_Cardio_Valve_Disorder_Plan_M1                                                  
+ PA_Cardio_Valve_Disorder_Plan_M2                                                  
+ PA_Cardio_Valve_Disorder_Plan_M3                                                  
+ PA_Cardio_Valve_Disorder_Plan_R1                                                  
+ PA_Cardio_Valve_Disorder_Plan_R2',v_CaseId,'MP') || '</managementPlan>' || LF;
  v_Str := v_Str || '   </diagnosis>' || LF;
  
  v_Str := v_Str || '   <diagnosis>' || LF;
  v_Str := v_Str || '    <title>Pulmonary Hypertension</title>' || LF;
  v_Str := v_Str || '    <value>' || Matrix_Utils.Get_InfoPathData('PA_Cardio_Pulmonary',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '        <managementPlan>' || Matrix_Utils.Get_InfoPathData('PA_Cardio_Pulmonary_Plan_E1                                                  
+ PA_Cardio_Pulmonary_Plan_E2                                                  
+ PA_Cardio_Pulmonary_Plan_E3                                                  
+ PA_Cardio_Pulmonary_Plan_E4                                                  
+ PA_Cardio_Pulmonary_Plan_E5                                                  
+ PA_Cardio_Pulmonary_Plan_M1                                                  
+ PA_Cardio_Pulmonary_Plan_M2                                                  
+ PA_Cardio_Pulmonary_Plan_M3                                                  
+ PA_Cardio_Pulmonary_Plan_R1                                                  
+ PA_Cardio_Pulmonary_Plan_R2',v_CaseId,'MP') || '</managementPlan>' || LF;
  v_Str := v_Str || '   </diagnosis>' || LF;
  
  v_Str := v_Str || '   <diagnosis>' || LF;
  v_Str := v_Str || '    <title>Other Significant Diagnoses:</title>' || LF;
  v_Str := v_Str || '    <value>' || Matrix_Utils.Get_InfoPathData('PA_Cardio_Other',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '        <followupQuestions>' || LF;
  v_Str := v_Str || '            <title>Other</title>' || LF;
  v_Str := v_Str || '            <answer>' || Matrix_Utils.Get_InfoPathData('PA_Cardio_Other_Box',v_CaseId,'ST') || '</answer>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </followupQuestions>'|| LF;
  v_Str := v_Str || '        <managementPlan>' || Matrix_Utils.Get_InfoPathData('PA_Cardio_Other_Plan_E1                                                  
+ PA_Cardio_Other_Plan_E2                                                  
+ PA_Cardio_Other_Plan_E3                                                  
+ PA_Cardio_Other_Plan_E4                                                  
+ PA_Cardio_Other_Plan_E5                                                  
+ PA_Cardio_Other_Plan_M1                                                  
+ PA_Cardio_Other_Plan_M2                                                  
+ PA_Cardio_Other_Plan_M3                                                  
+ PA_Cardio_Other_Plan_R1                                                  
+ PA_Cardio_Other_Plan_R2',
        v_CaseId,'MP') || '</managementPlan>' || LF;
  v_Str := v_Str || '     </diagnosis>' || LF;
  v_Str := v_Str || '   </sections>'|| LF;


  v_Str := v_Str || '   <sections>'|| LF;
  v_Str := v_Str || '   <title>Neuropsychiatric Disease</title>' || LF;
  v_Str := v_Str || '   <diagnosis>' || LF;
  v_Str := v_Str || '        <title>Alcohol Abuse</title>' || LF;
  v_Str := v_Str || '        <value>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '        <followupQuestions>' || LF;
  v_Str := v_Str || '            <title>Status:</title>' || LF;
  v_Str := v_Str || '            <answer>' || Matrix_Utils.Get_InfoPathData('PA_Neuro_Alcohol_Abuse_Continuous
+  PA_Neuro_Alcohol_Abuse_Episodic 
+ PA_Neuro_Alcohol_Abuse_Remission ',v_CaseId,'ST') || '</answer>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </followupQuestions>'|| LF;
  v_Str := v_Str || '        <managementPlan>' || Matrix_Utils.Get_InfoPathData('PA_Neuro_Alcohol_Abuse_Plan_E1                                                  
+ PA_Neuro_Alcohol_Abuse_Plan_E2                                                  
+ PA_Neuro_Alcohol_Abuse_Plan_E3                                                  
+ PA_Neuro_Alcohol_Abuse_Plan_E4                                                  
+ PA_Neuro_Alcohol_Abuse_Plan_E5                                                  
+ PA_Neuro_Alcohol_Abuse_Plan_M1                                                  
+ PA_Neuro_Alcohol_Abuse_Plan_M2                                                  
+ PA_Neuro_Alcohol_Abuse_Plan_M3                                                  
+ PA_Neuro_Alcohol_Abuse_Plan_R1                                                  
+ PA_Neuro_Alcohol_Abuse_Plan_R2',v_CaseId,'MP') || '</managementPlan>' || LF;
  v_Str := v_Str || '   </diagnosis>' || LF;
  
  v_Str := v_Str || '   <diagnosis>' || LF;
  v_Str := v_Str || '        <title>Alcohol Dependence</title>' || LF;
  v_Str := v_Str || '        <value>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '        <followupQuestions>' || LF;
  v_Str := v_Str || '            <title>Status:</title>' || LF;
  v_Str := v_Str || '            <answer>' || Matrix_Utils.Get_InfoPathData('PA_Neuro_Alcohol_Dependence_Continuous 
+ PA_Neuro_Alcohol_Dependence_Episodic 
+ PA_Neuro_Alcohol_Dependence_Remission ',v_CaseId,'MP') || '</answer>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </followupQuestions>'|| LF;
  v_Str := v_Str || '        <managementPlan>' || Matrix_Utils.Get_InfoPathData('PA_Neuro_Alcohol_Dependence_Plan_E1                                                  
+ PA_Neuro_Alcohol_Dependence_Plan_E2                                                  
+ PA_Neuro_Alcohol_Dependence_Plan_E3                                                  
+ PA_Neuro_Alcohol_Dependence_Plan_E4                                                  
+ PA_Neuro_Alcohol_Dependence_Plan_E5                                                  
+ PA_Neuro_Alcohol_Dependence_Plan_M1                                                  
+ PA_Neuro_Alcohol_Dependence_Plan_M2                                                  
+ PA_Neuro_Alcohol_Dependence_Plan_M3                                                  
+ PA_Neuro_Alcohol_Dependence_Plan_R1                                                  
+ PA_Neuro_Alcohol_Dependence_Plan_R2',v_CaseId,'MP') || '</managementPlan>' || LF;
  v_Str := v_Str || '   </diagnosis>' || LF;
  
  v_Str := v_Str || '   <diagnosis>' || LF;
  v_Str := v_Str || '        <title>Drug Abuse</title>' || LF;
  v_Str := v_Str || '        <value>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '        <followupQuestions>' || LF;
  v_Str := v_Str || '            <title>Specify Drug:</title>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('PA_Neuro_Drug_Abuse',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </followupQuestions>'|| LF;
  v_Str := v_Str || '        <followupQuestions>' || LF;
  v_Str := v_Str || '            <title>Status:</title>' || LF;
  v_Str := v_Str || '            <answer>' || Matrix_Utils.Get_InfoPathData('PA_Neuro_Drug_Abuse_Continuous 
+ PA_Neuro_Drug_Abuse_Episodic 
+ PA_Neuro_Drug_Abuse_Remission',v_CaseId,'ST') || '</answer>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </followupQuestions>'|| LF;
  v_Str := v_Str || '        <managementPlan>' || Matrix_Utils.Get_InfoPathData('PA_Neuro_Drug_Abuse_Plan_E1                                                  
+ PA_Neuro_Drug_Abuse_Plan_E2                                                  
+ PA_Neuro_Drug_Abuse_Plan_E3                                                  
+ PA_Neuro_Drug_Abuse_Plan_E4                                                  
+ PA_Neuro_Drug_Abuse_Plan_E5                                                  
+ PA_Neuro_Drug_Abuse_Plan_M1                                                  
+ PA_Neuro_Drug_Abuse_Plan_M2                                                  
+ PA_Neuro_Drug_Abuse_Plan_M3                                                  
+ PA_Neuro_Drug_Abuse_Plan_R1                                                  
+ PA_Neuro_Drug_Abuse_Plan_R2',v_CaseId,'MP') || '</managementPlan>' || LF;
  v_Str := v_Str || '   </diagnosis>' || LF;
  
  v_Str := v_Str || '   <diagnosis>' || LF;
  v_Str := v_Str || '        <title>Drug Dependence</title>' || LF;
  v_Str := v_Str || '        <value>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '        <followupQuestions>' || LF;
  v_Str := v_Str || '            <title>Specify Drug:</title>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('PA_Neuro_Drug_Dependence',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </followupQuestions>'|| LF;
  v_Str := v_Str || '        <followupQuestions>' || LF;
  v_Str := v_Str || '            <title>Status:</title>' || LF;
  v_Str := v_Str || '            <answer>' || Matrix_Utils.Get_InfoPathData('PA_Neuro_Drug_Dependence_Continuous 
+ PA_Neuro_Drug_Dependence_Episodic 
+ PA_Neuro_Drug_Dependence_Remission',v_CaseId,'MP') || '</answer>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </followupQuestions>'|| LF;
  v_Str := v_Str || '        <managementPlan>' || Matrix_Utils.Get_InfoPathData('PA_Neuro_Drug_Dependence_Plan_E1                                                  
+ PA_Neuro_Drug_Dependence_Plan_E2                                                  
+ PA_Neuro_Drug_Dependence_Plan_E3                                                  
+ PA_Neuro_Drug_Dependence_Plan_E4                                                  
+ PA_Neuro_Drug_Dependence_Plan_E5                                                  
+ PA_Neuro_Drug_Dependence_Plan_M1                                                  
+ PA_Neuro_Drug_Dependence_Plan_M2                                                  
+ PA_Neuro_Drug_Dependence_Plan_M3                                                  
+ PA_Neuro_Drug_Dependence_Plan_R1                                                  
+ PA_Neuro_Drug_Dependence_Plan_R2',v_CaseId,'MP') || '</managementPlan>' || LF;
  v_Str := v_Str || '   </diagnosis>' || LF;
  
  v_Str := v_Str || '   <diagnosis>' || LF;
  v_Str := v_Str || '        <title>Tobacco Use</title>' || LF;
  v_Str := v_Str || '        <value>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '        <followupQuestions>' || LF;
  v_Str := v_Str || '            <title>Status:</title>' || LF;
  v_Str := v_Str || '            <answer>' || Matrix_Utils.Get_InfoPathData(' PA_Neuro_Tobacco_Current ',v_CaseId,'ST') || '</answer>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </followupQuestions>'|| LF;
  v_Str := v_Str || '        <followupQuestions>' || LF;
  v_Str := v_Str || '            <title>Status:</title>' || LF;
  v_Str := v_Str || '            <answer>' || Matrix_Utils.Get_InfoPathData(' PA_Neuro_Tobacco_History_Of ',v_CaseId,'ST') || '</answer>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </followupQuestions>'|| LF;
  v_Str := v_Str || '      <managementPlan>' || Matrix_Utils.Get_InfoPathData('PA_Neuro_Tobacco_Plan_E1
+PA_Neuro_Tobacco_Plan_E2
+PA_Neuro_Tobacco_Plan_E3
+PA_Neuro_Tobacco_Plan_E4
+PA_Neuro_Tobacco_Plan_E5
+PA_Neuro_Tobacco_Plan_M1
+PA_Neuro_Tobacco_Plan_M2
+PA_Neuro_Tobacco_Plan_M3
+PA_Neuro_Tobacco_Plan_R1
+PA_Neuro_Tobacco_Plan_R2',
      v_CaseId,'MP') || '</managementPlan>' || LF;
  v_Str := v_Str || '   </diagnosis>' || LF;
  
  v_Str := v_Str || '   <diagnosis>' || LF;
  v_Str := v_Str || '        <title>Alzheimer''s Disease</title>' || LF;
  v_Str := v_Str || '        <value>' || Matrix_Utils.Get_InfoPathData(' PA_Neuro_Alzheimers ',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '        <followupQuestions>' || LF;
  v_Str := v_Str || '            <title>Dementia in Alzheimer''s without Behavioral Disturbance</title>' || LF;
  v_Str := v_Str || '            <answer>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</answer>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData(' PA_Neuro_Alzheimers_Dementia_Without_Disturbance ',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '        </followupQuestions>'|| LF;
  v_Str := v_Str || '        <followupQuestions>' || LF;
  v_Str := v_Str || '            <title>Dementia in Alzheimer''s with Behavioral Disturbance</title>' || LF;
  v_Str := v_Str || '            <answer>' || Matrix_Utils.Get_InfoPathData(' PA_Neuro_Alzheimers_Dementia_With_Disturbance ',v_CaseId,'TF') || '</answer>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </followupQuestions>'|| LF;
  v_Str := v_Str || '        <followupQuestions>' || LF;
  v_Str := v_Str || '            <title>Specify:</title>' || LF;
  v_Str := v_Str || '            <answer>' || Matrix_Utils.Get_InfoPathData(' PA_Neuro_Alzheimers_Dementia_With_Disturbance_Box ',v_CaseId,'ST') || '</answer>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </followupQuestions>' || LF;
  v_Str := v_Str || '        <managementPlan>' || Matrix_Utils.Get_InfoPathData('PA_Neuro_Alzheimers_Plan_E1                                                  
+ PA_Neuro_Alzheimers_Plan_E2                                                  
+ PA_Neuro_Alzheimers_Plan_E3                                                  
+ PA_Neuro_Alzheimers_Plan_E4                                                  
+ PA_Neuro_Alzheimers_Plan_E5                                                  
+ PA_Neuro_Alzheimers_Plan_M1                                                  
+ PA_Neuro_Alzheimers_Plan_M2                                                  
+ PA_Neuro_Alzheimers_Plan_M3                                                  
+ PA_Neuro_Alzheimers_Plan_R1                                                  
+ PA_Neuro_Alzheimers_Plan_R2',v_CaseId,'MP') || '</managementPlan>' || LF;
  v_Str := v_Str || '        <followupQuestions>' || LF;
  v_Str := v_Str || '            <title>Unspecified Dementia without behavioral disturbance</title>' || LF;
  v_Str := v_Str || '            <answer>' || Matrix_Utils.Get_InfoPathData(' PA_Neuro_Unspecified_Dementia_Without ',v_CaseId,'TF') || '</answer>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </followupQuestions>'|| LF;
  v_Str := v_Str || '        <followupQuestions>' || LF;
  v_Str := v_Str || '            <title>Unspecified Dementia with behavioral disturbance</title>' || LF;
  v_Str := v_Str || '            <answer>' || Matrix_Utils.Get_InfoPathData(' PA_Neuro_Unspecified_Dementia_With ',v_CaseId,'TF') || '</answer>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </followupQuestions>'|| LF;
  v_Str := v_Str || '        <followupQuestions>' || LF;
  v_Str := v_Str || '            <title>Specify:</title>' || LF;
  v_Str := v_Str || '            <answer>' || Matrix_Utils.Get_InfoPathData(' PA_Neuro_Unspecified_Dementia_With_Box ',v_CaseId,'ST') || '</answer>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </followupQuestions>' || LF;
  v_Str := v_Str || '        <managementPlan>' || Matrix_Utils.Get_InfoPathData('PA_Neuro_Unspecified_Dementia_E1                                                  
+ PA_Neuro_Unspecified_Dementia_E2                                                  
+ PA_Neuro_Unspecified_Dementia_E3                                                  
+ PA_Neuro_Unspecified_Dementia_E4                                                  
+ PA_Neuro_Unspecified_Dementia_E5                                                  
+ PA_Neuro_Unspecified_Dementia_M1                                                  
+ PA_Neuro_Unspecified_Dementia_M2                                                  
+ PA_Neuro_Unspecified_Dementia_M3                                                  
+ PA_Neuro_Unspecified_Dementia_R1                                                  
+ PA_Neuro_Unspecified_Dementia_R2',v_CaseId,'MP') || '</managementPlan>' || LF;
  v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
  v_Str := v_Str || '        <title>Wandering in patient diagnosed with dementia</title>' || LF;
  v_Str := v_Str || '        <value>' || Matrix_Utils.Get_InfoPathData(' PA_Neuro_Wandering ',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '        <managementPlan>' || Matrix_Utils.Get_InfoPathData('PA_Neuro_Wandering_E1                                                  
+ PA_Neuro_Wandering_E2                                                  
+ PA_Neuro_Wandering_E3                                                  
+ PA_Neuro_Wandering_E4                                                  
+ PA_Neuro_Wandering_E5                                                  
+ PA_Neuro_Wandering_M1                                                  
+ PA_Neuro_Wandering_M2                                                  
+ PA_Neuro_Wandering_M3                                                  
+ PA_Neuro_Wandering_R1                                                  
+ PA_Neuro_Wandering_R2',v_CaseId,'MP') || '</managementPlan>' || LF;
  v_Str := v_Str || '   </diagnosis>' || LF;
  
  v_Str := v_Str || '   <diagnosis>' || LF;
  v_Str := v_Str || '        <title>Mild Cognitive Impairment</title>' || LF;
  v_Str := v_Str || '        <value>' || Matrix_Utils.Get_InfoPathData(' PA_Neuro_Mild_Cognitive_Impairment ',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '        <managementPlan>' || Matrix_Utils.Get_InfoPathData('PA_Neuro_Mild_Cognitive_Impairment_Plan_E1                                                  
+ PA_Neuro_Mild_Cognitive_Impairment_Plan_E2                                                  
+ PA_Neuro_Mild_Cognitive_Impairment_Plan_E3                                                  
+ PA_Neuro_Mild_Cognitive_Impairment_Plan_E4                                                  
+ PA_Neuro_Mild_Cognitive_Impairment_Plan_E5                                                  
+ PA_Neuro_Mild_Cognitive_Impairment_Plan_M1                                                  
+ PA_Neuro_Mild_Cognitive_Impairment_Plan_M2                                                  
+ PA_Neuro_Mild_Cognitive_Impairment_Plan_M3                                                  
+ PA_Neuro_Mild_Cognitive_Impairment_Plan_R1                                                  
+ PA_Neuro_Mild_Cognitive_Impairment_Plan_R2',v_CaseId,'MP') ||
  '</managementPlan>' || LF;
  v_Str := v_Str || '   </diagnosis>' || LF;
  
  v_Str := v_Str || '   <diagnosis>' || LF;
  v_Str := v_Str || '        <title>Anxiety</title>' || LF;
  v_Str := v_Str || '        <value>' || Matrix_Utils.Get_InfoPathData(' PA_Neuro_Anxiety ',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '        <managementPlan>' || Matrix_Utils.Get_InfoPathData('PA_Neuro_Anxiety_E1                                                  
+ PA_Neuro_Anxiety_E2                                                  
+ PA_Neuro_Anxiety_E3                                                  
+ PA_Neuro_Anxiety_E4                                                  
+ PA_Neuro_Anxiety_E5                                                  
+ PA_Neuro_Anxiety_M1                                                  
+ PA_Neuro_Anxiety_M2                                                  
+ PA_Neuro_Anxiety_M3                                                  
+ PA_Neuro_Anxiety_R1                                                  
+ PA_Neuro_Anxiety_R2',v_CaseId,'MP') || '</managementPlan>' || LF;
  v_Str := v_Str || '   </diagnosis>' || LF;
  
  v_Str := v_Str || '   <diagnosis>' || LF;
  v_Str := v_Str || '        <title>Bipolar Disorder (manic-depressive)</title>' || LF;
  v_Str := v_Str || '        <value>' || Matrix_Utils.Get_InfoPathData(' PA_Neuro_Bipolar ',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '        <managementPlan>' || Matrix_Utils.Get_InfoPathData('PA_Neuro_Bipolar_Plan_E1                                                  
+ PA_Neuro_Bipolar_Plan_E2                                                  
+ PA_Neuro_Bipolar_Plan_E3                                                  
+ PA_Neuro_Bipolar_Plan_E4                                                  
+ PA_Neuro_Bipolar_Plan_E5                                                  
+ PA_Neuro_Bipolar_Plan_M1                                                  
+ PA_Neuro_Bipolar_Plan_M2                                                  
+ PA_Neuro_Bipolar_Plan_M3                                                  
+ PA_Neuro_Bipolar_Plan_R1                                                  
+ PA_Neuro_Bipolar_Plan_R2',v_CaseId,'MP') || '</managementPlan>' || LF;
  v_Str := v_Str || '   </diagnosis>' || LF;
  
  v_Str := v_Str || '   <diagnosis>' || LF;
  v_Str := v_Str || '        <title>Schizophrenia</title>' || LF;
  v_Str := v_Str || '        <value>' || Matrix_Utils.Get_InfoPathData(' PA_Neuro_Schizophrenia ',v_CaseId,'TF') || '</value>' || LF;
--  v_Str := v_Str || '        <followupQuestions>' || LF;
--  v_Str := v_Str || '            <title>Type of Schizophrenia:</title>' || LF;
--  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData(' PA_Neuro_Schizophrenia ',v_CaseId,'ST') || '</value>' || LF;
--  v_Str := v_Str || '            <otherValue>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</otherValue>' || LF;
--  v_Str := v_Str || '        </followupQuestions>'|| LF;
  v_Str := v_Str || '        <managementPlan>' || Matrix_Utils.Get_InfoPathData('PA_Neuro_Schizophrenia_Plan_E1                                                  
+ PA_Neuro_Schizophrenia_Plan_E2                                                  
+ PA_Neuro_Schizophrenia_Plan_E3                                                  
+ PA_Neuro_Schizophrenia_Plan_E4                                                  
+ PA_Neuro_Schizophrenia_Plan_E5                                                  
+ PA_Neuro_Schizophrenia_Plan_M1                                                  
+ PA_Neuro_Schizophrenia_Plan_M2                                                  
+ PA_Neuro_Schizophrenia_Plan_M3                                                  
+ PA_Neuro_Schizophrenia_Plan_R1                                                  
+ PA_Neuro_Schizophrenia_Plan_R2',v_CaseId,'MP') || '</managementPlan>' || LF;
  v_Str := v_Str || '   </diagnosis>' || LF;
  
  v_Str := v_Str || '   <diagnosis>' || LF;
  v_Str := v_Str || '        <title>Parkinson''s Disease</title>' || LF;
  v_Str := v_Str || '        <value>' || Matrix_Utils.Get_InfoPathData(' PA_Neuro_Parkinsons ',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '      <managementPlan>' || Matrix_Utils.Get_InfoPathData('PA_Neuro_Parkinsons_Plan_E1
+PA_Neuro_Parkinsons_Plan_E2
+PA_Neuro_Parkinsons_Plan_E3
+PA_Neuro_Parkinsons_Plan_E4
+PA_Neuro_Parkinsons_Plan_E5
+PA_Neuro_Parkinsons_Plan_M1
+PA_Neuro_Parkinsons_Plan_M2
+PA_Neuro_Parkinsons_Plan_M3
+PA_Neuro_Parkinsons_Plan_R1
+PA_Neuro_Parkinsons_Plan_R2',v_CaseId,'MP') || '</managementPlan>' || LF;  

  v_Str := v_Str || '   </diagnosis>' || LF;
  
  v_Str := v_Str || '   <diagnosis>' || LF;
  v_Str := v_Str || '        <title>Peripheral Neuropathy (not Diabetes-related)</title>' || LF;
  v_Str := v_Str || '        <value>' || Matrix_Utils.Get_InfoPathData(' PA_Neuro_Peripheral_Neuropathy ',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '      <managementPlan>' || Matrix_Utils.Get_InfoPathData('PA_Neuro_Peripheral_Neuropathy_Plan_E1
+PA_Neuro_Peripheral_Neuropathy_Plan_E2
+PA_Neuro_Peripheral_Neuropathy_Plan_E3
+PA_Neuro_Peripheral_Neuropathy_Plan_E4
+PA_Neuro_Peripheral_Neuropathy_Plan_E5
+PA_Neuro_Peripheral_Neuropathy_Plan_M1
+PA_Neuro_Peripheral_Neuropathy_Plan_M2
+PA_Neuro_Peripheral_Neuropathy_Plan_M3
+PA_Neuro_Peripheral_Neuropathy_Plan_R1
+PA_Neuro_Peripheral_Neuropathy_Plan_R2',v_CaseId,'MP') || '</managementPlan>' || LF;
  v_Str := v_Str || '   </diagnosis>' || LF;
  
  v_Str := v_Str || '   <diagnosis>' || LF;
  v_Str := v_Str || '        <title>Late Effect of Stroke</title>' || LF;
  v_Str := v_Str || '        <value>' || Matrix_Utils.Get_InfoPathData('PA_Neuro_Late_Effect_Stroke',v_CaseId,'YN') || '</value>' || LF;
  v_Str := v_Str || '        <followupQuestions>' || LF;
  v_Str := v_Str || '            <title>Cause:</title>' || LF;
  v_Str := v_Str || '            <answer>' || 'Other Cause' || '</answer>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('PA_Neuro_Late_Effect_Stroke_Other',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </followupQuestions>'|| LF;
  v_Str := v_Str || '        <managementPlan>' || Matrix_Utils.Get_InfoPathData('PA_Neuro_Late_Effect_Stroke_Plan_E1
+PA_Neuro_Late_Effect_Stroke_Plan_E2
+PA_Neuro_Late_Effect_Stroke_Plan_E3
+PA_Neuro_Late_Effect_Stroke_Plan_E4
+PA_Neuro_Late_Effect_Stroke_Plan_E5
+PA_Neuro_Late_Effect_Stroke_Plan_M1
+PA_Neuro_Late_Effect_Stroke_Plan_M2
+PA_Neuro_Late_Effect_Stroke_Plan_M3
+PA_Neuro_Late_Effect_Stroke_Plan_R1
+PA_Neuro_Late_Effect_Stroke_Plan_R2
',v_CaseId,'MP') ||      '</managementPlan>' || LF;
  v_Str := v_Str || '   </diagnosis>' || LF;


  v_Str := v_Str || '   <diagnosis>' || LF;
  v_Str := v_Str || '        <title>Aphasia</title>' || LF;
  v_Str := v_Str || '        <value>' || Matrix_Utils.Get_InfoPathData(' PA_Neuro_Aphasia ',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '        <followupQuestions>' || LF;
  v_Str := v_Str || '            <title>Cause:</title>' || LF;
  v_Str := v_Str || '            <answer>' || 'Other Cause' || '</answer>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </followupQuestions>'|| LF;
  v_Str := v_Str || '        <managementPlan>' || Matrix_Utils.Get_InfoPathData('PA_Neuro_Aphasia_Plan_E1
+PA_Neuro_Aphasia_Plan_E2
+PA_Neuro_Aphasia_Plan_E3
+PA_Neuro_Aphasia_Plan_E4
+PA_Neuro_Aphasia_Plan_E5
+PA_Neuro_Aphasia_Plan_M1
+PA_Neuro_Aphasia_Plan_M2
+PA_Neuro_Aphasia_Plan_M3
+PA_Neuro_Aphasia_Plan_R1
+PA_Neuro_Aphasia_Plan_R2',v_CaseId,'MP') 
                     || '</managementPlan>' || LF;
  v_Str := v_Str || '   </diagnosis>' || LF;


  
  v_Str := v_Str || '   <diagnosis>' || LF;
  v_Str := v_Str || '        <title>Dysphagia</title>' || LF;
  v_Str := v_Str || '        <value>' || Matrix_Utils.Get_InfoPathData(' PA_Neuro_Aphasia_Dysphagia ',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '        <followupQuestions>' || LF;
  v_Str := v_Str || '            <title>Cause:</title>' || LF;
  v_Str := v_Str || '            <answer>' || 'Other Cause' || '</answer>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </followupQuestions>'|| LF;
  v_Str := v_Str || '        <managementPlan>' || Matrix_Utils.Get_InfoPathData('PA_Neuro_Aphasia_Dysphagia_Plan_E1                                                  
+ PA_Neuro_Aphasia_Dysphagia_Plan_E2                                                  
+ PA_Neuro_Aphasia_Dysphagia_Plan_E3                                                  
+ PA_Neuro_Aphasia_Dysphagia_Plan_E4                                                  
+ PA_Neuro_Aphasia_Dysphagia_Plan_E5                                                  
+ PA_Neuro_Aphasia_Dysphagia_Plan_M1                                                  
+ PA_Neuro_Aphasia_Dysphagia_Plan_M2                                                  
+ PA_Neuro_Aphasia_Dysphagia_Plan_M3                                                  
+ PA_Neuro_Aphasia_Dysphagia_Plan_R1                                                  
+ PA_Neuro_Aphasia_Dysphagia_Plan_R2',v_CaseId,'MP') || '</managementPlan>' || LF;
  v_Str := v_Str || '   </diagnosis>' || LF;
  
  v_Str := v_Str || '   <diagnosis>' || LF;
  v_Str := v_Str || '        <title>Hemiparesis</title>' || LF;
  v_Str := v_Str || '        <value>' || Matrix_Utils.Get_InfoPathData(' PA_Neuro_Hemiparesis ',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '        <followupQuestions>' || LF;
  v_Str := v_Str || '            <title>Hemiparesis Dominant</title>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData(' PA_Neuro_Hemiparesis_Dominant ',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </followupQuestions>' || LF;
  v_Str := v_Str || '   </diagnosis>' || LF;
  
  v_Str := v_Str || '  <diagnosis>' || LF;
  v_Str := v_Str || '        <title>Hemiplegia</title>' || LF;
  v_Str := v_Str || '        <value>' || Matrix_Utils.Get_InfoPathData(' PA_Neuro_Hemiplegia ',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '        <followupQuestions>' || LF;
  v_Str := v_Str || '            <title>Dominant</title>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData(' PA_Neuro_Hemiplegia_Dominant ',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </followupQuestions>' || LF;

  v_Str := v_Str || '        <managementPlan>' || Matrix_Utils.Get_InfoPathData('PA_Neuro_Hemi_Plan_E1                                                  
+ PA_Neuro_Hemi_Plan_E2                                                  
+ PA_Neuro_Hemi_Plan_E3                                                  
+ PA_Neuro_Hemi_Plan_E4                                                  
+ PA_Neuro_Hemi_Plan_E5                                                  
+ PA_Neuro_Hemi_Plan_M1                                                  
+ PA_Neuro_Hemi_Plan_M2                                                  
+ PA_Neuro_Hemi_Plan_M3                                                  
+ PA_Neuro_Hemi_Plan_R1                                                  
+ PA_Neuro_Hemi_Plan_R2',v_CaseId,'MP') || '</managementPlan>' || LF;
  v_Str := v_Str || '   </diagnosis>' || LF;
  
  v_Str := v_Str || '   <diagnosis>' || LF;
  v_Str := v_Str || '        <title>Monoparesis</title>' || LF;
  v_Str := v_Str || '        <value>' || Matrix_Utils.Get_InfoPathData(' PA_Neuro_Monoparesis ',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '        <followupQuestions>' || LF;
  v_Str := v_Str || '            <title>Location:</title>' || LF;
  v_Str := v_Str || '            <answer>' || Matrix_Utils.Get_InfoPathData(' PA_Neuro_Monoparesis_Lower_Extremity 
+ PA_Neuro_Monoparesis_Upper_Extremity',v_CaseId,'ST') || '</answer>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </followupQuestions>'|| LF;
  v_Str := v_Str || '        <followupQuestions>' || LF;
  v_Str := v_Str || '            <title>Cause:</title>' || LF;
  v_Str := v_Str || '            <answer>' || 'Late Effect of Stroke' || '</answer>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </followupQuestions>'|| LF;
  v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
  v_Str := v_Str || '        <title>Monoplegia</title>' || LF;
  v_Str := v_Str || '        <value>' || Matrix_Utils.Get_InfoPathData(' PA_Neuro_Monoplegia ',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        <followupQuestions>' || LF;
  v_Str := v_Str || '            <title>Location:</title>' || LF;
  v_Str := v_Str || '            <answer>' || Matrix_Utils.Get_InfoPathData(' PA_Neuro_Monoplegia_Lower_Extremity 
+ PA_Neuro_Monoplegia_Upper_Extremity 
',v_CaseId,'ST') || '</answer>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </followupQuestions>'|| LF;
  v_Str := v_Str || '        <followupQuestions>' || LF;
  v_Str := v_Str || '            <title>Cause:</title>' || LF;
  v_Str := v_Str || '            <answer>' || 'Late Effect of Stroke' || '</answer>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </followupQuestions>'|| LF;
  v_Str := v_Str || '        <managementPlan>' || Matrix_Utils.Get_InfoPathData('PA_Neuro_Mono_Plan_E1                                                  
+ PA_Neuro_Mono_Plan_E2                                                  
+ PA_Neuro_Mono_Plan_E3                                                  
+ PA_Neuro_Mono_Plan_E4                                                  
+ PA_Neuro_Mono_Plan_E5                                                  
+ PA_Neuro_Mono_Plan_M1                                                  
+ PA_Neuro_Mono_Plan_M2                                                  
+ PA_Neuro_Mono_Plan_M3                                                  
+ PA_Neuro_Mono_Plan_R1                                                  
+ PA_Neuro_Mono_Plan_R2',v_CaseId,'MP') || '</managementPlan>' || LF;
  v_Str := v_Str || '        <followupQuestions>' || LF;
  v_Str := v_Str || '            <title>other</title>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('PA_Neuro_Stroke_Other',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '            <otherValue>' || Matrix_Utils.Get_InfoPathData('PA_Neuro_Stroke_Other_Box',v_CaseId,'ST') || '</otherValue>' || LF;
  v_Str := v_Str || '        </followupQuestions>'|| LF;
  v_Str := v_Str || '        <managementPlan>' || Matrix_Utils.Get_InfoPathData('PA_Neuro_Stroke_Other_Plan_E1                                                  
+ PA_Neuro_Stroke_Other_Plan_E2                                                  
+ PA_Neuro_Stroke_Other_Plan_E3                                                  
+ PA_Neuro_Stroke_Other_Plan_E4                                                  
+ PA_Neuro_Stroke_Other_Plan_E5                                                  
+ PA_Neuro_Stroke_Other_Plan_M1                                                  
+ PA_Neuro_Stroke_Other_Plan_M2                                                  
+ PA_Neuro_Stroke_Other_Plan_M3                                                  
+ PA_Neuro_Stroke_Other_Plan_R1                                                  
+ PA_Neuro_Stroke_Other_Plan_R2',v_CaseId,'MP') || '</managementPlan>' || LF;
  v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
  v_Str := v_Str || '        <title>History TIA or of a Stroke without Residual Deficits</title>' || LF;
  v_Str := v_Str || '        <value>' || Matrix_Utils.Get_InfoPathData(' PA_Neuro_TIA + PA_Neuro_History_Stroke ',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '        <managementPlan>' || Matrix_Utils.Get_InfoPathData(
  'PA_Neuro_TIA_E1                                                  
+ PA_Neuro_TIA_Plan_E2                                                  
+ PA_Neuro_TIA_Plan_E3                                                  
+ PA_Neuro_TIA_Plan_E4                                                  
+ PA_Neuro_TIA_Plan_E5                                                  
+ PA_Neuro_TIA_Plan_M1                                                  
+ PA_Neuro_TIA_Plan_M2                                                  
+ PA_Neuro_TIA_Plan_M3                                                  
+ PA_Neuro_TIA_Plan_R1                                                  
+ PA_Neuro_TIA_Plan_R2                                                  
+ PA_Neuro_History_Stroke_Plan_E1                                                  
+ PA_Neuro_History_Stroke_Plan_E2                                                  
+ PA_Neuro_History_Stroke_Plan_E3                                                  
+ PA_Neuro_History_Stroke_Plan_E4                                                  
+ PA_Neuro_History_Stroke_Plan_E5                                                  
+ PA_Neuro_History_Stroke_Plan_M1                                                  
+ PA_Neuro_History_Stroke_Plan_M2                                                  
+ PA_Neuro_History_Stroke_Plan_M3                                                  
+ PA_Neuro_History_Stroke_Plan_R1                                                  
+ PA_Neuro_History_Stroke_Plan_R2'
  ,v_CaseId,'MP') || '</managementPlan>' || LF;
  v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
  v_Str := v_Str || '        <title>Epilepsy or Seizure Disorder</title>' || LF;
  v_Str := v_Str || '        <value>' || Matrix_Utils.Get_InfoPathData(' PA_Neuro_Epilepsy ',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '        <managementPlan>' || Matrix_Utils.Get_InfoPathData('PA_Neuro_Epilepsy_Plan_E1                                                  
+ PA_Neuro_Epilepsy_Plan_E2                                                  
+ PA_Neuro_Epilepsy_Plan_E3                                                  
+ PA_Neuro_Epilepsy_Plan_E4                                                  
+ PA_Neuro_Epilepsy_Plan_E5                                                  
+ PA_Neuro_Epilepsy_Plan_M1                                                  
+ PA_Neuro_Epilepsy_Plan_M2                                                  
+ PA_Neuro_Epilepsy_Plan_M3                                                  
+ PA_Neuro_Epilepsy_Plan_R1                                                  
+ PA_Neuro_Epilepsy_Plan_R2',v_CaseId,'MP') || '</managementPlan>' || LF;
  v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
  v_Str := v_Str || '        <title>Other convulsions</title>' || LF;
  v_Str := v_Str || '        <value>' || Matrix_Utils.Get_InfoPathData(' PA_Neuro_Convulsions ',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '        <managementPlan>' || Matrix_Utils.Get_InfoPathData('PA_Neuro_Convulsions_E1                                                  
+ PA_Neuro_Convulsions_E2                                                  
+ PA_Neuro_Convulsions_E3                                                  
+ PA_Neuro_Convulsions_E4                                                  
+ PA_Neuro_Convulsions_E5                                                  
+ PA_Neuro_Convulsions_M1                                                  
+ PA_Neuro_Convulsions_M2                                                  
+ PA_Neuro_Convulsions_M3                                                  
+ PA_Neuro_Convulsions_R1                                                  
+ PA_Neuro_Convulsions_R2',v_CaseId,'MP') || '</managementPlan>' || LF;
  v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
  v_Str := v_Str || '        <title>Quadriplegia</title>' || LF;
  v_Str := v_Str || '        <value>' || Matrix_Utils.Get_InfoPathData(' PA_Neuro_Quadriplegia ',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '        <managementPlan>' || Matrix_Utils.Get_InfoPathData('PA_Neuro_Quadriplegia_Plan_E1                                                  
+ PA_Neuro_Quadriplegia_Plan_E2                                                  
+ PA_Neuro_Quadriplegia_Plan_E3                                                  
+ PA_Neuro_Quadriplegia_Plan_E4                                                  
+ PA_Neuro_Quadriplegia_Plan_E5                                                  
+ PA_Neuro_Quadriplegia_Plan_M1                                                  
+ PA_Neuro_Quadriplegia_Plan_M2                                                  
+ PA_Neuro_Quadriplegia_Plan_M3                                                  
+ PA_Neuro_Quadriplegia_Plan_R1                                                  
+ PA_Neuro_Quadriplegia_Plan_R2',v_CaseId,'MP') || '</managementPlan>' || LF;
  v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
  v_Str := v_Str || '        <title>Paraplegia</title>' || LF;
  v_Str := v_Str || '        <value>' || Matrix_Utils.Get_InfoPathData(' PA_Neuro_Paraplegia ',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '        <managementPlan>' || Matrix_Utils.Get_InfoPathData('PA_Neuro_Paraplegia_Plan_E1                                                  
+ PA_Neuro_Paraplegia_Plan_E2                                                  
+ PA_Neuro_Paraplegia_Plan_E3                                                  
+ PA_Neuro_Paraplegia_Plan_E4                                                  
+ PA_Neuro_Paraplegia_Plan_E5                                                  
+ PA_Neuro_Paraplegia_Plan_M1                                                  
+ PA_Neuro_Paraplegia_Plan_M2                                                  
+ PA_Neuro_Paraplegia_Plan_M3                                                  
+ PA_Neuro_Paraplegia_Plan_R1                                                  
+ PA_Neuro_Paraplegia_Plan_R2',v_CaseId,'MP') || '</managementPlan>' || LF;
  v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
  v_Str := v_Str || '        <title>Insomnia</title>' || LF;
  v_Str := v_Str || '        <value>' || Matrix_Utils.Get_InfoPathData(' PA_Neuro_Insomnia ',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '        <managementPlan>' || Matrix_Utils.Get_InfoPathData('PA_Neuro_Insomnia_Plan_E1                                                  
+ PA_Neuro_Insomnia_Plan_E2                                                  
+ PA_Neuro_Insomnia_Plan_E3                                                  
+ PA_Neuro_Insomnia_Plan_E4                                                  
+ PA_Neuro_Insomnia_Plan_E5                                                  
+ PA_Neuro_Insomnia_Plan_M1                                                  
+ PA_Neuro_Insomnia_Plan_M2                                                  
+ PA_Neuro_Insomnia_Plan_M3                                                  
+ PA_Neuro_Insomnia_Plan_R1                                                  
+ PA_Neuro_Insomnia_Plan_R2',v_CaseId,'MP') || '</managementPlan>' || LF;
  v_Str := v_Str || '   </diagnosis>'|| LF;
  
  v_Str := v_Str || '   <diagnosis>' || LF;
  v_Str := v_Str || '        <title>Other Significant Diagnoses:</title>' || LF;
  v_Str := v_Str || '        <value>' || Matrix_Utils.Get_InfoPathData(' PA_Neuro_Other_Significant ',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '        <followupQuestions>' || LF;
  v_Str := v_Str || '            <title>Other:</title>' || LF;
  v_Str := v_Str || '            <answer>' || Matrix_Utils.Get_InfoPathData(' PA_Neuro_Other_Significant_Box ',v_CaseId,'ST') || '</answer>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </followupQuestions>'|| LF;
  v_Str := v_Str || '        <managementPlan>' || Matrix_Utils.Get_InfoPathData('PA_Neuro_Other_Significant_Plan_E1                                                  
+ PA_Neuro_Other_Significant_Plan_E2                                                  
+ PA_Neuro_Other_Significant_Plan_E3                                                  
+ PA_Neuro_Other_Significant_Plan_E4                                                  
+ PA_Neuro_Other_Significant_Plan_E5                                                  
+ PA_Neuro_Other_Significant_Plan_M1                                                  
+ PA_Neuro_Other_Significant_Plan_M2                                                  
+ PA_Neuro_Other_Significant_Plan_M3                                                  
+ PA_Neuro_Other_Significant_Plan_R1                                                  
+ PA_Neuro_Other_Significant_Plan_R2',v_CaseId,'MP') 
                     || '</managementPlan>' || LF;
  v_Str := v_Str || '   </diagnosis>'|| LF;
  v_Str := v_Str || ' </sections>'|| LF;


  v_Str := v_Str || ' <sections>'|| LF;
  v_Str := v_Str || '   <title>Pulmonary</title>' || LF;
  v_Str := v_Str || '   <diagnosis>' || LF;
  v_Str := v_Str || '        <title>Chronic Bronchitis:</title>' || LF;
  v_Str := v_Str || '        <value>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '        <followupQuestions>' || LF;
  v_Str := v_Str || '            <title>Specify:</title>' || LF;
  v_Str := v_Str || '            <answer>' || Matrix_Utils.Get_InfoPathData(' PA_Pulmonary_Bronchitis_Simple 
+ PA_Pulmonary_Bronchitis_Mucopurulent 
+ PA_Pulmonary_Bronchitis_Exacerbation 
',v_CaseId,'ST') || '</answer>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </followupQuestions>'|| LF;
  v_Str := v_Str || '        <managementPlan>' || Matrix_Utils.Get_InfoPathData('PA_Pulmonary_Bronchitis_Plan_E1                                                  
+ PA_Pulmonary_Bronchitis_Plan_E2                                                  
+ PA_Pulmonary_Bronchitis_Plan_E3                                                  
+ PA_Pulmonary_Bronchitis_Plan_E4                                                  
+ PA_Pulmonary_Bronchitis_Plan_E5                                                  
+ PA_Pulmonary_Bronchitis_Plan_M1                                                  
+ PA_Pulmonary_Bronchitis_Plan_M2                                                  
+ PA_Pulmonary_Bronchitis_Plan_M3                                                  
+ PA_Pulmonary_Bronchitis_Plan_R1                                                  
+ PA_Pulmonary_Bronchitis_Plan_R2                                                  
',v_CaseId,'MP') || '</managementPlan>' || LF;
  v_Str := v_Str || '   </diagnosis>'|| LF;
  
  v_Str := v_Str || '   <diagnosis>' || LF;
  v_Str := v_Str || '        <title>Chronic Airway Obstruction/COPD</title>' || LF;
  v_Str := v_Str || '        <value>' || Matrix_Utils.Get_InfoPathData(' PA_Pulmonary_COPD ',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '        <managementPlan>' || Matrix_Utils.Get_InfoPathData('PA_Pulmonary_COPD_Plan_E1                                                  
+ PA_Pulmonary_COPD_Plan_E2                                                  
+ PA_Pulmonary_COPD_Plan_E3                                                  
+ PA_Pulmonary_COPD_Plan_E4                                                  
+ PA_Pulmonary_COPD_Plan_E5                                                  
+ PA_Pulmonary_COPD_Plan_M1                                                  
+ PA_Pulmonary_COPD_Plan_M2                                                  
+ PA_Pulmonary_COPD_Plan_M3                                                  
+ PA_Pulmonary_COPD_Plan_R1                                                  
+ PA_Pulmonary_COPD_Plan_R2                                                  
',v_CaseId,'MP') || '</managementPlan>' || LF;
  v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
  v_Str := v_Str || '        <title>Emphysema</title>' || LF;
  v_Str := v_Str || '        <value>' || Matrix_Utils.Get_InfoPathData(' PA_Pulmonary_Emphysema ',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '        <managementPlan>' || Matrix_Utils.Get_InfoPathData('PA_Pulmonary_Emphysema_Plan_E1                                                  
+ PA_Pulmonary_Emphysema_Plan_E2                                                  
+ PA_Pulmonary_Emphysema_Plan_E3                                                  
+ PA_Pulmonary_Emphysema_Plan_E4                                                  
+ PA_Pulmonary_Emphysema_Plan_E5                                                  
+ PA_Pulmonary_Emphysema_Plan_M1                                                  
+ PA_Pulmonary_Emphysema_Plan_M2                                                  
+ PA_Pulmonary_Emphysema_Plan_M3                                                  
+ PA_Pulmonary_Emphysema_Plan_R1                                                  
+ PA_Pulmonary_Emphysema_Plan_R2                                                  
',v_CaseId,'MP') || '</managementPlan>' || LF;
  v_Str := v_Str || '   </diagnosis>'|| LF;
  
  v_Str := v_Str || '   <diagnosis>' || LF;
  v_Str := v_Str || '        <title>Tracheostomy Status (current)</title>' || LF;
  v_Str := v_Str || '        <value>' || Matrix_Utils.Get_InfoPathData(' PA_Pulmonary_Tracheostomy ',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '        <managementPlan>' || Matrix_Utils.Get_InfoPathData('PA_Pulmonary_Tracheostomy_Plan_E1                                                  
+ PA_Pulmonary_Tracheostomy_Plan_E2                                                  
+ PA_Pulmonary_Tracheostomy_Plan_E3                                                  
+ PA_Pulmonary_Tracheostomy_Plan_E4                                                  
+ PA_Pulmonary_Tracheostomy_Plan_E5                                                  
+ PA_Pulmonary_Tracheostomy_Plan_M1                                                  
+ PA_Pulmonary_Tracheostomy_Plan_M2                                                  
+ PA_Pulmonary_Tracheostomy_Plan_M3                                                  
+ PA_Pulmonary_Tracheostomy_Plan_R1                                                  
+ PA_Pulmonary_Tracheostomy_Plan_R2                                                  
',v_CaseId,'MP') || '</managementPlan>' || LF;
  v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
  v_Str := v_Str || '        <title>Ventilator Dependent</title>' || LF;
  v_Str := v_Str || '        <value>' || Matrix_Utils.Get_InfoPathData(' PA_Pulmonary_Ventilator ',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '        <managementPlan>' || Matrix_Utils.Get_InfoPathData('PA_Pulmonary_Ventilator_Plan_E1                                                  
+ PA_Pulmonary_Ventilator_Plan_E2                                                  
+ PA_Pulmonary_Ventilator_Plan_E3                                                  
+ PA_Pulmonary_Ventilator_Plan_E4                                                  
+ PA_Pulmonary_Ventilator_Plan_E5                                                  
+ PA_Pulmonary_Ventilator_Plan_M1                                                  
+ PA_Pulmonary_Ventilator_Plan_M2                                                  
+ PA_Pulmonary_Ventilator_Plan_M3                                                  
+ PA_Pulmonary_Ventilator_Plan_R1                                                  
+ PA_Pulmonary_Ventilator_Plan_R2                                                  
',v_CaseId,'MP') || '</managementPlan>' || LF;
  v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
  v_Str := v_Str || '        <title>Supplemental O2</title>' || LF;
  v_Str := v_Str || '        <value>' || Matrix_Utils.Get_InfoPathData(' PA_Pulmonary_Supplemental_O2 ',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '        <managementPlan>' || Matrix_Utils.Get_InfoPathData('PA_Pulmonary_Supplemental_O2_Plan_E1                                                  
+ PA_Pulmonary_Supplemental_O2_Plan_E2                                                  
+ PA_Pulmonary_Supplemental_O2_Plan_E3                                                  
+ PA_Pulmonary_Supplemental_O2_Plan_E4                                                  
+ PA_Pulmonary_Supplemental_O2_Plan_E5                                                  
+ PA_Pulmonary_Supplemental_O2_Plan_M1                                                  
+ PA_Pulmonary_Supplemental_O2_Plan_M2                                                  
+ PA_Pulmonary_Supplemental_O2_Plan_M3                                                  
+ PA_Pulmonary_Supplemental_O2_Plan_R1                                                  
+ PA_Pulmonary_Supplemental_O2_Plan_R2                                                  
',v_CaseId,'MP') ||
  '</managementPlan>' || LF;
  v_Str := v_Str || '   </diagnosis>'|| LF;
  
  v_Str := v_Str || '   <diagnosis>' || LF;
  v_Str := v_Str || '        <title>Chronic Respiratory Failure</title>' || LF;
  v_Str := v_Str || '        <value>' || Matrix_Utils.Get_InfoPathData(' PA_Pulmonary_Chronic_Respiratory_Failure ',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '        <managementPlan>' || Matrix_Utils.Get_InfoPathData(
  'PA_Pulmonary_Respiratory_Failure_Plan_E1                                                  
+ PA_Pulmonary_Respiratory_Failure_Plan_E2                                                  
+ PA_Pulmonary_Respiratory_Failure_Plan_E3                                                  
+ PA_Pulmonary_Respiratory_Failure_Plan_E4                                                  
+ PA_Pulmonary_Respiratory_Failure_Plan_E5                                                  
+ PA_Pulmonary_Respiratory_Failure_Plan_M1                                                  
+ PA_Pulmonary_Respiratory_Failure_Plan_M2                                                  
+ PA_Pulmonary_Respiratory_Failure_Plan_M3                                                  
+ PA_Pulmonary_Respiratory_Failure_Plan_R1                                                  
+ PA_Pulmonary_Respiratory_Failure_Plan_R2                                                  
',v_CaseId,'MP') || '</managementPlan>' || LF;
  v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
  v_Str := v_Str || '        <title>Asthma/Acute Exacerbation</title>' || LF;
  v_Str := v_Str || '        <value>' || Matrix_Utils.Get_InfoPathData(' PA_Pulmonary_Asthma ',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '        <followupQuestions>' || LF;
  v_Str := v_Str || '            <title>Specify:</title>' || LF;
  v_Str := v_Str || '            <answer>' || Matrix_Utils.Get_InfoPathData(' PA_Pulmonary_Asthma_Acute_Exacerbation ',v_CaseId,'ST') || '</answer>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </followupQuestions>'|| LF;
  v_Str := v_Str || '        <managementPlan>' || Matrix_Utils.Get_InfoPathData('PA_Pulmonary_Asthma_Plan_E1                                                  
+ PA_Pulmonary_Asthma_Plan_E2                                                  
+ PA_Pulmonary_Asthma_Plan_E3                                                  
+ PA_Pulmonary_Asthma_Plan_E4                                                  
+ PA_Pulmonary_Asthma_Plan_E5                                                  
+ PA_Pulmonary_Asthma_Plan_M1                                                  
+ PA_Pulmonary_Asthma_Plan_M2                                                  
+ PA_Pulmonary_Asthma_Plan_M3                                                  
+ PA_Pulmonary_Asthma_Plan_R1                                                  
+ PA_Pulmonary_Asthma_Plan_R2                                                  
',v_CaseId,'MP') || '</managementPlan>' || LF;
  v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
  v_Str := v_Str || '        <title>Other Significant Diagnoses</title>' || LF;
  v_Str := v_Str || '        <value>' || Matrix_Utils.Get_InfoPathData(' PA_Pulmonary_Other ',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '        <followupQuestions>' || LF;
  v_Str := v_Str || '            <title>Other:</title>' || LF;
  v_Str := v_Str || '            <answer>' || Matrix_Utils.Get_InfoPathData(' PA_Pulmonary_Other_Box',v_CaseId,'ST') || '</answer>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </followupQuestions>'|| LF;
  v_Str := v_Str || '        <managementPlan>' || Matrix_Utils.Get_InfoPathData('PA_Pulmonary_Other_Plan_E1                                                  
+ PA_Pulmonary_Other_Plan_E2                                                  
+ PA_Pulmonary_Other_Plan_E3                                                  
+ PA_Pulmonary_Other_Plan_E4                                                  
+ PA_Pulmonary_Other_Plan_E5                                                  
+ PA_Pulmonary_Other_Plan_M1                                                  
+ PA_Pulmonary_Other_Plan_M2                                                  
+ PA_Pulmonary_Other_Plan_M3                                                  
+ PA_Pulmonary_Other_Plan_R1                                                  
+ PA_Pulmonary_Other_Plan_R2                                                  
',v_CaseId,'MP') || '</managementPlan>' || LF;
  v_Str := v_Str || '   </diagnosis>'|| LF;
  v_Str := v_Str || ' </sections>'|| LF;

  v_Str := v_Str || ' <sections>'|| LF;
  v_Str := v_Str || '   <title>Hematology/Oncology</title>' || LF;
  v_Str := v_Str || '   <diagnosis>' || LF;
  v_Str := v_Str || '        <title>Anemia</title>' || LF;
  v_Str := v_Str || '        <value>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '        <followupQuestions>' || LF;
  v_Str := v_Str || '            <title>Type:</title>' || LF;
  v_Str := v_Str || '            <answer>' || Matrix_Utils.Get_InfoPathData(' PA_Hematology_Anemia_Acute ',v_CaseId,'ST') || '</answer>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </followupQuestions>'|| LF;
  v_Str := v_Str || '        <followupQuestions>' || LF;
  v_Str := v_Str || '            <title>Type:</title>' || LF;
  v_Str := v_Str || '            <answer>' || Matrix_Utils.Get_InfoPathData(' PA_Hematology_Anemia_CKD ',v_CaseId,'ST') || '</answer>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </followupQuestions>'|| LF;
  v_Str := v_Str || '        <followupQuestions>' || LF;
  v_Str := v_Str || '            <title>Type:</title>' || LF;
  v_Str := v_Str || '            <answer>' || Matrix_Utils.Get_InfoPathData(' PA_Hematology_Anemia_Other_Chronic ',v_CaseId,'ST') || '</answer>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </followupQuestions>'|| LF;
  v_Str := v_Str || '        <followupQuestions>' || LF;
  v_Str := v_Str || '            <title>Type:</title>' || LF;
  v_Str := v_Str || '            <answer>' || Matrix_Utils.Get_InfoPathData(' PA_Hematology_Anemia_Aplastic ',v_CaseId,'ST') || '</answer>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </followupQuestions>'|| LF;
  v_Str := v_Str || '        <followupQuestions>' || LF;
  v_Str := v_Str || '            <title>Type:</title>' || LF;
  v_Str := v_Str || '            <answer>' || Matrix_Utils.Get_InfoPathData(' PA_Hematology_Anemia_Iron_Deficiency ',v_CaseId,'ST') || '</answer>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </followupQuestions>'|| LF;
  v_Str := v_Str || '        <followupQuestions>' || LF;
  v_Str := v_Str || '            <title>Type:</title>' || LF;
  v_Str := v_Str || '            <answer>' || Matrix_Utils.Get_InfoPathData(' PA_Hematology_Anemia_Unknown ',v_CaseId,'ST') || '</answer>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </followupQuestions>'|| LF;
  v_Str := v_Str || '        <managementPlan>' || Matrix_Utils.Get_InfoPathData('PA_Hematology_Anemia_Plan_E1                                                  
+ PA_Hematology_Anemia_Plan_E2                                                  
+ PA_Hematology_Anemia_Plan_E3                                                  
+ PA_Hematology_Anemia_Plan_E4                                                  
+ PA_Hematology_Anemia_Plan_E5                                                  
+ PA_Hematology_Anemia_Plan_M1                                                  
+ PA_Hematology_Anemia_Plan_M2                                                  
+ PA_Hematology_Anemia_Plan_M3                                                  
+ PA_Hematology_Anemia_Plan_R1                                                  
+ PA_Hematology_Anemia_Plan_R2                                                  
',v_CaseId,'MP') || '</managementPlan>' || LF;
  v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
  v_Str := v_Str || '        <title>Hemolytic Anemia</title>' || LF;
  v_Str := v_Str || '        <value>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '        <followupQuestions>' || LF;
  v_Str := v_Str || '            <title>Type:</title>' || LF;
  v_Str := v_Str || '            <answer>' || Matrix_Utils.Get_InfoPathData(' PA_Hematology_Hemolytic_Anemia_Autoimmune ',v_CaseId,'ST') || '</answer>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </followupQuestions>'|| LF;
  v_Str := v_Str || '        <followupQuestions>' || LF;
  v_Str := v_Str || '            <title>Type:</title>' || LF;
  v_Str := v_Str || '            <answer>' || Matrix_Utils.Get_InfoPathData(' PA_Hematology_Hemolytic_Anemia_NonAutoimmune ',v_CaseId,'ST') || '</answer>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </followupQuestions>'|| LF;
  v_Str := v_Str || '        <followupQuestions>' || LF;
  v_Str := v_Str || '            <title>Class:</title>' || LF;
  v_Str := v_Str || '            <answer>' || Matrix_Utils.Get_InfoPathData(' PA_Hematology_Neutropenia ',v_CaseId,'ST') || '</answer>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </followupQuestions>'|| LF;
  v_Str := v_Str || '        <followupQuestions>' || LF;
  v_Str := v_Str || '            <title>Class:</title>' || LF;
  v_Str := v_Str || '            <answer>' || Matrix_Utils.Get_InfoPathData(' PA_Hematology_Agranulocytosis ',v_CaseId,'ST') || '</answer>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </followupQuestions>'|| LF;
  v_Str := v_Str || '        <followupQuestions>' || LF;
  v_Str := v_Str || '            <title>Class:</title>' || LF;
  v_Str := v_Str || '            <answer>' || Matrix_Utils.Get_InfoPathData(' PA_Hematology_Pancytopenia ',v_CaseId,'ST') || '</answer>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </followupQuestions>'|| LF;
  v_Str := v_Str || '        <managementPlan>' || Matrix_Utils.Get_InfoPathData(
  'PA_Hematology_Hemolytic_Anemia_Plan_E1                                                  
+ PA_Hematology_Hemolytic_Anemia_Plan_E2                                                  
+ PA_Hematology_Hemolytic_Anemia_Plan_E3                                                  
+ PA_Hematology_Hemolytic_Anemia_Plan_E4                                                  
+ PA_Hematology_Hemolytic_Anemia_Plan_E5                                                  
+ PA_Hematology_Hemolytic_Anemia_Plan_M1                                                  
+ PA_Hematology_Hemolytic_Anemia_Plan_M2                                                  
+ PA_Hematology_Hemolytic_Anemia_Plan_M3                                                  
+ PA_Hematology_Hemolytic_Anemia_Plan_R1                                                  
+ PA_Hematology_Hemolytic_Anemia_Plan_R2                                                  
+ PA_Hematology_Neutropenia_Plan_E1                                                  
+ PA_Hematology_Neutropenia_Plan_E2                                                  
+ PA_Hematology_Neutropenia_Plan_E3                                                  
+ PA_Hematology_Neutropenia_Plan_E4                                                  
+ PA_Hematology_Neutropenia_Plan_E5                                                  
+ PA_Hematology_Neutropenia_Plan_M1                                                  
+ PA_Hematology_Neutropenia_Plan_M2                                                  
+ PA_Hematology_Neutropenia_Plan_M3                                                  
+ PA_Hematology_Neutropenia_Plan_R1                                                  
+ PA_Hematology_Neutropenia_Plan_R2 '
  ,v_CaseId,'MP') || '</managementPlan>' || LF;
  v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
  v_Str := v_Str || '        <title>Thrombocytopenia</title>' || LF;
  v_Str := v_Str || '        <value>' || Matrix_Utils.Get_InfoPathData(' PA_Hematology_Thrombocytopenia ',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '        <managementPlan>' || Matrix_Utils.Get_InfoPathData('PA_Hematology_Thrombocytopenia_Plan_E1                                                  
+ PA_Hematology_Thrombocytopenia_Plan_E2                                                  
+ PA_Hematology_Thrombocytopenia_Plan_E3                                                  
+ PA_Hematology_Thrombocytopenia_Plan_E4                                                  
+ PA_Hematology_Thrombocytopenia_Plan_E5                                                  
+ PA_Hematology_Thrombocytopenia_Plan_M1                                                  
+ PA_Hematology_Thrombocytopenia_Plan_M2                                                  
+ PA_Hematology_Thrombocytopenia_Plan_M3                                                  
+ PA_Hematology_Thrombocytopenia_Plan_R1                                                  
+ PA_Hematology_Thrombocytopenia_Plan_R2                                                  
',v_CaseId ,
  'MP') || '</managementPlan>' || LF;
  v_Str := v_Str || '   </diagnosis>'|| LF;
  
  v_Str := v_Str || '   <diagnosis>' || LF;
  v_Str := v_Str || '        <title>B12 Deficiency</title>' || LF;
  v_Str := v_Str || '        <value>' || Matrix_Utils.Get_InfoPathData(' PA_Hematology_B12_Deficiency ',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '        <managementPlan>' || Matrix_Utils.Get_InfoPathData('PA_Hematology_B12_Deficiency_Plan_E1                                                  
+ PA_Hematology_B12_Deficiency_Plan_E2                                                  
+ PA_Hematology_B12_Deficiency_Plan_E3                                                  
+ PA_Hematology_B12_Deficiency_Plan_E4                                                  
+ PA_Hematology_B12_Deficiency_Plan_E5                                                  
+ PA_Hematology_B12_Deficiency_Plan_M1                                                  
+ PA_Hematology_B12_Deficiency_Plan_M2                                                  
+ PA_Hematology_B12_Deficiency_Plan_M3                                                  
+ PA_Hematology_B12_Deficiency_Plan_R1                                                  
+ PA_Hematology_B12_Deficiency_Plan_R2                                                  
',v_CaseId,'MP') ||
  '</managementPlan>' || LF;
  v_Str := v_Str || '   </diagnosis>'|| LF;
  
  v_Str := v_Str || '   <diagnosis>' || LF;
  v_Str := v_Str || '        <title>Leukemia</title>' || LF;
  v_Str := v_Str || '        <value>' || Matrix_Utils.Get_InfoPathData(' PA_Hematology_Leukemia ',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '        <followupQuestions>' || LF;
  v_Str := v_Str || '            <title>Type:</title>' || LF;
  v_Str := v_Str || '            <answer>' || Matrix_Utils.Get_InfoPathData(' PA_Hematology_Leukemia_Box ',v_CaseId,'ST') || '</answer>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </followupQuestions>'|| LF;
  v_Str := v_Str || '        <followupQuestions>' || LF;
  v_Str := v_Str || '            <title>State:</title>' || LF;
  v_Str := v_Str || '            <answer>' || Matrix_Utils.Get_InfoPathData('PA_Hematology_Leukemia_Active 
+ PA_Hematology_Leukemia_Relapse 
+ PA_Hematology_Leukemia_Remission
',v_CaseId,'ST') || '</answer>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </followupQuestions>'|| LF;
  v_Str := v_Str || '        <managementPlan>' || Matrix_Utils.Get_InfoPathData('PA_Hematology_Leukemia_Plan_E1                                                  
+ PA_Hematology_Leukemia_Plan_E2                                                  
+ PA_Hematology_Leukemia_Plan_E3                                                  
+ PA_Hematology_Leukemia_Plan_E4                                                  
+ PA_Hematology_Leukemia_Plan_E5                                                  
+ PA_Hematology_Leukemia_Plan_M1                                                  
+ PA_Hematology_Leukemia_Plan_M2                                                  
+ PA_Hematology_Leukemia_Plan_M3                                                  
+ PA_Hematology_Leukemia_Plan_R1                                                  
+ PA_Hematology_Leukemia_Plan_R2                                                  
',v_CaseId,'MP') || '</managementPlan>' || LF;
  v_Str := v_Str || '   </diagnosis>'|| LF;
  
  v_Str := v_Str || '   <diagnosis>' || LF;
  v_Str := v_Str || '        <title>Lymphoma</title>' || LF;
  v_Str := v_Str || '        <value>' || Matrix_Utils.Get_InfoPathData(' PA_Hematology_Lymphoma ',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '        <followupQuestions>' || LF;
  v_Str := v_Str || '            <title>Type:</title>' || LF;
  v_Str := v_Str || '            <answer>' || Matrix_Utils.Get_InfoPathData('PA_Hematology_Lymphoma_Box ',v_CaseId,'ST') || '</answer>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </followupQuestions>'|| LF;
  v_Str := v_Str || '        <followupQuestions>' || LF;
  v_Str := v_Str || '            <title>State:</title>' || LF;
  v_Str := v_Str || '            <answer>' || Matrix_Utils.Get_InfoPathData('PA_Hematology_Lymphoma_Active+ PA_Hematology_Lymphoma_Remission',v_CaseId,'ST') || '</answer>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </followupQuestions>'|| LF;
  
     v_Str := v_Str || '      <managementPlan>' || Matrix_Utils.Get_InfoPathData('PA_Hematology_Lymphoma_Plan_E1
+PA_Hematology_Lymphoma_Plan_E2
+PA_Hematology_Lymphoma_Plan_E3
+PA_Hematology_Lymphoma_Plan_E4
+PA_Hematology_Lymphoma_Plan_E5
+PA_Hematology_Lymphoma_Plan_M1
+PA_Hematology_Lymphoma_Plan_M2
+PA_Hematology_Lymphoma_Plan_M3
+PA_Hematology_Lymphoma_Plan_R1
+PA_Hematology_Lymphoma_Plan_R2',v_CaseId,'MP') 
                     || '</managementPlan>' || LF;
  v_Str := v_Str || '   </diagnosis>'|| LF;
  
  v_Str := v_Str || '   <diagnosis>' || LF;
  v_Str := v_Str || '        <title>Benign neoplasm of Brain or Meninges</title>' || LF;
  v_Str := v_Str || '        <value>' || Matrix_Utils.Get_InfoPathData(' PA_Hematology_Benign_Neoplasm_Brain ',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '        <managementPlan>' || Matrix_Utils.Get_InfoPathData(
  'PA_Hematology_Benign_Neoplasm_Brain_Plan_E1                                                  
+ PA_Hematology_Benign_Neoplasm_Brain_Plan_E2                                                  
+ PA_Hematology_Benign_Neoplasm_Brain_Plan_E3                                                  
+ PA_Hematology_Benign_Neoplasm_Brain_Plan_E4                                                  
+ PA_Hematology_Benign_Neoplasm_Brain_Plan_E5                                                  
+ PA_Hematology_Benign_Neoplasm_Brain_Plan_M1                                                  
+ PA_Hematology_Benign_Neoplasm_Brain_Plan_M2                                                  
+ PA_Hematology_Benign_Neoplasm_Brain_Plan_M3                                                  
+ PA_Hematology_Benign_Neoplasm_Brain_Plan_R1                                                  
+ PA_Hematology_Benign_Neoplasm_Brain_Plan_R2                                                  
',v_CaseId,'MP') ||
  '</managementPlan>' || LF;
  v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
  v_Str := v_Str || '        <title>Bone Marrow Transplant Status</title>' || LF;
  v_Str := v_Str || '        <value>' || Matrix_Utils.Get_InfoPathData(' PA_Hematology_Bone_Marrow ',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '        <managementPlan>' || Matrix_Utils.Get_InfoPathData('PA_Hematology_Bone_Marrow_Plan_E1                                                  
+ PA_Hematology_Bone_Marrow_Plan_E2                                                  
+ PA_Hematology_Bone_Marrow_Plan_E3                                                  
+ PA_Hematology_Bone_Marrow_Plan_E4                                                  
+ PA_Hematology_Bone_Marrow_Plan_E5                                                  
+ PA_Hematology_Bone_Marrow_Plan_M1                                                  
+ PA_Hematology_Bone_Marrow_Plan_M2                                                  
+ PA_Hematology_Bone_Marrow_Plan_M3                                                  
+ PA_Hematology_Bone_Marrow_Plan_R1                                                  
+ PA_Hematology_Bone_Marrow_Plan_R2                                                  
',v_CaseId,'MP') || '</managementPlan>' || LF;
  v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
  v_Str := v_Str || '        <title>Long Term (Current) Use of Anticoagulants (excluding Aspirin)</title>' || LF;
  v_Str := v_Str || '        <value>' || Matrix_Utils.Get_InfoPathData(' PA_Hematology_Long_Anticoagulants ',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '        <managementPlan>' || Matrix_Utils.Get_InfoPathData(
  'PA_Hematology_Long_Anticoagulants_Plan_E1                                                  
+ PA_Hematology_Long_Anticoagulants_Plan_E2                                                  
+ PA_Hematology_Long_Anticoagulants_Plan_E3                                                  
+ PA_Hematology_Long_Anticoagulants_Plan_E4                                                  
+ PA_Hematology_Long_Anticoagulants_Plan_E5                                                  
+ PA_Hematology_Long_Anticoagulants_Plan_M1                                                  
+ PA_Hematology_Long_Anticoagulants_Plan_M2                                                  
+ PA_Hematology_Long_Anticoagulants_Plan_M3                                                  
+ PA_Hematology_Long_Anticoagulants_Plan_R1                                                  
+ PA_Hematology_Long_Anticoagulants_Plan_R2                                                  
',v_CaseId,'MP') || '</managementPlan>' || LF ;
  v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
  v_Str := v_Str || '        <title>Long Term (Current) Use of Aspirin</title>' || LF;
  v_Str := v_Str || '        <value>' || Matrix_Utils.Get_InfoPathData(' PA_Hematology_Long_Aspirin ',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '        <managementPlan>' || Matrix_Utils.Get_InfoPathData('PA_Hematology_Long_Aspirin_Plan_E1                                                  
+ PA_Hematology_Long_Aspirin_Plan_E2                                                  
+ PA_Hematology_Long_Aspirin_Plan_E3                                                  
+ PA_Hematology_Long_Aspirin_Plan_E4                                                  
+ PA_Hematology_Long_Aspirin_Plan_E5                                                  
+ PA_Hematology_Long_Aspirin_Plan_M1                                                  
+ PA_Hematology_Long_Aspirin_Plan_M2                                                  
+ PA_Hematology_Long_Aspirin_Plan_M3                                                  
+ PA_Hematology_Long_Aspirin_Plan_R1                                                  
+ PA_Hematology_Long_Aspirin_Plan_R2                                                  
',v_CaseId,'MP') || '</managementPlan>' || LF;
  v_Str := v_Str || '   </diagnosis>'|| LF;
  
  v_Str := v_Str || '   <diagnosis>' || LF;
  v_Str := v_Str || '        <title>Long Term (Current) Use of Antiplatelet/Antithrombotic</title>' || LF;
  v_Str := v_Str || '        <value>' || Matrix_Utils.Get_InfoPathData(' PA_Hematology_Long_Antiplatelet ',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '        <managementPlan>' || Matrix_Utils.Get_InfoPathData( 'PA_Hematology_Long_Antiplatelet_Plan_E1                                                  
+ PA_Hematology_Long_Antiplatelet_Plan_E2                                                  
+ PA_Hematology_Long_Antiplatelet_Plan_E3                                                  
+ PA_Hematology_Long_Antiplatelet_Plan_E4                                                  
+ PA_Hematology_Long_Antiplatelet_Plan_E5                                                  
+ PA_Hematology_Long_Antiplatelet_Plan_M1                                                  
+ PA_Hematology_Long_Antiplatelet_Plan_M2                                                  
+ PA_Hematology_Long_Antiplatelet_Plan_M3                                                  
+ PA_Hematology_Long_Antiplatelet_Plan_R1                                                  
+ PA_Hematology_Long_Antiplatelet_Plan_R2                                                  
'
  ,v_CaseId,'MP') || '</managementPlan>' || LF;
  v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
  v_Str := v_Str || '        <title>Long Term (Current) Steroid Use</title>' || LF;
  v_Str := v_Str || '        <value>' || Matrix_Utils.Get_InfoPathData(' PA_Hematology_Long_Steriod ',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '        <managementPlan>' || Matrix_Utils.Get_InfoPathData('PA_Hematology_Long_Steriod_Plan_E1                                                  
+ PA_Hematology_Long_Steriod_Plan_E2                                                  
+ PA_Hematology_Long_Steriod_Plan_E3                                                  
+ PA_Hematology_Long_Steriod_Plan_E4                                                  
+ PA_Hematology_Long_Steriod_Plan_E5                                                  
+ PA_Hematology_Long_Steriod_Plan_M1                                                  
+ PA_Hematology_Long_Steriod_Plan_M2                                                  
+ PA_Hematology_Long_Steriod_Plan_M3                                                  
+ PA_Hematology_Long_Steriod_Plan_R1                                                  
+ PA_Hematology_Long_Steriod_Plan_R2                                                  
',v_CaseId,'MP') || '</managementPlan>' || LF;
  v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
  v_Str := v_Str || '        <title>Other Significant Diagnoses:</title>' || LF;
  v_Str := v_Str || '        <value>' || Matrix_Utils.Get_InfoPathData(' PA_Hematology_Other ',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '        <followupQuestions>' || LF;
  v_Str := v_Str || '            <title>Other</title>' || LF;
  v_Str := v_Str || '            <answer>' || Matrix_Utils.Get_InfoPathData(' PA_Hematology_Other_Box',v_CaseId,'ST') || '</answer>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </followupQuestions>'|| LF;
  v_Str := v_Str || '        <managementPlan>' || Matrix_Utils.Get_InfoPathData('PA_Hematology_Other_Plan_E1                                                  
+ PA_Hematology_Other_Plan_E2                                                  
+ PA_Hematology_Other_Plan_E3                                                  
+ PA_Hematology_Other_Plan_E4                                                  
+ PA_Hematology_Other_Plan_E5                                                  
+ PA_Hematology_Other_Plan_M1                                                  
+ PA_Hematology_Other_Plan_M2                                                  
+ PA_Hematology_Other_Plan_M3                                                  
+ PA_Hematology_Other_Plan_R1                                                  
+ PA_Hematology_Other_Plan_R2                                                  
',v_CaseId,'MP') || '</managementPlan>' || LF;
  v_Str := v_Str || '   </diagnosis>'|| LF;
  v_Str := v_Str || ' </sections>'|| LF;

  v_Str := v_Str || ' <sections>'|| LF;
  v_Str := v_Str || '  <title>Endocrine</title>' || LF;

 v_Str := v_Str || '   <diagnosis>' || LF;
  v_Str := v_Str || '        <title>Hyperlipidemia</title>' || LF;
  v_Str := v_Str || '        <value>' || Matrix_Utils.Get_InfoPathData(' PA_Endoctrine_Hyperlipidemia ',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '        <managementPlan>' || Matrix_Utils.Get_InfoPathData('PA_Endoctrine_Hyperlipidemia_Plan_E1                                                  
+ PA_Endoctrine_Hyperlipidemia_Plan_E2                                                  
+ PA_Endoctrine_Hyperlipidemia_Plan_E3                                                  
+ PA_Endoctrine_Hyperlipidemia_Plan_E4                                                  
+ PA_Endoctrine_Hyperlipidemia_Plan_E5                                                  
+ PA_Endoctrine_Hyperlipidemia_Plan_M1                                                  
+ PA_Endoctrine_Hyperlipidemia_Plan_M2                                                  
+ PA_Endoctrine_Hyperlipidemia_Plan_M3                                                  
+ PA_Endoctrine_Hyperlipidemia_Plan_R1                                                  
+ PA_Endoctrine_Hyperlipidemia_Plan_R2                                                  
',v_CaseId,'MP') ||
  '</managementPlan>' || LF;
  v_Str := v_Str || '   </diagnosis>'|| LF;



  v_Str := v_Str || '   <diagnosis>' || LF;
  v_Str := v_Str || '        <title>Hypothyroidism</title>' || LF;
  v_Str := v_Str || '        <value>' || Matrix_Utils.Get_InfoPathData(' PA_Endoctrine__Hypothyroidism',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '         <managementPlan>' || Matrix_Utils.Get_InfoPathData('PA_Endoctrine_Hypothyroidism_Plan_E1                                                  
+ PA_Endoctrine_Hypothyroidism_Plan_E2                                                  
+ PA_Endoctrine_Hypothyroidism_Plan_E3                                                  
+ PA_Endoctrine_Hypothyroidism_Plan_E4                                                  
+ PA_Endoctrine_Hypothyroidism_Plan_E5                                                  
+ PA_Endoctrine_Hypothyroidism_Plan_M1                                                  
+ PA_Endoctrine_Hypothyroidism_Plan_M2                                                  
+ PA_Endoctrine_Hypothyroidism_Plan_M3                                                  
+ PA_Endoctrine_Hypothyroidism_Plan_R1                                                  
+ PA_Endoctrine_Hypothyroidism_Plan_R2                                                  
',v_CaseId,'MP') ||
  '</managementPlan>' || LF;
  v_Str := v_Str || '   </diagnosis>' || LF;
  
  
  v_Str := v_Str || '   <diagnosis>' || LF;
  v_Str := v_Str || '        <title>Cachexia</title>' || LF;
  v_Str := v_Str || '        <value>' || Matrix_Utils.Get_InfoPathData(' PA_Endoctrine_Cachexia ',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '        <managementPlan>' || Matrix_Utils.Get_InfoPathData('PA_Endoctrine_Cachexia_Plan_E1                                                  
+ PA_Endoctrine_Cachexia_Plan_E2                                                  
+ PA_Endoctrine_Cachexia_Plan_E3                                                  
+ PA_Endoctrine_Cachexia_Plan_E4                                                  
+ PA_Endoctrine_Cachexia_Plan_E5                                                  
+ PA_Endoctrine_Cachexia_Plan_M1                                                  
+ PA_Endoctrine_Cachexia_Plan_M2                                                  
+ PA_Endoctrine_Cachexia_Plan_M3                                                  
+ PA_Endoctrine_Cachexia_Plan_R1                                                  
+ PA_Endoctrine_Cachexia_Plan_R2                                                  
',v_CaseId,'MP') || '</managementPlan>' || LF;
  v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
  v_Str := v_Str || '        <title>Hypoalbuminemia</title>' || LF;
  v_Str := v_Str || '        <value>' || Matrix_Utils.Get_InfoPathData(' PA_Endoctrine_Hypoalbuminemia ',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '        <managementPlan>' || Matrix_Utils.Get_InfoPathData('PA_Endoctrine_Hypoalbuminemia_Plan_E1                                                  
+ PA_Endoctrine_Hypoalbuminemia_Plan_E2                                                  
+ PA_Endoctrine_Hypoalbuminemia_Plan_E3                                                  
+ PA_Endoctrine_Hypoalbuminemia_Plan_E4                                                  
+ PA_Endoctrine_Hypoalbuminemia_Plan_E5                                                  
+ PA_Endoctrine_Hypoalbuminemia_Plan_M1                                                  
+ PA_Endoctrine_Hypoalbuminemia_Plan_M2                                                  
+ PA_Endoctrine_Hypoalbuminemia_Plan_M3                                                  
+ PA_Endoctrine_Hypoalbuminemia_Plan_R1                                                  
+ PA_Endoctrine_Hypoalbuminemia_Plan_R2                                                  
',v_CaseId,'MP') ||
  '</managementPlan>' || LF;
  v_Str := v_Str || '   </diagnosis>'|| LF;
  
  v_Str := v_Str || '   <diagnosis>' || LF;
  v_Str := v_Str || '        <title>Other Significant Diagnoses:</title>' || LF;
  v_Str := v_Str || '        <value>' || Matrix_Utils.Get_InfoPathData(' PA_Endoctrine_Other ',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '        <followupQuestions>' || LF;
  v_Str := v_Str || '        <title>Other:</title>' || LF;
  v_Str := v_Str || '        <answer>' || Matrix_Utils.Get_InfoPathData(' PA_Endoctrine_Other_Box',v_CaseId,'ST') || '</answer>' || LF;
  v_Str := v_Str || '        <value>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </followupQuestions>'|| LF;
  v_Str := v_Str || '        <managementPlan>' || Matrix_Utils.Get_InfoPathData('PA_Endoctrine_Other_Plan_E1                                                  
+ PA_Endoctrine_Other_Plan_E2                                                  
+ PA_Endoctrine_Other_Plan_E3                                                  
+ PA_Endoctrine_Other_Plan_E4                                                  
+ PA_Endoctrine_Other_Plan_E5                                                  
+ PA_Endoctrine_Other_Plan_M1                                                  
+ PA_Endoctrine_Other_Plan_M2                                                  
+ PA_Endoctrine_Other_Plan_M3                                                  
+ PA_Endoctrine_Other_Plan_R1                                                  
+ PA_Endoctrine_Other_Plan_R2                                                  
',v_CaseId,'MP') || '</managementPlan>' || LF;
 --v_Str := v_Str || '   </diagnosis>'|| LF;
 v_Str := v_Str || '  </diagnosis>'|| LF;
 v_Str := v_Str || ' </sections>'|| LF;

  v_Str := v_Str || ' <sections>'|| LF;
  v_Str := v_Str || '  <title>Gastrointestinal</title>' || LF;
  v_Str := v_Str || '   <diagnosis>' || LF;
  v_Str := v_Str || '        <title>Esophageal Retlux (GERD)</title>' || LF;
  v_Str := v_Str || '        <value>' || Matrix_Utils.Get_InfoPathData(' PA_Gastrointestinal_Gerd ',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '        <managementPlan>' || Matrix_Utils.Get_InfoPathData('PA_Gastrointestinal_Gerd_Plan_E1                                                  
+ PA_Gastrointestinal_Gerd_Plan_E2                                                  
+ PA_Gastrointestinal_Gerd_Plan_E3                                                  
+ PA_Gastrointestinal_Gerd_Plan_E4                                                  
+ PA_Gastrointestinal_Gerd_Plan_E5                                                  
+ PA_Gastrointestinal_Gerd_Plan_M1                                                  
+ PA_Gastrointestinal_Gerd_Plan_M2                                                  
+ PA_Gastrointestinal_Gerd_Plan_M3                                                  
+ PA_Gastrointestinal_Gerd_Plan_R1                                                  
+ PA_Gastrointestinal_Gerd_Plan_R2                                                  
',v_CaseId,'MP') || '</managementPlan>' || LF;
   v_Str := v_Str || '   </diagnosis>'|| LF;
  
  v_Str := v_Str || '   <diagnosis>' || LF;
  v_Str := v_Str || '        <title>Peptic Ulcer Disease (PUD)</title>' || LF;
  v_Str := v_Str || '        <value>' || Matrix_Utils.Get_InfoPathData(' PA_Gastrointestinal_PUD ',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '        <managementPlan>' || Matrix_Utils.Get_InfoPathData('PA_Gastrointestinal_PUD_Plan_E1                                                  
+ PA_Gastrointestinal_PUD_Plan_E2                                                  
+ PA_Gastrointestinal_PUD_Plan_E3                                                  
+ PA_Gastrointestinal_PUD_Plan_E4                                                  
+ PA_Gastrointestinal_PUD_Plan_E5                                                  
+ PA_Gastrointestinal_PUD_Plan_M1                                                  
+ PA_Gastrointestinal_PUD_Plan_M2                                                  
+ PA_Gastrointestinal_PUD_Plan_M3                                                  
+ PA_Gastrointestinal_PUD_Plan_R1                                                  
+ PA_Gastrointestinal_PUD_Plan_R2                                                  
',v_CaseId,'MP') || '</managementPlan>' || LF;
  v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
  v_Str := v_Str || '        <title>Gastritis</title>' || LF;
  v_Str := v_Str || '        <value>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '        <followupQuestions>' || LF;
  v_Str := v_Str || '            <title>Type:</title>' || LF;
  v_Str := v_Str || '            <answer>' || Matrix_Utils.Get_InfoPathData(' PA_Gastrointestinal_Gastritis_Active ',v_CaseId,'TF') || '</answer>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </followupQuestions>'|| LF;
  v_Str := v_Str || '        <followupQuestions>' || LF;
  v_Str := v_Str || '            <title>Type:</title>' || LF;
  v_Str := v_Str || '            <answer>' || Matrix_Utils.Get_InfoPathData(' PA_Gastrointestinal_Gastritis_Chronic ',v_CaseId,'TF') || '</answer>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </followupQuestions>'|| LF;
  v_Str := v_Str || '        <managementPlan>' || Matrix_Utils.Get_InfoPathData('PA_Gastrointestinal_Gastritis_Plan_E1                                                  
+ PA_Gastrointestinal_Gastritis_Plan_E2                                                  
+ PA_Gastrointestinal_Gastritis_Plan_E3                                                  
+ PA_Gastrointestinal_Gastritis_Plan_E4                                                  
+ PA_Gastrointestinal_Gastritis_Plan_E5                                                  
+ PA_Gastrointestinal_Gastritis_Plan_M1                                                  
+ PA_Gastrointestinal_Gastritis_Plan_M2                                                  
+ PA_Gastrointestinal_Gastritis_Plan_M3                                                  
+ PA_Gastrointestinal_Gastritis_Plan_R1                                                  
+ PA_Gastrointestinal_Gastritis_Plan_R2                                                  
',v_CaseId,'MP') ||
  '</managementPlan>' || LF;
  v_Str := v_Str || '   </diagnosis>'|| LF;
  
  v_Str := v_Str || '   <diagnosis>' || LF;
  v_Str := v_Str || '        <title>Croh''s disease</title>' || LF;
  v_Str := v_Str || '        <value>' || Matrix_Utils.Get_InfoPathData(' PA_Gastrointestinal_Crohns ',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '        <managementPlan>' || Matrix_Utils.Get_InfoPathData('PA_Gastrointestinal_Crohns_Plan_E1                                                  
+ PA_Gastrointestinal_Crohns_Plan_E2                                                  
+ PA_Gastrointestinal_Crohns_Plan_E3                                                  
+ PA_Gastrointestinal_Crohns_Plan_E4                                                  
+ PA_Gastrointestinal_Crohns_Plan_E5                                                  
+ PA_Gastrointestinal_Crohns_Plan_M1                                                  
+ PA_Gastrointestinal_Crohns_Plan_M2                                                  
+ PA_Gastrointestinal_Crohns_Plan_M3                                                  
+ PA_Gastrointestinal_Crohns_Plan_R1                                                  
+ PA_Gastrointestinal_Crohns_Plan_R2                                                  
',v_CaseId,'MP') || '</managementPlan>' || LF;
  v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
  v_Str := v_Str || '        <title>Ulcerative Colitis</title>' || LF;
  v_Str := v_Str || '        <value>' || Matrix_Utils.Get_InfoPathData(' PA_Gastrointestinal_Ulcerative_Colitis ',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '        <managementPlan></managementPlan>' || LF;
  v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
  v_Str := v_Str || '        <title>Diarrhea</title>' || LF;
  v_Str := v_Str || '        <value>' || Matrix_Utils.Get_InfoPathData(' PA_Gastrointestinal_Diarrhea ',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '        <managementPlan>' || Matrix_Utils.Get_InfoPathData('PA_Gastrointestinal_Diarrhea_Plan_E1                                                  
+ PA_Gastrointestinal_Diarrhea_Plan_E2                                                  
+ PA_Gastrointestinal_Diarrhea_Plan_E3                                                  
+ PA_Gastrointestinal_Diarrhea_Plan_E4                                                  
+ PA_Gastrointestinal_Diarrhea_Plan_E5                                                  
+ PA_Gastrointestinal_Diarrhea_Plan_M1                                                  
+ PA_Gastrointestinal_Diarrhea_Plan_M2                                                  
+ PA_Gastrointestinal_Diarrhea_Plan_M3                                                  
+ PA_Gastrointestinal_Diarrhea_Plan_R1                                                  
+ PA_Gastrointestinal_Diarrhea_Plan_R2                                                  
',v_CaseId,'MP') ||
  '</managementPlan>' || LF;
  v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
  v_Str := v_Str || '        <title>C. Dif. Colitis</title>' || LF;
  v_Str := v_Str || '        <value>' || Matrix_Utils.Get_InfoPathData(' PA_Gastrointestinal_cdifcolitis ',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '        <managementPlan></managementPlan>' || LF;
  v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
  v_Str := v_Str || '        <title>Chronic Hepatitis</title>' || LF;
  v_Str := v_Str || '        <value>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '        <followupQuestions>' || LF;
  v_Str := v_Str || '            <title>Type:</title>' || LF;
  v_Str := v_Str || '            <answer>' || Matrix_Utils.Get_InfoPathData(' PA_Gastrointestinal_Hepatitis_B ',v_CaseId,'ST') || '</answer>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </followupQuestions>'|| LF;
  v_Str := v_Str || '        <followupQuestions>' || LF;
  v_Str := v_Str || '            <title>Type:</title>' || LF;
  v_Str := v_Str || '            <answer>' || Matrix_Utils.Get_InfoPathData(' PA_Gastrointestinal_Hepatitis_C ',v_CaseId,'ST') || '</answer>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </followupQuestions>'|| LF;
  v_Str := v_Str || '        <managementPlan>' || Matrix_Utils.Get_InfoPathData('PA_Gastrointestinal_Hepatitis_Plan_E1                                                  
+ PA_Gastrointestinal_Hepatitis_Plan_E2                                                  
+ PA_Gastrointestinal_Hepatitis_Plan_E3                                                  
+ PA_Gastrointestinal_Hepatitis_Plan_E4                                                  
+ PA_Gastrointestinal_Hepatitis_Plan_E5                                                  
+ PA_Gastrointestinal_Hepatitis_Plan_M1                                                  
+ PA_Gastrointestinal_Hepatitis_Plan_M2                                                  
+ PA_Gastrointestinal_Hepatitis_Plan_M3                                                  
+ PA_Gastrointestinal_Hepatitis_Plan_R1                                                  
+ PA_Gastrointestinal_Hepatitis_Plan_R2                                                  
',v_CaseId,'MP') ||
  '</managementPlan>' || LF;
  v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
  v_Str := v_Str || '        <title>Constipation</title>' || LF;
  v_Str := v_Str || '        <value>' || Matrix_Utils.Get_InfoPathData(' PA_Gastrointestinal_Constipation ',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '        <managementPlan>' || Matrix_Utils.Get_InfoPathData(
  'PA_Gastrointestinal_Constipation_Plan_E1                                                  
+ PA_Gastrointestinal_Constipation_Plan_E2                                                  
+ PA_Gastrointestinal_Constipation_Plan_E3                                                  
+ PA_Gastrointestinal_Constipation_Plan_E4                                                  
+ PA_Gastrointestinal_Constipation_Plan_E5                                                  
+ PA_Gastrointestinal_Constipation_Plan_M1                                                  
+ PA_Gastrointestinal_Constipation_Plan_M2                                                  
+ PA_Gastrointestinal_Constipation_Plan_M3                                                  
+ PA_Gastrointestinal_Constipation_Plan_R1                                                  
+ PA_Gastrointestinal_Constipation_Plan_R2                                                  
',v_CaseId,'MP') || '</managementPlan>' || LF;
  v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
  v_Str := v_Str || '        <title>Diverticulosis without Hemorrhage</title>' || LF;
  v_Str := v_Str || '        <value>' || Matrix_Utils.Get_InfoPathData(' PA_Gastrointestinal_Diverticulosis_Without ',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '        <followupQuestions>' || LF;
  v_Str := v_Str || '            <title>Type:</title>' || LF;
  v_Str := v_Str || '            <answer>' || Matrix_Utils.Get_InfoPathData(' PA_Gastrointestinal_Alcoholic_Cirrhosis ',v_CaseId,'ST') || '</answer>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '            <managementPlan>' || Matrix_Utils.Get_InfoPathData('PA_Gastrointestinal_Cirrhosis_Plan_E1                                                  
+ PA_Gastrointestinal_Cirrhosis_Plan_E2                                                  
+ PA_Gastrointestinal_Cirrhosis_Plan_E3                                                  
+ PA_Gastrointestinal_Cirrhosis_Plan_E4                                                  
+ PA_Gastrointestinal_Cirrhosis_Plan_E5                                                  
+ PA_Gastrointestinal_Cirrhosis_Plan_M1                                                  
+ PA_Gastrointestinal_Cirrhosis_Plan_M2                                                  
+ PA_Gastrointestinal_Cirrhosis_Plan_M3                                                  
+ PA_Gastrointestinal_Cirrhosis_Plan_R1                                                  
+ PA_Gastrointestinal_Cirrhosis_Plan_R2                                                  
',v_CaseId,'MP')
  || '</managementPlan>' || LF;
  v_Str := v_Str || '        </followupQuestions>'|| LF;
  v_Str := v_Str || '        <followupQuestions>' || LF;
  v_Str := v_Str || '            <title>Type:</title>' || LF;
  v_Str := v_Str || '            <answer>' || Matrix_Utils.Get_InfoPathData(' PA_Gastrointestinal_Cirrhosis_No_Alcohol ',v_CaseId,'ST') || '</answer>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '            <managementPlan>' || Matrix_Utils.Get_InfoPathData('PA_Gastrointestinal_Cirrhosis_Plan_E1                                                  
+ PA_Gastrointestinal_Cirrhosis_Plan_E2                                                  
+ PA_Gastrointestinal_Cirrhosis_Plan_E3                                                  
+ PA_Gastrointestinal_Cirrhosis_Plan_E4                                                  
+ PA_Gastrointestinal_Cirrhosis_Plan_E5                                                  
+ PA_Gastrointestinal_Cirrhosis_Plan_M1                                                  
+ PA_Gastrointestinal_Cirrhosis_Plan_M2                                                  
+ PA_Gastrointestinal_Cirrhosis_Plan_M3                                                  
+ PA_Gastrointestinal_Cirrhosis_Plan_R1                                                  
+ PA_Gastrointestinal_Cirrhosis_Plan_R2                                                  
',v_CaseId,'MP')
  || '</managementPlan>' || LF;
  v_Str := v_Str || '        </followupQuestions>'|| LF;
  v_Str := v_Str || '        <managementPlan>' || Matrix_Utils.Get_InfoPathData(
  'PA_Gastrointestinal_Diverticulosis_Plan_E1                                                  
+ PA_Gastrointestinal_Diverticulosis_Plan_E2                                                  
+ PA_Gastrointestinal_Diverticulosis_Plan_E3                                                  
+ PA_Gastrointestinal_Diverticulosis_Plan_E4                                                  
+ PA_Gastrointestinal_Diverticulosis_Plan_E5                                                  
+ PA_Gastrointestinal_Diverticulosis_Plan_M1                                                  
+ PA_Gastrointestinal_Diverticulosis_Plan_M2                                                  
+ PA_Gastrointestinal_Diverticulosis_Plan_M3                                                  
+ PA_Gastrointestinal_Diverticulosis_Plan_R1                                                  
+ PA_Gastrointestinal_Diverticulosis_Plan_R2                                                  
',v_CaseId,'MP') ||
  '</managementPlan>' || LF;
  v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
  v_Str := v_Str || '        <title>End Stage Liver Disease</title>' || LF;
  v_Str := v_Str || '        <value>' || Matrix_Utils.Get_InfoPathData(' PA_Gastrointestinal_End_Liver_Disease ',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '        <managementPlan>' || Matrix_Utils.Get_InfoPathData(
  'PA_Gastrointestinal_End_Liver_Disease_Plan_E1                                                  
+ PA_Gastrointestinal_End_Liver_Disease_Plan_E2                                                  
+ PA_Gastrointestinal_End_Liver_Disease_Plan_E3                                                  
+ PA_Gastrointestinal_End_Liver_Disease_Plan_E4                                                  
+ PA_Gastrointestinal_End_Liver_Disease_Plan_E5                                                  
+ PA_Gastrointestinal_End_Liver_Disease_Plan_M1                                                  
+ PA_Gastrointestinal_End_Liver_Disease_Plan_M2                                                  
+ PA_Gastrointestinal_End_Liver_Disease_Plan_M3                                                  
+ PA_Gastrointestinal_End_Liver_Disease_Plan_R1                                                  
+ PA_Gastrointestinal_End_Liver_Disease_Plan_R2                                                  
',
  v_CaseId,'MP') || '</managementPlan>' || LF;
  v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
  v_Str := v_Str || '        <title>Pancreatitis - Chronic</title>' || LF;
  v_Str := v_Str || '        <value>' || Matrix_Utils.Get_InfoPathData(' PA_Gastrointestinal_Pancreatitis_Chronic ',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '        <managementPlan>' || Matrix_Utils.Get_InfoPathData(
  'PA_Gastrointestinal_Pancreatitis_Plan_E1                                                  
+ PA_Gastrointestinal_Pancreatitis_Plan_E2                                                  
+ PA_Gastrointestinal_Pancreatitis_Plan_E3                                                  
+ PA_Gastrointestinal_Pancreatitis_Plan_E4                                                  
+ PA_Gastrointestinal_Pancreatitis_Plan_E5                                                  
+ PA_Gastrointestinal_Pancreatitis_Plan_M1                                                  
+ PA_Gastrointestinal_Pancreatitis_Plan_M2                                                  
+ PA_Gastrointestinal_Pancreatitis_Plan_M3                                                  
+ PA_Gastrointestinal_Pancreatitis_Plan_R1                                                  
+ PA_Gastrointestinal_Pancreatitis_Plan_R2                                                  
',v_CaseId,'MP') || '</managementPlan>' || LF;
  v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
  v_Str := v_Str || '        <title>Other Significant Diagnoses:</title>' || LF;
  v_Str := v_Str || '        <value>' || Matrix_Utils.Get_InfoPathData(' PA_Gastrointestinal_Other ',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '        <followupQuestions>' || LF;
  v_Str := v_Str || '            <title>Other:</title>' || LF;
  v_Str := v_Str || '            <answer>' || Matrix_Utils.Get_InfoPathData(' PA_Gastrointestinal_Other_Box',v_CaseId,'ST') || '</answer>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </followupQuestions>'|| LF;
  v_Str := v_Str || '        <managementPlan>' || Matrix_Utils.Get_InfoPathData('PA_Gastrointestinal_Other_Plan_E1                                                  
+ PA_Gastrointestinal_Other_Plan_E2                                                  
+ PA_Gastrointestinal_Other_Plan_E3                                                  
+ PA_Gastrointestinal_Other_Plan_E4                                                  
+ PA_Gastrointestinal_Other_Plan_E5                                                  
+ PA_Gastrointestinal_Other_Plan_M1                                                  
+ PA_Gastrointestinal_Other_Plan_M2                                                  
+ PA_Gastrointestinal_Other_Plan_M3                                                  
+ PA_Gastrointestinal_Other_Plan_R1                                                  
+ PA_Gastrointestinal_Other_Plan_R2                                                  
',v_CaseId,'MP') || '</managementPlan>' || LF;
  v_Str := v_Str || '   </diagnosis>'|| LF;
  v_Str := v_Str || ' </sections>'|| LF;

  v_Str := v_Str || ' <sections>'|| LF;
  v_Str := v_Str || '  <title>Skin</title>' || LF;
  v_Str := v_Str || '   <diagnosis>' || LF;
  v_Str := v_Str || '        <title>Pressure Ulcer (Decubitus)</title>' || LF;
  v_Str := v_Str || '        <value>' || Matrix_Utils.Get_InfoPathData(' PA_Skin_Pressure_Ulcer ',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '        <followupQuestions>' || LF;
  v_Str := v_Str || '            <title>Location</title>' || LF;
  v_Str := v_Str || '            <answer>' || Matrix_Utils.Get_InfoPathData(' PA_Skin_Pressure_Ulcer_Site_1 ',v_CaseId,'ST') || '</answer>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '            <secondaryQuestions>' || LF;
  v_Str := v_Str || '               <title>Stage:</title>' || LF;
  v_Str := v_Str || '               <answer>' || Matrix_Utils.Get_InfoPathData('PA_Skin_Pressure_Ulcer_Stage_1 ',v_CaseId,'ST') || '</answer>' || LF;
  v_Str := v_Str || '               <value>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '            </secondaryQuestions>' || LF;
  v_Str := v_Str || '        </followupQuestions>'|| LF;
  v_Str := v_Str || '        <followupQuestions>' || LF;
  v_Str := v_Str || '            <title>Location</title>' || LF;
  v_Str := v_Str || '            <answer>' || Matrix_Utils.Get_InfoPathData(' PA_Skin_Pressure_Ulcer_Site_2 ',v_CaseId,'ST') || '</answer>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '            <secondaryQuestions>' || LF;
  v_Str := v_Str || '               <title>Stage:</title>' || LF;
  v_Str := v_Str || '               <answer>' || Matrix_Utils.Get_InfoPathData('PA_Skin_Pressure_Ulcer_Stage_2 ',v_CaseId,'ST') || '</answer>' || LF;
  v_Str := v_Str || '               <value>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '            </secondaryQuestions>' || LF;
  v_Str := v_Str || '        </followupQuestions>'|| LF;
  v_Str := v_Str || '        <managementPlan>' || Matrix_Utils.Get_InfoPathData('PA_Skin_Pressure_Ulcer_Plan_E1                                                  
+ PA_Skin_Pressure_Ulcer_Plan_E2                                                  
+ PA_Skin_Pressure_Ulcer_Plan_E3                                                  
+ PA_Skin_Pressure_Ulcer_Plan_E4                                                  
+ PA_Skin_Pressure_Ulcer_Plan_E5                                                  
+ PA_Skin_Pressure_Ulcer_Plan_M1                                                  
+ PA_Skin_Pressure_Ulcer_Plan_M2                                                  
+ PA_Skin_Pressure_Ulcer_Plan_M3                                                  
+ PA_Skin_Pressure_Ulcer_Plan_R1                                                  
+ PA_Skin_Pressure_Ulcer_Plan_R2                                                  
',v_CaseId,'MP') || '</managementPlan>' || LF;
  v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
  v_Str := v_Str || '        <title>Arterial Ulcer</title>' || LF;
  v_Str := v_Str || '        <value>' || Matrix_Utils.Get_InfoPathData(' PA_Skin_Ulcer_Not_Pressure_Arterial ',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '        <followupQuestions>' || LF;
  v_Str := v_Str || '            <title>Site:</title>' || LF;
  v_Str := v_Str || '            <answer>' || Matrix_Utils.Get_InfoPathData(' PA_Skin_Ulcer_Not_Pressure_Box ',v_CaseId,'ST') || '</answer>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </followupQuestions>'|| LF;
  v_Str := v_Str || '        <managementPlan>' || Matrix_Utils.Get_InfoPathData('PA_Skin_Ulcer_Not_Pressure_Plan_E1                                                  
+ PA_Skin_Ulcer_Not_Pressure_Plan_E2                                                  
+ PA_Skin_Ulcer_Not_Pressure_Plan_E3                                                  
+ PA_Skin_Ulcer_Not_Pressure_Plan_E4                                                  
+ PA_Skin_Ulcer_Not_Pressure_Plan_E5                                                  
+ PA_Skin_Ulcer_Not_Pressure_Plan_M1                                                  
+ PA_Skin_Ulcer_Not_Pressure_Plan_M2                                                  
+ PA_Skin_Ulcer_Not_Pressure_Plan_M3                                                  
+ PA_Skin_Ulcer_Not_Pressure_Plan_R1                                                  
+ PA_Skin_Ulcer_Not_Pressure_Plan_R2                                                  
',v_CaseId,'MP') || '</managementPlan>' || LF;
  v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
  v_Str := v_Str || '        <title>Venous Ulcer</title>' || LF;
  v_Str := v_Str || '        <value>' || Matrix_Utils.Get_InfoPathData(' PA_Skin_Ulcer_Not_Pressure_Venous ',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '        <followupQuestions>' || LF;
  v_Str := v_Str || '            <title>Site:</title>' || LF;
  v_Str := v_Str || '            <answer>' || Matrix_Utils.Get_InfoPathData(' PA_Skin_Ulcer_Not_Pressure_Box_2 ',v_CaseId,'ST') || '</answer>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </followupQuestions>'|| LF;
  v_Str := v_Str || '        <managementPlan>' || Matrix_Utils.Get_InfoPathData('PA_Skin_Ulcer_Not_Pressure_Plan_E1                                                  
+ PA_Skin_Ulcer_Not_Pressure_Plan_E2                                                  
+ PA_Skin_Ulcer_Not_Pressure_Plan_E3                                                  
+ PA_Skin_Ulcer_Not_Pressure_Plan_E4                                                  
+ PA_Skin_Ulcer_Not_Pressure_Plan_E5                                                  
+ PA_Skin_Ulcer_Not_Pressure_Plan_M1                                                  
+ PA_Skin_Ulcer_Not_Pressure_Plan_M2                                                  
+ PA_Skin_Ulcer_Not_Pressure_Plan_M3                                                  
+ PA_Skin_Ulcer_Not_Pressure_Plan_R1                                                  
+ PA_Skin_Ulcer_Not_Pressure_Plan_R2                                                  
',v_CaseId,'MP') || '</managementPlan>' || LF;
  v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
  v_Str := v_Str || '        <title>Diabetic Ulcer</title>' || LF;
  v_Str := v_Str || '        <value>' || Matrix_Utils.Get_InfoPathData(' PA_Skin_Ulcer_Not_Pressure_Diabetic ',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '        <followupQuestions>' || LF;
  v_Str := v_Str || '            <title>Site:</title>' || LF;
  v_Str := v_Str || '            <answer>' || Matrix_Utils.Get_InfoPathData(' PA_Skin_Ulcer_Not_Pressure_Box_3 ',v_CaseId,'ST') || '</answer>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </followupQuestions>'|| LF;
  v_Str := v_Str || '        <managementPlan>' || Matrix_Utils.Get_InfoPathData('PA_Skin_Ulcer_Not_Pressure_Plan_E1                                                  
+ PA_Skin_Ulcer_Not_Pressure_Plan_E2                                                  
+ PA_Skin_Ulcer_Not_Pressure_Plan_E3                                                  
+ PA_Skin_Ulcer_Not_Pressure_Plan_E4                                                  
+ PA_Skin_Ulcer_Not_Pressure_Plan_E5                                                  
+ PA_Skin_Ulcer_Not_Pressure_Plan_M1                                                  
+ PA_Skin_Ulcer_Not_Pressure_Plan_M2                                                  
+ PA_Skin_Ulcer_Not_Pressure_Plan_M3                                                  
+ PA_Skin_Ulcer_Not_Pressure_Plan_R1                                                  
+ PA_Skin_Ulcer_Not_Pressure_Plan_R2                                                  
',v_CaseId,'MP') || '</managementPlan>' || LF;
  v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
  v_Str := v_Str || '        <title>Ulcer (not Pressure):</title>' || LF;
  v_Str := v_Str || '        <value>' || Matrix_Utils.Get_InfoPathData(' PA_Skin_Ulcer_Not_Pressure ',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
  v_Str := v_Str || '        <title>Cellulitis</title>' || LF;
  v_Str := v_Str || '        <value>' || Matrix_Utils.Get_InfoPathData(' PA_Skin_Cellulitis',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        <followupQuestions>' || LF;
  v_Str := v_Str || '            <title>Site:</title>' || LF;
  v_Str := v_Str || '            <answer>' || Matrix_Utils.Get_InfoPathData(' PA_Skin_Cellulitis_Box ',v_CaseId,'ST') || '</answer>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </followupQuestions>'|| LF;
  v_Str := v_Str || '        <managementPlan>' || Matrix_Utils.Get_InfoPathData('PA_Skin_Cellulitis_Plan_E1                                                  
+ PA_Skin_Cellulitis_Plan_E2                                                  
+ PA_Skin_Cellulitis_Plan_E3                                                  
+ PA_Skin_Cellulitis_Plan_E4                                                  
+ PA_Skin_Cellulitis_Plan_E5                                                  
+ PA_Skin_Cellulitis_Plan_M1                                                  
+ PA_Skin_Cellulitis_Plan_M2                                                  
+ PA_Skin_Cellulitis_Plan_M3                                                  
+ PA_Skin_Cellulitis_Plan_R1                                                  
+ PA_Skin_Cellulitis_Plan_R2                                                  
',v_CaseId,'MP') || '</managementPlan>' || LF;
  v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
  v_Str := v_Str || '        <title>Psoriasis</title>' || LF;
  v_Str := v_Str || '        <value>' || Matrix_Utils.Get_InfoPathData(' PA_Skin_Psoriasis ',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '        <managementPlan>' || Matrix_Utils.Get_InfoPathData('PA_Skin_Psoriasis_Plan_E1                                                  
+ PA_Skin_Psoriasis_Plan_E2                                                  
+ PA_Skin_Psoriasis_Plan_E3                                                  
+ PA_Skin_Psoriasis_Plan_E4                                                  
+ PA_Skin_Psoriasis_Plan_E5                                                  
+ PA_Skin_Psoriasis_Plan_M1                                                  
+ PA_Skin_Psoriasis_Plan_M2                                                  
+ PA_Skin_Psoriasis_Plan_M3                                                  
+ PA_Skin_Psoriasis_Plan_R1                                                  
+ PA_Skin_Psoriasis_Plan_R2                                                  
',v_CaseId,'MP') || '</managementPlan>' || LF;
  v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
  v_Str := v_Str || '        <title>Other Significant Diagnoses</title>' || LF;
  v_Str := v_Str || '        <value>' || Matrix_Utils.Get_InfoPathData(' PA_Skin_Other ',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '        <followupQuestions>' || LF;
  v_Str := v_Str || '            <title>Other:</title>' || LF;
  v_Str := v_Str || '            <answer>' || Matrix_Utils.Get_InfoPathData(' PA_Skin_Other_box',v_CaseId,'ST') || '</answer>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </followupQuestions>'|| LF;
  v_Str := v_Str || '        <managementPlan>' || Matrix_Utils.Get_InfoPathData('PA_Skin_Other_Plan_E1                                                  
+ PA_Skin_Other_Plan_E2                                                  
+ PA_Skin_Other_Plan_E3                                                  
+ PA_Skin_Other_Plan_E4                                                  
+ PA_Skin_Other_Plan_E5                                                  
+ PA_Skin_Other_Plan_M1                                                  
+ PA_Skin_Other_Plan_M2                                                  
+ PA_Skin_Other_Plan_M3                                                  
+ PA_Skin_Other_Plan_R1                                                  
+ PA_Skin_Other_Plan_R2                                                  
',v_CaseId,'MP') || '</managementPlan>' || LF;
  v_Str := v_Str || '   </diagnosis>'|| LF;
  v_Str := v_Str || ' </sections>'|| LF;

  v_Str := v_Str || ' <sections>'|| LF;
  v_Str := v_Str || '  <title>Renal/Genitourinary</title>' || LF;
  v_Str := v_Str || '   <diagnosis>' || LF;
  v_Str := v_Str || '        <title>Urinary Tract Infection (active)</title>' || LF;
  v_Str := v_Str || '        <value>' || Matrix_Utils.Get_InfoPathData(' PA_Renal_UTI ',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '        <managementPlan>' || Matrix_Utils.Get_InfoPathData('PA_Renal_UTI_Plan_E1                                                  
+ PA_Renal_UTI_Plan_E2                                                  
+ PA_Renal_UTI_Plan_E3                                                  
+ PA_Renal_UTI_Plan_E4                                                  
+ PA_Renal_UTI_Plan_E5                                                  
+ PA_Renal_UTI_Plan_M1                                                  
+ PA_Renal_UTI_Plan_M2                                                  
+ PA_Renal_UTI_Plan_M3                                                  
+ PA_Renal_UTI_Plan_R1                                                  
+ PA_Renal_UTI_Plan_R2                                                  
',v_CaseId,'MP') || '</managementPlan>' || LF;
  v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
  v_Str := v_Str || '        <title>Chronic Kidney Disease Stage I (GER 2.90) (with evidence of renalDamage such as proteinuria)</title>' || LF;
  v_Str := v_Str || '        <value>' || Matrix_Utils.Get_InfoPathData(' PA_Renal_CKD_Stage1 ',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '        <managementPlan>' || Matrix_Utils.Get_InfoPathData('PA_Renal_CKD_Stage1_Plan_E1                                                  
+ PA_Renal_CKD_Stage1_Plan_E2                                                  
+ PA_Renal_CKD_Stage1_Plan_E3                                                  
+ PA_Renal_CKD_Stage1_Plan_E4                                                  
+ PA_Renal_CKD_Stage1_Plan_E5                                                  
+ PA_Renal_CKD_Stage1_Plan_M1                                                  
+ PA_Renal_CKD_Stage1_Plan_M2                                                  
+ PA_Renal_CKD_Stage1_Plan_M3                                                  
+ PA_Renal_CKD_Stage1_Plan_R1                                                  
+ PA_Renal_CKD_Stage1_Plan_R2                                                  
',v_CaseId,'MP') || '</managementPlan>' || LF;
  v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
  v_Str := v_Str || '        <title>Chronic Kidney Disease Stage II Mild(GFR 60-89)</title>' || LF;
  v_Str := v_Str || '        <value>' || Matrix_Utils.Get_InfoPathData('PA_Renal_CKD_Stage2',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '        <managementPlan>' || Matrix_Utils.Get_InfoPathData('PA_Renal_CKD_Stage2_Plan_E1                                                  
+ PA_Renal_CKD_Stage2_Plan_E2                                                  
+ PA_Renal_CKD_Stage2_Plan_E3                                                  
+ PA_Renal_CKD_Stage2_Plan_E4                                                  
+ PA_Renal_CKD_Stage2_Plan_E5                                                  
+ PA_Renal_CKD_Stage2_Plan_M1                                                  
+ PA_Renal_CKD_Stage2_Plan_M2                                                  
+ PA_Renal_CKD_Stage2_Plan_M3                                                  
+ PA_Renal_CKD_Stage2_Plan_R1                                                  
+ PA_Renal_CKD_Stage2_Plan_R2                                                  
',v_CaseId,'MP') || '</managementPlan>' || LF;
  v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
  v_Str := v_Str || '        <title>Chronic Kidney Disease Stage III Moderate (GFR 30-59)</title>' || LF;
  v_Str := v_Str || '        <value>' || Matrix_Utils.Get_InfoPathData('PA_Renal_CKD_Stage3',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '        <managementPlan>' || Matrix_Utils.Get_InfoPathData('PA_Renal_CKD_Stage3_Plan_E1                                                  
+ PA_Renal_CKD_Stage3_Plan_E2                                                  
+ PA_Renal_CKD_Stage3_Plan_E3                                                  
+ PA_Renal_CKD_Stage3_Plan_E4                                                  
+ PA_Renal_CKD_Stage3_Plan_E5                                                  
+ PA_Renal_CKD_Stage3_Plan_M1                                                  
+ PA_Renal_CKD_Stage3_Plan_M2                                                  
+ PA_Renal_CKD_Stage3_Plan_M3                                                  
+ PA_Renal_CKD_Stage3_Plan_R1                                                  
+ PA_Renal_CKD_Stage3_Plan_R2                                                  
',v_CaseId,'MP') || '</managementPlan>' || LF;
  v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
  v_Str := v_Str || '        <title>Chronic Kidney Disease Stage IV Severe (GFR 15-29)</title>' || LF;
  v_Str := v_Str || '        <value>' || Matrix_Utils.Get_InfoPathData('PA_Renal_CKD_Stage4',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '        <managementPlan>' || Matrix_Utils.Get_InfoPathData('PA_Renal_CKD_Stage4_Plan_E1                                                  
+ PA_Renal_CKD_Stage4_Plan_E2                                                  
+ PA_Renal_CKD_Stage4_Plan_E3                                                  
+ PA_Renal_CKD_Stage4_Plan_E4                                                  
+ PA_Renal_CKD_Stage4_Plan_E5                                                  
+ PA_Renal_CKD_Stage4_Plan_M1                                                  
+ PA_Renal_CKD_Stage4_Plan_M2                                                  
+ PA_Renal_CKD_Stage4_Plan_M3                                                  
+ PA_Renal_CKD_Stage4_Plan_R1                                                  
+ PA_Renal_CKD_Stage4_Plan_R2                                                  
',v_CaseId,'MP') || '</managementPlan>' || LF;
  v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
  v_Str := v_Str || '        <title>Chronic Kidney Disease Stage V (GFR &amp;lt;15)</title>' || LF;
  v_Str := v_Str || '        <value>' || Matrix_Utils.Get_InfoPathData('PA_Renal_CKD_Stage5',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '        <value>' || Matrix_Utils.Get_InfoPathData('PA_Renal_CKD_Stage5_Plan_E1                                                  
+ PA_Renal_CKD_Stage5_Plan_E2                                                  
+ PA_Renal_CKD_Stage5_Plan_E3                                                  
+ PA_Renal_CKD_Stage5_Plan_E4                                                  
+ PA_Renal_CKD_Stage5_Plan_E5                                                  
+ PA_Renal_CKD_Stage5_Plan_M1                                                  
+ PA_Renal_CKD_Stage5_Plan_M2                                                  
+ PA_Renal_CKD_Stage5_Plan_M3                                                  
+ PA_Renal_CKD_Stage5_Plan_R1                                                  
+ PA_Renal_CKD_Stage5_Plan_R2                                                  
',v_CaseId,'MP') || '</value>' || LF;
  v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
  v_Str := v_Str || '        <title>Chronic Kidney Disease ESR (If on dialysis)</title>' || LF;
  v_Str := v_Str || '        <value>' || Matrix_Utils.Get_InfoPathData(' PA_Renal_CKD_ESRD ',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '        <managementPlan>' || Matrix_Utils.Get_InfoPathData('PA_Renal_CKD_ESRD_Plan_E1                                                  
+ PA_Renal_CKD_ESRD_Plan_E2                                                  
+ PA_Renal_CKD_ESRD_Plan_E3                                                  
+ PA_Renal_CKD_ESRD_Plan_E4                                                  
+ PA_Renal_CKD_ESRD_Plan_E5                                                  
+ PA_Renal_CKD_ESRD_Plan_M1                                                  
+ PA_Renal_CKD_ESRD_Plan_M2                                                  
+ PA_Renal_CKD_ESRD_Plan_M3                                                  
+ PA_Renal_CKD_ESRD_Plan_R1                                                  
+ PA_Renal_CKD_ESRD_Plan_R2                                                  
',v_CaseId,'MP') || '</managementPlan>' || LF;
  v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
  v_Str := v_Str || '        <title>Chronic Kidney Disease Unspecified</title>' || LF;
  v_Str := v_Str || '        <value>' || Matrix_Utils.Get_InfoPathData(' PA_Renal_CKD_Unspecified ',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '        <managementPlan>' || Matrix_Utils.Get_InfoPathData('PA_Renal_CKD_Unspecified_Plan_E1                                                  
+ PA_Renal_CKD_Unspecified_Plan_E2                                                  
+ PA_Renal_CKD_Unspecified_Plan_E3                                                  
+ PA_Renal_CKD_Unspecified_Plan_E4                                                  
+ PA_Renal_CKD_Unspecified_Plan_E5                                                  
+ PA_Renal_CKD_Unspecified_Plan_M1                                                  
+ PA_Renal_CKD_Unspecified_Plan_M2                                                  
+ PA_Renal_CKD_Unspecified_Plan_M3                                                  
+ PA_Renal_CKD_Unspecified_Plan_R1                                                  
+ PA_Renal_CKD_Unspecified_Plan_R2                                                  
',v_CaseId,'MP') || '</managementPlan>' || LF;
  v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
  v_Str := v_Str || '        <title>Dialysis</title>' || LF;
  v_Str := v_Str || '        <value>' || Matrix_Utils.Get_InfoPathData(' PA_Renal_Dialysis_Status ',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '        <followupQuestions>' || LF;
  v_Str := v_Str || '            <title>Dialysis Status:</title>' || LF;
  v_Str := v_Str || '            <answer>' || Matrix_Utils.Get_InfoPathData(' PA_Renal_Dialysis_Status_Hemodialysis 
+ PA_Renal_Dialysis_Status_Peritoneal',v_CaseId,'ST') || '</answer>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </followupQuestions>'|| LF;
  v_Str := v_Str || '        <followupQuestions>' || LF;
  v_Str := v_Str || '            <title>Start Date:</title>' || LF;
  v_Str := v_Str || '            <answer>' || Matrix_Utils.Get_InfoPathData(' PA_Renal_Dialysis_Status_date',v_CaseId,'DT') || '</answer>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </followupQuestions>'|| LF;
  v_Str := v_Str || '        <managementPlan>' || Matrix_Utils.Get_InfoPathData('PA_Renal_Dialysis_Status_Plan_E1                                                  
+ PA_Renal_Dialysis_Status_Plan_E2                                                  
+ PA_Renal_Dialysis_Status_Plan_E3                                                  
+ PA_Renal_Dialysis_Status_Plan_E4                                                  
+ PA_Renal_Dialysis_Status_Plan_E5                                                  
+ PA_Renal_Dialysis_Status_Plan_M1                                                  
+ PA_Renal_Dialysis_Status_Plan_M2                                                  
+ PA_Renal_Dialysis_Status_Plan_M3                                                  
+ PA_Renal_Dialysis_Status_Plan_R1                                                  
+ PA_Renal_Dialysis_Status_Plan_R2                                                  
',v_CaseId,'MP') || '</managementPlan>' || LF;
  v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
  v_Str := v_Str || '        <title>Renal Transplant</title>' || LF;
  v_Str := v_Str || '        <value>' || Matrix_Utils.Get_InfoPathData(' PA_Renal_Transplant ',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '        <managementPlan>' || Matrix_Utils.Get_InfoPathData('PA_Renal_Transplant_Plan_E1                                                  
+ PA_Renal_Transplant_Plan_E2                                                  
+ PA_Renal_Transplant_Plan_E3                                                  
+ PA_Renal_Transplant_Plan_E4                                                  
+ PA_Renal_Transplant_Plan_E5                                                  
+ PA_Renal_Transplant_Plan_M1                                                  
+ PA_Renal_Transplant_Plan_M2                                                  
+ PA_Renal_Transplant_Plan_M3                                                  
+ PA_Renal_Transplant_Plan_R1                                                  
+ PA_Renal_Transplant_Plan_R2                                                  
',v_CaseId,'MP') || '</managementPlan>' || LF;
  v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
  v_Str := v_Str || '        <title>BPH (benign prostatic hypettiophy)</title>' || LF;
  v_Str := v_Str || '        <value>' || Matrix_Utils.Get_InfoPathData(' PA_Renal_BPH ',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '        <managementPlan>' || Matrix_Utils.Get_InfoPathData('PA_Renal_BPH_Plan_E1                                                  
+ PA_Renal_BPH_Plan_E2                                                  
+ PA_Renal_BPH_Plan_E3                                                  
+ PA_Renal_BPH_Plan_E4                                                  
+ PA_Renal_BPH_Plan_E5                                                  
+ PA_Renal_BPH_Plan_M1                                                  
+ PA_Renal_BPH_Plan_M2                                                  
+ PA_Renal_BPH_Plan_M3                                                  
+ PA_Renal_BPH_Plan_R1                                                  
+ PA_Renal_BPH_Plan_R2                                                  
',v_CaseId,'MP') || '</managementPlan>' || LF;
  v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
  v_Str := v_Str || '        <title>Other Significant Diagnoses:</title>' || LF;
  v_Str := v_Str || '        <value>' || Matrix_Utils.Get_InfoPathData(' PA_Renal_Other ',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '        <followupQuestions>' || LF;
  v_Str := v_Str || '            <title>Other:</title>' || LF;
  v_Str := v_Str || '            <answer>' || Matrix_Utils.Get_InfoPathData(' PA_Renal_Other_Box',v_CaseId,'ST') || '</answer>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </followupQuestions>'|| LF;
  v_Str := v_Str || '        <managementPlan>' || Matrix_Utils.Get_InfoPathData('PA_Renal_Other_Plan_E1                                                  
+ PA_Renal_Other_Plan_E2                                                  
+ PA_Renal_Other_Plan_E3                                                  
+ PA_Renal_Other_Plan_E4                                                  
+ PA_Renal_Other_Plan_E5                                                  
+ PA_Renal_Other_Plan_M1                                                  
+ PA_Renal_Other_Plan_M2                                                  
+ PA_Renal_Other_Plan_M3                                                  
+ PA_Renal_Other_Plan_R1                                                  
+ PA_Renal_Other_Plan_R2                                                  
',v_CaseId,'MP') || '</managementPlan>' || LF;
  v_Str := v_Str || '   </diagnosis>'|| LF;
  v_Str := v_Str || ' </sections>'|| LF;

  v_Str := v_Str || ' <sections>'|| LF;
  v_Str := v_Str || '  <title>Bone/Rheum/Joint Disease</title>' || LF;
  v_Str := v_Str || '   <diagnosis>' || LF;
  v_Str := v_Str || '        <title>Polymyalgia Rheumatica</title>' || LF;
  v_Str := v_Str || '        <value>' || Matrix_Utils.Get_InfoPathData(' PA_Bone_Polymyalgia_Rheumatica ',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '        <managementPlan>' || Matrix_Utils.Get_InfoPathData('PA_Bone_Polymyalgia_Rheumatica_Plan_E1                                                  
+ PA_Bone_Polymyalgia_Rheumatica_Plan_E2                                                  
+ PA_Bone_Polymyalgia_Rheumatica_Plan_E3                                                  
+ PA_Bone_Polymyalgia_Rheumatica_Plan_E4                                                  
+ PA_Bone_Polymyalgia_Rheumatica_Plan_E5                                                  
+ PA_Bone_Polymyalgia_Rheumatica_Plan_M1                                                  
+ PA_Bone_Polymyalgia_Rheumatica_Plan_M2                                                  
+ PA_Bone_Polymyalgia_Rheumatica_Plan_M3                                                  
+ PA_Bone_Polymyalgia_Rheumatica_Plan_R1                                                  
+ PA_Bone_Polymyalgia_Rheumatica_Plan_R2                                                  
',v_CaseId ,
  'MP') || '</managementPlan>' || LF;
  v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
  v_Str := v_Str || '        <title>Systemic Lupus Erythematosus (SLE)</title>' || LF;
  v_Str := v_Str || '        <value>' || Matrix_Utils.Get_InfoPathData(' PA_Bone_SLE ',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '        <managementPlan>' || Matrix_Utils.Get_InfoPathData('PA_Bone_SLE_Plan_E1                                                  
+ PA_Bone_SLE_Plan_E2                                                  
+ PA_Bone_SLE_Plan_E3                                                  
+ PA_Bone_SLE_Plan_E4                                                  
+ PA_Bone_SLE_Plan_E5                                                  
+ PA_Bone_SLE_Plan_M1                                                  
+ PA_Bone_SLE_Plan_M2                                                  
+ PA_Bone_SLE_Plan_M3                                                  
+ PA_Bone_SLE_Plan_R1                                                  
+ PA_Bone_SLE_Plan_R2                                                  
',v_CaseId,'MP') || '</managementPlan>' || LF;
  v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
  v_Str := v_Str || '        <title>Rheumatoid Arthritis</title>' || LF;
  v_Str := v_Str || '        <value>' || Matrix_Utils.Get_InfoPathData(' PA_Bone_Rheumatoid_Arthritis ',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '        <followupQuestions>' || LF;
  v_Str := v_Str || '            <title>Also Complicated with:</title>' || LF;
  v_Str := v_Str || '            <answer>' || Matrix_Utils.Get_InfoPathData(' PA_Bone_Rheumatoid_Arthritis_Myopathy ',v_CaseId,'ST') || '</answer>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </followupQuestions>'|| LF;
  v_Str := v_Str || '        <followupQuestions>' || LF;
  v_Str := v_Str || '            <title>Also Complicated with:</title>' || LF;
  v_Str := v_Str || '            <answer>' || Matrix_Utils.Get_InfoPathData(' PA_Bone_Rheumatoid_Arthritis_Polyneuropathy ',v_CaseId,'ST') || '</answer>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </followupQuestions>'|| LF;
  v_Str := v_Str || '        <managementPlan>' || Matrix_Utils.Get_InfoPathData('PA_Bone_Rheumatoid_Arthritis_Plan_E1                                                  
+ PA_Bone_Rheumatoid_Arthritis_Plan_E2                                                  
+ PA_Bone_Rheumatoid_Arthritis_Plan_E3                                                  
+ PA_Bone_Rheumatoid_Arthritis_Plan_E4                                                  
+ PA_Bone_Rheumatoid_Arthritis_Plan_E5                                                  
+ PA_Bone_Rheumatoid_Arthritis_Plan_M1                                                  
+ PA_Bone_Rheumatoid_Arthritis_Plan_M2                                                  
+ PA_Bone_Rheumatoid_Arthritis_Plan_M3                                                  
+ PA_Bone_Rheumatoid_Arthritis_Plan_R1                                                  
+ PA_Bone_Rheumatoid_Arthritis_Plan_R2                                                  
',v_CaseId,'MP') ||
  '</managementPlan>' || LF;
  v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
  v_Str := v_Str || '        <title>Fibromyalgia</title>' || LF;
  v_Str := v_Str || '        <value>' || Matrix_Utils.Get_InfoPathData(' PA_Bone_Fibromyalgia ',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '        <managementPlan>' || Matrix_Utils.Get_InfoPathData('PA_Bone_Fibromyalgia_Plan_E1                                                  
+ PA_Bone_Fibromyalgia_Plan_E2                                                  
+ PA_Bone_Fibromyalgia_Plan_E3                                                  
+ PA_Bone_Fibromyalgia_Plan_E4                                                  
+ PA_Bone_Fibromyalgia_Plan_E5                                                  
+ PA_Bone_Fibromyalgia_Plan_M1                                                  
+ PA_Bone_Fibromyalgia_Plan_M2                                                  
+ PA_Bone_Fibromyalgia_Plan_M3                                                  
+ PA_Bone_Fibromyalgia_Plan_R1                                                  
+ PA_Bone_Fibromyalgia_Plan_R2                                                  
',v_CaseId,'MP') || '</managementPlan>' || LF;
  v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
  v_Str := v_Str || '        <title>Back Pain</title>' || LF;
  v_Str := v_Str || '        <value>' || Matrix_Utils.Get_InfoPathData(' PA_Bone_Back_Pain ',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '        <managementPlan>' || Matrix_Utils.Get_InfoPathData('PA_Bone_Back_Pain_Plan_E1                                                  
+ PA_Bone_Back_Pain_Plan_E2                                                  
+ PA_Bone_Back_Pain_Plan_E3                                                  
+ PA_Bone_Back_Pain_Plan_E4                                                  
+ PA_Bone_Back_Pain_Plan_E5                                                  
+ PA_Bone_Back_Pain_Plan_M1                                                  
+ PA_Bone_Back_Pain_Plan_M2                                                  
+ PA_Bone_Back_Pain_Plan_M3                                                  
+ PA_Bone_Back_Pain_Plan_R1                                                  
+ PA_Bone_Back_Pain_Plan_R2                                                  
',v_CaseId,'MP') || '</managementPlan>' || LF;
  v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
  v_Str := v_Str || '        <title>Degenerative Disc Disease (DDD)</title>' || LF;
  v_Str := v_Str || '        <value>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '        <followupQuestions>' || LF;
  v_Str := v_Str || '            <title>Location:</title>' || LF;
  v_Str := v_Str || '            <answer>' || Matrix_Utils.Get_InfoPathData(' PA_Bone_DDD_Cervical ',v_CaseId,'ST') || '</answer>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </followupQuestions>'|| LF;
  v_Str := v_Str || '        <followupQuestions>' || LF;
  v_Str := v_Str || '            <title>Location:</title>' || LF;
  v_Str := v_Str || '            <answer>' || Matrix_Utils.Get_InfoPathData(' PA_Bone_DDD_Lumbar ',v_CaseId,'ST') || '</answer>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </followupQuestions>'|| LF;
  v_Str := v_Str || '        <managementPlan>' || Matrix_Utils.Get_InfoPathData('PA_Bone_DDD_Plan_E1                                                  
+ PA_Bone_DDD_Plan_E2                                                  
+ PA_Bone_DDD_Plan_E3                                                  
+ PA_Bone_DDD_Plan_E4                                                  
+ PA_Bone_DDD_Plan_E5                                                  
+ PA_Bone_DDD_Plan_M1                                                  
+ PA_Bone_DDD_Plan_M2                                                  
+ PA_Bone_DDD_Plan_M3                                                  
+ PA_Bone_DDD_Plan_R1                                                  
+ PA_Bone_DDD_Plan_R2                                                  
',v_CaseId,'MP') || '</managementPlan>' || LF;
  v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
  v_Str := v_Str || '        <title>Osteoarthritis/DJD Localized</title>' || LF;
  v_Str := v_Str || '        <value>' || Matrix_Utils.Get_InfoPathData(' PA_Bone_Osteoarthritis_Localized ',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '        <followupQuestions>' || LF;
  v_Str := v_Str || '            <title>Site:</title>' || LF;
  v_Str := v_Str || '            <answer>' || Matrix_Utils.Get_InfoPathData(' PA_Bone_Osteoarthritis_Localized_Box ',v_CaseId,'ST') || '</answer>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </followupQuestions>'|| LF;
  v_Str := v_Str || '        <managementPlan>' || Matrix_Utils.Get_InfoPathData(
  'PA_Bone_Osteoarthritis_Localized_Plan_E1                                                  
+ PA_Bone_Osteoarthritis_Localized_Plan_E2                                                  
+ PA_Bone_Osteoarthritis_Localized_Plan_E3                                                  
+ PA_Bone_Osteoarthritis_Localized_Plan_E4                                                  
+ PA_Bone_Osteoarthritis_Localized_Plan_E5                                                  
+ PA_Bone_Osteoarthritis_Localized_Plan_M1                                                  
+ PA_Bone_Osteoarthritis_Localized_Plan_M2                                                  
+ PA_Bone_Osteoarthritis_Localized_Plan_M3                                                  
+ PA_Bone_Osteoarthritis_Localized_Plan_R1                                                  
+ PA_Bone_Osteoarthritis_Localized_Plan_R2                                                  
',v_CaseId,'MP') || '</managementPlan>' || LF;
  v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
  v_Str := v_Str || '        <title>Osteoarthritis/DJD Generalized</title>' || LF;
  v_Str := v_Str || '        <value>' || Matrix_Utils.Get_InfoPathData(' PA_Bone_Osteoarthritis_Generalized ',v_CaseId,'TF') || '</value>' || LF;
   v_Str := v_Str || '        <managementPlan>' || Matrix_Utils.Get_InfoPathData(
  'PA_Bone_Osteoarthritis_Generalized_Plan_E1
+PA_Bone_Osteoarthritis_Generalized_Plan_E2
+PA_Bone_Osteoarthritis_Generalized_Plan_E3
+PA_Bone_Osteoarthritis_Generalized_Plan_E4
+PA_Bone_Osteoarthritis_Generalized_Plan_E5
+PA_Bone_Osteoarthritis_Generalized_Plan_M1
+PA_Bone_Osteoarthritis_Generalized_Plan_M2
+PA_Bone_Osteoarthritis_Generalized_Plan_M3
+PA_Bone_Osteoarthritis_Generalized_Plan_R1
+PA_Bone_Osteoarthritis_Generalized_Plan_R2',v_CaseId,'MP') || '</managementPlan>' || LF;
  
  
  
  v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
  v_Str := v_Str || '        <title>Gout</title>' || LF;
  v_Str := v_Str || '        <value>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '        <followupQuestions>' || LF;
  v_Str := v_Str || '            <title>Type:</title>' || LF;
  v_Str := v_Str || '            <answer>' || Matrix_Utils.Get_InfoPathData(' PA_Bone_Gout_Acute ',v_CaseId,'ST') || '</answer>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </followupQuestions>'|| LF;
  v_Str := v_Str || '        <followupQuestions>' || LF;
  v_Str := v_Str || '            <title>Type:</title>' || LF;
  v_Str := v_Str || '            <answer>' || Matrix_Utils.Get_InfoPathData(' PA_Bone_Gout_Chronic' ,v_CaseId,'ST') || '</answer>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </followupQuestions>'|| LF;
  v_Str := v_Str || '        <followupQuestions>' || LF;
  v_Str := v_Str || '            <title>Type:</title>' || LF;
  v_Str := v_Str || '            <answer>' || Matrix_Utils.Get_InfoPathData(' PA_Bone_Gout_Unspecified ',v_CaseId,'ST') || '</answer>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </followupQuestions>'|| LF;
  v_Str := v_Str || '        <managementPlan>' || Matrix_Utils.Get_InfoPathData('PA_Bone_Gout_Plan_E1                                                  
+ PA_Bone_Gout_Plan_E2                                                  
+ PA_Bone_Gout_Plan_E3                                                  
+ PA_Bone_Gout_Plan_E4                                                  
+ PA_Bone_Gout_Plan_E5                                                  
+ PA_Bone_Gout_Plan_M1                                                  
+ PA_Bone_Gout_Plan_M2                                                  
+ PA_Bone_Gout_Plan_M3                                                  
+ PA_Bone_Gout_Plan_R1                                                  
+ PA_Bone_Gout_Plan_R2                                                  
',v_CaseId,'MP') || '</managementPlan>' || LF;
  v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
  v_Str := v_Str || '        <title>Spinal Stenosis</title>' || LF;
  v_Str := v_Str || '        <value>' || Matrix_Utils.Get_InfoPathData(' PA_Bone_Spinal_Stenosis ',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '        <followupQuestions>' || LF;
  v_Str := v_Str || '            <title>Type:</title>' || LF;
  v_Str := v_Str || '            <answer>' || Matrix_Utils.Get_InfoPathData(' PA_Bone_Spinal_Stenosis_Lumbar ',v_CaseId,'ST') || '</answer>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </followupQuestions>'|| LF;
  v_Str := v_Str || '        <followupQuestions>' || LF;
  v_Str := v_Str || '            <title>Type:</title>' || LF;
  v_Str := v_Str || '            <answer>' || Matrix_Utils.Get_InfoPathData(' PA_Bone_Spinal_Stenosis_Cervical ',v_CaseId,'ST') || '</answer>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </followupQuestions>'|| LF;
  v_Str := v_Str || '        <managementPlan>' || Matrix_Utils.Get_InfoPathData('PA_Bone_Spinal_Stenosis_Plan_E1                                                  
+ PA_Bone_Spinal_Stenosis_Plan_E2                                                  
+ PA_Bone_Spinal_Stenosis_Plan_E3                                                  
+ PA_Bone_Spinal_Stenosis_Plan_E4                                                  
+ PA_Bone_Spinal_Stenosis_Plan_E5                                                  
+ PA_Bone_Spinal_Stenosis_Plan_M1                                                  
+ PA_Bone_Spinal_Stenosis_Plan_M2                                                  
+ PA_Bone_Spinal_Stenosis_Plan_M3                                                  
+ PA_Bone_Spinal_Stenosis_Plan_R1                                                  
+ PA_Bone_Spinal_Stenosis_Plan_R2                                                  
',v_CaseId,'MP') || '</managementPlan>' || LF;
  v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
  v_Str := v_Str || '        <title>' || 'Osteomyelitis, Acute' || '</title>' || LF;
  v_Str := v_Str || '        <value>' || Matrix_Utils.Get_InfoPathData(' PA_Bone_Osteomyelitis_Acute ',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '        <followupQuestions>' || LF;
  v_Str := v_Str || '            <title>Specify site:</title>' || LF;
  v_Str := v_Str || '            <answer>' || Matrix_Utils.Get_InfoPathData(' PA_Bone_Osteomyelitis_Acute_Box ',v_CaseId,'ST') || '</answer>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </followupQuestions>'|| LF;
  v_Str := v_Str || '        <managementPlan>' || Matrix_Utils.Get_InfoPathData('PA_Bone_Osteomyelitis_Acute_Plan_E1                                                  
+ PA_Bone_Osteomyelitis_Acute_Plan_E2                                                  
+ PA_Bone_Osteomyelitis_Acute_Plan_E3                                                  
+ PA_Bone_Osteomyelitis_Acute_Plan_E4                                                  
+ PA_Bone_Osteomyelitis_Acute_Plan_E5                                                  
+ PA_Bone_Osteomyelitis_Acute_Plan_M1                                                  
+ PA_Bone_Osteomyelitis_Acute_Plan_M2                                                  
+ PA_Bone_Osteomyelitis_Acute_Plan_M3                                                  
+ PA_Bone_Osteomyelitis_Acute_Plan_R1                                                  
+ PA_Bone_Osteomyelitis_Acute_Plan_R2                                                  
',v_CaseId,'MP') || '</managementPlan>' ||
  LF;
  v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
  v_Str := v_Str || '        <title>' || 'Osteomyelitis, Chronic' || '</title>' || LF;
  v_Str := v_Str || '        <value>' || Matrix_Utils.Get_InfoPathData('PA_Bone_Osteomyelitis_Chronic',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '        <followupQuestions>' || LF;
  v_Str := v_Str || '            <title>Specify site:</title>' || LF;
  v_Str := v_Str || '            <answer>' || Matrix_Utils.Get_InfoPathData(' PA_Bone_Osteomyelitis_Chronic_Box ',v_CaseId,'ST') || '</answer>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </followupQuestions>'|| LF;
  v_Str := v_Str || '        <managementPlan>' || Matrix_Utils.Get_InfoPathData('PA_Bone_Osteomyelitis_Chronic_Plan_E1                                                  
+ PA_Bone_Osteomyelitis_Chronic_Plan_E2                                                  
+ PA_Bone_Osteomyelitis_Chronic_Plan_E3                                                  
+ PA_Bone_Osteomyelitis_Chronic_Plan_E4                                                  
+ PA_Bone_Osteomyelitis_Chronic_Plan_E5                                                  
+ PA_Bone_Osteomyelitis_Chronic_Plan_M1                                                  
+ PA_Bone_Osteomyelitis_Chronic_Plan_M2                                                  
+ PA_Bone_Osteomyelitis_Chronic_Plan_M3                                                  
+ PA_Bone_Osteomyelitis_Chronic_Plan_R1                                                  
+ PA_Bone_Osteomyelitis_Chronic_Plan_R2                                                  
',v_CaseId,'MP') ||
  '</managementPlan>' || LF;
  v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
  v_Str := v_Str || '        <title>Osteoporosis</title>' || LF;
  v_Str := v_Str || '        <value>' || Matrix_Utils.Get_InfoPathData(' PA_Bone_Osteoporosis ',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '        <managementPlan>' || Matrix_Utils.Get_InfoPathData('PA_Bone_Osteoporosis_Plan_E1                                                  
+ PA_Bone_Osteoporosis_Plan_E2                                                  
+ PA_Bone_Osteoporosis_Plan_E3                                                  
+ PA_Bone_Osteoporosis_Plan_E4                                                  
+ PA_Bone_Osteoporosis_Plan_E5                                                  
+ PA_Bone_Osteoporosis_Plan_M1                                                  
+ PA_Bone_Osteoporosis_Plan_M2                                                  
+ PA_Bone_Osteoporosis_Plan_M3                                                  
+ PA_Bone_Osteoporosis_Plan_R1                                                  
+ PA_Bone_Osteoporosis_Plan_R2                                                  
',v_CaseId,'MP') || '</managementPlan>' || LF;
  v_Str := v_Str || '   </diagnosis><diagnosis>' || LF;
  v_Str := v_Str || '        <title>Pathological Fracture Vertebra</title>' || LF;
  v_Str := v_Str || '        <value>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
-- v_Str := v_Str || '   <subDiagnosis>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</subDiagnosis>' || LF;  
  v_Str := v_Str || '   <subDiagnosis>'  || LF;
  v_Str := v_Str || '        <title>Healing</title>' || LF;
  v_Str := v_Str || '        <value>' || Matrix_Utils.Get_InfoPathData(' PA_Bone_Path_Frac_Vertebra_Healing ',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        <managementPlan>' || Matrix_Utils.Get_InfoPathData('PA_Bone_Path_Frac_Vertebra_Plan_E1                                                  
+ PA_Bone_Path_Frac_Vertebra_Plan_E2                                                  
+ PA_Bone_Path_Frac_Vertebra_Plan_E3                                                  
+ PA_Bone_Path_Frac_Vertebra_Plan_E4                                                  
+ PA_Bone_Path_Frac_Vertebra_Plan_E5                                                  
+ PA_Bone_Path_Frac_Vertebra_Plan_M1                                                  
+ PA_Bone_Path_Frac_Vertebra_Plan_M2                                                  
+ PA_Bone_Path_Frac_Vertebra_Plan_M3                                                  
+ PA_Bone_Path_Frac_Vertebra_Plan_R1                                                  
+ PA_Bone_Path_Frac_Vertebra_Plan_R2                                                  
',v_CaseId,'MP') || '</managementPlan>' || LF;
  --v_Str := v_Str || '   <subDiagnosis>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</subDiagnosis>' || LF;
  v_Str := v_Str || '   </subDiagnosis>' || LF || '   <subDiagnosis>' || LF;
  v_Str := v_Str || '        <title>History of</title>' || LF;
  v_Str := v_Str || '        <value>' || Matrix_Utils.Get_InfoPathData(' PA_Bone_Path_Frac_Vertebra_History ',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        <managementPlan>' || Matrix_Utils.Get_InfoPathData('PA_Bone_Path_Frac_Vertebra_Plan_E1                                                  
+ PA_Bone_Path_Frac_Vertebra_Plan_E2                                                  
+ PA_Bone_Path_Frac_Vertebra_Plan_E3                                                  
+ PA_Bone_Path_Frac_Vertebra_Plan_E4                                                  
+ PA_Bone_Path_Frac_Vertebra_Plan_E5                                                  
+ PA_Bone_Path_Frac_Vertebra_Plan_M1                                                  
+ PA_Bone_Path_Frac_Vertebra_Plan_M2                                                  
+ PA_Bone_Path_Frac_Vertebra_Plan_M3                                                  
+ PA_Bone_Path_Frac_Vertebra_Plan_R1                                                  
+ PA_Bone_Path_Frac_Vertebra_Plan_R2                                                  
',v_CaseId,'MP') || '</managementPlan>' || LF;
--  v_Str := v_Str || '   <subDiagnosis>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</subDiagnosis>' || LF;
  v_Str := v_Str || '   </subDiagnosis>' || LF || '   <subDiagnosis>' || LF;
  v_Str := v_Str || '        <title>Non-healed</title>' || LF;
  v_Str := v_Str || '        <value>' || Matrix_Utils.Get_InfoPathData(' PA_Bone_Path_Frac_Vertebra_Nonhealed ',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        <managementPlan>' || Matrix_Utils.Get_InfoPathData('PA_Bone_Path_Frac_Vertebra_Plan_E1                                                  
+ PA_Bone_Path_Frac_Vertebra_Plan_E2                                                  
+ PA_Bone_Path_Frac_Vertebra_Plan_E3                                                  
+ PA_Bone_Path_Frac_Vertebra_Plan_E4                                                  
+ PA_Bone_Path_Frac_Vertebra_Plan_E5                                                  
+ PA_Bone_Path_Frac_Vertebra_Plan_M1                                                  
+ PA_Bone_Path_Frac_Vertebra_Plan_M2                                                  
+ PA_Bone_Path_Frac_Vertebra_Plan_M3                                                  
+ PA_Bone_Path_Frac_Vertebra_Plan_R1                                                  
+ PA_Bone_Path_Frac_Vertebra_Plan_R2                                                  
',v_CaseId,'MP') || '</managementPlan>' || LF;
  v_Str := v_Str || ' </subDiagnosis>' || LF;
  v_Str := v_Str || '   </diagnosis>' || LF;
  
  v_Str := v_Str || '   <diagnosis>' || LF;
  v_Str := v_Str || '        <title>Pathological Fracture Hip</title>' || LF;
  v_Str := v_Str || '        <value>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
--  v_Str := v_Str || '   <subDiagnosis>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</subDiagnosis>' || LF;
  v_Str := v_Str || '    <subDiagnosis>' || LF;
  v_Str := v_Str || '        <title>Healing</title>' || LF;
  v_Str := v_Str || '        <value>' || Matrix_Utils.Get_InfoPathData(' PA_Bone_Path_Frac_Hip_Healing ',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '        <managementPlan>' || Matrix_Utils.Get_InfoPathData('PA_Bone_Path_Frac_Hip_Plan_E1                                                  
+ PA_Bone_Path_Frac_Hip_Plan_E2                                                  
+ PA_Bone_Path_Frac_Hip_Plan_E3                                                  
+ PA_Bone_Path_Frac_Hip_Plan_E4                                                  
+ PA_Bone_Path_Frac_Hip_Plan_E5                                                  
+ PA_Bone_Path_Frac_Hip_Plan_M1                                                  
+ PA_Bone_Path_Frac_Hip_Plan_M2                                                  
+ PA_Bone_Path_Frac_Hip_Plan_M3                                                  
+ PA_Bone_Path_Frac_Hip_Plan_R1                                                  
+ PA_Bone_Path_Frac_Hip_Plan_R2                                                  
',v_CaseId,'MP') || '</managementPlan>' || LF;
--  v_Str := v_Str || '   <subDiagnosis>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</subDiagnosis>' || LF;
  v_Str := v_Str || '   </subDiagnosis>' || LF || '   <subDiagnosis>' || LF;
  v_Str := v_Str || '        <title>History of</title>' || LF;
  v_Str := v_Str || '        <value>' || Matrix_Utils.Get_InfoPathData(' PA_Bone_Path_Frac_Hip_History ',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        <managementPlan>' || Matrix_Utils.Get_InfoPathData('PA_Bone_Path_Frac_Hip_Plan_E1                                                  
+ PA_Bone_Path_Frac_Hip_Plan_E2                                                  
+ PA_Bone_Path_Frac_Hip_Plan_E3                                                  
+ PA_Bone_Path_Frac_Hip_Plan_E4                                                  
+ PA_Bone_Path_Frac_Hip_Plan_E5                                                  
+ PA_Bone_Path_Frac_Hip_Plan_M1                                                  
+ PA_Bone_Path_Frac_Hip_Plan_M2                                                  
+ PA_Bone_Path_Frac_Hip_Plan_M3                                                  
+ PA_Bone_Path_Frac_Hip_Plan_R1                                                  
+ PA_Bone_Path_Frac_Hip_Plan_R2                                                  
',v_CaseId,'MP') || '</managementPlan>' || LF;
--  v_Str := v_Str || '   <subDiagnosis>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</subDiagnosis>' || LF;
  v_Str := v_Str || '   </subDiagnosis>' || LF || '   <subDiagnosis>' || LF;
  v_Str := v_Str || '        <title>Non-healed</title>' || LF;
  v_Str := v_Str || '        <value>' || Matrix_Utils.Get_InfoPathData(' PA_Bone_Path_Frac_Hip_Nonhealed ',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '        <managementPlan>' || Matrix_Utils.Get_InfoPathData('PA_Bone_Path_Frac_Hip_Plan_E1                                                  
+ PA_Bone_Path_Frac_Hip_Plan_E2                                                  
+ PA_Bone_Path_Frac_Hip_Plan_E3                                                  
+ PA_Bone_Path_Frac_Hip_Plan_E4                                                  
+ PA_Bone_Path_Frac_Hip_Plan_E5                                                  
+ PA_Bone_Path_Frac_Hip_Plan_M1                                                  
+ PA_Bone_Path_Frac_Hip_Plan_M2                                                  
+ PA_Bone_Path_Frac_Hip_Plan_M3                                                  
+ PA_Bone_Path_Frac_Hip_Plan_R1                                                  
+ PA_Bone_Path_Frac_Hip_Plan_R2                                                  
',v_CaseId,'MP') || '</managementPlan>' || LF;
  v_Str := v_Str || ' </subDiagnosis>' || LF;
  v_Str := v_Str || '   </diagnosis>' || LF;
  
  v_Str := v_Str || '   <diagnosis>' || LF;
  v_Str := v_Str || '        <title>History of Traumatic Fracture</title>' || LF;
  v_Str := v_Str || '        <value>' || Matrix_Utils.Get_InfoPathData(' PA_Bone_History_Traumatic_Fracture ',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '        <followupQuestions>' || LF;
  v_Str := v_Str || '            <title>Fracture of:</title>' || LF;
  v_Str := v_Str || '            <answer>' || Matrix_Utils.Get_InfoPathData('PA_Bone_History_Traumatic_Fracture_Box',v_CaseId,'ST') || '</answer>' || LF;
  v_Str := v_Str || '        </followupQuestions>'|| LF;
  v_Str := v_Str || '        <managementPlan>' || Matrix_Utils.Get_InfoPathData(
  'PA_Bone_History_Traumatic_Fracture_Plan_E1                                                  
+ PA_Bone_History_Traumatic_Fracture_Plan_E2                                                  
+ PA_Bone_History_Traumatic_Fracture_Plan_E3                                                  
+ PA_Bone_History_Traumatic_Fracture_Plan_E4                                                  
+ PA_Bone_History_Traumatic_Fracture_Plan_E5                                                  
+ PA_Bone_History_Traumatic_Fracture_Plan_M1                                                  
+ PA_Bone_History_Traumatic_Fracture_Plan_M2                                                  
+ PA_Bone_History_Traumatic_Fracture_Plan_M3                                                  
+ PA_Bone_History_Traumatic_Fracture_Plan_R1                                                  
+ PA_Bone_History_Traumatic_Fracture_Plan_R2                                                  
',v_CaseId,'MP') ||
  '</managementPlan>' || LF;
  v_Str := v_Str || '   </diagnosis>' || LF;
  
  v_Str := v_Str || '   <diagnosis>' || LF;
  v_Str := v_Str || '        <title>Amputation Status</title>' || LF;
  v_Str := v_Str || '        <value>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
--  v_Str := v_Str || '        <subDiagnosis>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</subDiagnosis>' || LF;
  v_Str := v_Str || '   <subDiagnosis>' || LF;
  v_Str := v_Str || '            <title>Above Knee</title>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData(' PA_Bone_Amputation_Above_Knee ',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '            <managementPlan>' || Matrix_Utils.Get_InfoPathData('PA_Bone_Amputation_Plan_E1                                                  
+ PA_Bone_Amputation_Plan_E2                                                  
+ PA_Bone_Amputation_Plan_E3                                                  
+ PA_Bone_Amputation_Plan_E4                                                  
+ PA_Bone_Amputation_Plan_E5                                                  
+ PA_Bone_Amputation_Plan_M1                                                  
+ PA_Bone_Amputation_Plan_M2                                                  
+ PA_Bone_Amputation_Plan_M3                                                  
+ PA_Bone_Amputation_Plan_R1                                                  
+ PA_Bone_Amputation_Plan_R2                                                  
',v_CaseId,'MP') || '</managementPlan>' || LF;

 -- v_Str := v_Str || '        <subDiagnosis>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</subDiagnosis>' || LF;
  v_Str := v_Str || '   </subDiagnosis>' || LF || '   <subDiagnosis>' || LF;
  v_Str := v_Str || '            <title>Below Knee</title>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData(' PA_Bone_Amputation_Below_Knee ',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '            <managementPlan>' || Matrix_Utils.Get_InfoPathData('PA_Bone_Amputation_Plan_E1                                                  
+ PA_Bone_Amputation_Plan_E2                                                  
+ PA_Bone_Amputation_Plan_E3                                                  
+ PA_Bone_Amputation_Plan_E4                                                  
+ PA_Bone_Amputation_Plan_E5                                                  
+ PA_Bone_Amputation_Plan_M1                                                  
+ PA_Bone_Amputation_Plan_M2                                                  
+ PA_Bone_Amputation_Plan_M3                                                  
+ PA_Bone_Amputation_Plan_R1                                                  
+ PA_Bone_Amputation_Plan_R2                                                  
',v_CaseId,'MP') || '</managementPlan>' || LF;
--  v_Str := v_Str || '            <managementPlan>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'MP') || '</managementPlan>' || LF;
--  v_Str := v_Str || '        <subDiagnosis>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</subDiagnosis>' || LF;
  v_Str := v_Str || '   </subDiagnosis>' || LF || '   <subDiagnosis>' || LF;
  v_Str := v_Str || '            <title>Great Toe</title>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData(' PA_Bone_Amputation_Great_Toe ',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '            <managementPlan>' || Matrix_Utils.Get_InfoPathData('PA_Bone_Amputation_Plan_E1                                                  
+ PA_Bone_Amputation_Plan_E2                                                  
+ PA_Bone_Amputation_Plan_E3                                                  
+ PA_Bone_Amputation_Plan_E4                                                  
+ PA_Bone_Amputation_Plan_E5                                                  
+ PA_Bone_Amputation_Plan_M1                                                  
+ PA_Bone_Amputation_Plan_M2                                                  
+ PA_Bone_Amputation_Plan_M3                                                  
+ PA_Bone_Amputation_Plan_R1                                                  
+ PA_Bone_Amputation_Plan_R2                                                  
',v_CaseId,'MP') || '</managementPlan>' || LF;
   v_Str := v_Str || '   </subDiagnosis>' || LF || '   <subDiagnosis>' || LF; 
--  v_Str := v_Str || '        <subDiagnosis>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</subDiagnosis>' || LF;
  v_Str := v_Str || '            <title>TMA</title>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData(' PA_Bone_Amputation_TMA ',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '            <managementPlan>' || Matrix_Utils.Get_InfoPathData('PA_Bone_Amputation_Plan_E1                                                  
+ PA_Bone_Amputation_Plan_E2                                                  
+ PA_Bone_Amputation_Plan_E3                                                  
+ PA_Bone_Amputation_Plan_E4                                                  
+ PA_Bone_Amputation_Plan_E5                                                  
+ PA_Bone_Amputation_Plan_M1                                                  
+ PA_Bone_Amputation_Plan_M2                                                  
+ PA_Bone_Amputation_Plan_M3                                                  
+ PA_Bone_Amputation_Plan_R1                                                  
+ PA_Bone_Amputation_Plan_R2                                                  
',v_CaseId,'MP') || '</managementPlan>' || LF;
--  v_Str := v_Str || '            <managementPlan>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'MP') || '</managementPlan>' || LF;
--  v_Str := v_Str || '        <subDiagnosis>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</subDiagnosis>' || LF;
  v_Str := v_Str || '   </subDiagnosis>' || LF || '   <subDiagnosis>' || LF;
  v_Str := v_Str || '            <title>Other Toe(s)</title>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData(' PA_Bone_Amputation_Other_Toes ',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '            <managementPlan>' || Matrix_Utils.Get_InfoPathData('PA_Bone_Amputation_Plan_E1                                                  
+ PA_Bone_Amputation_Plan_E2                                                  
+ PA_Bone_Amputation_Plan_E3                                                  
+ PA_Bone_Amputation_Plan_E4                                                  
+ PA_Bone_Amputation_Plan_E5                                                  
+ PA_Bone_Amputation_Plan_M1                                                  
+ PA_Bone_Amputation_Plan_M2                                                  
+ PA_Bone_Amputation_Plan_M3                                                  
+ PA_Bone_Amputation_Plan_R1                                                  
+ PA_Bone_Amputation_Plan_R2                                                  
',v_CaseId,'MP') || '</managementPlan>' || LF;
--  v_Str := v_Str || '            <managementPlan>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'MP') || '</managementPlan>' || LF;
--  v_Str := v_Str || '        <subDiagnosis>' || LF;
  v_Str := v_Str || '   </subDiagnosis>' || LF || '   <subDiagnosis>' || LF;
  v_Str := v_Str || '            <title>Other:</title>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData(' PA_Bone_Amputation_Other ',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '            <followupQuestions>'|| LF;
  v_Str := v_Str || '               <title>Other:</title>' || LF;
  v_Str := v_Str || '               <answer>' || Matrix_Utils.Get_InfoPathData(' PA_Bone_Amputation_Other_Box ',v_CaseId,'ST') || '</answer>' || LF;
  v_Str := v_Str || '               <value>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '            </followupQuestions>'|| LF;
  v_Str := v_Str || '        </subDiagnosis>' || LF;
  v_Str := v_Str || '        <managementPlan>' || Matrix_Utils.Get_InfoPathData('PA_Bone_Amputation_Plan_E1                                                  
+ PA_Bone_Amputation_Plan_E2                                                  
+ PA_Bone_Amputation_Plan_E3                                                  
+ PA_Bone_Amputation_Plan_E4                                                  
+ PA_Bone_Amputation_Plan_E5                                                  
+ PA_Bone_Amputation_Plan_M1                                                  
+ PA_Bone_Amputation_Plan_M2                                                  
+ PA_Bone_Amputation_Plan_M3                                                  
+ PA_Bone_Amputation_Plan_R1                                                  
+ PA_Bone_Amputation_Plan_R2                                                  
',v_CaseId,'MP') || '</managementPlan>' || LF;
  v_Str := v_Str || '   </diagnosis>' || LF;
v_Str := v_Str || '  <diagnosis>' || LF;
  v_Str := v_Str || '        <title>Joint Replacement Status</title>' || LF;
  v_Str := v_Str || '        <value>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'TF') || '</value>' || LF;
--  v_Str := v_Str || '        <subDiagnosis>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</subDiagnosis>' || LF;
  v_Str := v_Str || '   <subDiagnosis>' || LF;
  v_Str := v_Str || '            <title>Knee</title>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData(' PA_Bone_Joint_Knee ',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '            <managementPlan>' || Matrix_Utils.Get_InfoPathData('PA_Bone_Joint_Plan_E1                                                  
+ PA_Bone_Joint_Plan_E2                                                  
+ PA_Bone_Joint_Plan_E3                                                  
+ PA_Bone_Joint_Plan_E4                                                  
+ PA_Bone_Joint_Plan_E5                                                  
+ PA_Bone_Joint_Plan_M1                                                  
+ PA_Bone_Joint_Plan_M2                                                  
+ PA_Bone_Joint_Plan_M3                                                  
+ PA_Bone_Joint_Plan_R1                                                  
+ PA_Bone_Joint_Plan_R2                                                  
',v_CaseId,'MP') || '</managementPlan>' || LF;

--  v_Str := v_Str || '        <subDiagnosis>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</subDiagnosis>' || LF;
  v_Str := v_Str || '   </subDiagnosis>' || LF;
  v_Str := v_Str || '   <subDiagnosis>' || LF;
  v_Str := v_Str || '            <title>Hip</title>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData(' PA_Bone_Joint_Hip ',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '            <managementPlan>' || Matrix_Utils.Get_InfoPathData('PA_Bone_Joint_Plan_E1                                                  
+ PA_Bone_Joint_Plan_E2                                                  
+ PA_Bone_Joint_Plan_E3                                                  
+ PA_Bone_Joint_Plan_E4                                                  
+ PA_Bone_Joint_Plan_E5                                                  
+ PA_Bone_Joint_Plan_M1                                                  
+ PA_Bone_Joint_Plan_M2                                                  
+ PA_Bone_Joint_Plan_M3                                                  
+ PA_Bone_Joint_Plan_R1                                                  
+ PA_Bone_Joint_Plan_R2                                                  
',v_CaseId,'MP') || '</managementPlan>' || LF;
  v_Str := v_Str || '   </subDiagnosis>' || LF;
  v_Str := v_Str || '   <subDiagnosis>' || LF;
  v_Str := v_Str || '            <title>Other:</title>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData(' PA_Bone_Joint_Other ',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '            <followupQuestions>'|| LF;
  v_Str := v_Str || '               <title>Other:</title>' || LF;
  v_Str := v_Str || '               <answer>' || Matrix_Utils.Get_InfoPathData(' PA_Bone_Joint_Other_Box',v_CaseId,'ST') || '</answer>' || LF;
  v_Str := v_Str || '               <value>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '            </followupQuestions>'|| LF;
  v_Str := v_Str || '        </subDiagnosis>' || LF;
  v_Str := v_Str || '        <managementPlan>' || Matrix_Utils.Get_InfoPathData('PA_Bone_Joint_Plan_E1                                                  
+ PA_Bone_Joint_Plan_E2                                                  
+ PA_Bone_Joint_Plan_E3                                                  
+ PA_Bone_Joint_Plan_E4                                                  
+ PA_Bone_Joint_Plan_E5                                                  
+ PA_Bone_Joint_Plan_M1                                                  
+ PA_Bone_Joint_Plan_M2                                                  
+ PA_Bone_Joint_Plan_M3                                                  
+ PA_Bone_Joint_Plan_R1                                                  
+ PA_Bone_Joint_Plan_R2                                                  
',v_CaseId,'MP') || '</managementPlan>' || LF;
 -- v_Str := v_Str || '  </subDiagnosis>' || LF;
  v_Str := v_Str || '  </diagnosis>' || LF;
  v_Str := v_Str || '  <diagnosis>' || LF;
  v_Str := v_Str || '        <title>Gait Disturbance or Abnormality</title>' || LF;
  v_Str := v_Str || '        <value>' || Matrix_Utils.Get_InfoPathData(' PA_Bone_Gait_Disturbance ',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '        <followupQuestions>' || LF;
  v_Str := v_Str || '            <title>Related to a joint problem</title>' || LF;
  v_Str := v_Str || '            <answer>' || Matrix_Utils.Get_InfoPathData(' PA_Bone_Gait_Joint_Problem ',v_CaseId,'ST') || '</answer>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </followupQuestions>'|| LF;
  v_Str := v_Str || '        <managementPlan>' || Matrix_Utils.Get_InfoPathData('PA_Bone_Gait_Plan_E1                                                  
+ PA_Bone_Gait_Plan_E2                                                  
+ PA_Bone_Gait_Plan_E3                                                  
+ PA_Bone_Gait_Plan_E4                                                  
+ PA_Bone_Gait_Plan_E5                                                  
+ PA_Bone_Gait_Plan_M1                                                  
+ PA_Bone_Gait_Plan_M2                                                  
+ PA_Bone_Gait_Plan_M3                                                  
+ PA_Bone_Gait_Plan_R1                                                  
+ PA_Bone_Gait_Plan_R2                                                  
',v_CaseId,'MP') || '</managementPlan>' || LF;
  v_Str := v_Str || '   </diagnosis>' || LF;
  
  v_Str := v_Str || '   <diagnosis>' || LF;
  v_Str := v_Str || '        <title>Other Significant Diagnoses</title>' || LF;
  v_Str := v_Str || '        <value>' || Matrix_Utils.Get_InfoPathData(' PA_Bone_Other ',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '        <followupQuestions>' || LF;
  v_Str := v_Str || '            <title>Other:</title>' || LF;
  v_Str := v_Str || '            <answer>' || Matrix_Utils.Get_InfoPathData(' PA_Bone_Other_Box ',v_CaseId,'ST') || '</answer>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </followupQuestions>'|| LF;
  v_Str := v_Str || '        <managementPlan>' || Matrix_Utils.Get_InfoPathData('PA_Bone_Other_E1                                                  
+ PA_Bone_Other_E2                                                  
+ PA_Bone_Other_E3                                                  
+ PA_Bone_Other_E4                                                  
+ PA_Bone_Other_E5                                                  
+ PA_Bone_Other_M1                                                  
+ PA_Bone_Other_M2                                                  
+ PA_Bone_Other_M3                                                  
+ PA_Bone_Other_R1                                                  
+ PA_Bone_Other_R2                                                  
',v_CaseId,'MP') || '</managementPlan>' || LF;
  v_Str := v_Str || '   </diagnosis>'|| LF;
  v_Str := v_Str || ' </sections>'|| LF;

  v_Str := v_Str || ' <sections>'|| LF;
  v_Str := v_Str || '  <title>Other</title>' || LF;
  v_Str := v_Str || '   <diagnosis>' || LF;
  v_Str := v_Str || '        <title>Legal Blindness</title>' || LF;
  v_Str := v_Str || '        <value>' || Matrix_Utils.Get_InfoPathData(' PA_Other_Legal_Blindness ',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '        <managementPlan>' || Matrix_Utils.Get_InfoPathData('PA_Other_Legal_Blindness_Plan_E1                                                  
+ PA_Other_Legal_Blindness_Plan_E2                                                  
+ PA_Other_Legal_Blindness_Plan_E3                                                  
+ PA_Other_Legal_Blindness_Plan_E4                                                  
+ PA_Other_Legal_Blindness_Plan_E5                                                  
+ PA_Other_Legal_Blindness_Plan_M1                                                  
+ PA_Other_Legal_Blindness_Plan_M2                                                  
+ PA_Other_Legal_Blindness_Plan_M3                                                  
+ PA_Other_Legal_Blindness_Plan_R1                                                  
+ PA_Other_Legal_Blindness_Plan_R2                                                  
',v_CaseId,'MP') || '</managementPlan>' || LF;
  v_Str := v_Str || '   </diagnosis>' || LF;
  
  v_Str := v_Str || '   <diagnosis>' || LF;
  v_Str := v_Str || '        <title>Macular Degeneration</title>' || LF;
  v_Str := v_Str || '        <value>' || Matrix_Utils.Get_InfoPathData(' PA_Other_Macular_Degen ',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '        <managementPlan>' || Matrix_Utils.Get_InfoPathData('PA_Other_Macular_Degen_Plan_E1                                                  
+ PA_Other_Macular_Degen_Plan_E2                                                  
+ PA_Other_Macular_Degen_Plan_E3                                                  
+ PA_Other_Macular_Degen_Plan_E4                                                  
+ PA_Other_Macular_Degen_Plan_E5                                                  
+ PA_Other_Macular_Degen_Plan_M1                                                  
+ PA_Other_Macular_Degen_Plan_M2                                                  
+ PA_Other_Macular_Degen_Plan_M3                                                  
+ PA_Other_Macular_Degen_Plan_R1                                                  
+ PA_Other_Macular_Degen_Plan_R2                                                  
',v_CaseId,'MP') || '</managementPlan>' || LF;
  v_Str := v_Str || '   </diagnosis>' || LF;
  
  v_Str := v_Str || '   <diagnosis>' || LF;
  v_Str := v_Str || '        <title>Glaucoma</title>' || LF;
  v_Str := v_Str || '        <value>' || Matrix_Utils.Get_InfoPathData(' PA_Other_Glaucoma ',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '        <managementPlan>' || Matrix_Utils.Get_InfoPathData('PA_Other_Glaucoma_Plan_E1                                                  
+ PA_Other_Glaucoma_Plan_E2                                                  
+ PA_Other_Glaucoma_Plan_E3                                                  
+ PA_Other_Glaucoma_Plan_E4                                                  
+ PA_Other_Glaucoma_Plan_E5                                                  
+ PA_Other_Glaucoma_Plan_M1                                                  
+ PA_Other_Glaucoma_Plan_M2                                                  
+ PA_Other_Glaucoma_Plan_M3                                                  
+ PA_Other_Glaucoma_Plan_R1                                                  
+ PA_Other_Glaucoma_Plan_R2                                                  
',v_CaseId,'MP') || '</managementPlan>' || LF;
  v_Str := v_Str || '   </diagnosis>' || LF;
  
  v_Str := v_Str || '   <diagnosis>' || LF;
  v_Str := v_Str || '        <title>Hearing Impairment/Deafness</title>' || LF;
  v_Str := v_Str || '        <value>' || Matrix_Utils.Get_InfoPathData(' PA_Other_Hearing_Impairment ',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '        <managementPlan>' || Matrix_Utils.Get_InfoPathData('PA_Other_Hearing_Impairment_Plan_E1                                                  
+ PA_Other_Hearing_Impairment_Plan_E2                                                  
+ PA_Other_Hearing_Impairment_Plan_E3                                                  
+ PA_Other_Hearing_Impairment_Plan_E4                                                  
+ PA_Other_Hearing_Impairment_Plan_E5                                                  
+ PA_Other_Hearing_Impairment_Plan_M1                                                  
+ PA_Other_Hearing_Impairment_Plan_M2                                                  
+ PA_Other_Hearing_Impairment_Plan_M3                                                  
+ PA_Other_Hearing_Impairment_Plan_R1                                                  
+ PA_Other_Hearing_Impairment_Plan_R2                                                  
',v_CaseId,'MP') || '</managementPlan>' ||   LF;
  v_Str := v_Str || '   </diagnosis>' || LF;
  
  v_Str := v_Str || '   <diagnosis>' || LF;
  v_Str := v_Str || '        <title>HIV Infection with Symptoms</title>' || LF;
  v_Str := v_Str || '        <value>' || Matrix_Utils.Get_InfoPathData(' PA_Other_HIV ',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '        <managementPlan>' || Matrix_Utils.Get_InfoPathData('PA_Other_HIV_Plan_E1                                                  
+ PA_Other_HIV_Plan_E2                                                  
+ PA_Other_HIV_Plan_E3                                                  
+ PA_Other_HIV_Plan_E4                                                  
+ PA_Other_HIV_Plan_E5                                                  
+ PA_Other_HIV_Plan_M1                                                  
+ PA_Other_HIV_Plan_M2                                                  
+ PA_Other_HIV_Plan_M3                                                  
+ PA_Other_HIV_Plan_R1                                                  
+ PA_Other_HIV_Plan_R2                                                  
',v_CaseId,'MP')     || '</managementPlan>' || LF;
  v_Str := v_Str || '   </diagnosis>' || LF;
  
  v_Str := v_Str || '   <diagnosis>' || LF;
  v_Str := v_Str || '        <title>Asymptomatic HIV Infection Status</title>' || LF;
  v_Str := v_Str || '        <value>' || Matrix_Utils.Get_InfoPathData(' PA_Other_Asymptomatic_HIV ',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '        <managementPlan>' || Matrix_Utils.Get_InfoPathData('PA_Other_Asymptomatic_HIV_Plan_E1                                                  
+ PA_Other_Asymptomatic_HIV_Plan_E2                                                  
+ PA_Other_Asymptomatic_HIV_Plan_E3                                                  
+ PA_Other_Asymptomatic_HIV_Plan_E4                                                  
+ PA_Other_Asymptomatic_HIV_Plan_E5                                                  
+ PA_Other_Asymptomatic_HIV_Plan_M1                                                  
+ PA_Other_Asymptomatic_HIV_Plan_M2                                                  
+ PA_Other_Asymptomatic_HIV_Plan_M3                                                  
+ PA_Other_Asymptomatic_HIV_Plan_R1                                                  
+ PA_Other_Asymptomatic_HIV_Plan_R2                                                  
',v_CaseId,'MP') || '</managementPlan>' || LF;
  v_Str := v_Str || '   </diagnosis>' || LF;
  
  v_Str := v_Str || '   <diagnosis>' || LF;
  v_Str := v_Str || '        <title>Other significant diagnoses:</title>' || LF;
  v_Str := v_Str || '        <value>' || Matrix_Utils.Get_InfoPathData(' PA_Other_Other ',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '        <followupQuestions>' || LF;
  v_Str := v_Str || '            <title>Other:</title>' || LF;
  v_Str := v_Str || '            <answer>' || Matrix_Utils.Get_InfoPathData(' PA_Other_Other_Box',v_CaseId,'ST') || '</answer>' || LF;
  v_Str := v_Str || '            <value>' || Matrix_Utils.Get_InfoPathData('',v_CaseId,'ST') || '</value>' || LF;
  v_Str := v_Str || '        </followupQuestions>'|| LF;
  v_Str := v_Str || '        <managementPlan>' || Matrix_Utils.Get_InfoPathData('PA_Other_Other_Plan_E1                                                  
+ PA_Other_Other_Plan_E2                                                  
+ PA_Other_Other_Plan_E3                                                  
+ PA_Other_Other_Plan_E4                                                  
+ PA_Other_Other_Plan_E5                                                  
+ PA_Other_Other_Plan_M1                                                  
+ PA_Other_Other_Plan_M2                                                  
+ PA_Other_Other_Plan_M3                                                  
+ PA_Other_Other_Plan_R1                                                  
+ PA_Other_Other_Plan_R2                                                  
',v_CaseId,'MP') 
               ||    '</managementPlan>' || LF;
v_Str := v_Str || '  </diagnosis>' || LF;
v_Str := v_Str || ' </sections>' || LF;
v_Str := v_Str || '</ProviderAssessment>' || LF;
  ------------------------------------
  RETURN v_Str;
EXCEPTION
WHEN OTHERS THEN
  v_Str := SUBSTR(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || CHR(13) || SQLERRM,1,4000);
  RAISE;
END MATRIX_XML_PROVASSMT;






FUNCTION MATRIX_XML_SIGNATURE(
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
  v_Str := v_Str || '  <Signatures>' || LF;
  v_Str := v_Str || '   <reviewers>' || LF;
  v_Str := v_Str || '        <type>PROVIDER</type>' || LF;
  v_Str := v_Str || '        <friendlyType>Provider</friendlyType>' || LF;
  v_Str := v_Str || '        <dateOfService>' || Matrix_Utils.Get_InfoPathData('Name_Sig_Provider_date',v_CaseId,'DT') || '</dateOfService>' || LF;
 -- v_Str := v_Str || '        <printedName>' || Matrix_Utils.Get_InfoPathData('Name_Sig_Provider_Name',v_CaseId,'ST') || '</printedName>' || LF;
  v_Str := v_Str || '        <signature64>' || '</signature64>' || LF;   -- leave as null for now
  
  v_Str := v_Str || '        <credentials>' || LF;
  v_Str := v_Str || '          <title>MD</title>' || LF;
  v_Str := v_Str || '          <value>' || Matrix_Utils.Get_InfoPathData('Name_Sig_Provider_MD',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '        </credentials>' || LF;
  
  v_Str := v_Str || '        <credentials>' || LF;
  v_Str := v_Str || '          <title>DO</title>' || LF;
  v_Str := v_Str || '          <value>' || Matrix_Utils.Get_InfoPathData('Name_Sig_Provider_DO',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '        </credentials>' || LF;
  
  v_Str := v_Str || '        <credentials>' || LF;
  v_Str := v_Str || '          <title>NP</title>' || LF;
  v_Str := v_Str || '          <value>' || Matrix_Utils.Get_InfoPathData('Name_Sig_Provider_NP',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '        </credentials>' || LF;
  
  v_Str := v_Str || '        <credentials>' || LF;
  v_Str := v_Str || '          <title>PA</title>' || LF;
  v_Str := v_Str || '          <value>' || Matrix_Utils.Get_InfoPathData('Name_Sig_Provider_PA',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '        </credentials>' || LF;
  v_Str := v_Str || '   </reviewers>' || LF;


  v_Str := v_Str || '   <reviewers>' || LF;
  v_Str := v_Str || '        <type>COSIGNINGPROVIDER</type>' || LF;
  v_Str := v_Str || '        <friendlyType>Provider</friendlyType>' || LF;
  v_Str := v_Str || '        <dateOfService>' || Matrix_Utils.Get_InfoPathData('Name_Sig_Co_Signing_Provider_date',v_CaseId,'DT') || '</dateOfService>' || LF;
 -- v_Str := v_Str || '        <printedName>' || Matrix_Utils.Get_InfoPathData('Name_Sig_Co_Signing_Provider_Name',v_CaseId,'ST') || '</printedName>' || LF;
  v_Str := v_Str || '        <signature64>' || '</signature64>' || LF;   -- leave as null for now
  
  v_Str := v_Str || '        <credentials>' || LF;
  v_Str := v_Str || '          <title>MD</title>' || LF;
  v_Str := v_Str || '          <value>' || Matrix_Utils.Get_InfoPathData('Name_Sig_Provider_MD',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '        </credentials>' || LF;
  
  v_Str := v_Str || '        <credentials>' || LF;
  v_Str := v_Str || '          <title>DO</title>' || LF;
  v_Str := v_Str || '          <value>' || Matrix_Utils.Get_InfoPathData('Name_Sig_Provider_DO',v_CaseId,'TF') || '</value>' || LF;
  v_Str := v_Str || '        </credentials>' || LF;
  
  v_Str := v_Str || '   </reviewers>' || LF;

--- QA and Coder reviewers have been dropped from the XML requirements  
  v_Str := v_Str || '  </Signatures>' || LF;
  ------------------------------------
  RETURN v_Str;
EXCEPTION
WHEN OTHERS THEN
  v_Str := SUBSTR(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || CHR(13) || SQLERRM,1,4000);
  RAISE;
END MATRIX_XML_SIGNATURE;



END MATRIX_UTILS;