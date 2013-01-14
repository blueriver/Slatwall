<!---[START_SLATWALL_CONFIG]--->
<cfset this.mappings["/Slatwall"] = "/pathToSlatwallSetupOnInstall/" />
<cfset this.mappings["/ValidateThis"] = "/pathToSlatwallSetupOnInstall/org/ValidateThis/" />
<cfset this.customtagpaths = listAppend(this.customtagpaths,"/pathToSlatwallSetupOnInstall/tags/")>
<cfset arrayAppend(this.ormSettings.cfclocation, "/Slatwall/com/entity") />
<!---[END_SLATWALL_CONFIG]--->