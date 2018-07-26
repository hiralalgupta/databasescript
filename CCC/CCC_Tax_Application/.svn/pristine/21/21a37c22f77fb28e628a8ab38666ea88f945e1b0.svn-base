package com.ccc.jsonview;

import java.util.HashMap;
import java.util.List;
import java.util.Set;

import org.springframework.http.HttpStatus;

import com.ccc.model.TaxObject;
import com.ccc.webapp.util.ErrorResponse;
import com.fasterxml.jackson.annotation.JsonView;

public class DataResponse {
	
	@JsonView(Views.Public.class)
	Object obj;
	
	@JsonView(Views.Public.class)
	private String transactionId;
	
	@JsonView(Views.Public.class)
	List<TaxObject> taxObj;

	@JsonView(Views.Public.class)
	List<Object> objList;
	
	@JsonView(Views.Public.class)
	HashMap<String,Object> mapList;
	
	@JsonView(Views.Public.class)
	Set<Integer> integerSet;
	
	@JsonView(Views.Public.class)
	ErrorResponse errorResponse;
	
	@JsonView(Views.Public.class)
	Object errorObj;
	
	public Object getObj() {
		return obj;
	}
	
	public String getTransactionId() {
		return transactionId;
	}

	public void setTransactionId(String transactionId) {
		this.transactionId = transactionId;
	}

	public void setObj(Object obj) {
		this.obj = obj;
	}

	public List<Object> getObjList() {
		return objList;
	}

	public void setObjList(List<Object> objList) {
		this.objList = objList;
	}

	public HashMap<String, Object> getMapList() {
		return mapList;
	}

	public void setMapList(HashMap<String, Object> mapList) {
		this.mapList = mapList;
	}

	public Set<Integer> getIntegerSet() {
		return integerSet;
	}

	public void setIntegerSet(Set<Integer> integerSet) {
		this.integerSet = integerSet;
	}

	public ErrorResponse getErrorResponse() {
		return errorResponse;
	}

	public void setErrorResponse(ErrorResponse errorResponse) {
		this.errorResponse = errorResponse;
	}

	public List<TaxObject> getTaxObj() {
		return taxObj;
	}

	public void setTaxObj(List<TaxObject> taxObj) {
		this.taxObj = taxObj;
	}

}
