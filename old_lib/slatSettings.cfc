<cfcomponent output="false" name="slatSettings" hint="">

	<cfset variables.Settings = structnew() />
	<cfset variables.Settings.AllCountriesQuery = "" />
	
	<cffunction name="init" returntype="any" output="false" access="public">
		<cfreturn this />
	</cffunction>
	
	<cffunction name="loadSettings" returntype="void" output="false" access="public">
		<cfset var rsSettings = querynew('empty') />
		<cfset var rsPermissions = querynew('empty') />
		
		<cfquery name="rsSettings" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
			SELECT
				SettingName,
				SettingDisplayName,
				SettingType,
				SettingValue,
				SettingOptions,
				DefaultSettingValue,
				Hint
			FROM
				tslatsettings
		</cfquery>
		
		<cfset variables.Settings.SettingsQuery = rsSettings />
		
		<cfif rsSettings.recordcount>
			<cfloop query="rsSettings">
				<cfif rsSettings.SettingValue eq '' and rsSettings.DefaultSettingValue neq ''>
					<cfset setSetting(rsSettings.SettingName, rsSettings.DefaultSettingValue) />
				<cfelse>
					<cfset setSetting(rsSettings.SettingName, rsSettings.SettingValue) />
				</cfif>
			</cfloop>
		</cfif>
		
		<cfquery name="rsPermissions" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
			SELECT
				Permission
			FROM
				tslatpermissions
		</cfquery>
		
		<cfset variables.Permissions = "" />
		<cfloop query="rsPermissions">
			<cfset variables.Permissions = "#variables.Permissions##rsPermissions.Permission#^" />
			<!--- <cfset 'variables.Permissions.#Left(rsPermissions.Permission,Find("~",rsPermissions.Permission))#.#Right(rsPermissions.Permission,Find("~",rsPermissions.Permission))#' = 1 /> --->
		</cfloop>
		
	</cffunction>
	
	<cffunction name="getSetting" returntype="any" output="false" access="public">
		<cfargument name="Setting" required="true" />
		
		<cfreturn Evaluate("variables.Settings.#arguments.Setting#") />
	</cffunction>
	
	<cffunction name="setSetting" returntype="any" output="false" access="public">
		<cfargument name="Setting" required="true" />
		<cfargument name="SettingValue" required="true" />
		
		<cfset 'variables.Settings.#arguments.Setting#' = arguments.SettingValue />
	</cffunction>
	
	<cffunction name="updateSetting" returntype="void" output="false" access="public">
		<cfargument name="Setting" required="true" />
		<cfargument name="SettingValue" required="true" />
		
		<cfset var rs = querynew('empty') />
		<cfquery name="rs" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
			UPDATE tslatsettings SET SettingValue = <cfqueryparam value="#arguments.SettingValue#" cfsqltype="varchar"> WHERE SettingName = <cfqueryparam value="#arguments.Setting#" cfsqltype="varchar">
		</cfquery>
	</cffunction>
	
	<cffunction name="checkPermission" returntype="Numeric" output="false" access="public">
		<cfargument name="SVO" required="true" />
		<cfargument name="GroupList" required="true" />
		
		<cfset var I = "" />
		<cfset var IsOK = 0 />
		
		<cfloop list="#arguments.GroupList#" index="I">
			<cfif ListFindNoCase(variables.Permissions, "#arguments.SVO#~#I#", "^")>
				<cfset IsOK = 1 />
			</cfif>
		</cfloop>
		
		<cfreturn IsOK />
	</cffunction>
	<cffunction name="clearPermission" returntype="void" output="false" access="public">
		<cfset var rs = querynew('empty') />
		<cfquery name="rs" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
			DELETE FROM tslatpermissions
		</cfquery>
	</cffunction>
	<cffunction name="addPermission" returntype="void" output="false" access="public">
		<cfargument name="Permission" required="true" />
		<cfset var rs = querynew('empty') />
		<cfquery name="rs" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
			INSERT INTO tslatpermissions (Permission) VALUES (<cfqueryparam value="#arguments.Permission#" cfsqltype="varchar">)
		</cfquery>
	</cffunction>
	<cffunction name="getAllPermissions" returntype="any" output="false" access="public">
		
		<cfreturn variables.Permissions />
	</cffunction>
	
	
	<cffunction name="getAllSettingsStruct" returntype="any" output="false" access="public">
		
		<cfreturn variables.Settings />
	</cffunction>
	
	
	<cffunction name="getAllCountriesQuery" access="public" output="false" returntype="Query">
		<cfif not isQuery(variables.Settings.AllCountriesQuery)>
			<cfquery name="AllContries" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
				SELECT
					*
				FROM
					tslatcountries
				WHERE
					active = 1
				ORDER BY
					CountryDisplayName asc
			</cfquery>
			<cfset variables.Settings.AllCountriesQuery = AllContries />
		</cfif>
		
		<cfreturn variables.Settings.AllCountriesQuery />
	</cffunction> 
	
	<cffunction name="getCountryQuery" access="public" output="false" returntype="Query">
		<cfargument name="CountryCode" required="true" />
		
		<cfquery name="Country" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
			SELECT
				*
			FROM
				tslatcountries
			WHERE
				CountryCode = '#arguments.CountryCode#'
		</cfquery>
	
		<cfreturn Country />
	</cffunction> 
	
	<cffunction name="getStatesByCountryCodeQuery" access="public" output="false" returntype="Query">
		<cfargument name="CountryCode" required="true" />
		
		<cfset var StatesByCountryCode = querynew('empty') />
		
		<cfquery name="StatesByCountryCode" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
			SELECT
				*
			FROM
				tslatstates
			WHERE
				CountryCode = '#arguments.CountryCode#'
		</cfquery>
		
		<cfreturn StatesByCountryCode />
	</cffunction>
	
	<cffunction name="getCitiesByCountryCodeQuery" access="public" output="false" returntype="Query">
		<cfargument name="CountryCode" required="true" />
		
		<cfset var CitiesByCountryCode = querynew('empty') />
		
		<cfquery name="CitiesByCountryCode" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
			SELECT
				*
			FROM
				tslatcities
			WHERE
				CountryCode = '#arguments.CountryCode#'
		</cfquery>
		
		<cfreturn CitiesByCountryCode />
	</cffunction> 
</cfcomponent>