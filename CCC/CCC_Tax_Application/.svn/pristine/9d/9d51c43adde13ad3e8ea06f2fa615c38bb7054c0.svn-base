package com.ccc.model;

import java.io.Serializable;
import java.util.List;

import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.Id;
import javax.persistence.OneToMany;
import javax.persistence.Table;

import com.fasterxml.jackson.annotation.JsonIgnore;

@Entity
@Table(name="REGION")
public class Region implements Serializable {
	
	private static final long serialVersionUID = 1L;

	@Id
	private int regionId;
	
	private String name;
	
	private String isCounty;
	
	@JsonIgnore
	private String isActive;
	
	
	@OneToMany(fetch = FetchType.EAGER, mappedBy = "_region")
	private List<County> counties; 

	public int getRegionId() {
		return regionId;
	}

	public void setRegionId(int regionId) {
		this.regionId = regionId;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getIsActive() {
		return isActive;
	}

	public void setIsActive(String isActive) {
		this.isActive = isActive;
	}
	
	public List<County> getCounties() {
		return counties;
	}

	public void setCounties(List<County> counties) {
		this.counties = counties;
	}

	public String getIsCounty() {
		return isCounty;
	}

	public void setIsCounty(String isCounty) {
		this.isCounty = isCounty;
	}

	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result
				+ ((counties == null) ? 0 : counties.hashCode());
		result = prime * result
				+ ((isActive == null) ? 0 : isActive.hashCode());
		result = prime * result
				+ ((isCounty == null) ? 0 : isCounty.hashCode());
		result = prime * result + ((name == null) ? 0 : name.hashCode());
		result = prime * result + regionId;
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
		Region other = (Region) obj;
		if (counties == null) {
			if (other.counties != null)
				return false;
		} else if (!counties.equals(other.counties))
			return false;
		if (isActive == null) {
			if (other.isActive != null)
				return false;
		} else if (!isActive.equals(other.isActive))
			return false;
		if (isCounty == null) {
			if (other.isCounty != null)
				return false;
		} else if (!isCounty.equals(other.isCounty))
			return false;
		if (name == null) {
			if (other.name != null)
				return false;
		} else if (!name.equals(other.name))
			return false;
		if (regionId != other.regionId)
			return false;
		return true;
	}

}
