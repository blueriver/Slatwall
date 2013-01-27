<cfif thisTag.executionMode is "start">
	<cfparam name="attributes.hibachiScope" type="struct" default="#request.context.fw.getHibachiScope()#" />
	<cfparam name="attributes.permissionGroup" type="any" />
	<cfparam name="attributes.entityPermissionDetails" type="struct" default="#attributes.hibachiScope.getService('hibachiAuthenticationService').getEntityPermissionDetails()#" />
	
	<cfset hibachiScope = request.context.fw.getHibachiScope() />	
	
	<cfoutput>
		<table class="table">
			<tr>
				<th class="primary">Entity / Property</th>
				<th>Create</th>
				<th>Read</th>
				<th>Update</th>
				<th>Delete</th>
			</tr>
			
			<cfset entities = listToArray(structKeyList(attributes.entityPermissionDetails)) />
			<cfset arraySort(entities, "text") />
		
			<cfloop array="#entities#" index="entityName">
				<cfif not structKeyExists(attributes.entityPermissionDetails[entityName], "inheritPermissionEntityName")>
					<tr>
						<td class="primary" onClick="$('.permission#lcase(entityName)#').toggle();">#hibachiScope.rbKey('entity.#entityName#')#</td>
						<td><input type="checkbox" name="" value=""></td>
						<td><input type="checkbox" name="" value=""></td>
						<td><input type="checkbox" name="" value=""></td>
						<td><input type="checkbox" name="" value=""></td>
					</tr>
					<cf_HibachiPermissionGroupPropertyPermissions entityName="#entityName#" entityPermissionDetails="#attributes.entityPermissionDetails#" depth="1" />
				</cfif>
			</cfloop>
		</table>
	</cfoutput>
</cfif>