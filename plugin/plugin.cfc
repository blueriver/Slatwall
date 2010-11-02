<cfcomponent output="false" extends="mura.plugin.plugincfc">
	<cffunction name="install" returntype="void" access="public" output="false">
		<cfset application.appInitialized = false>
	</cffunction>
	
	<cffunction name="update" returntype="void" access="public" output="false">
		<!--- <cfset application.slat.dbUpdate.update(ConfigDirectory="#expandPath('#application.slatsettings.getSetting('PluginPath')#/config')#", RemoveTables=0) /> --->
	</cffunction>
	
	<cffunction name="delete" returntype="void" access="public" output="false">
		<!--- <cfset application.slat.dbUpdate.update(ConfigDirectory="#expandPath('#application.slatsettings.getSetting('PluginPath')#/config')#", RemoveTables=1) /> --->
	</cffunction>
</cfcomponent>