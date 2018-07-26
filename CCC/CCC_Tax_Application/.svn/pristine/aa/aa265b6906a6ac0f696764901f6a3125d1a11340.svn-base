package com.ccc.dao.impl;

import java.util.List;

import org.hibernate.Session;
import org.hibernate.query.Query;
import org.springframework.stereotype.Repository;

import com.ccc.customModel.StateTax;
import com.ccc.dao.AbstractDao;
import com.ccc.dao.StateTaxDao;
import com.ccc.model.User;

@Repository
public class StateTaxDaoImpl extends AbstractDao<Long, User> implements StateTaxDao {

	@Override
	public List<String> getStateTaxInformation(StateTax state) {
	String hql="SELECT DISTINCT T.RATE AS SALESTAX,T.RTA,FEESVALUE AS TITLEFEES,L.LOCATIONRATE, CASE WHEN L.ISRTA='Y' THEN T.RTA ELSE 0 END RTA1 FROM TAX T, REGION R,FEES F,COUNTY C,LOCATION L "
			+ "WHERE T.TOREGIONID=R.REGIONID AND F.REGIONID=R.REGIONID AND C.REGIONID=R.REGIONID AND L.COUNTYID=C.COUNTYID AND F.FEESID=1 AND R.NAME = :state AND C.NAME = :county "
					+ "AND L.ZIP = :zip  AND PLUS4= :plus4 ";
		
		Session session =getSession();
		Query<String> query=session.createNativeQuery(hql);
		query.setParameter("state", state.getState());
		query.setParameter("county", state.getCounty());
		query.setParameter("zip", state.getZip());
		query.setParameter("plus4", state.getPlus4());
		List<String> list=query.getResultList();
		return list;
	}
	
	
	
	

}
