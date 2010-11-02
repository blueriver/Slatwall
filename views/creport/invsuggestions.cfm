<cfoutput>
	<cftry>
	<cfquery name="InventorySuggestions"  datasource="#application.slatsettings.getSetting('IntegrationDSN')#" username="#application.slatsettings.getSetting('IntegrationDBUsername')#" password="#application.slatsettings.getSetting('IntegrationDBPassword')#">
		select
			max(c.style) as 'Style',
			max(c.brand) as 'Brand',
			max(c.description) as 'Description',
			isnull(max(d.attr1),'') as 'Color',
			isnull(max(e.attr2),'') as 'Att2',
			isnull(max(f.siz),'') as 'Size',
			sum(a.qs) as 'QS',
			sum(a.qoh) as 'QOH',
			sum(a.qc) as 'QC',
			CASE
				WHEN sum(a.qoh)+sum(a.qc) > 0 THEN round((sum(a.qoh)+sum(a.qc)) /(sum(a.qs) / DateDiff("d",min(a.first_rcvd),getDate())),0)
				ELSE 0
			END as 'DaysLeftOfStock',
			sum(a.qoo) as 'QOO',
			avg(a.opti) as 'MMMax',
			avg(a.mini) as 'MMMin',	
			round((sum(a.qs) / DateDiff("d",min(a.first_rcvd),getDate())),2) as 'SoldPerDay',	
			round(sum(a.qs) / DateDiff("d",min(a.first_rcvd),getDate())*7,0) as 'SoldPerWeek',
			round(sum(a.qs) / DateDiff("d",min(a.first_rcvd),getDate())*30,0) as 'SoldPerMonth',
			min(a.first_rcvd) as 'FirstRecieved',
			round(DateDiff("d",min(a.first_rcvd),getDate()),0) as 'DaysInStock',
			round(DateDiff("d",min(a.first_rcvd),getDate())/7,0) as 'WeeksInStock',	
			round(DateDiff("d",min(a.first_rcvd),getDate())/30,0) as 'MonthsInStock'
		from
			tb_sku_buckets a
		  inner join
			tb_skus b on a.sku_id = b.sku_id
		  inner join
			tb_styles c on b.style_id = c.style_id
		  left join
			tb_attr1_entries d on b.attr1_entry_id = d.attr1_entry_id
		  left join
			tb_attr2_entries e on b.attr2_entry_id = e.attr2_entry_id
		  left join
			tb_size_entries f on b.scale_entry_id = f.scale_entry_id
		where
			not exists(select sku_id from tb_item_makeup_skus where sku_id = b.sku_id)
		  and
			(select sum(qs) from tb_sku_buckets where tb_sku_buckets.sku_id = b.sku_id) > 2
		  and
			(select min(first_rcvd) from tb_sku_buckets where tb_sku_buckets.sku_id = b.sku_id) IS NOT NULL
		  and
			(c.of6 <> 'DISCONTINUED' or c.of6 IS NULL)
		  and
			c.brand <> 'CELERANT'
		group by
			b.sku_id
		order by
			(sum(a.qoh)+sum(a.qc))/(sum(a.qs) / DateDiff("d",min(a.first_rcvd),getDate())) asc,
			sum(a.qs) / DateDiff("d",min(a.first_rcvd),getDate()) desc
	</cfquery>
	<cfquery dbtype="query" name="InventorySuggestionsFiltered">
		select
			*
		from
			InventorySuggestions
		where
			soldperweek > 0
		  and
		  	qoo = 0
		  and
		  	MMMin = 0
		  and
		  	MMMax = 0
		  and
		  	DaysLeftOfStock < 30
	</cfquery>
	<table cellspacing="0" cellpadding="0" class="listtable">
		<tr>
			<th>Style</th>
			<th>Brand</th>
			<th>Description</th>
			<th>Color</th>
			<th>Att2</th>
			<th>Size</th>
			<th>QS</th>
			<th>QOH</th>
			<th>QC</th>
			<th>D Left</th>
			<th>S/Day</th>
			<th>S/Week</th>
			<th>FirstRecieved</th>
			<th>M/Stock</th>
		</tr>
	<cfloop query="InventorySuggestionsFiltered">
		<tr>
			<td>#InventorySuggestionsFiltered.Style#</td>
			<td>#InventorySuggestionsFiltered.Brand#</td>
			<td>#InventorySuggestionsFiltered.Description#</td>
			<td>#InventorySuggestionsFiltered.Color#</td>
			<td>#InventorySuggestionsFiltered.Att2#</td>
			<td>#InventorySuggestionsFiltered.Size#</td>
			<td>#InventorySuggestionsFiltered.QS#</td>
			<td>#InventorySuggestionsFiltered.QOH#</td>
			<td>#InventorySuggestionsFiltered.QC#</td>
			<td>#InventorySuggestionsFiltered.DaysLeftOfStock#</td>
			<td>#InventorySuggestionsFiltered.SoldPerDay#</td>
			<td>#InventorySuggestionsFiltered.SoldPerWeek#</td>
			<td>#DateFormat(InventorySuggestionsFiltered.FirstRecieved,"MM/DD/YYYY")#</td>
			<td>#InventorySuggestionsFiltered.MonthsInStock#</td>
		</tr>
	</cfloop>
	</table>
	

		<cfcatch><Cfdump var="#cfcatch#"></cfcatch>
	</cftry>
</cfoutput>