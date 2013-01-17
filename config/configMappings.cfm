<!--- Place Application Mappings Here --->
<cfset this.mappings[ "/Slatwall" ] = left(getDirectoryFromPath(getCurrentTemplatePath()), len(getDirectoryFromPath(getCurrentTemplatePath()))-8) />