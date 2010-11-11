<cfcomponent extends="main" output="false">

	<cffunction name="setproductService">
		<cfargument name="productService" />
		<cfset variables.productService = arguments.ProductService />
	</cffunction>
	
	<cffunction name="before">
		<cfset request.layout = false />
	</cffunction>
	
	<cffunction name="contentproducts">
		<cfargument name="rc">
		<cfset rc.ContentProductSmartList = variables.productService.getSmartList(arguments.rc) />
	</cffunction>
</cfcomponent>