<cfcomponent displayname="Base DAO" output="false">

	<cffunction name="init">
		<cfreturn this />
	</cffunction>

	<cffunction name="read" output="false">
		<cfargument name="id" type="any" required="yes" />
		<cfargument name="entityName" type="string" required="true" />
		
		<cfreturn entityLoad(arguments.entityName, arguments.id, true) />
	</cffunction>
	
	<cffunction name="readByFilename" output="false">
		<cfargument name="Filename" type="string" required="yes" />
		<cfargument name="entityName" type="string" required="true" />
		
		<cfset var HQL = " from #arguments.entityName# where filename = '#arguments.Filename#'" />
		<cfreturn ormExecuteQuery(HQL, true) />
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
		
		<cfset var Property = 0 />
		<cfset var MetaData = getMetadata(arguments.entity) />
		
		<cfloop array="#MetaData.Properties#" index="Property">
			<cfif Property.Name eq 'DateCreated'>
				<cfif arguments.entity.getDateCreated() eq ''>
					<cfset arguments.entity.setDateCreated(now()) />
				</cfif>
			<cfelseif Property.Name eq 'DateUpdated'>
				<cfset arguments.entity.setDateUpdated(now()) />
			</cfif>
		</cfloop>
		
		<cfset EntitySave(arguments.entity) />
		
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