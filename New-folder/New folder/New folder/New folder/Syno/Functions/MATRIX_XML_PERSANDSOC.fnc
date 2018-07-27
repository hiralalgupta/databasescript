--------------------------------------------------------
--  DDL for Function MATRIX_XML_PERSANDSOC
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SNX_IWS2"."MATRIX_XML_PERSANDSOC" (
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
    v_Str := v_Str || '   <maritalStatus>' || Get_InfoPathData('Personal_Social_Marital_Status',v_CaseId,'ST') || '</maritalStatus>' || LF;
    v_Str := v_Str || '   <occupation>' || Get_InfoPathData('Personal_Social_History_Occup',v_CaseId,'ST') || '</occupation>' || LF;
    v_Str := v_Str || '   <retired>' || Get_InfoPathData('Personal_Social_History_Retired',v_CaseId,'TF') || '</retired>' || LF;
    v_Str := v_Str || '   <livingWith>' || Get_InfoPathData('Personal_Live_Alone+Personal_Live_With_Spouse+Personal_Live_Children+Personal_Live_Other_Adults+Personal_Live_Full_Time_Facility',v_CaseId,'ST') || '</livingWith>' || LF;
    v_Str := v_Str || '   <help>' || LF;
    v_Str := v_Str || '     <title>Who would you turn to for help if you had problems (with health, transporation, etc)?</title>' || LF;
    v_Str := v_Str || '     <value></value>' || LF;
    v_Str := v_Str || '     <questions>' || LF;
    v_Str := v_Str || '         <title>Rely On Self</title>' || LF;
    v_Str := v_Str || '         <value>' || Get_InfoPathData('Personal_Help_Self',v_CaseId,'TF') || '</value>' || LF;
    v_Str := v_Str || '     </questions>' || LF;
    v_Str := v_Str || '     <questions>' || LF;
    v_Str := v_Str || '         <title>Spouse/Partner</title>' || LF;
    v_Str := v_Str || '         <value>' || Get_InfoPathData('Personal_Help_Spouse',v_CaseId,'TF') || '</value>' || LF;
    v_Str := v_Str || '     </questions>' || LF;
    v_Str := v_Str || '     <questions>' || LF;
    v_Str := v_Str || '         <title>Children</title>' || LF;
    v_Str := v_Str || '         <value>' || Get_InfoPathData('Personal_Help_Children',v_CaseId,'TF') || '</value>' || LF;
    v_Str := v_Str || '     </questions>' || LF;
    v_Str := v_Str || '     <questions>' || LF;
    v_Str := v_Str || '         <title>Other adult/sibling</title>' || LF;
    v_Str := v_Str || '         <value>' || Get_InfoPathData('Personal_Help_Other_Adult',v_CaseId,'TF') || '</value>' || LF;
    v_Str := v_Str || '     </questions>' || LF;
    v_Str := v_Str || '     <questions>' || LF;
    v_Str := v_Str || '         <title>Other</title>' || LF;
    v_Str := v_Str || '         <value>' || Get_InfoPathData('Personal_Help_Other',v_CaseId,'TF') || '</value>' || LF;
    v_Str := v_Str || '             <extraData>' || LF;
    v_Str := v_Str || '                  <title>Other</title>' || LF;
    v_Str := v_Str || '                  <value>' || Get_InfoPathData('Personal_Help_Other_Box',v_CaseId,'ST') || '</value>' || LF;
    v_Str := v_Str || '             </extraData>' || LF;
    v_Str := v_Str || '     </questions>' || LF;
    v_Str := v_Str || '   </help>' || LF;
    v_Str := v_Str || '   <houseSafty>' || LF;
    v_Str := v_Str || '    <title></title>' || LF;
    v_Str := v_Str || '    <value></value>' || LF;
    v_Str := v_Str || '    <secondaryQuestions>' || LF;
    v_Str := v_Str || '        <title>Do you feel safe in your home?</title>' || LF;
    v_Str := v_Str || '        <value>' || Get_InfoPathData('Personal_Safe',v_CaseId,'TF') || '</value>' || LF;
    v_Str := v_Str || '        <secondaryQuestions>' || LF;
    v_Str := v_Str || '           <title>Are you being abused by your partner or someone important to you?</title>' || LF;
    v_Str := v_Str || '           <value>' || Get_InfoPathData('Personal_Abused',v_CaseId,'TF') || '</value>' || LF;
    v_Str := v_Str || '        </secondaryQuestions>' || LF;
    v_Str := v_Str || '        <secondaryQuestions>' || LF;
    v_Str := v_Str || '           <title>Within the past 12 months have you been hit, slapped, pushed or otherwise hurt by someone?</title>' || LF;
    v_Str := v_Str || '           <value>' || Get_InfoPathData('Personal_Hit',v_CaseId,'TF') || '</value>' || LF;
    v_Str := v_Str || '        </secondaryQuestions>' || LF;
    v_Str := v_Str || '     </secondaryQuestions>' || LF;
    v_Str := v_Str || '   </houseSafty>' || LF;
    v_Str := v_Str || '   <communityMobility>' || LF;
    v_Str := v_Str || '        <groupTitle>How do you get around the community?</groupTitle>' || LF;
    v_Str := v_Str || '        <groupDesc></groupDesc>' || LF;
    v_Str := v_Str || '        <questions>' || LF;
    v_Str := v_Str || '         <title>Independent</title>' || LF;
    v_Str := v_Str || '         <value>' || Get_InfoPathData('Personal_Get_Around_Independent',v_CaseId,'TF') || '</value>' || LF;
    v_Str := v_Str || '        </questions>' || LF;
    v_Str := v_Str || '        <questions>' || LF;
    v_Str := v_Str || '         <title>With Assistance</title>' || LF;
    v_Str := v_Str || '         <value>' || Get_InfoPathData('Personal_Get_Around_Assistance',v_CaseId,'TF') || '</value>' || LF;
    v_Str := v_Str || '        </questions>' || LF;
    v_Str := v_Str || '        <questions>' || LF;
    v_Str := v_Str || '         <title>Homebound</title>' || LF;
    v_Str := v_Str || '         <value>' || Get_InfoPathData('Personal_Get_Around_Homeland',v_CaseId,'TF') || '</value>' || LF;
    v_Str := v_Str || '        </questions>' || LF;
    v_Str := v_Str || '   </communityMobility>' || LF;
    v_Str := v_Str || '   <spendTimeAlone>' || LF;
    v_Str := v_Str || '    <title>Do you feel you spend too much time alone?</title>' || LF;
    v_Str := v_Str || '    <value>' || Get_InfoPathData('Personal_Alone',v_CaseId,'TF') || '</value>' || LF;
    v_Str := v_Str || '   </spendTimeAlone>' || LF;
    v_Str := v_Str || '</PersonalAndSocial>' || LF;
    ------------------------------------
    RETURN v_Str;
  EXCEPTION
  WHEN OTHERS THEN
    v_Str := SUBSTR(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || CHR(13) || SQLERRM,1,4000);
  END;

/

