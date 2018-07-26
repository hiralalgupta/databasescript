package com.ccc.webapp.security.configuration;

import javax.servlet.Filter;

import org.springframework.security.web.context.AbstractSecurityWebApplicationInitializer;
import org.tuckey.web.filters.urlrewrite.UrlRewriteFilter;

public class SecurityWebApplicationInitializer extends AbstractSecurityWebApplicationInitializer {
}
/*
 * <filter>
    <filter-name>springSecurityFilterChain</filter-name>
    <filter-class>org.springframework.web.filter.DelegatingFilterProxy</filter-class>
</filter>
 
<filter-mapping>
    <filter-name>springSecurityFilterChain</filter-name>
    <url-pattern>/*</url-pattern>
</filter-mapping>
 */