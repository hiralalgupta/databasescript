package com.ccc.rest.authentication;

import java.io.Serializable;

import com.fasterxml.jackson.databind.annotation.JsonSerialize;
@JsonSerialize
public final  class JwtAuthenticationResponse implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private  String token;
	 public JwtAuthenticationResponse() {
	    }
	
	 public JwtAuthenticationResponse(String token) {
	        this.token = token;
	    }
   
    public String getToken() {
        return this.token;
    }
}
