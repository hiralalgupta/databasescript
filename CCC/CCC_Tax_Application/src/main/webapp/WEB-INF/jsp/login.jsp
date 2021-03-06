<!DOCTYPE html>
<%@ include file="/common/taglibs.jsp"%>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>CCC-Innodata</title>
</head>

<body onload="fillColor()">
<div class="ruleutility">
  <!-- Section start here -->
  <section id="main" >
    <div class="container-fluid">
      <!-- Page content -->
      <div class="row">
        <div class="col-md-4 col-md-offset-4 col-sm-8 col-sm-offset-2 mt60">
            <div class="quote"><h3>LOGIN</h3></div>
            	<hr>
	            <div class="login">
	            	<c:url var="loginUrl" value="/j_security_check" />
	            	<form class="navbar-form" action="${loginUrl}" method="post">
	            		<c:if test="${param.error != null}">
	            			<div class="alert alert-danger">
	            				<p>Invalid username and password.</p>
	            			</div>
	            		</c:if>
	            		<c:if test="${param.logout != null}">
	            			<div class="alert alert-success">
	            				<p>You have been logged out successfully.</p>
	            			</div>
	            		</c:if>
		            	<div class="row">
		                    <div class="form-group col-sm-12">
		                    	<input type="text" class="form-control username input-lg" id="username" name="username" placeholder="Username" required >
		                    </div>
		                    <a href="#" class="text-right">Forgot Username?</a>
		                    <div class="form-group col-sm-12">
		                    	<input type="password" class="form-control  password input-lg" id="password" name="password" autocomplete="off" placeholder="Password" required>
		                    </div>
		                    <a href="#" class="text-right">Forgot Password?</a>
		                    
		                   <input type="hidden" name="${_csrf.parameterName}"  value="${_csrf.token}" />
		                    
		                    <div class="form-group col-sm-12">
		                    	<button class="btn btn-success btn-lg" type="submit">LOGIN</button>
		                    </div>
		                 </div>
		              </form>
	            </div>    
            </div>
      </div>
      <!-- Page content End -->
    </div>
  </section>
  <!-- Section End here -->
</div>
</body>
</html>