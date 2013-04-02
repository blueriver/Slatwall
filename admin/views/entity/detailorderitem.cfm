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
<cfparam name="rc.orderItem" type="any" />
<cfparam name="rc.order" type="any" default="#rc.orderItem.getOrder()#" />
<cfparam name="rc.sku" type="any" default="#rc.orderItem.getSku()#" />
<cfparam name="rc.edit" default="false" />

<cfoutput>
	<cf_HibachiEntityDetailForm object="#rc.orderItem#" edit="#rc.edit#" >
		<cf_HibachiEntityActionBar type="detail" object="#rc.orderItem#" edit="#rc.edit#" backaction="admin:entity.detailorder" backquerystring="orderID=#rc.order.getOrderID()#">
			<cf_HibachiActionCaller action="admin:entity.createcomment" querystring="orderID=#rc.orderItem.getOrderItemID()#&redirectAction=#request.context.slatAction#" modal="true" type="list" />
		</cf_HibachiEntityActionBar>
		<cfif rc.edit>
			<!--- Hidden field to allow rc.order to be set on invalid submit --->
			<input type="hidden" name="orderID" value="#rc.order.getOrderID()#" />
			
			<!--- Hidden field to attach this to the order --->
			<input type="hidden" name="order.orderID" value="#rc.order.getOrderID()#" />
		</cfif>
		
		<cf_HibachiPropertyRow>
			
			<cf_HibachiPropertyList divclass="span6">
				<div class="well">
					#rc.sku.getImage(width=100, height=100)#
				</div>
				<hr />
				<cf_HibachiPropertyDisplay object="#rc.orderItem#" property="price" edit="#rc.edit#" />
				<cf_HibachiPropertyDisplay object="#rc.orderItem#" property="quantity" edit="#rc.edit#" />
			</cf_HibachiPropertyList>
			
			<cf_HibachiPropertyList divclass="span6">
				
				<!--- Totals --->
				<cf_HibachiPropertyTable>
					<cf_HibachiPropertyTableBreak header="Sku Details" />
					<cf_HibachiPropertyDisplay object="#rc.orderItem#" property="skuPrice" edit="false" displayType="table" />
					<cf_HibachiPropertyDisplay object="#rc.sku#" property="skuCode" edit="false" displayType="table">
					<cfloop array="#rc.sku.getAlternateSkuCodes()#" index="asc">
						<cf_HibachiPropertyDisplay object="#asc#" title="#asc.getAlternateSkuCodeType().getType()#" property="alternateSkuCode" edit="false" displayType="table">	
					</cfloop>
					<cfloop array="#rc.sku.getOptions()#" index="option">
						<cf_HibachiPropertyDisplay object="#option#" title="#option.getOptionGroup().getOptionGroupName()#" property="optionName" edit="false" displayType="table">
					</cfloop>
					<cf_HibachiPropertyTableBreak header="Status" />
					<cf_HibachiPropertyDisplay object="#rc.orderItem#" property="orderItemStatusType" edit="false" displayType="table" />
					<cfif rc.orderItem.getOrderItemType().getSystemCode() eq "oitSale">
						<cf_HibachiPropertyDisplay object="#rc.orderItem#" property="quantityDelivered" edit="false" displayType="table" />
						<cf_HibachiPropertyDisplay object="#rc.orderItem#" property="quantityUndelivered" edit="false" displayType="table" />
					<cfelse>
						<cf_HibachiPropertyDisplay object="#rc.orderItem#" property="quantityReceived" edit="false" displayType="table" />
						<cf_HibachiPropertyDisplay object="#rc.orderItem#" property="quantityUnreceived" edit="false" displayType="table" />
					</cfif>
					<cf_HibachiPropertyTableBreak header="Price Totals" />
					<cf_HibachiPropertyDisplay object="#rc.orderItem#" property="extendedPrice" edit="false" displayType="table" />
					<cf_HibachiPropertyDisplay object="#rc.orderItem#" property="taxAmount" edit="false" displayType="table" />
					<cf_HibachiPropertyDisplay object="#rc.orderItem#" property="discountAmount" edit="false" displayType="table" />
					<cf_HibachiPropertyTableBreak />
					<cf_HibachiPropertyDisplay object="#rc.orderItem#" property="extendedPriceAfterDiscount" edit="false" displayType="table" titleClass="table-total" valueClass="table-total" />	
					
				</cf_HibachiPropertyTable>
				
			</cf_HibachiPropertyList>
		</cf_HibachiPropertyRow>
		
		<!--- Tabs --->
		<cf_HibachiTabGroup object="#rc.orderItem#" allowComments="true" allowCustomAttributes="true">
			<cf_HibachiTab view="admin:entity/orderitemtabs/taxes" />
			<cf_HibachiTab view="admin:entity/orderitemtabs/promotions" />
			
			<cfif rc.orderItem.getOrderItemType().getSystemCode() eq "oitSale">
				<cf_HibachiTab view="admin:entity/orderitemtabs/deliveryitems" />
			<cfelse>
				<cf_HibachiTab view="admin:entity/orderitemtabs/stockReceiverItems" />
			</cfif>
			
			<!--- Custom Attributes --->
			<cfloop array="#rc.orderItem.getAssignedAttributeSetSmartList().getRecords()#" index="attributeSet">
				<cf_SlatwallAdminTabCustomAttributes object="#rc.orderItem#" attributeSet="#attributeSet#" />
			</cfloop>
			
			<!--- Comments --->
			<cf_SlatwallAdminTabComments object="#rc.orderItem#" />
		</cf_HibachiTabGroup>
		
	</cf_HibachiEntityDetailForm>
</cfoutput>