package com.ccc.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity
@Table(name="VEHICLETYPE")
public class VehicleType implements Serializable{

	private static final long serialVersionUID = 261648255494980282L;

	@Id
	private int vehicleTypeId;
	
	@Column(name = "name")
	private String name;

}
