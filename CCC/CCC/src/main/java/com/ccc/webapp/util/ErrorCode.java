package com.ccc.webapp.util;

public enum ErrorCode {
	VALIDAION(0, "One or more mandatory field is missing"),
	MULTIPLECOUNTY(1, "More than one county found."),
	GENERIC(2, "No data found. Please report."),
	ADDRESSNOTFOUND(3, "Address Not Found. Please check the input address data."),
	VEHICLETYPENOTFOUND(4, "Vehicle type not found. Please select the Vehicle type.");

	  private final int code;
	  private final String description;

	  private ErrorCode(int code, String description) {
	    this.code = code;
	    this.description = description;
	  }

	  public String getDescription() {
	     return description;
	  }

	  public int getCode() {
	     return code;
	  }

	  @Override
	  public String toString() {
	    return code + ": " + description;
	  }
	}
