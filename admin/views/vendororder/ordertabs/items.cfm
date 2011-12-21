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

<cfoutput>
	<table class="listing-grid stripe">
		<tr>
			<th>#$.slatwall.rbKey("entity.sku.skucode")#</th>
			<th class="varWidth">#$.slatwall.rbKey("entity.product.brand")# - #$.slatwall.rbKey("entity.product.productname")#</th>
			<!---<th>#$.slatwall.rbKey("admin.vendorOrder.list.actions")#</th>--->
			<!---<th>#$.slatwall.rbKey("entity.vendorOrderitem.status")#</th>--->
			<th>#$.slatwall.rbKey("entity.vendorOrderitem.quantity")#</th>
			<th>#$.slatwall.rbKey("admin.vendorOrder.detail.quantityreceived")#</th>
		</tr>
			
		<cfloop array="#rc.vendorOrderItemSmartList.getPageRecords()#" index="local.vendorOrderItem">
			<tr>
				<td>#local.vendorOrderItem.getStock().getSku().getSkuCode()#</td>
				<td class="varWidth">
					<strong>#local.vendorOrderItem.getSku().getProduct().getBrand().getBrandName()# #local.vendorOrderItem.getSku().getProduct().getProductName()#</strong>
					<cfif local.vendorOrderItem.hasAttributeValue() or arrayLen(local.vendorOrderItem.getSku().getOptions())>
					  <ul class="inlineAdmin">
			          	<li class="zoomIn">           
							<a class="customizations detail" id="show_#local.vendorOrderItem.getVendorOrderItemID()#" title="#$.slatwall.rbKey('admin.vendorOrder.vendorOrderItem.optionsandcustomizations')#" href="##">#$.slatwall.rbKey("admin.vendorOrder.vendorOrderItem.optionsandcustomizations")#</a>
						</li>
						<li class="zoomOut">           
							<a class="customizations detail" id="show_#local.vendorOrderItem.getVendorOrderItemID()#" title="#$.slatwall.rbKey('admin.vendorOrder.vendorOrderItem.optionsandcustomizations')#" href="##">#$.slatwall.rbKey("admin.vendorOrder.vendorOrderItem.optionsandcustomizations")#</a>
						</li>
			          </ul>
					  <div class="clear" style="display:none;">
					  <hr>
						<cfif arrayLen(local.vendorOrderItem.getSku().getOptions())>
							<div><h5>Options</h5>
								<ul>
								<cfloop array="#local.vendorOrderItem.getSku().getOptions()#" index="local.option" >
									<li>#local.option.getOptionGroup().getOptionGroupName()#: #local.option.getOptionName()#</li>
								</cfloop>
								</ul>
							</div>
						</cfif>
						<cfif arrayLen(local.vendorOrderItem.getAttributeValues())>
							<div><h5>Customizations</h5>
								#local.vendorOrderItem.displayCustomizations(format="htmlList")#
							</div>
						</cfif>
					  </div> 
					</cfif>
				</td>				
				<td>#local.vendorOrderItem.getVendorOrderItemStatusType().getType()#</td>				
				<td>#local.vendorOrderItem.getFormattedValue('price', 'currency')#</td>
				<td>#int(local.vendorOrderItem.getQuantity())#</td>
				<td>#local.vendorOrderItem.getQuantityDelivered()#</td>
				<td>#local.vendorOrderItem.getFormattedValue('extendedPrice', 'currency')#</td>
			</tr>
		</cfloop>
	</table>
	<div class="shippingAddress">
		<h5>#$.slatwall.rbKey("entity.vendorOrderFulfillment.shippingAddress")#</h5>
		<cf_SlatwallAddressDisplay address="#local.vendorOrderFulfillment.getShippingAddress()#" edit="false" />
	</div>
	<div class="shippingMethod">
		<h5>#$.slatwall.rbKey("entity.vendorOrderFulfillment.shippingMethod")#</h5>
		#local.vendorOrderFulfillment.getShippingMethod().getShippingMethodName()#	
	</div>
	<div class="totals">
		<dl class="fulfillmentTotals">
			<dt>
				#$.slatwall.rbKey("entity.vendorOrderFulfillment.subtotal")#:
			</dt>
			<dd>
				#local.vendorOrderFulfillment.getFormattedValue('subTotal', 'currency')#
			</dd>
			<dt>
				#$.slatwall.rbKey("entity.vendorOrderFulfillment.shippingCharge")#:
			</dt>
			<dd>
				#local.vendorOrderFulfillment.getFormattedValue('shippingCharge', 'currency')#
			</dd>
			<dt>
				#$.slatwall.rbKey("entity.vendorOrderFulfillment.tax")#:
			</dt>
			<dd>
				#local.vendorOrderFulfillment.getFormattedValue('tax', 'currency')#
			</dd>
			<!--- discounts for fulfillment --->
			<cfif local.vendorOrderFulfillment.getItemDiscountAmountTotal() gt 0>
				<dt>
					#$.slatwall.rbKey("entity.vendorOrderFulfillment.itemDiscountAmountTotal")#:
				</dt>
				<dd class="discountAmount">
					 - #local.vendorOrderFulfillment.getFormattedValue('itemDiscountAmountTotal', 'currency')#
				</dd>
			</cfif>
			<cfif local.vendorOrderFulfillment.getDiscountAmount() gt 0>
				<dt>
					#$.slatwall.rbKey("entity.vendorOrderFulfillmentShipping.discountAmount")#:
				</dt>
				<dd class="discountAmount">
					 - #local.vendorOrderFulfillment.getFormattedValue('discountAmount', 'currency')#
				</dd>
			</cfif>
			<dt>
				#$.slatwall.rbKey("entity.vendorOrderFulfillment.total")#:
			</dt>
			<dd>
				#local.vendorOrderFulfillment.getFormattedValue('totalCharge', 'currency')#
			</dd>
		</dl>
	</div>
	<div class="clear"></div>
</cfoutput>