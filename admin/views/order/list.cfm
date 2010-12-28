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
