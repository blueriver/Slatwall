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
<cfparam name="rc.listBy" type="string" />
<cfparam name="rc.attributes" type="any" />
<cfparam name="rc.attributeSets" type="any" />

<cfoutput>
<ul id="navTask">
    <cf_ActionCaller action="admin:attribute.createAttributeSet" type="list">
	<cfif rc.listby EQ "attributeSets">
		<cf_ActionCaller action="admin:attribute.list" text="#rc.$.Slatwall.rbKey('admin.attribute.listbyAttributes')#" querystring="listby=attributes" type="list">
	<cfelseif rc.listby EQ "attributes">
		<cf_ActionCaller action="admin:attribute.list" text="#rc.$.Slatwall.rbKey('admin.attribute.listbyAttributeSets')#" querystring="listby=attributeSets" type="list">
	</cfif>
</ul>

<cfif arrayLen(rc.attributeSets) GT 0>

	<cfif rc.listby eq "attributes">
	<form name="filterAttributes" method="get">
		 #rc.$.Slatwall.rbKey("admin.option.attributeSetFilter")#:
		<input type="hidden" name="action" value="admin:attribute.list" />
		<input type="hidden" name="listby" value="attributes" />
		<select name="F_attributeSet_attributeSetName">
			<option value="">#rc.$.Slatwall.rbKey('admin.attribute.showall')#</option>
		<cfloop array="#rc.attributeSets#" index="local.thisAttributeSet">
			<option value="#local.thisAttributeSet.getAttributeSetName()#"<cfif structKeyExists(rc,"F_attributeSet_attributeSetname") and rc.F_attributeSet_attributeSetname eq local.thisattributeSet.getattributeSetName()> selected="selected"</cfif>>#local.thisAttributeSet.getAttributeSetName()#</option>
		</cfloop>
		</select>
		<cf_ActionCaller action="admin:attribute.list" type="submit" text="#rc.$.Slatwall.rbKey('admin.attribute.show')#">
	</form>
	#view("attribute/inc/attributeTable")#
	<cfelse>
	#view("attribute/inc/attributeSetTable")#
	</cfif>

<cfelse>
	<p><em>#rc.$.Slatwall.rbKey("admin.attribute.noattributeSetsdefined")#</em></p>
</cfif>

</cfoutput>
