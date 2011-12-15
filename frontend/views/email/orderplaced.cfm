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
<cfparam name="$" type="any" />
<cfparam name="local" type="struct" />
<cfparam name="order" type="any" />

<cfoutput>
	<html>
	<body style="font-family: arial; font-size: 12px;">
		<div id="container" style="width: 625px;">
			
			<!--- Add Logo Here  --->
			<!--- <img src="http://Full_URL_Path_To_Company_Logo/logo.jpg" border="0" style="float: right;"> --->
			
			<div id="top" style="width: 325px; margin: 0; padding: 0;">
				<h1 style="font-size: 20px;">Order Confirmation</h1>
				
				<table id="orderInfo" style="border-spacing: 0px; border-collapse: collapse; border: 1px solid ##d8d8d8; text-align: left; font-size: 12px; width: 350px;">
					<tbody>
						<tr>
							<td style="border: 1px solid ##d8d8d8; padding:0px 5px;"><strong>Order Number:</strong></td>
							<td style="border: 1px solid ##d8d8d8; padding:0px 5px;"> #order.getOrderNumber()#</td>
						</tr>
						<tr>
							<td style="border: 1px solid ##d8d8d8; padding:0px 5px;"><strong>Order Placed:</strong></td>
							<td style="border: 1px solid ##d8d8d8; padding:0px 5px;"> #DateFormat(order.getOrderOpenDateTime(), "DD/MM/YYYY")# - #TimeFormat(order.getOrderOpenDateTime(), "short")#</td>
						</tr>
						<tr>
							<td style="border: 1px solid ##d8d8d8; padding:0px 5px;"><strong>Customer:</strong></td>
							<td style="border: 1px solid ##d8d8d8; padding:0px 5px;"> #order.getAccount().getFirstName()# #order.getAccount().getLastName()#</td>
						</tr>
						<tr>
							<td style="border: 1px solid ##d8d8d8; padding:0px 5px;"><strong>Email:</strong></td>
							<td style="border: 1px solid ##d8d8d8; padding:0px 5px;"> <a href="mailto:#order.getAccount().getEmailAddress()#">#order.getAccount().getEmailAddress()#</a></td>
						</tr>
						<tr>
							<td style="border: 1px solid ##d8d8d8; padding:0px 5px;"><strong>Phone:</strong></td>
							<td style="border: 1px solid ##d8d8d8; padding:0px 5px;"> #order.getAccount().getPhoneNumber()#</td>
						</tr>
					</tbody>
				</table>
			</div>
			
			<br style="clear:both;" />
			
			<div id="orderItems" style="margin-top: 15px; float: left; clear: both; width: 600px;">
				<table id="styles" style="border-spacing: 0px; border-collapse: collapse; border: 1px solid ##d8d8d8; text-align: left; font-size: 12px; width:600px;">
					<thead>
						<tr>
							<th style="background: ##f9f9f9; border: 1px solid ##d8d8d8; padding: 0px 5px;">Sku Code</th>
							<th style="background: ##f9f9f9; border: 1px solid ##d8d8d8; padding: 0px 5px;">Product</th>
							<th style="background: ##f9f9f9; border: 1px solid ##d8d8d8; padding: 0px 5px;">Options</th>
							<th style="background: ##f9f9f9; border: 1px solid ##d8d8d8; padding: 0px 5px;">Price</th>
							<th style="background: ##f9f9f9; border: 1px solid ##d8d8d8; padding: 0px 5px;">Qty</th>
							<th style="background: ##f9f9f9; border: 1px solid ##d8d8d8; padding: 0px 5px;">Total</th>
						</tr>
					</thead>
					<tbody>
						<cfloop array="#order.getOrderItems()#" index="orderItem">
							<tr>
								<td style="border: 1px solid ##d8d8d8; padding:0px 5px;">#orderItem.getSku().getSkuCode()#</td>
								<td style="border: 1px solid ##d8d8d8; padding:0px 5px;">#orderItem.getSku().getProduct().getTitle()#</td>
								<td style="border: 1px solid ##d8d8d8; padding:0px 5px;"><cfif len(orderItem.getSku().displayOptions())>#orderItem.getSku().displayOptions()#</cfif></td>
								<td style="border: 1px solid ##d8d8d8; padding:0px 5px;">#DollarFormat(orderItem.getPrice())# </td> 
								<td style="border: 1px solid ##d8d8d8; padding:0px 5px;">#NumberFormat(orderItem.getQuantity())# </td>
								<td style="border: 1px solid ##d8d8d8; padding:0px 5px;">
									<cfif orderItem.getDiscountAmount()>
										<span style="text-decoration:line-through; color:##cc0000;">#DollarFormat(orderItem.getExtendedPrice())#</span><br />
										#DollarFormat(orderItem.getExtendedPriceAfterDiscount())#
									<cfelse>
										#DollarFormat(orderItem.getExtendedPriceAfterDiscount())#
									</cfif>
								</td>
							</tr>
						</cfloop>
					</tbody>
				</table>
			</div>
					
			<br style="clear:both;" />
	
			<div id="bottom" style="margin-top: 15px; float: left; clear: both; width: 600px;">
				<div id="shippingAddress" style="width:190px; margin-right:10px; float:left;">
					<strong>Shipping Address</strong><br /><br />
					<cfif len(order.getOrderFulfillments()[1].getShippingAddress().getName())>#order.getOrderFulfillments()[1].getShippingAddress().getName()#<br /></cfif>
					<cfif len(order.getOrderFulfillments()[1].getShippingAddress().getStreetAddress())>#order.getOrderFulfillments()[1].getShippingAddress().getStreetAddress()#<br /></cfif>
					<cfif len(order.getOrderFulfillments()[1].getShippingAddress().getStreet2Address())>#order.getOrderFulfillments()[1].getShippingAddress().getStreet2Address()#<br /></cfif>
					#order.getOrderFulfillments()[1].getShippingAddress().getCity()#, #order.getOrderFulfillments()[1].getShippingAddress().getStateCode()# #order.getOrderFulfillments()[1].getShippingAddress().getPostalCode()#<br />
					#order.getOrderFulfillments()[1].getShippingAddress().getCountryCode()#
				</div>
				<div id="shippingMethod" style="width:190px; margin-right:10px; float:left;">
					<strong>Shipping Method</strong><br /><br />
					#order.getOrderFulfillments()[1].getShippingMethod().getShippingMethodName()#
				</div>
				<table id="total" style="border-spacing: 0px; border-collapse: collapse; border: 1px solid ##d8d8d8; text-align: left; font-size: 12px; width:200px; float:left;">
					<thead>
						<tr>
							<th colspan="2" style="background: ##f9f9f9; border: 1px solid ##d8d8d8; padding: 0px 5px;">Totals</th>
							</tr>
						</thead>
						<tbody>
							<tr>
								<td style="border: 1px solid ##d8d8d8; padding:0px 5px;"><strong>Subtotal</strong></td>
								<td style="border: 1px solid ##d8d8d8; padding:0px 5px;">#DollarFormat(order.getSubtotal())#</td>
							</tr>
							<tr>
								<td style="border: 1px solid ##d8d8d8; padding:0px 5px;"><strong>Delivery Charges</strong></td>
							<td style="border: 1px solid ##d8d8d8; padding:0px 5px;">#DollarFormat(order.getFulfillmentTotal())#</td>
						</tr>
						<tr>
							<td style="border: 1px solid ##d8d8d8; padding:0px 5px;"><strong>Tax</strong></td>
							<td style="border: 1px solid ##d8d8d8; padding:0px 5px;">#DollarFormat(order.getTaxTotal())#</td>
						</tr>
						<cfif order.getDiscountTotal()>
						<tr>
							<td style="border: 1px solid ##d8d8d8; padding:0px 5px;"><strong>Discounts</strong></td>
							<td style="border: 1px solid ##d8d8d8; padding:0px 5px; color:##cc0000;">-#DollarFormat(order.getDiscountTotal())#</td>
						</tr>
						</cfif>
						<tr>
							<td style="border: 1px solid ##d8d8d8; padding:0px 5px;"><strong>Total</strong></td>
							<td style="border: 1px solid ##d8d8d8; padding:0px 5px;">#DollarFormat(order.getTotal())#</td>
						</tr>
					</tbody>
				</table>
			</div>
			
			<br style="clear:both;" />
			
			<cfif arrayLen(order.getOrderPayments())>
				<div id="orderPayments" style="margin-top: 15px; float: left; clear: both; width: 600px;">
					<table id="payment" style="border-spacing: 0px; border-collapse: collapse; border: 1px solid ##d8d8d8; text-align: left; font-size: 12px; width:600px;">
						<thead>
							<tr>
								<th style="background: ##f9f9f9; border: 1px solid ##d8d8d8; padding: 0px 5px;">Payment Method</th>
								<th style="background: ##f9f9f9; border: 1px solid ##d8d8d8; padding: 0px 5px;">Payment Amount</th>
							</tr>
						</thead>
						<tbody>
							<cfloop array="#order.getOrderPayments()#" index="orderPayment">
								<tr>
									<td style="border: 1px solid ##d8d8d8; padding:0px 5px;">#application.slatwall.pluginConfig.getApplication().getValue("rbFactory").getKeyValue(session.rb,"admin.setting.paymentMethod.#orderPayment.getPaymentMethodID()#")#</td>
									<td style="border: 1px solid ##d8d8d8; padding:0px 5px; width:100px;">#DollarFormat(orderPayment.getAmount())#</td>
								</tr>
							</cfloop>
						</tbody>
					</table>
				</div>
			</cfif>
		</div>
	</body>
	</html>
</cfoutput>