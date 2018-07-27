create or replace
function apex_040000.wwv_flow_epg_include_mod_local(
    procedure_name in varchar2)
return boolean
--- Also remember to issue "GRANT EXECUTE ON {proc name} TO  PUBLIC"  !

is
begin
    if upper(procedure_name) in 
       ('UCM_UTILS.DISPLAY_FILE','UCM_UTILS.DISPLAY_FILE_T',
       'SNX_APEX_DEV.DISPLAY_IMAGE','DISPLAY_IMAGE',
       'SNX_IWS.DISPLAY_IMAGE',
       'IWS_APP_UTILS.DISPLAY_IMAGE_INLINE','DISPLAY_IMAGE_INLINE',
       'IWS_APP_UTILS.GET_DISPLAY_IMAGE','GET_DISPLAY_IMAGE',
       'SNX_APEX_DEV.REQUEST_VALIDITY_CHECK','REQUEST_VALIDITY_CHECK')            
     then
        return TRUE;
    else
        return FALSE;
    end if;
end wwv_flow_epg_include_mod_local;
/