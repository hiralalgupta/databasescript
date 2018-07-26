package com.ccc.webapp.mvc.configuration;

import java.util.List;

import org.springframework.context.MessageSource;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.support.ReloadableResourceBundleMessageSource;
import org.springframework.http.converter.HttpMessageConverter;
import org.springframework.http.converter.StringHttpMessageConverter;
import org.springframework.util.StringUtils;
import org.springframework.validation.Validator;
import org.springframework.validation.beanvalidation.LocalValidatorFactoryBean;
import org.springframework.web.servlet.LocaleResolver;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.EnableWebMvc;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.ViewControllerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurerAdapter;
import org.springframework.web.servlet.i18n.CookieLocaleResolver;
import org.springframework.web.servlet.i18n.LocaleChangeInterceptor;
import org.springframework.web.servlet.view.InternalResourceViewResolver;
import org.springframework.web.servlet.view.JstlView;
@Configuration
@EnableWebMvc
@ComponentScan(basePackages = { "com.ccc.*" })
public class MvcConfig extends WebMvcConfigurerAdapter {
	
	@Override
    public void addCorsMappings(CorsRegistry registry) {
        registry.addMapping("/**");
    }

	@Override
	public void addViewControllers(ViewControllerRegistry registry) {
	registry.addViewController("/home").setViewName("welcome");
	registry.addViewController("/").setViewName("welcome");
	registry.addViewController("/taxCalculate").setViewName("taxCalculate");
	registry.addViewController("/authentication").setViewName("authentication");
	//registry.addViewController("/admin").setViewName("admin");
	//registry.addViewController("/dba").setViewName("dba");
	registry.addViewController("/login").setViewName("login");
	registry.addViewController("/createprofile").setViewName("profilemanagement");
	registry.addViewController("/accessDenied").setViewName("accessDenied");
	}
	@Bean(name="viewResolver")
	public InternalResourceViewResolver viewResolver(){
		InternalResourceViewResolver resolver = new InternalResourceViewResolver();
	resolver.setPrefix("/WEB-INF/jsp/");
	resolver.setSuffix(".jsp");
	 resolver.setViewClass(JstlView.class);
	return resolver;
	}
	/*
     * Configure ResourceHandlers to serve static resources like CSS/ Javascript etc...
     */
	@Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        registry.addResourceHandler("/static/**").addResourceLocations("/static/");
    }
	@Override
	public void addInterceptors(InterceptorRegistry registry) {

		LocaleChangeInterceptor localeChangeInterceptor = new LocaleChangeInterceptor();
		localeChangeInterceptor.setParamName("lang");
		registry.addInterceptor(localeChangeInterceptor);
	}

	@Bean
	public LocaleResolver localeResolver() {

		CookieLocaleResolver cookieLocaleResolver = new CookieLocaleResolver();
		cookieLocaleResolver.setDefaultLocale(StringUtils.parseLocaleString("en"));
		return cookieLocaleResolver;
	}
	@Bean
	public MessageSource messageSource() {

		ReloadableResourceBundleMessageSource messageSource = new ReloadableResourceBundleMessageSource();
		messageSource.setBasenames("classpath:messages/messages", "classpath:messages/validation");
		// if true, the key of the message will be displayed if the key is not
		// found, instead of throwing a NoSuchMessageException
		messageSource.setUseCodeAsDefaultMessage(true);
		messageSource.setDefaultEncoding("UTF-8");
		// # -1 : never reload, 0 always reload
		messageSource.setCacheSeconds(0);
		return messageSource;
	}
	
	@Override
	public void extendMessageConverters(List<HttpMessageConverter<?>> converters) {
	    converters.stream()
	      .filter(c -> c instanceof StringHttpMessageConverter)
	      .findFirst().ifPresent(converters::remove);
	  }
	
	@Override
	   public Validator getValidator() {
	      LocalValidatorFactoryBean validator = new LocalValidatorFactoryBean();
	      validator.setValidationMessageSource(messageSource());
	      return validator;
	   }
	
	/* @Bean
	    public List<HttpMessageConverter<?>> configureMessageConverters() {
	    	List<HttpMessageConverter<?>> httpMessageConverters=new ArrayList<HttpMessageConverter<?>>();
	        httpMessageConverters.add(new MappingJackson2HttpMessageConverter());
	        ByteArrayHttpMessageConverter byteArrayHttpMessageConverter = new ByteArrayHttpMessageConverter();
	        List<MediaType> supportedApplicationTypes = new ArrayList<MediaType>();
	        MediaType pdfApplication = new MediaType("application","pdf");
	        supportedApplicationTypes.add(pdfApplication);
	        supportedApplicationTypes.add(MediaType.TEXT_PLAIN);
	        byteArrayHttpMessageConverter.setSupportedMediaTypes(supportedApplicationTypes);
	        httpMessageConverters.add(byteArrayHttpMessageConverter);
	        //httpMessageConverters.add(new Jaxb2RootElementHttpMessageConverter());
	        
	        return httpMessageConverters;
	    }*/
	

	/*@Override
	public void onStartup(ServletContext servletContext) throws ServletException {
		servletContext.setInitParameter("contextInitializerClasses", "xyz");
	}*/
}
