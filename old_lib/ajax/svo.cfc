<cfcomponent extends="slat.framework" output="false" name="ajaxManager" hint="">
	
	<cfinclude template="../../fw1Config.cfm">
	
	<cffunction name="init" access="public" returntype="any" output="false">
		<cfreturn this />
	</cffunction>
	
	<cffunction name="getNewAjaxHook" access="remote" returntype="string" output="false">
		<cfset NewRandom = round(rand()*1000000) />
		<cfset NewAjaxHook = "sah#NewRandom#" />
		<cfreturn NewAjaxHook />
	</cffunction>
	
	<cffunction name="getSVO" access="remote" returntype="string" output="false">
		<cfargument name="svo" type="string" required="true" />
		<cfargument name="args" type="struct" default="#structNew()#" />
		
		<cfset var result = "" />
		<cfset var fw1 = createObject("component","slat.Application") />
		
		<cfset url[variables.framework.action] = Replace(arguments.svo,'/',".","all") />
				
		<!--- call the frameworks onRequestStart --->
		<cfset fw1.onRequestStart('index.cfm') />
		<cfset fw1.onRequest('index.cfm') />
		<cfset fw1.SlatGlobalRequestStart() />
		<!--- call the frameworks onRequest --->
		<!--- we save the results via cfsavecontent so we can display it in mura --->
		<cfsavecontent variable="result">
			<cfoutput>#fw1.view(arguments.svo, arguments.args)#</cfoutput>
		</cfsavecontent>
		
		<cfreturn 'svo#replace(arguments.svo,"/","","all")#~#result#' />
	</cffunction>
</cfcomponent>