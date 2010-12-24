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
					<td>
						<a href="#buildURL(action='admin:brand.detail', queryString='brandID=#Local.Product.getBrand().getBrandID()#')#">
						#Local.Product.getBrand().getBrandName()#
						</a>
					</td>
					<td>#Local.Product.getProductYear()#</td>
					<td><a href="#buildURL(action='admin:product.detail', queryString='productID=#Local.Product.getProductID()#')#">#Local.Product.getProductName()#</a></td>
					<td><a href="#buildURL(action='admin:product.detail', queryString='productID=#Local.Product.getProductID()#')#">#Local.Product.getProductCode()#</a></td>
					<td><a href="#buildURL(action='admin:product.edit', queryString='productID=#Local.Product.getProductID()#')#">Edit</a></td>
				</tr>
			</cfloop>
		</table>
	</div>
</cfoutput>
