package com.ccc.service;

import java.util.List;
import java.util.Map;

import com.ccc.model.FormData;
import com.ccc.model.TaxObject;
import com.ccc.webapp.exception.advise.UniqueCountyNotFoundException;
import com.fasterxml.jackson.databind.node.ObjectNode;

public interface SaleTaxService {
	List<Map<String ,String>> getAllSaleTax(double totalAmount,Integer plus4,Integer zip,String rName,String cName,String modelMake,String modelName,
			Integer modelYear, String modelTrim,String plateType); 
	List<TaxObject> getTaxes(FormData jsonData) throws UniqueCountyNotFoundException;
	
	List<TaxObject> getGenericTaxData(ObjectNode jsonData);
	List<TaxObject> getCitySpecificGenericTaxData(ObjectNode jsonData);
	List<TaxObject> getAddressGenericTaxData(ObjectNode jsonData);
}
