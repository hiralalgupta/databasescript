--------------------------------------------------------
--  DDL for Function GET_INFOPATHDATA_MP
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SNX_IWS2"."GET_INFOPATHDATA_MP" (

    P_NODENAME VARCHAR2 DEFAULT NULL,
    P_CASEID   NUMBER DEFAULT 777,
    P_FORMAT   VARCHAR2 DEFAULT 'MP') --ST=String, DT=Date, TF=true/false, YN=yes/no, MF=male/female, MP=management plan, 01= 01 Boolean
                                      -- BPS/BPD  Blood pressure Systolic/Diastolic
                                      --
  
/**- 10-22-2012 added 0/1 Boolean
  -- to Test:  select GET_INFOPATHDATA_MP('GET_INFOPATHDATA_NEW1,4,3,'DEV') from dual
  set serveroutput on;
   select Get_InfoPathData('PA_Neuro_Aphasia_Plan_E1
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
  v_Format   VARCHAR2(5);
  v_PlanType varchar2(2);
  v_NodeName VARCHAR2(8000);
  v_TrimNode VARCHAR2(8000);
  J          INTEGER;
  PARM_Arr2 HTMLDB_APPLICATION_GLOBAL.VC_ARR2;
BEGIN
  --- Initialize Flags that might be used
  IF P_Format = 'TF' THEN
    v_Return :='false';
  END IF;
  IF P_Format = 'YN' THEN
    v_Return :='no';
  END IF;
  IF P_Format = '01' THEN
    v_Return :='0';
  END IF;
  -----------------------------------------------------------------------------------
  --- Parse line based on "+" character
  -----------------------------------------------------------------------------------
  --- Drop CR/LF and spaces
   v_TrimNode := trim(REPLACE(P_NodeName,chr(10),''));
   v_TrimNode := REPLACE(v_TrimNode,chr(13),'');
   v_TrimNode := REPLACE(v_TrimNode,' ','');
   dbms_output.put_line('>>>'||v_TrimNode||'<<<');

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
    CASE
      --- Date - convert YYYY-MM-DD to MM/DD/YYYY
    WHEN P_FORMAT='DT' THEN
      BEGIN
        SELECT trim(NODEVALUE)
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
        SELECT trim(NODEVALUE)
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
       
       --- Blood Pressure Systolic/diastlic
    WHEN P_FORMAT='BPS' AND v_value is not null THEN
        v_RETURN := trim(substr(v_value,1,instr(v_value,'/')-1));

    WHEN P_FORMAT='BPD' AND v_value is not null THEN
        v_RETURN := trim(substr(v_value,instr(v_value,'/')+1));

      
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
  v_Return := SUBSTR(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || CHR(13) || SQLERRM,1,4000);
  RAISE;
END ;

/

