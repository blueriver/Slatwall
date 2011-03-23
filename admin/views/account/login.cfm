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
<cfparam name="onError" default="" />
<cfparam name="SigninText" default="Account Sign-In" />
<cfparam name="GuestCheckoutOn" default=0 />
<cfparam name="NoLabels" default=0 />
<cfparam name="SmallButtons" default=0 />
		
<cfoutput>
	<div class="svoaccountlogin">
		<form action="?action=account.login" name="LoginUser" method="post">
			<input type="hidden" name="slatProcess" value="LoginUser" />
			<cfif arguments.onSuccess neq ""><input type="hidden" name="onSuccess" value="#arguments.onSuccess#" /></cfif>
			<cfif arguments.onError neq ""><input type="hidden" name="onError" value="#arguments.onError#" /></cfif>
			<h2>#Arguments.SigninText#</h2>
			<div class="Sign-In">
				<h3>Registed Users Sign-In:</h3>
				#application.slatwall.messageManager.dspMessage(FormName='LoginUser')#
				<cfif NoLabels>
					<input type="text" autocomplete="off" name="LoginUsername" onfocus="$(this).removeClass('BackgroundEmail');" required="email" message="You Must Enter A Valid E-Mail Address" class="BackgroundEmail"  />
					<input type="password" autocomplete="off" name="LoginPassword" onfocus="$(this).removeClass('BackgroundPassword');" required="true" message="Please Enter Your Password" class="BackgroundPassword"  />
				<cfelse>
					<label>E-Mail Address:</label>
					<input type="text" class="textbox" name="LoginUsername" required="true" message="You Must Enter A Valid E-Mail Address" />
					<label>Password:</label>
					<input type="password" class="textbox" required="true" message="Please Enter Your Password" name="LoginPassword"  />
				</cfif>
				<button class="slatButton <cfif SmallButtons>btnLoginSmall<cfelse>btnLogin</cfif>" type="submit">Login</button>
			</div>
		</form>
		<div class="New-Account">
			<cfif arguments.GuestCheckoutOn>
				<form action="" method="post">
					<cfif arguments.onSuccess neq ""><input type="hidden" name="onSuccess" value="#arguments.onSuccess#" /></cfif>
					<cfif arguments.onError neq ""><input type="hidden" name="onError" value="#arguments.onError#" /></cfif>
					<h3>No Account? Use Guest Checkout</h3>
					<p class="CreateLater">Proceed to checkout, and you will have a chance to create an Nytro ID at the end.</p>
					<input type="hidden" name="slatProcess" value="GuestCheckout" />
					<button class="slatButton <cfif SmallButtons>btnGuestCheckoutSmall<cfelse>btnGuestCheckout</cfif>" type="submit">Guest Checkout</button>
				</form>
			<cfelse>
				<h3>Not Registered Yet?</h3>
				<p class="CreateAccount">Register now to use all our convenient site features and check out quickly.</p>
				<button class="slatButton <cfif SmallButtons>btnCreateAccountSmall<cfelse>btnCreateAccount</cfif>" onClick="window.location='/index.cfm/create-account/'">Create Account</button>
			</cfif>
		</div>
	</div>
</cfoutput>
