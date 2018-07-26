package com.ccc.service;

import java.util.List;

import com.ccc.model.Role;
import com.ccc.model.User;
import com.ccc.model.UserRole;
public interface UserService {
	User findById(Long id);
    User findByUserName(String userName);
    public String findRoleByUserName(String userName);
	void save(User user);
	public List<User> getUserDetails(User user);
	boolean createUser(User user);
	boolean editUser(User user);
	List<Role> findRoles();
	boolean assignRole(UserRole userRole);
	Role getRoleById(Long id);
}
