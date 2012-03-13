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
<cfparam name="rc.stockAdjustment">
<!---<cfparam name="rc.inDialog" default="false">--->

<cfset local.location = rc.StockAdjustment.getOneLocation()>

<!---<cfif rc.inDialog EQ "true">--->
	<cfset request.layout = false>
<!---</cfif>--->

<cfoutput>
	<!---<cfif rc.inDialog EQ "true">--->
		<h3>#Replace($.Slatwall.rbKey("admin.stockAdjustment.stockAdjustmentItemsDialogTitle"), "{1}", rc.product.getProductName())#</h3>
	<!---</cfif>--->
	
	<form name="editStockAdjustmentItems" id="editStockAdjustmentItems" action="#buildURL('admin:stockAdjustment.saveStockAdjustmentItems')#" method="post">
		<input type="hidden" name="StockAdjustmentID" value="#rc.stockAdjustment.getStockAdjustmentID()#" />
		<input type="hidden" name="productID" value="#rc.product.getProductId()#"/>
		
		<table class="listing-grid stripepopup">
			<tr>
				<th class="varWidth">Sku</th>
				<th>Quantity</th>
			</tr>
			
			<tbody>
				<cfloop array="#rc.product.getSkus()#" index="local.sku">
					<!--- See if we already have a stockAdjustment item that matches this SKU. --->
					<cfset local.StockAdjustmentItem = rc.stockAdjustment.getStockAdjustmentItemForSku(local.sku)>
					
					<tr data-skuid="#local.sku.getSkuID()#">
						<td class="varWidth">#local.sku.getSkuCode()#</td>
						<td><input type="text" name="qty_skuid(#local.sku.getSkuID()#)" value="#local.StockAdjustmentItem.getQuantity()#"></td>
					</tr>
				</cfloop>
			</tbody>
		</table>

		<cf_SlatwallActionCaller action="admin:stockAdjustment.editStockAdjustment" type="link" class="cancel button" text="#rc.$.Slatwall.rbKey('sitemanager.cancel')#">
		<cf_SlatwallActionCaller action="admin:stockAdjustment.saveStockAdjustmentItems" type="submit" class="button">
	</form>
</cfoutput>