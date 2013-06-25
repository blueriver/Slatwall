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
<cfparam name="rc.order" type="any" />
<cfparam name="rc.account" type="any" default="#rc.order.getAccount()#"/>
<cfparam name="rc.edit" type="boolean" />

<cfoutput>
	<cf_HibachiPropertyRow>
		
		<!--- Left Side --->
		<cf_HibachiPropertyList divClass="span4">
			
			<!--- Email Addresses --->
			<h5>#$.slatwall.rbKey('entity.accountEmailAddress_plural')#</h5>
			<cf_HibachiListingDisplay smartList="#rc.account.getAccountEmailAddressesSmartList()#">
				<cf_HibachiListingColumn tdclass="primary" propertyIdentifier="emailAddress" />
				<cf_HibachiListingColumn propertyIdentifier="accountEmailType.type" />
				<cf_HibachiListingColumn propertyIdentifier="verifiedFlag" />
			</cf_HibachiListingDisplay>
			
			<hr />
			<br />
			
			<!--- Phone Numbers --->
			<h5>#$.slatwall.rbKey('entity.accountPhoneNumber_plural')#</h5>
			<cf_HibachiListingDisplay smartList="#rc.account.getAccountPhoneNumbersSmartList()#">
				<cf_HibachiListingColumn tdclass="primary" propertyIdentifier="phoneNumber" />
				<cf_HibachiListingColumn propertyIdentifier="accountPhoneType.type" />
			</cf_HibachiListingDisplay>
			
			<hr />
			<br />
			
			<!--- Price Gruops --->
			<h5>#$.slatwall.rbKey('entity.priceGroup_plural')#</h5>
			<cf_HibachiListingDisplay smartList="#rc.account.getPriceGroupsSmartList()#">
				<cf_HibachiListingColumn tdclass="primary" propertyIdentifier="priceGroupName" />
			</cf_HibachiListingDisplay>
			
			<hr />
			<br />
			
			<!--- Term Account Info --->
			<h5>#$.slatwall.rbKey('admin.order.accountDetails.termAccountCreditDetails.info')#</h5>	
			<cf_HibachiPropertyDisplay object="#rc.account#" property="termAccountAvailableCredit" edit="false">
			<cf_HibachiPropertyDisplay object="#rc.account#" property="termAccountBalance" edit="false">
			
		</cf_HibachiPropertyList>
		
		<!--- Right Side --->
		<cf_HibachiPropertyList divClass="span8">
			
			<!--- Payment Methods --->
			<h5>#$.slatwall.rbKey('entity.accountPaymentMethod_plural')#</h5>
			<cf_HibachiListingDisplay smartList="#rc.account.getAccountPaymentMethodsSmartList()#"
								  recordDetailAction="admin:entity.detailaccountpaymentmethod"
								  recordDetailQueryString="accountID=#rc.account.getAccountID()#"
								  recordDetailModal=true>
								    
				<cf_HibachiListingColumn tdclass="primary" propertyIdentifier="accountPaymentMethodName" />
				<cf_HibachiListingColumn propertyIdentifier="paymentMethod.paymentMethodName" />
			</cf_HibachiListingDisplay>
			
			<hr />
			<br />
			
			<!--- Addresses --->
			<h5>#$.slatwall.rbKey('entity.accountAddress_plural')#</h5>
			<cf_HibachiListingDisplay smartList="#rc.account.getAccountAddressesSmartList()#">
				<cf_HibachiListingColumn tdclass="primary" propertyIdentifier="accountAddressName" />
				<cf_HibachiListingColumn propertyIdentifier="address.name" />
				<cf_HibachiListingColumn propertyIdentifier="address.streetAddress" />
				<cf_HibachiListingColumn propertyIdentifier="address.street2Address" />
				<cf_HibachiListingColumn propertyIdentifier="address.city" />
				<cf_HibachiListingColumn propertyIdentifier="address.stateCode" />
				<cf_HibachiListingColumn propertyIdentifier="address.postalCode" />
			</cf_HibachiListingDisplay>	
			
			<hr />
			<br />
			
			<!--- Comments --->
			<h5>#$.slatwall.rbKey('entity.comment_plural')#</h5>
			<cf_SlatwallAdminCommentsDisplay object="#rc.account#" adminComments="false" />
			
		</cf_HibachiPropertyList>
		
	</cf_HibachiPropertyRow>

</cfoutput>