<!---[START_SLATWALL_CONFIG]--->
<cfset this.mappings["/Slatwall"] = "{pathToSlatwallSetupOnInstall}" />
<cfset arrayAppend(this.ormSettings.cfclocation, "/Slatwall/modal/entity") />
<!---[END_SLATWALL_CONFIG]--->