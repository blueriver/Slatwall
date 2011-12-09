jQuery(function() {

	jQuery('#addPriceGroupRateButton').click(function(){
	 	jQuery('#addPriceGroupRateHidden').val('true');
		jQuery('#priceGroupRateInputs').fadeIn(400);
		jQuery(this).remove();
	});
	
	// If Price Group Rate type is percentageOff, then enable the rounding rule
	jQuery("#priceGroupRateType").change(function(){
		if(jQuery(this).val() == "percentageOff")
			jQuery("#roundingRuleDiv").fadeIn(400);
		else{
			jQuery("#roundingRuleDiv").fadeOut(400);
			jQuery("#roundingRuleDiv select").val("");
		}
	})
	
	// Set up the warning message when GlobalFlag is turned on. name~="globalFlag" is a "contains"-version of the attribute selector. This prevents us from having to write name="PriceGroupRates[0].globalFlag" and escaping it.
	jQuery('#globalRateControls input').click(function(){
	 	if (jQuery(this).val() == '1') {
			jQuery('#priceGroupRate_globalOffInputs').fadeOut(400);
			jQuery("#priceGroupRate_globalWarning").fadeIn(400);
		}
		else {
			jQuery('#priceGroupRate_globalOffInputs').fadeIn(400);
			jQuery("#priceGroupRate_globalWarning").fadeOut(400);
		}
	});
	
	
	 
});
	