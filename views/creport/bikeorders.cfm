<cfoutput>
	<cfquery name="BikeOrders"  datasource="#application.slatsettings.getSetting('IntegrationDSN')#" username="#application.slatsettings.getSetting('IntegrationDBUsername')#" password="#application.slatsettings.getSetting('IntegrationDBPassword')#">
		select
			a.sku_bucket_id as 'sku_bucket_id',
			a.quantity as 'quantity',
			a.shipped as 'shipped',
			b.receipt_num as 'actual_receipt_num',
			c.store_receipt_num as 'receipt_num',
			c.store_id as 'store_id',
			b.machine_id as 'machine_id',
			b.date_time as 'order_date',
			m.ship_method_id as 'ship_method',
			a.serial_num as 'serial_num',
			d.first_name as 'first_name',
			d.last_name as 'last_name',
			g.description as 'description',
			h.siz as 'size',
			i.attr1 as 'color',
			j.attr2 as 'attr2',
			g.taxonomy_id as 'taxonomy_id',
			l.first_name as 'sp_first_name',
			l.last_name as 'sp_last_name',
			b.category2 as 'bike_status',
			g.of2 as 'year',
			g.brand as 'brand',
			(select sum(qoh) from tb_sku_buckets where sku_id = f.sku_id) as 'QOH',
			(select sum(qoo) from tb_sku_buckets where sku_id = f.sku_id) as 'QOO',
			(select sum(qc) from tb_sku_buckets where sku_id = f.sku_id) as 'QC'
		from
			tb_receiptline a
		  inner join 
			tb_receipt b on a.receipt_num = b.receipt_num
		  inner join
		  	tb_store_receipts c on b.receipt_num = c.receipt_num
		  inner join
		  	tb_customers d on b.customer_id = d.customer_id
		  inner join
		  	tb_sku_buckets e on a.sku_bucket_id = e.sku_bucket_id
		  inner join
		  	tb_skus f on e.sku_id = f.sku_id
		  inner join
		  	tb_styles g on f.style_id = g.style_id
		  left join
		  	tb_size_entries h on f.scale_entry_id = h.scale_entry_id
		  left join
		  	tb_attr1_entries i on f.attr1_entry_id = i.attr1_entry_id
		  left join
		  	tb_attr2_entries j on f.attr2_entry_id = j.attr2_entry_id
		  left join
		  	tb_receiptslsmn k on b.receipt_num = k.receipt_num
		  left join
		  	tb_employee l on k.employee_id = l.employee_id
		  left join
		  	tb_receipt_ship m on b.receipt_num = m.receipt_num 
		where
			b.date_closed is null
		  and
		  	(g.taxonomy_id = '344' or g.taxonomy_id = '345' or g.taxonomy_id = '351' or g.taxonomy_id = '352')
		  and
		  	a.quantity > 0
		  and
		  	a.quantity > a.shipped
		order by
			b.category2 desc,
			b.date_time asc
	</cfquery>
	<table cellspacing="0" cellpadding="0" class="listtable">
		<tr>
			<th>Rec</th>
			<th>Date</th>
			<th>Customer Name</th>
			<th>Year</th>
			<th>Brand</th>
			<th>Desc</th>
			<th>Size</th>
			<th>Color</th>
			<th>Attr 2</th>
			<th>F/B</th>
			<th>I/Stat</th>
			<th>B/Stat</th>
			<th>SN</th>
			<th>Salesperson</th>
			<th>Shipping</th>
		</tr>
		<cfloop query="BikeOrders">
			<cfif #BikeOrders.machine_id# eq '9907'>
				<tr class="rowyellow">
			<cfelse>
				<tr>
			</cfif>
				<td><a href="#buildURL(action='order.detail', querystring='OrderID=#BikeOrders.receipt_num#-#BikeOrders.store_id#')#">#BikeOrders.receipt_num#-#BikeOrders.store_id#</a></td>
				<td>#DateFormat(BikeOrders.order_date, "mm/dd")#</td>
				<td>#BikeOrders.first_name# #BikeOrders.last_name#</td>
				<td>#BikeOrders.year#</td>
				<td>#BikeOrders.brand#</td>
				<td>#BikeOrders.description#</td>
				<td>#BikeOrders.size#</td>
				<td>#BikeOrders.color#</td>
				<td>#BikeOrders.attr2#</td>
				<td>
					<cfif BikeOrders.taxonomy_id eq '345' or BikeOrders.taxonomy_id eq '351'>
						BK
					<cfelseif BikeOrders.taxonomy_id eq '344' or BikeOrders.taxonomy_id eq '352'>
						FS
					<cfelse>
						GRU
					</cfif>
				</td>
				<td>
					<cfif BikeOrders.Quantity eq BikeOrders.Shipped>
						SHIP
					<cfelseif BikeOrders.QOH + BikeOrders.QC gt -1>
						OH
					<cfelseif BikeOrders.QOH + BikeOrders.QOO + BikeOrders.QC gt -1>
						OO
					<cfelse>
						NTO
					</cfif>
				</td>
				<td>
					<cfif BikeOrders.bike_status eq "NEW BIKE ORDER">
						NEW
					<cfelseif BikeOrders.bike_status eq "READY TO BUILD">
						RTB
					<cfelseif BikeOrders.bike_status eq "BIKE BUILT">
						BUILT
					</cfif>
				</td>
				<td><cfif len(#BikeOrders.serial_num#)>X</cfif></td>
				<td>#BikeOrders.sp_first_name# #BikeOrders.sp_last_name#</td>
				<td>
					<cfif #BikeOrders.ship_method# eq "" or #BikeOrders.ship_method# eq "14">
						PICKUP
					<cfelseif #BikeOrders.ship_method# eq "4" or #BikeOrders.ship_method# eq "7" or #BikeOrders.ship_method# eq "8" or #BikeOrders.ship_method# eq "13" or #BikeOrders.ship_method# eq "15" or #BikeOrders.ship_method# eq "18" or #BikeOrders.ship_method# eq "21">
						S GROUND
					<cfelse>
						S EXPIDITE
					</cfif>
				</td>
			</tr>
		</cfloop>
	</table>
</cfoutput>