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
<cfparam name="rc.accountAuthenticationExists" type="boolean" />
		
<cfoutput>
	<div style="width:100%;">
		<cfif rc.accountAuthenticationExists>
			<div class="well tabable" style="width:400px;margin: 0px auto;">
				<h3>Login</h3>
				<br />
				<cfset authorizeProcessObject = rc.fw.getHibachiScope().getSession().getProcessObject("AuthorizeAccount") />
				<form action="?s=1" class="form-horizontal" method="post">
					<input type="hidden" name="#rc.fw.getAction()#" value="admin:main.authorizelogin" />
					<fieldset class="dl-horizontal">
						<fieldset class="dl-horizontal">
							<cf_HibachiPropertyDisplay object="#authorizeProcessObject#" property="emailAddress" edit="true" title="#rc.fw.getHibachiScope().rbKey('entity.account.emailAddress')#" />
							<cf_HibachiPropertyDisplay object="#authorizeProcessObject#" property="password" edit="true" title="#rc.fw.getHibachiScope().rbKey('entity.account.password')#" />
						</fieldset>
						<button type="submit" class="btn btn-primary pull-right">Login</button>
					</fieldset>
				</form>
			</div>
		<cfelse>
			<div class="well" style="width:400px;margin: 0px auto;">
				<h3>Create Super Administrator Account</h3>
				<br />
				<form action="?s=1" class="form-horizontal" method="post">
					<input type="hidden" name="#rc.fw.getAction()#" value="admin:main.setupinitialadmin" />
					
					<cfset processObject = rc.fw.getHibachiScope().getAccount().getProcessObject("setupInitialAdmin") />
							
					<fieldset class="dl-horizontal">
						<cf_HibachiPropertyDisplay object="#processObject#" property="firstName" edit="true" title="#rc.fw.getHibachiScope().rbKey('entity.account.firstName')#" />
						<cf_HibachiPropertyDisplay object="#processObject#" property="lastName" edit="true" title="#rc.fw.getHibachiScope().rbKey('entity.account.lastName')#" />
						<cf_HibachiPropertyDisplay object="#processObject#" property="company" edit="true" title="#rc.fw.getHibachiScope().rbKey('entity.account.company')#" />
						<cf_HibachiPropertyDisplay object="#processObject#" property="emailAddress" edit="true" />
						<cf_HibachiPropertyDisplay object="#processObject#" property="emailAddressConfirm" edit="true" />
						<cf_HibachiPropertyDisplay object="#processObject#" property="password" edit="true" />
						<cf_HibachiPropertyDisplay object="#processObject#" property="passwordConfirm" edit="true" />
						<button type="submit" class="btn btn-primary pull-right">Create & Login</button>
					</fieldset>
				</form>
			</div>
		</cfif>
	</div>
</cfoutput>