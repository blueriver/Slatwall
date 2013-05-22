<cfset arrayAppend(this.ormsettings.cfclocation, "/Slatwall/integrationServices") />
<cftry>
	<cfparam name="#this.datasource.name#" default="" />
	<cfparam name="#this.datasource.username#" default="" />
	<cfparam name="#this.datasource.password#" default="" />
	
	<cfdbinfo datasource="#this.datasource.name#" type="Version" name="dbVersion" username="#this.datasource.username#" password="#this.datasource.password#">
	<cfcatch>
		<cfinclude template="#variables.framework.baseURL#/admin/views/main/nodatasource.cfm" />
		<cfabort />
	</cfcatch>
</cftry>
<cfif findNoCase("MySQL", dbVersion.DATABASE_PRODUCTNAME)>
	<cfset this.ormSettings.dialect = "MySQL" />
<cfelseif findNoCase("Microsoft", dbVersion.DATABASE_PRODUCTNAME)>
	<cfset this.ormSettings.dialect = "MicrosoftSQLServer" />	
</cfif>