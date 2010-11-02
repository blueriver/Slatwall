<cfif isDefined('args.Vendor')>
	<cfset local.BrandsIterator = args.Vendor.getBrandsIterator() />
<cfelse>
	<cfset local.BrandsIterator = application.slat.brandManager.getBrandIterator(request.slat.queryOrganizer.organizeQuery(application.Slat.brandManager.getAllBrandsQuery())) />
</cfif>

<cfoutput>
<div class="svoBrandList">
	<h3 class="tableheader">Brands</h3>
	<table class="listtable">
		<tr>
			<th>Brand</th>
			<th>Brand Website</th>
		</tr>
		<cfloop condition="#local.BrandsIterator.hasNext()#">
			<cfset local.Brand = local.BrandsIterator.Next() />
			<tr>
				<td><a href="#buildURL(action='brand.detail', queryString='BrandID=#local.Brand.getBrandID()#')#">#local.Brand.getBrandName()#</a></td>
				<td>#local.Brand.getBrandWebsite()#</td>
			</tr>
		</cfloop>
	</table>
</div>
</cfoutput>