<cfcomponent extends="mura.iterator.queryIterator" output="false">
	
	<cffunction name="packageRecord" access="public" output="false" returntype="any">
		<cfset var product=createObject("component","productBean").init() />
		<cfset product.set(queryRowToStruct(variables.records,currentIndex()))>
		
		<cfreturn product>
	</cffunction>
	
	<cffunction name="getDebug" access="public" output="false" returntype="any">
		<cfreturn variables.records>
	</cffunction>

</cfcomponent>