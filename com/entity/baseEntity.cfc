<cfcomponent displayname="baseEntity" accessors="true">

	<cfproperty name="SearchScore" persistent="false" default=0 />
	<cfproperty name="UpdateKeys" persistent="false" default="" />
	
	<cffunction name="init">
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="getUpdateKeys">
		<cfset var MetaData = 0 />
		<cfset var Property = 0 />
		
		<cfif not isDefined('variables.UpdateKeys')>
			<cfset MetaData = getMetadata( this ) />
			<cfset variables.UpdateKeys = "" />		
			<cfloop array="#MetaData.Properties#" index="Property">
				<cfif not isDefined('Property.FieldType')>
					<cfif not isDefined('Property.Persistant') or Property.Persistant eq true>
						<cfset variables.UpdateKeys = "#variables.UpdateKeys#,#Property.Name#" />
					</cfif>
				</cfif> 
			</cfloop>
			<cfif len(variables.UpdateKeys)>
				<cfset variables.UpdateKeys = left(variables.UpdateKeys,len(variables.UpdateKeys)-1) />
			</cfif>
		</cfif>
		
		<cfreturn variables.UpdateKeys />
	</cffunction>
	
	<cffunction name="set" returntype="void">
		<cfargument name="record" type="any" required="true">
		
		<cfset var I = "" />
		<cfset var II = "" />
		<cfset var KeyList = "" />
		<cfset var KeysArray = arrayNew(1) />
		<cfset var EvalString = "" />

		<cfif isquery(arguments.record)>
			<cfset KeyList = arguments.record.ColumnList />
		<cfelseif isStruct(arguments.record)>
			<cfset KeyList = structKeyList(arguments.record) />
		</cfif>

		<cfloop list="#KeyList#" index="I">
			<cfset EvalString = "" />
			<cfset KeysArray = ListToArray(I,"_") />
			<cfloop from="1" to="#arrayLen(KeysArray)#" index="II">
				<cfif II eq arrayLen(KeysArray)>
					<cfset EvalString = "#EvalString#set#KeysArray[II]#(arguments.record.#I#)" />
				<cfelse>
					<cfset EvalString = "#EvalString#get#KeysArray[II]#()." />
				</cfif>
			</cfloop>
			<cftry>
				<cfset evaluate("#EvalString#") />
				<cfcatch><cfdump var="#cfcatch#" /><cfabort />
				</cfcatch>
			</cftry>
		</cfloop>
	</cffunction>
	
	<cffunction name="getService">
		<cfargument name="service">
		<cfreturn application.slatwall.pluginConfig.getApplication().getValue("serviceFactory").getBean("#arguments.service#") />
	</cffunction>
	
</cfcomponent>
