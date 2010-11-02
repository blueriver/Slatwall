<cfcomponent extends="mura.iterator.queryIterator" name="couponIterator" output="false">
	
	<cffunction name="packageRecord" access="public" output="false" returntype="any">
		<cfset var coupon=createObject("component","couponBean").init() />
		<cfset coupon.set(queryRowToStruct(variables.records,currentIndex()))>
		
		<cfreturn coupon>
	</cffunction>
	
	<cffunction name="getDebug" returnType="any" output="false">
		<cfreturn variables />
	</cffunction>
</cfcomponent>