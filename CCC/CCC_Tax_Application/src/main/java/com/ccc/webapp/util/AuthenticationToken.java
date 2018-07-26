package com.ccc.webapp.util;

import org.springframework.beans.factory.annotation.Autowired;

public class AuthenticationToken {
	private final String token; 
	
	public AuthenticationToken(String token){
		this.token=token;
	}

	public String getToken() {
		return token;
	}
	

}
