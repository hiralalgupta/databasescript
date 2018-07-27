CREATE OR REPLACE FORCE VIEW medicalhierarchy_field_label_v As
select l.id, l.name,l.revision,l.datafield,l.datafield_label,t.datafield_type,r.datafield_ref from
(select id, name, revision, datafield, datafield_label from medicalhierarchy
UNPIVOT (datafield_label FOR datafield IN (
datafield1 AS 'datafield1', datafield2 AS 'datafield2', datafield3 AS 'datafield3', datafield4 AS 'datafield4',
datafield5 AS 'datafield5', datafield6 AS 'datafield6', datafield7 AS 'datafield7', datafield8 AS 'datafield8',
datafield9 AS 'datafield9', datafield10 AS 'datafield10', datafield11 AS 'datafield11', datafield12 AS 'datafield12',
datafield13 AS 'datafield13', datafield14 AS 'datafield14',
datafield15 AS 'datafield15', datafield16 AS 'datafield16', datafield17 AS 'datafield17', datafield18 AS 'datafield18',
datafield19 AS 'datafield19', datafield20 AS 'datafield20',
datafield21 AS 'datafield21', datafield22 AS 'datafield22', datafield23 AS 'datafield23', datafield24 AS 'datafield24',
datafield25 AS 'datafield25', datafield26 AS 'datafield26', datafield27 AS 'datafield27', datafield28 AS 'datafield28',
datafield29 AS 'datafield29', datafield30 AS 'datafield30', datafield31 AS 'datafield31', datafield32 AS 'datafield32'
))) l,
(select id, name, revision, datafield, datafield_type from medicalhierarchy
UNPIVOT (datafield_type FOR datafield IN (
datafield1type AS 'datafield1', datafield2type AS 'datafield2', datafield3type AS 'datafield3', datafield4type AS 'datafield4',
datafield5type AS 'datafield5', datafield6type AS 'datafield6', datafield7type AS 'datafield7', datafield8type AS 'datafield8',
datafield9type AS 'datafield9', datafield10type AS 'datafield10', datafield11type AS 'datafield11', datafield12type AS 'datafield12',
datafield13type AS 'datafield13', datafield14type AS 'datafield14',
datafield15type AS 'datafield15', datafield16type AS 'datafield16', datafield17type AS 'datafield17', datafield18type AS 'datafield18',
datafield19type AS 'datafield19', datafield20type AS 'datafield20',
datafield21type AS 'datafield21', datafield22type AS 'datafield22', datafield23type AS 'datafield23', datafield24type AS 'datafield24',
datafield25type AS 'datafield25', datafield26type AS 'datafield26', datafield27type AS 'datafield27', datafield28type AS 'datafield28',
datafield29type AS 'datafield29', datafield30type AS 'datafield30', datafield31type AS 'datafield31', datafield32type AS 'datafield32'
))) t,
(select id, name, revision, datafield, datafield_ref from medicalhierarchy
UNPIVOT (datafield_ref FOR datafield IN (
datafield1ref AS 'datafield1', datafield2ref AS 'datafield2', datafield3ref AS 'datafield3', datafield4ref AS 'datafield4',
datafield5ref AS 'datafield5', datafield6ref AS 'datafield6', datafield7ref AS 'datafield7', datafield8ref AS 'datafield8',
datafield9ref AS 'datafield9', datafield10ref AS 'datafield10', datafield11ref AS 'datafield11', datafield12ref AS 'datafield12',
datafield13ref AS 'datafield13', datafield14ref AS 'datafield14',
datafield15ref AS 'datafield15', datafield16ref AS 'datafield16', datafield17ref AS 'datafield17', datafield18ref AS 'datafield18',
datafield19ref AS 'datafield19', datafield20ref AS 'datafield20',
datafield21ref AS 'datafield21', datafield22ref AS 'datafield22', datafield23ref AS 'datafield23', datafield24ref AS 'datafield24',
datafield25ref AS 'datafield25', datafield26ref AS 'datafield26', datafield27ref AS 'datafield27', datafield28ref AS 'datafield28',
datafield29ref AS 'datafield29', datafield30ref AS 'datafield30', datafield31ref AS 'datafield31', datafield32ref AS 'datafield32'
))) r
where l.id=t.id and t.id=r.id(+) and l.datafield=t.datafield and t.datafield=r.datafield(+);
