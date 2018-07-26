/*$(document).ready(function() {
	$("#href").click(function(event) {
		callAjax();
	});
});*/
function callAjax() {
		var search = {}
		search["username"] = $("#username").val();
		search["email"] = $("#email").val();
		$.ajax({
			type: "GET",
		  	url: "admin/getuserDetails/1",
		  	async: false,
		  	success: function(data) {
		  		console.log("SUCCESS: ", data);
				display(data);
		  },
			error : function(e) {
				console.log("ERROR: ", e);
				display(e);
			},
			done : function(e) {
				console.log("DONE");
				enableSearchButton(true);
			}
		});

	}

function display(data) {
	var json = "<h4>Ajax Response</h4><pre>"
			+ JSON.stringify(data, null, 4) + "</pre>";
	$('#feedback').html(json);
}

function displayCli() {
	alert("hi..");
}
		