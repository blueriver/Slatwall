<cfcomponent extends="mura.iterator.queryIterator" output="false">
	
	<cffunction name="packageRecord" access="public" output="false" returntype="any">
		<cfset var orderItem=createObject("component","orderItemBean").init() />
		<cfset orderItem.set(queryRowToStruct(variables.records,currentIndex()))>
		
		<cfreturn orderItem>
	</cffunction>

</cfcomponent>