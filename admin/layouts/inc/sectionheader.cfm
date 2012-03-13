<cfoutput>
	<div class="page-header">
		<h1>#rc.$.slatwall.rbKey(replace(rc.slatAction,":",".","all"))#</h1>
	</div>
	
	<cfif structKeyExists(rc,"message") && structKeyExists(rc,"messageType") && len(trim(rc.message)) gt 0>
		<cfset local.message = rc.$.Slatwall.rbKey(rc.message) />
		<cfif right(local.message,8) eq "_missing">
			<cfset local.message = rc.message />
		</cfif>
	</cfif>
	<!--- display messages --->
	<cfif structKeyExists(local,"message")>
		<p class="messagebox #rc.messagetype#_message">
			#htmlEditFormat(local.message)#
		</p>
	</cfif>
	
	<!---  display any errors --->
	<cfif structKeyExists(rc,"errorBean")>
		<cfset local.errors = rc.errorBean.getErrors() />
		<ul class="errors">
		<cfloop collection="#local.errors#" item="local.thisError">
			<cfloop array="#local.errors[local.thisError]#" index="local.em" >
				<li>#local.em#</li>
			</cfloop>
		</cfloop>
		</ul>
	</cfif>
</cfoutput>