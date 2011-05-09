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
<cfparam name="rc.validAccount" type="boolean" />
<cfparam name="rc.validShippingAddress" type="boolean" />
<cfparam name="rc.validShippingMethod" type="boolean" />
<cfparam name="rc.validPayment" type="boolean" />

<cfoutput>
	<div class="svofrontendcheckoutdetail">
		<h3 id="checkoutAccountTitle" class="titleBlock">Account <cfif rc.validAccount><a href="?doaction=logout" class="editLink">Edit</a></cfif></h3>
		<div id="checkoutAccountContent" class="contentBlock">
			<cfif rc.validAccount>
				<dl class="accountInfo">
					<dt class="fullName">#$.slatwall.cart().getAccount().getFullName()#</dt>
					<dd class="primaryEmail">#$.slatwall.cart().getAccount().getPrimaryEmail()#</dd>
				</dl>
			<cfelse>
				<div class="loginAccount">
					<form name="loginAccount" method="post" action="?nocache=1">
						<h4>Account Login</h4>
						<dl>
							<dt>E-Mail Address</dt>
							<dd><input type="text" name="username" value="" /></dd>
							<dt>Password</dt>
							<dd><input type="password" name="password" value="" /></dd>
						</dl>
						<input type="hidden" name="doaction" value="login" />
						<button type="submit">Login & Continue</button>
					</form>
				</div>
				<div class="newAccount">
					<form name="newAccount" method="post" action="?slatAction=frontend:checkout.saveNewAccount">
						<h4>New Customer</h4>
						<dl>
							<dt>First Name</dt>
							<dd><input type="text" name="firstName" value="" /></dd>
							<dt>Last Name</dt>
							<dd><input type="text" name="lastName" value="" /></dd>
							<dt>Phone Number</dt>
							<dd><input type="text" name="phoneNumber" value="" /></dd>
							<dt>Email</dt>
							<dd><input type="text" name="email" value="" /></dd>
							<dt>Confirm Email</dt>
							<dd><input type="text" name="emailConfirm" value="" /></dd>
							<dt>Guest Checkout</dt>
							<dd>
								<input type="radio" name="createMuraAccount" value="1" />Save Account
								<input type="radio" name="createMuraAccount" value="0" checked="checked" />Checkout As Guest
							</dd>
							<div class="accountPassword" style="display:none;">
								<dt>Password</dt>
								<dd><input type="password" name="password" value="" /></dd>
								<dt>Confirm Password</dt>
								<dd><input type="password" name="passwordConfirm" value="" /></dd>
							</div>
						</dl>
						<button type="submit">Continue</button>
					</form>
				</div>
			</cfif>
		</div>
		<h3 id="checkoutShippingTitle" class="titleBlick">Shipping</h3>
		<cfif rc.validAccount>
			<div id="checkoutShippingContent" class="contentBlock">
				<cfif rc.validShippingAddress>
				<cfelse>
					<form name="orderShipping" method="post" action="?slatAction=frontend:checkout.saveOrderShipping">
						<div class="shippingAddress">
							<h4>Shipping Address</h4>
							<dl>
								<dt>Name</dt>
								<dd><input type="text" name="shippingName" value="" /></dd>
								<dt>Company</dt>
								<dd><input type="text" name="shippingCompany" value="" /></dd>
								<dt>Street Address</dt>
								<dd><input type="text" name="shippingStreetAddress" value="" /></dd>
								<dt>Street Address 2</dt>
								<dd><input type="text" name="shippingStreet2Address" value="" /></dd>
								<dt>City</dt>
								<dd><input type="text" name="shippingCity" value="" /></dd>
								<dt>State</dt>
								<dd><input type="text" name="shippingState" value="" /></dd>
								<dt>Postal Code</dt>
								<dd><input type="text" name="shippingPostalCode" value="" /></dd>
							</dl>
						</div>
						<div class="shippingMethod">
							<h4>Shipping Method</h4>
							<div class="shippingOptions">
								
							</div>
						</div>
						<button type="submit">Save & Continue</button>
					</form>
				</cfif>
			</div>
		</cfif>
		<h3 id="checkoutShippingMethodTitle" class="titleBlick">Shipping Method</h3>
		<cfif rc.validAccount && rc.validShippingAddress>
			<div id="checkoutShippingMethodContent" class="contentBlock">
				
			</div>
		</cfif>
		<h3 id="checkoutPaymentTitle" class="titleBlick">Payment</h3>
		<cfif rc.validAccount && rc.validShippingAddress && rc.validShippingMethod>
			<div id="checkoutPaymentContent" class="contentBlock">
				<div class="paymentAddress">
					<h4>Payment Address</h4>
					<dl>
						<dt>Same As Shipping</dt>
						<dd><input type="checkbox" name="sameAsShipping" value="1" checked="checked" /></dd>
					</dl>
				</div>
				<div class="paymentMethod">
					<h4>Payment Method</h4>
					<dl>
						<!--- Payment Options Here --->
					</dl>
				</div>
			</div>
		</cfif>
		<h3 id="checkoutItemsTitle" class="titleBlick">Order Items</h3>
		<div id="checkoutItemsContent" class="contentBlock orderItems">
			<cfloop array="#$.slatwall.cart().getOrderItems()#" index="local.orderItem">
				<dl class="orderItem">
					<dt class="image">#local.orderItem.getSku().getImage(size="small")#</dt>
					<dt class="title"><a href="#local.orderItem.getSku().getProduct().getProductURL()#" title="#local.orderItem.getSku().getProduct().getTitle()#">#local.orderItem.getSku().getProduct().getTitle()#</a></dt>
					<dd class="options">#local.orderItem.getSku().displayOptions()#</dd>
					<dd class="price">#DollarFormat(local.orderItem.getPrice())#</dd>
					<dd class="quantity">#NumberFormat(local.orderItem.getQuantity(),"0")#</dd>
					<dd class="extended">#DollarFormat(local.orderItem.getExtendedPrice())#</dd>
				</dl>
			</cfloop>
			<dl class="totals">
				<dt class="subtotal">Subtotal</dt>
				<dd class="subtotal">#DollarFormat($.slatwall.cart().getSubtotal())#</dd>
				<dt class="shipping">Shipping</dt>
				<dd class="shipping">#DollarFormat($.slatwall.cart().getShippingTotal())#</dd>
				<dt class="tax">Tax</dt>
				<dd class="tax">#DollarFormat($.slatwall.cart().getTaxTotal())#</dd>
				<dt class="total">Total</dt>
				<dd class="total">#DollarFormat($.slatwall.cart().getTotal())#</dd>
			</dl>
		</div>
		<cfif rc.validAccount && rc.validShippingAddress && rc.validPayment>
			<form name="processOrder" action="?slatAction=frontend:checkout.processOrder">
				<button type="submit">Submit Order</button>
			</form>
		</cfif>
	</div>
	<cfdump var="#$.slatwall.cart().getAccount()#" top="2" />
</cfoutput>