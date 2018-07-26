package com.ccc.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.ccc.customModel.StateTax;
import com.ccc.dao.StateTaxDao;
import com.ccc.service.TaxService;

@Service
@Transactional(readOnly = true)
public class TaxServiceImpl implements TaxService {

	@Autowired
	private StateTaxDao stateTaxDao;
	
	@Override
	public List<String> getStateTaxInformation(StateTax stateTax) {
		return stateTaxDao.getStateTaxInformation(stateTax);
	}

}
