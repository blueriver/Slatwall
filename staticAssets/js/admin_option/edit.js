
/**
 * 
 * @depends /admin/core.js
 */

$(document).ready(function(){
	
	$("#showSort").click(function(){
		$("#optionList").sortable().disableSelection();
		$('#showSort').hide();
		$('#saveSort').show();
		
		$(".handle").each(
			function(index) {
				$(this).show();
			}
		);
		return false;
	});
	
	$("#saveSort").click(function(){
		var attArray=new Array();
		
		$("#optionList > li").each(
			function(index) {
				attArray.push( $(this).attr("optionID") );
			}
		);
		
		var url = "index.cfm";
		var pars = 'slatAction=admin:option.saveoptionsort&optionID=' + attArray.toString() + '&cacheID=' + Math.random();	
		
		$.post(url + "?" + pars); 
		showSort();
	});
});
	
function showSort(id){
	$('#showSort').show();
	$('#saveSort').hide();
	
	$(".handle").each(
		function(index) {
			$(this).hide();
		}
	);
	jQuery("#optionList").sortable('destroy').enableSelection();
}
