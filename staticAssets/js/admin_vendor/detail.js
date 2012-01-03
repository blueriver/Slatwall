jQuery(function() {

	jQuery('#addVendorAddressButton').click(function(){
		// If we are adding an address, then take address out of list of ignored fields for the autopopulation logic.
	 	jQuery('#ignoreProperties').listDeleteVal("vendorAddresses");
		jQuery('#vendorAddressInputs').fadeIn(400);
		jQuery(this).remove();
	});

	 
});
	