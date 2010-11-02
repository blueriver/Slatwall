<cfoutput>
	<cfquery name="OrdersShipping" datasource="#application.slatsettings.getSetting('IntegrationDSN')#" username="#application.slatsettings.getSetting('IntegrationDBUsername')#" password="#application.slatsettings.getSetting('IntegrationDBPassword')#">
		select
			a.receipt_num as 'actual_receipt_num',
			b.store_receipt_num,
			a.store_id as 'store_id',
			a.date_time as 'date_time',
			c.last_name as 'last_name',
			c.first_name as 'first_name',
			a.current_state_id as 'current_state_id'
		from
			TB_RECEIPT a
		  inner join
			TB_STORE_RECEIPTS b on a.receipt_num = b.receipt_num
		  inner join
		  	TB_CUSTOMERS c on a.customer_id = c.customer_id
		where
			a.DATE_CLOSED IS NULL
		  and
			a.SHIP_MODE = 1
		  and
			(a.current_state_id = 1 or a.current_state_id = 3 or a.current_state_id = 7 or a.current_state_id = 2)
		order by
			a.RECEIPT_NUM asc
	</cfquery>
	<table cellspacing="0" cellpadding="0" class="listtable">
		<tr>
			<th>Receipt</th>
			<th>Order Date</th>
			<th>Customer</th>
			<th>Status</th>
		</tr>
		<cfloop query="OrdersShipping">
			<cfif OrdersShipping.current_state_id eq 1>
				<cfset orderstate = "New Order">
				<tr class="rowyellow">
			<cfelseif OrdersShipping.current_state_id eq 3>
				<cfset orderstate = "Ready To Pick">
				<tr class="rowgreen">
			<cfelseif OrdersShipping.current_state_id eq 7>
				<cfset orderstate = "Picks Printed">
				<tr class="rowblue">
			<cfelseif OrdersShipping.current_state_id eq 2>
				<cfset orderstate = "Backorder">
				<tr class="rowgray">
			</cfif>
				<td><a href="/EmployeeTools/DetailViewer.cfm?detail=Receipt&rnum=#OrdersShipping.actual_receipt_num#">#OrdersShipping.store_receipt_num#-#OrdersShipping.store_id#</a></td>
				<td>#DateFormat(OrdersShipping.date_time, "MM/DD")# - #TimeFormat(OrdersShipping.date_time, "HH:MM")#</td>
				<td>#OrdersShipping.first_name# #OrdersShipping.last_name#</td>
				<td>#orderstate#</td>
			</tr>
		</cfloop>
	</table>
</cfoutput>