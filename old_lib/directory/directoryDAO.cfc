<cfcomponent output="false" name="directoryDAO" hint="">
	
	<cffunction name="init" access="public" output="false" returntype="Any">
		<cfreturn this />
	</cffunction>
	
	<cffunction name="getBean" access="public" returntype="Any">
		<cfreturn createObject("component","directoryBean").init()>
	</cffunction>
	
	<cffunction name="read" access="package" output="false" retruntype="Any">
		<cfargument name="DirectoryID" type="string" />
	
		<cfset var directoryBean=getBean() />
		<cfset var rs = queryNew('empty') />
		<cfset rs = application.slat.integrationManager.getDirectoryQuery(arguments.DirectoryID) />
		
		<cfif rs.recordcount>
			<cfset DirectoryBean.set(rs) />
		</cfif>

		<cfreturn DirectoryBean />
	</cffunction>
	
	<cffunction name="getDebug" returnType="any" output="false">
		<cfreturn variables />
	</cffunction>
</cfcomponent>