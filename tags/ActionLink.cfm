<cfparam name="attributes.action" type="string" />
<cfparam name="attributes.querystring" type="string" default="" />
<cfparam name="attributes.text" type="string" default="">
<cfparam name="attributes.atitle" type="string" default="">
<cfparam name="attributes.aclass" type="string" default="">
<cfparam name="attributes.listitem" type="boolean" default="false" >
<cfparam name="attributes.liclass" type="string" default="">

<cfset variables.fw = caller.this />

<cfif attributes.aclass eq "">
	<cfset attributes.aclass = Replace(Replace(attributes.action, ":", "", "all"), ".", "", "all") />
</cfif>

<cfif attributes.text eq "">
	<cfset attributes.text = request.slatwallScope.rbKey("#Replace(attributes.action, ":", ".", "all")#_nav") />
	<cfif right(attributes.text, 8) eq "_missing" >
		<cfset attributes.text = request.slatwallScope.rbKey("#Replace(attributes.action, ":", ".", "all")#") />
	</cfif>
</cfif>

<cfif attributes.atitle eq "">
	<cfset attributes.text = request.slatwallScope.rbKey("#Replace(attributes.action, ":", ".", "all")#_title") />
	<cfif right(attributes.text, 8) eq "_missing" >
		<cfset attributes.text = request.slatwallScope.rbKey("#Replace(attributes.action, ":", ".", "all")#") />
	</cfif>
	<cfset attributes.atitle = attributes.text />
</cfif>


<cfif thisTag.executionMode is "start">
	<cfif variables.fw.secureDisplay(action=attributes.action)>
		<cfoutput>
			<cfif attributes.listitem><li <cfif attributes.liclass neq "">class="#attributes.liclass#"</cfif>></cfif><a href="#variables.fw.buildURL(action=attributes.action,querystring=attributes.querystring)#" title="#attributes.atitle#">#attributes.text#</a><cfif attributes.listitem></li></cfif>
		</cfoutput>
	</cfif>
</cfif>