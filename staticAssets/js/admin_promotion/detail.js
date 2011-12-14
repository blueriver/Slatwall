/**
 * 
 * @depends /admin/core.js
 */

jQuery(function() {
	
	jQuery('#addPromotionRewardProductButton').click(function(){
	 	jQuery('#addPromotionRewardHidden').val('true');
		jQuery('#promotionRewardProductInputs').fadeIn(400);
		
		jQuery('#addPromotionRewardShippingButton').remove();
		jQuery(this).remove();
	});
	
	jQuery('#addPromotionRewardShippingButton').click(function(){
	 	jQuery('#addPromotionRewardHidden').val('true');
		jQuery('#promotionRewardShippingInputs').fadeIn(400);
		
		jQuery('#addPromotionRewardProductButton').remove();
		jQuery(this).remove();
	});
});
	