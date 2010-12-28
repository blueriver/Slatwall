Installation
------------

1. Create a Zip file of the source code with this directory as your top level directory.
2. Install Zip files as a plugin to Mura CMS
3. Copy the code block below into you Mura CMS cfapplication.cfm file located here: muraroot/config/cfapplication.cfm
4. Alter the 6th line of the code block 'variables.slatwallpluginid', and change it to the plugin id number of the slatwall plugin.

* Note: This custom setup should not be necessary in the production version of Slatwall

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
	<cfset this.ormsettings.cfclocation = "/plugins/Slatwall_#variables.slatwallpluginid#/com/entity" />
	
	<cfset ormReload() />
	
	<!--- Set Custom Tags Setting --->
	<cfset this.customtagpaths = "#this.customtagpaths#,#baseDir#/plugins/Slatwall_#variables.slatwallpluginid#/tags" />
	
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