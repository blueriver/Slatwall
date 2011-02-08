<!--- Slatwall Start --->
 
	<!--- Get Mura Data Source from Mura's Settings.ini file --->
	<cffile action="read" variable="SettingsINI" file="#baseDir#/config/settings.ini.cfm" />
	<cfset MuraDatasource = "" />
	<cfloop list="#SettingsINI#" index="I" delimiters="#chr(13)##chr(10)#">
		<cfif Left(I,10) eq 'datasource'>
			<cfset MuraDatasource = Right(I,Len(I)-11) />
		</cfif>
	</cfloop>
  
	<cfset this.ormenabled = "true" />
	<cfset this.datasource = "#MuraDatasource#" />
	<cfset this.ormSettings.dbcreate = "update" />
	<cfset this.ormSettings.flushAtRequestEnd = false />
	<cfset this.ormSettings.automanageSession = false />
	<cfset this.ormsettings.cfclocation = "/plugins/Slatwall/com/entity" />
	<!--- Set Custom Tags Setting --->
	<cfset this.customtagpaths = "#this.customtagpaths#,#baseDir#/plugins/Slatwall/tags" />
  
<!--- Slatwall End --->