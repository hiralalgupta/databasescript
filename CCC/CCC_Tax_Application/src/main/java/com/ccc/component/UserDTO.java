package com.ccc.component;

import java.util.List;

import org.springframework.stereotype.Component;
import org.springframework.web.context.annotation.SessionScope;

import com.ccc.model.User;

@Component
@SessionScope
public class UserDTO {
	List <User> user;

	public List<User> getUser() {
		return user;
	}

	public void setUser(List<User> user) {
		this.user = user;
	}
	
   
}
