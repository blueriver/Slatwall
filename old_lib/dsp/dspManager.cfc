<cfcomponent output="false" name="dspManager" hint="This Component Return all of the Core Slatwall HTML content.  It is designed to be accessed via Layout, DisplayObjects, and the ajaxManager">

	<cffunction name="init" access="public" returntype="any" output="false">
		<cfargument name="dspAccount" type="any" required="yes"/>
		<cfargument name="dspBilling" type="any" required="yes"/>
		<cfargument name="dspCart" type="any" required="yes"/>
		<cfargument name="dspProduct" type="any" required="yes"/>
		<cfargument name="dspShipping" type="any" required="yes"/>
		
		<cfset variables.dspAccount=arguments.dspAccount />
		<cfset variables.dspBilling=arguments.dspBilling />
		<cfset variables.dspCart=arguments.dspCart />
		<cfset variables.dspProduct=arguments.dspProduct />
		<cfset variables.dspShipping=arguments.dspShipping />
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="get" access="public" returntype="any" output="false">
		<cfargument name="Display" required="true" type="string" hint="The HTML Object you would like Returned" />
		<cfargument name="DisplaySettings" required="false" type="struct" default="#structNew()#" hint="A Struct Containing any Custom Settings the HTML Object Can use" />
		
		<cfset var ReturnHTML = "" />
		
		<cfswitch expression="#Left(arguments.Display,4)#">
			<cfcase value="Bill">
				<cfinvoke component="#variables.dspBilling#" method="get#arguments.Display#" argumentcollection="#arguments.DisplaySettings#" returnvariable="ReturnHTML" />
			</cfcase>
			<cfcase value="Ship">
				<cfinvoke component="#variables.dspShipping#" method="get#arguments.Display#" argumentcollection="#arguments.DisplaySettings#" returnvariable="ReturnHTML" />
			</cfcase>
			<cfcase value="Cart">
				<cfinvoke component="#variables.dspCart#" method="get#arguments.Display#" argumentcollection="#arguments.DisplaySettings#" returnvariable="ReturnHTML" />
			</cfcase>
			<cfcase value="Acco">
				<cfinvoke component="#variables.dspAccount#" method="get#arguments.Display#" argumentcollection="#arguments.DisplaySettings#" returnvariable="ReturnHTML" />
			</cfcase>
			<cfcase value="Prod">
				<cfinvoke component="#variables.dspProduct#" method="get#arguments.Display#" argumentcollection="#arguments.DisplaySettings#" returnvariable="ReturnHTML" />
			</cfcase>
		</cfswitch>
		
		<!---
		<cflock name="DisplayLock" timeout="10">
			<cfset var ArgumentString = "" />
			<cfset var ArgumentValue = "" />
			
			<cfset var Setting = "" />
			<cfset var LoopCount = 0 />
			<cfset var DisplayComponent = "" />
			
			<cfloop collection="#arguments.DisplaySettings#" item="Setting">
				<cfset LoopCount = LoopCount + 1>
				<cfset ArgumentValue = StructFind(arguments.DisplaySettings, Setting) />
				<cfset ArgumentValue = "'#ArgumentValue#'" />
				<cfset ArgumentString = "#ArgumentString##Setting#=#ArgumentValue#" />
				<cfif structCount(arguments.DisplaySettings) gt LoopCount>
					<cfset ArgumentString = "#ArgumentString#,">
				</cfif>
			</cfloop>
			
			<cfset ArgumentString = Replace(ArgumentString,"#chr(35)#","#chr(35)##chr(35)#","all") />
			
			<cfswitch expression="#Left(arguments.Display,4)#">
				<cfcase value="Bill">
					<cfset DisplayComponent = "dspBilling" />
				</cfcase>
				<cfcase value="Ship">
					<cfset DisplayComponent = "dspShipping" />
				</cfcase>
				<cfcase value="Cart">
					<cfset DisplayComponent = "dspCart" />
				</cfcase>
				<cfcase value="Acco">
					<cfset DisplayComponent = "dspAccount" />
				</cfcase>
				<cfcase value="Prod">
					<cfset DisplayComponent = "dspProduct" />
				</cfcase>
			</cfswitch>
			
			
			<cfset ReturnHTML = Evaluate("variables.#DisplayComponent#.get#arguments.Display#(#ArgumentString#)")>
			
		</cflock>	
		--->
		
		<cfreturn ReturnHTML />
	</cffunction>
	
	<cffunction name="getDebug" returnType="any" output="false">
		<cfset var DebugStruct = structNew() />
		<cfset DebugStruct.Variables = variables />
		<cfset DebugStruct.dspAccount = variables.dspAccount.getDebug() />
		<cfset DebugStruct.dspBilling = variables.dspBilling.getDebug() />
		<cfset DebugStruct.dspCart = variables.dspCart.getDebug() />
		<cfset DebugStruct.dspProduct = variables.dspProduct.getDebug() />
		<cfset DebugStruct.dspShipping = variables.dspShipping.getDebug() />
		<cfreturn DebugStruct />
	</cffunction>
	
</cfcomponent>
