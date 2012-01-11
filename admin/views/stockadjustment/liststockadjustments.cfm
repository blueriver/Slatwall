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
<cfparam name="rc.stockAdjustmentSmartList" type="any" />

<cfoutput>
<ul id="navTask">
    <cf_SlatwallActionCaller action="admin:stockadjustment.createStockAdjustment" type="list">
</ul>

<div class="svoadminstockadjustmentlist">
<cfif arrayLen(rc.stockAdjustmentSmartList.getPageRecords()) gt 0>
	<table id="StockAdjustments" class="listing-grid stripe">
		<tr>
			<th class="varWidth">#rc.$.Slatwall.rbKey("entity.stockadjustment.createDateTime")#</th>
			<th>#rc.$.Slatwall.rbKey("entity.stockadjustment.fromLocation")#</th>
			<th>#rc.$.Slatwall.rbKey("entity.stockadjustment.toLocation")#</th>
			<th>#rc.$.Slatwall.rbKey("entity.stockadjustment.type")#</th>
			<th>&nbsp;</th>
		</tr>
		<cfloop array="#rc.stockAdjustmentSmartList.getPageRecords()#" index="local.StockAdjustment">
			<tr>
				<td class="varWidth">#DateFormat(local.StockAdjustment.getCreatedDateTime(), "medium")#</td>
				<td>
					<cfif !isNull(local.StockAdjustment.getFromLocation())>
						#local.StockAdjustment.getFromLocation().getLocationName()#
					</cfif>
				</td>
				<td>
					<cfif !isNull(local.StockAdjustment.getToLocation())>
						#local.StockAdjustment.getToLocation().getLocationName()#
					</cfif>
				</td>
				<td>#local.StockAdjustment.getStockAdjustmentType().getType()#</td>
				
				<td class="administration">
		          <ul class="three">
                      <cf_SlatwallActionCaller action="admin:stockadjustment.editstockadjustment" querystring="stockadjustmentID=#local.stockadjustment.getStockAdjustmentID()#" class="edit" type="list">            
					  <cf_SlatwallActionCaller action="admin:stockadjustment.detailstockadjustment" querystring="stockadjustmentID=#local.stockadjustment.getStockAdjustmentID()#" class="detail" type="list">
					  <cf_SlatwallActionCaller action="admin:stockadjustment.deletestockadjustment" querystring="stockadjustmentID=#local.stockadjustment.getStockAdjustmentID()#" class="delete" type="list" disabled="#local.stockadjustment.isNotDeletable()#" confirmrequired="true">
		          </ul>     						
				</td>
			</tr>
		</cfloop>
	</table>
	<cf_SlatwallSmartListPager smartList="#rc.stockAdjustmentSmartList#">
<cfelse>
<em>#rc.$.Slatwall.rbKey("admin.stockadjustment.nostockadjustmentsdefined")#</em>
</cfif>
</div>
</cfoutput>