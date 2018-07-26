function buildAccodionCategory(clientId, searchValue){
	//var searchValue = "";
	if (clientId == ""){
		clientId = $('select[id=TimeLine]').val();
		searchValue = $('input#searchInput').val().trim();
	}
	selectedClientId = parseInt(clientId);
	var accordionHtml = "";
	//$.get("getSynIdOnClinetId/" +selectedClientId + "?searchInput="+searchValue, function(data, status){
	$.ajax({
		url: "getSynIdOnClinetId/" +selectedClientId + "?searchInput=" +searchValue,
		async: false,
        success: function (data) {
        if (data.objList.length > 0){
        	$('#accordion-div').html("");
        	accordionHtml += '<div id=\"accordion"\>';
        	var catLength = data.objList.length - 1;
        	for (var i = 0; i <= catLength; i++) { 	
        		if(i == 0){
        			accordionHtml += '<ul><li class="decor-list">'+data.objList[i].category1;
        			if(data.objList[i].category2 == "")
        				accordionHtml += '<ul><li id="synId'+data.objList[i].sid+'" ng-click="fetchComponent(\'' + encodeURIComponent(JSON.stringify(data.objList[i])).replace(/'/g, "\\'\\'") + '\')">' + data.objList[i].synid + '</li>';
        			else if (data.objList[i].category2 != "" && data.objList[i].category3 == "")
        				accordionHtml += '<ul><li class="decor-list">' + data.objList[i].category2 + '<ul><li id="synId'+data.objList[i].sid+'" ng-click="fetchComponent(\'' + encodeURIComponent(JSON.stringify(data.objList[i])).replace(/'/g, "\\'\\'") + '\')">' + data.objList[i].synid + '</li>';
        			else if (data.objList[i].category3 != "" && data.objList[i].category4 == "")
        				accordionHtml += '<ul><li class="decor-list">' + data.objList[i].category2 + '<ul><li class="decor-list">' + data.objList[i].category3 + '<ul><li id="synId'+data.objList[i].sid+'" ng-click="fetchComponent(\'' + encodeURIComponent(JSON.stringify(data.objList[i])).replace(/'/g, "\\'\\'") + '\')">' + data.objList[i].synid + '</li>';
        			else
        				accordionHtml += '<ul><li class="decor-list">' + data.objList[i].category2 + '<ul><li class="decor-list">' + data.objList[i].category3 + '<ul><li class="decor-list">' + data.objList[i].category4 + '<ul><li id="synId'+data.objList[i].sid+'" ng-click="fetchComponent(\'' + encodeURIComponent(JSON.stringify(data.objList[i])).replace(/'/g, "\\'\\'") + '\')">' + data.objList[i].synid + '</li>';
        		}else{
        			if(data.objList[i-1].category1 == data.objList[i].category1){
        				if(data.objList[i-1].category2 == ""){
        					if (data.objList[i].category2 == "")
        						accordionHtml += '<li id="synId'+data.objList[i].sid+'" ng-click="fetchComponent(\'' + encodeURIComponent(JSON.stringify(data.objList[i])).replace(/'/g, "\\'\\'") + '\')">' + data.objList[i].synid + '</li>';
        					else if (data.objList[i].category2 != "" && data.objList[i].category3 == "")
        						accordionHtml += '<li class="decor-list">' + data.objList[i].category2 + '<ul><li id="synId'+data.objList[i].sid+'" ng-click="fetchComponent(\'' + encodeURIComponent(JSON.stringify(data.objList[i])).replace(/'/g, "\\'\\'") + '\')">' + data.objList[i].synid + '</li>';
        					else if (data.objList[i].category3 != "" && data.objList[i].category4  == "")
        						accordionHtml += '<li class="decor-list">' + data.objList[i].category2 + '<ul><li class="decor-list">' + data.objList[i].category3 + '<ul><li id="synId'+data.objList[i].sid+'" ng-click="fetchComponent(\'' + encodeURIComponent(JSON.stringify(data.objList[i])).replace(/'/g, "\\'\\'") + '\')">' + data.objList[i].synid + '</li>';
        					else
        						accordionHtml += '<li class="decor-list">' + data.objList[i].category2 + '<ul><li class="decor-list">' + data.objList[i].category3 + '<ul><li class="decor-list">' + data.objList[i].category4 + '<ul><li id="synId'+data.objList[i].sid+'" ng-click="fetchComponent(\'' + encodeURIComponent(JSON.stringify(data.objList[i])).replace(/'/g, "\\'\\'") + '\')">' + data.objList[i].synid + '</li>';
        				}else if (data.objList[i-1].category2 != "" && data.objList[i-1].category3 == ""){
        					if (data.objList[i].category2 == ""){
        						accordionHtml += '</ul></li><li id="synId'+data.objList[i].sid+'" ng-click="fetchComponent(\'' + encodeURIComponent(JSON.stringify(data.objList[i])).replace(/'/g, "\\'\\'") + '\')">' + data.objList[i].synid + '</li>';
        					}else{
        						if (data.objList[i-1].category2 == data.objList[i].category2){
	        						if (data.objList[i].category3 == "")
	        							accordionHtml += '<li id="synId'+data.objList[i].sid+'" ng-click="fetchComponent(\'' + encodeURIComponent(JSON.stringify(data.objList[i])).replace(/'/g, "\\'\\'") + '\')">' + data.objList[i].synid + '</li>';
	        						else if (data.objList[i].category3 != "" && (data.objList[i].category4 == ""))
	        							accordionHtml += '<li class="decor-list">' + data.objList[i].category3 + '<ul><li id="synId'+data.objList[i].sid+'" ng-click="fetchComponent(\'' + encodeURIComponent(JSON.stringify(data.objList[i])).replace(/'/g, "\\'\\'") + '\')">' + data.objList[i].synid + '</li>';
	        						else
	        							accordionHtml += '<li class="decor-list">' + data.objList[i].category3 + '<ul><li class="decor-list">' + data.objList[i].category4 + '<ul><li id="synId'+data.objList[i].sid+'" ng-click="fetchComponent(\'' + encodeURIComponent(JSON.stringify(data.objList[i])).replace(/'/g, "\\'\\'") + '\')">' + data.objList[i].synid + '</li>';
        						}else{
        							if (data.objList[i].category3 == "")
	        							accordionHtml += '</ul></li><li class="decor-list">' + data.objList[i].category2 + '<ul><li id="synId'+data.objList[i].sid+'" ng-click="fetchComponent(\'' + encodeURIComponent(JSON.stringify(data.objList[i])).replace(/'/g, "\\'\\'") + '\')">' + data.objList[i].synid + '</li>';
        							else if (data.objList[i].category3 != "" && (data.objList[i].category4 == ""))
	        							accordionHtml += '</ul></li><li class="decor-list">' + data.objList[i].category2 + '<ul><li class="decor-list">' + data.objList[i].category3 + '<ul><li id="synId'+data.objList[i].sid+'" ng-click="fetchComponent(\'' + encodeURIComponent(JSON.stringify(data.objList[i])).replace(/'/g, "\\'\\'") + '\')">' + data.objList[i].synid + '</li>';
	        						else
	        							accordionHtml += '</ul></li><li class="decor-list">' + data.objList[i].category2 + '<ul><li class="decor-list">' + data.objList[i].category3 + '<ul><li class="decor-list">' + data.objList[i].category4 + '<ul><li id="synId'+data.objList[i].sid+'" ng-click="fetchComponent(\'' + encodeURIComponent(JSON.stringify(data.objList[i])).replace(/'/g, "\\'\\'") + '\')">' + data.objList[i].synid + '</li>';
        						}
        					}
        				}else if (data.objList[i-1].category3 != "" && data.objList[i-1].category4 == ""){
        					if (data.objList[i].category2 == ""){
        						accordionHtml += '</ul></li></ul></li><li id="synId'+data.objList[i].sid+'" ng-click="fetchComponent(\'' + encodeURIComponent(JSON.stringify(data.objList[i])).replace(/'/g, "\\'\\'") + '\')">' + data.objList[i].synid + '</li>';
        					}else if (data.objList[i].category2 != "" && data.objList[i].category3 == ""){
        						if (data.objList[i-1].category2 == data.objList[i].category2){
        							accordionHtml += '</ul></li><li id="synId'+data.objList[i].sid+'" ng-click="fetchComponent(\'' + encodeURIComponent(JSON.stringify(data.objList[i])).replace(/'/g, "\\'\\'") + '\')">' + data.objList[i].synid + '</li>';
        						}else{
        							accordionHtml += '</ul></li></ul></li><li class="decor-list">' + data.objList[i].category2 + '<ul><li id="synId'+data.objList[i].sid+'" ng-click="fetchComponent(\'' + encodeURIComponent(JSON.stringify(data.objList[i])).replace(/'/g, "\\'\\'") + '\')">' + data.objList[i].synid + '</li>';
        						}
        					}else if (data.objList[i].category3 != "" && data.objList[i].category4 == ""){
        						if (data.objList[i-1].category2 == data.objList[i].category2){
        							if (data.objList[i-1].category3 == data.objList[i].category3)
        								accordionHtml += '<li id="synId'+data.objList[i].sid+'" ng-click="fetchComponent(\'' + encodeURIComponent(JSON.stringify(data.objList[i])).replace(/'/g, "\\'\\'") + '\')">' + data.objList[i].synid + '</li>';
        							else
        								accordionHtml += '</ul></li><li class="decor-list">' + data.objList[i].category3 + '<ul><li id="synId'+data.objList[i].sid+'" ng-click="fetchComponent(\'' + encodeURIComponent(JSON.stringify(data.objList[i])).replace(/'/g, "\\'\\'") + '\')">' + data.objList[i].synid + '</li>';
        						}else{
        							accordionHtml += '</ul></li></ul></li><li class="decor-list">' + data.objList[i].category2 + '<ul><li class="decor-list">' + data.objList[i].category3 + '<ul><li id="synId'+data.objList[i].sid+'" ng-click="fetchComponent(\'' + encodeURIComponent(JSON.stringify(data.objList[i])).replace(/'/g, "\\'\\'") + '\')">' + data.objList[i].synid + '</li>';
        						}
        					}else if (data.objList[i].category4 != ""){
        						//TO DO
        						if (data.objList[i-1].category2 == data.objList[i].category2){
        							if (data.objList[i-1].category3 == data.objList[i].category3){
        								if (data.objList[i-1].category4 == data.objList[i].category4)
        									accordionHtml += '<li id="synId'+data.objList[i].sid+'" ng-click="fetchComponent(\'' + encodeURIComponent(JSON.stringify(data.objList[i])).replace(/'/g, "\\'\\'") + '\')">' + data.objList[i].synid + '</li>';
        								else
        									accordionHtml += '<li class="decor-list">' + data.objList[i].category4 + '<ul><li id="synId'+data.objList[i].sid+'" ng-click="fetchComponent(\'' + encodeURIComponent(JSON.stringify(data.objList[i])).replace(/'/g, "\\'\\'") + '\')">' + data.objList[i].synid + '</li>';
        							}else{
        								accordionHtml += '</ul></li><li class="decor-list">' + data.objList[i].category3 + '<ul><li class="decor-list">' + data.objList[i].category4 + '<ul><li id="synId'+data.objList[i].sid+'" ng-click="fetchComponent(\'' + encodeURIComponent(JSON.stringify(data.objList[i])).replace(/'/g, "\\'\\'") + '\')">' + data.objList[i].synid + '</li>';
        							}
        						}else{
        							accordionHtml += '</ul></li></ul></li><li class="decor-list">' + data.objList[i].category2 + '<ul><li class="decor-list">' + data.objList[i].category3 + '<ul><li class="decor-list">' + data.objList[i].category4 + '<ul><li id="synId'+data.objList[i].sid+'" ng-click="fetchComponent(\'' + encodeURIComponent(JSON.stringify(data.objList[i])).replace(/'/g, "\\'\\'") + '\')">' + data.objList[i].synid + '</li>';
        						}
        					}
        					
        				}else if (data.objList[i-1].category4 != ""){
        					if (data.objList[i].category2 == ""){
        						accordionHtml += '</ul></li></ul></li></ul></li><li id="synId'+data.objList[i].sid+'" ng-click="fetchComponent(\'' + encodeURIComponent(JSON.stringify(data.objList[i])).replace(/'/g, "\\'\\'") + '\')">' + data.objList[i].synid + '</li>';
        					} else if (data.objList[i].category2 != "" && data.objList[i].category3 == ""){
        						if (data.objList[i-1].category2 == data.objList[i].category2){
        							accordionHtml += '</ul></li></ul></li><li id="synId'+data.objList[i].sid+'" ng-click="fetchComponent(\'' + encodeURIComponent(JSON.stringify(data.objList[i])).replace(/'/g, "\\'\\'") + '\')">' + data.objList[i].synid + '</li>';
        						}else{
        							accordionHtml += '</ul></li></ul></li></ul></li><li class="decor-list">' + data.objList[i].category2 + '<ul><li id="synId'+data.objList[i].sid+'" ng-click="fetchComponent(\'' + encodeURIComponent(JSON.stringify(data.objList[i])).replace(/'/g, "\\'\\'") + '\')">' + data.objList[i].synid + '</li>';
        						}
        					}else if (data.objList[i].category3 != "" && data.objList[i].category4 == ""){
        						if (data.objList[i-1].category2 == data.objList[i].category2){
        							if (data.objList[i-1].category3 == data.objList[i].category3){
        								accordionHtml += '</ul></li><li id="synId'+data.objList[i].sid+'" ng-click="fetchComponent(\'' + encodeURIComponent(JSON.stringify(data.objList[i])).replace(/'/g, "\\'\\'") + '\')">' + data.objList[i].synid + '</li>';
        							}else{
        								accordionHtml += '</ul></li></ul></li><li class="decor-list">'  + data.objList[i].category3 + '<ul><li id="synId'+data.objList[i].sid+'" ng-click="fetchComponent(\'' + encodeURIComponent(JSON.stringify(data.objList[i])).replace(/'/g, "\\'\\'") + '\')">' + data.objList[i].synid + '</li>';
        							}	
        						}else{
        							accordionHtml += '</ul></li></ul></li></ul></li><li class="decor-list">' + data.objList[i].category2 + '<ul><li class="decor-list">' + data.objList[i].category3 + '<ul><li id="synId'+data.objList[i].sid+'" ng-click="fetchComponent(\'' + encodeURIComponent(JSON.stringify(data.objList[i])).replace(/'/g, "\\'\\'") + '\')">' + data.objList[i].synid + '</li>';
        						}
        					}else if (data.objList[i].category4 != ""){
        						if (data.objList[i-1].category2 == data.objList[i].category2){
        							if (data.objList[i-1].category3 == data.objList[i].category3){
        								if (data.objList[i-1].category4 == data.objList[i].category4){
        									accordionHtml += '<li id="synId'+data.objList[i].sid+'" ng-click="fetchComponent(\'' + encodeURIComponent(JSON.stringify(data.objList[i])).replace(/'/g, "\\'\\'") + '\')">' + data.objList[i].synid + '</li>';
        								}else{
        									accordionHtml += '</ul></li><li class="decor-list">' + data.objList[i].category4 + '<ul><li id="synId'+data.objList[i].sid+'" ng-click="fetchComponent(\'' + encodeURIComponent(JSON.stringify(data.objList[i])).replace(/'/g, "\\'\\'") + '\')">' + data.objList[i].synid + '</li>';
        								}
        							}else{
        								accordionHtml += '</ul></li></ul></li><li class="decor-list">'  + data.objList[i].category3 + '<ul><li class="decor-list">' + data.objList[i].category4 + '<ul><li id="synId'+data.objList[i].sid+'" ng-click="fetchComponent(\'' + encodeURIComponent(JSON.stringify(data.objList[i])).replace(/'/g, "\\'\\'") + '\')">' + data.objList[i].synid + '</li>';
        							}
        						}else{
        							accordionHtml += '</ul></li></ul></li></ul></li><li class="decor-list">' + data.objList[i].category2 + '<ul><li class="decor-list">' + data.objList[i].category3 + '<ul><li class="decor-list">' + data.objList[i].category4 + '<ul><li id="synId'+data.objList[i].sid+'" ng-click="fetchComponent(\'' + encodeURIComponent(JSON.stringify(data.objList[i])).replace(/'/g, "\\'\\'") + '\')">' + data.objList[i].synid + '</li>';
        						}
        					}
        				}
        						
        			}else{
        				if (data.objList[i-1].category2 == ""){
        					if (data.objList[i].category2 == "")
        						accordionHtml += '</ul></li><li class="decor-list">'+ data.objList[i].category1 + '<ul><li id="synId'+data.objList[i].sid+'" ng-click="fetchComponent(\'' + encodeURIComponent(JSON.stringify(data.objList[i])).replace(/'/g, "\\'\\'") + '\')">' + data.objList[i] + '</li>';
        					else if (data.objList[i].category2 != "" && data.objList[i].category3 == "")
        						accordionHtml += '</ul></li><li class="decor-list">'+ data.objList[i].category1 + '<ul><li class="decor-list">' + data.objList[i].category2 + '<ul><li id="synId'+data.objList[i].sid+'" ng-click="fetchComponent(\'' + encodeURIComponent(JSON.stringify(data.objList[i])).replace(/'/g, "\\'\\'") + '\')">' + data.objList[i].synid + '</li>';
        					else if (data.objList[i].category3 != "" && data.objList[i].category4 == "")
        						accordionHtml += '</ul></li><li class="decor-list">'+ data.objList[i].category1 + '<ul><li class="decor-list">' + data.objList[i].category2 + '<ul><li class="decor-list">' + data.objList[i].category3 + '<ul><li id="synId'+data.objList[i].sid+'" ng-click="fetchComponent(\'' + encodeURIComponent(JSON.stringify(data.objList[i])).replace(/'/g, "\\'\\'") + '\')">' + data.objList[i].synid + '</li>';
        					else
        						accordionHtml += '</ul></li><li class="decor-list">'+ data.objList[i].category1 + '<ul><li class="decor-list">' + data.objList[i].category2 + '<ul><li class="decor-list">' + data.objList[i].category3 + '<ul><li class="decor-list">' + data.objList[i].category4 + '<ul><li id="synId'+data.objList[i].sid+'" ng-click="fetchComponent(\'' + encodeURIComponent(JSON.stringify(data.objList[i])).replace(/'/g, "\\'\\'") + '\')">' + data.objList[i].synid + '</li>';
        				}else if (data.objList[i-1].category2 != "" && data.objList[i-1].category3 == ""){
        					if (data.objList[i].category2 == "")
        						accordionHtml += '</ul></li></ul></li><li class="decor-list">'+ data.objList[i].category1 + '<ul><li id="synId'+data.objList[i].sid+'" ng-click="fetchComponent(\'' + encodeURIComponent(JSON.stringify(data.objList[i])).replace(/'/g, "\\'\\'") + '\')">' + data.objList[i].synid + '</li>';
        					else if (data.objList[i].category2 != "" && data.objList[i].category3 == "")
        						accordionHtml += '</ul></li></ul></li><li class="decor-list">'+ data.objList[i].category1 + '<ul><li class="decor-list">' + data.objList[i].category2 + '<ul><li id="synId'+data.objList[i].sid+'" ng-click="fetchComponent(\'' + encodeURIComponent(JSON.stringify(data.objList[i])).replace(/'/g, "\\'\\'") + '\')">' + data.objList[i].synid + '</li>';
        					else if (data.objList[i].category3 != "" && data.objList[i].category4 == "")
        						accordionHtml += '</ul></li></ul></li><li class="decor-list">'+ data.objList[i].category1 + '<ul><li class="decor-list">' + data.objList[i].category2 + '<ul><li class="decor-list">' + data.objList[i].category3 + '<ul><li id="synId'+data.objList[i].sid+'" ng-click="fetchComponent(\'' + encodeURIComponent(JSON.stringify(data.objList[i])).replace(/'/g, "\\'\\'") + '\')">' + data.objList[i].synid + '</li>';
        					else
        						accordionHtml += '</ul></li></ul></li><li class="decor-list">'+ data.objList[i].category1 + '<ul><li class="decor-list">' + data.objList[i].category2 + '<ul><li class="decor-list">' + data.objList[i].category3 + '<ul><li class="decor-list">' + data.objList[i].category4 + '<ul><li id="synId'+data.objList[i].sid+'" ng-click="fetchComponent(\'' + encodeURIComponent(JSON.stringify(data.objList[i])).replace(/'/g, "\\'\\'") + '\')">' + data.objList[i].synid + '</li>';

        				}else if (data.objList[i-1].category3 != "" && data.objList[i-1].category4 == ""){
        					if (data.objList[i].category2 == "")
        						accordionHtml += '</ul></li></ul></li></ul></li><li class="decor-list">'+ data.objList[i].category1 + '<ul><li id="synId'+data.objList[i].sid+'" ng-click="fetchComponent(\'' + encodeURIComponent(JSON.stringify(data.objList[i])).replace(/'/g, "\\'\\'") + '\')">' + data.objList[i].synid + '</li>';
        					else if (data.objList[i].category2 != "" && data.objList[i].category3 == "")
        						accordionHtml += '</ul></li></ul></li></ul></li><li class="decor-list">'+ data.objList[i].category1 + '<ul><li class="decor-list">' + data.objList[i].category2 + '<ul><li id="synId'+data.objList[i].sid+'" ng-click="fetchComponent(\'' + encodeURIComponent(JSON.stringify(data.objList[i])).replace(/'/g, "\\'\\'") + '\')">' + data.objList[i].synid + '</li>';
        					else if (data.objList[i].category3 != "" && data.objList[i].category4 == "")
        						accordionHtml += '</ul></li></ul></li></ul></li><li class="decor-list">'+ data.objList[i].category1 + '<ul><li class="decor-list">' + data.objList[i].category2 + '<ul><li class="decor-list">' + data.objList[i].category3 + '<ul><li id="synId'+data.objList[i].sid+'" ng-click="fetchComponent(\'' + encodeURIComponent(JSON.stringify(data.objList[i])).replace(/'/g, "\\'\\'") + '\')">' + data.objList[i].synid + '</li>';
        					else
        						accordionHtml += '</ul></li></ul></li></ul></li><li class="decor-list">'+ data.objList[i].category1 + '<ul><li class="decor-list">' + data.objList[i].category2 + '<ul><li class="decor-list">' + data.objList[i].category3 + '<ul><li class="decor-list">' + data.objList[i].category4 + '<ul><li id="synId'+data.objList[i].sid+'" ng-click="fetchComponent(\'' + encodeURIComponent(JSON.stringify(data.objList[i])).replace(/'/g, "\\'\\'") + '\')">' + data.objList[i].synid + '</li>';
        				}else{
        					if (data.objList[i].category2 == "")
        						accordionHtml += '</ul></li></ul></li></ul></li></ul></li><li class="decor-list">'+ data.objList[i].category1 + '<ul><li id="synId'+data.objList[i].sid+'" ng-click="fetchComponent(\'' + encodeURIComponent(JSON.stringify(data.objList[i])).replace(/'/g, "\\'\\'") + '\')">' + data.objList[i].synid + '</li>';
        					else if (data.objList[i].category2 != "" && data.objList[i].category3 == "")
        						accordionHtml += '</ul></li></ul></li></ul></li></ul></li><li class="decor-list">'+ data.objList[i].category1 + '<ul><li class="decor-list">' + data.objList[i].category2 + '<ul><li id="synId'+data.objList[i].sid+'" ng-click="fetchComponent(\'' + encodeURIComponent(JSON.stringify(data.objList[i])).replace(/'/g, "\\'\\'") + '\')">' + data.objList[i].synid + '</li>';
        					else if (data.objList[i].category3 != "" && data.objList[i].category4 == "")
        						accordionHtml += '</ul></li></ul></li></ul></li></ul></li><li class="decor-list">'+ data.objList[i].category1 + '<ul><li class="decor-list">' + data.objList[i].category2 + '<ul><li class="decor-list">' + data.objList[i].category3 + '<ul><li id="synId'+data.objList[i].sid+'" ng-click="fetchComponent(\'' + encodeURIComponent(JSON.stringify(data.objList[i])).replace(/'/g, "\\'\\'") + '\')">' + data.objList[i].synid + '</li>';
        					else
        						accordionHtml += '</ul></li></ul></li></ul></li></ul></li><li class="decor-list">'+ data.objList[i].category1 + '<ul><li class="decor-list">' + data.objList[i].category2 + '<ul><li class="decor-list">' + data.objList[i].category3 + '<ul><li class="decor-list">' + data.objList[i].category4 + '<ul><li id="synId'+data.objList[i].sid+'" ng-click="fetchComponent(\'' + encodeURIComponent(JSON.stringify(data.objList[i])).replace(/'/g, "\\'\\'") + '\')">' + data.objList[i].synid + '</li>';
        				}
        			}
        		}
        	}
        	
        	//Close list at the end of the category list
			if(data.objList[catLength].category2 == "")
				accordionHtml += '</ul></li></ul>';
			else if (data.objList[catLength].category2 != "" && data.objList[catLength].category3 == "")
				accordionHtml += '</ul></li></ul></li></ul>';
			else if (data.objList[catLength].category2 != "" && data.objList[catLength].category3 != "" && data.objList[catLength].category4 == "")
				accordionHtml += '</ul></li></ul></li></ul></li></ul>';
			else
				accordionHtml += '</ul></li></ul></li></ul></li></ul></li></ul>';
			
        	accordionHtml += '</div>';
        	//$('#accordion-div').append(accordionHtml);
        	//var amenuOptions = {menuId: "accordion", linkIdToMenuHtml: null, expand: "single", speed: 200, license: "2a8e9"};
			//McAcdnMenu(amenuOptions);
        }
     }
    });
	return accordionHtml;
}

