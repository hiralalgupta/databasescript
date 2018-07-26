package com.ccc.model;

import java.io.Serializable;

import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.OneToOne;
import javax.persistence.Table;

import com.fasterxml.jackson.annotation.JsonIgnore;

@Entity
@Table(name="COUNTY")
public class County implements Serializable{
	
	private static final long serialVersionUID = 7897600096245993668L;

	
	
	@Id
	private int countyId;
	
	private String name;
	
	private String isLocation;
	
	private String isCity;
	
	@JsonIgnore
	private String isActive;
	@JsonIgnore
	@ManyToOne
	@JoinColumn(name="regionId")
	private Region _region;
	
	public Region get_region() {
		return _region;
	}
	public void set_region(Region _region) {
		this._region = _region;
	}
	public int getCountyId() {
		return countyId;
	}
	public void setCountyId(int countyId) {
		this.countyId = countyId;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getIsLocation() {
		return isLocation;
	}
	public void setIsLocation(String isLocation) {
		this.isLocation = isLocation;
	}
	public String getIsCity() {
		return isCity;
	}
	public void setIsCity(String isCity) {
		this.isCity = isCity;
	}
	public String getIsActive() {
		return isActive;
	}
	public void setIsActive(String isActive) {
		this.isActive = isActive;
	}
	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + ((_region == null) ? 0 : _region.hashCode());
		result = prime * result + countyId;
		result = prime * result + ((isActive == null) ? 0 : isActive.hashCode());
		result = prime * result + ((isCity == null) ? 0 : isCity.hashCode());
		result = prime * result + ((isLocation == null) ? 0 : isLocation.hashCode());
		result = prime * result + ((name == null) ? 0 : name.hashCode());
		return result;
	}
	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		County other = (County) obj;
		if (_region == null) {
			if (other._region != null)
				return false;
		} else if (!_region.equals(other._region))
			return false;
		if (countyId != other.countyId)
			return false;
		if (isActive == null) {
			if (other.isActive != null)
				return false;
		} else if (!isActive.equals(other.isActive))
			return false;
		if (isCity == null) {
			if (other.isCity != null)
				return false;
		} else if (!isCity.equals(other.isCity))
			return false;
		if (isLocation == null) {
			if (other.isLocation != null)
				return false;
		} else if (!isLocation.equals(other.isLocation))
			return false;
		if (name == null) {
			if (other.name != null)
				return false;
		} else if (!name.equals(other.name))
			return false;
		return true;
	}
	
}
