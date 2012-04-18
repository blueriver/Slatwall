<!---

    Slatwall - An e-commerce plugin for Mura CMS
    Copyright (C) 2011 ten24, LLC

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
    
    Linking this library statically or dynamically with other modules is
    making a combined work based on this library.  Thus, the terms and
    conditions of the GNU General Public License cover the whole
    combination.
 
    As a special exception, the copyright holders of this library give you
    permission to link this library with independent modules to produce an
    executable, regardless of the license terms of these independent
    modules, and to copy and distribute the resulting executable under
    terms of your choice, provided that you also meet, for each linked
    independent module, the terms and conditions of the license of that
    module.  An independent module is a module which is not derived from
    or based on this library.  If you modify this library, you may extend
    this exception to your version of the library, but you are not
    obligated to do so.  If you do not wish to do so, delete this
    exception statement from your version.

Notes:

--->
<cfparam name="rc.cmsUserGroups" type="query">
<cfparam name="rc.permissionActions" type="struct">
<cfparam name="rc.permissionSettings" type="struct">
<cfparam name="rc.edit" type="boolean">

<cfoutput>
	<div class="svoadmineditpermissions">
		<ul id="navTask">
	    	<cf_SlatwallActionCaller action="admin:setting.editpermissions" type="list">
		</ul>
		
		<form action="#buildURL(action='admin:setting.savepermissions')#" method="post">
			<table class="listtable stripe">
				<tr>
					<th class="varWidth">Setting</th>
					<cfloop query="local.rc.cmsUserGroups">
						<th>#local.rc.cmsUserGroups.groupName#</th>
					</cfloop>
				</tr>
				<cfset local.allControllers = structKeyList(local.rc.permissionActions) />
				<cfset local.allControllers = ListSort(local.allControllers, "TEXT") />
				<cfloop list="#local.allControllers#" index="local.controller">
					<tr>
						<td class="varWidth" style="background-color:##adceee;">
							<cfif Right(request.slatwallScope.rbKey("admin.#local.controller#_permission"),8) neq "_missing">
								<cfset local.thisControllerName = request.slatwallScope.rbKey("admin.#local.controller#_permission") />
							<cfelse>
								<cfset local.thisControllerName = request.slatwallScope.rbKey("admin.#local.controller#") />
							</cfif>
							
							<cfif Right(request.slatwallScope.rbKey("admin.#local.controller#_hint"),8) neq "_missing">
								<a href="##" class="tooltip"><strong>#local.thisControllerName#</strong><span>#request.slatwallScope.rbKey("admin.#local.controller#_hint")#</span></a>
							<cfelse>
								<strong>#local.thisControllerName#</strong>
							</cfif>
						</td>
						
						<input type="hidden" value="" name="permission_admin_#local.controller#_#variables.framework.defaultItem#" />
						<cfloop query="local.rc.cmsUserGroups">
							<td style="background-color:##adceee;">
								<cfset local.accessList = "" />
								<cfif structKeyExists(local.rc.permissionSettings, "permission_admin_#local.controller#_#variables.framework.defaultItem#")>
									<cfset local.accessList = local.rc.permissionSettings["permission_admin_#local.controller#_#variables.framework.defaultItem#"].getSettingValue() />
								</cfif>
								<cfif rc.edit>
									<input type="checkbox" value="#local.rc.cmsUserGroups.groupName#;#session.siteID#;#local.rc.cmsUserGroups.isPublic#" name="permission_admin_#local.controller#_#variables.framework.defaultItem#" <cfif listFind(local.accessList, "#local.rc.cmsUserGroups.groupName#;#session.siteID#;#local.rc.cmsUserGroups.isPublic#")>checked="checked"</cfif> />
								<cfelse>
									<cfif listFind(local.accessList, "#local.rc.cmsUserGroups.groupName#;#session.siteID#;#local.rc.cmsUserGroups.isPublic#")>YES<cfelse>NO</cfif>
								</cfif>
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
							<cfloop query="local.rc.cmsUserGroups">
								<td>
									<cfset local.accessList = "" />
									<cfif structKeyExists(local.rc.permissionSettings, "permission_admin_#local.controller#_#local.controllerAction#")>
										<cfset local.accessList = local.rc.permissionSettings["permission_admin_#local.controller#_#local.controllerAction#"].getSettingValue() />
									</cfif>
									<cfif rc.edit>
										<input type="checkbox" value="#local.rc.cmsUserGroups.groupName#;#session.siteID#;#local.rc.cmsUserGroups.isPublic#" name="permission_admin_#local.controller#_#local.controllerAction#" <cfif listFind(local.accessList, "#local.rc.cmsUserGroups.groupName#;#session.siteID#;#local.rc.cmsUserGroups.isPublic#")>checked="checked"</cfif> />
									<cfelse>
										<cfif listFind(local.accessList, "#local.rc.cmsUserGroups.groupName#;#session.siteID#;#local.rc.cmsUserGroups.isPublic#")>YES<cfelse>NO</cfif>
									</cfif>
								</td>
							</cfloop>
						</tr>
						<cfset local.rowcounter++ />
					</cfloop>
				</cfloop>
			</table>
			<cfif rc.edit>
			<cf_SlatwallActionCaller type="submit" action="admin:setting.savepermissions" class="button">
			</cfif>
		</form>
	</div>
</cfoutput>
