/**
 * 
 * @depends /admin/core.js
 */

jQuery(function() {

	jQuery('#addOptionButton').click(function(){
	 	jQuery('#addOptionHidden').val('true');
		jQuery('#optionInputs').fadeIn(400);
		jQuery(this).remove();
	});
	
	$("#showOptionSort").click(function(e){
		e.preventDefault();
		$("#Options tbody").sortable().disableSelection();
		$('#showOptionSort').hide();
		$('#saveOptionSort').show();
		
		$(".handle").each(
			function(index) {
				$(this).show();
			}
		);
		return false;
	});
	
	$("#saveOptionSort").click(function(e){
		e.preventDefault();
		var attArray=new Array();
		
		$("#OptionList > tr").each(
			function(index) {
				attArray.push( $(this).attr("id") );
			}
		);
		
		var url = "index.cfm";
		var pars = 'slatAction=admin:option.saveOptionSort&optionIDs=' + attArray.toString() + '&cacheID=' + Math.random();	
		
		$.post(url + "?" + pars); 
		
		$('#showOptionSort').show();
		$('#saveOptionSort').hide();
	
		$(".handle").each(
			function(index) {
				$(this).hide();
			}
		);
	
		$("#Options tbody").sortable('destroy').enableSelection();
		
		stripe('.stripe');
	});
	 
});