<cfcomponent output="false" name="skuManager" hint="">
	
	<cffunction name="init" returntype="any" output="false" access="public">
		<cfargument name="skuGateway" type="any" required="yes"/>
		<cfargument name="skuDAO" type="any" required="yes"/>

		<cfset variables.Gateway=arguments.skuGateway />
		<cfset variables.DAO=arguments.skuDAO />
		
		<cfreturn this />
	</cffunction>

	<cffunction name="getSkuIterator" access="public" output="false" returntype="any">
		<cfargument name="SkuQuery" type="any" required="true">
		
		<cfset var skuIterator=createObject("component","skuIterator").init() />
		<cfset skuIterator.setQuery(arguments.SkuQuery) />
		<cfreturn skuIterator />
	</cffunction>

	<cffunction name="read" access="public" returntype="any" output="false">
		<cfargument name="SkuID" type="String" />		
	
		<cfreturn variables.DAO.read(arguments.SkuID) />
	</cffunction>
	
	<cffunction name="getAllSkusQuery" access="public" returntype="any" output="false">
		<cfreturn variables.Gateway.getAllSkusQuery() />
	</cffunction>
	
	<cffunction name="getSkusByProductID" access="public" returntype="any" output="false">
		<cfargument name="ProductID" type="String" />		
	
		<cfreturn variables.Gateway.getSkusByProductID(arguments.ProductID) />
	</cffunction>

	<cffunction name="getBean" access="public" returntype="any" output="false">
		<cfreturn variables.DAO.getBean() />
	</cffunction>

	<cffunction name="getDebug" returnType="any" output="false">
		<cfset var DebugStruct = structNew() />
		<cfset DebugStruct.Variables = variables />
		<cfset DebugStruct.DAO = variables.DAO.getDebug() />
		<cfset DebugStruct.Gateway = variables.gateway.getDebug() />
		<cfreturn DebugStruct />
	</cffunction>
</cfcomponent>