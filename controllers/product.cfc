<cfcomponent extends="main" output="false">

	<cffunction name="before">
		<cfargument name="rc" />
		
		<cfparam name="rc.ProductID" default="" />
		<cfparam name="rc.ProductName" default="" />
		
		<cfif rc.ProductID eq "">
			<cfset rc.Product = variables.productService.getNewEntity() />
		<cfelse>
			<cfset rc.Product = variables.productService.getByID(rc.ProductID) />
		</cfif>
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
	
	<cffunction name="list">
		<cfargument name="rc" />
	
		<cfset rc.ProductSmartList = variables.productService.getSmartList(arguments.rc) />
	</cffunction>
	
	<cffunction name="save">
		<cfargument name="rc" />
		
		<cfset variables.fw.populate(cfc=rc.Product, trustKeys=true, trim=true) />
		<cfset rc.Product = variables.productService.save(entity=rc.Product) />
		<cfset variables.fw.redirect(action='product.detail',queryString='ProductID=#rc.Product.getProductID()#') />
		
	</cffunction>
	
</cfcomponent>