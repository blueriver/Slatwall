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

<cfoutput>

<cfset local.creditcardTransactions = local.orderPayment.getCreditCardTransactions() />
<table class="paymentDetails">
	<tr>
		<th>#$.Slatwall.rbKey("entity.orderPaymentCreditCard.creditCardType")#</th>
		<th>#$.Slatwall.rbKey("entity.orderPaymentCreditCard.creditCardLastFour")#</th>
		<th>#$.Slatwall.rbKey("entity.orderPaymentCreditCard.expirationDate")#</th>
		<th>#$.Slatwall.rbKey("entity.orderPaymentCreditCard.billingAddress")#</th>
		<th>#$.Slatwall.rbKey("entity.creditcardtransaction.authorizationcode")#</th>
		<th>#$.Slatwall.rbKey("entity.orderPaymentCreditCard.amountAuthorized")#</th>
		<th>#$.Slatwall.rbKey("entity.orderPaymentCreditCard.amountCharged")#</th>
	</tr>
	<tr>
		<td>#local.orderPayment.getCreditCardType()#</td>
		<td>#local.orderPayment.getCreditCardLastFour()#</td>
		<td>#local.orderPayment.getExpirationDate()#</td>
		<td><cfif !isNull(local.orderPayment.getBillingAddress())><cf_SlatwallAddressDisplay address="#local.orderPayment.getBillingAddress()#" edit="false" /></cfif></td>
		<td>
			<cfloop array = "#local.creditcardTransactions#" index="local.thistransaction">
				#local.thistransaction.getAuthorizationCode()#<br>
			</cfloop>
		</td>
		<td>#local.orderPayment.getAmountAuthorized()#</td>
		<td>#local.orderPayment.getAmountCharged()#</td>		
	</tr>
</table>

<!--- display link to charge card if full authorized amount hasn't been charged yet --->
<cfif local.orderPayment.getAmountAuthorized() gt local.orderpayment.getAmountCharged()>
	<cf_ActionCaller action="admin:order.chargeOrderPayment" querystring="orderPaymentID=#local.orderPayment.getOrderPaymentID()#" class="button">
</cfif>
	
</cfoutput>