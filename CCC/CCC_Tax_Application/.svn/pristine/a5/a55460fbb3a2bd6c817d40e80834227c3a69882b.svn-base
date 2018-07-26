package com.ccc.model;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;
@Entity
@Table(name="USERROLES")
public class UserRole {
@Id
@GeneratedValue(strategy = GenerationType.IDENTITY) 
@Column(name="URID")
private Long userroleid;
@ManyToOne
@JoinColumn(name="userid")
private User user;

@ManyToOne
@JoinColumn(name="roleid")
private Role role;



public Role getRole() {
	return role;
}

public void setRole(Role role) {
	this.role = role;
}

public Long getUserroleid() {
	return userroleid;
}

public User getUser() {
	return user;
}

public void setUser(User user) {
	this.user = user;
}


public void setUserroleid(Long userroleid) {
	this.userroleid = userroleid;
}




}
