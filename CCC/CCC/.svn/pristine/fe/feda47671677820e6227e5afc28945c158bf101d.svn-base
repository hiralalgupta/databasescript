package com.ccc.listener;

import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;

import org.springframework.security.core.context.SecurityContext;
import org.springframework.security.core.context.SecurityContextHolder;
@WebListener
public class ContextListener implements ServletContextListener  {
	
	@Override
	public void contextInitialized(ServletContextEvent sce) {
		System.out.println("Context Initailize .......");
		
		ServletContext context=sce.getServletContext();
	}

	@Override
	public void contextDestroyed(ServletContextEvent sce) {
		System.out.println("Context Destroyed .......");
		SecurityContext context = SecurityContextHolder.getContext();
		context.setAuthentication(null);

	SecurityContextHolder.clearContext();
		
	}
	

}
