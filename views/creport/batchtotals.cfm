<cfoutput>
	<cfquery name="BatchTotals"  datasource="#application.slatsettings.getSetting('IntegrationDSN')#" username="#application.slatsettings.getSetting('IntegrationDBUsername')#" password="#application.slatsettings.getSetting('IntegrationDBPassword')#">
		select
			count(tender_num) as tender_num,
			max(b.deposit_amt) as deposit_amt,
			max(b.machine_ID) as machine_ID,
			max(b.settle_dte) as settle_dte
		from
			tb_cc_details a
		  inner join
			tb_cc_batch b on a.cc_batch_id = b.cc_batch_id
		where
			b.deposit_amt IS NOT NULL
		group by
			b.cc_batch_id
		order by
			max(b.settle_dte) desc
	</cfquery>
	<table cellspacing="0" cellpadding="0" class="reporttable">
		<tr>
			<th>Date Settled</th>
			<th>Machine ID</th>
			<th>## Cards</th>
			<th>Total In Batch</th>
		</tr>
		<cfloop query="BatchTotals">
			<tr>
				<td>#DateFormat(BatchTotals.settle_dte, "MM/DD/YYYY")#</td>
				<td>#BatchTotals.machine_ID#</td>
				<td>#BatchTotals.tender_num#</td>
				<td>#DollarFormat(BatchTotals.deposit_amt)#</td>
			</tr>
		</cfloop>
	</table>
</cfoutput>