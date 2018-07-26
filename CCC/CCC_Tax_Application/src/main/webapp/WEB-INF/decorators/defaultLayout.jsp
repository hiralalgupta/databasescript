<!DOCTYPE html>
<%@ include file="/common/taglibs.jsp"%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <meta name="description" content="">
    	<meta name="author" content="Geoffroy Warin">
        
        <title><dec:title default="Client Aps Utility" /></title> 		
		<!-- Fevicon -->
		<link rel="shortcut icon" href="static/images/favicon.ico" type="image/x-icon">
		<link rel="icon" href="static/images/favicon.ico" type="image/x-icon">
		<!-- Bootstrap core CSS -->
		<link href="static/css/bootstrap.min.css" rel="stylesheet">
		<link rel="stylesheet" type="text/css" media="screen" href="static/css/font-awesome.min.css">
		<link rel="stylesheet" type="text/css" media="screen" href="static/css/overlay/overlay.css">
		 <link rel="stylesheet" href="https://ajax.googleapis.com/ajax/libs/angular_material/1.1.0/angular-material.min.css">
		 <link href="static/css/select/selectize.css" rel="stylesheet">
		 <link href="static/css/select/autocomplete.css" rel="stylesheet">
		<!-- Custom styles for this template -->
		<link href="static/css/style.css" rel="stylesheet">
		
        <!-- HTML5 shim, for IE6-8 support of HTML5 elements -->
		<!--[if lt IE 9]>
      		<script src="http://html5shim.googlecode.com/svn/trunk/html5.js"></script>
    	<![endif]-->
    	<style>
    	#wrap{padding-bottom: 40px !important;
    padding-top: 55px !important;
 }
    #header {
    border: 0;
    min-height: auto;
    padding: 10px 0;
    margin: 0;
}
.navbar-inverse .navbar-nav > li > a{padding-top: 10px;
    padding-bottom: 10px;}
    	</style>
    			<dec:head />
    			
    </head>
    
    <body  ng-app="myapp">
    
    <div id="wrap">
    	
		<!---Add header jsp file-->
        <%@include file="header.jsp"%>
				
		<!--Body content-->
		<dec:body />
			
		<!---Add footer jsp file-->
		<%@include file="footer.jsp"%>
			
	</div>
		
		<!-- #Wrap End -->
<!-- Js Placed at the end of the document so the pages load faster -->
<!-- <script src="static/js/jquery-2.1.1.js"></script> -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
<script src="static/js/custom.js"></script>
<!-- <script src="http://code.jquery.com/jquery-latest.min.js" type="text/javascript"></script> -->
<!-- <script src="https://ajax.googleapis.com/ajax/libs/angularjs/1.6.3/angular.js"></script> -->
	<script src="https://ajax.googleapis.com/ajax/libs/angularjs/1.5.5/angular.min.js"></script>
     <script src="https://ajax.googleapis.com/ajax/libs/angularjs/1.5.5/angular-animate.min.js"></script>
  <script src="https://ajax.googleapis.com/ajax/libs/angularjs/1.5.5/angular-aria.min.js"></script>
  <script src="https://ajax.googleapis.com/ajax/libs/angularjs/1.5.5/angular-messages.min.js"></script>
  <script src="https://s3-us-west-2.amazonaws.com/s.cdpn.io/t-114/svg-assets-cache.js"></script>
 <script src="https://cdn.gitcdn.link/cdn/angular/bower-material/v1.1.5/angular-material.js"></script>
<!--   <script src="static/js/angular-1.2.16.js"></script>  -->  
<!-- <script src="https://ajax.googleapis.com/ajax/libs/angularjs/1.2.13/angular.js"></script>  --> 
<script src="static/js/bootstrap.min.js" type="text/javascript"></script>
<!-- <script src="static/js/angular.min.js.map" type="text/javascript"></script> -->
<script async="" src="https://cdn.rawgit.com/eligrey/FileSaver.js/e9d941381475b5df8b7d7691013401e171014e89/FileSaver.min.js"></script>
<script src="static/js/app.js" type="text/javascript"></script>
<script src="static/js/angular-sanitize.min.js" type="text/javascript"></script>
  <!-- <script src="//angular-ui.github.io/bootstrap/ui-bootstrap-tpls-1.3.3.js"></script> -->
  <!-- <script src="//angular-ui.github.io/bootstrap/ui-bootstrap-tpls-0.14.3.min.js"></script> -->
  <script src="//angular-ui.github.io/bootstrap/ui-bootstrap-tpls-0.12.1.min.js"></script>
<!-- <script src="static/js/angular-sanitize.min.js.map" type="text/javascript"></script> -->
<!-- <script src="https://ajax.googleapis.com/ajax/libs/angularjs/1.5.5/angular-route.min.js"></script> -->
<script src="static/js/controllers.js" type="text/javascript"></script>

<script src="static/js/select/angular-selectize.js" type="text/javascript"></script>
<script src="static/js/select/selectize.js" type="text/javascript"></script>

<script type="text/javascript" src="<c:url value='static/js/custom/angular-filter-0.5.16.js'/>"></script>
<script type="text/javascript" src="<c:url value='static/js/global_helper.js'/>"></script> 
<script type="text/javascript" src="static/js/select/autocomplete.js"></script>
<script type="text/javascript" src="static/js/app.js"></script>
<script type="text/javascript" src="<c:url value='static/js/rule/rule_controller.js'/>"></script>
<script type="text/javascript" src="<c:url value='static/js/rule/rule_service.js'/>"></script>
<script type="text/javascript" src="<c:url value='static/js/tax/tax_controller.js'/>"></script>
<script type="text/javascript" src="<c:url value='static/js/tax/tax_service.js'/>"></script>


</body>
</html>