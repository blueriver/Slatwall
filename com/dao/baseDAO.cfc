<cfcomponent displayname="Base DAO" output="false">

	<cffunction name="init">
		<cfreturn this />
	</cffunction>

	<cffunction name="read" output="false">
		<cfargument name="id" type="any" required="yes" />
		<cfargument name="entityName" type="string" required="true" />
		
		<cfreturn entityLoad(arguments.entityName, arguments.id, true) />
	</cffunction>

	<cffunction name="list" output="false">
		<cfargument name="entityName" type="string" required="true" />
		<cfargument name="smartList" type="any" required="false" />
		
		<cfset ReturnList = arrayNew(1) />
		<cfif isDefined('arguments.smartList')>
			<cfset arguments.smartList.setEntityArray(entityLoad(arguments.entityName)) />
			<cfset ReturnList = arguments.SmartList.getEntityArray() />
		<cfelse>
			<cfset ReturnList = entityLoad(arguments.entityName) />
		</cfif>
			 
		<cfreturn entityLoad(arguments.EntityName) />
	</cffunction>

	<cffunction name="delete" output="false">
		<cfargument name="target" type="any" required="true" />

		<cfset EntityDelete(arguments.target) />
	</cffunction>

	<cffunction name="save" output="false">
		<cfargument name="entity" type="any" required="true" />
		
		<cfset EntitySave(arguments.entity, true) />
		
		<cfreturn arguments.entity />
	</cffunction>
	
	<cffunction name="QueryToEntityArray">
		<cfargument name="ResultsQuery" />
		<cfargument name="EntityName" />
		
		<cfset var CurrentRecord = 1 />
		<cfset var Entity = "" />
		<cfset var EntityArray = arrayNew(1) />
		
		<cfloop query="arguments.ResultsQuery">
			<cfset Entity = EntityNew(arguments.EntityName) />
			<cfset Entity.set(arguments.ResultsQuery) />
			<cfset ArrayAppend(EntityArray, Entity) />
		</cfloop>
		
		<cfreturn EntityArray />
	</cffunction>
	
</cfcomponent>