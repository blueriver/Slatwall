<cfcomponent output="false" name="skuDAO" hint="">
	
	<cffunction name="init" access="public" output="false" returntype="Any">
		<cfreturn this />
	</cffunction>
	
	<cffunction name="getBean" access="public" returntype="Any">
		<cfreturn createObject("component","skuBean").init()>
	</cffunction>
	
	<cffunction name="read" access="package" output="false" retruntype="Any">
		<cfargument name="SkuID" type="string" />
		
		<cfset var skuBean = getBean() /> 
		<cfset var rs = queryNew('empty') />
		<cfset rs = application.slat.integrationManager.getSkusQuery(SkuID = arguments.SkuID) />
		
		<cfif rs.recordcount>
			<cfset skuBean.set(rs) />
		</cfif>

		<cfreturn skuBean />
	</cffunction>
	
	<cffunction name="getDebug" returnType="any" output="false">
		<cfreturn variables />
	</cffunction>
	
</cfcomponent>