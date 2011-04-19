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
<cfparam name="rc.attributeSets" type="any" />

<cfoutput>
<ul id="navTask">
    <cf_ActionCaller action="admin:attribute.createAttributeSet" type="list">
</ul>

<cfif arrayLen(rc.attributeSets) GT 0>

<!---<cfif arrayLen(rc.attributeSets) gt 1>
	<div id="buttons">
	<a class="button" href="##" style="display:none;" id="saveSort">#rc.$.Slatwall.rbKey("admin.attribute.saveorder")#</a>
	<a class="button" href="##"  id="showSort">#rc.$.Slatwall.rbKey('admin.attribute.reorder')#</a>	
	</div>
</cfif>--->

<table class="stripe" id="AttributeSets">
	<thead>
	<tr>
		<th class="varWidth">#rc.$.Slatwall.rbKey("entity.attributeSet.attributeSetName")#</th>
		<th>#rc.$.Slatwall.rbKey('entity.attributeSet.attributeSetType')#</th>
		<th>&nbsp;</th>
	</tr>
	</thead>
	<tbody id="AttributeSetList">
<cfloop array="#rc.attributeSets#" index="local.thisAttributeSet">
	<tr class="attributeSet" id="#local.thisAttributeSet.getAttributeSetID()#">
		<td class="varWidth">#local.thisAttributeSet.getAttributeSetName()#</td>
		<td>#local.thisAttributeSet.getAttributeSetType().getType()#</td>
		<td class="administration">
		  <ul class="three">
		  	  <cfset local.deleteDisabled = local.thisAttributeSet.getAttributeCount() gt 0 ? true : false />
		      <cf_ActionCaller action="admin:attribute.create" querystring="AttributeSetid=#local.thisAttributeSet.getAttributeSetID()#" class="edit" type="list">
              <cf_ActionCaller action="admin:attribute.detailAttributeSet" querystring="attributeSetid=#local.thisAttributeSet.getAttributeSetID()#" class="viewDetails" type="list">
			  <cf_ActionCaller action="admin:attribute.deleteAttributeSet" querystring="attributeSetid=#local.thisAttributeSet.getAttributeSetID()#" class="delete" type="list" disabled="#local.deleteDisabled#" confirmrequired="true">
		  </ul>		
		
		</td>
	</tr>
</cfloop>
    </tbody>
</table>

<cfelse>
	<p><em>#rc.$.Slatwall.rbKey("admin.attribute.noAttributeSetsdefined")#</em></p>
</cfif>

</cfoutput>
