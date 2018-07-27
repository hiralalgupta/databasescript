/*this is used in medicalhierarchy_leaf_level_v generation*/ 
CREATE OR REPLACE Function getLineageFromPath(p_path IN VARCHAR2)
	  Return VARCHAR2
  Is
	v_output varchar2(500);
  begin
	  with input as
		(select p_path col from dual)
	  select '/'||LISTAGG(regexp_substr(col, '[^/]+', 1, rownum),'/') WITHIN GROUP (ORDER BY level desc) into v_output
	  from input
	  connect by level <= length(regexp_replace(col, '[^/]+'));
	  return v_output;
  end getLineageFromPath;
/