<cfparam name="local.rc.$" type="any">
<cfparam name="local.rc.muraUserGroups" type="query">
<cfparam name="local.rc.permissionActions" type="struct">
<cfparam name="local.rc.permissionSettings" type="struct">

<cfoutput>
	<div class="svoadmineditpermissions">
		<form action="#buildURL(action='admin:setting.savepermissions')#" method="post">
			<table class="listtable stripe">
				<tr>
					<th class="varWidth">Setting</th>
					<cfloop query="local.rc.muraUserGroups">
						<th>#local.rc.muraUserGroups.groupName#</th>
					</cfloop>
				</tr>
				<cfset local.allControllers = structKeyList(local.rc.permissionActions) />
				<cfset local.allControllers = ListSort(local.allControllers, "TEXT") />
				<cfloop list="#local.allControllers#" index="local.controller">
					<tr>
						<td class="varWidth" style="background-color:##adceee;">
							<cfif Right(rc.$.Slatwall.rbKey("admin.#local.controller#_permission"),8) neq "_missing">
								<cfset local.thisControllerName = rc.$.Slatwall.rbKey("admin.#local.controller#_permission") />
							<cfelse>
								<cfset local.thisControllerName = rc.$.Slatwall.rbKey("admin.#local.controller#") />
							</cfif>
							
							<cfif Right(rc.$.Slatwall.rbKey("admin.#local.controller#_hint"),8) neq "_missing">
								<a href="##" class="tooltip"><strong>#local.thisControllerName#</strong><span>#rc.$.Slatwall.rbKey("admin.#local.controller#_hint")#</span></a>
							<cfelse>
								<strong>#local.thisControllerName#</strong>
							</cfif>
						</td>
						
						<input type="hidden" value="" name="permission_admin_#local.controller#_#variables.framework.defaultItem#" />
						<cfloop query="local.rc.muraUserGroups">
							<td style="background-color:##adceee;">
								<cfset local.accessList = "" />
								<cfif structKeyExists(local.rc.permissionSettings, "permission_admin_#local.controller#_#variables.framework.defaultItem#")>
									<cfset local.accessList = local.rc.permissionSettings["permission_admin_#local.controller#_#variables.framework.defaultItem#"].getSettingValue() />
								</cfif>
								<input type="checkbox" value="#local.rc.muraUserGroups.groupName#;#session.siteID#;#local.rc.muraUserGroups.isPublic#" name="permission_admin_#local.controller#_#variables.framework.defaultItem#" <cfif listFind(local.accessList, "#local.rc.muraUserGroups.groupName#;#session.siteID#;#local.rc.muraUserGroups.isPublic#")>checked="checked"</cfif> />
							</td>
						</cfloop>
					</tr>
					<cfset local.rowcounter = 1 />
					
					<cfloop array="#local.rc.permissionActions[local.controller]#" index="local.controllerAction">
						<tr<cfif local.rowcounter mod 2 eq 1> class="alt"</cfif>>
							<td class="varWidth">
								<cfif Right(rc.$.Slatwall.rbKey("admin.#local.controller#.#local.controllerAction#_permission"),8) neq "_missing">
									<cfset local.thisControllerActionName = #rc.$.Slatwall.rbKey("admin.#local.controller#.#local.controllerAction#_permission")# />
								<cfelse>
									<cfset local.thisControllerActionName = #rc.$.Slatwall.rbKey("admin.#local.controller#.#local.controllerAction#")# />
								</cfif>
								<cfif Right(rc.$.Slatwall.rbKey("admin.#local.controller#.#local.controllerAction#_hint"),8) neq "_missing">
									<a href="##" class="tooltip">#local.thisControllerActionName#<span>#rc.$.Slatwall.rbKey("admin.#local.controller#.#local.controllerAction#_hint")#</span></a>
								<cfelse>
									#local.thisControllerActionName#
								</cfif>
							</td>
							<input type="hidden" value="" name="permission_admin_#local.controller#_#local.controllerAction#" />
							<cfloop query="local.rc.muraUserGroups">
								<td>
									<cfset local.accessList = "" />
									<cfif structKeyExists(local.rc.permissionSettings, "permission_admin_#local.controller#_#local.controllerAction#")>
										<cfset local.accessList = local.rc.permissionSettings["permission_admin_#local.controller#_#local.controllerAction#"].getSettingValue() />
									</cfif>
									<input type="checkbox" value="#local.rc.muraUserGroups.groupName#;#session.siteID#;#local.rc.muraUserGroups.isPublic#" name="permission_admin_#local.controller#_#local.controllerAction#" <cfif listFind(local.accessList, "#local.rc.muraUserGroups.groupName#;#session.siteID#;#local.rc.muraUserGroups.isPublic#")>checked="checked"</cfif> />
								</td>
							</cfloop>
						</tr>
						<cfset local.rowcounter++ />
					</cfloop>
				</cfloop>
			</table>
			<button type="submit">Save</button>
		</form>
	</div>
</cfoutput>