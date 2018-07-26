var app = angular.module('myapp');


app.controller('TaxController', ['$rootScope','$scope','$timeout','TaxService','$compile',"$window","$filter",function($rootScope,$scope, $timeout, TaxService,$compile,$window,$filter) {
    var self = this;
    self.clientInfo=[];
    self.ruleInfo=[];
    self.tabId = '';
    $scope.formData={};
    $scope.taxData={};
    self.controlMapping=[];
    self.vehicleMakeData="";
    self.vehicleTypeData = "";
    self.plateTypeData = "";
    self.vehicleData="";
    self.vehicleTaxData = "";
    self.controlSecondCompFilteredObj="";
    self.ruleFields="";
    self.operatorList="";
    self.secondaryClientSynIds ="";
    self.secondaryClientSynIdsStatus=[];
    self.saveMessage = "";
    
    self.stateData = "";
    self.countiesData = "";
    self.zipCode = "";
    self.uniqueZip="";
    
 
    $scope.fetchCounties = function() {
    	self.countiesData = JSON.parse($scope.formData.stateData).counties;
        
    };

    $scope.defaultInfoForClient = function() {
	        TaxService.fetchAddressInfo()
		        .then(
		        function(data) {
		        	self.stateData = data.obj;
		        },
		        function(errResponse){
		            console.error('Error while fetching Users');
		        }
	        );
        
    };
   
    
    
    $scope.submit = function() {
    	
    	$scope.formData.state = JSON.parse($scope.formData.stateData).name;
    	$scope.formData.county = JSON.parse($scope.formData.countyData).name;
    	$scope.taxData ={};
    	TaxService.submit($scope.formData)
        .then(
	        function(data) {
	        	resultData = data.obj;
	        	if(resultData != null){
	        		self.vehicleTaxData = resultData[0];
		        	$scope.taxData.SaleTaxComponent = resultData[0].SALES_TAX;
		        	$scope.taxData.LocationRate = resultData[0].LOCATION_RATE;
		        	$scope.taxData.RTA = resultData[0].RTA;
		        	$scope.taxData.TitleFeesComponent = resultData[0].TITLE_FEES;
		        	$scope.taxData.RegFessComponent = resultData[0].REGISTRATION_FEES;
		        	$scope.taxData.VehicleType = resultData[0].VEHICLE_FEES;
		        	$scope.taxData.WeightFee = resultData[0].WEIGHT_FEES;
		        	$scope.taxData.PlateTypeFee = resultData[0].PLATETYPE_FEES;
		        	$scope.taxData.VINFee = resultData[0].VEHICLEIDENTIFICATIONNUMBER;
		        	$scope.taxData.SalesTax = parseFloat($scope.taxData.SaleTaxComponent)+parseFloat($scope.taxData.LocationRate)+parseFloat($scope.taxData.RTA);
		        	$scope.taxData.TitleFees = $scope.taxData.TitleFeesComponent;
		        	$scope.taxData.RegFess = parseFloat($scope.taxData.RegFessComponent)+parseFloat($scope.taxData.VehicleType)+parseFloat($scope.taxData.WeightFee != -1.0 ? $scope.taxData.WeightFee:0)+parseFloat($scope.taxData.PlateTypeFee)+parseFloat($scope.taxData.VINFee);
	        	}
	        },
	        function(errResponse){
	            console.error('Error while fetching Users');
	        }
	    );
    };
    
    $scope.fetchLocationInfo = function() {
    	
    	var countyId = JSON.parse($scope.formData.countyData).countyId;
    	TaxService.fetchLocationInfo(countyId).then(
    	function (data){
    		 self.controlMapping=data.obj;
    		 self.vehicleTypeData = uniqueArraybyId(data.objList,2);
    		 self.vehicleMakeData = uniqueArraybyId(data.objList,0);
    		 self.plateTypeData = data.mapList.plateType;
    	},function(errResponse){
    		console.error('Error while fetching ControlMappings');
    	}		
    	);
    };
    
    $scope.getPlus4Info = function() {
    
    	$scope.plus4Data = $filter('filter')(self.controlMapping, function (control) {
	        
	        return $scope.formData.zip == control.zip;
	        
	      });
    };
    
  $scope.getvehicleDetail = function() {
    	
    	var vehicleMake = $scope.formData.vehicleMake;
    	TaxService.fetchVehicleInfo(vehicleMake).then(
    	function (data){
    		 self.vehicleData= data.obj;
    		 $scope.uniqueVehicleData = uniqueArraybyId(data.obj,0);
    	},function(errResponse){
    		console.error('Error while fetching vehicle data');
    	}		
    	);
    };
    
    $scope.getVehcileYearData = function() {
        
    	$scope.yearData = $filter('filter')(self.vehicleData, function (control) {
	        
	        return $scope.formData.vehicleTrim == control[2] && $scope.formData.vehicleModel == control[0];
	        
	      });
    	
    };
    
    
    $scope.getVehcileTrimData = function() {
    	
		$scope.trimData = $filter('filter')(self.vehicleData, function (control) {
			        
			        return $scope.formData.vehicleModel == control[0] ;
			        
			      });
		    	
		    	$scope.trimData = uniqueArraybyId($scope.trimData,2)
    };
    
    function uniqueArraybyId(collection, index) {
        var output = [], 
        keys = [];
        angular.forEach(collection, function(item) {
            var key = item[index];
            if(key != '' && keys.indexOf(key) === -1) {
            	keys.push(item[index]);
                output.push(item);
            }
        });
	  return output;
	};
    
}]);
