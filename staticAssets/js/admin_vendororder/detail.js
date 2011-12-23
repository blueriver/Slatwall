jQuery(function() {

	/*jQuery('.productsFromVendorOutput a').click(function(e){
		// Move up the dom and find the <tr>, and pull it's data-productid attribute.
		var productid = $(this).parents("tr").first().data("productid");
	
		
		var $div = jQuery("#addEditProductToOrder");
		actionDialog($div, function(){}, function(){}, function(){});
		
		// Prevent the default href action.
		e.preventDefault();
	});*/
	
	/*
	 *  Functions for Price group item dialog
	 */
	
	// Bind the change handlers
	jQuery("input.skulocationqty, input.skucost").change(function(){
		// Update the sku total (on the right) by grabbing 
		jQuery("td.skutotal").each(function(){
			// For each skutotal TD, get the cost field, and total up all of the qty fields, in that TR
			var cost = jQuery(this).parent("tr").first().find("input.skucost").val();
			var totalQty = 0;
			jQuery(this).parent("tr").first().find("input.skulocationqty").each(function(){
				if(jQuery.isNumeric(jQuery(this).val())) {
					totalQty += parseInt(jQuery(this).val());
				}
			});

			alert(totalQty);
		})
	})

	 
});
	