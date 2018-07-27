--------------------------------------------------------
--  DDL for Function BATCHINFO_FROM_CASEID
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SNX_IWS2"."BATCHINFO_FROM_CASEID" 
  (P_CASEID in NUMBER,
   P_FORMAT in VARCHAR2 default 'BATCHID' )  -- BATCHID/RECEIVEDZIPFILENAME 
    
    -- Created 11-16-2012 R Benzell
    -- Used by Apex Bulk Assignment Screen 340, because BatchInfo cannot be display via JOIN.
    -- to test:  select  BATCHINFO_FROM_CASEID(2365) from dual;
    -- Update History
    -- 
    
    
return VARCHAR2
    
As 

    v_Return VARCHAR2(255);

begin

CASE
    
 WHEN  P_FORMAT= 'BATCHID' THEN
   BEGIN
     SELECT B.BATCHID 
       into v_Return
    from BATCHPAYLOAD B,
         CLIENTZIPBATCHES Z
    where caseid = P_CASEID
        AND Z.BATCHID = B.BATCHID
        AND ROWNUM=1;
   EXCEPTION WHEN OTHERS THEN v_Return := null;
   END;

 WHEN  P_FORMAT= 'RECEIVEDZIPFILENAME' THEN
   BEGIN
     SELECT Z.RECEIVEDZIPFILENAME 
       into v_Return
    from BATCHPAYLOAD B,
         CLIENTZIPBATCHES Z
    where caseid = P_CASEID
        AND Z.BATCHID = B.BATCHID
        AND ROWNUM=1;
   EXCEPTION WHEN OTHERS THEN v_Return := null;
   END;

 ELSE NULL;

END CASE;


RETURN v_Return;

end;

/

