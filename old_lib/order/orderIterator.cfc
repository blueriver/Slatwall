<cfcomponent extends="mura.iterator.queryIterator" output="false" name="" hint="">
	
	<cffunction name="packageRecord" access="public" output="false" returntype="any">
		<cfset var order=createObject("component","orderBean").init() />
		<cfset order.set(queryRowToStruct(variables.records,currentIndex()))>
		
		<cfreturn order>
	</cffunction>
	
</cfcomponent>