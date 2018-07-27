create or replace
FUNCTION            "ROLEID_ICON" 
      ( P_ROLEID number default NULL,
        P_Userid   Number Default Null,
        P_ISCOMPLETE  varchar2 default NULL,  -- Y or N or 'R' means reassigned to another
        P_FORMAT    varchar2 default 'image'   -- prefix
       )
    
    -- Created 2-21-2013 R Benzell
    -- Returns a Text of an appropriate icon for POP Roles 
    -- to test: ROLEID_ICON(104,3,'N')ROLEID_ICON(104,3,'N') from dual
    -- to invoke from apex report region:  ROLEID_ICON(P.ROLEID,P.USERID,P.ISCOMPLETED) ROLEID_ICON 
    -- Update History: 
    -- 3-18-2012 R Benzell - addred 'R' option to ISCOMPLETE to flag Reassigned files.
    
--- Icon names (in /ORACLE/fmw/Oracle_OHS1/instances/instance1/config/OHS/ohs1/images)
   
   

    
      RETURN VARCHAR2 
    
        IS
    
        v_Return Varchar2(500) default null;
        v_prefix Varchar2(30);
      
     BEGIN
     
     
    v_prefix := '/i/';   
         
    CASE
     WHEN P_ISCOMPLETE = 'Y' then
       Select trim(COMPLETED_ICON_NAME) into v_Return
       From ROLES
       Where ROLEID = P_ROLEID AND ROWNUM=1;        

     WHEN P_USERID IS NULL or P_ISCOMPLETE = 'R' then
       Select trim(UNASSIGNED_ICON_NAME) into v_Return
       From ROLES
       Where ROLEID = P_ROLEID AND ROWNUM=1;        

     WHEN P_USERID IS NOT NULL then
       Select trim(ASSIGNED_ICON_NAME) into v_Return
       From ROLES
       Where ROLEID = P_ROLEID AND ROWNUM=1;
       
    ELSE v_Return  := null;  --'/i/UnknownStatus.png';  -- do this so no icon appears

    --  v_Return  := '/i/UnknownStatus.png';  -- do this so no icon appears
    --ELSE v_Return  := 'P_USERID=' || P_USERID || ' <br> ' ||
    --                  'P_ROLEID=' || P_ROLEID || ' <br> ' ||
    --                  'P_ISCOMPLETE=' || P_ISCOMPLETE ;
         
    END CASE;              

   --- If there is an Icon, and 'img' format is request, build the image link
   --- If no icon, null is returned, and missing icon link does not occur on web screen 
    CASE
     WHEN P_FORMAT = 'image' and v_Return is not null
        then v_Return :=  '<img src="/i/' || v_return || '"  width="40" height="40"> ';
      
     WHEN P_FORMAT = 'prefix' and v_Return is not null
        then v_Return :=  '/i/' || v_return ;
    
     ELSE
       null;
     -- for Debug
     --v_Return := v_return || 'NOTHING';
      --   v_Return  := 'P_USERID=' || P_USERID || ' <br> ' ||
      --                'P_ROLEID=' || P_ROLEID || ' <br> ' ||
      --                'P_ISCOMPLETE=' || P_ISCOMPLETE ;
       
     END CASE; 

    -- for Debug 
    -- v_Return  := 'v_return=>>' ||v_return || '<< <br> '  ||
    --              'P_USERID=' || P_USERID || ' <br> ' ||
    --              'P_ROLEID=' || P_ROLEID || ' <br> ' ||
    --              'P_FORMAT=' || P_FORMAT || ' <br> ' ||
    --              'P_ISCOMPLETE=' || P_ISCOMPLETE ;
       
      

     return v_Return;
       
     EXCEPTION WHEN OTHERS THEN 
            -- Dont return any value, but must perform return null to avoid ORA-06503 error
            return null;  
           
     END;
/	 