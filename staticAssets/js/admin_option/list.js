/**
 * 
 * @depends /admin/core.js
 * 
 */

$(document).ready(function(){
	
	$("#showSort").click(function(){
		$("#OptionGroups tbody").sortable().disableSelection();
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
		
		$("#OptionGroupList > tr").each(
			function(index) {
				attArray.push( $(this).attr("id") );
			}
		);
		
		var url = "index.cfm";
		var pars = 'slatAction=admin:option.saveOptionGroupSort&optionGroupID=' + attArray.toString() + '&cacheID=' + Math.random();	
		
		$.post(url + "?" + pars); 
		showSort();
	});
});

function showSort(){
	$('#showSort').show();
	$('#saveSort').hide();
	
	$(".handle").each(
		function(index) {
			$(this).hide();
		}
	);
	
	$("#OptionGroups tbody").sortable('destroy').enableSelection();
}
