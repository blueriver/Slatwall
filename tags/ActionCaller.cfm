<cfparam name="attributes.action" type="string" />
<cfparam name="attributes.type" type="string" default="link">
<cfparam name="attributes.querystring" type="string" default="" />
<cfparam name="attributes.text" type="string" default="">
<cfparam name="attributes.title" type="string" default="">
<cfparam name="attributes.class" type="string" default="">

<cfset variables.fw = caller.this />

<cfset attributes.class &= " " & Replace(Replace(attributes.action, ":", "", "all"), ".", "", "all") />

<cfif attributes.text eq "">
	<cfset attributes.text = request.customMuraScopeKeys.slatwall.rbKey("#Replace(attributes.action, ":", ".", "all")#_nav") />
	<cfif right(attributes.text, 8) eq "_missing" >
		<cfset attributes.text = request.customMuraScopeKeys.slatwall.rbKey("#Replace(attributes.action, ":", ".", "all")#") />
	</cfif>
</cfif>

<cfif attributes.title eq "">
	<cfset attributes.text = request.customMuraScopeKeys.slatwall.rbKey("#Replace(attributes.action, ":", ".", "all")#_title") />
	<cfif right(attributes.text, 8) eq "_missing" >
		<cfset attributes.text = request.customMuraScopeKeys.slatwall.rbKey("#Replace(attributes.action, ":", ".", "all")#") />
	</cfif>
	<cfset attributes.atitle = attributes.text />
</cfif>


<cfif thisTag.executionMode is "start">
	<cfif variables.fw.secureDisplay(action=attributes.action)>
		<cfif attributes.type eq "link">
			<cfoutput><a href="#variables.fw.buildURL(action=attributes.action,querystring=attributes.querystring)#" title="#attributes.title#" class="#attributes.class#">#attributes.text#</a></cfoutput>
		<cfelseif attributes.type eq "list">
			<cfoutput><li class="#attributes.class#"><a href="#variables.fw.buildURL(action=attributes.action,querystring=attributes.querystring)#" title="#attributes.title#" class="#attributes.class#">#attributes.text#</a></li></cfoutput> 
		<cfelseif attributes.type eq "button">
			<cfoutput><button type="button" class="#attributes.class#" name="action" value="#attributes.action#" title="#attributes.title#">#attributes.text#</button></cfoutput>
		<cfelseif attributes.type eq "submit">
			<cfoutput><button type="submit" class="#attributes.class#" name="action" value="#attributes.action#" title="#attributes.title#">#attributes.text#</button></cfoutput>
		</cfif>
	</cfif>
</cfif>