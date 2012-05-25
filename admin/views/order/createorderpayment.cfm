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

<cfparam name="rc.orderPayment" type="any" />
<cfparam name="rc.order" type="any" />
<cfparam name="rc.paymentMethod" type="any" />
<cfparam name="rc.edit" type="boolean" default="tr" />

<cfoutput>
	<cf_SlatwallDetailForm object="#rc.orderPayment#" edit="#rc.edit#">
		
		<input type="hidden" name="order.orderID" value="#rc.order.getOrderID()#" />
		<input type="hidden" name="paymentMethod.paymentMethodID" value="#rc.paymentMethod.getPaymentMethodID()#" />
		
		<cf_SlatwallDetailHeader>
			<cfif rc.paymentMethod.getPaymentMethodType() eq "creditCard">
				<cf_SlatwallPropertyDisplay object="#rc.orderPayment#" property="nameOnCreditCard" edit="#rc.edit#" />
				<cf_SlatwallPropertyDisplay object="#rc.orderPayment#" property="creditCardNumber" edit="#rc.edit#" />
				<cf_SlatwallPropertyDisplay object="#rc.orderPayment#" property="expirationMonth" edit="#rc.edit#" />
				<cf_SlatwallPropertyDisplay object="#rc.orderPayment#" property="expirationYear" edit="#rc.edit#" />
				<cf_SlatwallPropertyDisplay object="#rc.orderPayment#" property="securityCode" edit="#rc.edit#" />
			</cfif>
			<cf_SlatwallPropertyDisplay object="#rc.orderPayment#" property="amount" edit="#rc.edit#" value="#rc.order.getTotal() - rc.order.getPaymentAmountTotal()#" />
		</cf_SlatwallDetailHeader>
	</cf_SlatwallDetailForm>
</cfoutput>