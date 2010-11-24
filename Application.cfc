<cfcomponent extends="framework">

<cfinclude template="../../config/applicationSettings.cfm">
<cfinclude template="../../config/mappings.cfm">
<cfinclude template="../mappings.cfm">
<cfinclude template="fw1Config.cfm">

<cffunction name="setPluginConfig" output="false">  
	<cfargument name="pluginConfig" type="any" required="true">  
	<cfset application[ variables.framework.applicationKey ].pluginConfig = arguments.pluginConfig>  
</cffunction>  
<cffunction name="getPluginConfig" output="false">  
	<cfreturn application[ variables.framework.applicationKey ].pluginConfig>  
</cffunction>

<!--- Start: Standard Application Functions,  These are also called from the fw1EventAdapter --->
<cffunction name="setupApplication" output="false">
	<cfargument name="$">
	<cfset var serviceFactory = "" />
	<cfset var xml = "" />
	<cfset var xmlPath = "" />

	<cfset ormreload() />
	
	<cfif not structKeyExists(request,"pluginConfig") or request.pluginConfig.getPackage() neq variables.framework.applicationKey>
		<cfinclude template="plugin/config.cfm" />
	</cfif>
	<cfset setPluginConfig(request.PluginConfig) />
	
	<cfset xmlPath = "#expandPath( '/plugins' )#/#getPluginConfig().getDirectory()#/config/coldspring.xml" />
	<cffile action="read" file="#xmlPath#" variable="xml" />
	
	<!--- parse the xml and replace all [plugin] with the actual plugin mapping path --->
	<cfset xml = replaceNoCase( xml, "[plugin]", "plugins.#getPluginConfig().getDirectory()#.", "ALL") />
	<cfif getPluginConfig().getSetting("Integration") eq "Internal">
		<cfset getPluginConfig().setSetting("Integration", '') />
	<cfelse>
		<cfset getPluginConfig().setSetting("Integration", "#getPluginConfig().getSetting('Integration')#.") />
	</cfif>
	
	<cfset xml = replaceNoCase( xml, "[integration]", "#getPluginConfig().getSetting('Integration')#", "ALL") />
	
	<!--- build Coldspring factory --->
	<cfset serviceFactory=createObject("component","coldspring.beans.DefaultXmlBeanFactory").init() />
	<cfset serviceFactory.loadBeansFromXmlRaw( xml ) />
	
	<cfset serviceFactory.setParent(application.servicefactory) />
	<cfset getpluginConfig().getApplication().setValue( "serviceFactory", serviceFactory ) />
	
	<cfset setBeanFactory(request.PluginConfig.getApplication().getValue( "serviceFactory" ))>
</cffunction>

<cffunction name="setupSession" output="false">
	<cfset session.slat = structnew() />
	<cfset session.slat.crumbdata = arraynew(1) />
</cffunction>

<cffunction name="setupRequest" output="false">
	<cfset var item = 0 />
	
	<cfloop collection="#request.context#" item="item">
		<cfif isSimpleValue(request.context[item])>
			<cfif request.context[item] eq '0,1' or request.context[item] eq '1,0'>
				<cfset request.context[item] = 1 />
			</cfif>
		</cfif>
	</cfloop>

	<cfif not structKeyExists(request.context,"$")>
		<cfset request.context.$=getBeanFactory().getBean("muraScope").init(session.siteid)>
	</cfif>
	
	<cfset variables.framework.baseURL="http://#cgi.http_host#/plugins/#getPluginConfig().getDirectory()#/">
</cffunction>
<!--- End: Standard Application Functions,  These are also called from the fw1EventAdapter --->

<!--- Helper Functions --->
<cffunction name="isAdminRequest">
	<cfreturn not structKeyExists(request,"servletEvent")>
</cffunction>

<cffunction name="getExternalSiteLink" output="false" returntype="String">
	<cfargument name="Address" />
	<cfreturn #buildURL(action='external.site', queryString='es=#arguments.Address#')# />
</cffunction>

<!--- End: Helper Functions--->
</cfcomponent>