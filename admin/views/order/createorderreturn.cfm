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
<cfparam name="rc.edit" default="false" />
<cfparam name="rc.Order" type="any" />

<cfset rc.orderActionOptions = rc.Order.getActionOptions() />
<cfset local.account = rc.Order.getAccount() />
<cfset local.payments = rc.Order.getOrderPayments() />

<cfoutput>

<ul id="navTask">
	<cf_SlatwallActionCaller action="admin:order.list" type="list">
</ul>



<div class="svoadminorderdetail">
	<div class="basicOrderInfo">
		<table class="listing-grid stripe" id="basicOrderInfo">
			<tr>
				<th colspan="2">#$.Slatwall.rbKey("admin.order.detail.basicorderinfo")#</th>
			</tr>
			<cf_SlatwallPropertyDisplay object="#rc.Order#" property="OrderNumber" edit="#rc.edit#" displayType="table">
			<cf_SlatwallPropertyDisplay object="#rc.Order.getOrderStatusType()#" title="#rc.$.Slatwall.rbKey('entity.order.orderStatusType')#" property="Type" edit="#rc.edit#"  displayType="table">
			<cf_SlatwallPropertyDisplay object="#rc.Order#" property="OrderOpenDateTime" edit="#rc.edit#"  displayType="table">
			<tr>
				<td class="property">
					#rc.$.Slatwall.rbKey("entity.order.account")#
				</td>
				<td>
					#rc.Order.getAccount().getFullName()#  
					<a href="#buildURL(action='admin:account.detail',queryString='accountID=#local.account.getAccountID()#')#">
						<img src="#$.slatwall.getSlatwallRootPath()#/staticAssets/images/admin.ui.user.png" height="16" width="16" alt="" />
					</a>
				</td>
			</tr>
			<cf_SlatwallPropertyDisplay object="#local.account#" property="primaryEmailAddress" edit="#rc.edit#" displayType="table">
			<cf_SlatwallPropertyDisplay object="#local.account#" property="primaryPhoneNumber" edit="#rc.edit#" displayType="table">
		</table>
	</div>
	<div class="paymentInfo">
		<table class="listing-grid stripe" >
			<tr>
				<th class="varWidth">#$.Slatwall.rbKey("entity.orderPayment.paymentMethod")#</th>
				<th>#$.Slatwall.rbKey("entity.orderPayment.amount")#</th>
				<th>&nbsp</th>
			</tr>
			<cfloop array="#local.payments#" index="local.thisPayment">
			<tr>
				<td class="varWidth">#$.Slatwall.rbKey("entity.paymentMethod." & local.thisPayment.getPaymentMethod().getPaymentMethodID())#</td>
				<td>#local.thisPayment.getFormattedValue('amount', 'currency')#</td>
				<td class="administration">
		          <ul class="one">
		          	<li class="zoomIn">           
						<a class="paymentDetails detail" id="show_#local.thisPayment.getOrderPaymentID()#" title="Payment Detail" href="##">#$.slatwall.rbKey("admin.order.detail.paymentDetails")#</a>
					</li>
					<li class="zoomOut">           
						<a class="paymentDetails detail" id="show_#local.thisPayment.getOrderPaymentID()#" title="Payment Detail" href="##">#$.slatwall.rbKey("admin.order.detail.paymentDetails")#</a>
					</li>
		          </ul>     						
				</td>
			</tr>
			<tr id="orderDetail_#local.thisPayment.getOrderPaymentID()#" style="display:none;">
				<td colspan="3">
					<!--- set up order payment in params struct to pass into view which shows information specific to the payment method --->
					<cfset local.params.orderPayment = local.thisPayment />
					<div class="paymentDetails">
					#view("order/payment/#lcase(local.thisPayment.getPaymentMethod().getPaymentMethodID())#", local.params)#
					</div>
				</td>
			</tr>
			</cfloop>
		</table>
		<p><strong>#$.Slatwall.rbKey("admin.order.detail.ordertotals")#</strong></p>
		<dl class="orderTotals">
			<dt>#$.Slatwall.rbKey("admin.order.detail.subtotal")#</dt> 
			<dd>#rc.order.getFormattedValue('subtotal', 'currency')#</dd>
			<dt>#$.Slatwall.rbKey("admin.order.detail.totaltax")#</dt>
			<dd>#rc.order.getFormattedValue('taxTotal', 'currency')#</dd>
			<dt>#$.Slatwall.rbKey("admin.order.detail.totalFulfillmentCharge")#</dt>
			<dd>#rc.order.getFormattedValue('fulfillmentTotal', 'currency')#</dd>
			<dt>#$.Slatwall.rbKey("admin.order.detail.totalDiscounts")#</dt>
			<dd>#rc.order.getFormattedValue('discountTotal', 'currency')#</dd>
			<dt><strong>#$.Slatwall.rbKey("admin.order.detail.total")#</strong></dt> 
			<dd><strong>#rc.order.getFormattedValue('total', 'currency')#</strong></dd>
		</dl>
	</div>
	<div class="clear">
		
		<h4>Return These Items (Already Delivered)</h4>

		<form name="vendorEdit" id="vendorEdit" action="#buildURL(action='admin:vendor.savevendor')#" method="post">
			<input type="hidden" name="referencingOrderID" value="#rc.order.getOrderID()#" />

			<div id="actionButtons" class="clearfix">
				<cf_SlatwallActionCaller action="admin:order.detail" queryString="orderId=#rc.order.getOrderID()#" class="button" text="#rc.$.Slatwall.rbKey('sitemanager.cancel')#">
				<cf_SlatwallActionCaller action="admin:order.saveorderreturn" type="submit" class="button">
			</div>

			<table id="OrderReturnList" class="listing-grid stripe">
				<tr>
					<th>SKU Code</th>
					<th class="varWidth">Brand - Product Name</th>
					<th>Originally Ordered Qty</th>
					<th>Original Discount Amount</th>
					<th>Previously Returned Quantity</th>
					<th>Previously Returned Amount</th>
					<th>Return Price</th>
					<th>Returning</th>
					<th>Return Extended Amount</th>
				</tr>
				<cfloop array="#rc.order.getOrderItems()#" index="rc.orderItem">
					<tr>
						<td>#rc.orderItem.getSku().getSkuCode()#</td>
						<td class="varWidth">
							<strong>#rc.orderItem.getSku().getProduct().getBrand().getBrandName()# #rc.orderItem.getSku().getProduct().getProductName()#</strong>
							<cfif rc.orderItem.hasAttributeValue() or arrayLen(rc.orderItem.getSku().getOptions())>
							  <ul class="inlineAdmin">
					          	<li class="zoomIn">           
									<a class="customizations detail" id="show_#rc.orderItem.getOrderItemID()#" title="#$.slatwall.rbKey('admin.order.orderItem.optionsandcustomizations')#" href="##">#$.slatwall.rbKey("admin.order.orderItem.optionsandcustomizations")#</a>
								</li>
								<li class="zoomOut">           
									<a class="customizations detail" id="show_#rc.orderItem.getOrderItemID()#" title="#$.slatwall.rbKey('admin.order.orderItem.optionsandcustomizations')#" href="##">#$.slatwall.rbKey("admin.order.orderItem.optionsandcustomizations")#</a>
								</li>
					          </ul>
							  <div class="clear" style="display:none;">
							  <hr>
								<cfif arrayLen(rc.orderItem.getSku().getOptions())>
									<div><h5>Options</h5>
										<ul>
										<cfloop array="#rc.orderItem.getSku().getOptions()#" index="local.option" >
											<li>#local.option.getOptionGroup().getOptionGroupName()#: #local.option.getOptionName()#</li>
										</cfloop>
										</ul>
									</div>
								</cfif>
								<cfif arrayLen(rc.orderItem.getAttributeValues())>
									<div><h5>Customizations</h5>
										#rc.orderItem.displayCustomizations(format="htmlList")#
									</div>
								</cfif>
							  </div> 
							</cfif>
						</td>					
						<td>#rc.orderItem.getQuantity()#</td>
						<td>#rc.orderItem.getFormattedValue('discountAmount', 'currency')#</td>
						
						<cfset quantityPRiceAlreadyOrdered = rc.orderItem.getQuantityPriceAlreadyReturned()>
						<td>#quantityPRiceAlreadyOrdered.quantity#</td>
						<td>#quantityPRiceAlreadyOrdered.price#</td>
						<td><input type="text" name="price_orderItemId(#rc.orderItem.getOrderItemId()#)"></td>
						<td>
							<select name="returnQuantity">
								<option value="1">1</option>
								<option value="2">2</option>
							</select>
						</td>
						<td>$???</td>
					</tr>
				</cfloop>
			</table>
	
	
	
			<div class="shippingAddress">
				...
			</div>
			<div class="shippingMethod">
				...
			</div>
			<div class="totals">
				<dl class="fulfillmentTotals">
					<dt>
						#$.slatwall.rbKey("entity.order.subtotal")#:
					</dt>
					<dd>
						#rc.order.getFormattedValue('subTotal', 'currency')#
					</dd>
					
					<dt>
						#$.slatwall.rbKey("entity.order.tax")#:
					</dt>
					<dd>
						#rc.order.getFormattedValue('taxTotal', 'currency')#
					</dd>
					
					<dt>
						#$.slatwall.rbKey("entity.order.shippingCharge")#:
					</dt>
					<dd>
						#rc.order.getFormattedValue('fulfillmentDiscountAmountTotal', 'currency')#
					</dd>
					
					<dt>
						Previously Refunded Shipping Amount:
					</dt>
					<dd>
						...
					</dd>
					
					<dt>
						Refunded Shipping Amount:
					</dt>
					<dd>
						<input type="text" name="refundedShippingAmount"><br>
						[<a href="">refund all shipping</a>] 
					</dd>
					
					
					<dt>
						Total Amount To Be Refunded
					</dt>
					<dd>
						...
					</dd>
				</dl>
			</div>
			<div class="clear"></div>
		</form>


	</div>
</div>
</cfoutput>
