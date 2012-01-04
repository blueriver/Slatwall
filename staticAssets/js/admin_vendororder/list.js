/**
 * 
 * @depends /admin/core.js
 */

jQuery(document).ready(function(){
	jQuery("a#showAdvancedSearch").click(function(){
		jQuery("#advancedSearchOptions").show();
		jQuery("a#showAdvancedSearch").hide();
		return false;
	});
	
	
	jQuery("a#clearDates").click(function(){
		jQuery("input.datepicker").val("");
		return false;
	});
});