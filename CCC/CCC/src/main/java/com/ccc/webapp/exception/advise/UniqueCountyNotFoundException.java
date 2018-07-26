package com.ccc.webapp.exception.advise;

import java.util.ArrayList;
import java.util.List;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ResponseStatus;

@ResponseStatus(value=HttpStatus.INTERNAL_SERVER_ERROR, reason="More than one county Found") 
public class UniqueCountyNotFoundException extends RuntimeException{

	private static final long serialVersionUID = -6220379907767550887L;
	
	private List<String> countyList = new ArrayList<String>();
	
	public UniqueCountyNotFoundException(List<String> id){
		super("More than one county Found");
		this.setCountyList(id);
	}

	public List<String> getCountyList() {
		return countyList;
	}
	
	public void setCountyList(List<String> countyList) {
		this.countyList = countyList;
	}

}
