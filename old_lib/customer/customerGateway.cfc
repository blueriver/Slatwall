<cfcomponent output="false" name="customerGateway" hint="">
	<cffunction name="init" access="public" returntype="any" output="false">
		<cfreturn this />
	</cffunction>
	
	<cffunction name="getAllCustomersQuery" access="package" output="false" retruntype="query">
		<cfreturn application.Slat.integrationManager.getCustomerQuery() />
	</cffunction>
	
</cfcomponent>
