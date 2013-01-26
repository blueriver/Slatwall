<cfoutput>
	<table class="table">
		<tr>
			<th class="primary">Entity / Property</th>
			<th>Create</th>
			<th>Read</th>
			<th>Update</th>
			<th>Delete</th>
		</tr>
		
		<cfset entities = listToArray(structKeyList(rc.entityPermissionDetails)) />
		<cfset arraySort(entities, "text") />
	
		<cfloop array="#entities#" index="entityName">
			<cfif not structKeyExists(rc.entityPermissionDetails[entityName], "inheritPermissionEntityName")>
				<tr>
					<td class="primary" onClick="$('.#lcase(entityName)#').toggle();">#$.slatwall.rbKey('entity.#entityName#')#</td>
					<td><input type="checkbox" name="" value=""></td>
					<td><input type="checkbox" name="" value=""></td>
					<td><input type="checkbox" name="" value=""></td>
					<td><input type="checkbox" name="" value=""></td>
				</tr>
				#displayEntityProperties(entityName=entityName, entityPermissionDetails=rc.entityPermissionDetails, depth=1)#
			</cfif>
		</cfloop>
	</table>
</cfoutput>

<cffunction name="displayEntityProperties">
	<cfargument name="entityName" type="string" required="true" />
	<cfargument name="entityPermissionDetails" type="struct" required="true" />
	<cfargument name="depth" type="numeric" default="1" />
	
	<cfset var returnHTML = "" />
	<cfset var propertyName = "" />
	
	<cfset var properties = listToArray(structKeyList(entityPermissionDetails[entityName].properties)) />
	<cfset arraySort(properties, "text") />
	<cfset var mtoproperties = listToArray(structKeyList(entityPermissionDetails[entityName].mtoproperties)) />
	<cfset arraySort(mtoproperties, "text") />
	<cfset var otmproperties = listToArray(structKeyList(entityPermissionDetails[entityName].otmproperties)) />
	<cfset arraySort(otmproperties, "text") />
	<cfset var mtmproperties = listToArray(structKeyList(entityPermissionDetails[entityName].mtmproperties)) />
	<cfset arraySort(mtmproperties, "text") />
	
	<cfset var subPropertyInheriting = structNew() />
	<cfset var key = "" />
	<cfloop collection="#entityPermissionDetails#" item="key">
		<cfif structKeyExists(entityPermissionDetails[key], "inheritPermissionEntityName") and entityPermissionDetails[key].inheritPermissionEntityName eq arguments.entityName>
			<cfset subPropertyInheriting[ entityPermissionDetails[key].inheritPermissionPropertyName ] = key />
		</cfif>
	</cfloop>
	
	<cfsavecontent variable="returnHTML">
		<cfoutput>
			<cfloop array="#properties#" index="propertyName">
				<tr class="hide #lcase(arguments.entityName)#">
					<td class="primary"><span class="depth#arguments.depth#" />#propertyName#</td>
					<td><input type="checkbox" name="" value=""></td>
					<td><input type="checkbox" name="" value=""></td>
					<td><input type="checkbox" name="" value=""></td>
					<td><input type="checkbox" name="" value=""></td>
				</tr>
			</cfloop>
			<cfloop array="#mtoproperties#" index="propertyName">
				<tr class="hide #lcase(arguments.entityName)#" <cfif structKeyExists(subPropertyInheriting, propertyName)>onClick="$('.#lcase(subPropertyInheriting[ propertyName ])#').toggle();"</cfif>>
					<td class="primary"><span class="depth#arguments.depth#" />#propertyName#</td>
					<td></td>
					<td><input type="checkbox" name="" value=""></td>
					<td><input type="checkbox" name="" value=""></td>
					<td></td>
				</tr>
				<cfif structKeyExists(subPropertyInheriting, propertyName)>
					#displayEntityProperties(entityName=subPropertyInheriting[ propertyName ], entityPermissionDetails=arguments.entityPermissionDetails, depth=arguments.depth+1)#
				</cfif>
			</cfloop>
			<cfloop array="#mtmproperties#" index="propertyName">
				<tr class="hide #lcase(arguments.entityName)#" <cfif structKeyExists(subPropertyInheriting, propertyName)>onClick="$('.#lcase(subPropertyInheriting[ propertyName ])#').toggle();"</cfif>>
					<td class="primary"><span class="depth#arguments.depth#" />#propertyName#</td>
					<td></td>
					<td><input type="checkbox" name="" value=""></td>
					<td><input type="checkbox" name="" value=""></td>
					<td></td>
				</tr>
				<cfif structKeyExists(subPropertyInheriting, propertyName)>
					#displayEntityProperties(entityName=subPropertyInheriting[ propertyName ], entityPermissionDetails=arguments.entityPermissionDetails, depth=arguments.depth+1)#
				</cfif>
			</cfloop>
			<cfloop array="#otmproperties#" index="propertyName">
				<tr class="hide #lcase(arguments.entityName)#" <cfif structKeyExists(subPropertyInheriting, propertyName)>onClick="$('.#lcase(subPropertyInheriting[ propertyName ])#').toggle();"</cfif>>
					<td class="primary"><span class="depth#arguments.depth#" />#propertyName#</td>
					<td><input type="checkbox" name="" value=""></td>
					<td><input type="checkbox" name="" value=""></td>
					<td><input type="checkbox" name="" value=""></td>
					<td><input type="checkbox" name="" value=""></td>
				</tr>
				<cfif structKeyExists(subPropertyInheriting, propertyName)>
					#displayEntityProperties(entityName=subPropertyInheriting[ propertyName ], entityPermissionDetails=arguments.entityPermissionDetails, depth=arguments.depth+1)#
				</cfif>
			</cfloop>
		</cfoutput>
	</cfsavecontent>
	
	<cfreturn returnHTML />
</cffunction>
	