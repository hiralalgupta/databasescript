
var app = angular.module('myapp');

app.factory('RuleService', ['$http', '$q', function($http, $q){
 
    var REST_SERVICE_URI = 'getTaxDetail';
  /*  var REST_SERVICE_URI_SAVE = 'rulesaveRuleInfo';
    var REST_SERVICE_CONTROL_TYPE='getControlMapping/';
    var REST_SERVICE_CLIENTS_RULES = 'rulesearch/';
    var REST_SERVICE_URI_DISPALY = 'ruledisplay';*/
    var REST_SERVICE_LOCATION_INFO = 'getVehicleMake';
    var REST_SERVICE_PLATE_INFO = 'plateInfo/';
    var REST_SERVICE_ADDRESS_INFO = 'addressInfo/';
    var REST_SERVICE_LOCATION_AREA = 'zipInfo';
    var REST_SERVICE_PLUS4_AREA = 'plus4Info?';
    var REST_SERVICE_VEHICLE_INFO = 'vehicleInfo?vehicleMake=' ;
    var REST_SERVICE_VECHILE_ZIP='uniqueZipInfo?regionId=';
    var REST_SERVICE_VECHILE_PLUS4INFO_ZIP='plus4InfoBsdZip?zip=';
    var REST_SERVICE_ZIP ="getZIPPLUS4Info?zipplus4=";
    var REST_SERVICE_VECHILE_COUNTY='countyInfo?';
    var REST_SERVICE_VECHILE_REGION='regionInfo?';
    var factory = {
    	fetchAddressInfo: fetchAddressInfo,
        submit: submit,
        fetchLocationInfo: fetchLocationInfo,
        fetchVehicleInfo: fetchVehicleInfo,
        fetchControlMappingTypes:fetchControlMappingTypes,
        getRulesByClient: getRulesByClient,
        getPlateInfo: getPlateInfo,
        getVehicleMake:getVehicleMake,
        getPlus4: getPlus4,
        getDefaultUniqueZip:getDefaultUniqueZip,
        getPlus4BasedOnZip:getPlus4BasedOnZip,
        getCountyData:getCountyData,
        getRegionData:getRegionData,
        getZIPPLUS4Info:getZIPPLUS4Info
    };
 
    return factory;
    
    function getPlus4(countyAndZip) {
        var deferred = $q.defer();
        $http.get(REST_SERVICE_PLUS4_AREA+countyAndZip)
            .then(
            function (response) {
                deferred.resolve(response.data);
            },
            function(errResponse){
                console.error('Error while fetching Users');
                deferred.reject(errResponse);
            }
        );
        return deferred.promise;
    }
    function getDefaultUniqueZip(regionId) {
        var deferred = $q.defer();
        $http.get(REST_SERVICE_VECHILE_ZIP+regionId)
            .then(
            function (response) {
                deferred.resolve(response.data);
            },
            function(errResponse){
                console.error('Error while fetching ZIP');
                deferred.reject(errResponse);
            }
        );
        return deferred.promise;
    }
    function getPlus4BasedOnZip(zip) {
        var deferred = $q.defer();
        $http.get(REST_SERVICE_VECHILE_PLUS4INFO_ZIP+zip)
            .then(
            function (response) {
                deferred.resolve(response.data);
            },
            function(errResponse){
                console.error('Error while fetching Users');
                deferred.reject(errResponse);
            }
        );
        return deferred.promise;
    }
    
    function getZIPPLUS4Info(zip,regionId) {
        var deferred = $q.defer();
        $http.get(REST_SERVICE_ZIP+zip+"&regionId="+regionId)
            .then(
            function (response) {
                deferred.resolve(response.data);
            },
            function(errResponse){
                console.error('Error while fetching Users');
                deferred.reject(errResponse);
            }
        );
        return deferred.promise;
    }
    
    function getCountyData(zipAndplus4) {
        var deferred = $q.defer();
        $http.get(REST_SERVICE_VECHILE_COUNTY+zipAndplus4)
            .then(
            function (response) {
                deferred.resolve(response.data);
            },
            function(errResponse){
                console.error('Error while fetching Users');
                deferred.reject(errResponse);
            }
        );
        return deferred.promise;
    }
    function getRegionData(countyId) {
        var deferred = $q.defer();
        $http.get(REST_SERVICE_VECHILE_REGION+countyId)
            .then(
            function (response) {
                deferred.resolve(response.data);
            },
            function(errResponse){
                console.error('Error while fetching Users');
                deferred.reject(errResponse);
            }
        );
        return deferred.promise;
    }
    function getVehicleMake() {
        var deferred = $q.defer();
        $http.get(REST_SERVICE_LOCATION_INFO)
            .then(
            function (response) {
                deferred.resolve(response.data);
            },
            function(errResponse){
                console.error('Error while fetching Users');
                deferred.reject(errResponse);
            }
        );
        return deferred.promise;
    }
    
    function getPlateInfo(state) {
        var deferred = $q.defer();
        $http.get(REST_SERVICE_PLATE_INFO+getPath(state))
            .then(
            function (response) {
                deferred.resolve(response.data);
            },
            function(errResponse){
                console.error('Error while fetching Users');
                deferred.reject(errResponse);
            }
        );
        return deferred.promise;
    }
    
    function fetchVehicleInfo(vehicleMake) {
        var deferred = $q.defer();
        $http.get(REST_SERVICE_VEHICLE_INFO+vehicleMake)
            .then(
            function (response) {
                deferred.resolve(response.data);
            },
            function(errResponse){
                console.error('Error while fetching Users');
                deferred.reject(errResponse);
            }
        );
        return deferred.promise;
    }
 
    function fetchAddressInfo() {
        var deferred = $q.defer();
        $http.get(REST_SERVICE_ADDRESS_INFO)
            .then(
            function (response) {
                deferred.resolve(response.data);
            },
            function(errResponse){
                console.error('Error while fetching Users');
                deferred.reject(errResponse);
            }
        );
        return deferred.promise;
    }
    
    function fetchLocationInfo(county,state) {
        var deferred = $q.defer();
        $http.get(REST_SERVICE_LOCATION_AREA+getPath(county)+getPath(state))
            .then(
            function (response) {
                deferred.resolve(response.data);
            },
            function(errResponse){
                console.error('Error while fetching Users');
                deferred.reject(errResponse);
            }
        );
        return deferred.promise;
    }
    
    function getPath(value){
    	return "/"+value;    	
    }
    
    function submit(formData) {
        var deferred = $q.defer();
        $http.post(REST_SERVICE_URI,formData,{
            headers: { 'Content-Type': 'application/json'}})
            .then(
            function (response) {
                deferred.resolve(response.data);
            },
            function(errResponse){
                console.error('Error while fetching Users');
                deferred.reject(errResponse);
            }
        );
        return deferred.promise;
    }
    
    function fetchControlMappingTypes(synId,clientId,ruleId){
    	 var deferred = $q.defer();
         $http.get(REST_SERVICE_CONTROL_TYPE,{params: {synId: synId,clientId: clientId,ruleId: ruleId}})
         .then(
             function (response) {
                 deferred.resolve(response.data);
             },
             function(errResponse){
                 console.error('Error while fetching Control Mappings');
                 deferred.reject(errResponse);
             }
         );
         return deferred.promise;
    }
    
    function getRulesByClient(clientId) {
        var deferred = $q.defer();
        $http.get(REST_SERVICE_CLIENTS_RULES+clientId)
            .then(
            function (response) {
                deferred.resolve(response.data);
            },
            function(errResponse){
                console.error('Error while fetching Users');
                deferred.reject(errResponse);
            }
        );
        return deferred.promise;
    }
    
}]);


