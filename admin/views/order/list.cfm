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
<cfparam name="rc.orderSmartList" type="any" />

<cfoutput>
	
<div class="svoadminorderlist">
	<form action="#buildURL('admin:order.list')#" method="post">
		<input name="Keyword" value="#rc.Keyword#" /> 
		<div id="advancedSearchOptions" style="display:none;">
			#$.Slatwall.rbKey("entity.order.orderOpenDateTime")#: 
			<input type="date" name="orderDateStart" class="date" /> to <input type="date" name="orderDateEnd" class="date" /><br>
			#$.Slatwall.rbKey("entity.order.orderStatusType")#:
		</div>		
		<button type="submit">#rc.$.Slatwall.rbKey("admin.order.search")#</button>&nbsp;&nbsp;
		<a href="##" id="showAdvancedSearch">#$.slatwall.rbKey("admin.order.list.showAdvancedSearch")#</a>

	</form>
	
	<form name="OrderActions" action="#buildURL(action='admin:order.applyOrderActions')#" method="post">
		<table id="OrderList" class="stripe">
			<tr>
				<th>#rc.$.Slatwall.rbKey("entity.order.orderNumber")#</th>
				<th>#rc.$.Slatwall.rbKey("entity.order.orderOpenDateTime")#</th>
				<th class="varWidth">#rc.$.Slatwall.rbKey("entity.account.fullName")#</th>
				<th>#rc.$.Slatwall.rbKey("entity.order.orderStatusType")#</th>
				<th>#rc.$.Slatwall.rbKey("entity.order.total")#</th>
				<th>#$.slatwall.rbKey("admin.order.list.actions")#</th>
				<th>&nbsp</th>
			</tr>
			<cfloop array="#rc.orderSmartList.getPageRecords()#" index="local.order">
				<tr>
					<td>#Local.Order.getOrderNumber()#</td>
					<td>#DateFormat(Local.Order.getOrderOpenDateTime(), "medium")#</td>
					<td class="varWidth"><cfif not isNull(local.order.getAccount())>#Local.Order.getAccount().getFullName()#</cfif></td>
					<td>#Local.Order.getOrderStatusType().getType()#</td>
					<td>#DollarFormat(local.order.getTotal())#</td>
					<td>
						<cfset local.orderActionOptions = local.order.getActionOptions() />
						<cfif arrayLen(local.orderActionOptions) gt 0>
							<select name="orderActions">
								<option value="">#$.slatwall.rbKey("define.select")#</option>
								<cfloop array = #local.orderActionOptions# index="local.thisAction">
									<option value="#local.order.getOrderID()#_#local.thisAction.getOrderActionType().getTypeID()#">#local.thisAction.getOrderActionType().getType()#</option>
								</cfloop>
							</select>
						<cfelse>
							#$.slatwall.rbKey("define.notApplicable")#
						</cfif>
					</td>
					<td class="administration">
						<ul class="one">
						  <cf_SlatwallActionCaller action="admin:order.detail" querystring="orderID=#local.order.getOrderID()#" class="viewDetails" type="list">
						</ul>     						
					</td>
				</tr>
			</cfloop>
		</table>
		<cf_SlatwallActionCaller action="admin:order.applyOrderActions" type="submit" class="button" confirmRequired="true">
	</form>
</div>
</cfoutput>
