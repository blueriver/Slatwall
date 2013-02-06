
<!---[START_SLATWALL_CONFIG]--->
<cfset this.mappings["/Slatwall"] = "{pathToSlatwallSetupOnInstall}" />
<cfset arrayAppend(this.ormSettings.cfclocation, "/Slatwall/model/entity") />
<!---[END_SLATWALL_CONFIG]--->