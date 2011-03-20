<cfparam name="rc.message" type="string" default="" />
<cfparam name="rc.messagetype" type="string" default="info" />

<cfif len(trim(rc.message)) gt 0>
	<cfset local.message = rc.$.Slatwall.rbKey(rc.message) />
	<cfif right(local.message,8) eq "_missing">
		<cfset local.message = rc.message />
	</cfif>
</cfif>

<cfif structKeyExists(local,"message")>
<cfoutput>
<p class="messagebox #rc.messagetype#_message">
#htmlEditFormat(local.message)#
</p>
</cfoutput>
</cfif>