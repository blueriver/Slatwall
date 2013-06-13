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
<cfparam name="rc.edit" type="boolean" />

<cfoutput>
	<cf_HibachiEntityProcessForm entity="#rc.order#" edit="#rc.edit#" sRedirectAction="admin:entity.editorder">
		
		<cf_HibachiEntityActionBar type="preprocess" object="#rc.order#">
		</cf_HibachiEntityActionBar>
		
		<cf_HibachiPropertyRow>
			<cf_HibachiPropertyList>
				
				<h3>Required Details</h3>
				<hr />
				<!--- Update Order Fulfillment Details --->
				<cfif listFindNoCase(rc.order.getOrderRequirementsList(), 'fulfillment')>
					<cfset ofIndex=0 />
					
					<cfloop array="#rc.order.getOrderFulfillments()#" index="orderFulfillment">
						<cfset thisErrorBean = $.slatwall.getService("HibachiValidationService").validate(object=orderFulfillment, context='placeOrder', setErrors=false) />
						<cfif thisErrorBean.hasErrors()>
							<cfset ofIndex++ />
							<h4>#orderFulfillment.getSimpleRepresentation()#</h4>
							<input type="hidden" name="orderFulfillments[#ofIndex#].orderFulfillmentID" value="#orderFulfillment.getOrderFulfillmentID()#" />						
							<cfif orderFulfillment.getFulfillmentMethodType() eq "shipping">
								<cfif structKeyExists(thisErrorBean.getErrors(), "shippingMethod")>
									<cf_HibachiPropertyDisplay object="#orderFulfillment#" property="shippingMethod" fieldName="orderFulfillments[#ofIndex#].shippingMethod.shippingMethodID" fieldClass="required" edit="#rc.edit#" />
								</cfif>
								<cfif structKeyExists(thisErrorBean.getErrors(), "shippingAddress")>
									<cf_SlatwallAdminAddressDisplay address="#orderFulfillment.getAddress()#" fieldNamePrefix="orderFulfillments[#ofIndex#].shippingAddress" edit="#rc.edit#" />
								</cfif>
								<hr />
							</cfif>
						</cfif>
					</cfloop>
				</cfif>
				
				<!--- Update Order Payments --->
				<cfif listFindNoCase(rc.order.getOrderRequirementsList(), 'payment')>
					<cfset opIndex = 0 />
					<cfloop array="#rc.order.getOrderPayments()#" index="orderPayment">
						<cfset thisErrorBean = $.slatwall.getService("HibachiValidationService").validate(object=orderPayment, context='placeOrder', setErrors=false) />
						<cfif thisErrorBean.hasErrors()>
							<cfset opIndex++ />
							<h4>#orderPayment.getSimpleRepresentation()#</h4>
							<input type="hidden" name="orderPayments[#opIndex#].orderPaymentID" value="#orderPayment.getOrderPaymentID()#" />
						</cfif>
					</cfloop>
					
					<!--- Add an order payment for the remaining amount if needed --->
					<cfif rc.order.getTotalPaymentAmount() neq rc.order.getTotal()>
						<h4>Add Order Payment</h4>
						
						<cfset rc.addOrderPaymentProcessObject = rc.order.getProcessObject("addOrderPayment") />
						
						<!--- Add a hidden field for the orderID --->
						<input type="hidden" name="newOrderPayment.order.orderID" value="#rc.order.getOrderID()#" />
						
						<!--- Display the amount that is going to be used --->
						<cf_HibachiPropertyDisplay object="#rc.addOrderPaymentProcessObject.getNewOrderPayment()#" property="amount" edit="false">
						
						<!--- Add hidden value for payment type, and display what it is going to be --->
						<input type="hidden" name="newOrderPayment.orderPaymentType.typeID" value="#rc.order.getAddPaymentRequirementDetails().orderPaymentType.getTypeID()#" />
						<cf_HibachiPropertyDisplay object="#rc.addOrderPaymentProcessObject.getNewOrderPayment()#" property="orderPaymentType" value="#rc.order.getAddPaymentRequirementDetails().orderPaymentType.getType()#" edit="false">
						
						<cfinclude template="preprocessorder_include/addorderpayment.cfm" />
					</cfif>
				</cfif>
				
			</cf_HibachiPropertyList>
		</cf_HibachiPropertyRow>
		
	</cf_HibachiEntityProcessForm>
</cfoutput>