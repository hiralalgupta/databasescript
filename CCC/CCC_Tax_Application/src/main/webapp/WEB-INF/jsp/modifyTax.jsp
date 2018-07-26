<!DOCTYPE html>
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
</style>

</head>
<body>
<div class="container">
<!-- Form Start -->
<div ng-controller="TaxController as ctrl" ng-init="defaultInfoForClient();">
<form>
<div class="box">
<h3>State Information</h3>

	<div class="row">
		<div class="col-md-3">
			<div class="form-group"><label>State <span class="required">*</span></label>
				<select id="TimeLine" ng-change="fetchCounties();" ng-model="formData.stateData" class="form-control">
					<option ng-repeat="state in ctrl.stateData"  value="{{state}}">{{state.name}}</option>
				 </select>
			</div>
		</div>
		<div class="col-md-3">
			<div class="form-group"><label>County <span class="required">*</span></label>
				<select id="TimeLine" ng-change="fetchLocationInfo();"  ng-model="formData.countyData" class="form-control">
					<option ng-repeat="county in  ctrl.countiesData"  value="{{county}}">{{county.name}}</option>
				</select>
			</div>
		</div>
		<div class="col-md-3">
			<div class="form-group"><label>ZIP Code <span class="required">*</span></label>
				<select id="TimeLine" ng-change="getPlus4Info();" ng-model="formData.zip" class="form-control">
					<option ng-repeat="location in  ctrl.controlMapping | unique:'zip' " value="{{location.zip}}">{{location.zip}}</option>
				</select>
			</div>
		</div>
		<div class="col-md-3">
			<div class="form-group"><label>PLUS4 <span class="required">*</span></label>
				<select id="TimeLine"   ng-model="formData.plus4" class="form-control">
								<option ng-repeat="location in  plus4Data | unique:'plus4' "  value="{{location.plus4}}">{{location.plus4}}</option>
						  </select></div>
		</div>
		
	</div>

		<div class="btn-bar text-center"><input data-ng-click="submit()" type="button" value="Get Tax Detail" class="btn btn-primary btn-lg"  ></div>
		
</div>

 <!--  <input type="hidden" ng-model="_csrf" name="${_csrf.parameterName}"  value="${_csrf.token}" />-->

<!-- <div class="box">
<h3>Washington Title and/or Registration Application Vehicle Information</h3>
<div class="row">
		<div class="col-md-3">
			<div class="form-group"><label>Vehicle Identification Number (VIN)</label><input placeholder="VIN" type="text" class="form-control"></div>
		</div>
		<div class="col-md-3">
			<div class="form-group"><label>Vehicle Type <span class="required">*</span></label>
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
				<select id="TimeLine" ng-change="getVehcileTrimData();"  ng-model="formData.vehicleModel" class="form-control">
					<option ng-repeat="vehicle in  uniqueVehicleData " value="{{vehicle[0]}}">{{vehicle[0]}}</option>
				</select>
			</div>
		</div>
</div>
	<div class="row">
		
		<div class="col-md-3">
			<div class="form-group"><label>Model Trim <span class="required">*</span></label>
				<select id="TimeLine" ng-change="getVehcileYearData();"   ng-model="formData.vehicleTrim" class="form-control">
					<option ng-repeat="vehicle in  trimData " value="{{vehicle[2]}}">{{vehicle[2]}}</option>
				</select>
			</div>
		</div>
		<div class="col-md-3">
			<div class="form-group"><label>Year <span class="required">*</span></label>
				<select id="TimeLine" ng-model="formData.vehicleYear" class="form-control">
					<option ng-repeat="vehicle in  yearData | unique:'vehicle[1]' " value="{{vehicle[1]}}">{{vehicle[1]}}</option>
				</select>
			</div>
		</div>
		<div class="col-md-3">
			<div class="form-group"><label>Plate Type <span class="required">*</span></label>
				<select id="TimeLine" ng-model="formData.plateType" class="form-control">
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
<button focus-index="1" class="btn btn-primary" data-toggle="modal" focus-element="autofocus" data-target=".bs-example-modal-lg">Large modal</button>
<div class="btn-bar text-center"><input data-ng-click="submit()" type="button" value="Get Tax Detail" class="btn btn-primary btn-lg"  focus-index="1" class="btn btn-primary" data-toggle="modal" focus-element="autofocus" data-target=".bs-example-modal-lg"></div>
</div> -->
</form>

<div class="box">
<h3>Tax Information</h3>

	<div class="row">
		<div class="col-md-3">
			<div class="form-group"><label>Sales Tax/Use Tax <span class="required">*</span></label>
				<input ng-model="taxData.SalesTax" style="background:#c4bbc7 !important"  type="text" class="form-control" readonly> 
			</div>
		</div>
		<div class="col-md-3">
			<div class="form-group"><label>Location Rate <span class="required">*</span></label>
				<input ng-model="taxData.SalesTax" style="background:#c4bbc7 !important"  type="text" class="form-control" readonly> 
			</div>
		</div>
		<div class="col-md-3">
			<div class="form-group"><label>RTA <span class="required">*</span></label>
				<input ng-model="taxData.SalesTax" style="background:#c4bbc7 !important"  type="text" class="form-control" readonly> 
			</div>
		</div>
		<div class="col-md-3">
			<div class="form-group"><label>Title Fees <span class="required">*</span></label>
				<input ng-model="taxData.SalesTax" style="background:#c4bbc7 !important"  type="text" class="form-control" readonly> 
			</div>
		</div>
	</div>

</div>

<div class="modal fade bs-example-modal-lg"  focus-group focus-group-head="loop" focus-group-tail="loop" focus-stacktabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel" aria-hidden="true">
		  <div class="modal-dialog">
			<div class="modal-content">
			  <div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
				<h4 class="modal-title" id="myModalLabel">Results Screen</h4>
			  </div>
			  <div class="modal-body">
			  	<form class="ng-pristine ng-valid">
			<!-- 	<div class="box">
				<div class="innerbox">
						<h4>Vehicle Details</h4>
						<div class="row">
							<div class="col-md-6">
							<div class="form-group"><label>VIN: </label> {{formData.vehicleType}}</div>
							</div>
							<div class="col-md-6">
							<div class="form-group"><label>Vehicle Type: </label> VIN</div>
							</div>
							<div class="col-md-6">
							<div class="form-group"><label>Vehicle Make: </label> VIN</div>
							</div>
							<div class="col-md-6">
							<div class="form-group"><label>Vehicle Model: </label> VIN</div>
							</div>
						</div>
				</div></div> -->
					<div class="box" id="view-results">
						<div class="innerbox">
						<h4>Sales Tax</h4>
						<div class="row">
							<div class="col-md-3">
								<div class="form-group"><label>Sales Tax/Use Tax</label><input ng-model="taxData.SaleTaxComponent"  class=" form-control dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false" readonly>
									<ul class="dropdown-menu">
										<li><a href="{{ctrl.vehicleTaxData.SALETAXURL}}" target="_blank">Reference Link</a></li>
									</ul>
								</div>
							</div>
							<div class="col-md-3">
								<div class="form-group"><label>Location Rate</label><input ng-model="taxData.LocationRate" class=" form-control dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false" readonly>
									<ul class="dropdown-menu">
										<li><a href="{{ctrl.vehicleTaxData.LOCATIONRATEURL}}" target="_blank">Reference Link</a></li>
									</ul>
								</div>
							</div>
							<div class="col-md-3">
								<div class="form-group"><label>RTA</label><input ng-model="taxData.RTA" class=" form-control dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false" readonly>
									<ul class="dropdown-menu">
										<li><a href="{{ctrl.vehicleTaxData.RTAURL}}" target="_blank">Reference Link</a></li>
									</ul>
								</div>
							</div>
							<div class="col-md-3"><div class="form-group"><label>Total Sales Tax</label><input ng-model="taxData.SalesTax" style="background:#c4bbc7 !important"  type="text" class="form-control" readonly> </div></div>
						</div>
						</div>
						
						<div class="innerbox">
						<h4>Title Fees</h4>
						<div class="row">
						<div class="col-md-6">
							<div class="form-group"><label>Title Fees</label><input  ng-model="taxData.TitleFeesComponent" class=" form-control dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false" readonly>
								<ul class="dropdown-menu">
									<li><a href="{{ctrl.vehicleTaxData.TITLEFEESURL}}" target="_blank">Reference Link</a></li>
								</ul>
							 </div>
						</div>
						<div class="col-md-6">
						<div class="form-group"><label>Total Title fees</label><input ng-model="taxData.TitleFees" type="text" style="background:#c4bbc7 !important" class="form-control" readonly></div>
						</div>
						</div>
						</div>
						<div class="innerbox">
						<h4>Registration Fees</h4>
						<div class="row">
						<div class="col-md-4">
							<div class="form-group"><label>Registration Fees</label><input ng-model="taxData.RegFessComponent"  class=" form-control dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false" readonly>
								<ul class="dropdown-menu">
									<li><a href="{{ctrl.vehicleTaxData.REGISTRATIONFEESURL}}" target="_blank">Reference Link</a></li>
								</ul>
							 </div>
						</div>
						<div class="col-md-4">
							<div class="form-group"><label>Vehicle Type Fee</label><input ng-model="taxData.VehicleType"  class=" form-control dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false" readonly>
								<ul class="dropdown-menu">
									<li><a href="{{ctrl.vehicleTaxData.VEHICLETYPEURL}}" target="_blank">Reference Link</a></li>
								</ul>
							</div>
						</div>
						<div class="col-md-4">
							<div class="form-group"><label>Weight Fee</label><input ng-model="taxData.WeightFee"  class=" form-control dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false" readonly>
								<ul class="dropdown-menu">
									<li><a href="{{ctrl.vehicleTaxData.WEIGHTURL}}" target="_blank">Reference Link</a></li>
								</ul>
							</div>
						</div>
						<div class="col-md-4">
							<div class="form-group"><label>Plate Type Fee</label><input ng-model="taxData.PlateTypeFee"  class=" form-control dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false" readonly>
								<ul class="dropdown-menu">
									<li><a href="{{ctrl.vehicleTaxData.PLATETYPEURL}}" target="_blank">Reference Link</a></li>
								</ul>
							</div>
						</div>
						<div class="col-md-4">
							<div class="form-group"><label>VIN Fee</label><input ng-model="taxData.VINFee" class=" form-control dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false" readonly>
								<ul class="dropdown-menu">
									<li><a href="{{ctrl.vehicleTaxData.VINURL}}" target="_blank">Reference Link</a></li>
								</ul>
							</div>
						</div>
						<div class="col-md-4"><div class="form-group"><label>Total Registration fees</label><input ng-model="taxData.RegFess"  type="text" style="background:#c4bbc7 !important" class="form-control form-control-total" readonly></div></div>
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