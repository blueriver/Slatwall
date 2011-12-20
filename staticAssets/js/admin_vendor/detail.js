jQuery(function() {

	jQuery('#addVendorAddressButton').click(function(){
	 	jQuery('#populateSubProperties').val('true');
		jQuery('#vendorAddressInputs').fadeIn(400);
		jQuery(this).remove();
	});

	 
});
	