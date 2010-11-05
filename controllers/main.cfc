<cfcomponent extends="mura.cfobject" output="false">

<cfset variables.pluginConfig="">
<cfset variables.fw="">

<cffunction name="init" output="false">
	<cfargument name="fw">
	<cfset variables.fw=arguments.fw>
</cffunction>

<cffunction name="setPluginConfig" output="false">
	<cfargument name="pluginConfig">
	<cfset variables.pluginConfig=arguments.pluginConfig>
</cffunction>

<cffunction name="before" output="false">
	<cfargument name="rc">
	
	<cfset request.pluginConfig=variables.pluginConfig>
</cffunction>

</cfcomponent>