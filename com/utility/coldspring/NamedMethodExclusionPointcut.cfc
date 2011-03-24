<!---

    Slatwall - An e-commerce plugin for Mura CMS
    Copyright (C) 2011 ten24, LLC

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
    
    Linking this library statically or dynamically with other modules is
    making a combined work based on this library.  Thus, the terms and
    conditions of the GNU General Public License cover the whole
    combination.
 
    As a special exception, the copyright holders of this library give you
    permission to link this library with independent modules to produce an
    executable, regardless of the license terms of these independent
    modules, and to copy and distribute the resulting executable under
    terms of your choice, provided that you also meet, for each linked
    independent module, the terms and conditions of the license of that
    module.  An independent module is a module which is not derived from
    or based on this library.  If you modify this library, you may extend
    this exception to your version of the library, but you are not
    obligated to do so.  If you do not wish to do so, delete this
    exception statement from your version.

Notes:

--->
<cfcomponent name="NamedMethodExclusionPointcut" 
			displayname="NamedMethodExclusionPointcut" 
			extends="coldspring.aop.Pointcut" 
			hint="Pointcut to exclude matched method names (with wildcard)" 
			output="false">
			
	<cfset variables.mappedNames = 0 />
	
	<cffunction name="init" access="public" returntype="any" output="false">
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
