var currentNewRate = 1;

$(document).ready(function(){
	swapShippingMethods( shippingProvider );
	
	$("#shippingProvider").change(function(){
		swapShippingMethods($("#shippingProvider option:selected").text());
	});
	
	$("#addRate").click(function(){
		var appendContent = $(".template").html();
		appendContent = appendContent.replace(/.new./g, ".new" + currentNewRate + ".")
		$("#shippingRates > tbody:last").append(appendContent);
		currentNewRate++;
	});
});

function swapShippingMethods( selectionName ) {
	if(selectionName == "") {
		selectionName = "Rate";
	}
	var selector = ".spm" + selectionName;
	$("#spdshippingprovidermethod").html($(selector).html());
}

function addRateRow() {
	$(".rateTemplate").clone(true).appendTo("#ratesTable");
}