--------------------------------------------------------
--  DDL for Function DISPLAY_DP_FORMENTITIES
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SNX_IWS2"."DISPLAY_DP_FORMENTITIES" 
    (P_DPCATEGORYID  number default null,  
     P_DPSUBCATID number default null)
    
    -- Created 10-23-2011 R Benzell
    -- to test:  select DISPLAY_DP_FORMENTITIES(28)from dual;
    
    
        RETURN VARCHAR2
    
        IS
    
       v_Return varchar2(32000);
       I  Number;
     
       BEGIN
            
       --v_Name := P_NAME;    
       I := 0;
    
    IF P_DPSUBCATID is NULL then
    -------------------------------------------
       BEGIN
          for A in
           ( 
            select DISPLAYLABEL 
              from dpformentities
               where  DPCATEGORYID = P_DPCATEGORYID
             )
            LOOP
                I := I + 1;
                IF I = 1
                 then v_Return :=  A.DISPLAYLABEL   ;  -- Don't need Delim on first value
                 else v_Return := v_Return  || ', ' || A.DISPLAYLABEL  ;
              END IF;
            END LOOP;
           
        EXCEPTION WHEN OTHERS THEN 
             v_Return := null;
        END;
     ---------------------------------------------------
      ELSE
       BEGIN
          for A in
           (
            select DISPLAYLABEL
              from dpformentities
               where  DPCATEGORYID = P_DPCATEGORYID AND
                      DPSUBCATID = P_DPSUBCATID 
             )
            LOOP
                I := I + 1;
                IF I = 1
                 then v_Return :=  A.DISPLAYLABEL   ;  -- Don't need Delim on first value
                 else v_Return := v_Return  || ', ' || A.DISPLAYLABEL  ;
              END IF;
            END LOOP;
           
        EXCEPTION WHEN OTHERS THEN
             v_Return := null;
        END;
       -------------------------------------------------------------


      END IF;
    
 
         return v_Return;
       
      END;

/

