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
<cfparam name="rc.account" type="any" />
<cfparam name="rc.accountAuthenticationExists" type="boolean" />

<cfoutput>
	<div style="width:100%;">
		<cfif rc.accountAuthenticationExists>
			<div class="well tabable" style="width:400px;margin: 0px auto;">
				<ul class="">
					
				</ul>
				<ul>
					
				</ul>
					
				<h3>Login</h3>
				<br />
				<cf_SlatwallErrorDisplay object="#$.slatwall.getCurrentSession()#" />
				<form action="?s=1" class="form-horizontal" method="post">
					<input type="hidden" name="slatAction" value="admin:main.login" />
					<fieldset class="dl-horizontal">
						<div class="control-group">
							<label class="control-label" for="emailAddress">Email</label>
							<div class="controls">
								<input type="text" name="emailAddress" placeholder="Email">
							</div>
						</div>
						<div class="control-group">
							<label class="control-label" for="password">Password</label>
							<div class="controls">
								<input type="password" name="password" placeholder="Password">
							</div>
						</div>
						<button type="submit" class="btn btn-primary pull-right">Login</button>
					</fieldset>
				</form>
				<hr />
				<h3>Login with Mura Account</h3>
				<br />
				<form action="?s=1" class="form-horizontal">
					<input type="hidden" name="slatAction" value="mura:account.login" />
					<fieldset class="dl-horizontal">
						<div class="control-group">
							<label class="control-label" for="username">Username</label>
							<div class="controls">
								<input type="text" name="username" placeholder="Username">
							</div>
						</div>
						<div class="control-group">
							<label class="control-label" for="password">Password</label>
							<div class="controls">
								<input type="password" name="password" placeholder="Password">
							</div>
						</div>
						<button type="submit" class="btn pull-right">Login w/Mura</button>
					</fieldset>
				</form>
			</div>
		<cfelse>
			<div class="well" style="width:400px;margin: 0px auto;">
				<h3>Create Super Administrator Account</h3>
				<br />
				<form action="?s=1" class="form-horizontal" method="post">
					<input type="hidden" name="slatAction" value="admin:main.setupInitialAdmin" />
					
					<cfset processObject = rc.account.getProcessObject("setupInitialAdmin") />
							
					<fieldset class="dl-horizontal">
						<cf_HibachiPropertyDisplay object="#processObject#" property="firstName" edit="true" title="#$.slatwall.rbKey('entity.account.firstName')#" />
						<cf_HibachiPropertyDisplay object="#processObject#" property="lastName" edit="true" title="#$.slatwall.rbKey('entity.account.lastName')#" />
						<cf_HibachiPropertyDisplay object="#processObject#" property="company" edit="true" title="#$.slatwall.rbKey('entity.account.company')#" />
						<cf_HibachiPropertyDisplay object="#processObject#" fieldName="emailAddress" property="emailAddress" edit="true" title="#$.slatwall.rbKey('entity.account.emailAddress')#" />
						<cf_HibachiPropertyDisplay object="#processObject#" fieldName="emailAddressConfirm" property="emailAddressConfirm" edit="true" title="#$.slatwall.rbKey('entity.account.emailAddressConfirm')#" />
						<cf_HibachiPropertyDisplay object="#processObject#" property="password" edit="true" title="#$.slatwall.rbKey('entity.account.password')#" />
						<cf_HibachiPropertyDisplay object="#processObject#" property="passwordConfirm" edit="true" title="#$.slatwall.rbKey('entity.account.passwordConfirm')#" />
						<button type="submit" class="btn btn-primary pull-right">Create & Login</button>
					</fieldset>
				</form>
			</div>
		</cfif>
	</div>
</cfoutput>