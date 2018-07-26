package com.apsutil.webapp.controller;

import org.junit.Assert; 
import org.junit.Before; 
import org.junit.Test;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc; 
import org.springframework.test.web.servlet.MvcResult; 
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders; 
import org.springframework.test.web.servlet.result.MockMvcResultHandlers; 
import org.springframework.test.web.servlet.result.MockMvcResultMatchers;

import com.ccc.webapp.controller.UserController;

import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.content;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;
import static org.springframework.test.web.servlet.setup.MockMvcBuilders.standaloneSetup; 

public class SimpleControllerStandaloneSetupTest {
	
	private MockMvc mockMvc; 
	 
    @Before 
    public void setUp() { 
    	UserController userController = new UserController(); 
        mockMvc = standaloneSetup(userController).build(); 
    } 
 
    @Test 
    public void testView() throws Exception { 
    	System.out.println("Testing in stanalone Setup******************************************");
    	MediaType MEDIA_TYPE_PLAIN_UTF8 = new MediaType("text", "plain", java.nio.charset.Charset.forName("UTF-8"));
        MvcResult result = mockMvc.perform(MockMvcRequestBuilders.get("/hello").accept(MEDIA_TYPE_PLAIN_UTF8))
        		 .andExpect(status().isOk())
        		  .andDo(MockMvcResultHandlers.print()) 
        		 .andExpect(content().contentType(MEDIA_TYPE_PLAIN_UTF8))
        		  .andExpect(content().string("Hello World!"))
               // .andExpect(MockMvcResultMatchers.view().name("user/view")) 
               // .andExpect(MockMvcResultMatchers.model().attributeExists("user")) 
               // .andDo(MockMvcResultHandlers.print()) 
                .andReturn(); 
 
    } 
}
