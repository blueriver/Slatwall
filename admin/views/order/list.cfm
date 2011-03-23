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
<cfset local.OrderOrganizer = application.slatwall.orderManager.getQueryOrganizer() />
<cfset local.OrderOrganizer.setFromCollection(url) />
<cfset local.OrderIterator = application.slatwall.orderManager.getOrderIterator(local.OrderOrganizer.organizeQuery(application.Slatwall.orderManager.getAllOrdersQuery())) />

<cfoutput>
<div class="svoorderlist">
	<h3 class="tableheader">Orders</h3>
	<table class="listtable">
		<tr>
			<th>Order ID</th>
			<th>Date Placed</th>
			<th>Customer Name</th>
			<th>Order Type</th>
			<th>Order Status</th>
			<th>Order Total</th>
			<th>Alerts</th>
		</tr>
		<cfloop condition="#Local.OrderIterator.hasNext()#">
			<cfset local.Order = Local.OrderIterator.Next() />
			<cfset local.OrderAlertsQuery = Local.Order.getOrderAlertsQuery() />
			<tr>
				<td><a href="#buildURL(action='order.detail', queryString='OrderID=#local.Order.getOrderID()#')#">#local.Order.getOrderID()#</a></td>
				<td>#local.Order.getDatePlaced()#</td>
				<td><a href="#buildURL(action='customer.detail', queryString='CustomerID=#local.Order.getCustomerID()#')#">#local.Order.getCustomerName()#</a></td>
				<td>#local.Order.getOrderType()#</td>
				<td>#local.Order.getOrderStatus()#</td>
				<td>#local.Order.getOrderTotal()#</td>
				<cfif local.OrderAlertsQuery.recordcount gt 1>
					<td class="red">
						<cfloop query="local.OrderAlertsQuery">
							#local.OrderAlertsQuery.AlertCount# Item(s) #local.OrderAlertsQuery.Alert#<br />
						</cfloop>
					</td>
				<cfelse>
					<td>&nbsp;</td>
				</cfif>
					
			</tr>
		</cfloop>
	</table>
</div>
</cfoutput>

