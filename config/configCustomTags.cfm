<cfset this.customtagpaths = this.mappings[ "/Slatwall" ] & "/tags" />
<cfset this.customtagpaths = listAppend(this.customtagpaths, this.mappings[ "/Slatwall" ] & "/org/Hibachi/HibachiTags") />