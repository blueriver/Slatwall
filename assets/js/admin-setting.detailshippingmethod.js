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