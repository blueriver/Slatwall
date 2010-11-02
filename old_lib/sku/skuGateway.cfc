<cfcomponent output="false" name="skuGateway" hint="">
	
	<cffunction name="init" access="public" output="false" returntype="Any">
		<cfreturn this />
	</cffunction>
	
	<cffunction name="getAllSkusQuery" access="package" output="false" retruntype="query">
		<cfreturn application.slat.integrationManager.getSkusQuery() />
	</cffunction>
	
	<cffunction name="getSkusByProductID" access="package" output="false" retruntype="query">
		<cfargument name="ProductID" type="string" />

		<cfreturn application.slat.integrationManager.getSkusQuery(ProductID = arguments.ProductID) />
	</cffunction>

	<cffunction name="getDebug" returnType="any" output="false">
		<cfreturn variables />
	</cffunction>
</cfcomponent>