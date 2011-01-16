<cfoutput>
	<div class="ItemDetailMain">
		<cf_PropertyDisplay object="#rc.Brand#" property="BrandName">
		<cf_PropertyDisplay object="#rc.Brand#" property="BrandWebsite">
	</div>
	<p><a href="#buildURL(action='admin:brand.edit', queryString='BrandID=#rc.Brand.getBrandID()#')#">Edit Brand</a></p>
</cfoutput>