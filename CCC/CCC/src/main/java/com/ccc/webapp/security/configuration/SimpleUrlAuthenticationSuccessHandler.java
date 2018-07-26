package com.ccc.webapp.security.configuration;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.web.DefaultRedirectStrategy;
import org.springframework.security.web.RedirectStrategy;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import org.springframework.stereotype.Component;

public class SimpleUrlAuthenticationSuccessHandler implements AuthenticationSuccessHandler {
	
	 private RedirectStrategy redirectStrategy = new DefaultRedirectStrategy();
	@Override
	public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication) throws IOException, ServletException {
		
		handle(request, response, authentication);
	}
	 protected void handle(HttpServletRequest request, 
		      HttpServletResponse response, Authentication authentication) throws IOException {
		        String targetUrl = determineTargetUrl(authentication);
		 
		        if (response.isCommitted()) {
		            return;
		        }
		 
		        redirectStrategy.sendRedirect(request, response, targetUrl);
		    }
	 /** Builds the target URL according to the logic defined in the main class Javadoc. */
	    protected String determineTargetUrl(Authentication authentication) {
	    	String url="";
	        List<String> roles = new ArrayList();
	        Collection<? extends GrantedAuthority> authorities = authentication.getAuthorities();
	        for (GrantedAuthority a : authorities) {
	            roles.add(a.getAuthority());
	        }
	        
	 
	        if (isDba(roles)) {
	            return "/db";
	        } else if (isUser(roles) || isAdmin(roles)) {
	        	return "/taxCalculate";
	        }else {
	        	return "/accessDenied";
	        }
	    }
	    private boolean isUser(List<String> roles) {
	        if (roles.contains("ROLE_USER")) {
	            return true;
	        }
	        return false;
	    }
	 
	    private boolean isAdmin(List<String> roles) {
	        if (roles.contains("ROLE_ADMIN")) {
	            return true;
	        }
	        return false;
	    }
	 
	    private boolean isDba(List<String> roles) {
	        if (roles.contains("ROLE_DBA")) {
	            return true;
	        }
	        return false;
	    }
	    public void setRedirectStrategy(RedirectStrategy redirectStrategy) {
	        this.redirectStrategy = redirectStrategy;
	    }
	    protected RedirectStrategy getRedirectStrategy() {
	        return redirectStrategy;
	    }
}
