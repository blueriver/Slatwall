<cfoutput>
	<cfquery name="NoSerialNumber" datasource="#application.slatsettings.getSetting('IntegrationDSN')#" username="#application.slatsettings.getSetting('IntegrationDBUsername')#" password="#application.slatsettings.getSetting('IntegrationDBPassword')#">
		select
			a.receipt_num as 'receipt_num',
			e.date_time as 'date_time',
			f.store_receipt_num as 'store_receipt_num',
			f.store_id as 'store_id', 
			a.lookup as 'lookup',
			d.brand as 'brand',
			d.description as 'description'
		from
			tb_receiptline a
		  inner join
		  	tb_sku_buckets b on a.sku_bucket_id = b.sku_bucket_id
		  inner join
		  	tb_skus c on b.sku_id = c.sku_id
		  inner join
		  	tb_styles d on c.style_id = d.style_id
		  inner join
		  	tb_receipt e on a.receipt_num = e.receipt_num
		  inner join
		  	tb_store_receipts f on e.receipt_num = f.receipt_num
		where
			e.date_closed is not null
		  and
		  	a.quantity > 0
		  and
		  	serial_num is null
		  and
		  	(d.taxonomy_id = '344' or d.taxonomy_id = '345' or d.taxonomy_id = '351' or d.taxonomy_id = '352')
		  and
		  	e.void_by is null
	</cfquery>
	<table cellspacing="0" cellpadding="0" class="listtable">
		<tr>
			<th>Receipt Number</th>
			<th>Item Barcode</th>
			<th>Brand</th>
			<th>Description</th>
		</tr>
		<cfloop query="NoSerialNumber">
			<tr>
				<td>#NoSerialNumber.store_receipt_num#-#NoSerialNumber.store_id#</td>
				<td>#NoSerialNumber.lookup#</td>
				<td>#NoSerialNumber.brand#</td>
				<td>#NoSerialNumber.description#</td>
			</tr>
		</cfloop>
	</table>
</cfoutput>