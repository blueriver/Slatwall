<cfcomponent displayname="baseEntity" accessors="true">

	<cfproperty name="SearchScore" persistent="false" default=0 />
	<cfproperty name="UpdateKeys" persistent="false" default="" />
	
	<cffunction name="init">
		<cfreturn this />
	</cffunction>
	
	<!---
	
	<cffunction name="save" returntype="void">
		<cfset entitySave(this) />
	</cffunction>
	
	<cffunction name="delete" returntype="void">
		<cfset entityDelete(this) />
	</cffunction>
	
	--->
	
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
	
</cfcomponent>
