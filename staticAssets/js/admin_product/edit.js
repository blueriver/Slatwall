/**
 * 
 * @depends /admin/core.js
 * 
 */

jQuery(document).ready(function() {
	
    var skuCount = jQuery('tr[id^="Sku"]').length;
	
    $("#addSKU").click(function() {
        var current = jQuery('tr[id^="Sku"]').length;
        current++;
        var $newSKU= jQuery( "#tableTemplate tbody>tr:last" ).clone(true);
        $newSKU.children("td").children("input").each(function(i) {
            var $currentElem= $(this);
            if ($currentElem.attr("type") != "radio") {
                $currentElem.attr("name", "skus[" + current + "]." + $currentElem.attr("name"));
            }
        });
        $newSKU.children("td").children("select").each(function(i) {
            var $currentElem= $(this);
            $currentElem.attr("name","skus["+current+"]."+$currentElem.attr("name"));
        });
        $('#remSKU').attr('style','');
        $('#skuTable > tbody:last').append($newSKU);
        $newSKU.attr("id","Sku" + current);
        // add stripe to row
        if(current % 2 == 1) {
            $newSKU.addClass("alt");
        }
    });
    
    $('#remSKU').click(function() {
        var num = jQuery('tr[id^="Sku"]').length;
        $('#Sku' + num).remove();
        // can't remove more skus than were originally present
        if(num-1 == skuCount) {
            jQuery('#remSKU').attr('style','display:none;');
        }
    });
	
    $("#addImage").click(function() {
        var current = jQuery('input.imageid').length;
        current++;
        var $newImage= jQuery( "#imageUploadTemplate" ).clone(true);
        $newImage.children("dd").children("input").each(function(i) {
            var $currentElem= $(this);
            $currentElem.attr("name", "images[" + current + "]." + $currentElem.attr("name"));
            if ($currentElem.attr("type") == "hidden") {
                $currentElem.attr("class", "imageid");
            }
        });
        $newImage.children("dd").children("select").each(function(i) {
            var $currentElem= $(this);
            $currentElem.attr("name","images["+current+"]."+$currentElem.attr("name"));
        });
        $newImage.children("dd").find("textarea").each(function(i) {
			var $currentElem = $(this);
			$currentElem.attr("name","images["+current+"]."+$currentElem.attr("name"));
			$currentElem.attr("id",$currentElem.attr("id") + current);
			$currentElem.addClass("wysiwyg").addClass("Basic");
        });
		if($('.alternateImageUpload').length == 0) {
			$('.buttons:last').before($newImage);
		} else {
			$('.alternateImageUpload:last').after($newImage);	
		}
		$newImage.children("dd").find("textarea.wysiwyg").each(function(i){
			setRTE($(this));
		});
        $newImage.removeAttr("id");
		$newImage.attr("class","alternateImageUpload");
    });
	
    $(".uploadImage").colorbox({
        onComplete: function() {
			// upload button is disabled unless file field is filled
            $('input.imageFile').change(function(){
                    if($(this).val()) {
                        $('input.uploadImage').removeAttr('disabled');
                    } 
            });         
        }
    });
	
	/* Bind modal dialog clickable images to the price cells of the SKU tab. */
	$newImage = $("<img src='staticAssets/images/actionIcons14/edit.png'>");
	$newImage.click(function(){
		var $dialogDiv = $("#updatePriceGroupSKUSettingsDialog").clone();
		var $form = $("#updatePriceGroupSKUSettingsForm");
		var clickedPriceGroupId = $(this).parent("td,th").data("pricegroupid"); 
		var clickedSkuId = $(this).parents("tr").first().data("skuid");
		
		alert("clickedPriceGroupId: " + clickedPriceGroupId + " clickedSkuId: " + clickedSkuId);
		
		// Assign the clicked PriceGroupId and SkuId to the form so that it posts to the server
		$("#updatePriceGroupSKUSettingsForm_priceGroupId", $dialogDiv).val(clickedPriceGroupId);
		$("#updatePriceGroupSKUSettingsForm_skuId", $dialogDiv).val(clickedSkuId);

		// Populate the Price Group title in the modal dialog.
		$("#updatePriceGroupSKUSettings_GroupName\\[" + clickedPriceGroupId + "\\]", $dialogDiv).show();
		
		// Populate the rate radio buttons
		$("#updatePriceGroupSKUSettings_PriceGroupRateInputs\\[" + clickedPriceGroupId + "\\]", $dialogDiv).show();	
		
		// Open the dialog itself, and pass in the method that will be called when the OK button is clicked.
		actionDialog($dialogDiv, function(){
			// First validate the dialog
			if(!validateUpdatePriceGroupSKUSettingsDialog($dialogDiv, clickedPriceGroupId))
				return false;
			
			// If valid, then submit the dialog's form
			$form.submit();
			return false;
			
		});
		
		// Bind "change" handler to the Rate select. This has to happen after we assign the div to the dialog.
		$("#updatePriceGroupSKUSettings_PriceGroupRateSelect\\[" + clickedPriceGroupId + "\\]").bind("change", function(){
			if($(this).val() == "new amount")
				$("#updatePriceGroupSKUSettings_newAmount", $dialogDiv).show();
			else
				$("#updatePriceGroupSKUSettings_newAmount", $dialogDiv).hide();
			
		});
	});
	
	$(".priceGroupSKUColumn").append($newImage);
});

function validateUpdatePriceGroupSKUSettingsDialog($dialogDiv, priceGroupId){
	// TODO: Write validation!!!
	return true;
	
	//$divContainingRadios = $("#updatePriceGroupSKUSettings_PriceGroupRateInputs[" + priceGroupId + "]",$dialogDiv);
	
	// If no radio was selected
	//if(!$(":checked", $dialogDiv).size())
	//	alertDialog()
}

/*
function resetUpdatePriceGroupSKUSettingsForm($dialogDiv){
	// Hide all price group titles
	$("updatePriceGroupSKUSettings_GroupName", $dialogDiv).hide();
	
	// Hide all select boxes.
	$("updatePriceGroupSKUSettings_GroupName", $dialogDiv).hide();
	
	// Hide all "new amount" input boxes.
	$("updatePriceGroupSKUSettings_GroupName", $dialogDiv).hide();
}
*/











