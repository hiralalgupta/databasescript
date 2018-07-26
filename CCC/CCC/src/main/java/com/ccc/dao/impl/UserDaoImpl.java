package com.ccc.dao.impl;

import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.Stream;

import javax.persistence.criteria.CompoundSelection;
import javax.persistence.criteria.CriteriaBuilder;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Predicate;
import javax.persistence.criteria.Root;

import org.hibernate.Criteria;
import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.query.Query;
import org.springframework.stereotype.Repository;

import com.ccc.dao.AbstractDao;
import com.ccc.dao.UserDao;
import com.ccc.model.Role;
import com.ccc.model.User;
import com.ccc.model.UserRole;

@Repository("userDao")
public class UserDaoImpl extends AbstractDao<Long, User> implements UserDao {

	@Override
	public User findById(Long id) {
		// TODO Auto-generated method stub
		 return getByKey(id);
	}

	@Override
	public User findByUserName(String userName) {
		Session session=getSession();
		CriteriaBuilder builder=session.getCriteriaBuilder();
		CriteriaQuery<User> criteriaQuery = builder.createQuery(User.class);
		Root<User> root=criteriaQuery.from(User.class);
		criteriaQuery.select(root);
		criteriaQuery.where(builder.equal(root.get("userName"), userName));
		User user=session.createQuery(criteriaQuery).getSingleResult();
		
		/*Criteria criteria = createEntityCriteria();
        criteria.add(Restrictions.eq("userName", userName));
        return (User) criteria.uniqueResult();*/
		return user;
	}
	
	@Override
	public void save(User user){
		Session session = getSession();
		session.saveOrUpdate(user);
		//session.flush();
	}

	@SuppressWarnings("unchecked")
	@Override
	public String findRoleByUserName(final String userName) {
		String hql="SELECT R FROM UserRole UR INNER JOIN Role R on R.roleid=UR.role.roleid INNER JOIN User U on U.userId=UR.user.userId where U.userName=:userName";
/*
		Session session=getSession();
		CriteriaBuilder builder=session.getCriteriaBuilder();
		CriteriaQuery<User> criteriaQuery = builder.createQuery(User.class);*/
		
		Query<Role> query = getSession().createQuery(hql,Role.class);
		query.setParameter("userName", userName);
		Stream<Role> stream= query.getResultList().stream();
		String roleName=stream.map(r->r.getRoleName()).collect(Collectors.joining(","));
		return roleName;
	}
	//method for get user details ....
	@SuppressWarnings("unchecked")
	@Override
	public List<User> getUserInfo(User userData){
		String name=userData.getFirstName();
    	String email=userData.getEmail();
    	String userName=userData.getUserName();
		CriteriaBuilder builder=getSession().getCriteriaBuilder();
		 CriteriaQuery<User> criteria=builder.createQuery(User.class);
		 Root<User> root=criteria.from(User.class);
		 CompoundSelection<User> projection = builder.construct(User.class,root.get("userId"), root.get("firstName"),root.get("email"),root.get("userName"),root.get("accountStatus"),root.get("_client"));
		// Path<String> agePath = root.get( User.firstName );
		 Predicate nameAndEmailCondition=builder.and(builder.equal(root.get("firstName"), name),builder.equal(root.get("email"),email));
		 Predicate nameAndUserNameCondition=builder.and(builder.equal(root.get("firstName"), name),builder.equal(root.get("userName"),userName));
		 Predicate emailAndUserNameCondition=builder.and(builder.equal(root.get("email"), email),builder.equal(root.get("userName"),userName));
		 Predicate nameEmailAndUserName=builder.and(nameAndEmailCondition, builder.equal(root.get("userName"),userName));
		 if(name!=null && ( email==null || email.equals("")) && (userName==null || userName.equals(""))){
			 criteria.select(projection).where(builder.equal(root.get("firstName"), name));
		}
		 else if((name==null || name.equals("")) && (email!=null) && (userName==null || userName.equals(""))){
			criteria.select(projection).where(builder.equal(root.get("email"), email));
		}
		 else if((name==null || name.equals("")) && (email==null || email.equals(""))  && userName!=null){
				criteria.select(projection).where(builder.equal(root.get("userName"), userName));
		}
		 else if(name!=null && ( email!=null) && (userName==null || userName.equals(""))){
				 criteria.select(projection).where(nameAndEmailCondition);
			}
		 else if(name!=null && (email==null || email.equals("")) && (userName!=null )){
				 criteria.select(projection).where(nameAndUserNameCondition);
			}
		 else if((name==null || name.equals("")) && (email!=null) && (userName!=null )){
				 criteria.select(projection).where(emailAndUserNameCondition);
			}
		else{
			criteria.select(projection).where(nameEmailAndUserName);
		}
		List<User> results=getSession().createQuery(criteria).getResultList();
		return results;
	}
	//method for save new user details on database...
	@Override
	public Boolean createUser(User user){
		Session session = getSession();
		CriteriaBuilder builder=session.getCriteriaBuilder();
		CriteriaQuery<User> criteria=builder.createQuery(User.class);
		Root<User> root=criteria.from(User.class);
		Predicate userNameAndEmailCondition=builder.and(builder.equal(root.get("email"), user.getEmail()),builder.equal(root.get("userName"),user.getUserName()));
		Predicate userNameOrEmailCondition=builder.or(builder.equal(root.get("email"), user.getEmail()),builder.equal(root.get("userName"),user.getUserName()));
		if(user.getEmail()!=null || user.getUserName()!=null){
			 criteria.select(root).where(userNameOrEmailCondition);
		}
		else{
			 criteria.select(root).where(userNameAndEmailCondition);
		}
		List<User> results=getSession().createQuery(criteria).getResultList();
		if(results.size()==0){
			session.save(user);
		}
		//System.out.println("result status for duplicate is"+results.size());
		if(results.size()!=0){
			return false;
			
		}
		else
		return true;
	}
	//method for update user details..
	@Override
	public Boolean editUser(User user){
		try{
			Session session = getSession();
			session.update(user);
			return true;
		}catch(HibernateException he){
			he.printStackTrace();
			throw he;
		}
		
	}
	//find roles..
	@Override
	public List<Role> findRoles(){
		Criteria crit = getSession().createCriteria(Role.class);
		List<Role> results = crit.list();
		return results;
	}
	//method for save user role in database...
	@Override
	public boolean assignRole(UserRole userRole){
		UserRole userRoleList=new UserRole();
		Long userId=userRole.getUser().getUserId();
		Long roleId=userRole.getRole().getRoleid();
		Session session = getSession();
		CriteriaBuilder builder=session.getCriteriaBuilder();
		CriteriaQuery<UserRole> criteria=builder.createQuery(UserRole.class);
		Root<UserRole> root=criteria.from(UserRole.class);
		//Predicate userIdAndroleIdCondition=builder.and(builder.equal(root.get("user"),userRole.getUser()),builder.equal(root.get("role"),userRole.getRole()));
		//Predicate userIdAndroleIdCondition=builder.and(builder.equal(root.get("user"));
		if(userId!=null && roleId!=null){
			 criteria.select(root).where(builder.equal(root.get("user"),userRole.getUser()));
		}
		List<UserRole> results=session.createQuery(criteria).getResultList();
		userRoleList.setUser(userRole.getUser());
		userRoleList.setRole(userRole.getRole());
		for (UserRole temp : results) {
			userRole.setUserroleid(temp.getUserroleid());
		}
		if(results.size()==0){
			session.save(userRole);
		}
		else{
			session.clear();
		getSession().update(userRole);
		}
		if(results.size()!=0){
			return false;
			
		}
		else
		return true;
	}
	//find Role object based on roleId...
	@Override
	public Role getRoleById(Long roleId){
		Role role = (Role) getSession().get(Role.class, roleId);
		return role;
		
	}
}

