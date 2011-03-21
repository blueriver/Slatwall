<cfcomponent name="NamedMethodExclusionPointcut" 
			displayname="NamedMethodExclusionPointcut" 
			extends="coldspring.aop.Pointcut" 
			hint="Pointcut to exclude matched method names (with wildcard)" 
			output="false">
			
	<cfset variables.mappedNames = 0 />
	
	<cffunction name="init" access="public" returntype="coldspring.aop.support.NamedMethodExclusionPointcut" output="false">
		<cfreturn this />
	</cffunction>
	
	<cffunction name="setMappedName" access="public" returntype="void" output="false">
		<cfargument name="mappedName" type="string" required="true" />
		<cfset setMappedNames(arguments.mappedName) />
	</cffunction>
	
	<cffunction name="setMappedNames" access="public" returntype="void" output="false">
		<cfargument name="mappedNames" type="string" required="true" />
		<cfset var name = '' />
		<cfset variables.mappedNames = ArrayNew(1) />
		<cfloop list="#arguments.mappedNames#" index="name">
			<cfset ArrayAppend(variables.mappedNames, name) />
		</cfloop>
	</cffunction>
	
	<cffunction name="matches" access="public" returntype="boolean" output="true">
		<cfargument name="methodName" type="string" required="true" />
		<cfset var mappedName = '' />
		<cfset var ix = 0 />
		
		<cfif isArray(variables.mappedNames) and ArrayLen(variables.mappedNames)>
			<cfloop from="1" to="#ArrayLen(variables.mappedNames)#" index="ix">
				<cfset mappedName = variables.mappedNames[ix] />
				<cfif (arguments.methodName EQ mappedName) OR
					  isMatch(arguments.methodName, mappedName) >
					<cfreturn false />	  
				</cfif>
			</cfloop>
			<cfreturn true />
		<cfelse>
			<cfthrow type="coldspring.aop.InvalidMappedNames" message="You must provide the NamedMethodPointcutAdvisor with a list of method names to match. Use '*' of you would like to match all methods!" />
		</cfif>
	</cffunction>
			
	<cffunction name="isMatch" access="private" returntype="boolean" output="true">
		<cfargument name="methodName" type="string" required="true" />
		<cfargument name="mappedName" type="string" required="true" />
		<cfif mappedName EQ "*">
			<cfreturn true />
		<cfelseif mappedName.startsWith('*')>
			<cfreturn methodName.endsWith(Right(mappedName,mappedName.length()-1)) />
		<cfelseif mappedName.endsWith('*')>
			<cfreturn methodName.startsWith(Left(mappedName, mappedName.length()-1)) />
		</cfif>
		<cfreturn false />
	</cffunction>
				
</cfcomponent>