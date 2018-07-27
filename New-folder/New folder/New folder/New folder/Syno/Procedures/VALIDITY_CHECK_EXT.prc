--------------------------------------------------------
--  DDL for Procedure VALIDITY_CHECK_EXT
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "SNX_IWS2"."VALIDITY_CHECK_EXT" 
     ( P_SESSION in NUMBER   default null,
       P_APEXSESSION in NUMBER default null,
       P_JAVASESSION in NUMBER default null,
       P_CASEID in NUMBER default null,
       P_STAGEID in NUMBER default null,
       P_USERID in out NUMBER ,
       P_VALIDITY out VARCHAR2 ,
       P_MESSAGE out VARCHAR2 ,
       P_USERNAME out VARCHAR2
       )
    -- Program Name - VALIDITY_CHECK_EXT
    -- Created 10-14-2011 R Benzell
    -- Invoke by External Applications (like IWS) to  Validity check of a user session
    -- Performs any special environmental processing, then invokes VALIDITY_CHECK
    -- Similar to REQUEST_VALIDITY_CHECK, except it is not a URL
    -- or invoked directly as a stored procedure

    
     -- Update History
     -- 10-11-2011 R Benzell
     --   Elaborated on invocation as stored procedure
   
   /*    to test  
    --select * from sessions order by sessionid desc
    
    declare
     v_USERID   NUMBER default 3;
     v_VALIDITY VARCHAR2(30) ;
     v_MESSAGE  VARCHAR2(1000) ;
     v_USERNAME VARCHAR2(40);

    begin

      VALIDITY_CHECK_EXT(
                        P_SESSION => 27,
                        P_APEXSESSION => 3929040116295472,
                        P_JAVASESSION => 1111111111,
                        P_CASEID => 185,
                        P_STAGEID => 1,
                        P_USERID => v_USERID,
                        P_VALIDITY => v_VALIDITY,
                        P_MESSAGE => v_MESSAGE,
                        P_USERNAME => v_USERNAME  
            );

             htp.p('userid  :'  || v_USERID  );
             htp.p('validty  :'  ||v_VALIDITY ) ;
             htp.p('message  :'  ||v_MESSAGE  ) ;
             htp.p('username  :'  ||v_USERNAME );    

   end;
 */
    
    -- Update History
    --
    
    
    AS
    
    
BEGIN

    
     VALIDITY_CHECK(
       P_SESSION      => P_SESSION ,
       P_APEXSESSION => P_APEXSESSION,
       P_JAVASESSION => P_JAVASESSION,
       P_CASEID => P_CASEID,
       P_STAGEID => P_STAGEID,
       P_USERID => P_USERID,
       P_VALIDITY => P_VALIDITY,
       P_MESSAGE => P_MESSAGE,
       P_USERNAME => P_USERNAME
     );
    

  --- Log error and image it occurred with
  EXCEPTION WHEN OTHERS THEN LOG_APEX_ERROR(14,null,P_SESSION);

END;

/

