<cfcomponent>
	<cffunction name="doAction">
		<cfargument name="$">
		<cfargument name="action" type="string" required="false" default="" hint="Optional: If not passed it looks into the event for a defined action, else it uses the default"/>
		
		<!--- test --->
		
		<cfset var result = "" />
		<cfset var savedEvent = "" />
		<cfset var savedAction = "" />
		<cfset var fw1 = createObject("component","#pluginConfig.getPackage()#.Application") />
		
		<!--- Create a Mura struct in the url scope to pass stuff to FW/1 --->
		<cfset url.Mura = StructNew() />
		<!--- Put the current path into the url struct, to be used by FW/1 --->
		<cfset url.Mura.currentPath = CGI.SCRIPT_NAME & "/" & $.event('currentFilename') & "/" />
		<!--- Put the event url struct, to be used by FW/1 --->
		<cfset url.Mura.$ = $ />
		
		<cfif not len( arguments.action )>
			<cfif len(arguments.$.event(variables.framework.action))>
				<cfset arguments.action=arguments.$.event(variables.framework.action)>
			<cfelse>
				<cfset arguments.action=variables.framework.home>
			</cfif>
		</cfif>
		
		<!--- put the action passed into the url scope, saving any pre-existing value --->
		<cfif StructKeyExists(request, variables.framework.action)>
			<cfset savedEvent = request[variables.framework.action] />
		</cfif>
		<cfif StructKeyExists(url,variables.framework.action)>
			<cfset savedAction = url[variables.framework.action] />
		</cfif>
		
		<cfset url[variables.framework.action] = arguments.action />
				
		<!--- call the frameworks onRequestStart --->
		<cfset fw1.onRequestStart(CGI.SCRIPT_NAME) />
		
		<!--- call the frameworks onRequest --->
		<!--- we save the results via cfsavecontent so we can display it in mura --->
		<cfsavecontent variable="result">
			<cfset fw1.onRequest(CGI.SCRIPT_NAME) />
		</cfsavecontent>
		
		<!--- restore the url scope --->
		<cfif structKeyExists(url,variables.framework.action)>
			<cfset structDelete(url,variables.framework.action) />
		</cfif>
		<!--- if there was a passed in action via the url then restore it --->
		<cfif Len(savedAction)>
			<cfset url[variables.framework.action] = savedAction />
		</cfif>
		<!--- if there was a passed in request event then restore it --->
		<cfif Len(savedEvent)>
			<cfset request[variables.framework.action] = savedEvent />
		</cfif>
		
		<!--- remove the content from the request scope --->
		<!--- at this point if anything needed to be stored it should have been done so by pushing stored elements into the mura event for later use --->
		<cfset structDelete( request, "context" )>
		<cfset structDelete( request, "serviceExecutionComplete" )>
		
		<!--- return the result --->
		<cfreturn result>
	</cffunction>
</cfcomponent>