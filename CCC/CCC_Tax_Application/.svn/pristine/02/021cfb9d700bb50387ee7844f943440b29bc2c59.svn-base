package com.ccc.exception;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import org.springframework.context.annotation.Scope;
import org.springframework.http.HttpStatus;
import org.springframework.http.HttpStatus.Series;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.http.client.ClientHttpResponse;
import org.springframework.http.converter.HttpMessageConverter;
import org.springframework.http.converter.json.MappingJackson2HttpMessageConverter;
import org.springframework.stereotype.Component;
import org.springframework.web.client.HttpMessageConverterExtractor;
import org.springframework.web.client.ResponseErrorHandler;

@Component
@Scope("singleton")
public class RestResponseErrorHandler<T>  implements ResponseErrorHandler{

	private HttpMessageConverterExtractor<T> delegate;
	
	public RestResponseErrorHandler() {
		
	}
	
	public RestResponseErrorHandler(Class<T> responseType) {
		//Set up the message Converters
		List<HttpMessageConverter<?>> httpMessageConverters=new ArrayList<HttpMessageConverter<?>>();
        MappingJackson2HttpMessageConverter messageConverter=new MappingJackson2HttpMessageConverter();
        List<MediaType> mediaTypes = new ArrayList<MediaType>();
        mediaTypes.add(MediaType.APPLICATION_JSON);
        messageConverter.setSupportedMediaTypes(mediaTypes);
        httpMessageConverters.add(messageConverter);
		this.delegate = new HttpMessageConverterExtractor<T>(responseType, httpMessageConverters);
	}
	
	@Override
	public boolean hasError(ClientHttpResponse response) throws IOException {
		// If a 400 or 500 series error is returned then we want to handle the error, otherwise not
		HttpStatus statusCode=response.getStatusCode();
		if(statusCode.series() == Series.CLIENT_ERROR || statusCode.series() == Series.SERVER_ERROR)
			return true;
		return false;
	}

	@Override
	public void handleError(ClientHttpResponse response) throws IOException {
		
		// Reference: http://www.baeldung.com/global-error-handler-in-a-spring-rest-api
		// Create a new generic Response Entity adding the unmarshalled response, headers and status code
		ResponseEntity<T> responseEntity=new ResponseEntity<>(this.delegate.extractData(response),response.getHeaders(),response.getStatusCode());
		
		// Throw the Exception
		throw new RestResponseException(responseEntity);
	}

}
