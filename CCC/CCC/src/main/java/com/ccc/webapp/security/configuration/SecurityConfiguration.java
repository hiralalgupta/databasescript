package com.ccc.webapp.security.configuration;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.config.annotation.method.configuration.EnableGlobalMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import org.springframework.security.web.session.HttpSessionEventPublisher;

import com.ccc.webapp.security.filter.JwtAuthenticationEntryPoint;
import com.ccc.webapp.security.filter.JwtAuthenticationTokenFilter;


@Configuration
@EnableWebSecurity
@EnableGlobalMethodSecurity(prePostEnabled=true)
public class SecurityConfiguration extends WebSecurityConfigurerAdapter {
	@Autowired
	@Qualifier("customUserDetailsService")
	UserDetailsService userDetailsService;
	@Autowired
	JwtAuthenticationEntryPoint unauthorizedHandler;
	
	@Autowired
	public void configureGlobalSecurity(AuthenticationManagerBuilder authenticationManagerBuilder) throws Exception{
		authenticationManagerBuilder.userDetailsService(userDetailsService);
		
	}
	@Bean
    public JwtAuthenticationTokenFilter authenticationTokenFilterBean() throws Exception {
        return new JwtAuthenticationTokenFilter();
    }
	
	protected void configure(HttpSecurity http) throws Exception {
		System.out.println("in security..........");
		/*RequestMatcher csrfRequestMatcher = new RequestMatcher() {

		      // Disable CSFR protection on the following urls:
		      private AntPathRequestMatcher[] requestMatchers = {
		          new AntPathRequestMatcher("/j_security_check"),
		                  
		      };

		      @Override
		      public boolean matches(HttpServletRequest request) {
		        // If the request match one url the CSFR protection will be disabled
		        for (AntPathRequestMatcher rm : requestMatchers) {
		          if (rm.matches(request)) { return true; }
		        }
		        return false;
		      } // method matches

		    };*/ 
		    
		 /*
System.out.println("in security..........");
		RequestMatcher csrfRequestMatcher = new RequestMatcher() {

		      // Disable CSFR protection on the following urls:
		      private AntPathRequestMatcher[] requestMatchers = {
		          new AntPathRequestMatcher("/j_security_check"),
		                  
		      };

		      @Override
		      public boolean matches(HttpServletRequest request) {
		        // If the request match one url the CSFR protection will be disabled
		        for (AntPathRequestMatcher rm : requestMatchers) {
		          if (rm.matches(request)) { return true; }
		        }
		        return false;
		      } // method matches

		    }; 
		http.csrf().requireCsrfProtectionMatcher(csrfRequestMatcher).and().authorizeRequests().antMatchers("/wel**","/tax**").permitAll()
		.antMatchers("/profile**").access("hasRole('USER') OR hasRole('ADMIN')")
		.antMatchers("/adm**","/componentconfig**","/comorbidity**","/typesof**","/define**").access(" hasRole('ADMIN')")
		.antMatchers("/logout").permitAll()
		//.antMatchers("/aps/**").access("hasRole('USER')")
		.and().formLogin().loginPage("/").loginProcessingUrl("/j_security_check").usernameParameter("username").passwordParameter("password").successHandler(getSimpleUrlAuthenticationSuccessHandler())
		.failureHandler(getCustomAuthenticationFailureHandler())
		.and().exceptionHandling().accessDeniedPage("/Access_Denied");
			*/   
		http.csrf().disable().exceptionHandling().authenticationEntryPoint(unauthorizedHandler).and().sessionManagement().sessionCreationPolicy(SessionCreationPolicy.STATELESS).
		and().authorizeRequests().antMatchers("/authentication","/welcome","/tax**").permitAll()
		.antMatchers("/ref**").access("hasRole('USER') OR hasRole('ADMIN')")
        .anyRequest().authenticated();
/*		http.addFilterBefore(authenticationTokenFilterBean(), UsernamePasswordAuthenticationFilter.class);*/
		//disable page caching
		//http.headers().cacheControl();
		/*.antMatchers("/profile**").access("hasRole('USER') OR hasRole('ADMIN')")
		.antMatchers("/adm**","/componentconfig**","/comorbidity**","/typesof**","/define**").access(" hasRole('ADMIN')")
		.antMatchers("/logout").permitAll()
		//.antMatchers("/aps/**").access("hasRole('USER')")
		.and().formLogin().loginPage("/").loginProcessingUrl("/j_security_check").usernameParameter("username").passwordParameter("password").successHandler(getSimpleUrlAuthenticationSuccessHandler())
		.failureHandler(getCustomAuthenticationFailureHandler())
		.and().exceptionHandling().accessDeniedPage("/Access_Denied");*/
		
		
		
	}
	 	
	
	@Bean
	public SimpleUrlAuthenticationSuccessHandler getSimpleUrlAuthenticationSuccessHandler(){
		SimpleUrlAuthenticationSuccessHandler authenticationSuccessHandler= new SimpleUrlAuthenticationSuccessHandler();
		return authenticationSuccessHandler;
	}
	@Bean
	public CustomAuthenticationFailureHandler getCustomAuthenticationFailureHandler(){
		CustomAuthenticationFailureHandler authenticationFailureHandler= new CustomAuthenticationFailureHandler();
		return authenticationFailureHandler;
	}
	@Bean
	public HttpSessionEventPublisher httpSessionEventPublisher() {
	    return new HttpSessionEventPublisher();
	}
	
	@Bean
    @Override
    public AuthenticationManager authenticationManagerBean() throws Exception {
        return super.authenticationManagerBean();
    }
}

