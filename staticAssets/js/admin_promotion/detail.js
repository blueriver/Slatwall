

jQuery(function() {
	
	updateDiscountType();
	
	jQuery('.discounttypefield').change(function() {
		updateDiscountType();
	});	
	
	jQuery('#addPromotionRewardButton').click(function(){
		jQuery('#rewardTypeSelector').show(300);
		jQuery(this).remove();
		return false;
	});
	
	jQuery('#addPromotionQualifierButton').click(function(){
		jQuery('#qualifierTypeSelector').show(300);
		jQuery(this).remove();
		return false;
	});

	jQuery('#addPromotionRewardExclusionButton').click(function(){
		jQuery('#savePromotionRewardExclusionHidden').val('true');
		jQuery('#promotionRewardExclusionInputs').fadeIn(400);
		jQuery(this).remove();
		return false;
	});
	
	jQuery('#addPromotionQualifierExclusionButton').click(function(){
		jQuery('#savePromotionQualifierExclusionHidden').val('true');
		jQuery('#promotionQualifierExclusionInputs').fadeIn(400);
		jQuery(this).remove();
		return false;
	});
	
	jQuery('#promotionRewardType').change(function(){
		if( jQuery(this).val() == "product" ) {
			jQuery('#savePromotionRewardProductHidden').val('true');
			jQuery('#savePromotionRewardShippingHidden').val('false');
			jQuery('#savePromotionRewardOrderHidden').val('false');
			jQuery('#promotionRewardOrderInputs').hide();
			jQuery('#promotionRewardShippingInputs').hide();
			jQuery('#promotionRewardProductInputs').fadeIn(400);
		}
		else if( jQuery(this).val() == "shipping" ) {
			jQuery('#savePromotionRewardShippingHidden').val('true');
			jQuery('#savePromotionRewardProductHidden').val('false');
			jQuery('#savePromotionRewardOrderHidden').val('false');
			jQuery('#promotionRewardProductInputs').hide();
			jQuery('#promotionRewardOrderInputs').hide();
			jQuery('#promotionRewardShippingInputs').fadeIn(400);
		}
		else if( jQuery(this).val() == "order" ) {
			jQuery('#savePromotionRewardOrderHidden').val('true');
			jQuery('#savePromotionRewardProductHidden').val('false');
			jQuery('#savePromotionRewardShippingHidden').val('false');
			jQuery('#promotionRewardProductInputs').hide();
			jQuery('#promotionRewardShippingInputs').hide();
			jQuery('#promotionRewardOrderInputs').fadeIn(400);
		}
		else {
			jQuery('#promotionRewardProductInputs').hide();
			jQuery('#promotionRewardShippingInputs').hide();
			jQuery('#promotionRewardOrderInputs').hide();
			jQuery('#savePromotionRewardOrderHidden').val('false');
			jQuery('#savePromotionRewardProductHidden').val('false');
			jQuery('#savePromotionRewardShippingHidden').val('false');
		}
		updateDiscountType();
	});
	
	jQuery('#promotionQualifierType').change(function(){
		if( jQuery(this).val() == "product" ) {
			jQuery('#savePromotionQualifierProductHidden').val('true');
			jQuery('#savePromotionQualifierFulfillmentHidden').val('false');
			jQuery('#savePromotionQualifierOrderHidden').val('false');
			jQuery('#promotionQualifierProductInputs').hide();
			jQuery('#promotionQualifierFulfillmentInputs').hide();
			jQuery('#promotionQualifierProductInputs').fadeIn(400);
		}
		else if( jQuery(this).val() == "fulfillment" ) {
			jQuery('#savePromotionQualifierFulfillmentHidden').val('true');
			jQuery('#savePromotionQualifierProductHidden').val('false');
			jQuery('#savePromotionQualifierOrderHidden').val('false');
			jQuery('#promotionQualifierProductInputs').hide();
			jQuery('#promotionQualifierOrderInputs').hide();
			jQuery('#promotionQualifierFulfillmentInputs').fadeIn(400);
		}
		else if( jQuery(this).val() == "order" ) {
			jQuery('#savePromotionQualifierOrderHidden').val('true');
			jQuery('#savePromotionQualifierProductHidden').val('false');
			jQuery('#savePromotionQualifierFulfillmentHidden').val('false');
			jQuery('#promotionQualifierProductInputs').hide();
			jQuery('#promotionQualifierFulfillmentInputs').hide();
			jQuery('#promotionQualifierOrderInputs').fadeIn(400);
		}
		else {
			jQuery('#promotionQualifierProductInputs').hide();
			jQuery('#promotionQualifierFulfillmentInputs').hide();
			jQuery('#promotionQualifierOrderInputs').hide();
			jQuery('#savePromotionQualifierOrderHidden').val('false');
			jQuery('#savePromotionQualifierProductHidden').val('false');
			jQuery('#savePromotionQualifierFulfillmentHidden').val('false');
		}
		updateDiscountType();
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
			ampm: true
		});
		
		$newPromotionCode.children("td").children("input[name=endDateTime]").datetimepicker({
			ampm: true
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

function updateDiscountType() {
	var discountType = jQuery('.discounttypefield').filter(':visible').val();
	if(discountType == 'percentageOff') {
		jQuery('.percentageofftitle').show();
		jQuery('.percentageoffvalue').show();
		jQuery('.amountofftitle').hide();
		jQuery('.amountoffvalue').hide();
		jQuery('.amountofffield').val('');
		jQuery('.amounttitle').hide();
		jQuery('.amountvalue').hide();
		jQuery('.amountfield').val('');
	} else if (discountType == 'amountOff') {
		jQuery('.percentageofftitle').hide();
		jQuery('.percentageoffvalue').hide();
		jQuery('.percentageofffield').val('');
		jQuery('.amountofftitle').show();
		jQuery('.amountoffvalue').show();
		jQuery('.amounttitle').hide();
		jQuery('.amountvalue').hide();
		jQuery('.amountfield').val('');
	} else if (discountType == 'amount') {
		jQuery('.percentageofftitle').hide();
		jQuery('.percentageoffvalue').hide();
		jQuery('.percentageofffield').val('');
		jQuery('.amountofftitle').hide();
		jQuery('.amountoffvalue').hide();
		jQuery('.amountofffield').val('');
		jQuery('.amounttitle').show();
		jQuery('.amountvalue').show();
	}
}