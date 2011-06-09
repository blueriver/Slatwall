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
<cfparam name="rc.edit" type="string" default="" />
<cfparam name="rc.orderRequirementsList" type="string" default="" />

<cfoutput>
	<div class="svocheckoutfulfillmentshipping">
		<div class="shippingAddress">
		</div>
		<div class="shippingMethod">
		</div>
		
			<div id="checkoutShippingContent" class="contentBlock">
				<cfif listFind(rc.orderRequirementsList, 'shippingAddress') or rc.edit eq "shippingAddress">
					<form name="orderShipping" method="post" action="?slatAction=frontend:checkout.saveShippingAddress">
						<div class="shippingAddress">
							<h4>Shipping Address</h4>
							<cf_SlatwallAddressForm address="#rc.shippingAddress#">
						</div>
						<input type="hidden" name="shippingAddressID" value="#rc.shippingAddress.getAddressID()#" />
						<cf_ActionCaller action="frontend:checkout.saveShippingAddress" type="submit" />
					</form>
				<cfelse>
					<div class="shippingAddress">
						<dt>#$.slatwall.cart().getOrderFulfillments()[1].getShippingAddress().getName()#</dt>
						<dd>#$.slatwall.cart().getOrderFulfillments()[1].getShippingAddress().getCompany()#</dd>
						<dd>#$.slatwall.cart().getOrderFulfillments()[1].getShippingAddress().getStreetAddress()#</dd>
						<dd>#$.slatwall.cart().getOrderFulfillments()[1].getShippingAddress().getCity()# #$.slatwall.cart().getOrderFulfillments()[1].getShippingAddress().getStateCode()#, #$.slatwall.cart().getOrderFulfillments()[1].getShippingAddress().getPostalCode()#</dd>
					</div>
				</cfif>
			</div>
		</cfif>
	</div>
</cfoutput>

<!---
	<div class="svocheckoutshippingmethod">
	<h3 id="checkoutShippingMethodTitle" class="titleBlick">Shipping Method <cfif not listFind(rc.orderRequirementsList, "shippingMethod")> <a href="?edit=shippingMethod">Edit</a></cfif></h3>
	<cfif not listFind(rc.orderRequirementsList, "account") and not listFind(rc.orderRequirementsList, "shippingAddress") and (rc.edit eq "" || rc.edit eq "shippingMethod")>
		<div id="checkoutShippingMethodContent" class="contentBlock">
			<cfif listFind(rc.orderRequirementsList, "shippingMethod") or rc.edit eq "shippingMethod">
				<form action="?slatAction=frontend:checkout.saveshippingmethod" method="post">
				<cfset $.slatwall.cart().getOrderFulfillments()[1].populateOrderShippingMethodOptionsIfEmpty() />
				<cfset local.methodOptions = $.slatwall.cart().getOrderFulfillments()[1].getOrderShippingMethodOptions() />
				<cfloop array="#local.methodOptions#" index="option">
					<cfset local.optionSelected = false />
					<cfif $.slatwall.cart().hasValidOrderShippingMethod() && $.slatwall.cart().getOrderShippings()[1].getShippingMethod().getShippingMethodID() eq option.getOrderShippingMethodOptionID()>
						<cfset local.optionSelected = true />
					</cfif>
					<dl>
						<dt><input type="radio" name="orderShippingMethodOptionID" value="#option.getOrderShippingMethodOptionID()#" <cfif local.optionSelected>selected="selected"</cfif>>#option.getShippingMethod().getShippingMethodName()#</dt>
						<dd>#DollarFormat(option.getTotalCost())#</dd>
					</dl>
				</cfloop>
					<cf_ActionCaller action="frontend:checkout.saveShippingMethod" type="submit" />
				</form>
			<cfelse>
				<dl class="shippingMethod">
					<dt>#$.slatwall.cart().getOrderShippings()[1].getShippingMethod().getShippingMethodName()#</dt>
					<dd>#$.slatwall.cart().getOrderShippings()[1].getShippingCharge()#</dd>
				</dl>
			</cfif>
		</div>
	</cfif>
	</div>
--->
</cfoutput>