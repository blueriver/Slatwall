<cfcomponent output="false" name="directoryGateway" hint="" extends="slat.lib.coregateway">
	
	<cffunction name="init" access="public" output="false" returntype="Any">
		<cfreturn this />
	</cffunction>
	
	<cffunction name="getEntireDirectoryQuery" access="package" output="false" retruntype="query">
		<cfreturn application.Slat.integrationManager.getDirectoryQuery() />
	</cffunction>
	
	<cffunction name="getDirectoryQueryByVendorID" access="package" returntype="any" output="false">
		<cfargument name="VendorID" required="true" />
		
		<cfset var rs = querynew('empty') />
		<cfset var VendorDirectoryQuery = application.slat.integrationManager.getVendorDirectoryQuery(VendorID = arguments.VendorID) />
		<cfset var EntireDirectoryQuery = getEntireDirectoryQuery() />
		
		<cfquery name="rs" dbtype="query">
			SELECT
				*
			FROM
				EntireDirectoryQuery, VendorDirectoryQuery
			WHERE
				EntireDirectoryQuery.DirectoryID = VendorDirectoryQuery.DirectoryID
		</cfquery>
		
		<cfreturn rs />
	</cffunction>
	
	<cffunction name="getDebug" returnType="any" output="false">
		<cfreturn variables />
	</cffunction>
</cfcomponent>