<cfcomponent output="false" name="vendorManager" hint="">
	
	<cffunction name="init" access="public" returntype="any" output="false">
		<cfargument name="vendorDAO" type="any" required="yes"/>
		<cfargument name="vendorGateway" type="any" required="yes"/>
	
		<cfset variables.DAO=arguments.vendorDAO />
		<cfset variables.Gateway=arguments.vendorGateway />
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="read" access="public" returntype="any" output="false">
		<cfargument name="VendorID" type="String" />
	
		<cfreturn variables.DAO.read(arguments.VendorID) />
	</cffunction>
	
	<cffunction name="getAllVendorsQuery" access="public" returntype="query" output="false">
		<cfreturn variables.Gateway.getAllVendorsQuery() />
	</cffunction>
	
	<cffunction name="getQueryOrganizer" access="public" returntype="any" output="false"> 
		<cfset var QueryOrganizer = application.slat.utilityManager.getNewQueryOrganizer() />
		<cfset QueryOrganizer.addKeywordColumn('Company',5) />
		<cfset QueryOrganizer.addKeywordColumn('FirstName') />
		<cfset QueryOrganizer.addKeywordColumn('LastName') />
		<cfset QueryOrganizer.addKeywordColumn('PrimaryPhone') />
		<cfset QueryOrganizer.addKeywordColumn('PrimaryEMail') />
		<cfreturn QueryOrganizer />
	</cffunction>
	
	<cffunction name="getVendorsQueryByBrandID" access="public" returntype="any" output="false">
		<cfargument name="BrandID" required="true" />
		<cfreturn variables.Gateway.getVendorsQueryByBrandID(BrandID=Arguments.BrandID) />
	</cffunction>
	
	<cffunction name="getVendorIterator" access="public" output="false" returntype="any">
		<cfargument name="VendorQuery" type="any" required="true">
		
		<cfset var vendorIterator=createObject("component","vendorIterator").init() />
		<cfset vendorIterator.setQuery(arguments.VendorQuery) />
		<cfreturn vendorIterator />
	</cffunction>
	
</cfcomponent>
