--------------------------------------------------------
--  DDL for Function MATRIX_XML_NUTRIHEALTH
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SNX_IWS2"."MATRIX_XML_NUTRIHEALTH" 
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

v_Str := v_Str || '<NutritionalHealth>' || LF;

v_Str := v_Str || '   <total>' ||  Get_InfoPathData('Nutri_Check_Score',v_CaseId,'ST') || '</total>'  || LF;

v_Str := v_Str || '   <questions>' || LF;
v_Str := v_Str || '        <title>Changed food due to illness or condition</title>'  || LF;
v_Str := v_Str || '        <value>' ||  Get_InfoPathData('Nutri_Check_Ill_No+ Nutri_Check_Ill_Yes',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '   </questions>' || LF;
v_Str := v_Str || '   <questions>' || LF;
v_Str := v_Str || '        <title>Eat fewer than 2 meals per day</title>'  || LF;
v_Str := v_Str || '        <value>' ||  Get_InfoPathData('Nutri_Check_Meals_No+ Nutri_Check_Meals_Yes++',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '   </questions>' || LF;
v_Str := v_Str || '   <questions>' || LF;
v_Str := v_Str || '        <title>Eat few fruits, veggies, or milk products</title>'  || LF;
v_Str := v_Str || '        <value>' ||  Get_InfoPathData('Nutri_Check_Few_No+ Nutri_Check_Few_Yes',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '   </questions>' || LF;
v_Str := v_Str || '   <questions>' || LF;
v_Str := v_Str || '        <title>3 or more drinks of beer, liquor, wine daily</title>'  || LF;
v_Str := v_Str || '        <value>' ||  Get_InfoPathData('Nutri_Check_Drinks_No+ Nutri_Check_Drinks_Yes',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '   </questions>' || LF;
v_Str := v_Str || '   <questions>' || LF;
v_Str := v_Str || '        <title>Tooth or mouth problem</title>'  || LF;
v_Str := v_Str || '        <value>' ||  Get_InfoPathData('Nutri_Check_Tooth_No+ Nutri_Check_Tooth_Yes',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '   </questions>' || LF;
v_Str := v_Str || '   <questions>' || LF;
v_Str := v_Str || '        <title>Not enough money to buy food</title>'  || LF;
v_Str := v_Str || '        <value>' ||  Get_InfoPathData('Nutri_Check_Money_No+ Nutri_Check_Money_Yes',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '   </questions>' || LF;
v_Str := v_Str || '   <questions>' || LF;
v_Str := v_Str || '        <title>Eat alone</title>'  || LF;
v_Str := v_Str || '        <value>' ||  Get_InfoPathData('Nutri_Check_Alone_No+ Nutri_Check_Alone_Yes',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '   </questions>' || LF;
v_Str := v_Str || '   <questions>' || LF;
v_Str := v_Str || '        <title>3 or more drugs per day</title>'  || LF;
v_Str := v_Str || '        <value>' ||  Get_InfoPathData('Nutri_Check_Drugs_No+ Nutri_Check_Drugs_Yes++++',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '   </questions>' || LF;
v_Str := v_Str || '   <questions>' || LF;
v_Str := v_Str || '        <title>Weight Change of 10 lbs in 6 months</title>'  || LF;
v_Str := v_Str || '        <value>' ||  Get_InfoPathData('Nutri_Check_Weight_Change_No+ Nutri_Check_Weight_Change_Yes+',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '   </questions>' || LF;
v_Str := v_Str || '   <questions>' || LF;
v_Str := v_Str || '        <title>Not always able to shop, cook or feed themselves</title>'  || LF;
v_Str := v_Str || '        <value>' ||  Get_InfoPathData('Nutri_Check_Shop_No+ Nutri_Check_Shop_Yes+',v_CaseId,'ST') || '</value>'  || LF;
v_Str := v_Str || '   </questions>' || LF;

v_Str := v_Str || '</NutritionalHealth>' || LF;
------------------------------------


       RETURN v_Str;
       
       EXCEPTION WHEN OTHERS THEN
            v_Str := SUBSTR(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
                              CHR(13) ||
                              SQLERRM,1,4000); 
           
       END;

/

