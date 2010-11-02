<cfoutput>
	<cfquery name="OpenPO"  datasource="#application.slatsettings.getSetting('IntegrationDSN')#" username="#application.slatsettings.getSetting('IntegrationDBUsername')#" password="#application.slatsettings.getSetting('IntegrationDBPassword')#">
		select
			arrival_date,
			ship_date,
			dte,
			cancel_date,
			vendor_po,
			brand,
			pcs_ordered,
			pcs_rcvd,
			DATE_LAST_RCVD
		from
			tb_purchase_orders a
		where
			a.closed = 'N'
		  and
			a.pcs_ordered > 0
		order by
			a.arrival_date asc
	</cfquery>
	<table cellspacing="0" cellpadding="0" class="listtable">
		<tr>
			<th>Est. Arrival</th>
			<th>Est. Ship</th>
			<th>Order Date</th>
			<th>Cancel Date</th>
			<th>PO</th>
			<th>Brand</th>
			<th>Ordered</th>
			<th>Received</th>
		</tr>
		<cfloop query="OpenPO">
			<cfif len(OpenPO.arrival_date)>
				<cfif not len(OpenPO.date_last_rcvd)>
					<cfif OpenPO.arrival_date lt now()>
						<tr class="redbg">
					<cfelseif #DateFormat(OpenPO.arrival_date,"MM/DD/YYYY")# eq #DateFormat(now(),"MM/DD/YYYY")#>
						<tr class="yellowbg">
					<cfelseif  OpenPO.arrival_date gt now()>
						<tr class="greenbg">
					</cfif>
				<cfelse>
					<cfif OpenPO.arrival_date lt now()> 
						<tr class="purplebg">
					<cfelse>
						<tr class="greenbg">
					</cfif>
				</cfif>
			<cfelse>
				<tr class="gray">
			</cfif>
				<td>#DateFormat(OpenPO.arrival_date, "MM-DD-YYYY")#</td>
				<td>#DateFormat(OpenPO.ship_date, "MM-DD-YYYY")#</td>
				<td>#DateFormat(OpenPO.dte, "MM-DD-YYYY")#</td>
				<td>#DateFormat(OpenPO.cancel_date, "MM-DD-YYYY")#</td>
				<td>#OpenPO.vendor_po#</td>
				<td>#OpenPO.brand#</td>
				<td>#OpenPO.pcs_ordered#</td>
				<td>#OpenPO.pcs_rcvd#</td>
			</tr>
		</cfloop>
	</table>
</cfoutput>