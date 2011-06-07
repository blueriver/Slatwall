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
<cfparam name="rc.account" type="any" />

<cfoutput>
	<div class="svofrontendcheckoutaccount">
		<h3 id="checkoutAccountTitle" class="titleBlock">Account <cfif not listFind(rc.orderRequirementsList, 'account')><a href="?edit=account" class="editLink">Edit</a></cfif></h3>
		<cfif rc.edit eq "" || rc.edit eq "account">
			<div id="checkoutAccountContent" class="contentBlock">
				<cfif listFind(rc.orderRequirementsList, 'account') || rc.edit eq "account">
					<cfif listFind(rc.orderRequirementsList, 'account')>
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
					</cfif>
					<div class="accountDetails">
						<form name="account" method="post" action="?slatAction=frontend:checkout.saveaccount">
							<input type="hidden" name="accountID" value="#rc.account.getAccountID()#" />
							<cfif rc.edit eq "account"><h4>Edit Account Details</h4><cfelse><h4>New Customer</h4></cfif>
							<dl>
								<cf_PropertyDisplay object="#rc.account#" property="firstName" edit="true">
								<cf_PropertyDisplay object="#rc.account#" property="lastName" edit="true">
								<cf_PropertyDisplay object="#rc.account#" property="company" edit="true">
								<cfif isNull(rc.account.getPrimaryEmailAddress()) >
									<dt class="spdemailaddress"><label for="emailAddress">#$.slatwall.rbKey('entity.accountEmailAddress.emailAddress')#</label></dt>
									<dd id="spdemailaddress"><input type="text" name="emailAddress" value="" /></dd>
									<dt class="spdemailaddress"><label for="emailAddressConfirm">#$.slatwall.rbKey('entity.accountEmailAddress.emailAddressConfirm')#</label></dt>
									<dd id="spdemailaddress"><input type="text" name="emailAddressConfirm" value="" /></dd>
								</cfif>
								<cfif rc.account.isGuestAccount()>
									<dt class="guestcheckout"><label for="createMuraAccount">#$.slatwall.rbKey('frontend.checkout.detail.guestcheckout')#</label></dt>
									<dd id="guestcheckout">
										<input type="radio" name="createMuraAccount" value="1" checked="checked" />#$.slatwall.rbKey('frontend.checkout.detail.saveAccount')#<br />
										<input type="radio" name="createMuraAccount" value="0" />#$.slatwall.rbKey('frontend.checkout.detail.checkoutAsGuest')#
									</dd>
									<div class="accountPassword">
										<dt>Password</dt>
										<dd><input type="password" name="password" value="" /></dd>
										<dt>Confirm Password</dt>
										<dd><input type="password" name="passwordConfirm" value="" /></dd>
									</div>
								<cfelse>
									<a href="?doaction=logout">Logout</a>
								</cfif>
							</dl>
							<cf_ActionCaller action="frontend:checkout.saveaccount" type="submit">
						</form>
					</div>
				<cfelseif not listFind(rc.orderRequirementsList, 'account')>
					<div class="accountDetails">
						<dl class="accountInfo">
							<dt class="fullName">#rc.account.getFullName()#</dt>
							<dd class="primaryEmail">#rc.account.getPrimaryEmailAddress().getEmailAddress()#</dd>
						</dl>
					</div>
				</cfif>
			</div>
		</cfif>
	</div>
</cfoutput>