<cfcomponent output="false" name="customerDAO" hint="">
	<cffunction name="init" access="public" returntype="any" output="false">
		<cfreturn this />
	</cffunction>
	
	<cffunction name="getBean" access="public" returntype="Any">
		<cfreturn createObject("component","customerBean").init()>
	</cffunction>
	
	<cffunction name="read" access="package" output="false" retruntype="Any">
		<cfargument name="CustomerID" type="string" />
	
		<cfset var customerBean=getBean() />
		<cfset var rs = queryNew('empty') />
		<cfset rs = application.slat.integrationManager.getCustomerQuery(arguments.CustomerID) />
		
		<cfif rs.recordcount>
			<cfset customerBean.set(rs) />
		</cfif>

		<cfreturn customerBean />
	</cffunction>

</cfcomponent>
