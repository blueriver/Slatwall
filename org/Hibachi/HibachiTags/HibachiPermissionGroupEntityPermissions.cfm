<cfif thisTag.executionMode is "start">
	<cfparam name="attributes.hibachiScope" type="struct" default="#request.context.fw.getHibachiScope()#" />
	<cfparam name="attributes.permissionGroup" type="any" />
	<cfparam name="attributes.entityPermissionDetails" type="struct" default="#attributes.hibachiScope.getService('hibachiAuthenticationService').getEntityPermissionDetails()#" />
	<cfparam name="attributes.edit" type="boolean" default="false" />
	<cfparam name="attributes.editEntityName" type="string" default="" />
	
	<cfset hibachiScope = request.context.fw.getHibachiScope() />
	
	<cfoutput>
		<table class="table">
			<tr>
				<cfset thisPermission = attributes.permissionGroup.getPermissionByDetails(accessType='entity') />
				<cfif attributes.edit and not len(attributes.editEntityName)>
					<input type="hidden" name="permissions[1].permissionID" value="" />
					<input type="hidden" name="permissions[1].accessType" value="entity" />
				</cfif>
				<th class="primary" style="font-size:14px;">All Entities & Properties</th>
				<cfif attributes.edit and attributes.editEntityName eq "all">
					<th style="font-size:14px;"><input type="hidden" name="permissions[1].allowCreateFlag" value=""><input type="checkbox" name="permissions[1].allowCreateFlag" class="hibachi-permission-checkbox" value="1" <cfif !arrayLen(attributes.permissionGroup.getPermissions()) || thisPermission.getAllowCreateFlag()>checked="checked"</cfif>> Create</th>
					<th style="font-size:14px;"><input type="hidden" name="permissions[1].allowReadFlag" value=""><input type="checkbox" name="permissions[1].allowReadFlag" class="hibachi-permission-checkbox" value="1" <cfif !arrayLen(attributes.permissionGroup.getPermissions()) || thisPermission.getAllowCreateFlag()>checked="checked"</cfif>> Read</th>
					<th style="font-size:14px;"><input type="hidden" name="permissions[1].allowUpdateFlag" value=""><input type="checkbox" name="permissions[1].allowUpdateFlag" class="hibachi-permission-checkbox" value="1" <cfif !arrayLen(attributes.permissionGroup.getPermissions()) || thisPermission.getAllowCreateFlag()>checked="checked"</cfif>> Update</th>
					<th style="font-size:14px;"><input type="hidden" name="permissions[1].allowDeleteFlag" value=""><input type="checkbox" name="permissions[1].allowDeleteFlag" class="hibachi-permission-checkbox" value="1" <cfif !arrayLen(attributes.permissionGroup.getPermissions()) || thisPermission.getAllowCreateFlag()>checked="checked"</cfif>> Delete</th>
					<th style="font-size:14px;"><input type="hidden" name="permissions[1].allowProcessFlag" value=""><input type="checkbox" name="permissions[1].allowProcessFlag" class="hibachi-permission-checkbox" value="1" <cfif !arrayLen(attributes.permissionGroup.getPermissions()) || thisPermission.getAllowCreateFlag()>checked="checked"</cfif>> Process</th>
					<th><cf_HibachiActionCaller action="admin:entity.detailPermissionGroup" queryString="permissionGroupID=#attributes.permissionGroup.getPermissionGroupID()#" class="btn btn-mini" iconOnly="true" icon="remove"></th>
				<cfelse>
					<th style="font-size:14px;">Create</th>
					<th style="font-size:14px;">Read</th>
					<th style="font-size:14px;">Update</th>
					<th style="font-size:14px;">Delete</th>
					<th style="font-size:14px;">Process</th>
					<th><cf_HibachiActionCaller action="admin:entity.editPermissionGroup" queryString="permissionGroupID=#attributes.permissionGroup.getPermissionGroupID()#&editEntityName=all" class="btn btn-mini" iconOnly="true" icon="pencil"></th>
				</cfif>
			</tr>
			
			<cfset entities = listToArray(structKeyList(attributes.entityPermissionDetails)) />
			<cfset arraySort(entities, "text") />
			
			<cfset request.context.permissionFormIndex = 1 />
			
			<cfloop array="#entities#" index="entityName">
				<cfif not structKeyExists(attributes.entityPermissionDetails[entityName], "inheritPermissionEntityName")>
					<tr>
						<cfif attributes.edit and attributes.editEntityName eq entityName>
							<cfset request.context.permissionFormIndex++ />
							<input type="hidden" name="permissions[#request.context.permissionFormIndex#].permissionID" value="" />
							<input type="hidden" name="permissions[#request.context.permissionFormIndex#].accessType" value="entity" />
							<input type="hidden" name="permissions[#request.context.permissionFormIndex#].entityClassName" value="#entityName#" />
							
							<td class="primary" onClick="$('.permission#lcase(entityName)#').toggle();"><strong>#hibachiScope.rbKey('entity.#entityName#')#</strong></td>
							<td><input type="hidden" name="permissions[#request.context.permissionFormIndex#].allowCreateFlag" value=""><input type="checkbox" name="permissions[#request.context.permissionFormIndex#].allowCreateFlag" class="hibachi-permission-checkbox" data-hibachi-parentcheckbox="permissions[1].allowCreateFlag" value="1"> Create</td>
							<td><input type="hidden" name="permissions[#request.context.permissionFormIndex#].allowReadFlag" value=""><input type="checkbox" name="permissions[#request.context.permissionFormIndex#].allowReadFlag" class="hibachi-permission-checkbox" data-hibachi-parentcheckbox="permissions[1].allowReadFlag" value="1"> Read</td>
							<td><input type="hidden" name="permissions[#request.context.permissionFormIndex#].allowUpdateFlag" value=""><input type="checkbox" name="permissions[#request.context.permissionFormIndex#].allowUpdateFlag" class="hibachi-permission-checkbox" data-hibachi-parentcheckbox="permissions[1].allowUpdateFlag" value="1"> Update</td>
							<td><input type="hidden" name="permissions[#request.context.permissionFormIndex#].allowDeleteFlag" value=""><input type="checkbox" name="permissions[#request.context.permissionFormIndex#].allowDeleteFlag" class="hibachi-permission-checkbox" data-hibachi-parentcheckbox="permissions[1].allowDeleteFlag" value="1"> Delete</td>
							<td><input type="hidden" name="permissions[#request.context.permissionFormIndex#].allowProcessFlag" value=""><input type="checkbox" name="permissions[#request.context.permissionFormIndex#].allowProcessFlag" class="hibachi-permission-checkbox" data-hibachi-parentcheckbox="permissions[1].allowProcessFlag" value="1"> Process</td>
							<td><cf_HibachiActionCaller action="admin:entity.detailPermissionGroup" queryString="permissionGroupID=#attributes.permissionGroup.getPermissionGroupID()#" class="btn btn-mini" iconOnly="true" icon="remove"></td>
						<cfelse>
							<td class="primary" onClick="$('.permission#lcase(entityName)#').toggle();"><strong>#hibachiScope.rbKey('entity.#entityName#')#</strong></td>
							<td>Yes</td>
							<td>Yes</td>
							<td>Yes</td>
							<td>Yes</td>
							<td>Yes</td>
							<td><cf_HibachiActionCaller action="admin:entity.editPermissionGroup" queryString="permissionGroupID=#attributes.permissionGroup.getPermissionGroupID()#&editEntityName=#entityName#" class="btn btn-mini" iconOnly="true" icon="pencil"></td>
						</cfif>
					</tr>
					<cf_HibachiPermissionGroupPropertyPermissions entityName="#entityName#" entityPermissionDetails="#attributes.entityPermissionDetails#" parentIndex="#request.context.permissionFormIndex#" depth="1" />
				</cfif>
			</cfloop>
		</table>
	</cfoutput>
</cfif>