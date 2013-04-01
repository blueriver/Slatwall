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
<cfparam name="rc.order" type="any" />
<cfparam name="rc.processObject" type="any" />
<cfparam name="rc.edit" type="boolean" />

<cf_HibachiEntityProcessForm entity="#rc.order#" edit="#rc.edit#" sRedirectAction="admin:entity.editorder">
	
	<cf_HibachiEntityActionBar type="preprocess" object="#rc.order#">
	</cf_HibachiEntityActionBar>
	
	<cf_HibachiPropertyRow>
		<cf_HibachiPropertyList>
			
			<!--- Update Order Fulfillment Details --->
			<cfif listFindNoCase(rc.order.getOrderRequirementsList(), 'fulfillment')>
				<cfloop array="#rc.order.getOrderFulfillments()#" index="orderFulfillment">
					<cfif !orderFulfillment.isProcessable('placeOrder')>
						<h4>Fulfillment Details</h4>
						
						<hr />
					</cfif>
				</cfloop>
			</cfif>
			
			<!--- Update Order Payments --->
			<cfif listFindNoCase(rc.order.getOrderRequirementsList(), 'payment')>
				<h4>Payment Details</h4>
				<hr />
			</cfif>
			
			<!---
			<cf_HibachiPropertyDisplay object="#rc.processObject#" property="orderTypeID" edit="#rc.edit#">
			<cf_HibachiPropertyDisplay object="#rc.processObject#" property="currencyCode" edit="#rc.edit#">
			<hr />
			<cf_HibachiPropertyDisplay object="#rc.processObject#" property="newAccountFlag" edit="#rc.edit#" fieldType="yesno">
			<cf_HibachiDisplayToggle selector="input[name='newAccountFlag']">	
				<cf_HibachiPropertyDisplay object="#rc.processObject#" property="firstName" edit="#rc.edit#">
				<cf_HibachiPropertyDisplay object="#rc.processObject#" property="lastName" edit="#rc.edit#">
				<cf_HibachiPropertyDisplay object="#rc.processObject#" property="company" edit="#rc.edit#">
				<cf_HibachiPropertyDisplay object="#rc.processObject#" property="phoneNumber" edit="#rc.edit#">
				<cf_HibachiPropertyDisplay object="#rc.processObject#" property="emailAddress" edit="#rc.edit#">
				<cf_HibachiPropertyDisplay object="#rc.processObject#" property="emailAddressConfirm" edit="#rc.edit#">
				<cf_HibachiPropertyDisplay object="#rc.processObject#" property="createAuthenticationFlag" edit="#rc.edit#" fieldType="yesno">
				<cf_HibachiDisplayToggle selector="input[name='createAuthenticationFlag']">
					<cf_HibachiPropertyDisplay object="#rc.processObject#" property="password" edit="#rc.edit#">
					<cf_HibachiPropertyDisplay object="#rc.processObject#" property="passwordConfirm" edit="#rc.edit#">
				</cf_HibachiDisplayToggle>
			</cf_HibachiDisplayToggle>
			<cf_HibachiDisplayToggle selector="input[name='newAccountFlag']" showValues="0">
				<cf_HibachiPropertyDisplay object="#rc.processObject#" property="accountID" autocompletePropertyIdentifiers="adminIcon,fullName,company,emailAddress,phoneNumber,address.simpleRepresentation" edit="true">
			</cf_HibachiDisplayToggle>
			<hr />
			<cf_HibachiPropertyDisplay object="#rc.processObject#" property="fulfillmentMethodID" edit="#rc.edit#">
			<cf_HibachiPropertyDisplay object="#rc.processObject#" property="orderOriginID" edit="#rc.edit#">
			--->
		</cf_HibachiPropertyList>
	</cf_HibachiPropertyRow>
	
</cf_HibachiEntityProcessForm>
