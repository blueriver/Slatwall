jQuery(function() {
	
	// Bind onChange handler to type drop down, to show/hide location select
	jQuery(".stockAdjustmentTypeID").change(function(){
		
		if(jQuery(this).val() == "444df2e5cb27169f418279f3f859a4f7") {
			// Location - Location transfer. Show both.
			jQuery("#fromLocationDiv, #toLocationDiv").show().children("select").attr("disabled", false);
			
		} else if(jQuery(this).val() == "444df2e60db81c12589c9b39346009f2") {	
			// Manual In.
			jQuery("#fromLocationDiv").hide().children("select").attr("disabled", true);
			jQuery("#toLocationDiv").show().children("select").attr("disabled", false);
			
		} else if(jQuery(this).val() == "444df2e7dba550b7a24a03acbb37e717") {	
			// Manual Out
			jQuery("#fromLocationDiv").show().children("select").attr("disabled", false);
			jQuery("#toLocationDiv").hide().children("select").attr("disabled", true);
		}
	})
	
	/*
	 *  Functions for dialog
	 */
	
	// Initialize the dialog.
	jQuery("#addEditStockAdjustmentItems").dialog({
       autoOpen: false,
       modal: true,
       //width: "80%",
	   draggable: false,
	   dialogClass: "stockAdjustmentItemsDialog"
	});
	
	// Bind the actual opening action of the dialog to the <A> click.
	jQuery(".addProductButton").click(function(e){
		// Set the source of the iframe to the href of the clicked link.
		//jQuery("#addEditProductToOrder iframe").attr("src", jQuery(this.attr("href"))); 
		
		// Load the content and open the dialog.
		$("#addEditProductToOrder").load(jQuery(this).attr("href") + "&inDialog=true", function(){
			// Apply the "stripe" class to the new table loaded dynamically.
			stripe("stripepopup");
			
			// Trigger the keyup event once on one of the inputs so that the value populate on page load	
			$("#addEditStockAdjustmentItems").dialog("open");
		});
		
		// Prevent the default href action.
		e.preventDefault();
	});
	
	jQuery("#... .cancel").click(function(e){
		$("#addEditStockAdjustmentItems").dialog("close");
		
		// Since we cancelled, erase any HTML that was loaded into the dailog's div so that it doesn't save.
		$("#addEditStockAdjustmentItems").html("");
		e.preventDefault();
	})
	
	// Jog the change event so that the location inputs initialize
	jQuery(".stockAdjustmentTypeID").trigger("change");
	
});

