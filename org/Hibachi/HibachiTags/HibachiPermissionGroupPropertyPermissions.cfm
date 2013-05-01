<cfif thisTag.executionMode is "start">
	<cfparam name="attributes.hibachiScope" type="struct" default="#request.context.fw.getHibachiScope()#" />
	<cfparam name="attributes.entityName" type="string" />
	<cfparam name="attributes.entityPermissionDetails" type="struct" />
	<cfparam name="attributes.formIndex" type="numeric" default="1" />
	<cfparam name="attributes.depth" type="numeric" default="1" />
	
	<cfset propertyName = "" />
	
	<cfset properties = listToArray(structKeyList(attributes.entityPermissionDetails[attributes.entityName].properties)) />
	<cfset arraySort(properties, "text") />
	<cfset mtoproperties = listToArray(structKeyList(attributes.entityPermissionDetails[attributes.entityName].mtoproperties)) />
	<cfset arraySort(mtoproperties, "text") />
	<cfset otmproperties = listToArray(structKeyList(attributes.entityPermissionDetails[attributes.entityName].otmproperties)) />
	<cfset arraySort(otmproperties, "text") />
	<cfset mtmproperties = listToArray(structKeyList(attributes.entityPermissionDetails[attributes.entityName].mtmproperties)) />
	<cfset arraySort(mtmproperties, "text") />
	
	<cfset subPropertyInheriting = structNew() />
	<cfloop collection="#attributes.entityPermissionDetails#" item="key">
		<cfif structKeyExists(attributes.entityPermissionDetails[key], "inheritPermissionEntityName") and attributes.entityPermissionDetails[key].inheritPermissionEntityName eq attributes.entityName>
			<cfset subPropertyInheriting[ attributes.entityPermissionDetails[key].inheritPermissionPropertyName ] = key />
		</cfif>
	</cfloop>
	

	<cfoutput>
		<cfloop array="#properties#" index="propertyName">
			<tr class="hide permission#lcase(attributes.entityName)#">
				<cfset attributes.formIndex++ />
				<input type="hidden" name="permissions[#attributes.formIndex#].permissionID" value="" />
				<input type="hidden" name="permissions[#attributes.formIndex#].accessType" value="entity" />
				<input type="hidden" name="permissions[#attributes.formIndex#].entityClassName" value="#attributes.entityName#" />
				<td class="primary"><span class="depth#attributes.depth#" />#attributes.hibachiScope.rbKey('entity.#attributes.entityName#.#propertyName#')#</td>
				<td></td>
				<td><input type="hidden" name="permissions[#attributes.formIndex#].allowReadFlag" value=""><input type="checkbox" name="permissions[#attributes.formIndex#].allowReadFlag" value="1" disabled="true"> Read</td>
				<td><input type="hidden" name="permissions[#attributes.formIndex#].allowUpdateFlag" value=""><input type="checkbox" name="permissions[#attributes.formIndex#].allowUpdateFlag" value="1" disabled="true"> Update</td>
				<td></td>
				<td></td>
			</tr>
		</cfloop>
		<cfloop array="#otmproperties#" index="propertyName">
			<tr class="hide permission#lcase(attributes.entityName)#" <cfif structKeyExists(subPropertyInheriting, propertyName)>onClick="$('.permission#lcase(subPropertyInheriting[ propertyName ])#').toggle();"</cfif>>
				<cfset attributes.formIndex++ />
				<input type="hidden" name="permissions[#attributes.formIndex#].permissionID" value="" />
				<input type="hidden" name="permissions[#attributes.formIndex#].accessType" value="entity" />
				<input type="hidden" name="permissions[#attributes.formIndex#].entityClassName" value="#attributes.entityName#" />
				<td class="primary"><span class="depth#attributes.depth#" />
					<cfif structKeyExists(subPropertyInheriting, propertyName)>
						<strong>#attributes.hibachiScope.rbKey('entity.#attributes.entityName#.#propertyName#')#</strong>
					<cfelse>
						#attributes.hibachiScope.rbKey('entity.#attributes.entityName#.#propertyName#')#
					</cfif>
				</td>
				<td><input type="hidden" name="permissions[#attributes.formIndex#].allowCreateFlag" value=""><input type="checkbox" name="permissions[#attributes.formIndex#].allowCreateFlag" value="1" disabled="true"> Create</td>
				<td><input type="hidden" name="permissions[#attributes.formIndex#].allowReadFlag" value=""><input type="checkbox" name="permissions[#attributes.formIndex#].allowReadFlag" value="1" disabled="true"> Read</td>
				<td><input type="hidden" name="permissions[#attributes.formIndex#].allowUpdateFlag" value=""><input type="checkbox" name="permissions[#attributes.formIndex#].allowUpdateFlag" value="1" disabled="true"> Update</td>
				<td><input type="hidden" name="permissions[#attributes.formIndex#].allowDeleteFlag" value=""><input type="checkbox" name="permissions[#attributes.formIndex#].allowDeleteFlag" value="1" disabled="true"> Delete</td>
				<td><input type="hidden" name="permissions[#attributes.formIndex#].allowProcessFlag" value=""><input type="checkbox" name="permissions[#attributes.formIndex#].allowProcessFlag" value="1" disabled="true"> Process</td>
			</tr>
			<cfif structKeyExists(subPropertyInheriting, propertyName)>
				<cf_HibachiPermissionGroupPropertyPermissions entityName="#subPropertyInheriting[ propertyName ]#" entityPermissionDetails="#attributes.entityPermissionDetails#" formIndex="#attributes.formIndex#" depth="#attributes.depth + 1#" />
			</cfif>
		</cfloop>
		<cfloop array="#mtoproperties#" index="propertyName">
			<tr class="hide permission#lcase(attributes.entityName)#" <cfif structKeyExists(subPropertyInheriting, propertyName)>onClick="$('.#lcase(subPropertyInheriting[ propertyName ])#').toggle();"</cfif>>
				<cfset attributes.formIndex++ />
				<input type="hidden" name="permissions[#attributes.formIndex#].permissionID" value="" />
				<input type="hidden" name="permissions[#attributes.formIndex#].accessType" value="entity" />
				<input type="hidden" name="permissions[#attributes.formIndex#].entityClassName" value="#attributes.entityName#" />
				<td class="primary"><span class="depth#attributes.depth#" />#attributes.hibachiScope.rbKey('entity.#attributes.entityName#.#propertyName#')#</td>
				<td></td>
				<td><input type="hidden" name="permissions[#attributes.formIndex#].allowReadFlag" value=""><input type="checkbox" name="permissions[#attributes.formIndex#].allowReadFlag" value="1" disabled="true"> Read</td>
				<td><input type="hidden" name="permissions[#attributes.formIndex#].allowUpdateFlag" value=""><input type="checkbox" name="permissions[#attributes.formIndex#].allowUpdateFlag" value="1" disabled="true"> Update</td>
				<td></td>
				<td></td>
			</tr>
		</cfloop>
		<cfloop array="#mtmproperties#" index="propertyName">
			<tr class="hide permission#lcase(attributes.entityName)#" <cfif structKeyExists(subPropertyInheriting, propertyName)>onClick="$('.#lcase(subPropertyInheriting[ propertyName ])#').toggle();"</cfif>>
				<cfset attributes.formIndex++ />
				<input type="hidden" name="permissions[#attributes.formIndex#].permissionID" value="" />
				<input type="hidden" name="permissions[#attributes.formIndex#].accessType" value="entity" />
				<input type="hidden" name="permissions[#attributes.formIndex#].entityClassName" value="#attributes.entityName#" />
				<td class="primary"><span class="depth#attributes.depth#" />#attributes.hibachiScope.rbKey('entity.#attributes.entityName#.#propertyName#')#</td>
				<td></td>
				<td><input type="hidden" name="permissions[#attributes.formIndex#].allowReadFlag" value=""><input type="checkbox" name="permissions[#attributes.formIndex#].allowReadFlag" value="1" disabled="true"> Read</td>
				<td><input type="hidden" name="permissions[#attributes.formIndex#].allowUpdateFlag" value=""><input type="checkbox" name="permissions[#attributes.formIndex#].allowUpdateFlag" value="1" disabled="true"> Update</td>
				<td></td>
				<td></td>
			</tr>
		</cfloop>
	</cfoutput>
</cfif>