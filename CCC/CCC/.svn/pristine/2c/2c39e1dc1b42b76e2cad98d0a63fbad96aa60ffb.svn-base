package com.ccc.model;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;

import org.hibernate.annotations.DynamicInsert;
import org.hibernate.annotations.DynamicUpdate;

import com.ccc.jsonview.Views;
import com.fasterxml.jackson.annotation.JsonView;

@SuppressWarnings("deprecation")
@Entity
@Table(name = "USERS")
@DynamicUpdate
@DynamicInsert
public class User implements Serializable {
	private static final long serialVersionUID = 1L;
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@JsonView(Views.Public.class)
	@Column(name = "userid")
	private Long userId;
	@JsonView(Views.Public.class)
	@Column(name = "username")
	private String userName;
	@Column(name = "password")
	private String password;
	@Column(name = "CHALLENGEQUESTION")
	private String challengeQuestion;
	@Column(name = "CHALLENGEANSWER")
	private String challengeAnswer;
	@Column(name = "LASTLOGIN")
	private Date lastLogin;
	@Column(name = "LASTLOGINIP")
	private String lastloginip;
	@Column(name = "LASTLOGOUT")
	private Date lastLogout;
	@Column(name = "SUPERVISORID")
	private Long supervisorId;
	@Column(name = "FIRSTNAME")
	private String firstName;
	@Column(name = "LASTNAME")
	private String lastName;
	@Column(name = "MIDDLENAME")
	private String middleName;
	@Column(name = "SALUTATION")
	private String salutation;
	@Column(name = "LOCATION")
	private String location;
	@Column(name = "EMAIL")
	private String email;
	@Column(name = "PHONE")
	private String phone;
	@Column(name = "MOBILE")
	private String mobile;
	@Column(name = "MOBILEPROVIDER")
	private String mobileProvider;
	@Column(name = "EFFECTIVEDATE")
	private Date effectiveDate;
	@Column(name = "EXPIRATIONDATE")
	private Date expirationDate;
	@Column(name = "ACCOUNTSTATUS")
	private String accountStatus;
	@Column(name = "NOTES")
	private String notes;
/*	@ManyToOne
	@JoinColumn(name = "CLIENTID")
	private Client _client = null;*/
	@Column(name = "IP_ADDR_AUTH")
	private String ipAddrAuth;
	@Column(name = "SEED")
	private String seed;
	@Column(name = "DEBUG")
	private String debug;
	@Column(name = "PASSWORD_UPDATED_ON")
	private Date passwordUpdatedOn;
	@Column(name = "IS_INTERNAL")
	private String isInternal;

	public User() {
	}

	// UserId ,UserName and Password is necessary to authenticate User
	public User(User user) {
		this.userId = user.userId;
		this.userName = user.userName;
		this.password = user.password;
	}

	public User(Long userId, String userName, String password, String email,
			int enabled) {
		super();
		this.userId = userId;
		this.userName = userName;
		this.password = password;
	}
	public User(Long userId,String firstName,String email,String userName,String accountStatus){
		this.userId=userId;
		this.firstName = firstName;
		this.email = email;
		this.userName=userName;
		this.accountStatus=accountStatus;
		//this._client=_client;
		//this.password = password;
	}

	public Long getUserId() {
		return userId;
	}

	public void setUserId(Long userId) {
		this.userId = userId;
	}

	public String getUserName() {
		return userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public String getChallengeQuestion() {
		return challengeQuestion;
	}

	public void setChallengeQuestion(String challengeQuestion) {
		this.challengeQuestion = challengeQuestion;
	}

	public String getChallengeAnswer() {
		return challengeAnswer;
	}

	public void setChallengeAnswer(String challengeAnswer) {
		this.challengeAnswer = challengeAnswer;
	}

	public Date getLastLogin() {
		return lastLogin;
	}

	public void setLastLogin(Date lastLogin) {
		this.lastLogin = lastLogin;
	}

	public String getLastloginip() {
		return lastloginip;
	}

	public void setLastloginip(String lastloginip) {
		this.lastloginip = lastloginip;
	}

	public Date getLastLogout() {
		return lastLogout;
	}

	public void setLastLogout(Date lastLogout) {
		this.lastLogout = lastLogout;
	}

	public Long getSupervisorId() {
		return supervisorId;
	}

	public void setSupervisorId(Long supervisorId) {
		this.supervisorId = supervisorId;
	}

	public String getFirstName() {
		return firstName;
	}

	public void setFirstName(String firstName) {
		this.firstName = firstName;
	}

	public String getLastName() {
		return lastName;
	}

	public void setLastName(String lastName) {
		this.lastName = lastName;
	}

	public String getMiddleName() {
		return middleName;
	}

	public void setMiddleName(String middleName) {
		this.middleName = middleName;
	}

	public String getSalutation() {
		return salutation;
	}

	public void setSalutation(String salutation) {
		this.salutation = salutation;
	}

	public String getLocation() {
		return location;
	}

	public void setLocation(String location) {
		this.location = location;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getPhone() {
		return phone;
	}

	public void setPhone(String phone) {
		this.phone = phone;
	}

	public String getMobile() {
		return mobile;
	}

	public void setMobile(String mobile) {
		this.mobile = mobile;
	}

	public String getMobileProvider() {
		return mobileProvider;
	}

	public void setMobileProvider(String mobileProvider) {
		this.mobileProvider = mobileProvider;
	}

	public Date getEffectiveDate() {
		return effectiveDate;
	}

	public void setEffectiveDate(Date effectiveDate) {
		this.effectiveDate = effectiveDate;
	}

	public Date getExpirationDate() {
		return expirationDate;
	}

	public void setExpirationDate(Date expirationDate) {
		this.expirationDate = expirationDate;
	}

	public String getAccountStatus() {
		return accountStatus;
	}

	public void setAccountStatus(String accountStatus) {
		this.accountStatus = accountStatus;
	}

	public String getNotes() {
		return notes;
	}

	public void setNotes(String notes) {
		this.notes = notes;
	}

/*	public Client get_client() {
		return _client;
	}

	public void set_client(Client _client) {
		this._client = _client;
	}*/

	public String getIpAddrAuth() {
		return ipAddrAuth;
	}

	public void setIpAddrAuth(String ipAddrAuth) {
		this.ipAddrAuth = ipAddrAuth;
	}

	public String getSeed() {
		return seed;
	}

	public void setSeed(String seed) {
		this.seed = seed;
	}

	public String getDebug() {
		return debug;
	}

	public void setDebug(String debug) {
		this.debug = debug;
	}

	public Date getPasswordUpdatedOn() {
		return passwordUpdatedOn;
	}

	public void setPasswordUpdatedOn(Date passwordUpdatedOn) {
		this.passwordUpdatedOn = passwordUpdatedOn;
	}

	public String getIsInternal() {
		return isInternal;
	}

	public void setIsInternal(String isInternal) {
		this.isInternal = isInternal;
	}

}
