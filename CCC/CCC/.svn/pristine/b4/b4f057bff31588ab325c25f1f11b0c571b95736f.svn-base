package com.ccc.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

import com.fasterxml.jackson.annotation.JsonIgnore;

@Entity
@Table(name="LOCATION")
public class Location implements Serializable {

	private static final long serialVersionUID = 7420718246900560387L;
	
	@Id
	@JsonIgnore
	private int locationId;
	@JsonIgnore
	private String address1;
	@JsonIgnore
	private String address2;
	@JsonIgnore
	private int addr_high;
	@JsonIgnore
	private int addr_low;

	/*@Column(name= "CITYID", nullable=true)
	private int cityId;*/
	@JsonIgnore
	private int countyId;
	@JsonIgnore
	private String isActive;
	@JsonIgnore
	private int regionId;
	private int zip;
	private int plus4;
	@JsonIgnore
	private int areaCode;
	private double locationRate;
	public int getLocationId() {
		return locationId;
	}
	public void setLocationId(int locationId) {
		this.locationId = locationId;
	}
	public String getAddress1() {
		return address1;
	}
	public void setAddress1(String address1) {
		this.address1 = address1;
	}
	public String getAddress2() {
		return address2;
	}
	public void setAddress2(String address2) {
		this.address2 = address2;
	}
	public int getAddr_high() {
		return addr_high;
	}
	public void setAddr_high(int addr_high) {
		this.addr_high = addr_high;
	}
	public int getAddr_low() {
		return addr_low;
	}
	public void setAddr_low(int addr_low) {
		this.addr_low = addr_low;
	}
/*	public int getCityId() {
		return cityId;
	}
	public void setCityId(int cityId) {
		this.cityId = cityId;
	}*/
	public int getCountyId() {
		return countyId;
	}
	public void setCountyId(int countyId) {
		this.countyId = countyId;
	}
	public String getIsActive() {
		return isActive;
	}
	public void setIsActive(String isActive) {
		this.isActive = isActive;
	}
	public int getRegionId() {
		return regionId;
	}
	public void setRegionId(int regionId) {
		this.regionId = regionId;
	}
	public int getZip() {
		return zip;
	}
	public void setZip(int zip) {
		this.zip = zip;
	}
	public int getPlus4() {
		return plus4;
	}
	public void setPlus4(int plus4) {
		this.plus4 = plus4;
	}

	public int getAreaCode() {
		return areaCode;
	}
	public void setAreaCode(int areaCode) {
		this.areaCode = areaCode;
	}
	public double getLocationRate() {
		return locationRate;
	}
	public void setLocationRate(double locationRate) {
		this.locationRate = locationRate;
	}
	
	
}
