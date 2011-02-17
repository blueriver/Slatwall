<cfdirectory action="list" directory="C:\inetpub\wwwroot\Slatwall\com\entity" name="entityList" >
<cfdump var="#entityList#" />
<cfloop query="entityList" >
	<cfset thisEntity = createObject("component", "Slatwall.com.entity.#Replace(entityList.name, '.cfc', '', 'all')#") />
	<cfset meta = getMetaData(thisEntity) />
	<cfloop array="#meta.properties#" index="prop" >
		<cfif structKeyExists(prop, "DisplayName")>
			<cfoutput>entity.#LCASE(Replace(entityList.name, '.cfc', '', 'all'))#.#prop.name#=#prop.displayname#<br /></cfoutput>
		<cfelse>
			<cfoutput>entity.#LCASE(Replace(entityList.name, '.cfc', '', 'all'))#.#prop.name#=#prop.name#<br /></cfoutput>
		</cfif>
	</cfloop>
</cfloop>

<!---
<cfset local.ViewsPath = "#expandPath(application.slatsettings.getSetting('PluginPath'))#\views" />
<cfset local.UserGroups = application.userManager.getPrivateGroups(siteid=application.slatsettings.getSetting('siteid')) />

<cfoutput>
	<div class="svosettingpermisions">
		<form name="SettingsUpdate" method="post" action="index.cfm?action=setting.permissions">
			<table class="listtable">
				<tr>
					<th>Section</th>
					<th>SlatwallAdminIP<br />(<a href="javascript:;" onclick="checkgroup('SlatwallAdminIP', true);">Check</a> / <a href="javascript:;" onclick="checkgroup('SlatwallAdminIP', false);">Clear</a>)</th>
					<cfloop query="local.UserGroups">
						<th>#local.UserGroups.GroupName#<br />(<a href="javascript:;" onclick="checkgroup('#local.UserGroups.GroupName#', true);">Check</a> / <a href="javascript:;" onclick="checkgroup('#local.UserGroups.GroupName#', false);">Clear</a>)</th>
					</cfloop>
				</tr>
				<cfdirectory action="list" directory="#local.ViewsPath#" listinfo="all" name="local.ViewsDirectoryQuery" />
				<cfloop query="local.ViewsDirectoryQuery">
					<tr class="Parent">
						<td><strong>#local.ViewsDirectoryQuery.Name#</strong></td>
						<td><input type="checkbox" group="SlatwallAdminIP" section="#local.ViewsDirectoryQuery.Name#~SlatwallAdminIP" name="#local.ViewsDirectoryQuery.Name#~SlatwallAdminIP" <cfif application.slatSettings.checkPermission('#local.ViewsDirectoryQuery.Name#','SlatwallAdminIP')>checked="checked"</cfif>> (<a href="javascript:;" onclick="checksection('#local.ViewsDirectoryQuery.Name#~SlatwallAdminIP', true);">Check</a> / <a href="javascript:;" onclick="checksection('#local.ViewsDirectoryQuery.Name#~SlatwallAdminIP', false);">Clear</a>)</td>
						<cfloop query="local.UserGroups">
							<td><input type="checkbox" group="#local.UserGroups.GroupName#" section="#local.ViewsDirectoryQuery.Name#~#local.UserGroups.GroupName#" name="#local.ViewsDirectoryQuery.Name#~#local.UserGroups.GroupName#;#local.UserGroups.SiteID#;#local.UserGroups.IsPublic#" <cfif application.slatSettings.checkPermission('#local.ViewsDirectoryQuery.Name#','#local.UserGroups.GroupName#;#local.UserGroups.SiteID#;#local.UserGroups.IsPublic#')>checked="checked"</cfif>> (<a href="javascript:;" onclick="checksection('#local.ViewsDirectoryQuery.Name#~#local.UserGroups.GroupName#', true);">Check</a> / <a href="javascript:;" onclick="checksection('#local.ViewsDirectoryQuery.Name#~#local.UserGroups.GroupName#', false);">Clear</a>)</td>
						</cfloop>
					</tr>
					<cfdirectory action="list" directory="#local.ViewsPath#\#local.ViewsDirectoryQuery.Name#" listinfo="all" name="local.ViewsSubDirectoryQuery" />
					<cfloop query="local.ViewsSubDirectoryQuery">
						<tr>
							<td class="Child">#local.ViewsDirectoryQuery.Name# #Replace(local.ViewsSubDirectoryQuery.Name, ".cfm", "")#</td>
							<td><input type="checkbox" group="SlatwallAdminIP" section="#local.ViewsDirectoryQuery.Name#~SlatwallAdminIP" name="#local.ViewsDirectoryQuery.Name#.#Replace(local.ViewsSubDirectoryQuery.Name, ".cfm", "")#~SlatwallAdminIP" <cfif application.slatSettings.checkPermission('#local.ViewsDirectoryQuery.Name#','SlatwallAdminIP')>checked="checked"</cfif>></td>
							<cfloop query="local.UserGroups">
								<td><input type="checkbox" group="#local.UserGroups.GroupName#" section="#local.ViewsDirectoryQuery.Name#~#local.UserGroups.GroupName#" name="#local.ViewsDirectoryQuery.Name#.#Replace(local.ViewsSubDirectoryQuery.Name, ".cfm", "")#~#local.UserGroups.GroupName#;#local.UserGroups.SiteID#;#local.UserGroups.IsPublic#" <cfif application.slatSettings.checkPermission("#local.ViewsDirectoryQuery.Name#.#Replace(local.ViewsSubDirectoryQuery.Name, ".cfm", "")#","#local.UserGroups.GroupName#;#local.UserGroups.SiteID#;#local.UserGroups.IsPublic#")>checked="cehcked"</cfif>></td>
							</cfloop>
						</tr>
					</cfloop>
				</cfloop>
			</table>
			<script type="text/javascript">
				function checksection(section, check){
					$("input[section=" + section + "]").attr("checked", check);
				}
				function checkgroup(group, check){
					$("input[group=" + group + "]").attr("checked", check);
				}
			</script>
			<button type="submit">Save</button>
		</form>
	</div>
</cfoutput>
--->