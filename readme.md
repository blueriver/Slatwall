Installation
------------

1) This source is designed to be Zipped up and installed as a plug-in into MuraCMS
2) The below code block needs to be added to your MuraCMS cfapplication.cfm file located in (muraroot/config/cfapplication.cfm):
<!--- Add Custom Application.cfc Vars Here --->

<!--- Start: Setup Slatwall --->

	<!--- Change This Setting Per Install --->
	<cfset variables.slatwallpluginid = 2 />
	
	<!--- Get Mura Data Source from Mura's Settings.ini --->
	<cffile action="read" variable="SettingsINI" file="#baseDir#/config/settings.ini.cfm" />
	<cfset MuraDatasource = "" />
	<cfloop list="#SettingsINI#" index="I" delimiters="#chr(13)##chr(10)#">
		<cfif Left(I,10) eq 'datasource'>
			<cfset MuraDatasource = Right(I,Len(I)-11) />
		</cfif>
	</cfloop>
	
	<!--- Set ORM Settings --->
	<cfset this.ormenabled = "true" />
	<cfset this.datasource = "#MuraDatasource#" />
	<cfset this.ormSettings.dbcreate = "update" />
	<cfset this.ormsettings.cfclocation = "/plugins/Slat_#variables.slatwallpluginid#/com/entity" />
	
	<!--- Set Custom Tags Setting --->
	<cfset this.customtagpaths = "#this.customtagpaths#,#baseDir#/plugins/Slat_#variables.slatwallpluginid#/tags" />
	
<!--- End: Setup Slatwall --->


===================================================================


Documentation
-------------

In addition, there is a database diagram located here /help/dbdesign.xml
To view it, you will need to load it with wwwsqldesigner which can be downloaded here: http://code.google.com/p/wwwsqldesigner/