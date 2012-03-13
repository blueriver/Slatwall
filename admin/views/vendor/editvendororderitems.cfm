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
<cfparam name="rc.product">
<cfparam name="rc.vendorOrder">
<cfparam name="rc.locationSmartList">
<cfparam name="rc.inDialog" default="false">

<cfif rc.inDialog EQ "true">
	<cfset request.layout = false>
</cfif>

<cfoutput>
	<!--- This is referenced inside of admin/vendor_order/detail.js to format currency. --->
	<script language="JavaScript">
		currentMask="#rc.VendorOrder.formatValue(0, 'currency')#";
	</script>
	
	<cfif rc.inDialog EQ "true">
		<h3>#Replace($.Slatwall.rbKey("admin.vendorOrder.vendorOrderItemsDialogTitle"), "{1}", rc.product.getProductName())#</h3>
	</cfif>
	
	<form name="editVendorOrderProductAssignment" id="editVendorOrderProductAssignment" action="#buildURL('admin:vendorOrder.saveVendorOrderItems')#" method="post">
		<input type="hidden" name="VendorOrderID" value="#rc.vendorOrder.getVendorOrderID()#" />
		
		<table class="listing-grid stripepopup">
			<tr>
				<th class="varWidth">Sku</th>
				<th>Cost</th>
				
				<cfloop array="#rc.locationSmartList.getRecords()#" index="local.location">
					<th>Qty for: #local.location.getLocationName()#</th>
				</cfloop>
				
				<th>Total</th>
			</tr>
			
			<tbody>
				<cfloop array="#rc.product.getSkus()#" index="local.sku">
					<!--- See if we already have a vendor order item that matches this SKU and VendorOrder. --->
					
					<tr>
						<td class="varWidth">#local.sku.getSkuCode()#</td>
						<td><input type="text" class="skucost" data-skuid="#local.sku.getSkuID()#" name="cost_skuid(#local.sku.getSkuID()#)" value="#rc.VendorOrder.getVendorOrderItemCostForSku(local.sku.getSkuID())#"></td>
						
						<cfloop array="#rc.locationSmartList.getRecords()#" index="local.location">
							<!--- This method first finds the Stock with the provided sku and location, then searches in the VendorOrder's Items list for an item with that stock. ---> 
							<cfset local.VendorOrderItem = rc.VendorOrder.getVendorOrderItemForSkuAndLocation(local.sku.getSkuId(), local.location.getLocationId())>
							<input type="hidden">
							<td><input type="text" class="skulocationqty" data-skuid="#local.sku.getSkuID()#" data-locationid="#local.location.getLocationID()#" name="qty_skuid(#local.sku.getSkuID()#)_locationid(#local.location.getLocationId()#)" value="#local.VendorOrderItem.getQuantity()#"></td>
						</cfloop>
						
						<td class="skutotal" data-skuid="#local.sku.getSkuID()#"></td>
					</tr>
				</cfloop>
			</tbody>
			
			<tr>
				<td class="varWidth"><strong>Total:</strong></td>
				<td></td>
				
				<cfloop array="#rc.locationSmartList.getRecords()#" index="local.location">
					<td class="locationtotal" data-locationid="#local.location.getLocationID()#"></td>
				</cfloop>
				
				<td></td>
			</tr>
		</table>

		<cf_SlatwallActionCaller action="admin:vendorOrder.detailVendorOrder" type="link" class="cancel button" queryString="vendorOrderId=#rc.vendorOrder.getVendorOrderID()#" text="#rc.$.Slatwall.rbKey('sitemanager.cancel')#">
		<cf_SlatwallActionCaller action="admin:vendorOrder.saveVendorOrderItems" type="submit" class="button">
	</form>
</cfoutput>