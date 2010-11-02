<cfcomponent output="false" name="couponGateway" hint="">
	
	<cffunction name="init" returntype="any" output="false" access="public">
				
		<cfreturn this />
	</cffunction>
	
	<cffunction name="getAllCoupons" returntype="query" output="false" access="public">
		<cfreturn application.slat.integrationManager.getAllCouponsQuery()>
	</cffunction>
	
	<cffunction name="getCouponsByCode" returntype="query" output="false" access="public">
		<cfargument name="CouponCode" type="string" required="true">
		
		<cfset AllCoupons = getAllCoupons() />
		<cfquery dbtype="query" name="CouponsByCode">
			SELECT
				*
			FROM
				AllCoupons
			WHERE
				LOWER(CouponCode) = '#LCase(arguments.CouponCode)#'
		</cfquery>
		
		<cfreturn CouponsByCode>
	</cffunction>
	
	<cffunction name="getDebug" returnType="any" output="false">
		<cfreturn variables />
	</cffunction>
</cfcomponent>