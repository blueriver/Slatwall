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
	<div class="svofrontendcheckoutdetail">
		<form name="checkout" method="post" action="#$.createHREF(filename='checkout')#">
			<h3 id="checkoutAccountTitle" class="titleBlock">Account</h3>
			<div id="checkoutAccountContent" class="contentBlock">
				<cfif rc.$.slatwall.cart().isNew()>
					<div class="loginAccount">
						<h4>Account Login</h4>
						<dl>
							<dt>E-Mail Address</dt>
							<dd><input type="text" name="email" value="" /></dd>
							<dt>Password</dt>
							<dd><input type="password" name="password" value="" /></dd>
						</dl>
						<button type="submit">Login & Continue</button>
					</div>
					<div class="newAccount">
						<h4>Guest Checkout</h4>
						<dl>
							<dt>First Name</dt>
							<dd><input type="text" name="firstName" value="" /></dd>
							<dt>Last Name</dt>
							<dd><input type="text" name="lastName" value="" /></dd>
							<dt>Email</dt>
							<dd><input type="text" name="email" value="" /></dd>
							<dt>Confirm Email</dt>
							<dd><input type="text" name="emailConfirm" value="" /></dd>
							<dt>Guest Checkout</dt>
							<dd>
								<input type="radio" name="guestAccount" value="0"  />Save Account
								<input type="radio" name="guestAccount" value="1" checked="checked" />Checkout As Guest
							</dd>
							<div class="guestPassword" style="display:none;">
								<dt>Password</dt>
								<dd><input type="password" name="password" value="" /></dd>
								<dt>Confirm Password</dt>
								<dd><input type="password" name="passwordConfirm" value="" /></dd>
							</div>
						</dl>
						<button type="submit">Continue</button>
					</div>
				</cfif>
			</div>
			<h3 id="checkoutShippingTitle" class="titleBlick">Shipping</h3>
			<div id="checkoutShippingContent" class="contentBlock">
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
					<h4>Shipping Metod</h4>
					<dl>
						<!--- Shipping Options Here --->
					</dl>
				</div>
				<button type="submit">Save & Continue</button>
			</div>
			<h3 id="checkoutPaymentTitle" class="titleBlick">Payment</h3>
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
			<h3 id="checkoutItemsTitle" class="titleBlick">Order Items</h3>
			<div id="checkoutItemsContent" class="contentBlock">
				<div class="paymentItems">
					<dl>
						<dt>Same As Shipping</dt>
						<dd><input type="checkbox" name="sameAsShipping" value="1" checked="checked" /></dd>
					</dl>
				</div>
				<button type="submit">Submit Order</button>
			</div>
		</form>
	</div>
</cfoutput>