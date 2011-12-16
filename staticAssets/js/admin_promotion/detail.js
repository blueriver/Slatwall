/**
 * 
 * @depends /admin/core.js
 */

jQuery(function() {
	
	updateItemDiscountType();
	updateShippingDiscountType();
	
	jQuery('select[name="promotionRewards[1].itemDiscountType"]').change(function() {
		updateItemDiscountType();
	});
	
	jQuery('select[name="promotionRewards[1].shippingDiscountType"]').change(function() {
		updateShippingDiscountType();
	});
	
	jQuery('#addPromotionRewardProductButton').click(function(){
	 	jQuery('#savePromotionRewardProductHidden').val('true');
		jQuery('#promotionRewardProductInputs').fadeIn(400);
		
		jQuery('#addPromotionRewardShippingButton').remove();
		jQuery(this).remove();
	});
	
	jQuery('#addPromotionRewardShippingButton').click(function(){
	 	jQuery('#savePromotionRewardShippingHidden').val('true');
		jQuery('#promotionRewardShippingInputs').fadeIn(400);
		
		jQuery('#addPromotionRewardProductButton').remove();
		jQuery(this).remove();
	});
	
	jQuery('#remPromotionCode').click(function() {
		var num = jQuery('tr[id^="PromotionCode"]').length;
		jQuery('#PromotionCode' + num).remove();
		// can't remove more promotionCodes than were originally present
		if(num-1 == promotionCodeCount) {
			jQuery('#remPromotionCode').attr('style','display:none;');
		}
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
	
});

function updateItemDiscountType() {
	if(jQuery('select[name="promotionRewards[1].itemDiscountType"] :selected').val() == 'percentageOff') {
		jQuery('.itempercentageofftitle').show();
		jQuery('.itempercentageoffvalue').show();
		jQuery('.itemamountofftitle').hide();
		jQuery('.itemamountoffvalue').hide();
		jQuery('.itemamounttitle').hide();
		jQuery('.itemamountvalue').hide();
	} else if (jQuery('select[name="promotionRewards[1].itemDiscountType"] :selected').val() == 'amountOff') {
		jQuery('.itempercentageofftitle').hide();
		jQuery('.itempercentageoffvalue').hide();
		jQuery('.itemamountofftitle').show();
		jQuery('.itemamountoffvalue').show();
		jQuery('.itemamounttitle').hide();
		jQuery('.itemamountvalue').hide();
	} else if (jQuery('select[name="promotionRewards[1].itemDiscountType"] :selected').val() == 'amount') {
		jQuery('.itempercentageofftitle').hide();
		jQuery('.itempercentageoffvalue').hide();
		jQuery('.itemamountofftitle').hide();
		jQuery('.itemamountoffvalue').hide();
		jQuery('.itemamounttitle').show();
		jQuery('.itemamountvalue').show();
	}
}

function updateShippingDiscountType() {
	if(jQuery('select[name="promotionRewards[1].shippingDiscountType"] :selected').val() == 'percentageOff') {
		jQuery('.shippingpercentageofftitle').show();
		jQuery('.shippingpercentageoffvalue').show();
		jQuery('.shippingamountofftitle').hide();
		jQuery('.shippingamountoffvalue').hide();
		jQuery('.shippingamounttitle').hide();
		jQuery('.shippingamountvalue').hide();
	} else if (jQuery('select[name="promotionRewards[1].shippingDiscountType"] :selected').val() == 'amountOff') {
		jQuery('.shippingpercentageofftitle').hide();
		jQuery('.shippingpercentageoffvalue').hide();
		jQuery('.shippingamountofftitle').show();
		jQuery('.shippingamountoffvalue').show();
		jQuery('.shippingamounttitle').hide();
		jQuery('.shippingamountvalue').hide();
	} else if (jQuery('select[name="promotionRewards[1].shippingDiscountType"] :selected').val() == 'amount') {
		jQuery('.shippingpercentageofftitle').hide();
		jQuery('.shippingpercentageoffvalue').hide();
		jQuery('.shippingamountofftitle').hide();
		jQuery('.shippingamountoffvalue').hide();
		jQuery('.shippingamounttitle').show();
		jQuery('.shippingamountvalue').show();
	}
}