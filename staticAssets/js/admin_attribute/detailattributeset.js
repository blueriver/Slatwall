/**
 * 
 * @depends /admin/core.js
 */

jQuery(function() {

	jQuery('#addAttributeButton').click(function(){
	 	jQuery('#populateSubPropertiesHidden').val('true');
		jQuery('#attributeInputs').fadeIn(400);
		jQuery(this).remove();
	});
	
	$("#showAttributeSort").click(function(e){
		e.preventDefault();
		$("#Attributes tbody").sortable().disableSelection();
		$('#showAttributeSort').hide();
		$('#saveAttributeSort').show();
		
		$(".handle").each(
			function(index) {
				$(this).show();
			}
		);
		return false;
	});
	
	$("#saveAttributeSort").click(function(e){
		e.preventDefault();
		var attArray=new Array();
		
		$("#AttributeList > tr").each(
			function(index) {
				attArray.push( $(this).attr("id") );
			}
		);
		
		var url = "index.cfm";
		var pars = 'slatAction=admin:attribute.saveAttributeSort&attributeIDs=' + attArray.toString() + '&cacheID=' + Math.random();	
		
		$.post(url + "?" + pars); 
		
		$('#showAttributeSort').show();
		$('#saveAttributeSort').hide();
	
		$(".handle").each(
			function(index) {
				$(this).hide();
			}
		);
	
		$("#Attributes tbody").sortable('destroy').enableSelection();
		
		stripe('.stripe');
	});
	 
});