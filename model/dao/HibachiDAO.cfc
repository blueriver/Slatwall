<cfcomponent accessors="true" output="false" extends="Slatwall.org.Hibachi.HibachiDAO">
	
	<cffunction name="createSlatwallUUID" returntype="string" access="public">
		<cfreturn createHibachiUUID() />
	</cffunction>

</cfcomponent>