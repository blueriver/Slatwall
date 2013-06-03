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

<!--- This header include should be changed to the header of your site.  Make sure that you review the header to include necessary JS elements for slatwall templates to work --->
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

<cfoutput>
	<div class="container">
		<!--- Make sure that the user is logged in --->
		<cfif $.slatwall.getLoggedInFlag()>
			
			<div class="row">
				<div class="span12">
					<h2>My Account</h2>
					<ul>
						<li><a href="##profile">Profile</a></li>
						<li><a href="##order-history">Order History</a></li>
						<li><a href="##subscription-management">Subscription Management</a></li>
						<li><a href="?slatAction=public:account.logout">Logout</a></li>
					</ul>
				</div>
			</div>
			
			<!--- Profile --->
			<a name="profile"></a>
			<div class="row">
				<div class="span12">
					<h4>Profile</h4>
					
				</div>
			</div>
			
			<!--- Order History --->
			<a name="order-history"></a>
			<div class="row">
				<div class="span12">
					<h4>Order History</h4>
					
					<!--- Setup an accordian view for existing orders --->
					<div class="accordion" id="order-history-acc">
						
						<!--- Loop over all of the orders that this account has placed --->
						<cfloop array="#$.slatwall.account().getOrdersPlacedSmartList().getRecords()#" index="order">
					  	
						  	<!--- create a DOM ID to be used for open and closing --->
						  	<cfset orderDOMID = "oid#order.getOrderID()#" />
							
							<div class="accordion-group">
								
								<!--- This is the top accordian header row --->
								<div class="accordion-heading">
									<a class="accordion-toggle" data-toggle="collapse" data-parent="##order-history-acc" href="###orderDOMID#">Order ## #order.getOrderNumber()# &nbsp;&nbsp;&nbsp; | &nbsp;&nbsp;&nbsp; #$.slatwall.formatValue( order.getOrderOpenDateTime(), 'date' )# &nbsp;&nbsp;&nbsp; | &nbsp;&nbsp;&nbsp; #order.getFormattedValue('total')# <span class="pull-right">#order.getOrderStatusType().getType()#</span></a>
								</div>
								
								<!--- This is the accordian details when expanded --->
								<div id="#orderDOMID#" class="accordion-body collapse">
									
									<div class="accordion-inner">
											
										<!--- Overview & Status --->
										<h5>Overview & Status</h5>
										<div class="row">
											
											<div class="span4">
												<table class="table table-bordered table-condensed">
													<tr>
														<td>Order Status</td>
														<td>#order.getOrderStatusType().getType()#</td>
													</tr>
													<tr>
														<td>Order ##</td>
														<td>#order.getOrderNumber()#</td>
													</tr>
													<tr>
														<td>Order Placed</td>
														<td>#order.getFormattedValue('orderOpenDateTime')#</td>
													</tr>
												</table>
											</div>
											<div class="span3">
												<div class="btn-group">
												    <a class="btn btn-large" href="##"><i class="icon-phone"></i></a>
												    <a class="btn btn-large" href="##"><i class="icon-envelope"></i></a>
												    <a class="btn btn-large" href="##"><i class="icon-print"></i></a>
												</div>
												<br />
												<br />
												<p>
													If you have questions about your order, please contact customer service <a href="tel:888.555.5555">888.555.5555</a>
												</p>
											</div>
											<div class="span4 pull-right">
												<table class="table table-bordered table-condensed">
													<tr>
														<td>Subtotal</td>
														<td>#order.getFormattedValue('subTotalAfterItemDiscounts')#</td>
													</tr>
													<tr>
														<td>Delivery Charges</td>
														<td>#order.getFormattedValue('fulfillmentChargeAfterDiscountTotal')#</td>
													</tr>
													<tr>
														<td>Taxes</td>
														<td>#order.getFormattedValue('taxTotal')#</td>
													</tr>
													<tr>
														<td><strong>Total</strong></td>
														<td><strong>#order.getFormattedValue('total')#</strong></td>
													</tr>
													<cfif order.getDiscountTotal() gt 0>
														<tr>
															<td colspan="2" class="text-error">You saved #order.getFormattedValue('discountTotal')# on this order.</td>
														</tr>
													</cfif>
												</table>
											</div>
										</div>
										
										<!--- Start: Order Details --->
										<hr />
										<h5>Order Details</h5>
										<cfloop array="#order.getOrderFulfillments()#" index="orderFulfillment">
											
											<!--- Start: Fulfillment Table --->
											<table class="table table-bordered table-condensed">
												<tr>
													<!--- Fulfillment Details --->
													<td class="well span3" rowspan="#arrayLen(orderFulfillment.getOrderFulfillmentItems()) + 1#">
														
														<!--- Fulfillment Name --->
														<strong>#orderFulfillment.getFulfillmentMethod().getFulfillmentMethodName()#</strong><br />
														
														<!--- Fulfillment Details: Email --->
														<cfif orderFulfillment.getFulfillmentMethod().getFulfillmentMethodType() eq "email">
															<strong>Email Address:</strong> #orderFulfillment.getEmailAddress()#<br />
															
														<!--- Fulfillment Details: Pickup --->
														<cfelseif orderFulfillment.getFulfillmentMethod().getFulfillmentMethodType() eq "pickup">
															<strong>Pickup Location:</strong> #orderFulfillment.getPickupLocation().getLocationName()#<br />
															<sw:addressDisplay address="#orderFulfillment.getPickupLocation().getPrimaryAddress().getAddress()#" />
															
														<!--- Fulfillment Details: Shipping --->
														<cfelseif orderFulfillment.getFulfillmentMethod().getFulfillmentMethodType() eq "shipping">
															<sw:addressDisplay address="#orderFulfillment.getShippingAddress()#" />
															<strong>Shipping Method:</strong> #orderFulfillment.getShippingMethod().getShippingMethodName()#<br />
															
														</cfif>
														
														<br />
														<!--- Delivery Fee --->
														<strong>Delivery Fee:</strong> #orderFulfillment.getFormattedValue('chargeAfterDiscount')#
													</td>
													
													<!--- Additional Header Rows --->
													<th>Sku Code</th>
													<th>Product Title</th>
													<th>Qty.</th>
													<th>Price</th>
													<th>Status</th>
												</tr>
												
												<!--- Loop over the actual items in this orderFulfillment --->
												<cfloop array="#orderFulfillment.getOrderFulfillmentItems()#" index="orderItem">
													
													<tr>
														<!--- Sku Code --->
														<td>#orderItem.getSku().getSkuCode()#</td>
														
														<!--- Product Title --->
														<td>#orderItem.getSku().getProduct().getTitle()#</td>
														
														<!--- Quantity --->
														<td>#orderItem.getQuantity()#</td>
														
														<!--- Price --->
														<td>
															<cfif orderItem.getExtendedPrice() gt orderItem.getExtendedPriceAfterDiscount()>
																<span style="text-decoration:line-through;">#orderItem.getFormattedValue('extendedPrice')#</span> <span class="text-error">#orderItem.getFormattedValue('extendedPriceAfterDiscount')#</span><br />
															<cfelse>
																#orderItem.getFormattedValue('extendedPriceAfterDiscount')#	
															</cfif>
														</td>
														
														<!--- Status --->
														<td>#orderItem.getOrderItemStatusType().getType()#</td>
													</tr>
												</cfloop>
												
											</table>
											<!--- End: Fulfillment Table --->
												
										</cfloop>
										<!--- End: Order Details --->
										
										<!--- Start: Order Payments --->
										<hr />
										<h5>Order Payments</h5>
										<table class="table table-bordered table-condensed">
											<tr>
												<th>Payment Details</td>
												<th>Amount</td>
											</tr>
											<cfloop array="#order.getOrderPayments()#" index="orderPayment">
												<tr>
													<td>#orderPayment.getSimpleRepresentation()#</td>
													<td>#orderPayment.getAmount()#</td>
												</tr>
											</cfloop>
										</table>
										<!--- End: Order Payments --->
											
										<!--- Start: Order Deliveries --->
										<cfif arrayLen(order.getOrderDeliveries())>
											<hr />
											<h5>Order Deliveries</h5>
											
											<cfloop array="#order.getOrderDeliveries()#" index="orderDelivery">
												<table class="table table-bordered table-condensed">
													<tr>
														<!--- Delivery Details --->
														<td class="well span3" rowspan="#arrayLen(orderFulfillment.getOrderDeliveryItems()) + 1#">
															<!---
															<!--- Fulfillment Name --->
															<strong>#orderFulfillment.getFulfillmentMethod().getFulfillmentMethodName()#</strong><br />
															
															<!--- Fulfillment Details: Email --->
															<cfif orderFulfillment.getFulfillmentMethod().getFulfillmentMethodType() eq "email">
																<strong>Email Address:</strong> #orderFulfillment.getEmailAddress()#<br />
																
															<!--- Fulfillment Details: Pickup --->
															<cfelseif orderFulfillment.getFulfillmentMethod().getFulfillmentMethodType() eq "pickup">
																<strong>Pickup Location:</strong> #orderFulfillment.getPickupLocation().getLocationName()#<br />
																<sw:addressDisplay address="#orderFulfillment.getPickupLocation().getPrimaryAddress().getAddress()#" />
																
															<!--- Fulfillment Details: Shipping --->
															<cfelseif orderFulfillment.getFulfillmentMethod().getFulfillmentMethodType() eq "shipping">
																<sw:addressDisplay address="#orderFulfillment.getShippingAddress()#" />
																<strong>Shipping Method:</strong> #orderFulfillment.getShippingMethod().getShippingMethodName()#<br />
																
															</cfif>
															
															<br />
															
															<!--- Amount Captured --->
															<strong>Delivery Fee:</strong> #orderFulfillment.getFormattedValue('chargeAfterDiscount')#
															--->
														</td>
														
														<!--- Additional Header Rows --->
														<th>Sku Code</th>
														<th>Product Title</th>
														<th>Qty.</th>
													</tr>
													<cfloop array="#orderDelivery.getOrderDeliveryItems()#" index="orderDeliveryItem">
														<tr>
															<td>#orderDeliveryItem.getOrderItem().getSku().getSkuCode()#</td>
															<td>#orderDeliveryItem.getOrderItem().getSku().getProduct().getTitle()#</td>
															<td>#orderDeliveryItem.getQuantity()#</td>
														</tr>
													</cfloop>
												</table>
											</cfloop>
											
										</cfif>
										<!--- End: Order Deliveries --->
											
									</div> <!--- END: accordion-inner --->
									
								</div> <!--- END: accordion-body --->
								
							</div> <!--- END: accordion-group --->
								
						</cfloop>
						
					</div>
				</div>
			</div>
			
			<!--- Unplaced Carts --->
			<a name="order-history"></a>
			<div class="row">
				<div class="span12">
					<h4>Unplaced Carts</h4>
					<div class="accordion" id="order-history-acc">
  						<cfloop array="#$.slatwall.account().getOrdersNotPlacedSmartList().getRecords()#" index="order">
						  	<cfset orderDOMID = "oid#order.getOrderID()#" />
							  
							<div class="accordion-group">
								<div class="accordion-heading">
									<a class="accordion-toggle" data-toggle="collapse" data-parent="##order-history-acc" href="###orderDOMID#">#order.getSimpleRepresentation()#</a>
	    						</div>
								<div id="#orderDOMID#" class="accordion-body collapse">
									<div class="accordion-inner">
										
									</div>
								</div>
							</div>
						</cfloop>
 					</div>
				</div>
			</div>
			
			<!--- Subscription Management --->
			<a name="subscription-management"></a>
			<div class="row">
				<div class="span12">
					<h4>Subscription Management</h4>
				</div>
			</div>
		<!--- Otherwise display the create / login form --->
		<cfelse>
			<div class="row">
								
				<!--- LOGIN --->
				<div class="span4">
					
					<h5>Login with Existing Account</h5>
					
					<!--- Sets up the account login processObject --->
					<cfset accountLoginObj = $.slatwall.getAccount().getProcessObject('login') />
					
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
	      						<button type="submit" class="btn btn-primary">Login & Continue</button>
	    					</div>
	  					</div>
						
					</form>
					<!--- End: Login Form --->
						
					<hr />
					
					<h5>Forgot Password</h5>
					
					<!--- Sets up the account login processObject --->
					<cfset forgotPasswordObj = $.slatwall.getAccount().getProcessObject('forgotPassword') />
					
					<!--- Start: Forgot Password Form --->
					<form action="?s=1" method="post">
						
						<!--- This hidden input is what tells slatwall to try and login the account --->
						<input type="hidden" name="slatAction" value="public:account.forgotPassword" />
						
						<!--- Email Address --->
						<div class="control-group">
	    					<label class="control-label" for="rating">Email Address</label>
	    					<div class="controls">
	    						
								<sw:formField type="text" valueObject="#accountLoginObj#" valueObjectProperty="emailAddress" class="span4" />
								<sw:errorDisplay object="#forgotPasswordObj#" errorName="emailAddress" />
								
	    					</div>
	  					</div>
						
						<!--- Reset Email Button --->
						<div class="control-group">
	    					<div class="controls">
	      						<button type="submit" class="btn">Send Me Reset Email</button>
	    					</div>
	  					</div>
						
					</form>
					<!--- End: Forgot Password Form --->
					
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
						<div class="control-group pull-right">
	    					<div class="controls">
	      						<button type="submit" class="btn btn-primary">Create Account & Continue</button>
	    					</div>
	  					</div>
						
					</form>
					<!--- End: Create Account Form --->
					
					
				</div>
				
			</div>
		</cfif>
	</div>
</cfoutput>
<cfinclude template="_slatwall-footer.cfm" />