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

<cfoutput>
	<div class="svofrontendcheckoutaccount">
		<h3 id="checkoutAccountTitle" class="titleBlock">Account <cfif $.slatwall.cart().hasValidAccount()><a href="?edit=account" class="editLink">Edit</a></cfif></h3>
		<div id="checkoutAccountContent" class="contentBlock">
			<cfif $.slatwall.cart().hasValidAccount() and rc.edit eq "" || rc.edit eq "account">
				<cfif rc.edit eq "account">
					<div class="accountEdit">
						<form name="accountEdit" method="post" action="?slatAction=frontend:checkout.updateAccount">
							<h4>Account Information</h4>
							<dl>
								<dt>First Name</dt>
								<dd><input type="text" name="firstName" value="#$.slatwall.cart().getAccount().getFirstName()#" /></dd>
								<dt>Last Name</dt>
								<dd><input type="text" name="lastName" value="#$.slatwall.cart().getAccount().getLastName()#" /></dd>
								<dt>Phone Number</dt>
								<dd><input type="text" name="phoneNumber" value="#$.slatwall.cart().getAccount().getPrimaryPhoneNumber()#" /></dd>
								<dt>Email</dt>
								<dd><input type="text" name="emailAddress" value="#$.slatwall.cart().getAccount().getPrimaryEmailAddress()#" /></dd>
								<cfif isNull($.slatwall.cart().getAccount().getMuraUserID())>
									<dt>Guest Checkout</dt>
									<dd>
										<input type="radio" name="createMuraAccount" value="1" />Save Account
										<input type="radio" name="createMuraAccount" value="0" checked="checked" />Checkout As Guest
									</dd>
									<div class="accountPassword" style="display:none;">
										<dt>Password</dt>
										<dd><input type="password" name="password" value="" /></dd>
										<dt>Confirm Password</dt>
										<dd><input type="password" name="passwordConfirm" value="" /></dd>
									</div>
								</cfif>
							</dl>
							<input type="hidden" name="accountID" value="#$.slatwall.cart().getAccount().getAccountID()#" />
							<cfif $.currentUser().isLoggedIn()><a href="?doaction=logout">logout</a></cfif>
							<button type="submit">Save & Continue</button>
						</form>
					</div>
				<cfelse>
					<div class="accountDetails">
						<dl class="accountInfo">
							<dt class="fullName">#$.slatwall.cart().getAccount().getFullName()#</dt>
							<dd class="primaryEmail">#$.slatwall.cart().getAccount().getPrimaryEmailAddress()#</dd>
						</dl>
					</div>
				</cfif>
			<cfelse>
				<div class="loginAccount">
					<form name="loginAccount" method="post" action="?nocache=1">
						<h4>Account Login</h4>
						<dl>
							<dt>E-Mail Address</dt>
							<dd><input type="text" name="username" value="" /></dd>
							<dt>Password</dt>
							<dd><input type="password" name="password" value="" /></dd>
						</dl>
						<input type="hidden" name="doaction" value="login" />
						<button type="submit">Login & Continue</button>
					</form>
				</div>
				<div class="newAccount">
					<form name="newAccount" method="post" action="?slatAction=frontend:checkout.saveNewOrderAccount">
						<h4>New Customer</h4>
						<dl>
							<dt>First Name</dt>
							<dd><input type="text" name="firstName" value="" /></dd>
							<dt>Last Name</dt>
							<dd><input type="text" name="lastName" value="" /></dd>
							<dt>Phone Number</dt>
							<dd><input type="text" name="phoneNumber" value="" /></dd>
							<dt>Email</dt>
							<dd><input type="text" name="emailAddress" value="" /></dd>
							<dt>Confirm Email</dt>
							<dd><input type="text" name="emailAddressConfirm" value="" /></dd>
							<dt>Guest Checkout</dt>
							<dd>
								<input type="radio" name="createMuraAccount" value="1" />Save Account
								<input type="radio" name="createMuraAccount" value="0" checked="checked" />Checkout As Guest
							</dd>
							<div class="accountPassword" style="display:none;">
								<dt>Password</dt>
								<dd><input type="password" name="password" value="" /></dd>
								<dt>Confirm Password</dt>
								<dd><input type="password" name="passwordConfirm" value="" /></dd>
							</div>
						</dl>
						<button type="submit">Continue</button>
					</form>
				</div>
			</cfif>
		</div>
	</div>
</cfoutput>