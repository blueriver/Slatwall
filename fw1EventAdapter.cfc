<cfcomponent extends="mura.plugin.pluginGenericEventHandler">
	
	<!--- Include FW/1 configuration that is shared between then adapter and the application. --->
	<cfinclude template="fw1Config.cfm">
	
	<cffunction name="onApplicationLoad">
		<cfargument name="$">
		
		<cfset var serviceFactory = "" />
		<cfset var xml = "" />
		<cfset var xmlPath = "" />
		
		<cfset xmlPath = "#expandPath( '\plugins' )#/#variables.pluginConfig.getDirectory()#/config/coldspring.xml" />
		<cffile action="read" file="#xmlPath#" variable="xml" />
		
		<!--- parse the xml and replace all [plugin] with the actual plugin mapping path --->
		<cfset xml = replaceNoCase( xml, "[plugin]", "plugins.#variables.pluginConfig.getDirectory()#.", "ALL") />
		<cfif variables.pluginConfig.getSetting("Integration") eq "Internal">
			<cfset variables.pluginConfig.setSetting("Integration", '') />
		<cfelse>
			<cfset variables.pluginConfig.setSetting("Integration", "#variables.pluginConfig.getSetting('Integration')#.") />
		</cfif>
		
		<cfset xml = replaceNoCase( xml, "[integration]", "#variables.pluginConfig.getSetting('Integration')#", "ALL") />
		
		<!--- build Coldspring factory --->
		<cfset serviceFactory=createObject("component","coldspring.beans.DefaultXmlBeanFactory").init() />
		<cfset serviceFactory.loadBeansFromXmlRaw( xml ) />
		<cfset serviceFactory.setParent($.getServiceFactory()) />
		<cfset variables.pluginConfig.getApplication().setValue( "serviceFactory", serviceFactory ) />
		
		<!--- invoke onApplicationStart in the application.cfc so the framework can do its thing --->
		<cfinvoke component="#variables.pluginConfig.getPackage()#.Application" method="onApplicationStart"  />
		
		<cfset variables.pluginConfig.addEventHandler(this)>
	</cffunction>
	
	<!--- this is the plugin hook in for mura --->
	<cffunction name="onSiteRequestStart">
        <cfargument name="$">
        
        <!--- put the plugin into the event --->
        <cfset $[variables.framework.applicationKey]= this />
		<cfinvoke component="#pluginConfig.getPackage()#.Application" method="setupRequest" />
    </cffunction>
		
	<cffunction name="onGlobalSessionStart">
		<cfargument name="$">

		<!--- invoke onApplicationStart in the application.cfc so the framework can do its thing --->
		<cfinvoke component="#pluginConfig.getPackage()#.Application" method="onSessionStart" />
	</cffunction>
	
</cfcomponent>