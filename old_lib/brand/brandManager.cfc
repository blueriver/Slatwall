<cfcomponent output="false" name="brandManager" hint="">

	<cffunction name="init" access="public" returntype="any" output="false">
		<cfargument name="brandDAO" type="any" required="yes"/>
		<cfargument name="brandGateway" type="any" required="yes"/>
		
		<cfset variables.DAO=arguments.brandDAO />
		<cfset variables.Gateway=arguments.brandGateway />
	
		<cfreturn this />
	</cffunction>
	
	<cffunction name="read" access="public" returntype="any" output="false">
		<cfargument name="BrandID" required="true" />
		<cfreturn variables.DAO.read(BrandID=Arguments.BrandID) />
	</cffunction>
	
	<cffunction name="getAllBrandsQuery" access="public" returntype="any" output="false">
		<cfreturn variables.Gateway.getAllBrandsQuery() />
	</cffunction>
	
	<cffunction name="getQueryOrganizer" access="public" returntype="any" output="false"> 
		<cfset var QueryOrganizer = application.slat.utilityManager.getNewQueryOrganizer() />
		<cfset QueryOrganizer.addKeywordColumn('BrandName') />
		<cfreturn QueryOrganizer />
	</cffunction> 
	
	<cffunction name="getBrandsQueryByVendorID" access="public" returntype="any" output="false">
		<cfargument name="VendorID" required="true" />
		<cfreturn variables.Gateway.getBrandsQueryByVendorID(VendorID=Arguments.VendorID) />
	</cffunction>
	
	<cffunction name="getBrandIterator" access="public" output="false" returntype="any">
		<cfargument name="BrandQuery" type="any" required="true">
		
		<cfset var brandIterator=createObject("component","brandIterator").init() />
		<cfset brandIterator.setQuery(arguments.BrandQuery) />
		<cfreturn brandIterator />
	</cffunction>
	
</cfcomponent>