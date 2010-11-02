<cfcomponent extends="mura.iterator.queryIterator" output="false" name="" hint="">
	
	<cffunction name="packageRecord" access="public" output="false" returntype="any">
		<cfset var customer=createObject("component","customerBean").init() />
		<cfset customer.set(queryRowToStruct(variables.records,currentIndex()))>
		
		<cfreturn customer>
	</cffunction>
	
</cfcomponent>
