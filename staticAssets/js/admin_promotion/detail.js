/**
 * 
 * @depends /admin/core.js
 */

jQuery(function() {

	jQuery('.editPromotionReward').click(function(){
	 	var promotionID = jQuery(this).attr("id").substr(4);
		jQuery('tr#promotionRewardEdit' + promotionID).toggle();
	 	return false;
	});
	 
	var promotionCodeCount = jQuery('tr[id^="PromotionCode"]').length;
    jQuery("#addPromotionCode").click(function() {
        var current = jQuery('tr[id^="PromotionCode"]').length;
        current++;
        var $newPromotionCode= jQuery( "#promotionCodeTableTemplate tbody>tr:last" ).clone(true);
		$newPromotionCode.children("td").children("input[name=startDateTime]").datetimepicker({
		        ampm: true,
		     });
		$newPromotionCode.children("td").children("input[name=endDateTime]").datetimepicker({
		        ampm: true,
		     });
        $newPromotionCode.children("td").children("input").each(function(i) {
            var $currentElem= jQuery(this);
            if ($currentElem.attr("type") != "radio") {
                $currentElem.attr("name", "promotionCodes[" + current + "]." + $currentElem.attr("name"));
            }
        });
        $newPromotionCode.children("td").children("select").each(function(i) {
            var $currentElem= jQuery(this);
            $currentElem.attr("name","promotionCodes["+current+"]."+$currentElem.attr("name"));
        });
        jQuery('#remPromotionCode').attr('style','');
        jQuery('#promotionCodeTable > tbody:last').append($newPromotionCode);
        $newPromotionCode.attr("id","PromotionCode" + current);
        // add stripe to row
        if(current % 2 == 1) {
            $newPromotionCode.addClass("alt");
        }
    });
    
    jQuery('#remPromotionCode').click(function() {
        var num = jQuery('tr[id^="PromotionCode"]').length;
        jQuery('#PromotionCode' + num).remove();
        // can't remove more promotionCodes than were originally present
        if(num-1 == promotionCodeCount) {
            jQuery('#remPromotionCode').attr('style','display:none;');
        }
    });
	
	var promotionRewardCount = jQuery('.promotionRewardForm').length;
    jQuery("#addPromotionReward").click(function() {
        var current = jQuery('.promotionRewardForm').length;
        current++;
        var $newPromotionReward= jQuery( "#promotionRewardFormTemplate" ).clone(true);
        $newPromotionReward.children("dl").each(function(i) {
            var $currentElem= jQuery(this);
			$currentElem.attr("id", $currentElem.attr("id") + current);
        });
        $newPromotionReward.children("dl").children("dt").children("label").each(function(i) {
            var $currentElem= jQuery(this);
			$currentElem.attr("for", $currentElem.attr("for") + current);
        });
        $newPromotionReward.children("dl").children("dd").children("input").each(function(i) {
            var $currentElem= jQuery(this);
            $currentElem.attr("name", "promotionRewards[" + current + "]." + $currentElem.attr("name"));
			$currentElem.attr("id", $currentElem.attr("id") + current);
        });
        $newPromotionReward.children("dl").children("dd").children("select").each(function(i) {
            var $currentElem= jQuery(this);
            $currentElem.attr("name","promotionRewards["+current+"]."+$currentElem.attr("name"));
			$currentElem.attr("id", $currentElem.attr("id") + current);
        });
        $newPromotionReward.removeAttr("id");
		$newPromotionReward.removeAttr("class");
		$newPromotionReward.addClass("promotionRewardForm");
        jQuery('#rewardButtons').before($newPromotionReward);
        jQuery('#remPromotionReward').attr('style','');
    });
    
    jQuery('#remPromotionReward').click(function() {
        var num = jQuery('.promotionRewardForm').length;
        jQuery('.promotionRewardForm').last().remove();
        // can't remove more promotionRewards than were originally present
        if(num-1 == promotionRewardCount) {
            jQuery('#remPromotionReward').attr('style','display:none;');
        }
    });

	// ------- AUTOCOMPLETE for Product and SKU
	
	jQuery('input.rewardProduct').live("focus",function(event) {
		var productTypeID = jQuery(this).closest('dl').find('select[id^="productTypeID"]').val();
		jQuery(this).autocomplete({
			source: "?slatAction=admin:product.searchProductsByType&productTypeID=" + productTypeID,
			select: function(event,ui) {
				jQuery('#product' + jQuery(this).attr("id").substr(11)).val(ui.item.id);
			}
		});
	});
	
	jQuery('input.rewardSku').live("focus",function(event) {
		var productTypeID = jQuery(this).closest('dl').find('select[id^="productTypeID"]').val();
		jQuery(this).autocomplete({
			source: "?slatAction=admin:product.searchSkusByProductType&productTypeID=" + productTypeID,
			select: function(event,ui) {
				jQuery('#sku' + jQuery(this).attr("id").substr(7)).val(ui.item.id);
			}			
		});
	});
	

	jQuery('.rewardTypeSelector').change(function() {
		var selected = jQuery(this).val();
		var idx = jQuery(this).parents('dl').attr('id').substr(12);
		//alert(idx);
		$shippingRewardForm = jQuery('#shippingReward' + idx);
		$productRewardForm = jQuery('#productReward' + idx);
		$shippingRewardForm.hide();
		$productRewardForm.hide();
		if(selected == "shipping"){
			$shippingRewardForm.show();
		} else if(selected == "product"){
			$productRewardForm.show();
		}
	});
});
	