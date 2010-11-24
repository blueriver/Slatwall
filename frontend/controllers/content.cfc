<cfcomponent extends="baseController">

	<cffunction name="setproductService">
		<cfargument name="productService" />
		<cfset variables.productService = arguments.ProductService />
	</cffunction>
	
	<cffunction name="productlist">
		<cfargument name="rc">
		
		<cfset rc.ProductSmartList = variables.productService.getSmartList(arguments.rc) />
	</cffunction>
	
</cfcomponent>