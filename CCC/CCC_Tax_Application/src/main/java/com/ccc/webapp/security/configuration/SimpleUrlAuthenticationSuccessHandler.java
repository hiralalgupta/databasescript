package com.ccc.webapp.security.configuration;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.function.Function;

import javax.security.auth.callback.ConfirmationCallback;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.BeansException;
import org.springframework.beans.factory.NoSuchBeanDefinitionException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.beans.factory.config.ConfigurableListableBeanFactory;
import org.springframework.beans.factory.config.SingletonBeanRegistry;
import org.springframework.beans.factory.support.DefaultListableBeanFactory;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;
import org.springframework.context.ConfigurableApplicationContext;
import org.springframework.http.HttpMethod;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.web.DefaultRedirectStrategy;
import org.springframework.security.web.RedirectStrategy;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import org.springframework.stereotype.Component;

import com.ccc.model.User;
import com.ccc.rest.authentication.JwtAuthenticationRequest;
import com.ccc.rest.authentication.JwtAuthenticationResponse;
import com.ccc.service.RestTemplateService;
import com.ccc.webapp.util.AuthenticationToken;

public class SimpleUrlAuthenticationSuccessHandler implements AuthenticationSuccessHandler,ApplicationContextAware {
	
	@Value("${rest.server.url}")
	private String url;
	
	@Autowired
	RestTemplateService restTemplateService;
	
	ApplicationContext  applicationContext;
	/*@Autowired
	Function<String, AuthenticationToken> authenticationToken;*/
	
	 private RedirectStrategy redirectStrategy = new DefaultRedirectStrategy();
	@Override
	public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication) throws IOException, ServletException {
		
		handle(request, response, authentication);
	}
	 protected void handle(HttpServletRequest request, 
		      HttpServletResponse response, Authentication authentication) throws IOException {
		 		//Get and set Authentication Token 
		 		//setRestAuthenticationToken(authentication);
		 		
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
	        
	 
	        if (isTaxView(roles)) {
	            return "/taxCalculate";
	        } else if (isUser(roles) || isAdmin(roles)) {
	        	return "/modifyTax";
	        }else if (isZipLookupUser(roles)) {
	        	return "/lookUpTaxCalculate";
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
	    private boolean isZipLookupUser(List<String> roles) {
	        if (roles.contains("ROLE_ZIPLOOKUP")) {
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
	 
	    private boolean isTaxView(List<String> roles) {
	        if (roles.contains("ROLE_TAXVIEW")) {
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
		@Override
		public void setApplicationContext(ApplicationContext applicationContext) throws BeansException {
			this.applicationContext=applicationContext;
			
		}
		
		private void setRestAuthenticationToken(Authentication authentication){
			System.out.println("getting token form web service Url");
	        User user = (User) (UserDetails)authentication.getPrincipal();
	      
	        JwtAuthenticationRequest authenticationRequest= new JwtAuthenticationRequest(user.getUserName(), user.getPassword());
	        JwtAuthenticationResponse token=  restTemplateService.postDataToWS(url+"/authentication", HttpMethod.POST,authenticationRequest, JwtAuthenticationResponse.class);
	        //To achieve high security Register AuthenticationToken with final variable token 
	        AuthenticationToken tokenUtil= new AuthenticationToken(token.getToken());
	        /*AuthenticationToken tokenUtil= authenticationToken.apply(token.getToken());*/
	      
	        ConfigurableApplicationContext cApplicationContext = (ConfigurableApplicationContext)applicationContext;
	        
	        DefaultListableBeanFactory  factory= (DefaultListableBeanFactory) cApplicationContext.getBeanFactory();
	        //handle exception when bean is not found
	       try{
		       if(applicationContext.getBean(AuthenticationToken.class)!=null){
		    	   factory.destroySingleton("tokenUtil");
		       }
	       }catch(NoSuchBeanDefinitionException beanDefinitionException){
	    	   System.out.println("Exception in bean definition :not found bean");
	       }
	       //register singleton bean
	        factory.registerSingleton("tokenUtil", tokenUtil);
	        
	       System.out.println(" AuthenticationToken Bean registered..");
	       //validating Bean
	       /*AuthenticationToken tokenUtil2= (AuthenticationToken)applicationContext.getBean(AuthenticationToken.class);
	       System.out.println("Token "+tokenUtil2.getToken());*/
		}
}
