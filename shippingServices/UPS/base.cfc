<!---
	Name         : base.cfc
	Author       : Raymond Camden 
	Created      : December 12, 2006
	Last Updated : 
	History      : 
	Purpose		 : Base CFC

LICENSE 
Copyright 2006 Raymond Camden

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
--->
<cfcomponent output="false" displayName="Base" hint="Base component for UPS package">

<cfset variables.key = "">
<cfset variables.username = "">
<cfset variables.password = "">
<cfset variables.developmentmode = true>

<cffunction name="init" access="public" output="false" returnType="any">
	<cfargument name="key" type="string" required="true">
	<cfargument name="username" type="string" required="true">
	<cfargument name="password" type="string" required="true">
	<cfargument name="developmentmode" type="boolean" required="false">
	
	<cfset variables.key = arguments.key>
	<cfset variables.username = arguments.username>
	<cfset variables.password = arguments.password>
	<cfif structKeyExists(arguments,"developmentmode")>
		<cfset variables.developmentmode = arguments.developmentmode>
	</cfif>
	
	<cfreturn this>
</cffunction>

<cffunction name="generateVerificationXML" access="public" output="false" returnType="string">
	<cfset var packet = "">
	<cfsavecontent variable="packet">
	<cfoutput>
<?xml version="1.0"?>
<AccessRequest>
<AccessLicenseNumber>#getKey()#</AccessLicenseNumber>
<UserId>#getUsername()#</UserId>
<Password>#getPassword()#</Password>
</AccessRequest>
	</cfoutput>
	</cfsavecontent>
	
	<cfreturn trim(packet)>
</cffunction>

<cffunction name="getDevelopmentMode" access="public" output="false" returnType="boolean">
	<cfreturn variables.developmentmode>
</cffunction>

<cffunction name="getKey" access="public" output="false" returnType="string">
	<cfreturn variables.key>
</cffunction>

<cffunction name="getPassword" access="public" output="false" returnType="string">
	<cfreturn variables.password>
</cffunction>

<!---
This function returns the TEST or LIVE url depending on production mode.
Extending CFCs should be sure to set a TEST_URL and LIVE_URL in the variables scope.
--->
<cffunction name="getURL" access="public" output="false" returnType="string">
	<cfif getDevelopmentMode()>
		<cfreturn variables.TEST_URL>
	<cfelse>
		<cfreturn variables.LIVE_URL>
	</cfif>
</cffunction>

<cffunction name="getUsername" access="public" output="false" returnType="string">
	<cfreturn variables.username>
</cffunction>

<cffunction name="setDevelopmentMode" access="public" output="false" returnType="void">
	<cfargument name="developmentmode" type="string" required="true">
	<cfset variables.developmentmode = arguments.developmentmode>
</cffunction>

<cffunction name="setKey" access="public" output="false" returnType="void">
	<cfargument name="key" type="string" required="true">
	<cfset variables.key = arguments.key>
</cffunction>

<cffunction name="setPassword" access="public" output="false" returnType="void">
	<cfargument name="password" type="string" required="true">
	<cfset variables.password = arguments.password>
</cffunction>


<cffunction name="setUsername" access="public" output="false" returnType="void">
	<cfargument name="username" type="string" required="true">
	<cfset variables.username = arguments.username>
</cffunction>

<cffunction name="upsDateParse" access="private" output="false" returnType="date"
			hint="Translates YYYYMMDD into a CF date">
	<cfargument name="dstr" type="string" required="true">
	<cfreturn createDate(left(arguments.dstr, 4), mid(arguments.dstr, 5, 2), right(arguments.dstr, 2))>
</cffunction>

<cffunction name="upsTimeParse" access="private" output="false" returnType="string"
			hint="Translates HHMMSS into a nicer string, HH:MM:SS">
	<cfargument name="dstr" type="string" required="true">
	<cfreturn left(arguments.dstr, 2) & ":" & mid(arguments.dstr, 3, 2) & ":" & right(arguments.dstr, 2)>
</cffunction>

</cfcomponent>