package com.ccc.dao;

import java.util.List;

import com.ccc.model.Role;
import com.ccc.model.User;
import com.ccc.model.UserRole;

public interface UserDao {
	User findById(Long id);
    User findByUserName(String userName);
    public String findRoleByUserName(String userName);
	void save(User user);
	List<User> getUserInfo(User user);
	Boolean createUser(User user);
	Boolean editUser(User user);
	List<Role> findRoles();
	boolean assignRole(UserRole userRole);
	Role getRoleById(Long id);
}
