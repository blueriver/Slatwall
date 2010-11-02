<cfcomponent output="false" name="integrationManager">

	<cffunction name="init" returntype="any" output="false" access="public">
		<cfargument name="integrationCelerant" type="any" required="yes"/>
		<cfargument name="integrationQuickbooks" type="any" required="yes"/>
		<cfargument name="integrationSlatwall" type="any" required="yes"/>
		
		<cfset variables.integration = arguments.integrationSlatwall />
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="setIntegration" access="public" returntype="void" output="false">
		<cfargument name="integrationType" required="true" />
		<cfset variables.integration = createObject('Component', 'integration#arguments.IntegrationType#') />
	</cffunction>
	
	<cffunction name="getAllProductsQuery" access="public" returntype="query" output="false">
		
		<cfreturn variables.integration.getAllProductsQuery() />
	</cffunction>
	
	<cffunction name="getProductQuery" access="public" returntype="query" output="false">
		<cfargument name="ProductID" type="String" />
		
		<cfreturn variables.integration.getProductQuery(arguments.ProductID) />
	</cffunction>
	
	<cffunction name="getSkusQuery" access="public" returntype="query" output="false">
		<cfargument name="SkuID" type="String" />
		<cfargument name="ProductID" type="String" />
		
		<cfset var rs = queryNew('empty') />
		
		<cfif isDefined('arguments.SkuID')>
			<cfset rs = variables.integration.getSkusQuery(SkuID=arguments.SkuID) />
		<cfelseif isDefined('arguments.ProductID')>
			<cfset rs = variables.integration.getSkusQuery(ProductID=arguments.ProductID) />
		<cfelse>
			<cfset rs = variables.integration.getSkusQuery() />
		</cfif>
		
		<cfreturn rs />
	</cffunction>

	<cffunction name="getGiftCardBalanceQuery" access="public" returntype="query" output="false">
		<cfargument name="GiftCardID" type="String" />
		
		<cfreturn variables.integration.getGiftCardBalanceQuery(arguments.GiftCardID) />
	</cffunction>
	
	<cffunction name="getCouponQuery" access="public" returntype="query" output="false">
		<cfargument name="CouponID" type="String" />
		
		<cfreturn variables.integration.getCouponQuery(arguments.CouponID) />
	</cffunction>
	
	<cffunction name="getAllCouponsQuery" access="public" returntype="any" output="false">
		
		<cfreturn variables.integration.getAllCouponsQuery() />
	</cffunction>
	
	<cffunction name="getVendorsQuery" access="public" returntype="query" output="false">
		<cfargument name="VendorID" type="String" />
		<cfset var rs = queryNew('empty') />
		
		<cfif isDefined('arguments.VendorID')>
			<cfset rs = variables.integration.getVendorsQuery(arguments.VendorID) />
		<cfelse>
			<cfset rs = variables.integration.getVendorsQuery() />
		</cfif>
		
		<cfreturn rs />
	</cffunction>
	
	<cffunction name="getVendorBrandsQuery" access="public" returntype="any" output="false">
		<cfargument name="VendorID" type="String" required="false" />
		<cfargument name="BrandID" type="String" required="false">
		<cfset var rs = queryNew('empty') />
		
		<cfif isDefined('arguments.VendorID')>
			<cfset rs = variables.integration.getVendorBrandsQuery(VendorID = arguments.VendorID) />
		<cfelse>
			<cfset rs = variables.integration.getVendorBrandsQuery(BrandID = arguments.BrandID) />
		</cfif>
		
		<cfreturn rs />
	</cffunction>
	
	<cffunction name="getBrandsQuery" access="public" returntype="any" output="false">
		<cfargument name="BrandID" type="String" required="false" />
		<cfset var rs = queryNew('empty') />
		<cfif isDefined('arguments.BrandID')>
			<cfset rs = variables.integration.getBrandsQuery(arguments.BrandID) />
		<cfelse>
			<cfset rs = variables.integration.getBrandsQuery() />
		</cfif>
		<cfreturn rs />
	</cffunction>
	
	<cffunction name="getVendorDirectoryQuery" access="public" returntype="any" output="false">
		<cfargument name="DirectoryID" type="String" required="false" />
		<cfargument name="VendorID" type="String" required="false" />
		<cfset var rs = queryNew('empty') />
		
		<cfif isDefined('arguments.DirectoryID')>
			<cfset rs = variables.integration.getVendorDirectoryQuery(DirectoryID = arguments.DirectoryID) />
		<cfelse>
			<cfset rs = variables.integration.getVendorDirectoryQuery(VendorID = arguments.VendorID) />
		</cfif>
		<cfreturn rs />
	</cffunction>
	
	<cffunction name="getDirectoryQuery" access="public" returntype="any" output="false">
		<cfargument name="DirectoryID" type="String" required="false" />
		<cfset var rs = queryNew('empty') />
		<cfif isDefined('arguments.DirectoryID')>
			<cfset rs = variables.integration.getDirectoryQuery(arguments.DirectoryID) />
		<cfelse>
			<cfset rs = variables.integration.getDirectoryQuery() />
		</cfif>
		<cfreturn rs />
	</cffunction>
	
	<cffunction name="getCustomerQuery" access="public" returntype="any" output="false">
		<cfargument name="CustomerID" type="String" required="false" />
		<cfset var rs = queryNew('empty') />
		<cfif isDefined('arguments.CustomerID')>
			<cfset rs = variables.integration.getCustomerQuery(arguments.CustomerID) />
		<cfelse>
			<cfset rs = variables.integration.getCustomerQuery() />
		</cfif>
		<cfreturn rs />
	</cffunction>
	
	<cffunction name="getOrderQuery" access="public" returntype="any" output="false">
		<cfargument name="OrderID" type="String" required="false" />
		<cfargument name="IsOpen" type="String" required="false" />
		
		<cfset var rs = queryNew('empty') />
		<cfif isDefined('arguments.OrderID')>
			<cfset rs = variables.integration.getOrderQuery(OrderID = arguments.OrderID) />
		<cfelseif isDefined('arguments.IsOpen')>
			<cfset rs = variables.integration.getOrderQuery(IsOpen = 1) />
		<cfelse>
			<cfset rs = variables.integration.getOrderQuery() />
		</cfif>
		<cfreturn rs />
	</cffunction>
	
	<cffunction name="getOrderItemsQuery" access="public" returntype="any" output="false">
		<cfargument name="OrderID" type="String" required="false" />
		<cfargument name="IsOpen" type="numeric" required="false" />
		
		<cfset var rs = queryNew('empty') />
		<cfif isDefined('arguments.OrderID')>
			<cfset rs = variables.integration.getOrderItemsQuery(OrderID = arguments.OrderID) />
		<cfelse>
			<cfset rs = variables.integration.getOrderItemsQuery(IsOpen = arguments.IsOpen) />
		</cfif>
		<cfreturn rs />
	</cffunction>
	
	<cffunction name="insertNewOrder" access="public" returntype="any" output="false">
		<cfargument name="Order" type="struct" required="true" />
		
		<cfreturn variables.integration.insertNewOrder(arguments.Order) />
	</cffunction>
	
	<cffunction name="getDebug" returnType="any" output="false">
		<cfset var DebugStruct = structNew() />
		<cfset DebugStruct.Variables = variables />
		<cfset DebugStruct.integration = variables.integration.getDebug() />
		<cfreturn DebugStruct />
	</cffunction>
	
</cfcomponent>