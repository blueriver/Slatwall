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
																						
	The core of the checkout revolves around a value called the 'orderRequirementsList'	
	There are 3 major elements that all need to be in place for an order to be placed:	
																						
	account																				
	fulfillment																			
	payment																				
																						
	With that in mind you will want to display different UI elements & forms based on 	
	if one ore more of those items are in the orderRequirementsList.  In the eample		
	below we go in that order listed above, but you could very easily do it in a		
	different order if you like.														
																						
	
--->
<cfinclude template="_slatwall-header.cfm" />

<!--- IMPORTANT: Get the orderRequirementsList to drive your UI Below --->
<cfset orderRequirementsList = $.slatwall.cart().getOrderRequirementsList() />

<cfoutput>
	<div class="container">
		
		<!--- START CEHECKOUT EXAMPLE 1 --->
		<div class="row">
			<div class="span12">
				<h3>Checkout Example 1</h3>
			</div>
		</div>
		
		<!--- Verify that there are items in the cart --->
		<cfif arrayLen($.slatwall.cart().getOrderItems())>
			<div class="row">
				
				<!--- START: CHECKOUT DETAIL --->
				<div class="span8">
					
					
					
					<cfif listFindNoCase("account", orderRequirementsList)>
						
						<!--- START: ACCOUNT --->
						<h4>Account Details #orderRequirementsList#</h4>
						
						<div class="row">
							<div class="span4">
								<h5>Login with Existing Account</h5>
								
							</div>
							<div class="span4">
								<h5>Login with Existing Account</h5>
								
							</div>
						</div>
						<!--- END: ACCOUNT --->
							
					<cfelseif listFindNoCase("fulfillment", orderRequirementsList) >
						
						<!--- START: FULFILLMENT --->
						<h4>Fulfillment Details</h4>
						
						<!--- We loop over the orderFulfillments and check if they are processable --->
						<cfloop array="#$.slatwall.cart().getOrderFulfillments()#" index="orderFulfillment">
							
							<!--- We need to check if this order fulfillment is one that needs --->
							<div class="row">
								
								<div class="span4">
									<h5>Login with Existing Account</h5>
									
								</div>
								<div class="span4">
									<h5>Login with Existing Account</h5>
									
								</div>
							</div>
							
						</cfloop>
						<!--- END: FULFILLMENT --->
							
					<cfelseif listFindNoCase("payment", orderRequirementsList)>
						
						<!--- START: PAYMENT --->
						<h4>Payment Details</h4>
						
						<div class="row">
							<div class="span4">
								<h5>Login with Existing Account</h5>
							</div>
							<div class="span4">
								<h5>Login with Existing Account</h5>
								
							</div>
						</div>
						<!--- END: PAYMENT --->
						
					</cfif>
					
					
					
						
					
						
				</div>
				<!--- END: CHECKOUT DETAIL --->
				
				<!--- START: ORDER SUMMARY --->
				<div class="span4">
					<h5>Order Summary</h5>
					
					<table class="table table-condensed">
						<!--- The Subtotal is all of the orderItems before any discounts are applied --->
						<tr>
							<td>Subtotal</td>
							<td>#$.slatwall.cart().getFormattedValue('subtotal')#</td>
						</tr>
						<!--- This displays a delivery cost, some times it might make sense to do a conditional here and check if the amount is > 0, then display otherwise show something like TBD --->
						<tr>
							<td>Delivery</td>
							<td>#$.slatwall.cart().getFormattedValue('fulfillmentTotal')#</td>
						</tr>
						<!--- Displays the total tax that was calculated for this order --->
						<tr>
							<td>Tax</td>
							<td>#$.slatwall.cart().getFormattedValue('taxTotal')#</td>
						</tr>
						<!--- If there were discounts they would be displayed here --->
						<cfif $.slatwall.cart().getDiscountTotal() gt 0>
							<tr>
								<td>Discounts</td>
								<td>#$.slatwall.cart().getFormattedValue('discountTotal')#</td>
							</tr>
						</cfif>
						<!--- The total is the finished amount that the customer can expect to pay --->
						<tr>
							<td><strong>Total</strong></td>
							<td><strong>#$.slatwall.cart().getFormattedValue('total')#</strong></td>
						</tr>
					</table>
				</div>
				<!--- END: ORDER SUMMARY --->
					
			</div>
			
		<!--- No Items In Cart --->
		<cfelse>
			
			<div class="row">
				<div class="span12">
					<p>There are no items in your cart.</p>
				</div>
			</div>
			
		</cfif>
		
		<!--- END CHECKOUT EXAMPLE 1 --->
		
	</div>
</cfoutput>
<cfinclude template="_slatwall-footer.cfm" />