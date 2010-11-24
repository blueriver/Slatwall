<cfoutput>
	<div class="svoadminproductlist">
		<table class="listtable">
			<tr>
				<th>Brand Name</th>
				<th>Year</th>
				<th>Product Name</th>
				<th>Product Code</th>
				<th>Administration</th>
			</tr>
			<cfloop array="#rc.ProductSmartList.getEntityArray()#" index="Local.Product">
				<tr>
					<td><a href="#buildURL(action='brand.detail', queryString='Brand_BrandID=#Local.Product.getBrand().getBrandID()#')#">#Local.Product.getBrand().getBrandName()#</a></td>
					<td>#Local.Product.getProductYear()#</td>
					<td><a href="#buildURL(action='product.detail', queryString='ProductID=#Local.Product.getProductID()#')#">#Local.Product.getProductName()#</a></td>
					<td><a href="#buildURL(action='product.detail', queryString='ProductID=#Local.Product.getProductID()#')#">#Local.Product.getProductCode()#</a></td>
					<td><a href="#buildURL(action='product.edit', queryString='ProductID=#Local.Product.getProductID()#')#">Edit</a></td>
				</tr>
			</cfloop>
		</table>
	</div>
</cfoutput>
