<cfcomponent output="false" name="vendorGateway" hint="" extends="slat.lib.coregateway">
	
	<cffunction name="init" access="public" output="false" returntype="Any">
		<cfreturn this />
	</cffunction>
	
	<cffunction name="getAllVendorsQuery" access="package" output="false" retruntype="query">
		<cfreturn application.Slat.integrationManager.getVendorsQuery() />
	</cffunction>
	
	<cffunction name="getVendorsQueryByBrandID" access="package" returntype="any" output="false">
		<cfargument name="BrandID" required="true" />
		
		<cfset var rs = querynew('empty') />
		<cfset var VendorBrands = application.slat.integrationManager.getVendorBrandsQuery(BrandID = arguments.BrandID) />
		<cfset var AllVendors = getAllVendorsQuery() />
		
		<cfquery name="rs" dbtype="query">
			SELECT
				*
			FROM
				AllVendors, VendorBrands
			WHERE
				AllVendors.VendorID = VendorBrands.VendorID
		</cfquery>
		
		<cfreturn rs />
	</cffunction>
	
	<cffunction name="getDebug" returnType="any" output="false">
		<cfreturn variables />
	</cffunction>
</cfcomponent>