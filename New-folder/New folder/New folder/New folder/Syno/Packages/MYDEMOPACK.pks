--------------------------------------------------------
--  DDL for Package MYDEMOPACK
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "SNX_IWS2"."MYDEMOPACK" 
AS
      FUNCTION prodFunc RETURN myTableType PIPELINED;
END;

/

