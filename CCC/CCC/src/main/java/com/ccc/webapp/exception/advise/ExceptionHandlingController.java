package com.ccc.webapp.exception.advise;

import java.util.ArrayList;
import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.FieldError;
import org.springframework.validation.ObjectError;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;
import org.springframework.web.context.request.WebRequest;
import org.springframework.web.servlet.mvc.method.annotation.ResponseEntityExceptionHandler;

import com.ccc.jsonview.ErrorResponseWrapper;
import com.ccc.webapp.util.ErrorCode;
import com.ccc.webapp.util.ErrorResponse;

@RestControllerAdvice
public class ExceptionHandlingController extends ResponseEntityExceptionHandler{
	
	private final Logger logger = LoggerFactory.getLogger( this.getClass());
	
	@Override
	protected ResponseEntity<Object>  handleMethodArgumentNotValid(MethodArgumentNotValidException ex,HttpHeaders headers, HttpStatus status, WebRequest request) {
		logger.info("Calling handleMethodArgumentNotValid()....");
		List<String> errors = new ArrayList<String>();
	    for (FieldError error : ex.getBindingResult().getFieldErrors()) {
	        errors.add(error.getField() + ": " + error.getDefaultMessage());
	    }
	    for (ObjectError error : ex.getBindingResult().getGlobalErrors()) {
	        errors.add(error.getObjectName() + ": " + error.getDefaultMessage());
	    }
	    
	    ErrorResponse errorRespose = new ErrorResponse(ErrorCode.VALIDAION.getCode(), ErrorCode.VALIDAION.getDescription(), errors);
	    
	    ErrorResponseWrapper errorResponses = new ErrorResponseWrapper();
	    errorResponses.setErrorResponse(errorRespose);
	    return new ResponseEntity<Object>(errorResponses, HttpStatus.BAD_REQUEST);
	}
	
	@ExceptionHandler(value = { UniqueCountyNotFoundException.class})
    protected  ResponseEntity<Object>  handleConflict(UniqueCountyNotFoundException ex, WebRequest request) {
		logger.info("Calling handleConflict() UniqueCountyNotFoundException....");
        ErrorResponse errorRespose = new ErrorResponse(ErrorCode.MULTIPLECOUNTY.getCode(), ErrorCode.MULTIPLECOUNTY.getDescription(), null);
        errorRespose.setCounties(ex.getCountyList());
	    ErrorResponseWrapper errorResponse = new ErrorResponseWrapper();
	    errorResponse.setErrorResponse(errorRespose);
	    
	    return new ResponseEntity<Object>(errorResponse, HttpStatus.PRECONDITION_REQUIRED);
    }
	
	@ExceptionHandler(value = { AddressNotFoundException.class})
    protected  ResponseEntity<Object>  handleConflict(AddressNotFoundException ex, WebRequest request) {
		logger.info("Calling handleConflict() AddressNotFoundException....");
		List<String> errors = new ArrayList<String>();
		errors.add(ErrorCode.GENERIC.getDescription());
        ErrorResponse errorRespose = new ErrorResponse(ErrorCode.ADDRESSNOTFOUND.getCode(), ErrorCode.ADDRESSNOTFOUND.getDescription(),errors);
	    errorRespose.setErrorCode(ErrorCode.ADDRESSNOTFOUND.getCode());
	    
	    ErrorResponseWrapper errorResponse = new ErrorResponseWrapper();
	    errorResponse.setErrorResponse(errorRespose);
	    return new ResponseEntity<Object>(errorResponse, HttpStatus.PRECONDITION_REQUIRED);
    }
	
	
	@ExceptionHandler(value = { VehicleTypeNotFoundException.class})
    protected  ResponseEntity<Object>  handleConflict(VehicleTypeNotFoundException ex, WebRequest request) {
		logger.info("Calling handleConflict() VehicleTypeNotFoundException....");
		List<String> errors = new ArrayList<String>();
		errors.add(ErrorCode.VEHICLETYPENOTFOUND.getDescription());
        ErrorResponse errorRespose = new ErrorResponse(ErrorCode.VEHICLETYPENOTFOUND.getCode(), ErrorCode.VEHICLETYPENOTFOUND.getDescription(),errors);
	    errorRespose.setErrorCode(ErrorCode.VEHICLETYPENOTFOUND.getCode());
	    
	    ErrorResponseWrapper errorResponse = new ErrorResponseWrapper();
	    errorResponse.setErrorResponse(errorRespose);
	    
	    return new ResponseEntity<Object>(errorResponse, HttpStatus.PRECONDITION_REQUIRED);
    }
	
	@ExceptionHandler(value = { Exception.class})
    protected ResponseEntity<Object> handleConflict(Exception ex, WebRequest request) {
		logger.info("Calling handleConflict() for Exception....");
		List<String> errors = new ArrayList<String>();
		errors.add(ErrorCode.GENERIC.getDescription());
        ErrorResponse errorRespose = new ErrorResponse(ErrorCode.GENERIC.getCode(), ErrorCode.GENERIC.getDescription(), errors);
	    errorRespose.setErrorCode(ErrorCode.GENERIC.getCode());
	    
	    ErrorResponseWrapper errorResponse = new ErrorResponseWrapper();
	    errorResponse.setErrorResponse(errorRespose);
	    
	    ex.printStackTrace();
	    logger.error("print stack trace: "+ex.getStackTrace());
	    return new ResponseEntity<Object>(errorResponse, HttpStatus.INTERNAL_SERVER_ERROR);
    }
	

}
