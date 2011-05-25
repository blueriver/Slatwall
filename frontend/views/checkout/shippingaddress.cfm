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
<cfparam name="rc.countriesArray" type="array">
<cfparam name="rc.shippingAddress" type="any">

<cfoutput>
	<div class="svofrontendcheckoutshippingaddress">
		<h3 id="checkoutShippingTitle" class="titleBlick">Shipping<cfif $.slatwall.cart().hasValidOrderShippingAddress()> <a href="?edit=shippingAddress">Edit</a></cfif></h3>
		<cfif $.slatwall.cart().hasValidAccount() and (rc.edit eq "" || rc.edit eq "shippingAddress")>
			<div id="checkoutShippingContent" class="contentBlock">
				<cfif not $.slatwall.cart().hasValidOrderShippingAddress() or rc.edit eq "shippingAddress">
					<form name="orderShipping" method="post" action="?slatAction=frontend:checkout.saveShippingAddress">
						<div class="shippingAddress">
							<h4>Shipping Address</h4>
							<dl>
								<dt class="spdcountry"><label for="country">#$.slatwall.rbKey('entity.address.countryCode')#</label></dt>
								<dd id="spdcountry"><cf_CountrySelector countriesArray="#rc.countriesArray#" selectName="countryCode"></dd>
								<cf_PropertyDisplay object="#rc.shippingAddress#" property="name" edit="true" />
								<cf_PropertyDisplay object="#rc.shippingAddress#" property="company" edit="true" />
								<cf_PropertyDisplay object="#rc.shippingAddress#" property="streetAddress" edit="true" />
								<cf_PropertyDisplay object="#rc.shippingAddress#" property="street2Address" edit="true" />
								<cf_PropertyDisplay object="#rc.shippingAddress#" property="city" edit="true" />
								<cf_PropertyDisplay object="#rc.shippingAddress#" property="state" edit="true" />
								<cf_PropertyDisplay object="#rc.shippingAddress#" property="postalCode" edit="true" />
							</dl>
						</div>
						<input type="hidden" name="shippingAddressID" value="#rc.shippingAddress.getAddressID()#" />
						<cf_ActionCaller action="frontend:checkout.saveShippingAddress" type="submit" />
					</form>
				<cfelse>
					<div class="shippingAddress">
						<dt>#$.slatwall.cart().getOrderShippings()[1].getAddress().getName()#</dt>
						<dd>#$.slatwall.cart().getOrderShippings()[1].getAddress().getCompany()#</dd>
						<dd>#$.slatwall.cart().getOrderShippings()[1].getAddress().getStreetAddress()#</dd>
						<dd>#$.slatwall.cart().getOrderShippings()[1].getAddress().getCity()# #$.slatwall.cart().getOrderShippings()[1].getAddress().getStateCode()#, #$.slatwall.cart().getOrderShippings()[1].getAddress().getPostalCode()#</dd>
					</div>
				</cfif>
			</div>
		</cfif>
	</div>
</cfoutput>