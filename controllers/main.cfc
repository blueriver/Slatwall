<cfcomponent extends="mura.cfobject" output="false">

<cfset variables.pluginConfig="">
<cfset variables.contentManager="">
<cfset variables.fw="">

<cffunction name="init" output="false">
<cfargument name="fw">
<cfset variables.fw=arguments.fw>
</cffunction>

<cffunction name="setPluginConfig" output="false">
<cfargument name="pluginConfig">
<cfset variables.pluginConfig=arguments.pluginConfig>
</cffunction>

<cffunction name="setContentManager" output="false">
<cfargument name="ContentManager">
<cfset variables.ContentManager=arguments.ContentManager>
</cffunction>

<cffunction name="before" output="false">
<cfargument name="rc">
<cfset rc.pluginConfig=variables.pluginConfig>
</cffunction>

</cfcomponent>