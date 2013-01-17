<cfset this.ormenabled = true />
<cfset this.ormsettings = {} />
<cfset this.ormsettings.cfclocation = [ variables.framework.baseURL & "model/entity" ] />
<cfset this.ormSettings.dbcreate = "update" />
<cfset this.ormSettings.flushAtRequestEnd = false />
<cfset this.ormsettings.eventhandling = true />
<cfset this.ormSettings.automanageSession = false />
<cfset this.ormSettings.savemapping = false />
<cfset this.ormSettings.skipCFCwitherror = true />
<cfset this.ormSettings.useDBforMapping = true />
<cfset this.ormSettings.autogenmap = true />
<cfset this.ormSettings.logsql = false />
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