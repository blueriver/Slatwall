<cfset this.ormsettings.cfclocation = [ "/Slatwall/model/entity", "/Slatwall/integrationServices" ] />
<cftry>
	<cfdbinfo datasource="#this.datasource.name#" type="Version" name="dbVersion">
	<cfcatch>
		<cfinclude template="admin/views/main/nodatasource.cfm" />
		<cfabort />
	</cfcatch>
</cftry>
<cfif FindNoCase("MySQL", dbVersion.DATABASE_PRODUCTNAME)>
	<cfset this.ormSettings.dialect = "MySQL" />
<cfelseif FindNoCase("Microsoft", dbVersion.DATABASE_PRODUCTNAME)>
	<cfset this.ormSettings.dialect = "Microsoft" />	
</cfif>