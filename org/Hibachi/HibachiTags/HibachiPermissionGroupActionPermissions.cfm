<cfif thisTag.executionMode is "start">
	<cfparam name="attributes.hibachiScope" type="struct" default="#request.context.fw.getHibachiScope()#" />
	<cfparam name="attributes.permissionGroup" type="any" />
	<cfparam name="attributes.actionPermissionDetails" type="struct" default="#attributes.hibachiScope.getService('hibachiAuthenticationService').getActionPermissionDetails()#" />
	<cfparam name="attributes.edit" type="boolean" default="#request.context.edit#" />
	
	
	<cfoutput>
		<table class="table">
			<tr>
				<th class="primary" style="font-size:14px;">Subsystem / Section / Item</th>
				<th class="primary" style="font-size:14px;">Access</th>
				<!---<cfset thisPermission = attributes.permissionGroup.getPermissionByDetails(accessType='action', subsystemName=subsystemName) />--->
			</tr>
			<cfloop collection="#attributes.actionPermissionDetails#" item="subsystemName">
				<cfset subsystemDetails = attributes.actionPermissionDetails[ subsystemName ] />
				<cfif subsystemDetails.hasSecureMethods>
					<tr>
						<td>#subsystemName#</td>
						<td></td>
					</tr>
					<cfloop collection="#subsystemDetails.sections#" item="sectionName">
						<cfset sectionDetails = subsystemDetails.sections[ sectionName ] />
						<cfloop list="#sectionDetails.secureMethods#" index="secureMethod">
							<tr>
								<td>#subsystemName# / #sectionName# / #secureMethod#</td>
								<td></td>
							</tr>
						</cfloop>
					</cfloop>
				</cfif>
			</cfloop>
		</table>
	</cfoutput>
	
</cfif>