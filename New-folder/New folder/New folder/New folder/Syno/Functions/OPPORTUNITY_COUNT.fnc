--------------------------------------------------------
--  DDL for Function OPPORTUNITY_COUNT
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SNX_IWS2"."OPPORTUNITY_COUNT" 
    (P_FINALPAGENUMBER NUMBER default null,
     P_SECTIONNUMBER NUMBER default null,
     P_CODENAME VARCHAR2 default null,
     P_DATADATE DATE default null,
     P_DATAFIELD1VALUE VARCHAR2 default null,
     P_DATAFIELD2VALUE VARCHAR2 default null,
     P_DATAFIELD3VALUE VARCHAR2 default null,
     P_DATAFIELD4VALUE VARCHAR2 default null,    
     P_DATAFIELD5VALUE VARCHAR2 default null,    
     P_DATAFIELD6VALUE VARCHAR2 default null,
     P_DATAFIELD7VALUE VARCHAR2 default null,
     P_DATAFIELD8VALUE VARCHAR2 default null,
     P_DATAFIELD9VALUE VARCHAR2 default null,    
     P_DATAFIELD10VALUE VARCHAR2 default null,
     P_DATAFIELD11VALUE VARCHAR2 default null,
     P_DATAFIELD12VALUE VARCHAR2 default null )
    
    -- Created 11-7-2012 R Benzell
    -- Counts the number of Fields for a DataPoint that have entry values
    -- Fields are passed as parameters 
/** to test    
    select OPPORTUNITY_COUNT(2,3) from dual
     select OPPORTUNITY_COUNT(2,3,'xxx',sysdate,'123') from dual
**/    
    

    
        RETURN number
    
        IS
    
        v_Count number default 0;

       BEGIN

         IF P_FINALPAGENUMBER is not null THEN v_Count := v_count+1; END IF;
         IF P_SECTIONNUMBER   is not null THEN v_Count := v_count+1; END IF;
         IF P_CODENAME        is not null THEN v_Count := v_count+1; END IF;
         IF P_DATADATE        is not null THEN v_Count := v_count+1; END IF;
         IF P_DATAFIELD1VALUE is not null THEN v_Count := v_count+1; END IF;
         IF P_DATAFIELD2VALUE is not null THEN v_Count := v_count+1; END IF;
         IF P_DATAFIELD3VALUE is not null THEN v_Count := v_count+1; END IF;
         IF P_DATAFIELD4VALUE is not null THEN v_Count := v_count+1; END IF;
         IF P_DATAFIELD5VALUE is not null THEN v_Count := v_count+1; END IF;
         IF P_DATAFIELD6VALUE is not null THEN v_Count := v_count+1; END IF;
         IF P_DATAFIELD7VALUE is not null THEN v_Count := v_count+1; END IF;
         IF P_DATAFIELD8VALUE is not null THEN v_Count := v_count+1; END IF;
         IF P_DATAFIELD9VALUE is not null THEN v_Count := v_count+1; END IF;
         IF P_DATAFIELD10VALUE is not null THEN v_Count := v_count+1; END IF;
         IF P_DATAFIELD11VALUE is not null THEN v_Count := v_count+1; END IF;
         IF P_DATAFIELD12VALUE is not null THEN v_Count := v_count+1; END IF;
       
 
         return v_Count;
       
      END;

/

