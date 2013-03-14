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
								
	Order Status Types			
	__________________			
	ostNotPlaced				
	ostNew						
	ostProcessing				
	ostOnHold					
	ostClosed					
	ostCanceled					
								
								
--->

<cfparam name="rc.edit" default="false" />
<cfparam name="rc.order" type="any" />

<cfoutput>
	<cf_HibachiEntityDetailForm object="#rc.order#" edit="#rc.edit#">
		<cf_HibachiEntityActionBar type="detail" object="#rc.order#" edit="#rc.edit#">
			<cf_HibachiProcessCaller action="admin:entity.preprocessorder" entity="#rc.order#" processContext="addPromotionCode" type="list" modal="true" />
			<!---
			<cf_HibachiProcessCaller action="admin:entity.processOrder" entity="#rc.order#" processContext="placeOrder" queryString="orderID=#rc.order.getOrderID()#&process=1&redirectAction=admin:entity.detailorder" type="list" />
			<cf_HibachiProcessCaller action="admin:entity.processOrder" entity="#rc.order#" processContext="placeOnHold" queryString="orderID=#rc.order.getOrderID()#" type="list" modal="true" />
			<cf_HibachiProcessCaller action="admin:entity.processOrder" entity="#rc.order#" processContext="takeOffHold" queryString="orderID=#rc.order.getOrderID()#" type="list" modal="true" />
			<cf_HibachiProcessCaller action="admin:entity.processOrder" entity="#rc.order#" processContext="cancelOrder" queryString="orderID=#rc.order.getOrderID()#" type="list" modal="true" />
			<cf_HibachiProcessCaller action="admin:entity.processOrder" entity="#rc.order#" processContext="closeOrder" queryString="orderID=#rc.order.getOrderID()#" type="list" modal="true" />
			<cf_HibachiProcessCaller action="admin:entity.processOrder" entity="#rc.order#" processContext="createReturn" queryString="orderID=#rc.order.getOrderID()#" type="list" />
			--->
		</cf_HibachiEntityActionBar>
		
		<cf_HibachiPropertyRow>
			<cf_HibachiPropertyList divclass="span4">
				
				<!--- Account --->
				<cfif rc.edit>
					<cf_HibachiPropertyDisplay object="#rc.order#" property="account" fieldtype="textautocomplete" autocompletePropertyIdentifiers="adminIcon,fullName,company,emailAddress,phoneNumber,address.simpleRepresentation" edit="true">
				<cfelseif !isNull(rc.order.getAccount())>
					<cf_HibachiPropertyDisplay object="#rc.order.getAccount()#" property="fullName" valuelink="?slatAction=admin:entity.detailaccount&accountID=#rc.order.getAccount().getAccountID()#">
					<cf_HibachiPropertyDisplay object="#rc.order.getAccount()#" property="emailAddress" valuelink="mailto:#rc.order.getAccount().getEmailAddress()#">
					<cf_HibachiPropertyDisplay object="#rc.order.getAccount()#" property="phoneNumber">
				</cfif>
				
				<!--- Origin --->
				<cf_HibachiPropertyDisplay object="#rc.order#" property="orderOrigin" edit="#rc.edit#">
				
				<cf_HibachiPropertyDisplay object="#rc.order#" property="orderStatusType">
				<cfif !isNull(rc.order.getReferencedOrder())>
					<cf_HibachiPropertyDisplay object="#rc.order#" property="referencedOrder" valuelink="?slatAction=admin:entity.detailorder&orderID=#rc.order.getReferencedOrder().getOrderID()#">
				</cfif>
				<cfif !isNull(rc.order.getOrderOpenDateTime())>
					<cf_HibachiPropertyDisplay object="#rc.order#" property="orderOpenDateTime">
				</cfif>
				<cfif !isNull(rc.order.getOrderCloseDateTime())>
					<cf_HibachiPropertyDisplay object="#rc.order#" property="orderCloseDateTime">
				</cfif>
			</cf_HibachiPropertyList>
			<cf_HibachiPropertyList divclass="span4">
					<cf_HibachiPropertyDisplay object="#rc.order#" property="paymentAmountTotal">
					<hr />
					<cf_HibachiPropertyDisplay object="#rc.order#" property="paymentAmountReceivedTotal">
					<cf_HibachiPropertyDisplay object="#rc.order#" property="paymentAmountCreditedTotal">
					<cfif arrayLen(rc.order.getReferencingOrders())>
						<hr />
						<cf_HibachiPropertyDisplay object="#rc.order#" property="referencingPaymentAmountCreditedTotal">
					</cfif>
			</cf_HibachiPropertyList>
			<cf_HibachiPropertyList divclass="span4">
					<cf_HibachiPropertyDisplay object="#rc.order#" property="subtotal">
					<cf_HibachiPropertyDisplay object="#rc.order#" property="taxtotal">
					<cf_HibachiPropertyDisplay object="#rc.order#" property="fulfillmenttotal">
					<cf_HibachiPropertyDisplay object="#rc.order#" property="discounttotal">
					<hr />
					<cf_HibachiPropertyDisplay object="#rc.order#" property="total">
			</cf_HibachiPropertyList>
		</cf_HibachiPropertyRow>
		
		<cf_HibachiTabGroup object="#rc.order#" allowComments="true" allowCustomAttributes="true">
			<cf_HibachiTab view="admin:entity/ordertabs/orderitems" count="#rc.order.getOrderItemsCount()#" />
			<cf_HibachiTab view="admin:entity/ordertabs/orderpayments" count="#rc.order.getOrderPaymentsCount()#" />
			<cfif rc.order.getOrderType().getSystemCode() eq "otSalesOrder" or rc.order.getOrderType().getSystemCode() eq "otExchangeOrder">
				<cf_HibachiTab view="admin:entity/ordertabs/orderfulfillments" count="#rc.order.getOrderFulfillmentsCount()#" />
				<cf_HibachiTab view="admin:entity/ordertabs/orderdeliveries" count="#rc.order.getOrderDeliveriesCount()#" />
			</cfif>
			<cfif rc.order.getOrderType().getSystemCode() eq "otReturnOrder" or rc.order.getOrderType().getSystemCode() eq "otExchangeOrder">
				<cf_HibachiTab view="admin:entity/ordertabs/orderreturns" count="#rc.order.getOrderReturnsCount()#" />
				<cf_HibachiTab view="admin:entity/ordertabs/stockreceivers" count="#rc.order.getStockReceiversCount()#" />
			</cfif>
			<cf_HibachiTab view="admin:entity/ordertabs/promotions" count="#rc.order.getPromotionCodesCount()#" />
			<cfif rc.order.getReferencingOrdersCount()>
				<cf_HibachiTab view="admin:entity/ordertabs/referencingOrders" count="#rc.order.getReferencingOrdersCount()#" />
			</cfif>
		</cf_HibachiTabGroup>
		
	</cf_HibachiEntityDetailForm>

</cfoutput>