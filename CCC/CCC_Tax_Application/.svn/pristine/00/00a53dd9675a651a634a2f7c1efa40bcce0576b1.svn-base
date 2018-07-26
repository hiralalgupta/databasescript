/*angular.module('myapp', [
  'myapp.controllers'
]);*/


var app = angular.module('myapp',['ngSanitize','ui.bootstrap']);
/*angular.module("myapp", [])
    .controller("HelloController", function($scope) {
        $scope.helloTo = {};
        $scope.helloTo.title = "World, AngularJS";
    } );*/
app.controller('HelloController', ['$scope', function($scope) {
	$scope.helloTo = "World, AngularJS";
}]);

app.controller('MyController', ['$scope', function($scope) {
	$scope.hello = "World, AngularJS";
}]);

app.controller("AjaxController", function($scope, $http) {
	$scope.myData = {};
	$scope.myData.doClick = function(item, event) {
		//var url='admin/getuserDetails/1';
		var responsePromise = $http.get("admin/getuserDetails/1");

		responsePromise.success(function(data, status, headers, config) {
			alert("hello");
			$scope.myData.users=data.objList;
			$scope.myData.fromServer = data.obj.userName;
		});
		responsePromise.error(function(data, status, headers, config) {
			alert("AJAX failed!");
		});
	}
});
app.controller("ruleCreationController", function($scope, $http,$sce) {

	$scope.myData = {};
	$scope.accordion = {
			current: null,
			child:null
	};
	$scope.switchLanguage = function() {
		//var  langKey = $scope.selected;
		alert($scope.selected);
		var clientName=$scope.selected;
		/*  var responsePromise = $http.get("getSynIds/"+clientName);

    	        responsePromise.success(function(data, status, headers, config) {
    	        	alert("hello");
    	        	$scope.myData=data.objList;
    	        });
    	        responsePromise.error(function(data, status, headers, config) {
    	            alert("AJAX failed!");
    	        });*/
		/* $scope.cat1list = ["item 1", "item 2","item 3","item 4","item 5"];
    	    	 $scope.cat2list = ["item 1", "item 2","item 3","item 4","item 5"];
    	    	 $scope.cat3list = [];
    	    	 $scope.cat4list = [];     
    	    	 $scope.synlist = ["item 1", "item 2","item 3","item 4","item 5"];  */  
		$scope.items = [{
			name: 'List 1',
			sub: [{
				name: 'Sub 1.1'
			}, {
				name: 'Sub 1.2'
			}]
		}, {
			name: 'List 2',
			sub: [{
				name: 'Sub 2.1'
			}]
		}, {
			name: 'List 3',
			sub: [{
				name: 'Sub 3.1'
			}, {
				name: 'Sub 3.2'
			}, {
				name: 'Sub 3.3'
			}]
		}];
		/*$scope.myHTML=$sce.trustAsHtml("<ul > <li ng-repeat='item in items' ng-click='accordion.current = item.name'>A<ul ng-show='accordion.current == item.name'><li ng-repeat='sub in item.sub'>B</li>"+
    		      "</ul></li></ul>");*/
		/*" <div> <ul> <li ng-click='accordion.current=1'> <div>Sollicitudin</div> <ul ng-show='accordion.current == 1'> <li >Lorem ipsum</li></ul>" +
    	        		"</li></ul></div>");*/

		/* "<li style='list-style: none;'>Dolor sit</a></li> <li style='list-style: none;'> <div>Commodo Rhoncus</div><ul>"+
    	                    "<li style='list-style: none;'>Current</a></li> <li style='list-style: none;'>Consectetur</a></li></ul>"+
    	                   "</li> </ul> </li><li style='list-style: none;'><div>Quis Porttitor</div><ul><li style='list-style: none;'>Finibus Bonorum</a></li>"+
    	                    "<li style='list-style: none;'>Sed ut</a></li><li style='list-style: none;'>Neque porro</a></li></ul>"+
"</li>  </ul>   </div> </div><div style='height:40px;clear:both;'></div></div>");*/
	}
	//$scope.

});

app.controller("searchUserController", function($scope,$rootScope, $http) {
	$scope.myData = [];
	$scope.errMsg="";
	$rootScope.eMsg='';
	$scope.showDiv=false;
	$rootScope.editMsg='';
	$rootScope.roleMsg='';
	//Method for searching user
	$scope.searchUser=function(item, event) {
		var dataObj={
				firstName: $scope.firstName!= null ? $scope.firstName :"",
						email: $scope.email!= null ? $scope.email :"",
								userName: $scope.userName!= null ? $scope.userName :""
		};
		if(($scope.firstName==undefined || $scope.firstName=='')  && ($scope.email==undefined || $scope.email=='' ) && ($scope.userName==undefined || $scope.userName=='') ){
			$scope.errMsg="All fields are blank,Please try again";
			//reset searched user details form
			$scope.fname="";
			$scope.userEmail="";
			$scope.uname="";
			$scope.accountStatus="";
			//reset edit user form details
			$scope.frstName="";
			$scope.usrEmail="";
			$scope.usrName="";
			$scope.usrStatus="";
			$scope.usrId="";
			//reset Assign User Role form details
			$scope.urName="";
			$scope.uId="";
			return;
		}
		/*else if($scope.firstName!=null && ($scope.email==undefined || $scope.email=='' ) && ($scope.userName==undefined || $scope.userName=='') ){
    		$scope.errMsg="first name is not unique,pleae enter email/user name also";
    	}*/
		else{
			$scope.errMsg="";
			var responsePromise = $http.post("searchuser",dataObj);
			responsePromise.success(function(data, status, headers, config) {
				$scope.myData=data.objList;
				if($scope.firstName!=null && $scope.myData!=null && $scope.myData.length>1){
					$scope.errMsg="There are existing multiple users with this name,so please enter email/username also ";
					//reset searched user details form
					$scope.fname="";
					$scope.userEmail="";
					$scope.uname="";
					$scope.accountStatus="";
					//reset edit user form details
					$scope.frstName="";
					$scope.usrEmail="";
					$scope.usrName="";
					$scope.usrStatus="";
					$scope.usrId="";
					//reset Assign User Role form details
					$scope.urName="";
					$scope.uId="";
					return;
				}
				else if($scope.myData!=null  && $scope.myData.length==1){
					for (var i=0;i<$scope.myData.length;i++)
					{
						//alert('list value is'+$scope.myData[i].firstName+"'"+$scope.myData[i].userId);
						//searched user details form
						$scope.fname=($scope.myData[i].firstName)!=null?$scope.myData[i].firstName:" ";
						$scope.userEmail=$scope.myData[i].email!=null?$scope.myData[i].email:" ";
						$scope.uname=$scope.myData[i].userName!=null?$scope.myData[i].userName:" ";
						$scope.accountStatus=$scope.myData[i].accountStatus!=null?$scope.myData[i].accountStatus:" ";
						//edit user details
						$scope.frstName=($scope.myData[i].firstName)!=null?$scope.myData[i].firstName:" ";
						$scope.usrEmail=$scope.myData[i].email!=null?$scope.myData[i].email:" ";
						$scope.usrName=$scope.myData[i].userName!=null?$scope.myData[i].userName:" ";
						$scope.usrStatus=$scope.myData[i].accountStatus!=null?$scope.myData[i].accountStatus:" ";
						$scope.usrId=$scope.myData[i].userId!=null?$scope.myData[i].userId:" ";
						//$scope.editMsg="";
						//Assign User Role form details
						$scope.urName=$scope.myData[i].userName!=null?$scope.myData[i].userName:" ";
						$scope.uId=$scope.myData[i].userId!=null?$scope.myData[i].userId:" ";
						//what searched
						$scope.firstName=($scope.firstName)!=null?$scope.firstName:null;
						$scope.email=$scope.email!=null?$scope.email:null;
						$scope.userName=$scope.userName!=null?$scope.userName:null;

					}
					$scope.myData=[];

				}
				else{
					$scope.errMsg="Sorry! No Data found.,Please try again.. ";
					//reset searched user details form
					$scope.fname="";
					$scope.userEmail="";
					$scope.uname="";
					$scope.accountStatus="";
					//reset edit user form details
					$scope.frstName="";
					$scope.usrEmail="";
					$scope.usrName="";
					$scope.usrStatus="";
					$scope.usrId="";
					//reset Assign User Role form details
					$scope.urName="";
					$scope.uId="";
				}
				$scope.showDiv=false;
				$rootScope.editMsg=' ';
				$rootScope.eMsg='';
				$rootScope.roleMsg='';
				/*if(editMsg=="User is updated successfully..."){
              		var div = angular.element( document.querySelector( '#editMesageId' ) );
              		div.empty();
              	}*/
				//alert('$scope.showDiv :'+$scope.showDiv+",$scope.editMsg:"+$scope.editMsg);
			});

			responsePromise.error(function(data, status, headers, config) {
				alert("AJAX failed!");
			});
		}//End searchUser() method
	}//End searchUser() method

	//method for edit user details...
	$scope.submitForm = function(item, event) {
		$scope.isExist="";
		var dataObj = {
				firstName : $scope.frstName,
				email : $scope.usrEmail,
				userName : $scope.usrName,
				accountStatus :$scope.usrStatus,
				userId :$scope.usrId
		};
		var responsePromise = $http.post("edituser",dataObj);
		responsePromise.success(function(data, status, headers, config) {
			$scope.isExist=data.obj;
			if($scope.isExist=="true"){
				$scope.showDiv=true;
				$rootScope.editMsg="User is updated successfully...";
			}
			else{
				$scope.showDiv=true;
				$rootScope.editMsg="Sorry!something error ,please try again";
			}
		});
		responsePromise.error(function(data, status, headers, config) {
			alert("AJAX failed!");
		});
	}//end edit user details method..
	//method for assign the  user role...
	$scope.assignRole = function(item, event) {
		var userObj = {
				userName: $scope.urName,
				userId: $scope.uId
		};
		$scope.isExist="";
		//$rootScope.roleMsg="";
		var roleId=$scope.roleId;
		if($scope.roleId==undefined){
			$rootScope.roleMsg="Please select role...";
		}
		else{	
			var responsePromise = $http.post("assignrole/"+roleId,userObj);
			responsePromise.success(function(data, status, headers, config) {
				$scope.isExist=data.obj;

				if($scope.isExist=="true"){
					$rootScope.roleMsg="User role  is assigned successfully...";
					/*$scope.urName="";
        				$scope.uId="";
        				$scope.roleId="";*/
				}
				else
					$rootScope.roleMsg="User role is updated succesfully...";
			});
		}		 		
		responsePromise.error(function(data, status, headers, config) {
			alert("AJAX failed!");
		});
	}//end assinRole method
	//method for create user
	$scope.createUser = function(item, event) {
		$scope.isExist="";
		var userObj = {
				firstName: $scope.userFirstName,
				email: $scope.userrEmail,
				userName: $scope.userNm
		};
		var clientId=$scope.clientId;
		if($scope.clientId==undefined){
			$rootScope.eMsg="Please select client...";
		}
		else{	
			var responsePromise = $http.post("createuser/"+clientId,userObj);
			responsePromise.success(function(data, status, headers, config) {
				$scope.isExist=data.obj;
				if($scope.isExist=="false"){
					$rootScope.eMsg="Sorry! user is alredy registered...Please try again";
				}
				else{
					$rootScope.eMsg="User is created successfully";
					//reset create user form details afer save in database
					$scope.userFirstName="";
					$scope.userrEmail="";
					$scope.userNm="";
					$scope.clientId="";
				}
			});

		}		
		responsePromise.error(function(data, status, headers, config) {
			alert("AJAX failed!");
		});
	}
});

app.controller("ClientMngtController", function($scope,$rootScope,$modal,$http) {
	var modalInstance;
	$rootScope.updateMsg="";
	$rootScope.showDiv=false;
	$rootScope.createMsg="";
	$rootScope.showCreateDiv=false;
	$rootScope.deleteMsg="";
	$rootScope.showDeleteDiv=false;
	$rootScope.showDiv=false;
	$scope.editClient = function(clientName,clientAddress,clientEmail,clientPhone,clientStatus,clientId) {
		$rootScope.updateMsg="";
		$rootScope.showDiv=false;
		$rootScope.deleteMsg="";
		$rootScope.showDeleteDiv=false;
		//alert("in edit client name :"+clientName+"address"+clientAddress+"email"+clientEmail+"phone"+clientPhone);
		//alert("cname value"+$scope.cname);
		//$scope.clientName=clientName;
		modalInstance = $modal.open({
			templateUrl: 'myModalContent.html',
			scope: $scope,
			size:'lg'
		});
		$scope.clientName=clientName;
		$scope.contact=clientAddress+"   "+clientEmail+"   "+clientPhone;
		$scope.address=clientAddress;
		$scope.email=clientEmail;
		$scope.phone=clientPhone;
		$scope.status=clientStatus;
		$scope.clientId=clientId;
		//alert(" client name :"+$scope.clientName+"address: "+$scope.address+"email:"+$scope.email+"phone:"+$scope.phone);
	}
	$scope.updateClient = function() {
		$scope.isExist="";
		//alert(" client name :"+this.clientName+"address: "+this.address+"email:"+this.email+"phone:"+this.phone);
		var clientObj = {
				clientId:this.clientId,
				clientName : this.clientName,
				address : this.address,
				email : this.email,
				phone :this.phone,
				status :this.status

		};
		var responsePromise = $http.post("editclient",clientObj);
		responsePromise.success(function(data, status, headers, config) {
			$scope.isExist=data.obj;
			if($scope.isExist=="true"){
				$rootScope.showDiv=true;
				$rootScope.updateMsg="Client Informations are updated successfully...";
				modalInstance.close();
			}
			else{
				$rootScope.showDiv=true;
				$rootScope.updateMsg="Sorry!something error ,please try again";
			}

		});
		responsePromise.error(function(data, status, headers, config) {
			alert("AJAX failed!");
		});
	}
	$scope.cancel = function () {
		this.$close();
	};
	$scope.deleteClient = function(clientid) {
		$scope.isExist="";
		var clientObj = {
				clientId:clientid,
				status:'INACTIVE'
		};
		confirm('are you sure ');
		var responsePromise = $http.post("deleteclient",clientObj);
		responsePromise.success(function(data, status, headers, config) {
			//alert('success');
			$scope.isExist=data.obj;
			if($scope.isExist=="true"){
				$rootScope.showDeleteteDiv=true;
				alert('successfully deleted');
				//$rootScope.deleteMsg="Client record deleted successfully...";
			}
			else{
				$rootScope.showDeleteteDiv=true;
				$rootScope.deleteMsg="Sorry!Something error occured ,please try again";
			}

		});
		responsePromise.error(function(data, status, headers, config) {
			alert("AJAX failed!");
		});
	}
});

app.controller("defSynIdCntrl", function($scope,$rootScope,$http) {

	$rootScope.savedSynids=[];
	var each;
	//var each1;
	$scope.selectClient=function(){
		var clientId=$scope.selClient!=null?$scope.selClient : 0;
		var responsePromise = $http.get("defineSynid/"+clientId);

		var self = this;
		self.clientInfo=[];

		responsePromise.success(function(data, status, headers, config) {
			self.clientInfo= data.mapList.clientInfo;
			$scope.selClient = self.clientInfo.clientId;
		});
		responsePromise.error(function(data, status, headers, config) {
			alert("AJAX failed!");
		});
	}

	$scope.showLeftSynids = function() {
		//if(self.synidAvailable !=undefined){
		var clientId = $scope.selClient!= null ? $scope.selClient : 0;
		var responsePromise = $http.get("defineSynid/"+clientId);
		var self = this;
		self.synidAvailable=[];
		self.eMsg=null;
		self.selectedsynids=[];
		self.rightsynids=[];

		responsePromise.success(function(data, status, headers, config) {

			self.synidAvailable= data.mapList.synidAvailable;

		});
		responsePromise.error(function(data, status, headers, config) {
			alert("AJAX failed!");
		});
		//}
	}
	$scope.showRightSynids = function() {
		//if(self.synidSaved !=undefined){
		var clientId = $scope.selClient!= null ? $scope.selClient : 0;
		var responsePromise = $http.get("defineSynid/"+clientId);
		var self = this;
		self.synidAvailable=[];

		self.synidSaved=[];
		self.rightsynids=[];
		self.savedSynids=[];
		responsePromise.success(function(data, status, headers, config) {

			self.synidSaved= data.mapList.synidSaved;

			//$rootScope.savedSynids=data.mapList.origSynSaved;
		});
		responsePromise.error(function(data, status, headers, config) {
			alert("AJAX failed!");
		});
		//}
	}

	$scope.moveRight = function(synidAvailable,leftsynids, rightsynids) {
		var self = this;
		self.rightsynids=null;
		self.leftsynids=[];
		self.eMsg=null;
		var isFound=false;

		if(synidAvailable !=undefined){
			for(i = 0;i < synidAvailable.length; i++){
				var idx=leftsynids.indexOf(synidAvailable[i]);
				if(idx != -1){
					leftsynids.splice(idx,1);
					rightsynids.push(synidAvailable[i]);

					if($rootScope.savedSynids.length==0){
						//var each;
						each=angular.copy(synidAvailable[i]);
						each.isSaved='Y';
						$rootScope.savedSynids.push(each);

					}

					/*	if(synidAvailable[i].isSaved=='N'){
					$rootScope.savedSynids.push(synidAvailable[i])*/
					else{
						//for some synid already moved from right to left
						for(j = 0;j <$rootScope.savedSynids.length; j++){
							if($rootScope.savedSynids[j].synid==synidAvailable[i].synid){
								isFound=true;
								$rootScope.savedSynids.splice(j,1);
								break;
							}
						}
						if(isFound==false){
							//var each;
							each=angular.copy(synidAvailable[i]);
							each.isSaved='Y';
							$rootScope.savedSynids.push(each);
						}
					}
				}
			}
		}
	};

	$scope.moveLeft = function(synidSaved,rightsynids,leftsynids) {
		var self = this;
		self.leftsynids=null;
		self.rightsynids=[];
		self.eMsg=null;
		var isFound=false;

		if(synidSaved !=undefined){
			for(i = 0;i < synidSaved.length; i++){
				var idx=rightsynids.indexOf(synidSaved[i]);
				if(idx != -1){
					rightsynids.splice(idx,1);
					leftsynids.push(synidSaved[i]);

					if($rootScope.savedSynids.length==0){

						each=angular.copy(synidSaved[i]);
						each.isUpdated='Y';
						$rootScope.savedSynids.push(each);
					}

					else{
						//for some synid already moved from left to right
						for(j = 0;j <$rootScope.savedSynids.length; j++){
							if($rootScope.savedSynids[j].synid==synidSaved[i].synid){
								isFound=true;
								$rootScope.savedSynids.splice(j,1);
								break;
							}
						}
						if(isFound==false){
							//var each;
							each=angular.copy(synidSaved[i]);
							each.isUpdated='Y';
							$rootScope.savedSynids.push(each);
						}
					}
				}
			}
		}
	};

	$scope.moveRightAll = function(from, to) {
		$scope.eMsg=null;
		//move all synids from left to right
		if($rootScope.savedSynids.length==0){   		
			for(j=0;j<from.length;j++){
				to.push(from[j]);
				each=angular.copy(from[j]);
				each.isSaved='Y';
				$rootScope.savedSynids.push(each);
			}
		}
		else{
			//if some synid move right to left earlier
			var tempobj = angular.copy($rootScope.savedSynids);
			$rootScope.savedSynids = [];
			var counter = 0;
			for(var i=0;i<from.length;i++){
				var c = 0;
				for(var j=0;j<tempobj.length;j++){
					//checking from array against tempobj(earlier moved synids)
					if(from[i].sid != tempobj[j].sid){
						c++;
					}
					//after checking all from array against tempobj, changing issaved to Y
					if (c == tempobj.length){
						$rootScope.savedSynids[counter] = from[i];
						$rootScope.savedSynids[counter].isSaved='Y';
						counter ++;
					} 
				}
				to.push(from[i]);
			}//if some synid move left to right earlier
			for(var k=0;k<tempobj.length;k++){
				if (tempobj[k].isSaved == 'Y')
					$rootScope.savedSynids.push(tempobj[k]);
			}
		}
		from.length=[];
		//from.length = 0;
	}; 

	$scope.moveLeftAll = function(from, to) {
		$scope.eMsg=null;

		//move all synids from right to left
		if($rootScope.savedSynids.length==0){
			for(i=0;i<from.length;i++){
				to.push(from[i]);
				each=angular.copy(from[i]);
				each.isUpdated='Y';
				$rootScope.savedSynids.push(each);
			}
		}
		else{ //if some synid move from left to right earlier
			var tempobj=angular.copy($rootScope.savedSynids);
			$rootScope.savedSynids=[];
			var counter=0;
			for(var i=0;i<from.length;i++){
				var c=0;
				for(var j=0;j<tempobj.length;j++){
					//checking from array against tempobj(earlier moved synids)
					if(from[i].sid != tempobj[j].sid){
						c++;
					}
					//after checking all from array against tempobj, changing isupdated to Y
					if(c==tempobj.length){
						$rootScope.savedSynids[counter]=from[i];
						$rootScope.savedSynids[counter].isUpdated='Y';
						counter++
					}
				}
				to.push(from[i]);
			}//if some synid move right to left earlier
			for(var k=0;k<tempobj.length;k++){
				if(tempobj[k].isUpdated =='Y')
					$rootScope.savedSynids.push(tempobj[k]);
			}
		}     
		from.length = 0;
	}; 

	$scope.saveDefSynId = function(item, event) {
		if($rootScope.savedSynids.length!==0){
			var toSaveSynid=[];

			angular.forEach($rootScope.savedSynids, function(value){
				if(value.isSaved=='Y'|| value.isUpdated=='Y'){ 
					toSaveSynid.push(value);
				}	   
			});  

			var clientId=$scope.selClient;
			var responsePromise = $http.post("defineSaveSynId/"+clientId,toSaveSynid);

			responsePromise.success(function(data, status, headers, config) {
				$rootScope.savedSynids=[];
				$scope.eMsg="Synids Saved Successfully";
			});
			responsePromise.error(function(data, status, headers, config) {
				alert("AJAX failed!");
			});
		}
		else if($rootScope.savedSynids.length==0){
			$scope.eMsg="No Synid selected";
		}
	}
	$scope.synidAvailable= [];             
	$scope.synidSaved = [];
});

app.controller("defineComorbiditySynIdCntrl", function($scope,$rootScope,$http) {

	$rootScope.savedSynids=[];
	var each;

	$scope.selectClient=function(){
		var clientId=$scope.selClient!=null?$scope.selClient : 0;
		var responsePromise = $http.get("ComorbiditySynid/"+clientId);

		var self = this;
		self.clientInfo=[];

		responsePromise.success(function(data, status, headers, config) {
			self.clientInfo= data.mapList.clientInfo;
			$scope.selClient = self.clientInfo.clientId;
		});
		responsePromise.error(function(data, status, headers, config) {
			alert("AJAX failed!");
		});
	}

	$scope.showLeftSynids = function() {
		var clientId = $scope.selClient!= null ? $scope.selClient : 0;
		var responsePromise = $http.get("ComorbiditySynid/"+clientId);
		var self = this;
		self.synidAvailable=[];
		self.eMsg=null;
		self.selectedsynids=[];
		self.rightsynids=[];

		responsePromise.success(function(data, status, headers, config) {
			self.synidAvailable= data.mapList.synidAvailable;		
		});
		responsePromise.error(function(data, status, headers, config) {
			alert("AJAX failed!");
		});
	}

	$scope.showRightSynids = function() {
		var clientId = $scope.selClient!= null ? $scope.selClient : 0;
		var responsePromise = $http.get("ComorbiditySynid/"+clientId);
		var self = this;
		self.synidAvailable=[];

		self.synidSaved=[];
		self.rightsynids=[];
		self.savedSynids=[];
		responsePromise.success(function(data, status, headers, config) {	
			self.synidSaved= data.mapList.synidSaved;
		});
		responsePromise.error(function(data, status, headers, config) {
			alert("AJAX failed!");
		});
	}

	$scope.moveRight = function(synidAvailable,leftsynids, rightsynids) {
		var self = this;
		self.rightsynids=null;
		self.leftsynids=[];
		self.eMsg=null;
		var isFound=false;

		if(synidAvailable !=undefined){
			for(i = 0;i < synidAvailable.length; i++){
				var idx=leftsynids.indexOf(synidAvailable[i]);
				if(idx != -1){
					leftsynids.splice(idx,1);
					rightsynids.push(synidAvailable[i]);

					if($rootScope.savedSynids.length==0){
						each=angular.copy(synidAvailable[i]);
						each.isSaved='Y';
						$rootScope.savedSynids.push(each);
					}
					else{
						//for some synid already moved from right to left
						for(j = 0;j <$rootScope.savedSynids.length; j++){
							if($rootScope.savedSynids[j].synid==synidAvailable[i].synid){
								isFound=true;
								$rootScope.savedSynids.splice(j,1);
								break;
							}
						}
						if(isFound==false){
							each=angular.copy(synidAvailable[i]);
							each.isSaved='Y';
							$rootScope.savedSynids.push(each);
						}
					}
				}
			}
		}
	};

	$scope.moveLeft = function(synidSaved,rightsynids,leftsynids) {
		var self = this;
		self.leftsynids=null;
		self.rightsynids=[];
		self.eMsg=null;
		var isFound=false;

		if(synidSaved !=undefined){
			for(i = 0;i < synidSaved.length; i++){
				var idx=rightsynids.indexOf(synidSaved[i]);
				if(idx != -1){
					rightsynids.splice(idx,1);
					leftsynids.push(synidSaved[i]);

					if($rootScope.savedSynids.length==0){
						each=angular.copy(synidSaved[i]);
						each.isUpdated='Y';
						$rootScope.savedSynids.push(each);
					}

					else{
						//for some synid already moved from left to right
						for(j = 0;j <$rootScope.savedSynids.length; j++){
							if($rootScope.savedSynids[j].synid==synidSaved[i].synid){
								isFound=true;
								$rootScope.savedSynids.splice(j,1);
								break;
							}
						}
						if(isFound==false){
							each=angular.copy(synidSaved[i]);
							each.isUpdated='Y';
							$rootScope.savedSynids.push(each);
						}
					}
				}
			}
		}
	};

	$scope.moveRightAll = function(from, to) {
		$scope.eMsg=null;
		//move all synids from left to right
		if($rootScope.savedSynids.length==0){   		
			for(j=0;j<from.length;j++){
				to.push(from[j]);
				each=angular.copy(from[j]);
				each.isSaved='Y';
				$rootScope.savedSynids.push(each);
			}
		}
		else{
			//if some synid move right to left earlier
			var tempobj = angular.copy($rootScope.savedSynids);
			$rootScope.savedSynids = [];
			var counter = 0;
			for(var i=0;i<from.length;i++){
				var c = 0;
				for(var j=0;j<tempobj.length;j++){
					//checking from array against tempobj(earlier moved synids)
					if(from[i].sid != tempobj[j].sid){
						c++;
					}
					//after checking all from array against tempobj, changing issaved to Y
					if (c == tempobj.length){
						$rootScope.savedSynids[counter] = from[i];
						$rootScope.savedSynids[counter].isSaved='Y';
						counter ++;
					} 
				}
				to.push(from[i]);
			}//if some synid move left to right earlier
			for(var k=0;k<tempobj.length;k++){
				if (tempobj[k].isSaved == 'Y')
					$rootScope.savedSynids.push(tempobj[k]);
			}
		}
		from.length=[];
	}; 

	$scope.moveLeftAll = function(from, to) {
		$scope.eMsg=null;

		//move all synids from right to left
		if($rootScope.savedSynids.length==0){
			for(i=0;i<from.length;i++){
				to.push(from[i]);
				each=angular.copy(from[i]);
				each.isUpdated='Y';
				$rootScope.savedSynids.push(each);
			}
		}
		else{ //if some synid move from left to right earlier
			var tempobj=angular.copy($rootScope.savedSynids);
			$rootScope.savedSynids=[];
			var counter=0;
			for(var i=0;i<from.length;i++){
				var c=0;
				for(var j=0;j<tempobj.length;j++){
					//checking from array against tempobj(earlier moved synids)
					if(from[i].sid != tempobj[j].sid){
						c++;
					}
					//after checking all from array against tempobj, changing isupdated to Y
					if(c==tempobj.length){
						$rootScope.savedSynids[counter]=from[i];
						$rootScope.savedSynids[counter].isUpdated='Y';
						counter++
					}
				}
				to.push(from[i]);
			}//if some synid move right to left earlier
			for(var k=0;k<tempobj.length;k++){
				if(tempobj[k].isUpdated =='Y')
					$rootScope.savedSynids.push(tempobj[k]);
			}
		}     
		from.length = 0;
	}; 

	$scope.saveComorbiditySynId = function(item, event) {
		if($rootScope.savedSynids.length!==0){
			var toSaveSynid=[];

			angular.forEach($rootScope.savedSynids, function(value){
				if(value.isSaved=='Y'|| value.isUpdated=='Y'){ 
					toSaveSynid.push(value);
				}	   
			});  

			var clientId=$scope.selClient;
			var responsePromise = $http.post("comorbiditySaveSynId/"+clientId,toSaveSynid);

			responsePromise.success(function(data, status, headers, config) {
				$rootScope.savedSynids=[];
				$scope.eMsg="Synids Saved Successfully";
			});
			responsePromise.error(function(data, status, headers, config) {
				alert("AJAX failed!");
			});
		}
		else if($rootScope.savedSynids.length==0){
			$scope.eMsg="No Synid selected";
		}
	}

	$scope.synidAvailable= [];             
	$scope.synidSaved = [];
});

