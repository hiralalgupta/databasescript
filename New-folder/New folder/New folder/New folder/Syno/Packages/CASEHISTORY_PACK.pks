  CREATE OR REPLACE PACKAGE "SNX_IWS2"."CASEHISTORY_PACK" 
 -- To test:
 -- SELECT * FROM TABLE(CASEHISTORY_PACK.CASEHISTORY_FUNC()); 
    
AS
      FUNCTION CASEHISTORY_FUNC RETURN CASEHISTORY_TYPE PIPELINED;
END;

/

