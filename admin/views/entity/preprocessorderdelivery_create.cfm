<!---

    Slatwall - An Open Source eCommerce Platform
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
<cfparam name="rc.orderDelivery" type="any" />
<cfparam name="rc.orderFulfillment" type="any" />
<cfparam name="rc.processObject" type="any" />

<cfset $.slatwall.setORMHasErrors( true ) />

<cfoutput>
	<cf_HibachiEntityProcessForm entity="#rc.orderDelivery#" edit="#rc.edit#" processActionQueryString="orderFulfillmentID=#rc.orderFulfillment.getOrderFulfillmentID()#" sRedirectAction="admin:entity.detailorderfulfillment" fRenderItem="preprocessorderdelivery">
		
		<cf_HibachiEntityActionBar type="preprocess" object="#rc.orderDelivery#">
		</cf_HibachiEntityActionBar>
		
		<cf_HibachiPropertyRow>
			<cf_HibachiPropertyList>
				
				<input type="hidden" name="order.orderID" value="#rc.processObject.getOrder().getOrderID()#" />
				<input type="hidden" name="location.locationID" value="#rc.processObject.getLocation().getLocationID()#" />
				<input type="hidden" name="fulfillmentMethod.fulfillmentMethodID" value="#rc.processObject.getFulfillmentMethod().getFulfillmentMethodID()#" />
				<input type="hidden" name="shippingMethod.shippingMethodID" value="#rc.processObject.getShippingMethod().getShippingMethodID()#" />
				<input type="hidden" name="shippingAddress.addressID" value="#rc.processObject.getShippingAddress().getAddressID()#" />
				
				<cf_HibachiPropertyDisplay object="#rc.orderDelivery#" property="trackingNumber" edit="true" fieldName="orderDelivery.trackingNumber" />
				
				<hr />
				
				<table class="table table-striped table-bordered table-condensed">
					<tr>
						<th>Sku Code</th>
						<th class="primary">Product Title</th>
						<th>Options</th>
						<th>Quantity</th>
					</tr>
					<cfset orderItemIndex = 0 />
					<cfloop array="#rc.processObject.getOrderDeliveryItems()#" index="orderDeliveryItem">
						<tr>
							
							<cfset orderItemIndex++ />
							
							<input type="hidden" name="orderDelivery.orderDeliveryItems[#orderItemIndex#].orderDeliveryItemID" value="" />
							<input type="hidden" name="orderDelivery.orderDeliveryItems[#orderItemIndex#].orderItem.orderItemID" value="#orderDeliveryItem.getOrderItem().getOrderItemID()#" />
							<input type="hidden" name="orderDelivery.orderDeliveryItems[#orderItemIndex#].quantity" value="#orderDeliveryItem.getQuantity()#" />
							
							<td>#orderDeliveryItem.getOrderItem().getSku().getSkuCode()#</td>
							<td>#orderDeliveryItem.getOrderItem().getSku().getProduct().getTitle()#</td>
							<td>#orderDeliveryItem.getOrderItem().getSku().displayOptions()#</td>
							<td>#orderDeliveryItem.getQuantity()#</td>
						</tr>
					</cfloop>
				</table>
			</cf_HibachiPropertyList>
		</cf_HibachiPropertyRow>
		
	</cf_HibachiEntityProcessForm>
</cfoutput>