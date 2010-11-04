<cfcomponent extends="mura.plugin.pluginGenericEventHandler">
	
	<cfset variables.preserveKeyList="context,base,cfcbase,subsystem,subsystembase,section,item,services,action,controllerExecutionStarted">
	
	<!--- Include FW/1 configuration that is shared between then adapter and the application. --->
	<cfinclude template="fw1Config.cfm">
	
	<!--- this is the plugin hook in for mura --->
	<cffunction name="onSiteRequestStart" output="false">
        <cfargument name="$">
        
        <!--- put the plugin into the event --->
        <cfset $[variables.framework.applicationKey]= this />
    </cffunction>
	
	<cffunction name="onApplicationLoad" output="false">
		<cfargument name="$">
		<cfset var state=preseveInternalState(request)>
		<cfset request.pluginConfig=variables.pluginConfig>
		<cfinvoke component="#pluginConfig.getPackage()#.Application" method="onApplicationStart" />
		<cfset restoreInternalState(request,state)>
		<cfset variables.pluginConfig.addEventHandler(this)>
	</cffunction>
	
	<cffunction name="onGlobalSessionStart" output="false">
		<cfargument name="$">
		<cfset var state=preseveInternalState(request)>
		<cfinvoke component="#pluginConfig.getPackage()#.Application" method="onSessionStart" />
		<cfset restoreInternalState(request,state)>
	</cffunction>

	<cffunction name="preseveInternalState" output="false">
		<cfargument name="state">
		<cfset var preserveKeys=structNew()>
		<cfset var k="">
		
		<cfloop list="#variables.preserveKeyList#" index="k">
			<cfif isDefined("arguments.state.#k#")>
				<cfset preserveKeys[k]=arguments.state[k]>
				<cfset structDelete(arguments.state,k)>
			</cfif>
		</cfloop>
		
		<cfset structDelete( arguments.state, "serviceExecutionComplete" )>
		
		<cfreturn preserveKeys>
	</cffunction>
	
	<cffunction name="restoreInternalState" output="false">
		<cfargument name="state">
		<cfargument name="restore">
		
		<cfloop list="#variables.preserveKeyList#" index="k">
				<cfset structDelete(arguments.state,k)>
		</cfloop>
		
		<cfset structAppend(state,restore,true)>
		<cfset structDelete( state, "serviceExecutionComplete" )>
	</cffunction>
	
</cfcomponent>