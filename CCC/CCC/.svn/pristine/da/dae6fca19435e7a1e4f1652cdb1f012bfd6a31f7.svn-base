package com.apsutil.dao.impl;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.Assert;

import com.ccc.dao.UserDao;
import com.ccc.model.User;




@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(classes = { HibernateTestConfiguration.class })
public  class UserDaoImplTest   {
	@Autowired
	private UserDao userDao;
	
	
	@SuppressWarnings("deprecation")
	@Test
	@Transactional
	public void findById(){
		Long id= new Long(1l);
		Assert.notNull(userDao.findById(id));
	} 
	@Test
	@Transactional
	public void findByUserName(){
		Assert.notNull(userDao.findByUserName("ankit"));
	}
	
	@Test
	@Transactional
	public void findRoleByUserName(){
		Assert.notNull(userDao.findRoleByUserName("admin"));
	} 
	@Test
	@Transactional(readOnly=false)
	public void save() throws Exception{
		User user= userDao.findById(1l);
		//user.setUserName("ram");
		user.setFirstName("Admin88 888Update");
		userDao.save(user);;
		//Client client=ClientDao.getClient(1l);
		//user.set_client(client);
		/*Client client= clientDao.getClient(6l);
		client.setClientName("Synodex245");
		clientDao.saveClient(client);*/
		
		
		
	}
}
