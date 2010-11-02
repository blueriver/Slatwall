<cfcomponent extends="framework">

<cfinclude template="../../config/applicationSettings.cfm">
<cfinclude template="../../config/mappings.cfm">
<cfinclude template="../mappings.cfm">
<cfinclude template="fw1Config.cfm">

<!--- Get Mura Data Source for Mura Settings.ini --->
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
<cfset this.ormsettings.cfclocation = "com/entity" />

<cffunction name="setupApplication" output="false">
	<cfset ormreload() />
	<cfif not structKeyExists(request,"pluginConfig")>
		<cfinclude template="plugin/config.cfm" />
	</cfif>
	<cfset setPluginConfig(request.PluginConfig) />
	
	<cfset setBeanFactory(getPluginConfig().getApplication().getValue( "serviceFactory" ))>
</cffunction>

<cffunction name="setPluginConfig" output="false">  
	<cfargument name="pluginConfig" type="any" required="true">  
	<cfset application[ variables.framework.applicationKey ].pluginConfig = arguments.pluginConfig>  
</cffunction>  
<cffunction name="getPluginConfig" output="false">  
	<cfreturn application[ variables.framework.applicationKey ].pluginConfig>  
</cffunction> 

<cffunction name="isAdminRequest">
	<cfreturn not structKeyExists(request,"servletEvent")>
</cffunction>

<cffunction name="secureRequest" output="false">
	<cfset var ActionOK = 0 />
	<cfif isAdminRequest()>
		<cfif isDefined('url.action')>
			<cfset ActionOK = SecureDisplay(url.action) />
		<cfelse>
			<cfset ActionOK = SecureDisplay('main.default') />
		</cfif>
		<cfif not ActionOK>	
			<cflocation url="#application.configBean.getContext()#/admin/" addtoken="false">
		</cfif>
	</cfif>
</cffunction>

<cffunction name="setupRequest" output="false">
	<cfif isDefined('url.returnFormat')>
		<cfif url.returnFormat neq 'json'>
			<cfset secureRequest()>
		</cfif>
	<cfelse>
		<cfset secureRequest()>
	</cfif>

	<cfset variables.framework.baseURL="http://#cgi.http_host#/plugins/#getPluginConfig().getDirectory()#/">
</cffunction>

<cffunction name="SlatFERenderStart" output="false" returntype="any">
	<cfset var I = 0 />
	<cfset var ValuePair = "" />
	<cfset var FilterProperty = "" />
	<cfset var RangeProperty = "" />
	<cfset var HTMLHead = "" />
	
	<cfif isAdminRequest()>
		<cfset secureRequest()>
	</cfif>
	
	<!--- Set Request.Slat.Product --->
	<cfset request.Slat.Product = "">
	<cfif isDefined('url.ProductID')>
		<cfset request.Slat.Product = application.Slat.productManager.read('#url.ProductID#') />
	</cfif>
	
	<cfif not isAdminRequest()>
		<!--- Set HTML Head Elements --->
		<cfsavecontent variable="HTMLHead">
			<cfoutput>
				<cfinclude template="layouts/inc/html_head.cfm" />
			</cfoutput>
		</cfsavecontent>
		<cfhtmlhead text="#HTMLHead#">
	</cfif>
</cffunction>


<!--- Misc Functions --->
<cffunction name="getExternalSiteLink" output="false" returntype="String">
	<cfargument name="Address" />
	<cfreturn #buildURL(action='external.site', queryString='es=#arguments.Address#')# />
</cffunction>

<cffunction name="buildSecureURL" output="false" returntype="string">
	<cfargument name="action" />
	<cfargument name="path" type="string" default="#variables.framework.baseURL#" />
	<cfargument name="querystring" default="" />
	
	<cfset var returnLink = "" />
	
	<cfif SecureDisplay(arguments.action)>
		<cfset returnLink = variables.BuildURL(arguments.action,arguments.path,arguments.querystring) />
	<cfelse>
		<cfset returnLink = "javascript:alert('You do not have access to this area');" />	
	</cfif>
	
	<cfreturn returnLink />
</cffunction>

<cffunction name="viewSecure" output="false" returntype="String">
	<cfargument name="view" required="true" />
	<cfargument name="args" default="#structNew()#" />
	
	<cfset var returnView = "" />
	
	<cfif SecureDisplay(Replace(arguments.view,"/",".","all"))>
		<cfset returnView = variables.view(arguments.view, arguments.args) />
	</cfif>
	
	<cfreturn returnView />
</cffunction>

<cffunction name="SecureDisplay" output="false" returntype="Numeric">
	<cfargument name="action" required="true" />
	
	<cfset var isOK = 0 />
	
	<cfif isUserInRole('S2')>
		<cfset isOK = 1 />
	<cfelse>
		<cfset isOK = application.slatsettings.checkPermission(arguments.action, getUserRoles()) />
	</cfif>
	
	<cfif not isOK and listFindNoCase(application.slatsettings.getSetting('AdminIPList'), '#cgi.remote_addr#')>
		<cfset isOK = application.slatsettings.checkPermission(arguments.action, "SlatwallAdminIP") />
	</cfif>
	
	<cfreturn isOK />
</cffunction>

</cfcomponent>