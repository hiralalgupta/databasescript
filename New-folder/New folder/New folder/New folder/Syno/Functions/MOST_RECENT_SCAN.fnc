--------------------------------------------------------
--  DDL for Function MOST_RECENT_SCAN
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SNX_IWS2"."MOST_RECENT_SCAN" 
    -- Created 9-21-2011 R Benzell
    -- Returns the Image Number of the most recent scan
    --
    -- Update History
     
     
     (P_CASEID in number ) 
     RETURN NUMBER   
    IS
    
      v_imageid number;
     BEGIN
         
       BEGIN   
 
         
         select max(imageid) into  v_ImageId
           from  Images
              where CASEID = P_CASEID;
                
        EXCEPTION 
           WHEN OTHERS THEN  null; --v_ImageId := 0';
      END; 
     
    return  v_ImageId;
       
    END;

/

