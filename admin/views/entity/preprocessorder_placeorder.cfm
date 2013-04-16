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

<cfoutput>
	<cf_HibachiEntityProcessForm entity="#rc.order#" edit="#rc.edit#" sRedirectAction="admin:entity.editorder">
		
		<cf_HibachiEntityActionBar type="preprocess" object="#rc.order#">
		</cf_HibachiEntityActionBar>
		
		<cf_HibachiPropertyRow>
			<cf_HibachiPropertyList>
				
				<!--- Update Order Fulfillment Details --->
				<cfif listFindNoCase(rc.order.getOrderRequirementsList(), 'fulfillment')>
					<cfset ofIndex=0 />
					<h3>Required Fulfillment Info</h3>
					<hr />
					<cfloop array="#rc.order.getOrderFulfillments()#" index="orderFulfillment">
						<cfset thisErrorBean = $.slatwall.getService("HibachiValidationService").validate(object=orderFulfillment, context='placeOrder', setErrors=false) />
						<cfif thisErrorBean.hasErrors()>
							<cfset ofIndex++ />
							<h4>#orderFulfillment.getSimpleRepresentation()#</h4>
							<input type="hidden" name="orderFulfillments[#ofIndex#].orderFulfillmentID" value="#orderFulfillment.getOrderFulfillmentID()#" />						
							<cfif orderFulfillment.getFulfillmentMethodType() eq "shipping">
								<cfif structKeyExists(thisErrorBean.getErrors(), "shippingMethod")>
									<cf_HibachiPropertyDisplay object="#orderFulfillment#" property="shippingMethod" fieldName="orderFulfillments[#ofIndex#].shippingMethodID" fieldClass="required" edit="#rc.edit#" />
								</cfif>
								<cfif structKeyExists(thisErrorBean.getErrors(), "shippingAddress")>
									<cf_SlatwallAdminAddressDisplay address="#orderFulfillment.getAddress()#" fieldNamePrefix="orderFulfillments[#ofIndex#]." edit="#rc.edit#" />
								</cfif>
								<hr />
							</cfif>
						</cfif>
					</cfloop>
				</cfif>
				
				<!--- Update Order Payments --->
				<cfif listFindNoCase(rc.order.getOrderRequirementsList(), 'payment')>
					<cfset opIndex = 0 />
					<cfset totalPaymentAmount = 0 />
					<h3>Required Payment Info</h3>
					<hr />
					<cfloop array="#rc.order.getOrderPayments()#" index="orderPayment">
						<cfset totalPaymentAmount += orderPayment.getAmount() />
						<cfset thisErrorBean = $.slatwall.getService("HibachiValidationService").validate(object=orderPayment, context='placeOrder', setErrors=false) />
						<cfif thisErrorBean.hasErrors()>
							<cfset opIndex++ />
							<h4>#orderPayment.getSimpleRepresentation()#</h4>
							<input type="hidden" name="orderPayments[#opIndex#].orderPaymentID" value="#orderPayment.getOrderPaymentID()#" />
						</cfif>
					</cfloop>
					<!--- Add an order payment for the full amount --->
					<cfif totalPaymentAmount lt rc.order.getTotal()>
						<h4>Add Order Payment</h4>
						<cfset aopProcessObject = rc.order.getProcessObject("addOrderPayment") />
						
						<cf_HibachiPropertyDisplay object="#aopProcessObject#" property="amount" edit="false">
						<cf_HibachiPropertyDisplay object="#aopProcessObject#" property="accountPaymentMethodID" edit="#rc.edit#">
						
						<!--- New Payment Method --->
						<cf_HibachiDisplayToggle selector="select[name='accountPaymentMethodID']" showValues="">
							
							<input type="hidden" name="newOrderPayment.orderPaymentID" value="" />
							
							<!--- New Payment Type --->
							<cf_HibachiPropertyDisplay object="#aopProcessObject.getNewOrderPayment()#" property="paymentMethod" fieldName="newOrderPayment.paymentMethod.paymentMethodID" edit="#rc.edit#">
							
							<!--- Save Order Payment as Account Payment Method --->
							<cf_HibachiDisplayToggle selector="select[name='newOrderPayment.paymentMethod.paymentMethodID']" valueAttribute="paymentmethodtype" showValues="creditCard">
								
								<!--- Save New Payment Method --->
								<cf_HibachiPropertyDisplay object="#aopProcessObject#" property="saveAccountPaymentMethodFlag" edit="#rc.edit#" />
								
								<!--- Save New Address Name --->
								<cf_HibachiDisplayToggle selector="input[name='saveAccountPaymentMethodFlag']">
									<cf_HibachiPropertyDisplay object="#aopProcessObject#" property="saveAccountPaymentMethodName" edit="#rc.edit#" />
								</cf_HibachiDisplayToggle>
							</cf_HibachiDisplayToggle>
							
							<hr />
							
							<!--- Credit Card Payment Details --->
							<cf_HibachiDisplayToggle selector="select[name='newOrderPayment.paymentMethod.paymentMethodID']" valueAttribute="paymentmethodtype" showValues="creditCard">
								<h4>#$.slatwall.rbKey('admin.define.creditCardDetails')#</h4>
								<cf_HibachiPropertyDisplay object="#aopProcessObject.getNewOrderPayment()#" fieldName="newOrderPayment.creditCardNumber" property="creditCardNumber" edit="#rc.edit#">
								<cf_HibachiPropertyDisplay object="#aopProcessObject.getNewOrderPayment()#" fieldName="newOrderPayment.nameOnCreditCard" property="nameOnCreditCard" edit="#rc.edit#">
								<cf_HibachiPropertyDisplay object="#aopProcessObject.getNewOrderPayment()#" fieldName="newOrderPayment.expirationMonth" property="expirationMonth" edit="#rc.edit#">
								<cf_HibachiPropertyDisplay object="#aopProcessObject.getNewOrderPayment()#" fieldName="newOrderPayment.expirationYear" property="expirationYear" edit="#rc.edit#">
								<cf_HibachiPropertyDisplay object="#aopProcessObject.getNewOrderPayment()#" fieldName="newOrderPayment.securityCode" property="securityCode" edit="#rc.edit#">
							</cf_HibachiDisplayToggle>
							
							<!--- Term Payment Details --->
							<cf_HibachiDisplayToggle selector="select[name='newOrderPayment.paymentMethod.paymentMethodID']" valueAttribute="paymentmethodtype" showValues="termPayment">
								<h4>#$.slatwall.rbKey('admin.define.termPaymentDetails')#</h4>
								<cf_HibachiPropertyDisplay object="#rc.order.getAccount()#" property="termAccountBalance" edit="false">
								<cf_HibachiPropertyDisplay object="#rc.order.getAccount()#" property="termAccountAvailableCredit" edit="false">
							</cf_HibachiDisplayToggle>
							
							<!--- Gift Card Details --->
							<cf_HibachiDisplayToggle selector="select[name='newOrderPayment.paymentMethod.paymentMethodID']" valueAttribute="paymentmethodtype" showValues="giftCard">
								<h4>#$.slatwall.rbKey('admin.define.giftCardDetails')#</h4>
								<cf_HibachiPropertyDisplay object="#aopProcessObject.getNewOrderPayment()#" fieldName="newOrderPayment.giftCardNumber" property="giftCardNumber" edit="#rc.edit#">
							</cf_HibachiDisplayToggle>
							
							<!--- Check Details --->
							<cf_HibachiDisplayToggle selector="select[name='newOrderPayment.paymentMethod.paymentMethodID']" valueAttribute="paymentmethodtype" showValues="check">
								<h4>#$.slatwall.rbKey('admin.define.checkDetails')#</h4>
								<cf_HibachiPropertyDisplay object="#aopProcessObject.getNewOrderPayment()#" fieldName="newOrderPayment.checkNumber" property="checkNumber" edit="#rc.edit#">
								<cf_HibachiPropertyDisplay object="#aopProcessObject.getNewOrderPayment()#" fieldName="newOrderPayment.bankRoutingNumber" property="bankRoutingNumber" edit="#rc.edit#">
								<cf_HibachiPropertyDisplay object="#aopProcessObject.getNewOrderPayment()#" fieldName="newOrderPayment.bankAccountNumber" property="bankAccountNumber" edit="#rc.edit#">
							</cf_HibachiDisplayToggle>
							
							<!--- Billing Address --->
							<cf_HibachiDisplayToggle selector="select[name='newOrderPayment.paymentMethod.paymentMethodID']" valueAttribute="paymentmethodtype" showValues="creditCard,check,termPayment">
								<hr />
								<h4>#$.slatwall.rbKey('entity.orderPayment.billingAddress')#</h4>
								<cf_HibachiPropertyDisplay object="#aopProcessObject#" property="accountAddressID" edit="#rc.edit#">
								<cf_HibachiDisplayToggle selector="select[name='accountAddressID']" showValues="">
									<cf_SlatwallAdminAddressDisplay address="#aopProcessObject.getNewOrderPayment().getBillingAddress()#" filedNamePrefix="newOrderPayment.billingAddresss." edit="#rc.edit#" />
								</cf_HibachiDisplayToggle>	
							</cf_HibachiDisplayToggle>
							
							
						</cf_HibachiDisplayToggle>
						
					</cfif>
				</cfif>
				
				
				
	
			</cf_HibachiPropertyList>
		</cf_HibachiPropertyRow>
		
	</cf_HibachiEntityProcessForm>
</cfoutput>