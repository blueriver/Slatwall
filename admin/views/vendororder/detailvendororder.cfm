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
<cfparam name="rc.edit" default="false" />
<cfparam name="rc.VendorOrder" type="any" />

<!---<cfset local.vendorOrderActionOptions = rc.VendorOrder.getActionOptions() />--->
<cfset local.vendor = rc.VendorOrder.getVendor() />

<cfoutput>

<ul id="navTask">
	<cf_SlatwallActionCaller action="admin:vendorOrder.listvendororders" type="list">
</ul>

<!--- Display buttons of available vendorOrder actions --->
<!---<cfloop array="#local.vendorOrderActionOptions#" index="local.thisAction">
<cfset local.action = lcase( replace(local.thisAction.getVendorOrderActionType().getSystemCode(),"oat","","one") ) />
	<cfif local.action neq "cancel" or (local.action eq "cancel" and !rc.vendorOrder.getQuantityDelivered())>
	<cf_SlatwallActionCaller action="admin:vendorOrder.#local.action#vendorOrder" querystring="vendorOrderid=#rc.VendorOrder.getVendorOrderID()#" class="button" confirmRequired="true" />
	</cfif>
</cfloop>--->

<div class="svoadminvendororderdetail">
	<div class="basicOrderInfo">
		<table class="listing-grid stripe" id="basicVendorOrderInfo" style="width:400px;">
			<tr>
				<th colspan="2">#$.Slatwall.rbKey("admin.vendorOrder.detail.basicvendorOrderinfo")#</th>
			</tr>
			<cf_SlatwallPropertyDisplay object="#rc.VendorOrder#" property="VendorOrderNumber" edit="false" displayType="table">
			<cf_SlatwallPropertyDisplay object="#rc.VendorOrder.getVendorOrderType()#" property="Type" edit="false"  displayType="table">
			<cf_SlatwallPropertyDisplay object="#rc.VendorOrder#" property="createdDateTime" edit="false"  displayType="table">
			<cf_SlatwallPropertyDisplay object="#rc.VendorOrder.getVendor()#" property="vendorName" edit="false"  displayType="table">
			<cf_SlatwallPropertyDisplay object="#rc.VendorOrder.getVendor()#" property="emailAddress" edit="false" displayType="table">
			<!---<cf_SlatwallPropertyDisplay object="#local.vendor#" property="primaryPhoneNumber" edit="false" displayType="table">--->
		</table>
	</div>
	<div class="paymentInfo">
		<p><strong>#$.Slatwall.rbKey("admin.vendorOrder.detail.vendorOrdertotals")#</strong></p>
		<dl class="orderTotals">
			<dt>#$.Slatwall.rbKey("admin.vendorOrder.detail.subtotal")#</dt> 
			<dd>#rc.vendorOrder.getFormattedValue('subtotal', 'currency')#</dd>
			<dt>#$.Slatwall.rbKey("admin.vendorOrder.detail.totaltax")#</dt>
			<dd>#rc.vendorOrder.getFormattedValue('taxTotal', 'currency')#</dd>
			<!---<dt>#$.Slatwall.rbKey("admin.vendorOrder.detail.totalFulfillmentCharge")#</dt>--->
			<!---<dd>#rc.vendorOrder.getFormattedValue('fulfillmentTotal', 'currency')#</dd>--->
			<!---<dt>#$.Slatwall.rbKey("admin.vendorOrder.detail.totalDiscounts")#</dt>--->
			<!---<dd>#rc.vendorOrder.getFormattedValue('discountTotal', 'currency')#</dd>--->
			<dt><strong>#$.Slatwall.rbKey("admin.vendorOrder.detail.total")#</strong></dt> 
			<dd><strong>#rc.vendorOrder.getFormattedValue('total', 'currency')#</strong></dd>
		</dl>
	</div>
	<div class="clear">
		<div class="tabs initActiveTab ui-tabs ui-widget ui-widget-content ui-corner-all">
			<ul>	
				<li><a href="##tabVendorOrderItems" onclick="return false;"><span>#rc.$.Slatwall.rbKey("admin.vendorOrder.detail.tab.vendorOrderItems")#</span></a></li>
				<li><a href="##tabVendorOrderDeliveries" onclick="return false;"><span>#rc.$.Slatwall.rbKey("admin.vendorOrder.detail.tab.vendorOrderDeliveries")#</span></a></li>
			</ul>
		
			<div id="tabVendorOrderItems">
				#view("vendorOrder/vendorOrdertabs/items")# 
			</div>
			<div id="tabVendorOrderDeliveries">
				WIP
			</div>
		</div> <!-- tabs -->
	</div>
</div>
</cfoutput>
