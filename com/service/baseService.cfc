<cfcomponent displayname="BaseService" accessors="true" hint="This is a base service that all services will extend">
	
	<cfproperty name="DAO" type="any" />
	
	<cfset variables.entityName = "" />
	
	<cffunction name="init">
		<cfreturn this />
	</cffunction>
	
	<cffunction name="getByID" access="public" returntype="any" output="false">
		<cfargument name="ID" type="string" required="false" default="0" />
		<cfreturn getDAO().read(arguments.ID,variables.entityName) />
	</cffunction>
	
	<cffunction name="getNewEntity" access="public" returntype="any" output="false">
		<cfset var entity = entityNew(variables.entityName) />
		<cfset entity.init(argumentcollection=arguments) />
		<cfreturn entity />
	</cffunction>
		
	<cffunction name="delete" access="public" returntype="void" output="false">
		<cfargument name="entity" type="any" required="true" />
		
		<cfreturn getDAO().delete(arguments.entity, arguments.flush) />
	</cffunction>
</cfcomponent>