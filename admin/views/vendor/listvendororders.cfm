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
<cfparam name="rc.$" type="any" />
<cfparam name="rc.vendorOrderSmartList" type="any" />
<cfparam name="rc.isSearch" default=0 />
<cfparam name="rc.showAdvancedSearch" default=false />

<cfoutput>
<form action="#buildURL('admin:vendororder.listvendororders')#" method="post">
	<input type="hidden" name="isSearch" value="1" />
	<input name="Keyword" value="#rc.Keyword#" /> 
	<div id="advancedSearchOptions" <cfif !rc.showAdvancedSearch>style="display:none;"</cfif>>
		#$.Slatwall.rbKey("entity.vendorOrder.vendorOrderCreatedDateTime")#: 
		<input type="date" value="#rc.vendorOrderDateStart#" name="vendorOrderDateStart" class="datepicker" /> to <input type="date" value="#rc.vendorOrderDateEnd#" name="vendorOrderDateEnd" class="datepicker" /> 
		<cfif len(rc.vendorOrderDateStart) gt 0 or len(rc.vendorOrderDateEnd) gt 0>
			<a href="##" id="clearDates">#$.slatwall.rbKey('admin.search.cleardates')#</a><br>
		</cfif>
	</div>
	<button type="submit">#rc.$.Slatwall.rbKey("admin.vendorOrder.search")#</button>&nbsp;&nbsp;
	<a href="##" id="showAdvancedSearch"<cfif rc.showAdvancedSearch> style="display:none;"</cfif>>#$.slatwall.rbKey("admin.vendorOrder.list.showAdvancedSearch")#</a>
</form>

<cfif rc.isSearch>
	<h4>#rc.vendorOrderSmartList.getRecordsCount()# #$.slatwall.rbKey("admin.vendorOrder.list.searchresultsfound")#</h4>
</cfif>

<table id="VendorOrderList" class="listing-grid stripe">
	<tr>
		<th>#rc.$.Slatwall.rbKey("entity.vendorOrder.vendorOrderNumber")#</th>
		<th>#rc.$.Slatwall.rbKey("entity.vendorOrder.vendorOrderCreatedDateTime")#</th>
		<th class="varWidth">#rc.$.Slatwall.rbKey("entity.vendor.vendorName")#</th>
		<th>#rc.$.Slatwall.rbKey("entity.vendor.vendorOrderType")#</th>
		<th>#rc.$.Slatwall.rbKey("entity.vendorOrder.total")#</th>
		<th>&nbsp</th>
	</tr>
	<cfloop array="#rc.vendorOrderSmartList.getPageRecords()#" index="local.vendorOrder">
		<tr>
			<td>#Local.VendorOrder.getVendorOrderNumber()#</td>
			<td>#DateFormat(Local.VendorOrder.getCreatedDateTime(), "medium")#</td>
			<td class="varWidth">#Local.VendorOrder.getVendor().getVendorName()#</td>
			<td >#Local.VendorOrder.getVendorOrderType().getType()#</td>
			<td>#local.vendorOrder.getFormattedValue('total', 'currency')#</td>
			<td class="administration">
				<ul class="one">
				  <cf_SlatwallActionCaller action="admin:vendororder.detailvendororder" querystring="vendorOrderID=#local.vendorOrder.getVendorOrderID()#" class="detail" type="list">
				</ul>     						
			</td>
		</tr>
	</cfloop>
</table>
<cf_SlatwallSmartListPager smartList="#rc.vendorOrderSmartList#">
</cfoutput>
