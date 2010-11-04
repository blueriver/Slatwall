<cfparam name="args.HiddenColumns" default="" />

<cfoutput>
<div class="svoproductlist">
	<h3 class="tableheader">Products</h3>
	<table class="listtable">
		<tr>
			<cfif not listFind(args.HiddenColumns,'DateLastReceived')><th>Last Received</th></cfif>
			<cfif not listFind(args.HiddenColumns,'BrandName')><th>Brand Name</th></cfif>
			<cfif not listFind(args.HiddenColumns,'ProductYear')><th>Year</th></cfif>
			<cfif not listFind(args.HiddenColumns,'ProductName')><th>Product Name</th></cfif>
			<cfif not listFind(args.HiddenColumns,'ProductCode')><th>Product Code</th></cfif>
		</tr>
		<cfloop array="#rc.ProductSmartList.getEntityArray()#" index="Local.Product">
			<tr>
				<cfif not listFind(args.HiddenColumns,'DateLastReceived')><td>#DateFormat(Local.Product.getDateLastReceived(),"MM/DD/YYYY")# - #TimeFormat(Local.Product.getDateLastReceived(),"HH:MM")#</td></cfif>
				<cfif not listFind(args.HiddenColumns,'BrandName')><td><a href="#buildURL(action='brand.detail', queryString='Brand_BrandID=#Local.Product.getBrand().getBrandID()#')#">#Local.Product.getBrand().getBrandName()#</a></td></cfif>
				<cfif not listFind(args.HiddenColumns,'ProductYear')><td>#Local.Product.getProductYear()#</td></cfif>
				<cfif not listFind(args.HiddenColumns,'ProductName')><td><a href="#buildURL(action='product.detail', queryString='ProductID=#Local.Product.getProductID()#')#">#Local.Product.getProductName()#</a></td></cfif>
				<cfif not listFind(args.HiddenColumns,'ProductCode')><td><a href="#buildURL(action='product.detail', queryString='ProductID=#Local.Product.getProductID()#')#">#Local.Product.getProductCode()#</a></td></cfif>
				<td><a href="#buildURL(action='product.edit', queryString='ProductID=#Local.Product.getProductID()#')#">Edit</a></td>
			</tr>
		</cfloop>
	</table>
</div>
</cfoutput>
<!---

<cfparam name="args.HiddenColumns" default="" />

<cfif isDefined('args.Brand')>
	<cfset local.ProductIterator = args.Brand.getProductsIterator() />
<cfelseif isDefined('args.Vendor')>
	<cfset local.ProductIterator = args.Vendor.getProductsIterator() />
<cfelse>
	<cfset local.ProductOrganizer = application.slat.productManager.getQueryOrganizer() />
	<cfset local.ProductOrganizer.setFromCollection(url) />
	<cfset local.ProductIterator = application.slat.productManager.getProductIterator(local.ProductOrganizer.organizeQuery(application.Slat.productManager.getAllProductsQuery())) />
</cfif>

<cfoutput>
<div class="svoproductlist">
	<h3 class="tableheader">Products</h3>
	<table class="listtable">
		<tr>
			<cfif not listFind(args.HiddenColumns,'DateLastReceived')><th>Last Received</th></cfif>
			<cfif not listFind(args.HiddenColumns,'BrandName')><th>Brand Name</th></cfif>
			<cfif not listFind(args.HiddenColumns,'ProductYear')><th>Year</th></cfif>
			<cfif not listFind(args.HiddenColumns,'ProductName')><th>Product Name</th></cfif>
			<cfif not listFind(args.HiddenColumns,'ProductCode')><th>Product Code</th></cfif>
		</tr>
		<cfloop condition="#Local.ProductIterator.hasNext()#">
			<cfset Local.Product = Local.ProductIterator.Next() />
			<tr>
				<cfif not listFind(args.HiddenColumns,'DateLastReceived')><td>#DateFormat(Local.Product.getDateLastReceived(),"MM/DD/YYYY")# - #TimeFormat(Local.Product.getDateLastReceived(),"HH:MM")#</td></cfif>
				<cfif not listFind(args.HiddenColumns,'BrandName')><td><a href="#buildURL(action='brand.detail', queryString='BrandID=#Local.Product.getBrandID()#')#">#Local.Product.getBrandName()#</a></td></cfif>
				<cfif not listFind(args.HiddenColumns,'ProductYear')><td>#Local.Product.getProductYear()#</td></cfif>
				<cfif not listFind(args.HiddenColumns,'ProductName')><td><a href="#buildURL(action='product.detail', queryString='ProductID=#Local.Product.getProductID()#')#">#Local.Product.getProductName()#</a></td></cfif>
				<cfif not listFind(args.HiddenColumns,'ProductCode')><td><a href="#buildURL(action='product.detail', queryString='ProductID=#Local.Product.getProductID()#')#">#Local.Product.getProductCode()#</a></td></cfif>
			</tr>
		</cfloop>
	</table>
</div>
</cfoutput>

--->