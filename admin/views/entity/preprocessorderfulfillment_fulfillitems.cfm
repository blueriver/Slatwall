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
<cfparam name="rc.orderFulfillment" type="any" />

<cfoutput>
	<cf_HibachiEntityProcessForm entity="#rc.orderFulfillment#" edit="#rc.edit#" processAction="admin:entity.preprocessorderdelivery" processContext="create">
		
		<cf_HibachiEntityActionBar type="preprocess" object="#rc.orderFulfillment#">
		</cf_HibachiEntityActionBar>
		
		<cf_HibachiPropertyRow>
			<cf_HibachiPropertyList>
				
				<!--- Pass the info across --->
				<input type="hidden" name="order.orderID" value="#rc.orderFulfillment.getOrder().getOrderID()#" />
				<input type="hidden" name="orderFulfillment.orderFulfillmentID" value="#rc.orderFulfillment.getOrderFulfillmentID()#" />
				<input type="hidden" name="fulfillmentMethod.fulfillmentMethodID" value="#rc.orderFulfillment.getFulfillmentMethod().getFulfillmentMethodID()#" />
				<input type="hidden" name="shippingMethod.shippingMethodID" value="#rc.orderFulfillment.getShippingMethod().getShippingMethodID()#" />
				<input type="hidden" name="shippingAddress.addressID" value="#rc.orderFulfillment.getAddress().getAddressID()#" />
				
				<!--- Location --->
				<cf_HibachiFieldDisplay title="#$.slatwall.rbKey('entity.location')#" fieldName="location.locationID" valueOptions="#$.slatwall.getService('locationService').getLocationOptions()#" fieldType="select" edit="true" />
				
				<hr />
				
				<!--- Items Selector --->
				<table class="table table-striped table-bordered table-condensed">
					<tr>
						<th>Sku Code</th>
						<th class="primary">Product Title</th>
						<th>Options</th>
						<th>Quantity</th>
					</tr>
					<cfset orderItemIndex = 0 />
					<cfloop array="#rc.orderFulfillment.getOrderFulfillmentItems()#" index="orderItem">
						<tr>
							<cfset orderItemIndex++ />
							
							<input type="hidden" name="orderDeliveryItems[#orderItemIndex#].orderDeliveryItemID" value="" />
							<input type="hidden" name="orderDeliveryItems[#orderItemIndex#].orderItem.orderItemID" value="#orderItem.getOrderItemID()#" />
							
							<td>#orderItem.getSku().getSkuCode()#</td>
							<td>#orderItem.getSku().getProduct().getTitle()#</td>
							<td>#orderItem.getSku().displayOptions()#</td>
							<td><input type="text" name="orderDeliveryItems[#orderItemIndex#].quantity" value="" class="span1" /></td>
						</tr>
					</cfloop>
				</table>
			</cf_HibachiPropertyList>
		</cf_HibachiPropertyRow>
		
	</cf_HibachiEntityProcessForm>
</cfoutput>