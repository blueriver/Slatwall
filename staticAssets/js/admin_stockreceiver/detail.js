jQuery(function() {
	
	// Bind onchange to the location select box so that we can "dim" out TRs that are not of that location
	jQuery("#detailStockReceiver .receiveForLocationID").change(function(e){
		var locationID = jQuery(this).val()
		var locationName = jQuery(".receiveForLocationID option[value=" + locationID + "]").text();
		
		// For each th and tr in the table, highlight the cell if it has the selected location id
		jQuery("#detailStockReceiver th, #detailStockReceiver td").each(function(){
			if(jQuery(this).data("locationid") == locationID){
				jQuery(this).addClass("highlighted");
			} else {
				jQuery(this).removeClass("highlighted");
			}
		})
		
		// Update the "Due in after" location name
		jQuery(".dueInAfterLocationTitle").html(locationName);
		
		// Trigger a keyup event on the quantity boxes to update the totals
		jQuery("input.receivingQuantityInput").trigger("keyup");
	});
	
	
	
	// Bind keyup on quantity boxes
	jQuery("input.receivingQuantityInput").keyup(function(){
		var $quantityInput = jQuery(this);
		var locationID = jQuery("#detailStockReceiver .receiveForLocationID").val();
		
		if(jQuery.isNumeric($quantityInput.val())) {
			// Get the value stored in the table for quantity due in for the selected locationid. Look in the same TR as the input that was typed into.
			jQuery(".dueInQuantity", $quantityInput.parents("tr").first()).each(function(){
				if(jQuery(this).data("locationid") == locationID) {
					dueInQuantity = parseInt(jQuery(this).html());
				}
			});
			
			// Then get the due in quantities across ALL locations, and add them up
			var dueInQuantityAllLocations = 0;
			jQuery(".dueInQuantity", $quantityInput.parents("tr").first()).each(function(){
				dueInQuantityAllLocations += parseInt(jQuery(this).html())
			});
				
			// Update the "Due In After" columns 	
			jQuery(".dueInAfterCount", $quantityInput.parents("tr").first()).html(dueInQuantity - parseInt($quantityInput.val()));
			jQuery(".dueInAfterAllLocationsCount", $quantityInput.parents("tr").first()).html(dueInQuantityAllLocations - parseInt($quantityInput.val()));
		} else {
			jQuery(".dueInAfterCount", $quantityInput.parents("tr").first()).html("");
			jQuery(".dueInAfterAllLocationsCount", $quantityInput.parents("tr").first()).html("");
		}
	});
	
	// Trigger the recieve location drop-down selection event to initialize the interface.
	jQuery("#detailStockReceiver .receiveForLocationID").trigger("change");
	
});