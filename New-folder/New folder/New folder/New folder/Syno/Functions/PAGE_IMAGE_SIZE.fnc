--------------------------------------------------------
--  DDL for Function PAGE_IMAGE_SIZE
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SNX_IWS2"."PAGE_IMAGE_SIZE" 
    (P_CASEID NUMBER,
     P_SIDE VARCHAR2,  --- either 'LHS'/'22' or 'RHS'
     P_ID  VARCHAR2,   --- Image ID
     P_FILTER VARCHAR2 -- either nofilter,allnonexcluded, processed,unprocessed,excluded,flagged
      )
    
    -- Created 11-30-2011 R Benzell
    -- Called by IWS when calculating Page Image Metrics into Audit log
    -- Update History
    -- 12-7-2011 - updated LHS to lookup by SPID, only return RHS stats if 'nofilter'
         RETURN number
           IS
       
    v_SIZE number default 0;
        
    BEGIN
 
     IF P_SIDE = 'LHS' or P_SIDE = '22'
        THEN 

     --- Grab the LHS Image Size
        SELECT f.dfilesize into v_SIZE
           FROM snx_ocs.revisions r,
                snx_ocs.filestorage f
              WHERE f.did       =r.did
                AND r.ddocname    = P_ID
                AND f.drenditionid='primaryFile';

       END IF;


      IF (P_SIDE = 'RHS' or P_SIDE = '18') AND P_FILTER = 'nofilter'
        THEN
         --- Sum the RHS Thumbnails Sizes 
         --- Only calculate if all thumbnails selected (P_FILTER='nofilter')
         --- If performance of filtered results is desired, this can be added as a later enhancement
        SELECT   sum(f.dfilesize) into V_SIZE
           FROM pages p,
           snx_ocs.filestorage f
          WHERE f.did         = p.did
          AND p.caseid        = P_CASEID
          AND f.drenditionid = 'rendition:T';
      END IF; 
      

     ---- don't return 0, make null if that happens
        If v_Size = 0
          then return NULL;
          else return v_Size;
        END IF;
       
      END;

/

