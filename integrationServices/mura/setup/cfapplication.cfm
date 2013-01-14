<!---[START_SLATWALL_CONFIG]--->
<cfset this.mappings["/Slatwall"] = "{pathToSlatwallSetupOnInstall}" />
<cfset this.mappings["/ValidateThis"] = this.mappings["/Slatwall"] & "/org/ValidateThis" />
<cfset this.mappings["/coldspring"] = this.mappings["/Slatwall"] & "/org/coldspring" />
<cfset this.mappings["/SlatwallVFSRoot"] = "ram:///" & this.name />
<cfset this.customtagpaths = listAppend(this.customtagpaths, this.mappings["/Slatwall"] & "/tags")>
<cfset arrayAppend(this.ormSettings.cfclocation, "/plugins/slatwall-mura/Slatwall/com/entity") />
<!---[END_SLATWALL_CONFIG]--->