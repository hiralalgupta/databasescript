package com.ccc.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.ccc.dao.UserDao;
import com.ccc.model.Role;
import com.ccc.model.User;
import com.ccc.model.UserRole;
import com.ccc.service.UserService;

@Service("userService")
@Transactional
public class UserServiceImpl implements UserService{
	@Autowired
	UserDao userDao;
	@Override
	public User findById(Long id) {
		// TODO Auto-generated method stub
		return userDao.findById(id);
	}

	@Override
	public User findByUserName(String userName) {
		// TODO Auto-generated method stub
		return userDao.findByUserName(userName);
	}

	@Override
	public String findRoleByUserName(String userName) {
		// TODO Auto-generated method stub
		return userDao.findRoleByUserName(userName);
	}

	@Override
	public void save(User user) {
		userDao.save(user);
	}
	@Override
	public List<User> getUserDetails(User user) {
		return userDao.getUserInfo(user);
	}
	@Override
	public boolean createUser(User user){
		return userDao.createUser(user);
	}
	@Override
	//@Transactional(readOnly=false)
	public boolean editUser(User user){
		return userDao.editUser(user);
	}
	@Override
	public List<Role> findRoles(){
		return userDao.findRoles();
	}
	@Override
	public boolean assignRole(UserRole userRole){
		return userDao.assignRole(userRole);
	}
	@Override
	public Role getRoleById(Long id){
		return userDao.getRoleById(id);
	}
}
