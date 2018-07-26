package com.apsutil.webapp.controller;



import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.MediaType;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.web.WebAppConfiguration;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.result.MockMvcResultHandlers;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

import org.springframework.web.context.WebApplicationContext;

import com.ccc.service.UserService;
import com.ccc.webapp.mvc.configuration.MvcConfig;



@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(classes=MvcConfig.class)
@WebAppConfiguration
public class SimpleControllerTest {
	
	@Autowired
	private WebApplicationContext context;

	private MockMvc mockMvc;
	
		
	@Before
	public void setup() {
		mockMvc = MockMvcBuilders
				.webAppContextSetup(context)
				.build();
	}
	@Test
	 public void test1() throws Exception {
		MediaType MEDIA_TYPE_PLAIN_UTF8 = new MediaType("text", "plain", java.nio.charset.Charset.forName("UTF-8"));
		System.out.println("Testing...1 *********************************************************************");
	        mockMvc.perform(get("/hello").accept(MEDIA_TYPE_PLAIN_UTF8))
	        		.andDo(MockMvcResultHandlers.print())
	                .andExpect(status().isOk())
	                //.andExpect(content().contentType(MediaType.TEXT_PLAIN))//check the content type
	                .andExpect(content().contentType(MEDIA_TYPE_PLAIN_UTF8))
	                .andExpect(content().string("Hello World!"));
	    }
	/*@Test
	 public void getUserDetails() throws Exception {
		System.out.println("Testing... 2");
		Integer id = 1;
        mockMvc.perform(
                get("/getuserDetails/{id}",id).accept(MediaType.APPLICATION_JSON))
                .andExpect(status().isOk())
                .andExpect(content().contentType("application/json;charset=UTF-8"))
                .andExpect(jsonPath("id").value(id));
	    }*/
	 
	 
	    /*@Configuration
	    public static class TestConfiguration {
	    	@Bean
	         public UserController userController() {
	            return new UserController();
	        }
	 
	    }*/
}
