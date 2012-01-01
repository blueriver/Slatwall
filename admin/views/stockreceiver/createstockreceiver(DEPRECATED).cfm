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


<!---

			INTERFACE NOT BEING USED! DELETE.



--->

<cfparam name="rc.vendorOrder">
<cfparam name="rc.vendorOrderReceiver">
<cfparam name="rc.vendorOrderItemSmartList">
<cfparam name="rc.locationSmartList">

<cfoutput>
	<ul id="navTask">
		<cf_SlatwallActionCaller action="admin:vendorOrder.detailVendorOrder" queryString="vendorOrderId=#rc.vendorOrder.getVendorOrderId()#" type="list">
	</ul>
	
	<div class="basicOrderInfo">
		<table class="listing-grid stripe" id="basicVendorOrderInfo" style="width:400px;">
			<tr>
				<th colspan="2">#$.Slatwall.rbKey("admin.vendorOrderReceiver.basicvendorOrderrecenverinfo")#</th>
			</tr>
			<cf_SlatwallPropertyDisplay object="#rc.VendorOrder#" property="VendorOrderNumber" edit="false" displayType="table">
			<cf_SlatwallPropertyDisplay object="#rc.VendorOrder.getVendorOrderType()#" property="Type" edit="false"  displayType="table">
			<cf_SlatwallPropertyDisplay object="#rc.VendorOrder#" property="createdDateTime" edit="false"  displayType="table">
			<cf_SlatwallPropertyDisplay object="#rc.VendorOrder.getVendor()#" property="vendorName" edit="false"  displayType="table">
			<cf_SlatwallPropertyDisplay object="#rc.VendorOrder.getVendor()#" property="emailAddress" edit="false" displayType="table">
			<!---<cf_SlatwallPropertyDisplay object="#local.vendor#" property="primaryPhoneNumber" edit="false" displayType="table">--->
		</table>
	</div>
	<!---<div class="paymentInfo">
		<dl class="orderTotals">
			<dt><strong>#$.Slatwall.rbKey("admin.vendorOrderReceiver.receiveForLocation")#</strong></dt> 
			<dd>
				<select name="receiveForLocationID" id="receiveForLocationID">
					<option value="">#$.Slatwall.rbKey("admin.vendorOrderReceiver.selectReceiveForLocation")#</option>
					<cfloop array="#rc.locationSmartList.getPageRecords()#" index="local.location">
						<option value="#local.location.getLocationID()#">#local.location.getLocationName()#</option>
					</cfloop>
				</select>
			</dd>
			<!---<dt><strong>#$.Slatwall.rbKey("entity.vendorOrderReceiver.dateTimeReceived")#</strong></dt>
			<dt><cf_SlatwallPropertyDisplay object="#rc.VendorOrder#" property="dateTimeReceived" edit="#rc.edit#" displayType="dl" fieldType="date"><dt>--->
			
			<dl  class="orderTotals"><strong>#$.Slatwall.rbKey("entity.vendorOrderReceiver.boxCount")#</strong></dl>
			<dd><input type="text" name="boxCount"></dd>
		</dl>
	</div>--->

	<div class="clear">
		<style>
			
			.dim td{background-color:##ced6df !important;}
			.dim.alt td{background-color:##dddfe0 !important;}
		</style>

		<form name="detailVendorOrderReceiver" id="detailVendorOrderReceiver" action="#buildURL('admin:vendorOrder.saveVendorOrderReceiver')#" method="post">
			
			<dl class="twoColumn">
				
				<cfif rc.edit>
					<dt class="title"><label>#$.Slatwall.rbKey("admin.vendorOrderReceiver.receiveForLocation")#</strong></label></dt> 
					<dd class="value">
					
						<cfset valueOptions = rc.locationSmartList.getPageRecords()>
						<cfset ArrayPrepend(valueOptions, {name=$.Slatwall.rbKey("admin.vendorOrderReceiver.selectReceiveForLocation"), value=""})>
						<cf_SlatwallFormField fieldType="select" fieldName="receiveForLocationID" valueOptions="#valueOptions#" fieldClass="receiveForLocationID">
						
						<!---<select name="receiveForLocationID" id="receiveForLocationID">
							<option value="">#$.Slatwall.rbKey("admin.vendorOrderReceiver.selectReceiveForLocation")#</option>
							<cfloop array="#rc.locationSmartList.getPageRecords()#" index="local.location">
								<option value="#local.location.getLocationID()#">#local.location.getLocationName()#</option>
							</cfloop>
						</select>--->
					</dd>
				</cfif>
				
				<cf_SlatwallPropertyDisplay object="#rc.VendorOrderReceiver#" property="boxCount" edit="#rc.edit#">
				
				<!---<dl class="title"><label><strong>#$.Slatwall.rbKey("entity.vendorOrderReceiver.boxCount")#</strong></label></dl>
				<dd class="value"><input type="text" name="boxCount"></dd>--->
				
				<!---<cf_SlatwallPropertyDisplay object="#rc.VendorOrderReceiver#" property="notes" edit="#rc.edit#">--->
				
				<!---<dl class="title"><label><strong>#$.Slatwall.rbKey("entity.vendorOrderReceiver.notes")#</strong></label></dl>
				<dd class="value"><textarea name="notes" rows="4" cols="40"></textarea></dd>--->
			</dl>
			
			
			
			<input type="hidden" name="VendorOrderID" value="#rc.vendorOrder.getVendorOrderID()#" />
			
			<table class="listing-grid stripe">
				<tr>
					<th class="varWidth">Sku</th>
					<th>Brand - Product Name</th>
					<th>Cost</th>
					<th>Quantity Ordered</th>
					<th>Quantity Already Received</th>
					<th>Ordered for Location</th>	
					<th>Quantity Receiving</th>
				</tr>
				
				<tbody>
					<cfloop from="1" to="#ArrayLen(rc.vendorOrderItemSmartList.getPageRecords())#" index="local.i">
						<cfset local.vendorOrderItem = rc.vendorOrderItemSmartList.getPageRecords()[local.i]>
						<cfset local.stock = local.vendorOrderItem.getStock()>
						<cfset local.product = local.stock.getSku().getProduct()>
						<tr data-locationid="#local.stock.getLocation().getLocationID()#">
							<td class="varWidth">#local.stock.getSku().getSkuCode()#</td>
							<td>#local.product.getBrand().getBrandName()# #local.product.getProductName()#</td>
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
							<td><input type="text"  name="quantity_stockid(#local.stock.getStockID()#)" value=""></td>
						</tr>
					</cfloop>
				</tbody>
			</table>
	
			<cf_SlatwallActionCaller action="admin:vendorOrder.detailVendorOrder" type="link" class="cancel button" queryString="vendorOrderId=#rc.vendorOrder.getVendorOrderID()#" text="#rc.$.Slatwall.rbKey('sitemanager.cancel')#">
			<cf_SlatwallActionCaller action="admin:vendorOrder.saveVendorOrderItems" type="submit" class="button">
		</form>
	</div>
</cfoutput>