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

<!--- This import allows for the custom tags required by this page to work --->
<cfimport prefix="sw" taglib="/Slatwall/public/tags" />

<!---[DEVELOPER NOTES]															
																				
	If you would like to customize any of the public tags used by this			
	template, the recommended method is to uncomment the below import,			
	copy the tag you'd like to customize into the directory defined by			
	this import, and then reference with swc:tagname instead of sw:tagname.		
	Technically you can define the prefix as whatever you would like and use	
	whatever directory you would like but we recommend using this for			
	the sake of convention.														
																				
	<cfimport prefix="swc" taglib="/Slatwall/custom/public/tags" />				
																				
--->

<!--- IMPORTANT: Get the orderRequirementsList to drive your UI Below --->
<cfset orderRequirementsList = $.slatwall.cart().getOrderRequirementsList() />

<!---[DEVELOPER NOTES]															
																				
	IMPORTANT: The orderRequirementsList just makes sure that there is an		
	account attached to the order, however it does not ensure that the user be	
	logged in because we allow by default for "guest checkout".  By leaving in	
	the conditionals below it will require that the user is logged in, or that	
	they are currently submitting the form as a guest checkout person			
																				
--->


<!--- Because we are going to potentially be dynamically adding 'account' back into the orderRequirementsList, we need to make sure that it isn't already part of the list, and that the session account ID's doesn't match the cart account ID --->
<cfif not listFindNoCase(orderRequirementsList, "account") and $.slatwall.cart().getAccount().getAccountID() neq $.slatwall.account().getAccountID()>

	<!--- Add account to the orderRequirements list --->
	<cfset orderRequirementsList = listPrepend(orderRequirementsList, "account") />

	<!--- OPTIONAL: This should be left in if you would like to allow for guest checkout --->
	<cfif $.slatwall.account().getGuestAccountFlag()>
		
		<!--- OPTIONAL: This condition can be left in if you would like to make it so that a guest checkout is only valid if the page is refreshed via a form post with guestCheckoutFlag always passed across --->
		<cfif structKeyExists(form, "guestAccountFlag") && form.guestAccountFlag>
			<cfset orderRequirementsList = listDeleteAt(orderRequirementsList, listFindNoCase(orderRequirementsList, "account")) />
		</cfif>
		<!--- IMPORTANT: If you delete the above contitional so that a guest can move about the site without loosing their checkout data, then you will want to uncomment below --->
		<!--- <cfset orderRequirementsList = listDeleteAt(orderRequirementsList, listFindNoCase(orderRequirementsList, "account")) /> ---> 
		
	</cfif>
</cfif>

<cfoutput>
	<div class="container">
		
		<!--- START CEHECKOUT EXAMPLE 1 --->
		<div class="row">
			<div class="span12">
				<h3>Checkout Example 1 ( 3 Step Process: Account - Fulfillment - Payment )</h3>
			</div>
		</div>
		
		<!--- Verify that there are items in the cart --->
		<cfif arrayLen($.slatwall.cart().getOrderItems())>
			<div class="row">
				
				<!--- START: CHECKOUT DETAIL --->
				<div class="span8">
					
					<cfif listFindNoCase(orderRequirementsList, "account")>
						
						<!--- START: ACCOUNT --->
						<h4>Account Details</h4>
						
						<div class="row">
							
							<!--- LOGIN --->
							<div class="span4">
								
								<h5>Login with Existing Account</h5>
								
								<!--- Sets up the account login processObject --->
								<cfset accountLoginObj = $.slatwall.getSession().getProcessObject('authorizeAccount') />
								
								<!--- Start: Login Form --->
								<form action="?s=1" method="post">
									
									<!--- This hidden input is what tells slatwall to try and login the account --->
									<input type="hidden" name="slatAction" value="public:account.login" />
									
									<!--- Email Address --->
									<div class="control-group">
				    					<label class="control-label" for="rating">Email Address</label>
				    					<div class="controls">
				    						
											<sw:formField type="text" valueObject="#accountLoginObj#" valueObjectProperty="emailAddress" class="span4" />
											<sw:errorDisplay object="#accountLoginObj#" errorName="emailAddress" />
											
				    					</div>
				  					</div>
									
									
									<!--- Password --->
									<div class="control-group">
				    					<label class="control-label" for="rating">Password</label>
				    					<div class="controls">
				    						
											<sw:formField type="password" valueObject="#accountLoginObj#" valueObjectProperty="password" class="span4" />
											<sw:errorDisplay object="#accountLoginObj#" errorName="password" />
											
				    					</div>
				  					</div>
									
									<!--- Login Button --->
									<div class="control-group">
				    					<div class="controls">
				      						<button type="submit" class="btn">Login Account</button>
				    					</div>
				  					</div>
									
								</form>
								<!--- End: Login Form --->
									
								<hr />
								
								<h5>Forgot Password</h5>
								
								<!--- Sets up the account login processObject --->
								<cfset forgotPasswordObj = $.slatwall.getAccount().getProcessObject('forgotPassword') />
								
								<!--- Start: Login Form --->
								<form action="?s=1" method="post">
									
									<!--- This hidden input is what tells slatwall to try and login the account --->
									<input type="hidden" name="slatAction" value="public:account.forgotPassword" />
									
									<!--- Email Address --->
									<div class="control-group">
				    					<label class="control-label" for="rating">Email Address</label>
				    					<div class="controls">
				    						
											<sw:formField type="text" valueObject="#accountLoginObj#" valueObjectProperty="emailAddress" class="span4" />
											<sw:errorDisplay object="#accountLoginObj#" errorName="emailAddress" />
											
				    					</div>
				  					</div>
									
									<!--- Reset Email Button --->
									<div class="control-group">
				    					<div class="controls">
				      						<button type="submit" class="btn">Send Me Reset Email</button>
				    					</div>
				  					</div>
									
								</form>
								<!--- End: Login Form --->
								
							</div>
							
							<!--- CREATE ACCOUNT --->
							<div class="span4">
								<h5>Create New Account</h5>
								
								<!--- Sets up the create account processObject --->
								<cfset createAccountObj = $.slatwall.account().getProcessObject('create') />
								
								<!--- Create Account Form --->
								<form action="?s=1" method="post">
									<!--- This hidden input is what tells slatwall to 'create' an account, it is then chained by the 'login' method so that happens directly after --->
									<input type="hidden" name="slatAction" value="public:account.create,public:account.login" />
									
									<!--- This is also passed so that guestCheckout will work when the page is reloaded --->
									<input type="hidden" name="guestCheckoutFlag" value="1" />
									
									<!--- Name --->
									<div class="row">
										
										<!--- First Name --->
										<div class="span2">
											<div class="control-group">
						    					<label class="control-label" for="rating">First Name</label>
						    					<div class="controls">
						    						
													<sw:formField type="text" valueObject="#createAccountObj#" valueObjectProperty="firstName" class="span2" />
													<sw:errorDisplay object="#createAccountObj#" errorName="firstName" />
													
						    					</div>
						  					</div>
										</div>
										
										<!--- Last Name --->
										<div class="span2">
											<div class="control-group">
						    					<label class="control-label" for="rating">Last Name</label>
						    					<div class="controls">
						    						
													<sw:formField type="text" valueObject="#createAccountObj#" valueObjectProperty="lastName" class="span2" />
													<sw:errorDisplay object="#createAccountObj#" errorName="lastName" />
													
						    					</div>
						  					</div>
										</div>
										
									</div>
									
									<!--- Phone Number --->
									<div class="control-group">
				    					<label class="control-label" for="rating">Phone Number</label>
				    					<div class="controls">
				    						
											<sw:formField type="text" valueObject="#createAccountObj#" valueObjectProperty="phoneNumber" class="span4" />
											<sw:errorDisplay object="#createAccountObj#" errorName="phoneNumber" />
											
				    					</div>
				  					</div>
									
									<!--- Email Address --->
									<div class="control-group">
				    					<label class="control-label" for="rating">Email Address</label>
				    					<div class="controls">
				    						
											<sw:formField type="text" valueObject="#createAccountObj#" valueObjectProperty="emailAddress" class="span4" />
											<sw:errorDisplay object="#createAccountObj#" errorName="emailAddress" />
											
				    					</div>
				  					</div>
									
									<!--- Email Address Confirm --->
									<div class="control-group">
				    					<label class="control-label" for="rating">Confirm Email Address</label>
				    					<div class="controls">
				    						
											<sw:formField type="text" valueObject="#createAccountObj#" valueObjectProperty="emailAddressConfirm" class="span4" />
											<sw:errorDisplay object="#createAccountObj#" errorName="emailAddressConfirm" />
											
				    					</div>
				  					</div>
									
									<!--- Guest Checkout --->
									<div class="control-group">
				    					<label class="control-label" for="rating">Save Account ( No for Guest Checkout )</label>
				    					<div class="controls">
				    						
											<sw:formField type="yesno" valueObject="#createAccountObj#" valueObjectProperty="createAuthenticationFlag" />
											<sw:errorDisplay object="#createAccountObj#" errorName="createAuthenticationFlag" />
											
				    					</div>
				  					</div>
									
									<!--- SCRIPT IMPORTANT: This jQuery is just here for example purposes to show/hide the password fields if guestCheckout it set to true / false --->
									<script type="text/javascript">
										(function($){
											$(document).ready(function(){
												$('body').on('change', 'input[name="createAuthenticationFlag"]', function(e){
													if( $(this).val() == 0 ) {
														$('##password-details').hide();
													} else {
														$('##password-details').show();	
													}
												});
												$('input[name="createAuthenticationFlag"]:checked').change();
											});
										})( jQuery )
									</script>
									
									<!--- Password --->
									<div id="password-details" >
										<div class="control-group">
					    					<label class="control-label" for="rating">Password</label>
					    					<div class="controls">
					    						
												<sw:formField type="password" valueObject="#createAccountObj#" valueObjectProperty="password" class="span4" />
												<sw:errorDisplay object="#createAccountObj#" errorName="password" />
												
					    					</div>
					  					</div>
										
										<!--- Password Confirm --->
										<div class="control-group">
					    					<label class="control-label" for="rating">Confirm Password</label>
					    					<div class="controls">
					    						
												<sw:formField type="password" valueObject="#createAccountObj#" valueObjectProperty="passwordConfirm" class="span4" />
												<sw:errorDisplay object="#createAccountObj#" errorName="password" />
												
					    					</div>
					  					</div>
									</div>
									
									<!--- Create Button --->
									<div class="control-group">
				    					<div class="controls">
				      						<button type="submit" class="btn">Create Account</button>
				    					</div>
				  					</div>
									
								</form>
								<!--- End: Create Account Form --->
								
								
							</div>
							
						</div>
						<!--- END: ACCOUNT --->
							
					<cfelseif listFindNoCase(orderRequirementsList, "fulfillment")>
						
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
							
					<cfelseif listFindNoCase(orderRequirementsList, "payment")>
						
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