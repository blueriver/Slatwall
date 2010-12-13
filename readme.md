Installation
------------

1. This source is designed to be Zipped up and installed as a plug-in into MuraCMS
2. The below code block needs to be added to your MuraCMS cfapplication.cfm file located in (muraroot/config/cfapplication.cfm):
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


Documentation
-------------

Please view the project documentation here: https://github.com/gregmoser/Slatwall/wiki


Contribution
------------

Slatwall is an Open Source project that is made possible by the support of fellow developers.  For more information on how to get involved please reference the "Contribution" section of our development guide that is located here: https://github.com/gregmoser/Slatwall/wiki/Developer-Guide


License
-------

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

	http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.