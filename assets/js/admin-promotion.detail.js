/*

    Slatwall - An e-commerce plugin for Mura CMS
    Copyright (C) 2011 ten24, LLC

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
    
    Linking this library statically or dynamically with other modules is
    making a combined work based on this library.  Thus, the terms and
    conditions of the GNU General Public License cover the whole
    combination.
 
    As a special exception, the copyright holders of this library give you
    permission to link this library with independent modules to produce an
    executable, regardless of the license terms of these independent
    modules, and to copy and distribute the resulting executable under
    terms of your choice, provided that you also meet, for each linked
    independent module, the terms and conditions of the license of that
    module.  An independent module is a module which is not derived from
    or based on this library.  If you modify this library, you may extend
    this exception to your version of the library, but you are not
    obligated to do so.  If you do not wish to do so, delete this
    exception statement from your version.

Notes:

*/

jQuery(function() {

	jQuery.datepicker.setDefaults(jQuery.datepicker.regional[dtLocale]);
    
	jQuery('#spdstartdatetime').datetimepicker({
        ampm: true,
     });
    jQuery('#spdenddatetime').datetimepicker({
        ampm: true,
     });
	 
	jQuery('.dateTime').datetimepicker({
        ampm: true,
     });
	 
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
	