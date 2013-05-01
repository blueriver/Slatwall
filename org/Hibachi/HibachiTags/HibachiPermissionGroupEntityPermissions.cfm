<cfif thisTag.executionMode is "start">
	<cfparam name="attributes.hibachiScope" type="struct" default="#request.context.fw.getHibachiScope()#" />
	<cfparam name="attributes.permissionGroup" type="any" />
	<cfparam name="attributes.entityPermissionDetails" type="struct" default="#attributes.hibachiScope.getService('hibachiAuthenticationService').getEntityPermissionDetails()#" />
	
	<cfset hibachiScope = request.context.fw.getHibachiScope() />	
	
	<cfoutput>
		<table class="table">
			<tr>
				<input type="hidden" name="permissions[1].permissionID" value="" />
				<input type="hidden" name="permissions[1].accessType" value="entity" />
				<th class="primary" style="font-size:14px;">All Entities & Properties</th>
				<th style="font-size:14px;"><input type="hidden" name="permissions[1].allowCreateFlag" value=""><input type="checkbox" name="permissions[1].allowCreateFlag" value="1"> Create</th>
				<th style="font-size:14px;"><input type="hidden" name="permissions[1].allowReadFlag" value=""><input type="checkbox" name="permissions[1].allowReadFlag" value="1"> Read</th>
				<th style="font-size:14px;"><input type="hidden" name="permissions[1].allowUpdateFlag" value=""><input type="checkbox" name="permissions[1].allowUpdateFlag" value="1"> Update</th>
				<th style="font-size:14px;"><input type="hidden" name="permissions[1].allowDeleteFlag" value=""><input type="checkbox" name="permissions[1].allowDeleteFlag" value="1"> Delete</th>
				<th style="font-size:14px;"><input type="hidden" name="permissions[1].allowProcessFlag" value=""><input type="checkbox" name="permissions[1].allowProcessFlag" value="1"> Process</th>
			</tr>
			
			<cfset entities = listToArray(structKeyList(attributes.entityPermissionDetails)) />
			<cfset arraySort(entities, "text") />
			<cfset formIndex = 1 />
			<cfloop array="#entities#" index="entityName">
				<cfif not structKeyExists(attributes.entityPermissionDetails[entityName], "inheritPermissionEntityName")>
					<tr>
						<cfset formIndex++ />
						<input type="hidden" name="permissions[#formIndex#].permissionID" value="" />
						<input type="hidden" name="permissions[#formIndex#].accessType" value="entity" />
						<input type="hidden" name="permissions[#formIndex#].entityClassName" value="#entityName#" />
						<td class="primary" onClick="$('.permission#lcase(entityName)#').toggle();"><strong>#hibachiScope.rbKey('entity.#entityName#')#</strong></td>
						<td><input type="hidden" name="permissions[#formIndex#].allowCreateFlag" value=""><input type="checkbox" name="permissions[#formIndex#].allowCreateFlag" value="1" disabled="true"> Create</td>
						<td><input type="hidden" name="permissions[#formIndex#].allowReadFlag" value=""><input type="checkbox" name="permissions[#formIndex#].allowReadFlag" value="1" disabled="true"> Read</td>
						<td><input type="hidden" name="permissions[#formIndex#].allowUpdateFlag" value=""><input type="checkbox" name="permissions[#formIndex#].allowUpdateFlag" value="1" disabled="true"> Update</td>
						<td><input type="hidden" name="permissions[#formIndex#].allowDeleteFlag" value=""><input type="checkbox" name="permissions[#formIndex#].allowDeleteFlag" value="1" disabled="true"> Delete</td>
						<td><input type="hidden" name="permissions[#formIndex#].allowProcessFlag" value=""><input type="checkbox" name="permissions[#formIndex#].allowProcessFlag" value="1" disabled="true"> Process</td>
					</tr>
					<cf_HibachiPermissionGroupPropertyPermissions entityName="#entityName#" entityPermissionDetails="#attributes.entityPermissionDetails#" formIndex="#formIndex#" depth="1" />
				</cfif>
			</cfloop>
		</table>
	</cfoutput>
</cfif>