package com.ccc.model;

import java.io.Serializable;

import javax.validation.constraints.NotNull;

import org.hibernate.validator.constraints.NotEmpty;

public class FormData implements Serializable{

	private static final long serialVersionUID = -1587876302903152323L;
	
	@NotEmpty(message="Please send the transactionId ")
	private String transactionId;	
	@NotEmpty(message="Please enter state value")
	private String state;
	private String county;
	@NotNull(message="Please enter zip value")
	private Integer zip;
	@NotNull(message="Please enter plus4 value")
	private Integer plus4;
	@NotEmpty(message="Please enter vehicle make value")
	private String vehicleMake;
	@NotEmpty(message="Please enter vehicle model value")
	private String vehicleModel;
	@NotNull(message="Please enter vehicle year value")
	private Integer vehicleYear;
	private String vehicleTrim;
	@NotNull(message="Please enter vehicle value")
	private Double vehicleValue;
	@NotNull(message="Please enter vehicle MSRP value")
	private Double vehicleMSRPValue;
	private String plateType;
	private String city;
	private Integer weight;
	private Integer vehicleSeats;
	// @NotEmpty(message="Please enter vehicle type value")
	private String vehicleType;
	@NotEmpty(message="Please enter registration date value")
	private String registrationDate;
	@NotEmpty(message="Please enter totaled date value")
	private String lossDate;
	

	public String getTransactionId() {
		return transactionId;
	}
	public void setTransactionId(String transactionId) {
		this.transactionId = transactionId;
	}
	public String getState() {
		return state;
	}
	public void setState(String state) {
		this.state = state;
	}
	public String getCounty() {
		return county;
	}
	public void setCounty(String county) {
		this.county = county;
	}
	public Integer getZip() {
		return zip;
	}
	public void setZip(Integer zip) {
		this.zip = zip;
	}
	public Integer getPlus4() {
		return plus4;
	}
	public void setPlus4(Integer plus4) {
		this.plus4 = plus4;
	}
	public String getVehicleMake() {
		return vehicleMake;
	}
	public void setVehicleMake(String vehicleMake) {
		this.vehicleMake = vehicleMake;
	}
	public String getVehicleModel() {
		return vehicleModel;
	}
	public void setVehicleModel(String vehicleModel) {
		this.vehicleModel = vehicleModel;
	}
	public Integer getVehicleYear() {
		return vehicleYear;
	}
	public void setVehicleYear(Integer vehicleYear) {
		this.vehicleYear = vehicleYear;
	}
	public String getVehicleTrim() {
		return vehicleTrim;
	}
	public void setVehicleTrim(String vehicleTrim) {
		this.vehicleTrim = vehicleTrim;
	}
	public Double getVehicleValue() {
		return vehicleValue;
	}
	public void setVehicleValue(Double vehicleValue) {
		this.vehicleValue = vehicleValue;
	}
	public String getPlateType() {
		return plateType;
	}
	public void setPlateType(String plateType) {
		this.plateType = plateType;
	}
	public String getCity() {
		return city;
	}
	public void setCity(String city) {
		this.city = city;
	}
	public Integer getWeight() {
		return weight;
	}
	public void setWeight(Integer weight) {
		this.weight = weight;
	}
	public String getVehicleType() {
		return vehicleType;
	}
	public void setVehicleType(String vehicleType) {
		this.vehicleType = vehicleType;
	}
	public String getRegistrationDate() {
		return registrationDate;
	}
	public void setRegistrationDate(String registrationDate) {
		this.registrationDate = registrationDate;
	}

	public String getLossDate() {
		return lossDate;
	}
	public void setLossDate(String lossDate) {
		this.lossDate = lossDate;
	}
	
	public Double getVehicleMSRPValue() {
		return vehicleMSRPValue;
	}
	public void setVehicleMSRPValue(Double vehicleMSRPValue) {
		this.vehicleMSRPValue = vehicleMSRPValue;
	}
	
	public Integer getVehicleSeats() {
		return vehicleSeats;
	}
	public void setVehicleSeats(Integer vehicleSeats) {
		this.vehicleSeats = vehicleSeats;
	}
	
	@Override
	public String toString() {
		return "FormData [transactionId=" + transactionId + ", state=" + state + ", county=" + county + ", zip=" + zip
				+ ", plus4=" + plus4 + ", vehicleMake=" + vehicleMake + ", vehicleModel=" + vehicleModel
				+ ", vehicleYear=" + vehicleYear + ", vehicleTrim=" + vehicleTrim + ", vehicleValue=" + vehicleValue
				+ ", vehicleMSRPValue=" + vehicleMSRPValue + ", plateType=" + plateType + ", city=" + city + ", weight="
				+ weight + ", vehicleSeats=" + vehicleSeats + ", vehicleType=" + vehicleType + ", registrationDate="
				+ registrationDate + ", lossDate=" + lossDate + "]";
	}
	
	/*@Override
	public String toString() {
		return "FormData [transactionId=" + transactionId + ", state=" + state + ", county=" + county + ", zip=" + zip
				+ ", plus4=" + plus4 + ", vehicleMake=" + vehicleMake + ", vehicleModel=" + vehicleModel
				+ ", vehicleYear=" + vehicleYear + ", vehicleTrim=" + vehicleTrim + ", vehicleValue=" + vehicleValue + ", vehicleMSRPValue=" + vehicleMSRPValue
				+ ", plateType=" + plateType + ", city=" + city + ", weight=" + weight + ", vehicleType=" + vehicleType
				+ ", registrationDate=" + registrationDate + ", lossDate=" + lossDate + "]";
	}
	*/
	
	
}
