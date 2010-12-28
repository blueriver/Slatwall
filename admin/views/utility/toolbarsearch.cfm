<cfparam name="args.Keyword" default="" />
<cfif len(args.Keyword)>
	
	<cfset local.ProductsOrganizer = application.slatwall.productManager.getQueryOrganizer() />
	<cfset local.ProductsOrganizer.setKeyword(args.Keyword) />
	<cfset local.ProductsSearch = local.ProductsOrganizer.organizeQuery(application.slatwall.productManager.getAllProductsQuery()) />
	
	<cfset local.VendorsOrganizer = application.slatwall.vendorManager.getQueryOrganizer() />
	<cfset local.VendorsOrganizer.setKeyword(args.Keyword) />
	<cfset local.VendorsSearch = local.VendorsOrganizer.organizeQuery(application.slatwall.vendorManager.getAllVendorsQuery()) />
	
	<cfset local.DirectoryOrganizer = application.slatwall.directoryManager.getQueryOrganizer() />
	<cfset local.DirectoryOrganizer.setKeyword(args.Keyword) />
	<cfset local.DirectorySearch = local.DirectoryOrganizer.organizeQuery(application.slatwall.DirectoryManager.getEntireDirectoryQuery()) />
	
	<cfset local.OrderOrganizer = application.slatwall.orderManager.getQueryOrganizer() />
	<cfset local.OrderOrganizer.setKeyword(args.Keyword) />
	<cfset local.OrderOrganizer.addFilter('IsOpen','1') />
	<cfset local.OrderSearch = local.OrderOrganizer.organizeQuery(application.slatwall.orderManager.getOpenOrdersQuery()) />
	
<!---
	<cfset local.CustomersOrganizer = application.slatwall.customerManager.getQueryOrganizer() />
	<cfset local.CustomersOrganizer.setKeyword(args.Keyword) />
	<cfset local.CustomersSearch = local.CustomersOrganizer.organizeQuery(application.slatwall.customerManager.getAllCustomersQuery()) />
--->
</cfif>
<cfoutput>
	<cfif not len(args.Keyword)> 
		<div class="svoutilitytoolbarsearch" style="display:none;"></div>
	<cfelse>
		<div class="svoutilitytoolbarsearch">
			<ul class="SearchMenu">
				<li class="MenuTop">&nbsp;</li>
				<cfif local.ProductsSearch.recordCount>
					<li class="SearchHeader top"><a href="#buildURL(action='product.list',querystring='Keyword=#args.keyword#')#">Products</a></li>
					<cfloop query="local.ProductsSearch" endrow="5">
						<li class="SearchResult"><a href="#buildURL(action='product.detail',querystring='ProductID=#local.ProductsSearch.ProductID#')#">#local.ProductsSearch.ProductName#</a></li>
					</cfloop>
					<li class="Spacer">&nbsp;</li>
				</cfif>
				<cfif local.VendorsSearch.recordCount>
					<li class="SearchHeader"><a href="#buildURL(action='vendor.list',querystring='Keyword=#args.keyword#')#">Vendors</a></li>
					<cfloop query="local.VendorsSearch" endrow="5">
						<li class="SearchResult"><a href="#buildURL(action='vendor.detail',querystring='VendorID=#local.VendorsSearch.VendorID#')#">#local.VendorsSearch.Company#</a></li>
					</cfloop>
					<li class="Spacer">&nbsp;</li>
				</cfif>
				
				<cfif local.DirectorySearch.recordCount>
					<li class="SearchHeader"><a href="#buildURL(action='directory.list',querystring='Keyword=#args.keyword#')#">Company Directory</a></li>
					<cfloop query="local.DirectorySearch" endrow="5">
						<li class="SearchResult"><a href="#buildURL(action='directory.detail',querystring='DirectoryID=#local.DirectorySearch.DirectoryID#')#">#local.DirectorySearch.FirstName# #local.DirectorySearch.LastName#</a></li>
					</cfloop>
					<li class="Spacer">&nbsp;</li>
				</cfif>
				
				<cfif local.OrderSearch.recordCount>
					<li class="SearchHeader"><a href="#buildURL(action='order.list',querystring='Keyword=#args.keyword#')#">Order</a></li>
					<cfloop query="local.OrderSearch" endrow="5">
						<li class="SearchResult"><a href="#buildURL(action='order.detail',querystring='OrderID=#local.OrderSearch.OrderID#')#">#local.OrderSearch.OrderID#: #local.OrderSearch.CustomerName#</a></li>
					</cfloop>
					<li class="Spacer">&nbsp;</li>
				</cfif>
				
				<!---
				<cfif local.CustomersSearch.recordCount>
					<li class="SearchHeader">Customers</li>
					<cfloop query="local.CustomersSearch" endrow="5">
						<li class="SearchResult"><a href="#buildURL(action='Customer.detail',querystring='CustomerID=#local.CustomersSearch.CustomerID#')#">#local.CustomersSearch.FirstName# #local.CustomersSearch.LastName# #local.CustomersSearch.QOKScore#</a></li>
					</cfloop>
				</cfif>
				--->
				<li class="MenuBottom">&nbsp;</li>
			</ul>
		</div>
	</cfif>
		
</cfoutput>