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

<cfset local.account = rc.Order.getAccount() />
<cfset local.payments = rc.Order.getOrderPayments() />

<cfoutput>

<div class="svoadminorderdetail">
	<div class="basicOrderInfo">
		<h3>#$.Slatwall.rbKey("admin.order.detail.basicorderinfo")#</h3>
		<table class="stripe" id="basicOrderInfo">
			<cf_PropertyDisplay object="#rc.Order#" property="OrderNumber" edit="#rc.edit#" displayType="table">
			<cf_PropertyDisplay object="#rc.Order.getOrderStatusType()#" title="#rc.$.Slatwall.rbKey('entity.order.orderStatusType')#" property="Type" edit="#rc.edit#"  displayType="table">
			<cf_PropertyDisplay object="#rc.Order#" property="OrderOpenDateTime" edit="#rc.edit#"  displayType="table">
			<tr>
				<td class="property">
					#rc.$.Slatwall.rbKey("entity.order.account")#
				</td>
				<td>
					#rc.Order.getAccount().getFullName()#  
					<a href="#buildURL(action='admin:account.detail',queryString='accountID=#local.account.getAccountID()#')#">
						<img src="#$.slatwall.getSlatwallRootPath()#/assets/images/admin.ui.user.png" height="16" width="16" alt="" />
					</a>
				</td>
			</tr>
			<cf_PropertyDisplay object="#local.account#" property="primaryEmailAddress" propertyObject="emailAddress" edit="#rc.edit#" displayType="table">
			<cf_PropertyDisplay object="#local.account#" property="primaryPhoneNumber" propertyObject="phoneNumber" edit="#rc.edit#" displayType="table">
	 		<cf_PropertyDisplay object="#rc.Order#" property="OrderTotal" edit="#rc.edit#" displayType="table">
			<cf_PropertyDisplay object="#rc.Order#" property="filename" edit="#rc.edit#" displayType="table">
		</table>
	</div>
	<div class="paymentInfo">
		<h3 class="tableheader">#$.Slatwall.rbKey("admin.order.detail.payments")#</h3>
		<table class="stripe">
			<tr>
				<th class="varWidth">#$.Slatwall.rbKey("entity.orderPayment.paymentMethod")#</th>
				<th>#$.Slatwall.rbKey("entity.orderPayment.billingAddress")#</th>
				<th>#$.Slatwall.rbKey("entity.orderPayment.amountAuthorized")#</th>
				<th>#$.Slatwall.rbKey("entity.orderPayment.amountCharged")#</th>
			</tr>
			<cfloop array="#local.payments#" index="local.thisPayment">
				<td class="varWidth">#$.Slatwall.rbKey("entity.paymentMethod." & local.thisPayment.getPaymentMethod().getPaymentMethodID())#</td>
				<td>#local.thisPayment.getBillingAddress().getFullAddress()#</td>
				<td>#local.thisPayment.getAmountAuthorized()#</td>
				<td>#local.thisPayment.getAmountCharged()#</td>
			</cfloop>
		</table>
	</div>
	<div class="clear">
		<div class="tabs initActiveTab ui-tabs ui-widget ui-widget-content ui-corner-all">
			<ul>
				<li><a href="##tabOrderFulfillments" onclick="return false;"><span>#rc.$.Slatwall.rbKey("admin.order.detail.tab.orderFulfillments")#</span></a></li>	
				<li><a href="##tabOrderDeliveries" onclick="return false;"><span>#rc.$.Slatwall.rbKey("admin.order.detail.tab.orderDeliveries")#</span></a></li>
				<li><a href="##tabOrderActivityLog" onclick="return false;"><span>#rc.$.Slatwall.rbKey("admin.order.detail.tab.orderActivityLog")#</span></a></li>
			</ul>
		
			<div id="tabOrderFulfillments">
				<cfloop array="#rc.order.getOrderFulfillments()#" index="local.thisOrderFulfillment">
					<cfswitch expression="#local.thisOrderFulfillment.getFulfillmentMethod().getFulfillmentMethodID()#">
						<cfcase value="shipping">
							<table class="stripe">
								<tr>
									<th>#$.slatwall.rbKey("entity.sku.skucode")#</th>
									<th class="varWidth">#$.slatwall.rbKey("entity.product.brand")# - #$.slatwall.rbKey("entity.product.productname")#</th>
									<th>#$.slatwall.rbKey("entity.orderitem.price")#</th>
									<th>#$.slatwall.rbKey("entity.orderitem.quantity")#</th>
									<th>#$.slatwall.rbKey("admin.order.detail.quantityshipped")#</th>
									<th>#$.slatwall.rbKey("admin.order.detail.priceextended")#</th>
								</tr>
									
								<cfloop array="#local.thisOrderFulfillment.getOrderFulfillmentItems()#" index="local.orderItem">
									<tr>
										<td>#local.orderItem.getSku().getSkuCode()#</td>
										<td class="varWidth">#local.orderItem.getSku().getProduct().getBrand().getBrandName()# #local.orderItem.getSku().getProduct().getProductName()#</td>
										<td>#dollarFormat(local.orderItem.getPrice())#</td>
										<td>#local.orderItem.getQuantity()#</td>
										<td></td>
										<td>#dollarFormat(local.orderItem.getPrice() * local.orderItem.getQuantity())#</td>
									</tr>
								</cfloop>
							</table>
							<div id="shippingAddress">
								<h5>#$.slatwall.rbKey("entity.orderFulfillment.shippingAddress")#</h5>
								#local.thisOrderFulfillment.getShippingAddress().getFullAddress()#	
							</div>
							<div id="shippingMethod">
								<h5>#$.slatwall.rbKey("entity.orderFulfillment.shippingMethod")#</h5>
								#local.thisOrderFulfillment.getShippingMethod().getShippingMethodName()#	
							</div>
						</cfcase>
					</cfswitch>
				</cfloop>
			</div>
			
			<div id="tabOrderDeliveries">
				
			</div>
			<div id="tabOrderActivityLog">
				
			</div>
		</div> <!-- tabs -->
	</div>
</div>
</cfoutput>
