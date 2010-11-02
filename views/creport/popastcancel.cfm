<cfoutput>
	<cfquery name="POPastCancel" datasource="#application.slatsettings.getSetting('IntegrationDSN')#" username="#application.slatsettings.getSetting('IntegrationDBUsername')#" password="#application.slatsettings.getSetting('IntegrationDBPassword')#">
		select
			*
		from tb_purchase_orders a
		where
			a.closed = 'N'
		  and
		    a.cancel_date is not null
		  and
			a.cancel_date < '#DateFormat(now(), "MM/DD/YYYY")#'
		  and
			a.pcs_rcvd = '0'
		order by
			a.cancel_date asc
	</cfquery>
	<table cellspacing="0" cellpadding="0" class="listtable">
		<tr>
			<th>Order Date</th>
			<th>Cancel Date</th>
			<th>PO</th>
			<th>Brand</th>
			<th>Ordered</th>
			<th>Received</th>
		</tr>
		<cfloop query="POPastCancel">
			<cfif #DateFormat(POPastCancel.cancel_date,"MM/DD/YYYY")# lt #DateFormat(now()-15,"MM/DD/YYYY")#>
				<tr class="rowred">
			<cfelse>
				<tr class="rowyellow">
			</cfif>
				<td>#DateFormat(POPastCancel.dte, "MM-DD-YYYY")#</td>
				<td>#DateFormat(POPastCancel.cancel_date, "MM-DD-YYYY")#</td>
				<td>#POPastCancel.vendor_po#</td>
				<td>#POPastCancel.brand#</td>
				<td>#POPastCancel.pcs_ordered#</td>
				<td>#POPastCancel.pcs_rcvd#</td>
			</tr>
		</cfloop>
	</table>
</cfoutput>