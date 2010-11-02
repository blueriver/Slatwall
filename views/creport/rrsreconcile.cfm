<cfoutput>
	<cfquery name="RRSReconcile" datasource="#application.slatsettings.getSetting('IntegrationDSN')#" username="#application.slatsettings.getSetting('IntegrationDBUsername')#" password="#application.slatsettings.getSetting('IntegrationDBPassword')#">
		select
			tb_store_receipts.store_receipt_num,
			tb_receipt.our_num,
			--tb_receiptline.price,
			avg(CASE
				WHEN tb_taxonomy.dept = 'BIKE' or tb_taxonomy.dept = 'BIKE ACCESSORIES' THEN .925
				ELSE .85
			END) as 'AverageCommision',
			sum(tb_receiptline.price * tb_receiptline.quantity) as 'Subtotal',
			sum(CASE
				WHEN tb_taxonomy.dept = 'BIKE' or tb_taxonomy.dept = 'BIKE ACCESSORIES' THEN .925 * ((tb_receiptline.price * tb_receiptline.quantity) * .9)
				ELSE .85 * ((tb_receiptline.price * tb_receiptline.quantity) * .9)
			END) as 'NytrosPayVIP',
			sum(CASE
				WHEN tb_taxonomy.dept = 'BIKE' or tb_taxonomy.dept = 'BIKE ACCESSORIES' THEN .925 * (tb_receiptline.price * tb_receiptline.quantity)
				ELSE .85 * (tb_receiptline.price * tb_receiptline.quantity)
			END) as 'NytrosPayNoVIP'
			--tb_sku_buckets.price,
			--tb_sku_buckets.avg_cost
		from
			tb_receiptline
		  inner join
			tb_receipt on tb_receiptline.receipt_num = tb_receipt.receipt_num
		  inner join
			tb_sku_buckets on tb_receiptline.sku_bucket_id = tb_sku_buckets.sku_bucket_id
		  inner join
			tb_skus on tb_sku_buckets.sku_id = tb_skus.sku_id
		  inner join
			tb_styles on tb_skus.style_id = tb_styles.style_id
		  inner join
			tb_taxonomy on tb_taxonomy.taxonomy_id = tb_styles.taxonomy_id
		  inner join
		  	tb_store_receipts on tb_receipt.receipt_num = tb_store_receipts.receipt_num
		where
			tb_receipt.category3 = 'RRS ORDERS'
		group by
			tb_receipt.our_num, tb_store_receipts.store_receipt_num
		order by
			tb_receipt.our_num

	</cfquery>
	<table cellspacing="0" cellpadding="0" class="listtable">
		<tr>
			<th>RRS Invoice ##</th>
			<th>Average Commision</th>
			<th>Nytros Pay VIP</th>
			<th>Nytros Pay Not VIP</th>
		</tr>
		<cfloop query="RRSReconcile">
			<tr>
				<td>#RRSReconcile.store_receipt_num#</td>
				<td>#RRSReconcile.our_num#</td>
				<td>#NumberFormat(((1 - RRSReconcile.AverageCommision)*100),"0.00")# %</td>
				<td>#DollarFormat(RRSReconcile.Subtotal)#</td>
				<td>#DollarFormat(RRSReconcile.NytrosPayVIP)#</td>
				<td>#DollarFormat(RRSReconcile.NytrosPayNoVIP)#</td>
			</tr>
		</cfloop>
	</table>
</cfoutput>