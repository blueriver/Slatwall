<cfcomponent output="false">
	
	<cffunction name="cfcookie">
		<cfargument name="name" type="string" required="true" />
		<cfargument name="value" type="any" required="true" />
		<cfargument name="expires" type="string" default="session only" />
		<cfargument name="secure" type="boolean" default="false" />
		
		<cfcookie name="#arguments.name#" value="#arguments.value#" expires="#arguments.expires#" secure="#arguments.secure#">
	</cffunction>
	
</cfcomponent>