package com.ccc.webapp.mvc.configuration;

import javax.servlet.Filter;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;

import org.springframework.web.filter.CharacterEncodingFilter;
import org.springframework.web.servlet.support.AbstractAnnotationConfigDispatcherServletInitializer;
import org.tuckey.web.filters.urlrewrite.UrlRewriteFilter;

import com.ccc.webapp.security.configuration.SecurityConfiguration;
import com.opensymphony.sitemesh.webapp.SiteMeshFilter;

public class WebAppIntializer extends AbstractAnnotationConfigDispatcherServletInitializer   {

	@Override
	protected Class<?>[] getRootConfigClasses() {
		// TODO Auto-generated method stub
		return new Class[] { MvcConfig.class,SecurityConfiguration.class };
	}

	@Override
	protected Class<?>[] getServletConfigClasses() {
		// TODO Auto-generated method stub
		return new Class[] { MvcConfig.class };
	}

	@Override
	protected String[] getServletMappings() {
		// TODO Auto-generated method stub
		return new String[] { "/" };
	}
	@Override
    protected Filter[] getServletFilters() {
		UrlRewriteFilter urlRewriteFilter = new UrlRewriteFilter();
		
         /* Add filter configuration here if necessary
         */
        CharacterEncodingFilter characterEncodingFilter = new CharacterEncodingFilter();
        characterEncodingFilter.setEncoding("UTF-8");
        return new Filter[] {characterEncodingFilter,urlRewriteFilter,new SiteMeshFilter()};
    }
	@Override
	public void onStartup(ServletContext servletContext) throws ServletException {
		super.onStartup(servletContext);
		servletContext.setInitParameter("spring.profiles.active", "live");

		//Set multiple active profile
		//servletContext.setInitParameter("spring.profiles.active", "dev, testdb");
	}

	
}
