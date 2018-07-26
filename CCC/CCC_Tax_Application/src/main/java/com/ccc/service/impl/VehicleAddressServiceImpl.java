package com.ccc.service.impl;

import java.util.List;
import java.util.Set;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.ccc.dao.VehicleAddressDao;
import com.ccc.model.County;
import com.ccc.model.Region;
import com.ccc.service.VehicleAddressService;

@Service
@Transactional(readOnly =true)
public class VehicleAddressServiceImpl implements VehicleAddressService {

	@Autowired
	private VehicleAddressDao addressDao;
	
	@Override
	public List<Region> getRegionInfo() {
		return addressDao.getRegionInfo();
	}

	//@Cacheable(value = {"locationCache"})
	@Override
	public List<Integer> getZipInfo(int countyId) {
		return addressDao.getZipInfo(countyId);
	}
	
	@SuppressWarnings("unchecked")
	@Cacheable(value = {"zipplusCache"})
	@Override
	public JSONArray getZipPlus4Info(int regionId,int countyId) {
		List<Object[]> zipPlus4 = addressDao.getZipPlusInfo(regionId,countyId);
		JSONArray zipPlus = new JSONArray();
		
		for (Object[] objects : zipPlus4) {
			JSONObject json = new JSONObject();
			String zip = objects[0].toString();
			json.put("value",zip);
			json.put("text", zip);;
			zipPlus.add(json);
		}
		return zipPlus;
	}
	
	@Override
	public List<Object> getVehcileMakeInfo() {
		return addressDao.getVehcileMakeInfo();
	}

	@Override
	public List<Object> getVehcileInfo(String modelMake) {
		return addressDao.getVehcileInfo(modelMake);
	}

	@Override
	public List<String> getPlateTypeInfo(int state) {
		return addressDao.getPlateTypeInfo(state);
	}

	//@Cacheable(value = {"plus4Cache"})
	@Override
	public List<Integer> getPlus4Info(int countyId, int zip) {
		return addressDao.getPlus4Info(countyId, zip);
	}

	@Override
	public List<Integer> getUniqueZipInfo(int state) {
		// TODO Auto-generated method stub
		return addressDao.getUniqueZipInfo(state);
	}

	@Override
	public List<Integer> getPlus4InfoBasedOnZip(int zip) {
		// TODO Auto-generated method stub
		return addressDao.getPlus4InfoBasedOnZip(zip);
	}

	@Override
	public List<County> getCountyData(int zip, int plus4info) {
		return addressDao.getCountyData(zip, plus4info);
	}

	@Override
	public List<Region> getRegionData(int countyId) {
		// TODO Auto-generated method stub
		return addressDao.getRegionData(countyId);
	}
	@Override
	public List<String> getCities(int countyId) {
		return addressDao.getCities(countyId);
	}
	
	@Override
	public List<String> getVehicleType(int state) {
		return addressDao.getVehicleType(state);
	}
	
	@Override
	public Set<String> getZipPlus4(int zipPlus4, int regionId) {
		return addressDao.getZipPlus4(zipPlus4,regionId);
	}
}
