package com.ccc.model;

import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity
@Table(name="VEHICLEMODELS")
public class VehicleModels {
	
	@Id
	private int vehicleModelId;	
	private int vehicleMakeId;
	private int vehicleTypeId;
	private String modelName;
	private String description;
	
	public int getVehicleModelId() {
		return vehicleModelId;
	}
	public void setVehicleModelId(int vehicleModelId) {
		this.vehicleModelId = vehicleModelId;
	}
	public int getVehicleMakeId() {
		return vehicleMakeId;
	}
	public void setVehicleMakeId(int vehicleMakeId) {
		this.vehicleMakeId = vehicleMakeId;
	}
	public int getVehicleTypeId() {
		return vehicleTypeId;
	}
	public void setVehicleTypeId(int vehicleTypeId) {
		this.vehicleTypeId = vehicleTypeId;
	}
	public String getModelName() {
		return modelName;
	}
	public void setModelName(String modelName) {
		this.modelName = modelName;
	}
	public String getDescription() {
		return description;
	}
	public void setDescription(String description) {
		this.description = description;
	}
	
}
