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
<cfparam name="rc.processObject" type="any" />
<cfparam name="rc.edit" type="boolean" />

<cf_HibachiEntityProcessForm entity="#rc.account#" edit="#rc.edit#">
	
	<cf_HibachiEntityActionBar type="preprocess" object="#rc.account#">
	</cf_HibachiEntityActionBar>
	
	<cf_HibachiPropertyList>
		<cf_HibachiPropertyDisplay object="#rc.processObject#" property="firstName" title="#$.slatwall.rbKey('entity.account.firstName')#" edit="#rc.edit#">
		<cf_HibachiPropertyDisplay object="#rc.processObject#" property="lastName" title="#$.slatwall.rbKey('entity.account.lastName')#" edit="#rc.edit#">
		<cf_HibachiPropertyDisplay object="#rc.processObject#" property="emailAddress" edit="#rc.edit#">
		<cf_HibachiPropertyDisplay object="#rc.processObject#" property="emailAddressConfirm" edit="#rc.edit#">
		<cf_HibachiPropertyDisplay object="#rc.processObject#" property="createAuthentication" edit="#rc.edit#" fieldType="yesno">
		<cf_HibachiDisplayToggle selector="input[name=createAuthentication]">
			<cf_HibachiPropertyDisplay object="#rc.processObject#" property="password" edit="#rc.edit#">
			<cf_HibachiPropertyDisplay object="#rc.processObject#" property="passwordConfirm" edit="#rc.edit#">
		</cf_HibachiDisplayToggle>
	</cf_HibachiPropertyList>
	
	<!---
	<cf_HibachiEntityActionBar type="detail" object="#rc.account#" edit="#rc.edit#">
		<cf_HibachiActionCaller action="admin:entity.createaccountaddress" queryString="accountID=#rc.account.getAccountID()#" type="list" modal=true />
	</cf_HibachiEntityActionBar>
	
	<cfif rc.account.isNew()>
		<cf_HibachiDetailHeader>
			<cf_HibachiPropertyList>
				<cf_HibachiPropertyDisplay object="#rc.account#" property="firstName" edit="#rc.edit#">
				<cf_HibachiPropertyDisplay object="#rc.account#" property="lastName" edit="#rc.edit#">
				<cf_HibachiPropertyDisplay object="#rc.account#" property="company" edit="#rc.edit#">
				<cf_HibachiPropertyDisplay object="#rc.account#" property="emailAddress" fieldnameprefix="primaryEmailAddress." edit="#rc.edit#">
				<cf_HibachiPropertyDisplay object="#rc.account#" property="phoneNumber" fieldnameprefix="primaryPhoneNumber." edit="#rc.edit#">
				<input type="hidden" name="primaryAddress.accountAddressName" value="Primary Address" />
				<cf_SlatwallAddressDisplay address="#rc.account.getPrimaryAddress().getAddress()#" showName="false" showCompany="false" fieldnameprefix="primaryAddress.address." />
			</cf_HibachiPropertyList>
		</cf_HibachiDetailHeader>
	<cfelse>
		<cf_HibachiDetailHeader>
			<cf_HibachiPropertyList divclass="span6">
				<cf_HibachiPropertyDisplay object="#rc.account#" property="firstName" edit="#rc.edit#">
				<cf_HibachiPropertyDisplay object="#rc.account#" property="lastName" edit="#rc.edit#">
				<cf_HibachiPropertyDisplay object="#rc.account#" property="company" edit="#rc.edit#">
				<cf_HibachiPropertyDisplay object="#rc.account#" property="emailAddress" edit="#rc.edit#">
				<cf_HibachiPropertyDisplay object="#rc.account#" property="password" edit="#rc.edit#">			
			</cf_HibachiPropertyList>
			<cf_HibachiPropertyList divclass="span6">
				<cf_HibachiPropertyDisplay object="#rc.account#" property="termAccountAvailableCredit" edit="false">
				<cf_HibachiPropertyDisplay object="#rc.account#" property="termAccountBalance" edit="false">
			</cf_HibachiPropertyList>
		</cf_HibachiDetailHeader>
	</cfif>
	--->
</cf_HibachiEntityProcessForm>
