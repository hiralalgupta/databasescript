// JavaScript Document
$(document).ready(function() {
	stickFooter();
	$(window).resize(function() {
		stickFooter();
	});
	if ($("div").hasClass( "ruleutility")){
		$("#wrap").addClass("blue-bg");
	}else{
		$("#wrap").css("background","white");
	}
	/*$("#TimeLine").change(function() {
		buildAccodionCategory($("#TimeLine").val());
	});*/
	
});

function stickFooter() {
	var hHeight =  $("#header").height();
	var fHeight = $("#footer").innerHeight();
	var winHeight = $(window).innerHeight();
	$("body > #wrap").css({"padding-bottom": fHeight + 20, "padding-top": hHeight  });
	$("body > #wrap").css({"min-height": winHeight });
}

$('.table-responsive').on('show.bs.dropdown', function () {
     $('.table-responsive').css( "overflow", "inherit" );
});

$('.table-responsive').on('hide.bs.dropdown', function () {
     $('.table-responsive').css( "overflow", "auto" );
})

