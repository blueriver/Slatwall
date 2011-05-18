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
<cfparam name="rc.edit" type="string" default="">

<cfoutput>
	<div class="svofrontendcheckoutshipping">
		<h3 id="checkoutShippingTitle" class="titleBlick">Shipping</h3>
		<cfif $.slatwall.cart().hasValidAccount() and rc.edit eq "" || rc.edit eq "shipping">
			<div id="checkoutShippingContent" class="contentBlock">
				<cfif $.slatwall.cart().hasValidOrderShippingAddress() and rc.edit eq "" || rc.edit eq "shipping">
					<cfif rc.edit eq "shipping">
						<!--- Shipping Address Edit Here --->
					<cfelse>
						<div class="shippingAddress">
							<!--- Shipping Address Display Here --->
						</div>
					</cfif>
				<cfelse>
					<form name="orderShipping" method="post" action="?slatAction=frontend:checkout.saveOrderShippingAddress">
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
						<button type="submit">Save & Continue</button>
					</form>
				</cfif>
			</div>
		</cfif>
	</div>
</cfoutput>