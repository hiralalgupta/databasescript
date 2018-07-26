package com.ccc.dao;

import java.io.Serializable;
import java.io.Serializable;

import java.lang.reflect.ParameterizedType;
 
import org.hibernate.Criteria;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;
import org.hibernate.resource.transaction.spi.TransactionStatus;
import org.springframework.beans.factory.annotation.Autowired;
public class AbstractDao<PK extends Serializable, T> {
    
   private final Class<T> persistentClass;
    
   @SuppressWarnings("unchecked")
   public AbstractDao(){
       this.persistentClass =(Class<T>) ((ParameterizedType) this.getClass().getGenericSuperclass()).getActualTypeArguments()[1];
   }
    
   @Autowired
   private SessionFactory sessionFactory;

   protected Session getSession(){
       return this.sessionFactory.getCurrentSession();
   }

   @SuppressWarnings("unchecked")
   public T getByKey(PK key) {
       return (T) getSession().get(persistentClass, key);
   }
   public void save(T entity) {
	   getSession().save(entity);
   }
   public void persist(T entity) {
	   Session session=null;
			   try{
			   session= getSession();
		       session.persist(entity);
			   }catch ( Exception e ) {
				    // we may need to rollback depending on
				    // where the exception happened
				    if (  session !=null &&
				    		(session.getTransaction().getStatus() == TransactionStatus.ACTIVE
				            || session.getTransaction().getStatus() == TransactionStatus.MARKED_ROLLBACK )) {
				        session.getTransaction().rollback();
				    }
				    // handle the underlying error
				}
				finally {
					if(session!=null)
				    session.close();
				}
   }

   public void delete(T entity) {
	   Session session=null;
	   try{
	   session= getSession();
       session.delete(entity);
	   }catch ( Exception e ) {
		    // we may need to rollback depending on
		    // where the exception happened
		    if (  session !=null &&
		    		(session.getTransaction().getStatus() == TransactionStatus.ACTIVE
		            || session.getTransaction().getStatus() == TransactionStatus.MARKED_ROLLBACK )) {
		        session.getTransaction().rollback();
		    }
		    // handle the underlying error
		}
		finally {
			if(session!=null)
		    session.close();
		}
   }
     
   
   public void saveOrUpdate(T obj) {
	   Session session=null;
			   try{
			   session= getSession();
		       session.saveOrUpdate(obj);
			   }catch ( Exception e ) {
				    // we may need to rollback depending on
				    // where the exception happened
				    if (  session !=null &&
				    		(session.getTransaction().getStatus() == TransactionStatus.ACTIVE
				            || session.getTransaction().getStatus() == TransactionStatus.MARKED_ROLLBACK )) {
				        session.getTransaction().rollback();
				    }
				    // handle the underlying error
				}
				finally {
					if(session!=null)
				    session.close();
				}
   }
}
