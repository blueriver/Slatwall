<cfcomponent output="false" name="couponManager" hint="">
	
	<cffunction name="init" returntype="any" output="false" access="public">
		<cfargument name="couponDAO" type="any" required="yes"/>
		<cfargument name="couponGateway" type="any" required="yes"/>
		
		<cfset variables.DAO=arguments.couponDAO />
		<cfset variables.Gateway=arguments.couponGateway />
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="getCouponsByCode" returntype="query" output="false" access="public">
		<cfargument name="CouponCode" type="string" required="true">
		
		<cfreturn variables.Gateway.getCouponsByCode(arguments.CouponCode)>
	</cffunction>
	
	<cffunction name="read" returntype="any" output="false" access="public">
		<cfargument name="CouponID" type="string" required="true">
		
		<cfreturn variables.DAO.read(arguments.CouponID)>
	</cffunction>
	
	<cffunction name="getDebug" returnType="any" output="false">
		<cfset var DebugStruct = structNew() />
		<cfset DebugStruct.Variables = variables />
		<cfset DebugStruct.DAO = variables.DAO.getDebug() />
		<cfset DebugStruct.Gateway = variables.gateway.getDebug() />
		<cfreturn DebugStruct />
	</cffunction>
</cfcomponent>