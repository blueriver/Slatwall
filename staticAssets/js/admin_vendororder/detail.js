jQuery(function() {
	
	/*
	 * Functions for the Vendor Order receiver interface. 
	 */
	
	// Bind onchange to the location select box so that we can "dim" out TRs that are not of that location
	jQuery(".receiveForLocationID").change(function(e){
		var locationID = jQuery(this).val().toLowerCase();
		
		// Loop over all TRs in the table and check if they have the clicked locationID. If not, dim, and if so, remove the dim
		jQuery("#detailVendorOrderReceiver tr").each(function(){
			var foundLocationId = jQuery(this).data("locationid");
			foundLocationId = foundLocationId != undefined ? foundLocationId.toLowerCase() : "";
			
			if(foundLocationId == locationID){
				jQuery(this).removeClass("dim");
			} else if(foundLocationId != "") {
				jQuery(this).addClass("dim");
			}
		})	
	});

	
	/*
	 *  Functions for Vendor Order Item dialog
	 */
	
	// Initialize the dialog.
	jQuery("#addEditProductToOrder").dialog({
       autoOpen: false,
       modal: true,
       width: "80%",
	   draggable: false,
	   dialogClass: "vendorOrderItemDialog"
	});
	
	// Bind the actual opening action of the dialog to the <A> click.
	jQuery(".productsFromVendorOutput a.dialogLink").click(function(e){
		// Set the source of the iframe to the href of the clicked link.
		//jQuery("#addEditProductToOrder iframe").attr("src", jQuery(this.attr("href"))); 
		
		// Inject the iframe and open the dialog.
		$("#addEditProductToOrder").load(jQuery(this).attr("href") + "&inDialog=true", function(){
			// Trigger the keyup event once on one of the inputs so that the value populate on page load
			jQuery("input.skucost").first().trigger("keyup");	
			$("#addEditProductToOrder").dialog("open");
		});
		
		// Prevent the default href action.
		e.preventDefault();
	});
	
	
	// Bind the change handlers
	jQuery("input.skulocationqty, input.skucost").live("keyup", function(){
		// Update each of the sku totals (on the right) by grabbing the cost of this row, then looping over all qry fields, adding them up.
		jQuery("td.skutotal").each(function(){
			// For each skutotal TD, get the cost field, and total up all of the qty fields, in that TR
			var cost = jQuery(this).parent("tr").first().find("input.skucost").val();
			var totalQty = 0;
			jQuery(this).parent("tr").first().find("input.skulocationqty").each(function(){
				if(jQuery.isNumeric(jQuery(this).val())) {
					totalQty += parseInt(jQuery(this).val());
				}
			});
			
			// Format to to the current currency. Function expects currentMask="$0.00" to exist as a javascript variable.
			if (jQuery.isNumeric(cost)) {
				jQuery(this).html(currentMask.replace("0.00", (cost * totalQty).toFixed(2)) + " (" + totalQty + " item" + (totalQty != 1 ? "s" : "")+ ")");
			} else {
				jQuery(this).html("");
			}
		});
		
		// Update each of the location totals (on the bottom) by grabbing the qty fields, checking if it is the correct location ID, adding them up (since no s).
		jQuery("td.locationtotal").each(function(){
			var locationid = jQuery(this).data("locationid");
			var totalQty = 0;
			var totalCost = 0;
			jQuery("input.skulocationqty").each(function(){
				if(jQuery(this).data("locationid") == locationid && jQuery.isNumeric(jQuery(this).val())) {
					var qty = parseInt(jQuery(this).val());
					totalQty += qty;
					
					// Grab the cost input (to the left) and find the local cost for this sku/location.
					jQuery(this).parents("tr").first().find("input.skucost").each(function(){
						// There will only be one iteration of this loop (one cost field per row).
						totalCost += jQuery(this).val() * qty;
					});
				}
			});
			
			jQuery(this).html(currentMask.replace("0.00", totalCost.toFixed(2)) + " (" + totalQty + " item" + (totalQty != 1 ? "s" : "")+ ")");
		})
	})

});
	