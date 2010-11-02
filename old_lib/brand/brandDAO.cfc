<cfcomponent output="false" name="brandDAO" hint="">
	<cffunction name="init" access="public" returntype="any" output="false">
		<cfreturn this />
	</cffunction>
	
	<cffunction name="getBean" access="public" returntype="Any">
		<cfreturn createObject("component","brandBean").init()>
	</cffunction>
	
	<cffunction name="read" access="package" output="false" retruntype="Any">
		<cfargument name="BrandID" type="string" />
	
		<cfset var brandBean=getBean() />
		<cfset var rs = queryNew('empty') />
		<cfset rs = application.slat.integrationManager.getBrandsQuery(arguments.BrandID) />
		
		<cfif rs.recordcount>
			<cfset brandBean.set(rs) />
		</cfif>

		<cfreturn brandBean />
	</cffunction>
</cfcomponent>