jQuery(function() {

	jQuery('#addPriceGroupRateButton').click(function(){
	 	jQuery('#addPriceGroupRateHidden').val('true');
		jQuery('#priceGroupRateInputs').fadeIn(400);
		jQuery(this).remove();
	});
	
	// If Price Group Rate type is percentageOff, then enable the rounding rule
	jQuery("#priceGroupRateType").change(function(){
		if($(this).val() == "percentageOff")
			$("#roundingRuleDiv").fadeIn(400);
		else{
			$("#roundingRuleDiv").fadeOut(400);
			$("#roundingRuleDiv select").val("");
		}
	})
	
	jQuery('input[name="globalFlag"]').click(function(){
	 	if(jQuery(this).val() == '1')
			jQuery('#priceGroupRate_globalOffInputs').fadeOut(400);
		else
			jQuery('#priceGroupRate_globalOffInputs').fadeIn(400);
	});
	 
});
	