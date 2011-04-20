jQuery(document).ready(function() {
	
    var rateCount = jQuery('tr[id^="Sku"]').length;
	
    jQuery("#addShippingRate").click(function() {
		
        var current = jQuery('tr[id^="ShippingRate"]').length;
        current++;
        var $newShippingRate= jQuery( "#tableTemplate tbody>tr:last" ).clone(true);
        $newShippingRate.children("td").children("input").each(function(i) {
            var $currentElem= $(this);
            if ($currentElem.attr("type") != "radio") {
                $currentElem.attr("name", "shippingRates[" + current + "]." + $currentElem.attr("name"));
            }
        });
        $newShippingRate.children("td").children("select").each(function(i) {
            var $currentElem= $(this);
            $currentElem.attr("name","shippingRates["+current+"]."+$currentElem.attr("name"));
        });
        jQuery('#shippingRateTable > tbody:last').append($newShippingRate);
		jQuery('#shippingRateTable').attr('style','');
        $newShippingRate.attr("id","ShippingRate" + current);
        // add stripe to row
        if(current % 2 == 1) {
            $newShippingRate.addClass("alt");
        }
    });
	
	jQuery("#shippingProvider").change(function(){
		jQuery('#spdshippingmethod > select').remove();
		if(jQuery("#shippingProvider option:selected").val() == "RateTable") {
			var current = jQuery('tr[id^="ShippingRate"]').length;
			if(current > 0) {
				jQuery('#shippingRateTable').show();
			}
			jQuery("#addShippingRate").show();
			jQuery('.spdshippingmethod').html('Shipping Rates');
		} else {
			jQuery('#shippingRateTable').hide();
			jQuery("#addShippingRate").hide();
			jQuery('.spdshippingmethod').html('Shipping Provider Method');
			
			var methodSelector = "#" + jQuery("#shippingProvider option:selected").val();
			var $shippingProviderMethods = jQuery(methodSelector).clone(true);
			jQuery('#spdshippingmethod').append($shippingProviderMethods);
		}
	});
});