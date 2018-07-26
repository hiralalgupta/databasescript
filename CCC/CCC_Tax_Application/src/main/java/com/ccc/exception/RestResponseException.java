package com.ccc.exception;

import org.springframework.http.ResponseEntity;

public class RestResponseException extends RuntimeException{
	
	private static final long serialVersionUID = 1322843626304554510L;
	
	protected ResponseEntity<?> responseEntity;
	
	public RestResponseException () {
		super();
	}
	
	public RestResponseException (ResponseEntity<?> entity) {
		this.responseEntity=entity;
	}
	
	public ResponseEntity<?> getResponseEntity () {
		return this.responseEntity;
	}
 
	public void setResponseEntity(ResponseEntity<?> responseEntity) {
		this.responseEntity = (ResponseEntity<?>) responseEntity;
	}
	
}
