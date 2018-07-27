--------------------------------------------------------
--  DDL for Function CASE_OPPORTUNITY_COUNT
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SNX_IWS2"."CASE_OPPORTUNITY_COUNT" 
    (P_CASEID NUMBER default null )
    
    -- Created 11-14-2012 R Benzell
    -- Counts the number of Fields for a DataPoint that have entry values
    -- For the entire case
/** to test    
    select CASE_OPPORTUNITY_COUNT(2047) from dual
**/    
    

    
        RETURN number
    
        IS
    
        v_Count number default 0;

       BEGIN

          for A in
           ( SELECT  FINALPAGENUMBER,
          SECTIONNUMBER,
          CODENAME,
          DATADATE,
          DATAFIELD1VALUE,
          DATAFIELD2VALUE,
          DATAFIELD3VALUE,
          DATAFIELD4VALUE,    
          DATAFIELD5VALUE,    
          DATAFIELD6VALUE,
          DATAFIELD7VALUE,
          DATAFIELD8VALUE,
          DATAFIELD9VALUE,    
          DATAFIELD10VALUE,
          DATAFIELD11VALUE,
          DATAFIELD12VALUE
             from DPENTRYPAGES_VIEW
               WHERE CASEID = P_CASEID)
          LOOP
           

         IF A.FINALPAGENUMBER is not null THEN v_Count := v_count+1; END IF;
         IF A.SECTIONNUMBER   is not null THEN v_Count := v_count+1; END IF;
         IF A.CODENAME        is not null THEN v_Count := v_count+1; END IF;
         IF A.DATADATE        is not null THEN v_Count := v_count+1; END IF;
         IF A.DATAFIELD1VALUE is not null THEN v_Count := v_count+1; END IF;
         IF A.DATAFIELD2VALUE is not null THEN v_Count := v_count+1; END IF;
         IF A.DATAFIELD3VALUE is not null THEN v_Count := v_count+1; END IF;
         IF A.DATAFIELD4VALUE is not null THEN v_Count := v_count+1; END IF;
         IF A.DATAFIELD5VALUE is not null THEN v_Count := v_count+1; END IF;
         IF A.DATAFIELD6VALUE is not null THEN v_Count := v_count+1; END IF;
         IF A.DATAFIELD7VALUE is not null THEN v_Count := v_count+1; END IF;
         IF A.DATAFIELD8VALUE is not null THEN v_Count := v_count+1; END IF;
         IF A.DATAFIELD9VALUE is not null THEN v_Count := v_count+1; END IF;
         IF A.DATAFIELD10VALUE is not null THEN v_Count := v_count+1; END IF;
         IF A.DATAFIELD11VALUE is not null THEN v_Count := v_count+1; END IF;
         IF A.DATAFIELD12VALUE is not null THEN v_Count := v_count+1; END IF;

         END LOOP;
 
         return v_Count;
       
      END;

/

