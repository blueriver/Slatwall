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
			
			<!--- Setup Product in Request Scope --->
			<cfset request.muraScope.slatwall.Product = variables.productService.getByFilename(rc.Filename) />
			
			<!--- Force Product Information into Content Bean --->
			<cfset request.contentBean.setTitle(request.muraScope.slatwall.Product.getProductName()) />
			<cfset request.contentBean.setBody(request.muraScope.slatwall.Product.getProductDescription()) />
			
			<!--- Overright crumbdata with the last page that was loaded --->
			<cfset request.crumbdata = duplicate(session.slat.crumbdata) />
			<cfset request.contentrenderer.crumbdata = duplicate(session.slat.crumbdata) />
			
			<!--- Set template based on Product Template --->
			<cfif request.muraScope.slatwall.Product.getTemplate() neq ''>
				<cfset request.contentBean.setTemplate(request.muraScope.slatwall.Product.getTemplate()) />
			</cfif>
		<cfelse>
			<cfset session.slat.crumbdata = duplicate(request.crumbdata) />
		</cfif>
	</cffunction>
	
	<cffunction name="contentproducts">
		<cfargument name="rc">
		<cfset rc.ContentProductSmartList = variables.productService.getSmartList(arguments.rc) />
	</cffunction>

</cfcomponent>