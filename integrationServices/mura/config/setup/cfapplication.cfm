
<!---[START_SLATWALL_CONFIG]--->
<cfset this.mappings["/Slatwall"] = "#this.mappings["muraWRM"]#/Slatwall" />
<cfset arrayAppend(this.ormSettings.cfclocation, "/Slatwall/model/entity") />
<cfset this.customTagPaths = listAppend(this.customTagPaths, "#this.mappings["/Slatwall"]#/tags") />
<!---[END_SLATWALL_CONFIG]--->