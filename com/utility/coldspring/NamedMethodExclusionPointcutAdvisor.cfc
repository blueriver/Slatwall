<cfcomponent name="NamedMethodExclusionPointcutAdvisor" 
			displayname="NamedMethodExclusionPointcutAdvisor" 
			extends="coldspring.aop.support.DefaultPointcutAdvisor" 
			hint="Pointcut Advisor to exclude matched method names (with wildcard)" 
			output="false">
	
	<cffunction name="init" access="public" returntype="any" output="false">
		<cfset setPointcut(CreateObject('component','NamedMethodExclusionPointcut').init()) />
		<cfreturn this />
	</cffunction>
	
	<cffunction name="setMappedName" access="public" returntype="void" output="false">
		<cfargument name="mappedName" type="string" required="true" />
		<cfset variables.pointcut.setMappedName(arguments.mappedName) />
	</cffunction>
	
	<cffunction name="setMappedNames" access="public" returntype="void" output="false">
		<cfargument name="mappedNames" type="string" required="true" />
		<cfset variables.pointcut.setMappedNames(arguments.mappedNames) />
	</cffunction>
	
	<cffunction name="matches" access="public" returntype="boolean" output="true">
		<cfargument name="methodName" type="string" required="true" />
		<cfreturn variables.pointcut.matches(arguments.methodName) />
	</cffunction>
	
	<cffunction name="getPointcut" access="public" returntype="coldspring.aop.Pointcut" output="false">
		<cfreturn variables.pointcut  />
	</cffunction>
				
</cfcomponent>