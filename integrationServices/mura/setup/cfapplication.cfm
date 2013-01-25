<!---[START_SLATWALL_CONFIG]--->
<cfset this.mappings["/Slatwall"] = "{pathToSlatwallSetupOnInstall}" />
<cfset this.mappings["/ValidateThis"] = "{pathToSlatwallSetupOnInstall}/org/Hibachi/ValidateThis" />
<cfset arrayAppend(this.ormSettings.cfclocation, "/Slatwall/model/entity") />
<!---[END_SLATWALL_CONFIG]--->