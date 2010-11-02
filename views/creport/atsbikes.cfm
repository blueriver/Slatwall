<cfoutput>
	<cfquery name="AvailableBikes"  datasource="#application.slatsettings.getSetting('IntegrationDSN')#" username="#application.slatsettings.getSetting('IntegrationDBUsername')#" password="#application.slatsettings.getSetting('IntegrationDBPassword')#">
		select
			max(c.style) as 'Style',
			max(c.of2) as 'Year',
			max(c.brand) as 'Brand',
			max(c.description) as 'Description',
			max(d.attr1) as 'Color',
			max(e.attr2) as 'Attr2',
			max(f.siz) as 'Size',
			max(a.price) as 'Price',
			sum(qoh) + sum(qc) as 'ATS'
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
			(select sum(qoh) + sum(qc) from tb_sku_buckets where tb_sku_buckets.sku_id = b.sku_id) > 0
		  and
		  	(c.taxonomy_id = '344' or c.taxonomy_id = '345' or c.taxonomy_id = '351' or c.taxonomy_id = '352')
		group by
			b.sku_id
		order by
			max(f.siz) asc,
			max(c.brand) asc,
			max(a.price) asc
	</cfquery>
	
	<cfform>
	<cfgrid name="AvailableBikes" query="AvailableBikes" autoWidth="yes" format="html" />
	</cfform>

</cfoutput>









