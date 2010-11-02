<cfcomponent output="false" name="poBean" hint="">
	
	<cfset variables.instance.PurchaseOrderID = 0 />
	<cfset variables.instance.PurchaseOrderCode = "" />
	<cfset variables.instance.PurchaseOrderItems = arrayNew(1) />	<!--- ArrayOfComponents --- >
	<cfset variables.instance.Vendor = "" /> 						<!--- Component --->
	
	<cffunction name="init" access="public" returntype="any" output="false">
		<cfreturn this />
	</cffunction>
	
	
	
</cfcomponent>
