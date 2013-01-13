<cfset this.mappings[ "/Slatwall" ] = left(getDirectoryFromPath(getCurrentTemplatePath()), len(getDirectoryFromPath(getCurrentTemplatePath()))-7) />
<cfset this.mappings[ "/coldspring" ] = this.mappings[ "/Slatwall" ] & "org/coldspring/" />
<cfset this.mappings[ "/ValidateThis" ] = this.mappings[ "/Slatwall" ] & "org/ValidateThis/" />
<cfset this.mappings[ "/SlatwallVFSRoot" ] = "ram:///" & this.name />