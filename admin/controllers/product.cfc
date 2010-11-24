<cfcomponent extends="baseController" output="false">

	<cffunction name="before">
		<cfargument name="rc" />
		
		<cfparam name="rc.ProductID" default="" />
		
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
		
		<!--- Setup Products Filename --->
		<cfif rc.Product.getFilename() eq "">
			<cfset rc.Product.setFilename(rc.Product.getProductName()) />
		</cfif>
		<cfset rc.Product.setFilename(LCASE(REReplaceNoCase(Replace(rc.Product.getFilename()," ","-","all"),"[^A-Z|\-]","","all"))) />
		
		<!--- Save Product --->
		<cfset rc.Product = variables.productService.save(entity=rc.Product) />
		<cfset variables.fw.redirect(action='product.detail',queryString='ProductID=#rc.Product.getProductID()#') />
	</cffunction>
	
	<cffunction name="edit">
		<cfargument name="rc" />
		<cfset rc.ProductTemplatesQuery = variables.productService.getProductTemplates() />
	</cffunction>
	
</cfcomponent>