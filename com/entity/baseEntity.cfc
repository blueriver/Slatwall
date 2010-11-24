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
	
	<cffunction name="getPropertyDisplay">
		<cfargument name="Property" required="true" />
		<cfargument name="Edit" default=false />
		<cfargument name="Title" default="" />
		<cfargument name="Value" default="" />
		
		<cfset var return = "" />
		<cfset var MetaData = getMetadata( this ) />
		<cfset var PorpertyMD = StructNew() />
		<cfset var PropertyI = StructNew() />
		<cfset var PropertyExists = false />
		
		<cfloop array="#MetaData.Properties#" index="PropertyI">
			<cfif UCASE(PropertyI.Name) eq UCASE(arguments.Property)>
				<cfset PropertyExists = true />
				<cfset PropertyMD = PropertyI />
			</cfif>
		</cfloop>
		
		<cfif PropertyExists>
			<cfif arguments.Title eq "">
				<cfif isDefined('PropertyMD.DisplayName')>
					<cfset arguments.Title = PropertyMD.DisplayName />
				<cfelse>
					<cfset arguments.Title = arguments.Property />
				</cfif>
			</cfif>
			
			<cfif arguments.Value eq "">
				<cfif structkeyexists(variables, PropertyMD.Name)>
					<cfset  arguments.Value = variables[PropertyMD.Name] />
				<cfelse>
					<cfset  arguments.Value = PropertyMD.Default />
				</cfif>
			</cfif>
			
			<cfsavecontent variable="return">
				<cfoutput>
				<dl class="spd#LCASE(PropertyMD.Name)#">
					<dt><cfif arguments.edit><label for="#PropertyMD.Name#">#arguments.Title#</label><cfelse>#arguments.Title#</cfif></dt>
					<dd>
						<cfif arguments.edit>
							<cfif PropertyMD.type eq 'boolean'>
								<input type="hidden" name="#PropertyMD.Name#" value="0">
								<input type="checkbox" name="#PropertyMD.Name#" value="1" <cfif arguments.Value>checked="checked"</cfif> />
							<cfelseif PropertyMD.type eq 'string' or PropertyMD.type eq 'numeric'>
								<input type="text" name="#PropertyMD.Name#" value="#arguments.Value#" />
							</cfif>
						<cfelse>
							<cfif PropertyMD.type eq 'boolean' and arguments.Value eq true>
								YES
							<cfelseif PropertyMD.type eq 'boolean' and arguments.Value eq false>
								NO
							<cfelse>
								#arguments.Value#
							</cfif>
						</cfif>
					</dd>
				</dl>
				</cfoutput>
			</cfsavecontent>
		</cfif>
		
		<Cfreturn return />
	</cffunction>
	
</cfcomponent>
