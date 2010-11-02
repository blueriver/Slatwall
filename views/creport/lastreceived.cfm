<cfset AllProductsQuery = application.Slat.ProductManager.getAllProductsQuery() />
<cfquery name="AllProductsByDateLastReceived" dbtype="query" maxrows="200">
	Select
		*
	From 
		AllProductsQuery
	Where
		DateLastReceived IS NOT NULL
	Order By DateLastReceived DESC
</cfquery>
<cfset ProductIterator = application.Slat.productManager.getProductIterator(AllProductsByDateLastReceived) />
<cfoutput>
	<table class="listtable">
		<tr>
			<th>Date Received</th>
			<th>Brand</th>
			<th>Product Code</th>
			<th>Year</th>
			<th>Product Name</th>	
		</tr>
		<cfloop condition="#ProductIterator.hasNext()#">
			<cfset Product = ProductIterator.Next() />
			<tr>
				<td>#DateFormat(Product.getDateLastReceived(),"MM/DD")# - #TimeFormat(Product.getDateLastReceived(),"HH:MM")#</td>
				<td>#Product.getBrandName()#</td>
				<td>#Product.getProductCode()#</td>
				<td>#Product.getProductYear()#</td>
				<td>#Product.getProductName()#</td>
			</tr>
		</cfloop>
	</table>
</cfoutput>