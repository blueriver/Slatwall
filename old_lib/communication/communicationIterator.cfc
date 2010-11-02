<cfcomponent extends="mura.iterator.queryIterator" name="communicationIterator" output="false" hint="">
	
	<cffunction name="packageRecord" access="public" output="false" returntype="any">
		<cfset var communication=createObject("component","communicationBean").init() />
		<cfset communication.set(queryRowToStruct(variables.records,currentIndex()))>
		
		<cfreturn communication>
	</cffunction>
</cfcomponent>
