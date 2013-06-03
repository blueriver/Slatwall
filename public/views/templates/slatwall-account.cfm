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
<cfinclude template="_slatwall-header.cfm" />
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
					<cfloop array="#$.slatwall.account().getOrdersSmartList().getRecords()#" index="order">
						<li>#order.getOrderNumber()#</li>
					</cfloop>
				</div>
			</div>
			
			<!--- Subscription Management --->
			<a name="subscription-management"></a>
			<div class="row">
				<div class="span12">
					<h4>Subscription Management</h4>
				</div>
			</div>
			<br />
			<br />
			<br />
			<br />
			<br />
			<br />
			<br />
			<br />
			<br />
			<br />
			<br />
			<br />
			<br />
			<br />
			<br />
			<br />
			<br />
			<br />
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