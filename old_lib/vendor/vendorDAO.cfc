<cfcomponent output="false" name="vendorDAO" hint="">
	
	<cffunction name="init" access="public" output="false" returntype="Any">
		<cfreturn this />
	</cffunction>
	
	<cffunction name="getBean" access="public" returntype="Any">
		<cfreturn createObject("component","vendorBean").init()>
	</cffunction>
	
	<cffunction name="read" access="package" output="false" retruntype="Any">
		<cfargument name="VendorID" type="string" />
	
		<cfset var vendorBean=getBean() />
		<cfset var rs = queryNew('empty') />
		<cfset rs = application.slat.integrationManager.getVendorsQuery(arguments.VendorID) />
		
		<cfif rs.recordcount>
			<cfset vendorBean.set(rs) />
		</cfif>

		<cfreturn vendorBean />
	</cffunction>
	
	<cffunction name="getDebug" returnType="any" output="false">
		<cfreturn variables />
	</cffunction>
</cfcomponent>