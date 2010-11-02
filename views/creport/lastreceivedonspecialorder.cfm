<cfoutput>
	<cfquery name="NewItems" datasource="#application.slatsettings.getSetting('IntegrationDSN')#" username="#application.slatsettings.getSetting('IntegrationDBUsername')#" password="#application.slatsettings.getSetting('IntegrationDBPassword')#">
		select
			b.sku_id as sku_id,
			max(c.style_id) as style_id,
			max(c.picture_id) as picture_id,
			max(c.style) as style,
			max(c.brand) as brand,
			max(c.of2) as year,
			max(c.description) as description,
			max(f.DTE) as rcvd_dte,
			min(a.first_rcvd) as first_rcvd,
			max(c.style_id) as style_id,
			max(f.po_box_id) as po_box_id,
			max(i.SIZ) as size,
			max(g.attr1) as color,
			max(h.attr2) as attr2
		from
			tb_sku_buckets a
		left join
			tb_skus b on a.sku_id = b.SKU_ID
		left join
			tb_styles c on b.STYLE_ID = c.style_id
		left join
			tb_po_skus d on a.sku_bucket_id = d.sku_bucket_id
		left join
			tb_transfer_sku e on d.po_sku_id = e.po_sku_id
		left join
			tb_po_boxes f on e.po_box_id = f.po_box_id
		left join
			tb_attr1_entries g on b.attr1_entry_id = g.attr1_entry_id
		left join
			tb_attr2_entries h on b.attr2_entry_id = h.attr2_entry_id
		left join
			tb_size_entries i on b.scale_entry_id = i.scale_entry_id
		where exists(
			select
				n.store_receipt_num as receipt_num,
				n.store_id as store_id
			from tb_receiptline l
			inner join tb_receipt m on l.receipt_num = m.receipt_num
			inner join tb_store_receipts n on m.receipt_num = n.receipt_num
			inner join tb_sku_buckets o on l.sku_bucket_id = o.sku_bucket_id
			inner join tb_skus p on o.sku_id = p.sku_id
			where
				p.sku_id = b.sku_id
			and
				l.quantity > 0
			and
				m.date_closed is null
			)
		  AND
		  	f.DTE is not null
		group by
			b.sku_id
		order by
			max(f.dte) desc
	</cfquery>
	<table cellspacing="0" cellpadding="0" class="listtable">
		<tr>
			<th>Received</th>
			<th>Brand</th>
			<th>Year</th>
			<th>Description</th>
			<th>Size</th>
			<th>Color</th>
			<th>ATTR 2</th>
			<th>Receipts</th>
		</tr>
		<cfloop query="NewItems">
			<tr valign="top">
				<td>#DateFormat(NewItems.rcvd_dte, "mm/dd")#</td>
				<td>#NewItems.brand#</td>
				<td>#NewItems.year#</td>
				<td>#NewItems.description#</td>
				<td>#NewItems.size#</td>
				<td>#NewItems.color#</td>
				<td>#NewItems.attr2#</td>
				<td>
					<cfset SOReceipts = "">
					<cfquery name="SOReceipts" datasource="#application.slatsettings.getSetting('IntegrationDSN')#" username="#application.slatsettings.getSetting('IntegrationDBUsername')#" password="#application.slatsettings.getSetting('IntegrationDBPassword')#">
						select
							b.receipt_num as actual_receipt_num,
							c.store_receipt_num as receipt_num,
							c.store_id as store_id,
							b.date_time as order_date
						from tb_receiptline a
						inner join tb_receipt b on a.receipt_num = b.receipt_num
						inner join tb_store_receipts c on b.receipt_num = c.receipt_num
						inner join tb_sku_buckets d on a.sku_bucket_id = d.sku_bucket_id
						inner join tb_skus e on d.sku_id = e.sku_id
						where
							e.sku_id = #NewItems.sku_id#
						and
							a.quantity > 0
						and
							b.date_closed is null
						order by b.date_time asc
					</cfquery>
					<cfloop query="SOReceipts">
						<a href="#buildURL(action='order.detail',querystring='OrderID=#SOReceipts.receipt_num#-#SOReceipts.store_id#')#">#SOReceipts.receipt_num#-#SOReceipts.store_id#</a><br /> 
					</cfloop>
				</td>
			</tr>
		</cfloop>
	</table>
</cfoutput>