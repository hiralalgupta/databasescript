package com.ccc.service;

import java.util.HashMap;
import java.util.Map;

import org.springframework.http.HttpMethod;


public interface RestTemplateService {
	
	public <T> T getDataFromWS(String requestUrl, HttpMethod httpMethod,Class<T> clazz, Map<String, String> requestParameter);
	public <T> T postDataToWS(String url,HttpMethod httpMethod, Object requestEntity, Class<T> responseEntity);
	
	
}
