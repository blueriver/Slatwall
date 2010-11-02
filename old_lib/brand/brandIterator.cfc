<cfcomponent extends="mura.iterator.queryIterator" name="brandIterator" output="false" hint="">
	
	<cffunction name="packageRecord" access="public" output="false" returntype="any">
		<cfset var brand=createObject("component","brandBean").init() />
		<cfset brand.set(queryRowToStruct(variables.records,currentIndex()))>
		
		<cfreturn brand>
	</cffunction>
</cfcomponent>
