package com.ccc.webapp.util;

import java.util.List;

import com.fasterxml.jackson.databind.annotation.JsonSerialize;

@JsonSerialize
public class ErrorResponse {

	private String errorMsg;
	private int errorCode;
	private List<String> errors;
	private List<String> counties;
	
	ErrorResponse(){};
	
	public ErrorResponse(int errorCode, String errorMsg, List<String> errors) {
		this.errorCode = errorCode;
		this.errorMsg = errorMsg;
		this.errors = errors;
	}


	public String getErrorMsg() {
		return errorMsg;
	}

	public void setErrorMsg(String errorMsg) {
		this.errorMsg = errorMsg;
	}

	public int getErrorCode() {
		return errorCode;
	}

	public void setErrorCode(int errorCode) {
		this.errorCode = errorCode;
	}

	public List<String> getErrors() {
		return errors;
	}

	public void setErrors(List<String> errors) {
		this.errors = errors;
	}

	public List<String> getCounties() {
		return counties;
	}

	public void setCounties(List<String> counties) {
		this.counties = counties;
	}	
}
