package com.ccc.webapp.security.configuration;
/**
 * User: Ankit Mathur
 * Date: 05/08/2017
 */
import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.security.core.AuthenticationException;
import org.springframework.security.web.DefaultRedirectStrategy;
import org.springframework.security.web.RedirectStrategy;
import org.springframework.security.web.authentication.AuthenticationFailureHandler;

public class CustomAuthenticationFailureHandler implements AuthenticationFailureHandler {

	 private RedirectStrategy redirectStrategy = new DefaultRedirectStrategy();
	 
	 
	@Override
	public void onAuthenticationFailure(HttpServletRequest request, HttpServletResponse response,
			AuthenticationException exception) throws IOException, ServletException {
		System.out.println("Custom Authentication Failure handler is called ");
		//response.sendRedirect("/login?error=loginError");
		redirectStrategy.sendRedirect(request, response, "/login?error=loginError");
		
	}

}
