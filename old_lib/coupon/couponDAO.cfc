<cfcomponent output="false" name="couponDAO" hint="">
	
	<cffunction name="init" access="public" output="false" returntype="Any">
		<cfreturn this />
	</cffunction>
	
	<cffunction name="getBean" access="public" returntype="Any">
		<cfreturn createObject("component","couponBean").init()>
	</cffunction>
	
	<cffunction name="read" access="package" output="false" retruntype="Any">
		<cfargument name="CouponID" type="string" />
	
		<cfset var couponBean=getBean() />
		<cfset var rs = application.slat.integrationManager.getCouponQuery(arguments.CouponID) />
		
		<cfif rs.recordcount>
			<cfset couponBean.set(rs) />
		</cfif>

		<cfreturn couponBean />
	</cffunction>
	
	<cffunction name="getDebug" returnType="any" output="false">
		<cfreturn variables />
	</cffunction>
	
</cfcomponent>