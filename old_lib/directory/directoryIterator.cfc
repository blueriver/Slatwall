<cfcomponent extends="mura.iterator.queryIterator" output="false">
	
	<cffunction name="packageRecord" access="public" output="false" returntype="any">
		<cfset var directory=createObject("component","directoryBean").init() />
		<cfset directory.set(queryRowToStruct(variables.records,currentIndex()))>
		
		<cfreturn directory>
	</cffunction>

</cfcomponent>