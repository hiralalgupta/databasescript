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
               DataField(dataField12, 'DataField12', dataField12Value) df12,
               DataField(dataField13, 'DataField13', dataField13Value) df13,
               DataField(dataField14, 'DataField14', dataField14Value) df14,
               DataField(dataField15, 'DataField15', dataField15Value) df15,
               DataField(dataField16, 'DataField16', dataField16Value) df16,
               DataField(dataField17, 'DataField17', dataField17Value) df17,
               DataField(dataField18, 'DataField18', dataField18Value) df18,
               DataField(dataField19, 'DataField19', dataField19Value) df19,
               DataField(dataField20, 'DataField20', dataField20Value) df20,
               DataField(dataField21, 'DataField21', dataField21Value) df21,
               DataField(dataField22, 'DataField22', dataField22Value) df22,
               DataField(dataField23, 'DataField23', dataField23Value) df23,
               DataField(dataField24, 'DataField24', dataField24Value) df24,
               DataField(dataField25, 'DataField25', dataField25Value) df25,
               DataField(dataField26, 'DataField26', dataField26Value) df26,
               DataField(dataField27, 'DataField27', dataField27Value) df27,
               DataField(dataField28, 'DataField28', dataField28Value) df28,
               DataField(dataField29, 'DataField29', dataField29Value) df29,
               DataField(dataField30, 'DataField30', dataField30Value) df30,
               DataField(dataField31, 'DataField31', dataField31Value) df31,
               DataField(dataField32, 'DataField32', dataField32Value) df32
        from XML_DATAPOINTS_V
) unpivot (
      DataField
      for DataFields in (df1,df2,df3,df4,df5,df6,df7,df8,df9,df10,df11,df12,df13,df14,df15,df16,df17,df18,df19,df20,df21,df22,df23,df24,df25,df26,df27,df28,df29,df30,df31,df32)
)) t1
where t1.DataField.value is not null;