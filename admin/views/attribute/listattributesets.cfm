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
<cfparam name="rc.attributeSetSmartList" type="any" />

<cfoutput>
	<ul id="navTask">
	    <cf_SlatwallActionCaller action="admin:attribute.createAttributeSet" type="list">
	</ul>

	<div class="svoadminattributelistattributesets">
	<cfif arrayLen(rc.attributeSetSmartList.getPageRecords()) GT 0>
		<table class="listing-grid stripe" id="AttributeSets">
			<thead>
			<tr>
				<th class="varWidth">#rc.$.Slatwall.rbKey("entity.attributeSet.attributeSetName")#</th>
				<th>#rc.$.Slatwall.rbKey('entity.attributeSet.attributeSetType')#</th>
				<th>#rc.$.Slatwall.rbKey('entity.attributeSet.globalFlag')#</th>
				<th>&nbsp;</th>
			</tr>
			</thead>
			<tbody id="AttributeSetList">
				<cfloop array="#rc.attributeSetSmartList.getPageRecords()#" index="local.thisAttributeSet">
					<tr class="attributeSet" id="#local.thisAttributeSet.getAttributeSetID()#">
						<td class="varWidth">#local.thisAttributeSet.getAttributeSetName()#</td>
						<td>#local.thisAttributeSet.getAttributeSetType().getType()#</td>
						<td>#yesNoformat(local.thisAttributeSet.getGlobalFlag())#</td>
						<td class="administration">
							<ul class="three">
								<cf_SlatwallActionCaller action="admin:attribute.editAttributeSet" querystring="attributeSetID=#local.thisAttributeSet.getAttributeSetID()#" class="edit" type="list">
								<cf_SlatwallActionCaller action="admin:attribute.detailAttributeSet" querystring="attributeSetID=#local.thisAttributeSet.getAttributeSetID()#" class="detail" type="list">
								<cf_SlatwallActionCaller action="admin:attribute.deleteAttributeSet" querystring="attributeSetID=#local.thisAttributeSet.getAttributeSetID()#" class="delete" type="list" disabled="#local.thisAttributeSet.isNotDeletable()#" confirmrequired="true">
							</ul>		
						</td>
					</tr>
				</cfloop>
		    </tbody>
		</table>
		<cf_SlatwallSmartListPager smartList="#rc.attributeSetSmartList#">
	<cfelse>
		<p><em>#rc.$.Slatwall.rbKey("admin.attribute.listattributesets.noAttributeSets")#</em></p>
	</cfif>
	</div>
</cfoutput>
