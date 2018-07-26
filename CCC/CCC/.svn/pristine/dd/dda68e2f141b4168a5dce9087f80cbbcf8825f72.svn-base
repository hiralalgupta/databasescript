package com.ccc.jsonview;

import java.util.List;

import com.ccc.model.TaxObject;
import com.fasterxml.jackson.annotation.JsonView;

public class DataResponse {
	
	@JsonView(Views.Public.class)
	List<TaxObject> taxObj;
	
	@JsonView(Views.Public.class)
	private String transactionId;
	
	public List<TaxObject> getTaxObj() {
		return taxObj;
	}

	public void setTaxObj(List<TaxObject> taxObj) {
		this.taxObj = taxObj;
	}

	public String getTransactionId() {
		return transactionId;
	}

	public void setTransactionId(String transactionId) {
		this.transactionId = transactionId;
	}
	
}
