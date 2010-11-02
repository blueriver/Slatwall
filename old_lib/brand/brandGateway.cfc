<cfcomponent output="false" name="brandGanteway" hint="">
	<cffunction name="init" access="public" returntype="any" output="false">
		<cfreturn this />
	</cffunction>
	
	<cffunction name="getAllBrandsQuery" access="package" returntype="query" output="false">
		<cfreturn application.slat.integrationManager.getBrandsQuery() />
	</cffunction>
	
	<cffunction name="getBrandsQueryByVendorID" access="package" returntype="any" output="false">
		<cfargument name="VendorID" required="true" />
		
		<cfset var rs = querynew('empty') />
		<cfset var VendorBrands = application.slat.integrationManager.getVendorBrandsQuery(arguments.VendorID) />
		<cfset var AllBrands = getAllBrandsQuery() />
		<cfquery name="rs" dbtype="query">
			SELECT
				*
			FROM
				AllBrands, VendorBrands
			WHERE
				AllBrands.BrandID = VendorBrands.BrandID
		</cfquery>
		
		<cfreturn rs />
	</cffunction> 
</cfcomponent>