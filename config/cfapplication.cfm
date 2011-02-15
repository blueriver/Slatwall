<!--- Slatwall Start --->
 
	<!--- Set ORM Settings --->
	<cfset this.ormenabled = "true" />
	<cfset this.datasource = getProfileString("#baseDir#/config/settings.ini.cfm", "production", "datasource") />
	<cfset this.ormSettings.dbcreate = "update" />
	<cfset this.ormSettings.flushAtRequestEnd = false />
	<cfset this.ormSettings.automanageSession = false />
	<cfset this.ormsettings.cfclocation = "/plugins/Slatwall/com/entity" />
	<!--- Set Custom Tags Setting --->
	<cfset this.customtagpaths = "#this.customtagpaths#,#baseDir#/plugins/Slatwall/tags" />
  
<!--- Slatwall End --->