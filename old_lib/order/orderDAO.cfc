<cfcomponent output="false" name="orderDAO" hint="">
	<cffunction name="init" access="public" returntype="any" output="false">
		<cfreturn this />
	</cffunction>
	
	<cffunction name="getBean" access="public" returntype="Any">
		<cfreturn createObject("component","orderBean").init()>
	</cffunction>
	
	<cffunction name="read" access="package" output="false" retruntype="Any">
		<cfargument name="OrderID" type="string" />
	
		<cfset var orderBean=getBean() />
		<cfset var rs = queryNew('empty') />
		<cfset rs = application.slat.integrationManager.getOrderQuery(arguments.OrderID) />
		
		<cfif rs.recordcount>
			<cfset orderBean.set(rs) />
		</cfif>

		<cfreturn orderBean />
	</cffunction>
</cfcomponent>
