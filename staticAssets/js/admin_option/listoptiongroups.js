/**
 * 
 * @depends /admin/core.js
 */

jQuery(document).ready(function(){
	
	jQuery("#showOptionGroupSort").click(function(e){
		e.preventDefault();
		jQuery("#OptionGroups tbody").sortable().disableSelection();
		jQuery('#showOptionGroupSort').hide();
		jQuery('#saveOptionGroupSort').show();
		
		jQuery(".handle").each(
			function(index) {
				$(this).show();
			}
		);
		return false;
	});
	
	jQuery("#saveOptionGroupSort").click(function(e){
		e.preventDefault();
		var attArray=new Array();
		
		jQuery("#OptionGroupList > tr").each(
			function(index) {
				attArray.push( $(this).attr("id") );
			}
		);
		
		var url = "index.cfm";
		var pars = 'slatAction=admin:option.saveOptionGroupSort&optionGroupIDs=' + attArray.toString() + '&cacheID=' + Math.random();	
		
		jQuery.post(url + "?" + pars); 
		
		jQuery('#showOptionGroupSort').show();
		jQuery('#saveOptionGroupSort').hide();
	
		jQuery(".handle").each(
			function(index) {
				$(this).hide();
			}
		);
	
		jQuery("#OptionGroups tbody").sortable('destroy').enableSelection();
		
		stripe('.stripe');
	});
	
});	