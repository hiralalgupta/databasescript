package com.ccc.dao.impl;

import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

import javax.persistence.criteria.CriteriaBuilder;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.ParameterExpression;
import javax.persistence.criteria.Root;

import org.hibernate.Session;
import org.hibernate.query.Query;
import org.springframework.stereotype.Repository;

import com.ccc.dao.AbstractDao;
import com.ccc.dao.VehicleAddressDao;
import com.ccc.model.City;
import com.ccc.model.County;
import com.ccc.model.Location;
import com.ccc.model.Region;
import com.ccc.model.User;
import com.ccc.model.VehicleType;

@Repository
public class VehicleAddressDaoImpl extends AbstractDao<Long, User> implements VehicleAddressDao {

	@Override
	public List<Region> getRegionInfo() {
		Session session=getSession();
		CriteriaBuilder builder=session.getCriteriaBuilder();
		CriteriaQuery<Region> criteriaQuery = builder.createQuery(Region.class);
		Root<Region> root=criteriaQuery.from(Region.class);
		criteriaQuery.select(root);
		List<Region> user= session.createQuery(criteriaQuery).getResultList();
		
		return user;
	}
	
	@Override
	public List<Integer> getZipInfo(int countyId) {
		Session session=getSession();
		CriteriaBuilder builder=session.getCriteriaBuilder();
		CriteriaQuery<Integer> criteriaQuery = builder.createQuery(Integer.class);
		Root<Location> root=criteriaQuery.from(Location.class);
		criteriaQuery.select(root.<Integer>get("zip"));
		criteriaQuery.distinct(true);
		criteriaQuery.where(builder.equal(root.get("countyId"), countyId));
		List<Integer> user= session.createQuery(criteriaQuery).getResultList();
		
		return user;
	}
	@Override
	public List<Integer> getUniqueZipInfo(int state) {
		Session session=getSession();
		CriteriaBuilder builder=session.getCriteriaBuilder();
		CriteriaQuery<Integer> criteriaQuery = builder.createQuery(Integer.class);
		Root<Location> root=criteriaQuery.from(Location.class);
		criteriaQuery.select(root.<Integer>get("zip"));
		criteriaQuery.distinct(true);
		//criteriaQuery.where(builder.equal(root.get("regionId"), state));
		List<Integer> user= session.createQuery(criteriaQuery).getResultList();
		
		return user;
	}
	@Override
	public List<Integer> getPlus4Info(int countyId, int zip) {
		Session session=getSession();
		CriteriaBuilder builder=session.getCriteriaBuilder();
		CriteriaQuery<Integer> criteriaQuery = builder.createQuery(Integer.class);
		Root<Location> root=criteriaQuery.from(Location.class);
		criteriaQuery.select(root.<Integer>get("plus4"));
		criteriaQuery.distinct(true);
		criteriaQuery.where(builder.equal(root.get("countyId"), countyId), builder.equal(root.get("zip"), zip));
		List<Integer> user= session.createQuery(criteriaQuery).getResultList();
		
		return user;
	}
	@Override
	public List<Integer> getPlus4InfoBasedOnZip( int zip) {
		Session session=getSession();
		CriteriaBuilder builder=session.getCriteriaBuilder();
		CriteriaQuery<Integer> criteriaQuery = builder.createQuery(Integer.class);
		Root<Location> root=criteriaQuery.from(Location.class);
		criteriaQuery.select(root.<Integer>get("plus4"));
		criteriaQuery.distinct(true);
		criteriaQuery.where(builder.equal(root.get("zip"), zip));
		List<Integer> user= session.createQuery(criteriaQuery).getResultList();
		
		return user;
	}
	
	@Override
	public List<Object> getVehcileMakeInfo() {
	String hql="SELECT DISTINCT MM.modelMake, VM.modelName,MO.objectValue AS MODELBODY FROM ModelMake MM INNER JOIN Models M ON MM.modelMakeId=M.modelMakeId "
			+ "INNER JOIN VehicleModels VM ON VM.vehicleModelId=M.vehicleModelId "
			+ "LEFT OUTER JOIN ModelObjects MO ON MO.objectId=M.obj_body AND MO.objectName='BODY'";
	
	Session session =getSession();
	Query<Object> query=session.createQuery(hql);
	List<Object> list=query.getResultList();
	return list;
	}
	
	@Override
	public List<Object> getVehcileInfo(String modelMake) {
	String hql="SELECT DISTINCT  VM.modelName,M.year,M.trim FROM VehicleModels VM 	INNER JOIN Models M ON VM.vehicleModelId=M.vehicleModelId INNER JOIN ModelMake MM ON MM.modelMakeId=M.modelMakeId "
			+ "	WHERE UPPER(MM.modelMake)=UPPER(:modelMake) order by VM.modelName,M.year";
	
	Session session =getSession();
	Query<Object> query=session.createQuery(hql);
	query.setParameter("modelMake", modelMake);
	List<Object> list=query.getResultList();
	return list;
	}

	@Override
	public List<String> getPlateTypeInfo(int state) {
		String hql="SELECT F.feesName FROM Fees F,FeesCategory FC WHERE FC.feesCategoryId=4 AND F.feesCategoryId=FC.feesCategoryId AND REGIONID=:stateId order by F.feesName";
		
		Session session =getSession();
		Query<String> query=session.createQuery(hql);
		query.setParameter("stateId", state);
		List<String> list=query.getResultList();
		return list;
	}

	@Override
	public List<County> getCountyData(int zip, int plus4info) {
		//String hql=" SELECT DISTINCT countyId,regionId FROM Location WHERE zip=:zip AND plus4=:plus4";
		Session session =getSession();
		/*Query<Location> query=session.createQuery(hql);
		query.setParameter("zip", zip);
		query.setParameter("plus4", plus4info);
		List<Location> list=query.getResultList();*/
		CriteriaBuilder builder=session.getCriteriaBuilder();
		CriteriaQuery<Location> criteriaQuery = builder.createQuery(Location.class);
		Root<Location> locroot=criteriaQuery.from(Location.class);
		criteriaQuery.select(locroot);
		criteriaQuery.distinct(true);
		ParameterExpression<Integer> zipNameParameter = builder.parameter(Integer.class );
		ParameterExpression<Integer> plus4NameParameter = builder.parameter(Integer.class );
		criteriaQuery.where(builder.equal(locroot.get("zip"), zipNameParameter),builder.equal(locroot.get("plus4"), plus4NameParameter));
		List<Location> locList= session.createQuery(criteriaQuery).setParameter(zipNameParameter, zip).setParameter(plus4NameParameter, plus4info).getResultList();
		
		
		List<Integer>clist=locList.stream().map(Location::getCountyId).collect(Collectors.toList());
		//Getting County

	    //The string builder used to construct the string
	    /*StringBuilder commaSepValueBuilder = new StringBuilder();
	 
	    //Looping through the list
	    for ( int i = 0; i< locList.size(); i++){
	    	Location loc= locList.get(i);
	      //append the value into the builder
	      commaSepValueBuilder.append(String.valueOf(loc.getCountyId()));
	       
	      //if the value is not the last element of the list
	      //then append the comma(,) as well
	      if ( i != locList.size()-1){
	        commaSepValueBuilder.append(",");
	      }
	    }
	    System.out.println("sdgdfsgdfg    "+commaSepValueBuilder);*/
	    String chql="SELECT C FROM County C WHERE C.countyId IN (:countyId)";
		Query<County> countyQuery=session.createQuery(chql);
		countyQuery.setParameterList("countyId", clist);
		List<County> countylist=countyQuery.getResultList();
		
		
		return countylist;
		
	}

	@Override
	public List<Region> getRegionData(int countyId) {
		String hql="SELECT R FROM Region R WHERE R.regionId IN ( SELECT DISTINCT regionId FROM Location WHERE countyId=:countyId)";
		Session session =getSession();
		Query<Region> query=session.createQuery(hql);
		query.setParameter("countyId", countyId);
		List<Region> list=query.getResultList();
		return list;
	}
	@Override
	public List<String> getCities(int countyId) {
		Session session=getSession();
		CriteriaBuilder builder=session.getCriteriaBuilder();
		CriteriaQuery<String> criteriaQuery = builder.createQuery(String.class);
		Root<City> root=criteriaQuery.from(City.class);
		criteriaQuery.select(root.<String>get("name"));
		criteriaQuery.distinct(true);
		criteriaQuery.where(builder.equal(root.get("countyId"), countyId));
		List<String> cities= session.createQuery(criteriaQuery).getResultList();
		
		return cities;
	}
	
	@Override
	public List<String> getVehicleType(int regionId) {
		String hql="SELECT V.NAME FROM `VEHICLETYPE` V WHERE V.VEHICLETYPEID IN (SELECT VT.VEHICLETYPEID FROM VEHICLETYPEFEES VT,"
				+ " FEES F WHERE F.FEESID=VT.FEESID AND F.REGIONID=:regionId) AND V.ISACTIVE='Y'";
		Session session =getSession();
		Query<String> query=session.createSQLQuery(hql);
		query.setParameter("regionId", regionId);		
		List<String> vehicleType= query.getResultList();		
		return vehicleType;
	}
	
	@Override
	public List<Object[]> getZipPlusInfo(int regionId,int countyId) {
		/*String hql="SELECT zipplus4,group_concat(locationId) as locat, COUNT(1) AS RECORED FROM  Location L" 
				+ " WHERE regionId=:regionId AND countyId=:countyId GROUP BY zipplus4";*/
		
		String hql="SELECT  CONCAT(L.ZIP,'-',L.PLUS4) AS ZIPPLUS4,GROUP_CONCAT(LOCATIONID) ,COUNT(1) AS RECORED FROM  LOCATION L " + 
				"WHERE    REGIONID=:regionId AND COUNTYID=:countyId GROUP BY ZIPPLUS4";
		Session session =getSession();
		Query query=session.createSQLQuery(hql);
		query.setParameter("countyId", countyId);
		query.setParameter("regionId", regionId);
		List<Object[]> list=query.getResultList();
		return list;
	}

	@Override
	public Set<String> getZipPlus4(int zip, int regionId) {
		Session session=getSession();
		String hql="SELECT DISTINCT  L.ZIP,L.ZIP4LOW,L.ZIP4HIGH FROM LOCATION L WHERE REGIONID=:regionId AND L.ZIP=:zip";
		Query query=session.createNativeQuery(hql);
		query.setParameter("regionId", regionId);
		query.setParameter("zip", zip);
		List<Object[]> list=query.getResultList();
		
		return getZipPlus4Data(zip, list);
		
	}
	
	private Set<String> getZipPlus4Data(int zip,List<Object[]> resultSet){
		Set<String> uniqueZipPlus4 = new HashSet<String>();
		resultSet.forEach(zipplus4 -> uniqueZipPlus4.addAll(getFormatedZipData(zipplus4[0].toString(),Integer.valueOf(zipplus4[1].toString()),Integer.valueOf(zipplus4[2].toString()))));
		return uniqueZipPlus4;
		
	}
	
	private Set<String> getFormatedZipData(String zip,int start, int end) {
		Set<String> uniqueZipPlus4 = new HashSet<String>();
		for(int i=start; i<=end;i++) {
			String data = zip+"-"+i;
			uniqueZipPlus4.add(data);
		}
		return uniqueZipPlus4;
	}
		
}
	
