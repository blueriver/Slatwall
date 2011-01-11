<~--- Slatwall Start --->
<~--- Only uncomment the 2 lines starting "remove this line" do not remove the Slatwall start/end tags --->
<~--- Remove this line
  <%cfset variables.slatwallpluginid = <cfoutput>#variables.config.getPluginID()#</cfoutput> /%>
  <~--- Get Mura Data Source from Mura's Settings.ini file --->
  <%cffile action="read" variable="SettingsINI" file="#baseDir#/config/settings.ini.cfm" /%>
  <%cfset MuraDatasource = "" /%>
  <%cfloop list="#SettingsINI#" index="I" delimiters="#chr(13)##chr(10)#"%>
      <%cfif Left(I,10) eq 'datasource'%>
          <%cfset MuraDatasource = Right(I,Len(I)-11) /%>
      <%/cfif%>
  <%/cfloop%>
  <!--- Set ORM Settings --->
  <%cfset this.ormenabled = "true" /%>
  <%cfset this.datasource = "#MuraDatasource#" /%>
  <%cfset this.ormSettings.dbcreate = "update" /%>
  <%cfset this.ormsettings.cfclocation = "/plugins/Slatwall_#variables.slatwallpluginid#/com/entity" /%>
  <~--- Set Custom Tags Setting --->
  <%cfset this.customtagpaths = "#this.customtagpaths#,#baseDir#/plugins/Slatwall_#variables.slatwallpluginid#/tags" /%>
  Remove this line --->
<~--- Slatwall End --->



	

	