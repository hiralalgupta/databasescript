--------------------------------------------------------
--  DDL for Function SHOW_CGI_INFO
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SNX_IWS2"."SHOW_CGI_INFO" 
    -- Program name: show_cgi_info
    -- created R Benzell 9-19-2011
    -- to run:  select show_cgi_info() from dual
    -- update history
    -- 10-21-2011 added <br> for formatting
    
    return varchar2
    
  IS
    
  BEGIN
  FOR i IN 1..owa.num_cgi_vars LOOP
    htp.p(owa.cgi_var_name(i)||' = '||owa.cgi_var_val(i) || '<br>');
  END LOOP;
return '--end--';
end;

/

