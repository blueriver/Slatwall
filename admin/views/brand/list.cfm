<cfoutput>
<div class="svobrandlist">
	<h3 class="tableheader">Brands</h3>
	<table class="listtable">
		<tr>
			<th>Brand</th>
			<th>Brand Website</th>
			<th>Administration</th>
		</tr>
		<cfloop array="#rc.BrandSmartList.getEntityArray()#" index="Local.Brand">
			<tr>
				<td><a href="#buildURL(action='admin:brand.detail', queryString='BrandID=#local.Brand.getBrandID()#')#">#local.Brand.getBrandName()#</a></td>
				<td>#local.Brand.getBrandWebsite()#</td>
				<td><a href="#buildURL(action='admin:brand.edit', queryString='BrandID=#local.Brand.getBrandID()#')#">Edit</a></td>
			</tr>
		</cfloop>
	</table>
</div>
</cfoutput>