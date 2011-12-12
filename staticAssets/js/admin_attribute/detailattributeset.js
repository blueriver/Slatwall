/**
 * 
 * @depends /admin/core.js
 */

jQuery(function() {

	var addClicks = 0;

	jQuery('#addAttributeButton').click(function(){
	 	jQuery('#populateSubPropertiesHidden').val('true');
		jQuery('#attributeInputs').fadeIn(400);
		jQuery(this).remove();
	});
	
	jQuery('#addAttributeOptionButton').click(function(){
		jQuery('#removeAttributeOptionButton').show();
	 	var inputNum = jQuery('#attributeOptionsTable tr').length;
		jQuery('#attributeOptionsTable tr:last').after('<tr><td><input type="hidden" name="attributes[1].attributeOptions[' + inputNum + '].attributeOptionID" value="" /><input name="attributes[1].attributeOptions[' + inputNum + '].attributeOptionValue" /></td><td><input name="attributes[1].attributeOptions[' + inputNum + '].attributeOptionLabel" /></td><td></td></tr>');
		stripe('.stripe');
		addClicks = addClicks + 1;
	});
	
	jQuery('#removeAttributeOptionButton').click(function(){
		if(jQuery('#attributeOptionsTable tr').length > 1) {
			var inputNum = jQuery('#attributeOptionsTable tr:last').remove();	
		}
	 	if(addClicks == 1) {
			jQuery('#removeAttributeOptionButton').hide();
		}
		addClicks = addClicks - 1;
	});
	
	jQuery('.attributetypefield').change(function(e){
		updateAttributeFieldsToDisplay();
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
	
	updateAttributeFieldsToDisplay();
	 
});

function updateAttributeFieldsToDisplay() {
	
	var attributeOptionsNeededList = "444df2d2bd86e1f290c2cce99d5ca2d8,444df2d5973447a85033d6c6735e002a,444df2a9fe732d3ec9d8b495ab1dddf7,444df2a8bfb73ecb3a777c8599950d5f";
	var attributeValidationNeededList = "444df2a5a9088e72342c0b5eaf731c64"
	
	if(attributeOptionsNeededList.indexOf(jQuery('.attributetypefield').val()) > -1) {
		jQuery('#attributeOptionInputs').show();
	} else {
		jQuery('#attributeOptionInputs').hide();
	}
	if(attributeValidationNeededList.indexOf(jQuery('.attributetypefield').val()) > -1) {
		jQuery('#attributeValidationInputs').show();
	} else {
		jQuery('#attributeValidationInputs').hide();
	}
}
