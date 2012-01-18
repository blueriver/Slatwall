/**
 * 
 * @depends /admin/core.js
 */

jQuery(document).ready(function(){
	
	jQuery("a.paymentDetails").click(function(){
		jQuery(this).parent().hide();
		jQuery(this).parent().siblings().show()
		var id = jQuery(this).attr("id").substring(5);
		jQuery('#orderDetail_' + id).toggle();
		return false;
	});
	
	jQuery("a.customizations").click(function(){
		jQuery(this).parent().hide();
		jQuery(this).parent().siblings().show()
		jQuery(this).parents('ul').next('div').toggle();
		return false;
	});
	
    jQuery(".adminorderrefundOrderPayment").colorbox({
		onComplete: function() {
            jQuery('input.refundAmount').focus();         
        }
	});
	
	/*
		Relate to Order Refund Creation
	*/
	
	jQuery("#orderReturnEdit .refundShippingAmountLink").click(function(e){
		// refundFulfillmentAmountDefault is global variable pulled from a <script> tag in the view.
		jQuery("#refundShippingAmountInput").val(refundFulfillmentAmountDefault);
		jQuery("#refundShippingAmountInput").trigger("keyup");
		e.preventDefault();
	})
	
	
	updateSummary = function() {
		var subTotal = 0;
		var taxTotal = 0;
		var fulfillmentReturnAmount = 0;
		
		if(typeof(currentMask) == "undefined") {
			currentMask = "0.00";
		}

		// Loop over each <td class="returnExtendedAmount"> in the table and extract the stored "total"
		
		jQuery("#OrderReturnEditTable .returnExtendedAmount").each(function(){
			//if(jQuery(this).data("total") != undefined) {
				subTotal += jQuery(this).data("total");
			//}
		}) 		
		
		jQuery("#summarySubTotal").html(currentMask.replace("0.00", subTotal.toFixed(2)));
		
		// Calculate tax by looping over all TRs in the table, pulling out the tax rate in data-taxrate, and multiplying it with the total.
		jQuery("#OrderReturnEditTable tbody tr").each(function(){
			var rate = jQuery(this).data("taxrate") / 100;
			taxTotal += rate * jQuery(".returnExtendedAmount", jQuery(this)).data("total");
		});
				
		if(jQuery.isNumeric(jQuery("#refundShippingAmountInput").val())) {
			fulfillmentReturnAmount = parseInt(jQuery("#refundShippingAmountInput").val());
		}
		
		jQuery("#summaryTaxTotal").html(currentMask.replace("0.00", taxTotal.toFixed(2)));
		jQuery("#summaryTotalRefunded").html(currentMask.replace("0.00", (subTotal + taxTotal + fulfillmentReturnAmount).toFixed(2)));
		
	}
	
	updateRowFn = function(){
		// This function could have been called from either the price or quantity inputs. Backtrack up the DOM to the TR, and then track back in to find the inputs for the current row
		$tr = jQuery(this).parents("tr").first();
		var price = jQuery(".priceReturningInput", $tr).val();
		var quantity = jQuery(".quantityReturningSelect", $tr).val();
		var total = price * parseInt(quantity);
		
		if(!jQuery.isNumeric(total)) {
			total = 0;
		}
		
		jQuery(".returnExtendedAmount", $tr).html(currentMask.replace("0.00", total.toFixed(2)));
		jQuery(".returnExtendedAmount", $tr).data("total", total);		
		
		updateSummary();
	}
	
	
	
	jQuery("#orderReturnEdit .priceReturningInput").keyup(updateRowFn);
	jQuery("#orderReturnEdit .quantityReturningSelect").change(updateRowFn);
	jQuery("#orderReturnEdit #refundShippingAmountInput").keyup(updateSummary);
	
	// Initialize by first triggering the keyup even on all return price inputs
	jQuery("#orderReturnEdit .priceReturningInput").trigger("keyup");
	updateSummary();
	
});