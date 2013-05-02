<cfif thisTag.executionMode is "start">
	<cfparam name="attributes.hibachiScope" type="struct" default="#request.context.fw.getHibachiScope()#" />
	<cfparam name="attributes.entityName" type="string" />
	<cfparam name="attributes.entityPermissionDetails" type="struct" />
	<cfparam name="attributes.parentIndex" type="numeric" default="1" />
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
			<cfset request.context.permissionFormIndex++ />
			
			<tr class="hide permission#lcase(attributes.entityName)#">
				<input type="hidden" name="permissions[#request.context.permissionFormIndex#].permissionID" value="" />
				<input type="hidden" name="permissions[#request.context.permissionFormIndex#].accessType" value="entity" />
				<input type="hidden" name="permissions[#request.context.permissionFormIndex#].entityClassName" value="#attributes.entityName#" />
				<input type="hidden" name="permissions[#request.context.permissionFormIndex#].propertyName" value="#propertyName#" />
				<td class="primary"><span class="depth#attributes.depth#" />#attributes.hibachiScope.rbKey('entity.#attributes.entityName#.#propertyName#')#</td>
				<td></td>
				<td><input type="hidden" name="permissions[#request.context.permissionFormIndex#].allowReadFlag" value=""><input type="checkbox" name="permissions[#request.context.permissionFormIndex#].allowReadFlag" class="hibachi-permission-checkbox" data-hibachi-parentcheckbox="permissions[#attributes.parentIndex#].allowReadFlag" value="1"> Read</td>
				<td><input type="hidden" name="permissions[#request.context.permissionFormIndex#].allowUpdateFlag" value=""><input type="checkbox" name="permissions[#request.context.permissionFormIndex#].allowUpdateFlag" class="hibachi-permission-checkbox" data-hibachi-parentcheckbox="permissions[#attributes.parentIndex#].allowUpdateFlag" value="1"> Update</td>
				<td></td>
				<td></td>
			</tr>
		</cfloop>
		<cfloop array="#mtoproperties#" index="propertyName">
			<cfset request.context.permissionFormIndex++ />
			
			<tr class="hide permission#lcase(attributes.entityName)#" <cfif structKeyExists(subPropertyInheriting, propertyName)>onClick="$('.#lcase(subPropertyInheriting[ propertyName ])#').toggle();"</cfif>>
				<input type="hidden" name="permissions[#request.context.permissionFormIndex#].permissionID" value="" />
				<input type="hidden" name="permissions[#request.context.permissionFormIndex#].accessType" value="entity" />
				<input type="hidden" name="permissions[#request.context.permissionFormIndex#].entityClassName" value="#attributes.entityName#" />
				<td class="primary"><span class="depth#attributes.depth#" />#attributes.hibachiScope.rbKey('entity.#attributes.entityName#.#propertyName#')#</td>
				<td></td>
				<td><input type="hidden" name="permissions[#request.context.permissionFormIndex#].allowReadFlag" value=""><input type="checkbox" name="permissions[#request.context.permissionFormIndex#].allowReadFlag" class="hibachi-permission-checkbox" data-hibachi-parentcheckbox="permissions[#attributes.parentIndex#].allowReadFlag" value="1"> Read</td>
				<td><input type="hidden" name="permissions[#request.context.permissionFormIndex#].allowUpdateFlag" value=""><input type="checkbox" name="permissions[#request.context.permissionFormIndex#].allowUpdateFlag" class="hibachi-permission-checkbox" data-hibachi-parentcheckbox="permissions[#attributes.parentIndex#].allowUpdateFlag" value="1"> Update</td>
				<td></td>
				<td></td>
			</tr>
		</cfloop>
		<cfloop array="#mtmproperties#" index="propertyName">
			<cfset request.context.permissionFormIndex++ />
			
			<tr class="hide permission#lcase(attributes.entityName)#" <cfif structKeyExists(subPropertyInheriting, propertyName)>onClick="$('.#lcase(subPropertyInheriting[ propertyName ])#').toggle();"</cfif>>
				<input type="hidden" name="permissions[#request.context.permissionFormIndex#].permissionID" value="" />
				<input type="hidden" name="permissions[#request.context.permissionFormIndex#].accessType" value="entity" />
				<input type="hidden" name="permissions[#request.context.permissionFormIndex#].entityClassName" value="#attributes.entityName#" />
				<td class="primary"><span class="depth#attributes.depth#" />#attributes.hibachiScope.rbKey('entity.#attributes.entityName#.#propertyName#')#</td>
				<td></td>
				<td><input type="hidden" name="permissions[#request.context.permissionFormIndex#].allowReadFlag" value=""><input type="checkbox" name="permissions[#request.context.permissionFormIndex#].allowReadFlag" class="hibachi-permission-checkbox" data-hibachi-parentcheckbox="permissions[#attributes.parentIndex#].allowReadFlag" value="1"> Read</td>
				<td><input type="hidden" name="permissions[#request.context.permissionFormIndex#].allowUpdateFlag" value=""><input type="checkbox" name="permissions[#request.context.permissionFormIndex#].allowUpdateFlag" class="hibachi-permission-checkbox" data-hibachi-parentcheckbox="permissions[#attributes.parentIndex#].allowUpdateFlag" value="1"> Update</td>
				<td></td>
				<td></td>
			</tr>
		</cfloop>
		<cfloop array="#otmproperties#" index="propertyName">
			<cfset request.context.permissionFormIndex++ />
			
			<tr class="hide permission#lcase(attributes.entityName)#" <cfif structKeyExists(subPropertyInheriting, propertyName)>onClick="$('.permission#lcase(subPropertyInheriting[ propertyName ])#').toggle();"</cfif>>
				<input type="hidden" name="permissions[#request.context.permissionFormIndex#].permissionID" value="" />
				<input type="hidden" name="permissions[#request.context.permissionFormIndex#].accessType" value="entity" />
				<input type="hidden" name="permissions[#request.context.permissionFormIndex#].entityClassName" value="#attributes.entityName#" />
				<td class="primary"><span class="depth#attributes.depth#" />
					<cfif structKeyExists(subPropertyInheriting, propertyName)>
						<strong>#attributes.hibachiScope.rbKey('entity.#attributes.entityName#.#propertyName#')#</strong>
					<cfelse>
						#attributes.hibachiScope.rbKey('entity.#attributes.entityName#.#propertyName#')#
					</cfif>
				</td>
				<td>
					<cfif structKeyExists(subPropertyInheriting, propertyName)>
						<input type="hidden" name="permissions[#request.context.permissionFormIndex#].allowCreateFlag" value=""><input type="checkbox" name="permissions[#request.context.permissionFormIndex#].allowCreateFlag" class="hibachi-permission-checkbox" data-hibachi-parentcheckbox="permissions[#attributes.parentIndex#].allowCreateFlag" value="1"> Create
					</cfif>
				</td>
				<td><input type="hidden" name="permissions[#request.context.permissionFormIndex#].allowReadFlag" value=""><input type="checkbox" name="permissions[#request.context.permissionFormIndex#].allowReadFlag" class="hibachi-permission-checkbox" data-hibachi-parentcheckbox="permissions[#attributes.parentIndex#].allowReadFlag" value="1"> Read</td>
				<td><input type="hidden" name="permissions[#request.context.permissionFormIndex#].allowUpdateFlag" value=""><input type="checkbox" name="permissions[#request.context.permissionFormIndex#].allowUpdateFlag" class="hibachi-permission-checkbox" data-hibachi-parentcheckbox="permissions[#attributes.parentIndex#].allowUpdateFlag" value="1"> Update</td>
				<td><input type="hidden" name="permissions[#request.context.permissionFormIndex#].allowDeleteFlag" value=""><input type="checkbox" name="permissions[#request.context.permissionFormIndex#].allowDeleteFlag" class="hibachi-permission-checkbox" data-hibachi-parentcheckbox="permissions[#attributes.parentIndex#].allowDeleteFlag" value="1"> Delete</td>
				<td>
					<cfif structKeyExists(subPropertyInheriting, propertyName)>
						<input type="hidden" name="permissions[#request.context.permissionFormIndex#].allowProcessFlag" value=""><input type="checkbox" name="permissions[#request.context.permissionFormIndex#].allowProcessFlag" class="hibachi-permission-checkbox" data-hibachi-parentcheckbox="permissions[#attributes.parentIndex#].allowProcessFlag" value="1"> Process
					</cfif>
				</td>
			</tr>
			<cfif structKeyExists(subPropertyInheriting, propertyName)>
				<cf_HibachiPermissionGroupPropertyPermissions entityName="#subPropertyInheriting[ propertyName ]#" entityPermissionDetails="#attributes.entityPermissionDetails#" parentIndex="#request.context.permissionFormIndex#" depth="#attributes.depth + 1#" />
			</cfif>
		</cfloop>
	</cfoutput>
</cfif>