<cfparam name="rc.message" type="string" default="" />
<cfparam name="rc.messagetype" type="string" default="info" />

<cfif len(trim(rc.message)) gt 0>
<cfoutput>
<p class="messagebox #rc.messagetype#_message">
#htmlEditFormat(rc.$.Slatwall.rbKey(rc.message))#
</p>
</cfoutput>
</cfif>