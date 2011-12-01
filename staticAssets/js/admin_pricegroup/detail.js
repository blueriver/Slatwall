jQuery(function() {

	jQuery('#addPriceGroupRateButton').click(function(){
	 	jQuery('#addPriceGroupRateHidden').val('true');
		jQuery('#priceGroupRateInputs').fadeIn(400);
		jQuery(this).remove();
	});
	

	
	jQuery('input[name="globalFlag"]').click(function(){
	 	if(jQuery(this).val() == '1')
			jQuery('#priceGroupRate_globalOffInputs').fadeOut(400);
		else
			jQuery('#priceGroupRate_globalOffInputs').fadeIn(400);
	});
	 
});
	