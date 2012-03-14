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

<cfparam name="rc.vendorOrder">
<cfparam name="rc.locationSmartList">

<cfoutput>
	<input type="hidden" name="vendorOrderId" value="#rc.vendorOrder.getVendorOrderId()#">
	
	<table class="listing-grid stripe">
		<!--- Two levels of table titles --->
		<tr>
			<th class="varWidth">#$.Slatwall.rbKey("admin.stockReceiver.detail.sku")#</th>
			<cfloop array="#rc.locationSmartList.getPageRecords()#" index="local.location">
				<th colspan="3">#local.location["name"]#</th>
			</cfloop>
			<th>#$.Slatwall.rbKey("admin.stockReceiver.detail.receiving")#</th>
			<th colspan="2">#$.Slatwall.rbKey("admin.stockReceiver.detail.dueInAfter")#</th>
		</tr>
		<tr>
			<th class="varWidth"></th>
			<cfloop array="#rc.locationSmartList.getPageRecords()#" index="local.location">
				<th data-locationid="#local.location["value"]#">#$.Slatwall.rbKey("admin.stockReceiver.detail.quantityOrdered")#</th>
				<th data-locationid="#local.location["value"]#">#$.Slatwall.rbKey("admin.stockReceiver.detail.quantityReceived")#</th>
				<th data-locationid="#local.location["value"]#">#$.Slatwall.rbKey("admin.stockReceiver.detail.quantityDueIn")#</th>
			</cfloop>
			<th class="receivingInLocationTitle"></th>
			<th class="dueInAfterLocationTitle"></th>
			<th>#$.Slatwall.rbKey("admin.stockReceiver.detail.allLocations")#</th>
		</tr>
		
		<tbody>
			<!---<cfloop from="1" to="#ArrayLen(rc.vendorOrderItemSmartList.getPageRecords())#" index="local.i">--->
			<cfloop array="#rc.vendorOrder.getSkusOrdered()#" index="local.sku">
				<!---<cfset local.vendorOrderItem = rc.vendorOrderItemSmartList.getPageRecords()[local.i]>
				<cfset local.stock = local.vendorOrderItem.getStock()>
				<cfset local.product = local.stock.getSku().getProduct()>--->
				<tr data-skuid="#local.sku.getSkuID()#">
					<td class="varWidth">#local.sku.getSkuCode()#</td>
					
					<cfloop array="#rc.locationSmartList.getPageRecords()#" index="local.location">
						<!--- Quantity Ordered --->
						<cfset local.qtyOrdered = rc.VendorOrder.getQuantityOfStockAlreadyOnOrder(local.sku.getSkuID(), local.location["value"])>
						<td data-locationid="#local.location["value"]#">#local.qtyOrdered#</td>
						
						<!--- Quantity received --->
						<cfset local.qtyReceived = rc.VendorOrder.getQuantityOfStockAlreadyReceived(local.sku.getSkuID(), local.location["value"])>
						<td data-locationid="#local.location["value"]#">#local.qtyReceived#</td>
						
						<!--- Quantity Due in --->
						<td class="dueInQuantity" data-locationid="#local.location["value"]#">#local.qtyOrdered - local.qtyReceived#</td>
					</cfloop>

					<td>
						<cfif rc.edit>
							<input type="text" class="receivingQuantityInput" name="quantity_skuid(#local.sku.getSkuID()#)">
						<cfelse>
							?
						</cfif>
					</td>
							
							
					<td class="dueInAfterCount" data-skuid="#local.sku.getSkuID()#"></td>
					<td class="dueInAfterAllLocationsCount" data-skuid="#local.sku.getSkuID()#"></td>
					
					<!---
					<td>
						<cfif rc.edit>
							<input type="text" name="cost_stockid(#local.stock.getStockID()#)" value="#local.vendorOrderItem.getCost()#">
						<cfelse>
							#local.vendorOrderItem.getCost()#
						</cfif>
					</td>
					<td>#local.vendorOrderItem.getQuantityIn()#</td>
					<td>#rc.vendorOrder.getQuantityOfStockAlreadyOnOrder(rc.vendorOrder.getVendorOrderId(), local.stock.getStockId())#</td>
					<td>#local.stock.getLocation().getLocationName()#</td>
					<td><input type="text"  name="quantity_stockid(#local.stock.getStockID()#)" value=""></td>--->
				</tr>
			</cfloop>
		</tbody>
	</table>

</cfoutput>