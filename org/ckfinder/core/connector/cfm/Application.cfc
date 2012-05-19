<!---
 * CKFinder
 * ========
 * http://ckfinder.com
 * Copyright (C) 2007-2012, CKSource - Frederico Knabben. All rights reserved.
 *
 * The software, this file and its contents are subject to the CKFinder
 * License. Please read the license.txt file before using, installing, copying,
 * modifying or distribute this file or part of its contents. The contents of
 * this file is part of the Source Code of CKFinder.
--->

<cfcomponent displayname="Application" output="false" hint="Pre-page processing for the application">

	<!---
	Run the pseudo constructor to set up default
	data structures.
	--->
	<cfscript>
	// Set up the application.
	THIS.Name = "CKFinder_Connector";
	THIS.ApplicationTimeout = "#CreateTimeSpan( 0, 2, 0, 0 )#";
	THIS.SessionTimeout = "#CreateTimeSpan(0,0,45,0)#";
	THIS.SessionManagement = true;
	THIS.SetClientCookies = true;
	THIS.mappings["/CKFinder_Connector"] = getDirectoryFromPath(getCurrentTemplatePath());
	</cfscript>

	<!--- Include the CFC creation proxy. --->
	<cfinclude template="createcfc.udf.cfm" />

	<!--- Required by flash uloader --->
	<cffunction name="onSessionStart" access="public" returntype="void" output="false" hint="I initialize the session.">
		<cfset var requestData = GetHTTPRequestData()>
		<cfif LCase(requestData.method) eq "post">
			<!--- ColdFusion 9 does not use CFID/CFTOKEN passed in the URL, so we need to do it manually. --->
			<cfif isDefined('URL.CFID')>
				<cfcookie name="CFID" value="#URL.CFID#" />
			</cfif>
			<cfif isDefined('URL.CFTOKEN')>
				<cfcookie name="CFTOKEN" value="#URL.CFTOKEN#" />
			</cfif>
			<cfif isDefined('URL.JSESSIONID')>
				<cfcookie name="JSESSIONID" value="#URL.JSESSIONID#" />
			</cfif>
		</cfif>
		<cfreturn />
	</cffunction>

	<cffunction name="OnRequestStart" access="public" returntype="boolean" output="false" hint="Pre-page processing for the page request.">
		<!---
		Store the CreateCFC method in the application
		scope.
		--->
		<cfset APPLICATION.CreateCFC = THIS.CreateCFC />
		<cfset APPLICATION.CFVersion = Left(SERVER.COLDFUSION.PRODUCTVERSION,Find(",",SERVER.COLDFUSION.PRODUCTVERSION)-1) />
		<cfreturn true />
	</cffunction>

</cfcomponent>
