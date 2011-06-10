<!---

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

--->
<cfparam name="params.orderFulfillment" type="any" />
<cfparam name="params.edit" type="boolean" />

<cfif not isNull(params.orderFulfillment.getShippingAddress())>
	<cfset local.address = params.orderFulfillment.getShippingAddress() />
<cfelse>
	<cfset local.address = $.slatwall.getService("addressService").newAddress() />
</cfif>

<cfoutput>
	<div class="svocheckoutfulfillmentshipping">
		<form name="fulfillmentShipping" action="?slatAction=frontend:checkout.saveFulfillment" method="post">
			<div class="shippingAddress">
				<h4>Shipping Address</h4>
				<cf_SlatwallAddressDisplay address="#local.address#" edit="#params.edit#">
				<input type="hidden" name="orderFulfillmentID" value="#params.orderFulfillment.getOrderFulfillmentID()#" />
			</div>
			<cfif arrayLen(params.orderFulfillment.getOrderShippingMethodOptions())>
				<div class="shippingMethod">
					<h4>Shipping Method</h4>
					<cf_SlatwallShippingMethodDisplay orderFulfillmentShipping="#params.orderFulfillment#" edit="#params.edit#">
				</div>
			</cfif>
			<button type="submit">Save & Continue</button>
		</form>
		<!---
		<script type="text/javascript">
			jQuery(document).ready(function(){
				jQuery('form[name="fulfillmentShipping"]').submit(function(e) {
					if(!jQuery('input[name=shippingMethodOptionID]').size()) {
						e.preventDefault();
						
						// Save Order Fulfilling Address and Update That Element
						jQuery.ajax({
							type: "PUT",
							url: '/plugins/Slatwall/api/index.cfm/AddressMember/',
							data: {
								addressID : jQuery('input[name="addressID"]').val(),
								countryCode : jQuery('select[name="countryCode"]').val(),
								name : jQuery('input[name="name"]').val(),
								company : jQuery('input[name="company"]').val(),
								streetAddress : jQuery('input[name="streetAddress"]').val(),
								street2Address : jQuery('input[name="street2Address"]').val(),
								city : jQuery('input[name="city"]').val(),
								stateCode : jQuery('select[name="slateCode"]').val(),
								postalCode : jQuery('input[name="postalCode"]').val()
							},
							dataType: "json",
							context: document.body,
							success: function(data) {
								jQuery('div.addressForm').replaceWith(data);
							}
						});
						
						jQuery.ajax({
							type: "post",
							url: '/plugins/Slatwall/api/index.cfm/ShippingMethodDisplay/',
							data: {
								orderFulfillmentID : '#params.orderFulfillment.getOrderFulfillmentID()#',
								countryCode : jQuery('select[name="countryCode"]').val(),
								name : jQuery('input[name="name"]').val(),
								company : jQuery('input[name="company"]').val(),
								streetAddress : jQuery('input[name="streetAddress"]').val(),
								street2Address : jQuery('input[name="street2Address"]').val(),
								city : jQuery('input[name="city"]').val(),
								stateCode : jQuery('select[name="slateCode"]').val(),
								postalCode : jQuery('input[name="postalCode"]').val()
							},
							dataType: "json",
							context: document.body,
							success: function(data) {
								jQuery('div.addressForm').replaceWith(data);
							}
						});
					}
				});
			});
		</script>
		--->
	</div>
</cfoutput>

