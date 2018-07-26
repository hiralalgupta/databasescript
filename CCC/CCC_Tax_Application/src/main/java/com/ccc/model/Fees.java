package com.ccc.model;

import java.io.Serializable;

import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity
@Table(name="FEES")
public class Fees implements Serializable{
	
	private static final long serialVersionUID = -289771927004481646L;

	@Id
	private int feesId;
	
	private String feesName;
	
	private double feesValue;
	
	private int feesCategoryId;
	
	private String feesUrl;

	public int getFeesId() {
		return feesId;
	}

	public void setFeesId(int feesId) {
		this.feesId = feesId;
	}

	public String getFeesName() {
		return feesName;
	}

	public void setFeesName(String feesName) {
		this.feesName = feesName;
	}

	public double getFeesValue() {
		return feesValue;
	}

	public void setFeesValue(double feesValue) {
		this.feesValue = feesValue;
	}

	public int getFeesCategoryId() {
		return feesCategoryId;
	}

	public void setFeesCategoryId(int feesCategoryId) {
		this.feesCategoryId = feesCategoryId;
	}

	public String getFeesUrl() {
		return feesUrl;
	}

	public void setFeesUrl(String feesUrl) {
		this.feesUrl = feesUrl;
	}
	
	
}
