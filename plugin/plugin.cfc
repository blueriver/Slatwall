<cfcomponent output="false" extends="mura.plugin.plugincfc">

	<cffunction name="install" returntype="void" access="public" output="false">
		<cfset application.appInitialized=false />
	</cffunction>
	
	<cffunction name="update" returntype="void" access="public" output="false">
		<cfset application.appInitialized=false />
	</cffunction>

</cfcomponent>