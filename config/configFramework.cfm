<cfset variables.framework=structNew() />
<cfset variables.framework.hibachiKey="Slatwall" />
<cfset variables.framework.applicationKey="SlatwallFW1" />
<cfset variables.framework.base="/Slatwall" />
<cfset variables.framework.baseURL = replace(replace(replace( getDirectoryFromPath(getCurrentTemplatePath()) , expandPath('/'), '/' ), '\', '/', 'all'),'/config/','/') />
<cfset variables.framework.action="slatAction" />
<cfset variables.framework.error="admin:main.error" />
<cfset variables.framework.home="admin:main.default" />
<cfset variables.framework.defaultSection="main" />
<cfset variables.framework.defaultItem="default" />
<cfset variables.framework.usingsubsystems=true />
<cfset variables.framework.defaultSubsystem = "admin" />
<cfset variables.framework.subsystemdelimiter=":" />
<cfset variables.framework.generateSES = true />
<cfset variables.framework.SESOmitIndex = true />
<cfset variables.framework.reload = "reload" />
<cfset variables.framework.routes = [
		{ "$GET/api/:entityName/:entityID" = "/admin:api/get/entityName/:entityName/entityID/:entityID"},
		{ "$GET/api/:entityName/" = "/admin:api/post/entityName/:entityName/"}
	] />
	
<cfset variables.framework.hibachi = {} />
<cfset variables.framework.hibachi.applicationKey = "Slatwall" />
<cfset variables.framework.hibachi.resourceBundleDirectories = "config/resourceBundles,config/custom/resourceBundles" />
<cfset variables.framework.hibachi.hibachiScopeObject = "Hibachi.HibachiScope" />
<cfset variables.framework.hibachi.smartListObject = "Hibachi.SmartList" />
<cfset variables.framework.hibachi.fullUpdateKey = "Update" />
<cfset variables.framework.hibachi.fullUpdatePassword = "true" />