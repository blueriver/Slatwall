<cfoutput>

	<cfquery name="QBReconcile" datasource="#application.slatsettings.getSetting('IntegrationDSN')#" username="#application.slatsettings.getSetting('IntegrationDBUsername')#" password="#application.slatsettings.getSetting('IntegrationDBPassword')#">
		select
			DATEPART(yy, tb_receipt.[date_closed]) AS 'YEAR',
			DATEPART(mm, tb_receipt.[date_closed]) AS 'MONTH', 
			sum(total) As 'TOTAL',
			sum(tax1) As 'TAX1',
			sum(tax2) As 'TAX2',
			sum(shipping_charge) as 'SHIPPING',
			sum(gift_amount) as 'GC',
			sum(total) - sum(tax1) - sum(tax2) - sum(shipping_charge) - sum(gift_amount) as 'NET'
		from
			tb_receipt 
		where
			date_closed IS NOT NULL
		  and
		  	void_by is null
		GROUP BY
			DATEPART(yy, tb_receipt.[date_closed]),
			DATEPART(mm, tb_receipt.[date_closed])
		ORDER BY
			DATEPART(yy, tb_receipt.[date_closed]) DESC,
			DATEPART(mm, tb_receipt.[date_closed]) DESC
	</cfquery>
	<table cellspacing="0" cellpadding="0" class="listtable">
		<tr>
			<th>Month / Year</th>
			<th>Total</th>
			<th>Tax 1</th>
			<th>Tax 2</th>
			<th>Shipping</th>
			<th>GC</th>
			<th>Net</th>
		</tr>
		<cfloop query="QBReconcile">
			<tr>
				<td>#QBReconcile.MONTH# / #QBReconcile.YEAR#</td>
				<td>#DollarFormat(QBReconcile.TOTAL)#</td>
				<td>#DollarFormat(QBReconcile.TAX1)#</td>
				<td>#DollarFormat(QBReconcile.TAX2)#</td>
				<td>#DollarFormat(QBReconcile.SHIPPING)#</td>
				<td>#DollarFormat(QBReconcile.GC)#</td>
				<td>#DollarFormat(QBReconcile.NET)#</td>
			</tr>
		</cfloop>
	</table>
</cfoutput>