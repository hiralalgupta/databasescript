drop MATERIALIZED view MEDICALHIERARCHY_LEAF_LEVEL_V;

CREATE MATERIALIZED VIEW MEDICALHIERARCHY_LEAF_LEVEL_V as 
select cp.RootID, cp.hid, cp.codedesc, cp.path, cp.lineage, cp.node_level, mh.* from
medicalhierarchy mh,
(SELECT id RootID, hid, codedesc, SUBSTR(fullpath,1,LENGTH(fullpath)-5) path,
 getLineageFromPath(SUBSTR(fullpath,1,LENGTH(fullpath)-5)) lineage, node_level
  FROM
    (SELECT id, name, level-1 node_level, 
      connect_by_root id hid, connect_by_root description codedesc,
      SYS_CONNECT_BY_PATH(name,'/') fullpath
    FROM medicalhierarchy
      START WITH id IN
      (SELECT id FROM medicalhierarchy
      --WHERE connect_by_isleaf=1
        START WITH name      ='Root'
        CONNECT BY PRIOR id  = parentid
      )
      CONNECT BY PRIOR parentid = id
    )
  WHERE name='Root') cp
where mh.id=cp.hid;

drop index "SNX_IWS2"."MH_LEAF_LEVEL_V_INX1";
CREATE INDEX "SNX_IWS2"."MH_LEAF_LEVEL_V_INX1" ON "SNX_IWS2"."MEDICALHIERARCHY_LEAF_LEVEL_V"
  ("HID", "NODE_LEVEL",
    "ID",
    "NAME",
    "PARENTID",
    "REVISION"
  )
  TABLESPACE "SNX_IWS_INX" ;
grant select on SNX_IWS2.MEDICALHIERARCHY_LEAF_LEVEL_V to SNX_BB2;
grant select on SNX_IWS2.MEDICALHIERARCHY_LEAF_LEVEL_V to SNX_FDN;
grant select on SNX_IWS2.MEDICALHIERARCHY_LEAF_LEVEL_V to SNX_IWS_DW;
