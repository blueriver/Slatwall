<cfcomponent extends="main" output="false">

	<cffunction name="setproductService">
		<cfargument name="productService" />
		<cfset variables.productService = arguments.ProductService />
	</cffunction>
	
	<cffunction name="before">
		<cfargument name="rc" />
		
		<cfset request.layout = false />
	</cffunction>
	
	<cffunction name="onsiterequeststart">
		<cfargument name="rc" />
		
	</cffunction>
	
	<cffunction name="onrenderstart">
		<cfargument name="rc" />
		
		<cfif Left(rc.path,12) eq '/default/sp/'>
			<cfset request.slatProduct = variables.productService.getByHTMLTitle(rc.ProductID) />
			<cfset request.contentBean.setTitle('THIS IS A TEST') />		
		</cfif>
	</cffunction>
	
	<cffunction name="contentproducts">
		<cfargument name="rc">
		<cfset rc.ContentProductSmartList = variables.productService.getSmartList(arguments.rc) />
	</cffunction>

</cfcomponent>