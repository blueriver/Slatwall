<cfcomponent extends="main" output="false">

	<cffunction name="before">
		<cfargument name="rc" />
		
		<cfparam name="rc.ProductID" default="" />
		<cfparam name="rc.ProductName" default="" />
		
		<cfset rc.Product = variables.productService.getByID(rc.ProductID) />
		<cfif not isDefined('rc.Product')>
			<cfset rc.Product = variables.productService.getNewEntity() />
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
	
	<cffunction name="update">
		<cfargument name="rc" />
		
		<cfset rc.Product = variables.fw.populate(cfc=rc.Product, Keys=rc.Product.getUpdateKeys(), trim=true) />
		<cfif rc.Product.getFilename() eq "">
			<cfset rc.Product.setFilename(LCASE(Replace(rc.Product.getProductName()," ","-"))) />
		</cfif>
		<cfset rc.Product = variables.productService.save(entity=rc.Product) />
		<cfset variables.fw.redirect(action='product.detail',queryString='ProductID=#rc.Product.getProductID()#') />
		
	</cffunction>
	
</cfcomponent>