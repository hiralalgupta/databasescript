--------------------------------------------------------
--  DDL for Function STATUS_ICON_BK1
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SNX_IWS2"."STATUS_ICON_BK1" 
      ( P_CASEID  number default NULL,  
        P_STAGEID number default NULL,
        P_USERID   number default NULL
       )
    
    -- Created 11-01-2011 R Benzell
    -- Returns a Text of an appropriate icon 
/*** Icon names (in /ORACLE/fmw/Oracle_OHS1/instances/instance1/config/OHS/ohs1/images)
Assigned-1.png
Assigned-2.png
Assigned-3.png
Assigned-4.png
BlackBox-3.png
BlackBox-4.png
Late-1.png
Late-2.png
Late-3.png
Late-4.png
Published.png
Ready.png
UnAssigned-1.png
UnAssigned-2.png
UnAssigned-3.png
UnAssigned-4.png
****/    

    

    
        RETURN VARCHAR2 
    
        IS
    
        v_Return Varchar2(500) default null;
        --v_Icon Varchar2(500) default null;

        --v_random number;
      
        BEGIN
        
/***         v_random :=  mod(P_CASEID,2);
         CASE
            WHEN v_Random =0
              then v_Return  := '/i/ProfileShadow.gif';
            ELSE 
              v_Icon  := '/i/htmldb/builder/builder_find.png'; 
         END CASE;
***/
      
    
         CASE
            WHEN P_USERID is NULL
              then v_Return  := '/i/ProfileShadow.gif';
            ELSE
              v_Return  := '/i/htmldb/builder/builder_find.png';
         END CASE;


        return v_Return;
       
       EXCEPTION WHEN OTHERS THEN 
            v_Return := NULL;
           
       END;

/

