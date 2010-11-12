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
		
		<cfif Left(rc.path,len(request.siteid) + 5) eq '/#request.siteid#/sp/'>
			<cfset rc.Filename = Right( rc.path, len(rc.path)-(len(request.siteid) + 5) ) />
			<cfset rc.Filename = Left(rc.Filename, len(rc.Filename)-1) />
			<cfset request.slatProduct = variables.productService.getByFilename(rc.Filename) />
			<cfset request.contentBean.setTitle(request.slatProduct.getProductName()) />
			<cfset request.contentBean.setBody(request.slatProduct.getProductDescription()) />
			<cfset request.crumbdata = duplicate(session.slat.crumbdata) />
			<cfset request.contentrenderer.crumbdata = duplicate(session.slat.crumbdata) />
		<cfelse>
			<cfset session.slat.crumbdata = duplicate(request.crumbdata) />
		</cfif>
	</cffunction>
	
	<cffunction name="contentproducts">
		<cfargument name="rc">
		<cfset rc.ContentProductSmartList = variables.productService.getSmartList(arguments.rc) />
	</cffunction>

</cfcomponent>