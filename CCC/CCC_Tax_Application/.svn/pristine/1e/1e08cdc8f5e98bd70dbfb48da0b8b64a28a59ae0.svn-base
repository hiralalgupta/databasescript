<!DOCTYPE html>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html lang="en">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Innodata Vehicle tax app</title>
	
<style>
.box{background-color:#fbfbfb; box-shadow:0 0px 4px 0px #cfcfcf; -webkit-box-shadow:0 0px 4px 0px #cfcfcf; -moz-box-shadow:0 0px 4px 0px #cfcfcf; -ms-box-shadow:0 0px 4px 0px #cfcfcf; padding:20px; margin-bottom:20px; margin-top:10px;}
.box h3{margin-top:0; margin-bottom:20px; font-size:18px; color:#777;border-bottom: 1px solid #ccc;    padding: 0 5px 15px;}
.form-group{font-size: 11px;}
.form-group label{font-weight:600; font-size: 14px;}
.form-group .form-control{border-radius:0; height:35px; border-color:#e8e8e8;     margin-bottom: 10px;}
.form-group .required{color:red;}

/*******************************/
#view-results .form-group label{white-space: nowrap;     text-overflow: ellipsis; overflow:hidden;}
#resultsmodal .modal-body{max-height:600px; overflow-y:auto;}

/*******************/
.fees{background-color: #f5f8ff;  padding:0 20px;}
.fees .form-group {margin-bottom: 0;}
.fees .form-group label {line-height:36px;    display: inline-block;    margin: 0;}
.fees .btn {margin:4px 0;}
 label[title]:hover:after{
    content: attr(title);
    background: #e4a267; 
    position: absolute;
    margin: 10px 0px 20px 20px;
    left: 15%;
    top: 20%;}
</style>

</head>
<body>
<div class="container">
<!-- Form Start -->
<div ng-controller="TaxCalculatorController as ctrl" ng-init="defaultInfo();">
<form>
<div class="box">
<h3>New Registered Owner Information</h3>
		
	<!-- <div class="row">
		<div class="col-md-4">
			<div class="form-group"><label>Name</label><input placeholder="Name" type="text" class="form-control"></div>
		</div>
		<div class="col-md-4">
			<div class="form-group"><label>Address Line 1</label><input placeholder="Address1" type="text" class="form-control"></div>
		</div>
		<div class="col-md-4">
			<div class="form-group"><label>Address Line 2</label><input placeholder="Address2" type="text" class="form-control"></div>
		</div>
	</div> -->

	<div class="row">
		<div class="col-md-4" >
		
			 <div class="form-group"><label>State <span class="required">*</span></label>
				<select id="TimeLine"  ng-change="getUniqueZip()" ng-model="stateData" class="form-control">
					<option ng-repeat="state in stateWA"  value="{{state}}">{{state.name}}</option>
				 </select>
			</div> 
			
		</div>
		<div  class="col-md-4" ng-if="ctrl.zipCode" >
		 <div class="form-group"><label>ZIP Code <span class="required">*</span></label>
				<select id="TimeLine" ng-change="getPlus4BasedOnZip();" ng-model="formData.zip" class="form-control">
					<option value=""/>
					<option ng-repeat="zip in  ctrl.zipCode track by $index" value="{{zip}}">{{zip}}</option>
				</select>
			</div> 
		</div>
		<div class="col-md-4" ng-if="plus4Data">
		
		<div class="form-group"><label>PLUS4 <span class="required">*</span></label>
				<select id="TimeLine" ng-change="getCountyData()" ng-model="formData.plus4" class="form-control">
					<option value=""/>
					<option ng-repeat="plus4 in  plus4Data "  value="{{plus4}}">{{plus4}}</option>
				</select></div>
		</div>
			<!-- <div class="form-group"><label>County <span class="required">*</span></label>
				<select id="TimeLine" ng-change="getRegionData()"  ng-model="countyData" class="form-control">
					<option value=""/>
					<option ng-repeat="county in  ctrl.countiesData"  value="{{county}}">{{county.name}}</option>
				</select>
			</div> -->
		
		
		
		
	</div>

	<div class="row" ng-if="ctrl.countiesData">
	<div class="col-md-4">
			<div class="form-group"><label>County <span class="required">*</span></label>
				<select id="TimeLine"   ng-model="countyData" class="form-control">
					<option value=""/>
					<option ng-repeat="county in  ctrl.countiesData" ng-selected="ctrl.countiesData[0]"  value="{{county}}">{{county.name}}</option>
				</select>
			</div>
		</div>
			<!-- <div class="form-group"><label>State <span class="required">*</span></label>
				<select id="TimeLine"  ng-model="stateData"  class="form-control">
				    <option value=""/>
					<option ng-repeat="state in ctrl.stateData" ng-selected="state[0] == stateData"	 value="{{state}}">{{state.name}}</option>
				 </select>
			</div> -->
		
		<div class="col-md-4">
		</div>
		<div class="col-md-4">
		</div>
	</div>
</div>

 <!--  <input type="hidden" ng-model="_csrf" name="${_csrf.parameterName}"  value="${_csrf.token}" />-->

<div class="box">
<h3>Washington Title and/or Registration Application Vehicle Information</h3>
<div class="row">
		<div class="col-md-3">
			<div class="form-group"><label style="color:#6769e4;" data-toggle="tooltip" data-placement="bottom" title="This data will be used to get the vehicle info in the final product. For POC purpose, vehicle details need to be selected">Vehicle Identification Number (VIN)</label><input placeholder="VIN" type="text" class="form-control"></div>
		</div>
		<div class="col-md-3">
			<div class="form-group"><label>Vehicle Type </label>
				<select id="TimeLine" ng-model="formData.vehicleType" class="form-control">
					<option ng-repeat="vehicleInfo in  ctrl.vehicleTypeData" value="{{vehicleInfo[2]}}">{{vehicleInfo[2]}}</option>
				</select>
			</div>
		</div>
		<div class="col-md-3">
			<div class="form-group"><label>Make <span class="required">*</span></label>
				<select id="TimeLine" ng-change="getvehicleDetail();" ng-model="formData.vehicleMake" class="form-control">
					<option ng-repeat="vehicleInfo in  ctrl.vehicleMakeData" value="{{vehicleInfo[0]}}">{{vehicleInfo[0]}}</option>
				</select>
			</div>
		</div>
		<div class="col-md-3">
			<div class="form-group"><label>Model <span class="required">*</span></label>
				<select id="TimeLine" ng-change="getVehcileYearData();"  ng-model="formData.vehicleModel" class="form-control">
					<option ng-repeat="vehicle in  uniqueVehicleData " value="{{vehicle[0]}}">{{vehicle[0]}}</option>
				</select>
			</div>
		</div>
</div>
	<div class="row">
		
		<div class="col-md-3">
			<div class="form-group"><label>Year <span class="required">*</span></label>
				<select id="TimeLine" ng-change="getVehcileTrimData();" ng-model="formData.vehicleYear" class="form-control">
					<option ng-repeat="vehicle in  yearData | unique:'vehicle[1]' " value="{{vehicle[1]}}">{{vehicle[1]}}</option>
				</select>
			</div>
		</div>
		<div class="col-md-3">
			<div class="form-group"><label>Model Trim </label>
				<select id="TimeLine"    ng-model="formData.vehicleTrim" class="form-control">
				<option value=""/>
					<option ng-repeat="vehicle in  trimData " value="{{vehicle[2]}}">{{vehicle[2]}}</option>
				</select>
			</div>
		</div>
		<div class="col-md-3">
			<div class="form-group"><label>Plate Type</label>
				<select id="TimeLine" ng-model="formData.plateType" class="form-control">
					<option value=""/>
					<option ng-repeat="plate in  ctrl.plateTypeData" value="{{plate}}">{{plate}}</option>
				</select>
			</div>
		</div>
	</div>

<div class="accordion-panel">
	<a class="accordion-label" role="button" data-toggle="collapse" data-parent="#accordion" href="#collapseOne" aria-expanded="true" aria-controls="collapseOne">
	<i class="more-less glyphicon glyphicon-plus"></i> Additional Information</a>
	 
	<div id="collapseOne" class="panel-collapse collapse" role="tabpanel" aria-labelledby="headingOne">


		<div class="row">
		<div class="col-md-4">
		<div class="form-group"><label>Weight</label> <input ng-model="formData.weight" placeholder="Weight" type="text" class="form-control"></div>
		</div>
		<div class="col-md-4">
		<div class="form-group"><label>Body Style <input placeholder="Body Style" type="text" class="form-control"></div>
		</div>
		<div class="col-md-4">
		<div class="form-group"><label>Fuel Type <input placeholder="Fuel Type" type="text" class="form-control"></div>
		</div>
		</div>
		<div class="row">
		<div class="col-md-6">
		<div class="form-group"><label>Seating Capacity</label> <input placeholder="Seating Capacity" type="text" class="form-control"></div>
		</div>
		 <div class="col-md-6">
		<div class="form-group"><label>Registration Date</label> <input placeholder="Registration Date" type="text" class="form-control"></div>
		</div>
		</div>
	</div>
</div>
<!-- <button focus-index="1" class="btn btn-primary" data-toggle="modal" focus-element="autofocus" data-target=".bs-example-modal-lg">Large modal</button> -->
<div class="btn-bar text-center"><input data-ng-click="submit()" type="button" value="Get Tax Detail" class="btn btn-primary btn-lg"  focus-index="1" class="btn btn-primary" data-toggle="modal" focus-element="autofocus" data-target=".bs-example-modal-lg"></div>
</div>
</form>
<div class="modal fade bs-example-modal-lg" id="resultsmodal"  focus-group focus-group-head="loop" focus-group-tail="loop" focus-stacktabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel" aria-hidden="true">
		  <div class="modal-dialog">
			<div class="modal-content modal-lg">
			  <div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
				<h4 class="modal-title" id="myModalLabel">Results Screen</h4>
			  </div>
			  <div class="modal-body">
			  	<form class="ng-pristine ng-valid">
					<div class="box" id="view-results">
						<div>
							<div  class="innerbox">
								<h4>Sales Tax</h4>
								
								<div ng-repeat="tax in salesTaxWithPercent" ng-if="$index % 3 ==0" class="row">
										<div class="col-xs-4">
											<div class="form-group"><label data-toggle="tooltip" data-placement="top" title="{{salesTaxWithPercent[$index].name}}">{{salesTaxWithPercent[$index].name}}-{{salesTaxWithPercent[$index].unit}}</label><input value="{{salesTaxWithPercent[$index].value}}" class=" form-control dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false" readonly>
												<ul class="dropdown-menu">
													<li><a href="{{salesTaxWithPercent[$index].url}}" target="_blank">Reference Link</a></li>
												</ul>
											</div>
										</div>
										<div ng-if= "salesTaxWithPercent[$index+1]">
											<div class="col-xs-4">
												<div class="form-group"><label data-toggle="tooltip" data-placement="top" title="{{salesTaxWithPercent[$index+1].name}}">{{salesTaxWithPercent[$index+1].name}}-{{salesTaxWithPercent[$index+1].unit}}</label><input value="{{salesTaxWithPercent[$index+1].value}}" class=" form-control dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false" readonly>
													<ul class="dropdown-menu">
														<li><a href="{{salesTaxWithPercent[$index+1].url}}" target="_blank">Reference Link</a></li>
													</ul>
												</div>
											</div>
										</div>
										<div ng-if= "salesTaxWithPercent[$index+2]">
											<div class="col-xs-4">
												<div class="form-group"><label data-toggle="tooltip" data-placement="top" title="{{salesTaxWithPercent[$index+2].name}}">{{salesTaxWithPercent[$index+2].name}}-{{salesTaxWithPercent[$index+2].unit}}</label><input value="{{salesTaxWithPercent[$index+2].value}}" class=" form-control dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false" readonly>
													<ul class="dropdown-menu">
														<li><a href="{{salesTaxWithPercent[$index+2].url}}" target="_blank">Reference Link</a></li>
													</ul>
												</div>
											</div>
										</div>
									</div>
									
									<div ng-repeat="tax in salesTaxWithDollar" ng-if="$index % 3 ==0" class="row">
										<div class="col-xs-4">
											<div class="form-group"><label data-toggle="tooltip" data-placement="top" title="{{salesTaxWithDollar[$index].name}}">{{salesTaxWithDollar[$index].name}}-{{salesTaxWithDollar[$index].unit}}</label><input value="{{salesTaxWithDollar[$index].value}}" class=" form-control dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false" readonly>
												<ul class="dropdown-menu">
													<li><a href="{{salesTaxWithDollar[$index].url}}" target="_blank">Reference Link</a></li>
												</ul>
											</div>
										</div>
										<div ng-if= "salesTaxWithDollar[$index+1]">
											<div class="col-xs-4">
												<div class="form-group"><label data-toggle="tooltip" data-placement="top" title="{{salesTaxWithDollar[$index+1].name}}">{{salesTaxWithDollar[$index+1].name}}-{{salesTaxWithDollar[$index+1].unit}}</label><input value="{{salesTaxWithDollar[$index+1].value}}" class=" form-control dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false" readonly>
													<ul class="dropdown-menu">
														<li><a href="{{salesTaxWithDollar[$index+1].url}}" target="_blank">Reference Link</a></li>
													</ul>
												</div>
											</div>
										</div>
										<div ng-if= "salesTaxWithDollar[$index+2]">
											<div class="col-xs-4">
												<div class="form-group"><label data-toggle="tooltip" data-placement="top" title="{{salesTaxWithDollar[$index+2].name}}">{{salesTaxWithDollar[$index+2].name}}-{{salesTaxWithDollar[$index+2].unit}}</label><input value="{{salesTaxWithDollar[$index+2].value}}" class=" form-control dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false" readonly>
													<ul class="dropdown-menu">
														<li><a href="{{salesTaxWithDollar[$index+2].url}}" target="_blank">Reference Link</a></li>
													</ul>
												</div>
											</div>
										</div>
									</div>
							</div>
							
							
							<div ng-if="titleFeesData" class="innerbox">
								<h4>Title Fees</h4>
								<div ng-repeat="tax in titleFeesData" ng-if="$index % 3 ==0" class="row">
										<div class="col-xs-4">
											<div class="form-group"><label data-toggle="tooltip" data-placement="top" title="{{titleFeesData[$index].name}}">{{titleFeesData[$index].name}}-{{titleFeesData[$index].unit}}</label><input value="{{titleFeesData[$index].value}}" class=" form-control dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false" readonly>
												<ul class="dropdown-menu">
													<li><a href="{{titleFeesData[$index].url}}" target="_blank">Reference Link</a></li>
												</ul>
											</div>
										</div>
										<div ng-if= "titleFeesData[$index+1]">
											<div class="col-xs-4">
												<div class="form-group"><label data-toggle="tooltip" data-placement="top" title="{{titleFeesData[$index+1].name}}">{{titleFeesData[$index+1].name}}-{{titleFeesData[$index+1].unit}}</label><input value="{{titleFeesData[$index+1].value}}" class=" form-control dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false" readonly>
													<ul class="dropdown-menu">
														<li><a href="{{titleFeesData[$index+1].url}}" target="_blank">Reference Link</a></li>
													</ul>
												</div>
											</div>
										</div>
										<div ng-if= "titleFeesData[$index+2]">
											<div class="col-xs-4">
												<div class="form-group"><label data-toggle="tooltip" data-placement="top" title="{{titleFeesData[$index+2].name}}">{{titleFeesData[$index+2].name}}-{{titleFeesData[$index+2].unit}}</label><input value="{{titleFeesData[$index+2].value}}" class=" form-control dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false" readonly>
													<ul class="dropdown-menu">
														<li><a href="{{titleFeesData[$index+2].url}}" target="_blank">Reference Link</a></li>
													</ul>
												</div>
											</div>
										</div>
									</div>
									
									<!-- <div class="row">
										<div class="col-xs-4">
											<div class="form-group"><label>{{totalRegFeesData[0].name}}-{{totalRegFeesData[0].unit}}</label><input value="{{totalRegFeesData[0].value}}" class=" form-control dropdown-toggle" style="background:#c4bbc7 !important" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false" readonly>
											</div>
										</div>
									</div> -->
							</div>
							
							<div ng-if="registrationTaxData" class="innerbox">
								<h4>Registration Fees</h4>
								<div ng-repeat="tax in registrationTaxData" ng-if="$index % 3 ==0" class="row">
										<div class="col-xs-4">
											<div class="form-group"><label data-toggle="tooltip" data-placement="top" title="{{registrationTaxData[$index].name}}">{{registrationTaxData[$index].name}}-{{registrationTaxData[$index].unit}}</label><input value="{{registrationTaxData[$index].value}}" class=" form-control dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false" readonly>
												<ul class="dropdown-menu">
													<li><a href="{{registrationTaxData[$index].url}}" target="_blank">Reference Link</a></li>
												</ul>
											</div>
										</div>
										<div ng-if= "registrationTaxData[$index+1]">
											<div class="col-xs-4">
												<div class="form-group"><label data-toggle="tooltip" data-placement="top" title="{{registrationTaxData[$index+1].name}}">{{registrationTaxData[$index+1].name}}-{{registrationTaxData[$index+1].unit}}</label><input value="{{registrationTaxData[$index+1].value}}" class=" form-control dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false" readonly>
													<ul class="dropdown-menu">
														<li><a href="{{registrationTaxData[$index+1].url}}" target="_blank">Reference Link</a></li>
													</ul>
												</div>
											</div>
										</div>
										<div ng-if= "registrationTaxData[$index+2]">
											<div class="col-xs-4">
												<div class="form-group"><label data-toggle="tooltip" data-placement="top" title="{{registrationTaxData[$index+2].name}}">{{registrationTaxData[$index+2].name}}-{{registrationTaxData[$index+2].unit}}</label><input value="{{registrationTaxData[$index+2].value}}" class=" form-control dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false" readonly>
													<ul class="dropdown-menu">
														<li><a href="{{registrationTaxData[$index+2].url}}" target="_blank">Reference Link</a></li>
													</ul>
												</div>
											</div>
										</div>
									</div>
									
									<div class="row">
										<div class="col-xs-4">
											<div class="form-group"><label>{{totalRegFeesData[0].name}}-{{totalRegFeesData[0].unit}}</label><input  ng-model="TaxDetailForm.totalRegFee"  class=" form-control dropdown-toggle" style="background:#c4bbc7 !important" aria-haspopup="true" aria-expanded="false" readonly>
											</div>
										</div>
									</div>
							</div>
							
							<div ng-if="optinalFeesData" class="innerbox">
								<h4>Optional Fees</h4>
									<div class="row" style="margin-bottom: 29px;">
										<div class="col-xs-3">
												<div class="form-group"><label>Select optional fees</label></div>
										</div>
										<div class="col-xs-5">
												<select id="optinalFee" ng-model="TaxDetailForm.optinalFee" class="form-control">
													<option ng-repeat="OF in optinalFeesData"  value="{{OF}}">{{OF.name}}</option>
												 </select>
										</div>
										<div class="col-xs-4">
												<button type="button" data-toggle="tooltip" data-placement="top" title="Add Fee" class="btn-default" style="margin-top: 5px;" ng-click="addOptionalFees();" ><i class="fa fa-plus" aria-hidden="true"></i></i></button>
										</div>
									</div>
									
									<div ng-repeat="fees in reverse(optionalFeesObject)" class="fees row">
										<div class="col-md-6">
											<div class="form-group"><label>{{fees.name}}</label></div>
										</div>
										<div class="col-md-2">
											<div class="form-group"><label>{{fees.value}}</label></div>
										</div>
										<div class="col-md-4">
											<button type="button" data-toggle="tooltip" data-placement="top" title="Delete Fee" class="btn-default" ng-click="removeOptionalFees(fees);"><i class="fa fa-minus" aria-hidden="true"></i></button>
										</div>
									</div>
							</div>
						</div>
						</div>
						</form>
			  </div>
			  <div class="modal-footer">
				<button type="button" class="btn btn-default" focus-element="autofocus" data-dismiss="modal">Close</button>
				<!-- <button type="button" class="btn btn-primary">Save changes</button> -->
			  </div>
			</div>
		  </div>

</div> 	
</form>
</div>
<!-- Form End -->
</div>
</body>
</html>