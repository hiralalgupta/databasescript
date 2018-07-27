--------------------------------------------------------
--  DDL for Function TRANSMITTED_PAGE_IMAGE_SIZE
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SNX_IWS2"."TRANSMITTED_PAGE_IMAGE_SIZE" 
    (P_CASEID NUMBER default null,
     P_SPCONTENTID VARCHAR2 default null,  --only required for LHS images
     P_FILTER VARCHAR2 default 'nofilter' -- either: nofilter,allnonexcluded, processed,unprocessed,excluded,flagged
     )
    
    -- Created 11-30-2011 R Benzell
    -- Called by IWS when inserting Page Image Metrics into Audit log
    -- to test:
    --  Select TRANSMITTED_PAGE_IMAGE_SIZE(1800,null,'nofilter') from dual  --RHS
    --  Select TRANSMITTED_PAGE_IMAGE_SIZE(null,'SP0000012419',null) from dual  --LHS
    -- Update History
    -- 
         RETURN number
           IS
       
    v_SIZE number default 0;

    v_SQL varchar2(4000);
        
    BEGIN
 
    CASE  

  --- Need to sum up totals of Thumbnails for the Case, Must consider filtering
     WHEN P_CASEID IS NOT NULL  --and P_FILTER = 'nofilter'
        then
         Select SUM(f.dfilesize) into v_SIZE
          FROM pages p,
          snx_ocs.filestorage f
          WHERE f.did=p.did
                AND p.caseid       = P_CASEID
                AND f.drenditionid = 'rendition:T';

    --- Always one image, no filtering is necessary, find by SPCONTENTID
     WHEN P_SPCONTENTID IS NOT NULL 
        then
         Select f.dfilesize into v_SIZE
          FROM pages p,
          snx_ocs.filestorage f
          WHERE f.did=p.did
                AND p.SPCONTENTID    = P_SPCONTENTID
                AND f.drenditionid = 'primaryFile';

     ELSE
         v_Size := 0; 

     END CASE;
        
        return v_Size;
       
      END;

/

