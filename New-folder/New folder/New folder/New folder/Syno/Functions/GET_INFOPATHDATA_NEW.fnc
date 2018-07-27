--------------------------------------------------------
--  DDL for Function GET_INFOPATHDATA_NEW
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SNX_IWS2"."GET_INFOPATHDATA_NEW" (
      P_NODENAME VARCHAR2 DEFAULT NULL,
      P_CASEID   NUMBER DEFAULT NULL,
      P_FORMAT   VARCHAR2 DEFAULT 'ST') --ST=String, DT=Date, TF=true/false, YN=yes/no, MF=male/female, MP=management plan
    -- Created 10-6-2012 R Benzell
    -- called by ClientXMLgenerator
    -- Updated
    -- 10-13-2011 R Benzell
    -- to Test:  select GET_INFOPATHDATA_NEW('GET_INFOPATHDATA_NEW1,4,3,'DEV') from dual
    RETURN VARCHAR2
  IS
    v_Return   VARCHAR2(1000);
    v_Value    VARCHAR2(1000);
    v_Format   VARCHAR2(2);
    v_NodeName VARCHAR2(8000);
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
    -----------------------------------------------------------------------------------
    --- Parse line based on "+" character
    -----------------------------------------------------------------------------------
    PARM_Arr2 := HTMLDB_UTIL.STRING_TO_TABLE(trim( REPLACE(P_NodeName,chr(10),'') ),'+');
    FOR J     IN 1..PARM_arr2.count
    LOOP
      v_NodeName := trim(upper(PARM_arr2(J)));
      --- If multi-parm, but type string, convert to CT (concatenate)
      IF PARM_arr2.count >= 2 AND P_FORMAT = 'ST' THEN
        v_Format         := 'CT';
      ELSE
        v_Format := P_FORMAT;
      END IF;
      --htp.p(J||' - ' || P_NodeName || ': ' || v_format || ' - ' || v_value ||' - ' || v_return);
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
          v_value              := SUBSTR(v_value,6,2) || '/' || SUBSTR(v_value,9,2) || '/' || SUBSTR(v_value,1,4) ;
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
          v_Value := NULL;
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
      WHEN v_FORMAT='MP' AND v_Value='true' THEN
        v_Return  := v_Return || regexp_substr(v_NODENAME,'[^_]+', 1, length(regexp_replace(v_NODENAME,'[^_]',''))+1) || ',';
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
  END;

/

