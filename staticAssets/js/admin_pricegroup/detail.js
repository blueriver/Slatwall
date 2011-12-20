jQuery(function() {

	jQuery('#addPriceGroupRateButton').click(function(){
	 	jQuery('#populateSubProperties').val('true');
		jQuery('#priceGroupRateInputs').fadeIn(400);
		jQuery(this).remove();
	});
	
	// If Price Group Rate type is percentageOff, then enable the rounding rule. Also, change the name of the "value" input to map property to the entity's properties.
	jQuery("#priceGroupRateType").change(function(){
		if (jQuery(this).val() == "percentageOff") {
			jQuery("#amountOffDiv input, #amountDiv input").val("");
			
			jQuery("#percentageOffDiv").css("display", "inline");
			jQuery("#amountOffDiv, #amountDiv").hide();
			jQuery("#roundingRuleDiv").fadeIn(400);		
		}
		else if (jQuery(this).val() == "amountOff") {
			jQuery("#percentageOffDiv input, #amountDiv input").val("");
			
			jQuery("#amountOffDiv").css("display", "inline");
			jQuery("#percentageOffDiv, #amountDiv").hide();
			jQuery("#roundingRuleDiv").fadeOut(400);
			jQuery("#roundingRuleDiv select").val("");
		}
		else if (jQuery(this).val() == "amount") {
			jQuery("#percentageOffDiv input, #amountOffDiv input").val("");
			
			jQuery("#percentageOffDiv, #amountOffDiv").hide();
			jQuery("#amountDiv").css("display", "inline");
			jQuery("#roundingRuleDiv").fadeOut(400);
			jQuery("#roundingRuleDiv select").val("");
		}
	})
	
	// Set up the warning message when GlobalFlag is turned on.
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
	
	jQuery("#priceGroupRateType").change();
	
	 
});
	