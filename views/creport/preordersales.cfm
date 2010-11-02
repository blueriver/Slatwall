<cfoutput>
	<cfparam name="dashboard" default="NO">
	<div class="subheader">
		<a href="/EmployeeTools/ReportViewer.cfm?report=PreOrderSales&db=#url.db#"><span>Pre-Order Sales</span></a>
	</div>
	<cfquery name="PreOrderSales"  datasource="#application.slatsettings.getSetting('IntegrationDSN')#" username="#application.slatsettings.getSetting('IntegrationDBUsername')#" password="#application.slatsettings.getSetting('IntegrationDBPassword')#">
		select
			max(c.brand) as 'Brand',
			max(c.of2) as 'Year',
			max(c.style) as 'Style',
			max(c.style_id) as 'StyleID',
			max(c.description) as 'Description',
			sum(a.qc) as 'QC',
			sum(a.qoo) as 'QOO',
			max(d.attr1) as 'Color',
			max(e.attr2) as 'Attr2',
			max(f.siz) as 'Size',
			min(a.first_rcvd) as 'FirstRCVD',
			sum(a.qs) as 'QS'
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
	--		(select min(first_rcvd) from tb_sku_buckets where tb_sku_buckets.sku_id = b.sku_id) IS NULL
	--	  and
			(select sum(qc) from tb_sku_buckets where tb_sku_buckets.sku_id = b.sku_id) < 0
		  and
			(select sum(qoo) from tb_sku_buckets inner join tb_skus on tb_sku_buckets.sku_id = tb_skus.sku_id where tb_skus.style_id = c.style_id) > 2
		  and
			(select sum(qc) / sum(qoo) from tb_sku_buckets inner join tb_skus on tb_sku_buckets.sku_id = tb_skus.sku_id where tb_skus.style_id = c.style_id) < -.2
		  and
			c.non_invt = 'N'
		  and
			c.brand <> 'CELERANT'
		group by
			b.sku_id
		order by
			max(c.brand)
	</cfquery>
	<table cellspacing="0" cellpadding="0" class="reporttable">
		<tr>
			<th>Brand</th>
			<th>Year</th>
			<th>Style</th>
			<th>Description</th>
			<th>QC</th>
			<th>QOO</th>
			<th>Color</th>
			<th>Attr2</th>
			<th>Size</th>
			<th>ST</th>
			<th>First Rcvd</th>
			<th>Prior Sold</th>
		</tr>
		<cfloop query="PreOrderSales">
			<tr>

				<td>#PreOrderSales.Brand#</td>
				<td>#PreOrderSales.Year#</td>
				<td><a href="http://www.nytro.com/EmployeeTools/DetailViewer.cfm?detail=Style&sid=#PreOrderSales.StyleID#">#PreOrderSales.Style#</a></td>
				<td><a href="http://www.nytro.com/EmployeeTools/DetailViewer.cfm?detail=Style&sid=#PreOrderSales.StyleID#">#PreOrderSales.Description#</a></td>
				<cfif (PreOrderSales.QC * -1) gt PreOrderSales.QOO - 1>
					<td class="rowred">#(PreOrderSales.QC * -1)#</td>
					<td class="rowred">#PreOrderSales.QOO#</td>
				<cfelse>
					<td>#(PreOrderSales.QC * -1)#</td>
					<td>#PreOrderSales.QOO#</td>
				</cfif>
				<td>#PreOrderSales.Color#</td>
				<td>#PreOrderSales.Attr2#</td>
				<td>#PreOrderSales.Size#</td>
				<cfif PreOrderSales.QOO gt 0>
					<cfif (PreOrderSales.QC * -1)/PreOrderSales.QOO gt .5>
						<td class="rowyellow">#NumberFormat((PreOrderSales.QC * -1)/PreOrderSales.QOO,"9.99")#</td>
					<cfelse>
						<td>#NumberFormat((PreOrderSales.QC * -1)/PreOrderSales.QOO,"9.99")#</td>
					</cfif>
				<cfelse>
					<td class="rowyellow">1.00</td>
				</cfif>
				<td>#DateFormat(PreOrderSales.FirstRCVD,"MM/DD/YYYY")#</td>
				<td>#PreOrderSales.QS#</td>
			</tr>
		</cfloop>
	</table>
</cfoutput>