<cfset this.mappings[ "/Slatwall" ] = left(getDirectoryFromPath(getCurrentTemplatePath()), len(getDirectoryFromPath(getCurrentTemplatePath()))-7) />
<cfset this.mappings[ "/coldspring" ] = expandPath("/Slatwall/org/coldspring") />
<cfset this.mappings[ "/ValidateThis" ] = expandPath("/Slatwall/org/ValidateThis") />
<cfset this.mappings[ "/SlatwallVFSRoot" ] = "ram:///" & this.name />