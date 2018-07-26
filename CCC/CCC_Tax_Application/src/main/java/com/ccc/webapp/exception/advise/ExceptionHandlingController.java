package com.ccc.webapp.exception.advise;

import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.client.HttpClientErrorException;
import org.springframework.web.client.HttpServerErrorException;

//@ControllerAdvice
public class ExceptionHandlingController {
	
	
/*	@ExceptionHandler(RestResponseException.class)
	@ResponseBody
	public AjaxResponseBody<String, Object> invalidInput(RestResponseException exception){
		//System.out.println("Handle Exception in ExceptionHandlingController :"+ exception.getBindingResult().getAllErrors());
		ResponseEntity<ErrorResponse> errorResponse=(ResponseEntity<ErrorResponse>) exception.getResponseEntity();
		AjaxResponseBody<String, Object> ajaxBody= new AjaxResponseBody<>();
		ErrorResponse errorRespose= new ErrorResponse();
		errorRespose.setErrorMsg("Invalid Input");
		errorRespose.setErrorCode("E01");
		//String error=exception.getBindingResult().getAllErrors().stream().map(n->n.toString()).collect(Collectors.joining(","));
		//errorRespose.setErrors(exception.getMessage());
		ajaxBody.setObj(errorRespose);
		
		
		
		return ajaxBody;
	}*/
	
	@ExceptionHandler(HttpClientErrorException.class)
	public String handleXXException(HttpClientErrorException e) {
	    return "HttpClientErrorException_message";
	}

	@ExceptionHandler(HttpServerErrorException.class)
	public String handleXXException(HttpServerErrorException e) {
	    return "HttpServerErrorException_message";
	}
	// catch unknown error
	@ExceptionHandler(Exception.class)
	public String handleException(Exception e) {
	    return "unknown_error_message";
	}

}
