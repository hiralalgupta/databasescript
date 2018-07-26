package com.ccc.service;

import java.util.List;
import java.util.Set;

import org.json.simple.JSONArray;

import com.ccc.model.County;
import com.ccc.model.Region;

public interface VehicleAddressService {
	List<Region> getRegionInfo();
	List<Integer> getZipInfo(int countyId);
	List<Integer> getPlus4Info(int countyId, int zip);
	List<Object> getVehcileMakeInfo();
	List<Object> getVehcileInfo(String modelMake);
	List<String> getPlateTypeInfo(int state);
	List<String> getCities(int countyId);
	List<Integer> getUniqueZipInfo(int state);
	List<Integer> getPlus4InfoBasedOnZip( int zip);
	List<County> getCountyData(int zip,int plus4info);
	List<Region> getRegionData(int countyId); 
	JSONArray getZipPlus4Info(int regionId, int countyId) throws Exception;
	List<String> getVehicleType(int state);
	Set<String> getZipPlus4(int zipPlus4, int regionId);
}
