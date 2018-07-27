--Types for XML data
DROP type MedicalDataCategories_t;
DROP type MedicalDataCategory;
DROP type Subcategories_t;
DROP type Subcategory;
DROP type Codes_t;
DROP type Code;
DROP type DataPoints_t;
DROP type DataPoint;
DROP type DataFields_t;
DROP type DataField;

CREATE OR REPLACE TYPE DataField AS Object
(
    "@Label" VARCHAR2(100 CHAR),
    "@Column" VARCHAR2(100 CHAR),
    Value Varchar2(2000 CHAR));
/
CREATE OR REPLACE TYPE DataFields_t AS TABLE OF DataField;
/
CREATE OR REPLACE TYPE DataPoint AS Object
(
    DataDate     VARCHAR2(100 CHAR),
    DPEntryID    VARCHAR2(50 CHAR),
    DataFields   DataFields_t,
    Page         VARCHAR2(5 CHAR),
    Line         VARCHAR2(5 CHAR),
    ISCRITICAL   VARCHAR2(1 CHAR),
    CRITICALITY  VARCHAR2(2 CHAR),
    DATASTATUS   VARCHAR2(30 CHAR));
/
CREATE OR REPLACE TYPE DataPoints_t AS TABLE OF DataPoint;
/
CREATE OR REPLACE TYPE Code AS OBJECT
(
    "@CodeID" VARCHAR2(10 CHAR),
    "@CodeName" VARCHAR2(50 CHAR),
    "@CodeType"  VARCHAR2(50 CHAR),
    "@CodeDescription"    VARCHAR2(2000 CHAR),
    "@CodeVersion"    VARCHAR2(20 CHAR),
    DATAPOINTS DataPoints_t);
/
CREATE OR REPLACE TYPE Codes_t AS TABLE OF Code;
/
CREATE OR REPLACE TYPE Subcategory AS Object
(
    "@SubcategoryName" VARCHAR2(100 CHAR),
    CODES   Codes_t);
/
CREATE OR REPLACE TYPE Subcategories_t AS TABLE OF Subcategory;
/
CREATE OR REPLACE type MedicalDataCategory AS object
(
    "@CategoryName" VARCHAR2(100 CHAR),
    SUBCATEGORIES   Subcategories_t)
/
CREATE OR REPLACE TYPE MedicalDataCategories_t AS TABLE OF MedicalDataCategory;
/

--View of all data points
CREATE OR REPLACE FORCE VIEW XML_DATAPOINTS_V As
Select
   c.caseid,
   regexp_substr(code.lineage,'[^/]+', 1, 1) CategoryName, 
   regexp_substr(code.lineage,'[^/]+', 1, 2) SubcategoryName, 
   dpe.dpentryId,
   dpe.hid codeid,  
   code.name codename, 
   code.CodeDesc CodeDescription, 
   code.codetype,  
   c.HIERARCHYREVISION CodeVersion,  
   dpe.datadate,  
   p.finalpagenumber page,
   case when dpe.endSectionNumber != dpe.startSectionNumber then dpe.startSectionNumber||'-'||dpe.endSectionNumber else to_char(dpe.startSectionNumber) end line,
   dpe.iscritical,
   dpe.CRITICALITY,
   dpe.status, -- data status for screening
   code.dataField1,  
   dpe.dataField1Value,  
   code.dataField2, 
   dpe.dataField2Value, 
   code.dataField3, 
   dpe.dataField3Value,  
   code.dataField4,  
   dpe.dataField4Value,  
   code.dataField5,  
   dpe.dataField5Value,  
   code.dataField6,  
   dpe.dataField6Value,  
   code.dataField7,  
   dpe.dataField7Value, 
   code.dataField8,  
   dpe.dataField8Value,  
   code.dataField9,  
   dpe.dataField9Value,  
   code.dataField10, 
   dpe.dataField10Value,  
   code.dataField11,  
   dpe.dataField11Value,  
   code.dataField12,  
   dpe.dataField12Value
   FROM dpentries dpe, pages p, MEDICALHIERARCHY_LEAF_LEVEL_V code, cases c  
   WHERE dpe.pageid = p.pageid 
   AND dpe.hid = code.hid AND dpe.isDeleted = 'N' 
   AND c.caseid = p.caseId;
   
--View of all categories of data points
CREATE OR REPLACE FORCE VIEW XML_DATAPOINTS_CAT_V As
Select
   distinct c.caseid,
   regexp_substr(code.lineage,'[^/]+', 1, 1) CategoryName 
FROM dpentries dpe, pages p, MEDICALHIERARCHY_LEAF_LEVEL_V code, cases c  
   WHERE dpe.pageid = p.pageid 
   AND dpe.hid = code.hid AND dpe.isDeleted = 'N' 
   AND c.caseid = p.caseId;

--View of all categories and subcategories of data points
CREATE OR REPLACE FORCE VIEW XML_DATAPOINTS_SUBCAT_V As
Select
   distinct c.caseid,
   regexp_substr(code.lineage,'[^/]+', 1, 1) CategoryName, 
   regexp_substr(code.lineage,'[^/]+', 1, 2) SubcategoryName 
FROM dpentries dpe, pages p, MEDICALHIERARCHY_LEAF_LEVEL_V code, cases c  
   WHERE dpe.pageid = p.pageid 
   AND dpe.hid = code.hid AND dpe.isDeleted = 'N' 
   AND c.caseid = p.caseId;

--View of all codes of data points
CREATE OR REPLACE FORCE VIEW XML_DATAPOINTS_Code_V As
Select
   distinct c.caseid,
   regexp_substr(code.lineage,'[^/]+', 1, 1) CategoryName, 
   regexp_substr(code.lineage,'[^/]+', 1, 2) SubcategoryName, 
   dpe.hid codeid,  
   code.name codename, 
   code.CodeDesc CodeDescription, 
   code.codetype,  
   c.HIERARCHYREVISION CodeVersion  
   FROM dpentries dpe, pages p, MEDICALHIERARCHY_LEAF_LEVEL_V code, cases c  
   WHERE dpe.pageid = p.pageid 
   AND dpe.hid = code.hid AND dpe.isDeleted = 'N' 
   AND c.caseid = p.caseId;
   
--View of all data point fields in tabular format
CREATE OR REPLACE FORCE VIEW XML_DataFields_V As
select caseid, dpentryId, DataField from (
  select caseid, dpentryId, DataField
  from (Select caseid, dpentryId,
               DataField(dataField1, 'DataField1', dataField1Value) df1,
               DataField(dataField2, 'DataField2', dataField2Value) df2,
               DataField(dataField3, 'DataField3', dataField3Value) df3,
               DataField(dataField4, 'DataField4', dataField4Value) df4,
               DataField(dataField5, 'DataField5', dataField5Value) df5,
               DataField(dataField6, 'DataField6', dataField6Value) df6,
               DataField(dataField7, 'DataField7', dataField7Value) df7,
               DataField(dataField8, 'DataField8', dataField8Value) df8,
               DataField(dataField9, 'DataField9', dataField9Value) df9,
               DataField(dataField10, 'DataField10', dataField10Value) df10,
               DataField(dataField11, 'DataField11', dataField11Value) df11,
               DataField(dataField12, 'DataField12', dataField12Value) df12
        from XML_DATAPOINTS_V
) unpivot (
      DataField
      for DataFields in (df1,df2,df3,df4,df5,df6,df7,df8,df9,df10,df11,df12)
)) t1
where t1.DataField.value is not null;
