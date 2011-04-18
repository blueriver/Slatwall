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
<cfparam name="rc.options" type="any" />
<cfparam name="rc.optionGroups" type="any" />

<cfoutput>
<ul id="navTask">
    <cf_ActionCaller action="admin:option.createoptiongroup" type="list">
	<cfif rc.listby EQ "optiongroups">
		<cf_ActionCaller action="admin:option.list" text="#rc.$.Slatwall.rbKey('admin.option.listbyoptions')#" querystring="listby=options" type="list">
	<cfelseif rc.listby EQ "options">
		<cf_ActionCaller action="admin:option.list" text="#rc.$.Slatwall.rbKey('admin.option.listbyoptiongroups')#" querystring="listby=optiongroups" type="list">
	</cfif>
</ul>

<cfif arrayLen(rc.optionGroups) GT 0>

	<cfif rc.listby eq "options">
	<form name="filterOptions" method="get">
		 #rc.$.Slatwall.rbKey("admin.option.optiongroupfilter")#:
		<input type="hidden" name="action" value="admin:option.list" />
		<input type="hidden" name="listby" value="options" />
		<select name="F_optiongroup_optiongroupname">
			<option value="">#rc.$.Slatwall.rbKey('admin.option.showall')#</option>
		<cfloop array="#rc.optionGroups#" index="local.thisOptionGroup">
			<option value="#local.thisOptionGroup.getOptionGroupName()#"<cfif structKeyExists(rc,"F_optiongroup_optiongroupname") and rc.F_optiongroup_optiongroupname eq local.thisOptionGroup.getOptionGroupName()> selected="selected"</cfif>>#local.thisOptionGroup.getOptionGroupName()#</option>
		</cfloop>
		</select>
		<cf_ActionCaller action="admin:option.list" type="submit" text="#rc.$.Slatwall.rbKey('admin.option.show')#">
	</form>
	#view("option/inc/optiontable")#
	<cfelse>
	#view("option/inc/optiongrouptable")#
	</cfif>

<cfelse>
	<p><em>#rc.$.Slatwall.rbKey("admin.option.nooptiongroupsdefined")#</em></p>
</cfif>

</cfoutput>
