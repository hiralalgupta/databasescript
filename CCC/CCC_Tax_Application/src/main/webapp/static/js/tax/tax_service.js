
var app = angular.module('myapp');

app.factory('TaxService', ['$http', '$q', function($http, $q){
 
    var REST_SERVICE_URI = 'stateTaxInfo';
  /*  var REST_SERVICE_URI_SAVE = 'rulesaveRuleInfo';
    var REST_SERVICE_CONTROL_TYPE='getControlMapping/';
    var REST_SERVICE_CLIENTS_RULES = 'rulesearch/';
    var REST_SERVICE_URI_DISPALY = 'ruledisplay';*/
    var REST_SERVICE_ADDRESS_INFO = 'addressInfo/';
    var REST_SERVICE_LOCATION_AREA = 'locationInfo?county=';
    var REST_SERVICE_VEHICLE_INFO = 'vehicleInfo?vehicleMake=' ;
 
    var factory = {
    	fetchAddressInfo: fetchAddressInfo,
        submit: submit,
        fetchLocationInfo: fetchLocationInfo,
        fetchVehicleInfo: fetchVehicleInfo,
        fetchControlMappingTypes:fetchControlMappingTypes,
        getRulesByClient: getRulesByClient,
    };
 
    return factory;
    
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
    
    function fetchLocationInfo(county) {
        var deferred = $q.defer();
        $http.get(REST_SERVICE_LOCATION_AREA+county)
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

