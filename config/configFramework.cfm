<cfset variables.framework.applicationKey="SlatwallFW1" />
<cfset variables.framework.base = "/Slatwall" />
<cfset variables.framework.baseURL = replace(replace(replace( getDirectoryFromPath(getCurrentTemplatePath()) , expandPath('/'), '/' ), '\', '/', 'all'),'/config/','/') />
<cfset variables.framework.action="slatAction" />
<cfset variables.framework.hibachi.applicationKey = "Slatwall" />
