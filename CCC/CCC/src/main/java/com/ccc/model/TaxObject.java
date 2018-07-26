package com.ccc.model;

import java.io.Serializable;

public class TaxObject implements Serializable{

	private static final long serialVersionUID = -2828058060923325742L;
	
	private String name;
	private String value;
	private String url;
	private String type;
	private String unit;
	private String description;
	//private String rangeValue;
	private String status;
	private String taxValue;
	//private List<Object> listData;
	
	/*public List<Object> getListData() {
		return listData;
	}
	public void setListData(List<Object> listData) {
		this.listData = listData;
	}*/
	/*private String isText;
	
	public String getIsText() {
		return isText;
	}
	public void setIsText(String isText) {
		this.isText = isText;
	}*/
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getValue() {
		return value;
	}
	public void setValue(String value) {
		this.value = value;
	}
	public String getUrl() {
		return url;
	}
	public void setUrl(String url) {
		this.url = url;
	}
	public String getType() {
		return type;
	}
	public void setType(String type) {
		this.type = type;
	}
	public String getUnit() {
		return unit;
	}
	public void setUnit(String unit) {
		this.unit = unit;
	}
	public String getDescription() {
		return description;
	}
	public void setDescription(String description) {
		this.description = description;
	}
	/*public String getRangeValue() {
		return rangeValue;
	}
	public void setRangeValue(String rangeValue) {
		this.rangeValue = rangeValue;
	}*/
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	public String getTaxValue() {
		return taxValue;
	}
	public void setTaxValue(String taxValue) {
		this.taxValue = taxValue;
	}
	
}
