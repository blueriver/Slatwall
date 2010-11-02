<cfcomponent extends="main" output="false">

	<cffunction name="before">
		<cfargument name="rc" />
		<cfparam name="rc.ProductID" default="" />
		
	</cffunction>

	<cffunction name="setproductService">
		<cfargument name="productService" />
		<cfset variables.productService = arguments.ProductService />
	</cffunction>
	
	<cffunction name="contentassignment">
		<cfargument name="rc" />
		
		<cfset var I = "">
		
		<cfif isDefined('rc.fieldnames')>
			<cfif isDefined('rc.NewContentAssignmentID')>
				<cfset application.slat.ProductManager.addProductToContent(ProductID=rc.ProductID,ContentID=rc.NewContentAssignmentID) />
			<cfelseif isDefined('rc.RemoveContentID')>
				<cfset application.slat.ProductManager.removeProductFromContent(ProductID=rc.ProductID,ContentID=rc.RemoveContentID) />
			</cfif>
			<cfset variables.fw.redirect(action='product.detail', append='ProductId') />
		</cfif>
		
	</cffunction>
	
	<cffunction name="detail">
		<cfargument name="rc" />
		<cfset rc.Product = variables.productService.getByID(ID=rc.ProductID) />
	</cffunction>
	
	<cffunction name="list">
		<cfargument name="rc" />
	
		<cfset rc.ProductSmartList = variables.productService.getSmartList(arguments.rc) />
	</cffunction>
	
</cfcomponent>