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
<cfparam name="attributes.action" type="string" />
<cfparam name="attributes.type" type="string" default="link">
<cfparam name="attributes.querystring" type="string" default="" />
<cfparam name="attributes.text" type="string" default="">
<cfparam name="attributes.title" type="string" default="">
<cfparam name="attributes.class" type="string" default="">
<cfparam name="attributes.confirmrequired" type="boolean" default="false" />
<cfparam name="attributes.confirmtext" type="string" default="" />
<cfparam name="attributes.disabled" type="boolean" default="false" />
<cfparam name="attributes.disabledtext" type="string" default="" />

<cfset variables.fw = caller.this />

<cfset attributes.class = Replace(Replace(attributes.action, ":", "", "all"), ".", "", "all") & " " & attributes.class />

<cfif attributes.text eq "">
	<cfset attributes.text = request.customMuraScopeKeys.slatwall.rbKey("#Replace(attributes.action, ":", ".", "all")#_nav") />
	<cfif right(attributes.text, 8) eq "_missing" >
		<cfset attributes.text = request.customMuraScopeKeys.slatwall.rbKey("#Replace(attributes.action, ":", ".", "all")#") />
	</cfif>
</cfif>

<cfif attributes.title eq "">
	<cfset attributes.title = request.customMuraScopeKeys.slatwall.rbKey("#Replace(attributes.action, ":", ".", "all")#_title") />
	<cfif right(attributes.title, 8) eq "_missing" >
		<cfset attributes.title = request.customMuraScopeKeys.slatwall.rbKey("#Replace(attributes.action, ":", ".", "all")#") />
	</cfif>
</cfif>

<cfif attributes.disabled is true>
    <cfif trim(attributes.disabledtext) eq "">
       <cfset attributes.disabledtext = request.customMuraScopeKeys.slatwall.rbKey("#Replace(attributes.action, ":", ".", "all")#_disabled") />
	</cfif>
	<cfset attributes.class &= "Off" />
</cfif>

<cfif attributes.confirmrequired is true>
    <cfif trim(attributes.confirmtext) eq "">
       <cfset attributes.confirmtext = request.customMuraScopeKeys.slatwall.rbKey("#Replace(attributes.action, ":", ".", "all")#_confirm") />
	</cfif>
</cfif>

<cfif thisTag.executionMode is "start">
	<cfif variables.fw.secureDisplay(action=attributes.action)>
		<cfif attributes.type eq "link">
			<cfoutput><a href="#variables.fw.buildURL(action=attributes.action,querystring=attributes.querystring)#" title="#attributes.title#" class="#attributes.class#"<cfif attributes.disabled> onclick="return alertDialog('#attributes.disabledtext#');"<cfelseif attributes.confirmrequired> onclick="return confirmDialog('#attributes.confirmtext#',this.href);"</cfif>>#attributes.text#</a></cfoutput>
		<cfelseif attributes.type eq "list">
			<cfoutput><li class="#attributes.class#"><a href="#variables.fw.buildURL(action=attributes.action,querystring=attributes.querystring)#" title="#attributes.title#" class="#attributes.class#"<cfif attributes.disabled> onclick="return alertDialog('#attributes.disabledtext#');"<cfelseif attributes.confirmrequired> onclick="return confirmDialog('#attributes.confirmtext#',this.href);"</cfif>>#attributes.text#</a></li></cfoutput> 
		<cfelseif attributes.type eq "button">
			<cfoutput><button type="button" class="#attributes.class#" name="slatAction" value="#attributes.action#" title="#attributes.title#"<cfif attributes.disabled> onclick="return alertDialog('#attributes.disabledtext#');"<cfelseif attributes.confirmrequired> onclick="return btnConfirmDialog('#attributes.confirmtext#',this);"</cfif>>#attributes.text#</button></cfoutput>
		<cfelseif attributes.type eq "submit">
			<cfoutput><button type="submit" class="#attributes.class#" name="slatAction" value="#attributes.action#" title="#attributes.title#"<cfif attributes.disabled> onclick="return alertDialog('#attributes.disabledtext#');"<cfelseif attributes.confirmrequired> onclick="return btnConfirmDialog('#attributes.confirmtext#',this);"</cfif>>#attributes.text#</button></cfoutput>
		</cfif>
	</cfif>
</cfif>
