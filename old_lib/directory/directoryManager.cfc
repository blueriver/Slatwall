<cfcomponent output="false" name="directoryManager" hint="">
	
	<cffunction name="init" access="public" returntype="any" output="false">
		<cfargument name="directoryDAO" type="any" required="yes"/>
		<cfargument name="directoryGateway" type="any" required="yes"/>
	
		<cfset variables.DAO=arguments.directoryDAO />
		<cfset variables.Gateway=arguments.directoryGateway />
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="read" access="public" returntype="any" output="false">
		<cfargument name="DirectoryID" type="String" />
	
		<cfreturn variables.DAO.read(arguments.DirectoryID) />
	</cffunction>
	
	<cffunction name="getEntireDirectoryQuery" access="public" returntype="query" output="false">
		<cfreturn variables.Gateway.getEntireDirectoryQuery() />
	</cffunction>
	
	<cffunction name="getQueryOrganizer" access="public" returntype="any" output="false"> 
		<cfset var QueryOrganizer = application.slat.utilityManager.getNewQueryOrganizer() />
		<cfset QueryOrganizer.addKeywordColumn('Company') />
		<cfset QueryOrganizer.addKeywordColumn('FirstName') />
		<cfset QueryOrganizer.addKeywordColumn('LastName') />
		<cfset QueryOrganizer.addKeywordColumn('PrimaryPhone',2) />
		<cfset QueryOrganizer.addKeywordColumn('PrimaryEMail',2) />
		<cfreturn QueryOrganizer />
	</cffunction>
	
	<cffunction name="getDirectoryQueryByVendorID" access="public" returntype="any" output="false">
		<cfargument name="VendorID" required="true" />
		<cfreturn variables.Gateway.getDirectoryQueryByVendorID(VendorID=Arguments.VendorID) />
	</cffunction>
	
	<cffunction name="getDirectoryIterator" access="public" output="false" returntype="any">
		<cfargument name="DirectoryQuery" type="any" required="true">
		
		<cfset var directoryIterator=createObject("component","directoryIterator").init() />
		<cfset directoryIterator.setQuery(arguments.DirectoryQuery) />
		<cfreturn directoryIterator />
	</cffunction>
	
</cfcomponent>
