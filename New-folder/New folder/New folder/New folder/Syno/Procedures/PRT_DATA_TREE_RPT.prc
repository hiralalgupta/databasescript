--------------------------------------------------------
--  DDL for Procedure PRT_DATA_TREE_RPT
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "SNX_IWS2"."PRT_DATA_TREE_RPT" 
  -- Program name - PRT_DATA_TREE
  -- Created 10-10-2011 R Benzell
  -- Generates a report showing the configuration tree
  -- Update History
  -- 10-11-2011 R Benzell
  --    Updated to retreive based on linkaged in GROUPS table, and format within Apex Screens
    
/** to test    
begin
  PRT_DATA_TREE_RPT(1);
end;
***/
    
           (
             P_GROUPID in NUMBER default 1
           )   
               
  
      IS
 
 
        vA Integer default 0;
        vB Integer default 0;
        vC Integer default 0;
        vD Integer default 0;
        vE Integer default 0;
        v_CaseCnt integer;
        v_tab varchar2(50);
        v_LF varchar2(5); 
        v_line varchar2(100);
      BEGIN
   --- spacer tab
      v_tab := '     ';       
      v_lf  := '
';  
      v_line := '____________________________________________________________________________________';
    htp.p('Group Id: ' || P_GROUPID ||v_LF || v_lf);
 
   -- Drive from Category Groups
    for A in
      (   SELECT  X.DPCATEGORYID, Y.DPCATEGORYNAME, X.SEQUENCE, X. NOTES
          from DPCATEGORYGROUPS X,
               DPCATEGORIES Y
          where X.SEQUENCE > 0 and X.DPCATEGORYID = Y.DPCATEGORYID
                and X.GROUPID = P_GROUPID
          ORDER BY X.SEQUENCE,    X.DPCATEGORYID  )
    LOOP  
        vA := vA + 1;
        htp.p( v_line || v_LF);
        htp.p(v_LF || '(' || vA || ') Cat: ' ||  A.DPCATEGORYNAME || '' || v_lf);
 
       --- Now Grab Each Subcategory
        for B in
         ( SELECT DPSUBCATID, DPCATEGORYID,  DPSUBCATNAME, SEQUENCE,   NOTES
           from DPSUBCATEGORIES
           where SEQUENCE > 0 AND DPCATEGORYID = A.DPCATEGORYID
           ORDER BY SEQUENCE, DPSUBCATNAME  )
            LOOP   ---B
              vB := vB + 1;
              htp.p( v_LF || v_tab || vB || ')  SubCat: ' ||  B.DPSUBCATNAME || ''|| v_lf);
             
          --- Get DP Form Entity Info
              for C in
              ( SELECT DISPLAYLABEL,ISDATEREQUIRED, ISSTATUSREQUIRED, ISUNIQUEPERCASE,
                       LOVID, HELPTEXT, HELPLINK,    NOTES
                 from DPFORMENTITIES
                 where DPCATEGORYID = B.DPCATEGORYID AND DPSUBCATID = B.DPSUBCATID
                 ORDER BY  DISPLAYLABEL  )
                 LOOP   ---C
                    vC := vC + 1;
                    htp.p( v_tab || v_tab || 'Label: '           || C.DISPLAYLABEL  || v_lf);
                    htp.p( v_tab || v_tab || 'HelpText: '        || C.HELPTEXT   || v_lf);
                    --htp.p( v_tab || v_tab || 'HelpText:'  || v_LF ||
                    --    replace(C.HELPTEXT,chr(10),v_LF)   || v_lf);
                    htp.p( v_tab || v_tab || 'HelpLink: '        || C.HELPLINK   || v_lf);
                    htp.p( v_tab || v_tab || 'Date Req: '        || C.ISDATEREQUIRED || v_lf);   
                    htp.p( v_tab || v_tab || 'Status Req: '      || C.ISSTATUSREQUIRED || v_lf);
                    htp.p( v_tab || v_tab || 'Unique Per Case: ' || C.ISUNIQUEPERCASE || v_lf);
                     --- Get LOV Header Info
                      for D in
                      ( SELECT  LOVLABEL,LOVID from LOVS
                          where LOVID = C.LOVID
                          ORDER BY  LOVID  )
                          LOOP   ---D
                             vD := vD + 1;
                              htp.p( v_tab || v_tab || 'Lov Label: '  || D.LOVLABEL || ''|| v_lf );
                                                  --- Get LOV Header Info
                              for E in
                              ( SELECT  LOVVALUE from LOVVALUES
                               where LOVID = D.LOVID
                               ORDER BY  SEQUENCE,LOVVALUE  )
                               LOOP   ---E
                                 vE := vE + 1; 
                                 htp.p( v_tab || v_tab || v_tab || vE || ') '  || E.LOVVALUE || v_lf );
                               END LOOP; ---E 
                               vE := 0;
                               --htp.p(v_LF);
                          END LOOP; ---D 
                          vD := 0;
              END LOOP; ---C 
              vC := 0;
            END LOOP; ---B
            vB := 0;
        htp.p(v_LF);
     END LOOP;  ---A
     vA := 0;      
                
             
       EXCEPTION WHEN OTHERS THEN LOG_APEX_ERROR(15);
             
       END;

/

