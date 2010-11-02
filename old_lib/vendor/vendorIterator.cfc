<cfcomponent extends="mura.iterator.queryIterator" output="false">
	
	<cffunction name="packageRecord" access="public" output="false" returntype="any">
		<cfset var vendor=createObject("component","vendorBean").init() />
		<cfset vendor.set(queryRowToStruct(variables.records,currentIndex()))>
		
		<cfreturn vendor>
	</cffunction>

</cfcomponent>