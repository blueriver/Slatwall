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
<cfparam name="rc.vendor" type="any" />

<cfoutput>
	<table id="VendorOrderList" class="listing-grid stripe">
		<tr>
			<th class="varWidth">#rc.$.Slatwall.rbKey("entity.vendorOrder.vendorOrderNumber")#</th>
			<th>#rc.$.Slatwall.rbKey("entity.vendorOrder.vendorOrderCreatedDateTime")#</th>
			<th>#rc.$.Slatwall.rbKey("entity.vendorOrder.vendorOrderType")#</th>
			<th>#rc.$.Slatwall.rbKey("entity.vendorOrder.total")#</th>
			<th>&nbsp</th>
		</tr>
		<cfloop array="#rc.vendorOrderSmartList.getPageRecords()#" index="local.vendorOrder">
			<tr>
				<td class="varWidth">#Local.VendorOrder.getVendorOrderNumber()#</td>
				<td>#DateFormat(Local.VendorOrder.getCreatedDateTime(), "medium")#</td>
				<td>#Local.VendorOrder.getVendorOrderType().getType()#</td>
				<td>#local.VendorOrder.getFormattedValue('total', 'currency')#</td>
				<td class="administration">
					<ul class="one">
					  <cf_SlatwallActionCaller action="admin:vendorOrder.detailvendororder" querystring="vendorOrderID=#local.vendorOrder.getVendorOrderID()#" class="detail" type="list">
					</ul>     						
				</td>
			</tr>
			
			
		</cfloop>
	</table>
</cfoutput>