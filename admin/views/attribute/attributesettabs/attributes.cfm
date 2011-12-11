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
<cfoutput>
	<cfif arrayLen(rc.attributeSet.getAttributes()) GT 0>
		<table class="listing-grid stripe" id="Options">
			<thead>
				<tr>
					<th class="handle" style="display:none;"></th>
					<th>#rc.$.Slatwall.rbKey("entity.attribute.attributeCode")#</th>
					<th class="varWidth">#rc.$.Slatwall.rbKey("entity.attribute.attributeName")#</th>
					<th>&nbsp;</th>
				</tr>
			</thead>
			<tbody id="AttributeList">
				<cfloop array="#rc.attributeSet.getAttributes()#" index="local.thisAttribute">
					<cfif not local.thisAttribute.hasErrors()>
						<tr class="Attribute" data-attributeID="#local.thisAttribute.getAttributeID()#">
							<td class="handle" style="display:none;"><img src="#$.slatwall.getSlatwallRootPath()#/staticAssets/images/admin.ui.drag_handle.png" height="14" width="15" alt="#rc.$.Slatwall.rbKey('admin.option.reorder')#" /></td>
							<td>#local.thisAttribute.getAttributeCode()#</td>
							<td class="varWidth">#local.thisAttribute.getAttributeName()#</td>
							<td class="administration">
								<ul class="two">
									<cf_SlatwallActionCaller action="admin:attribute.editAttributeSet" querystring="attributeSetID=#local.thisAttribute.getAttributeSet().getAttributeSetID()#&attributeID=#local.thisAttribute.getAttributeID()#" class="edit" type="list">
									<cf_SlatwallActionCaller action="admin:attribute.deleteAttribute" querystring="attributeID=#local.thisAttribute.getAttributeID()#" class="delete" type="list" disabled="#local.thisAttribute.isNotDeletable()#" confirmrequired="true">
								</ul>
							</td>
						</tr>
					</cfif>
				</cfloop>
			</tbody>
		</table>
	<cfelse>
		<p><em>#rc.$.Slatwall.rbKey("admin.attribute.detailattributeset.noAtributes")#</em></p>
		<br /><br />
	</cfif>
	<cfif rc.edit>
		<!--- If the Option is new, then that means that we are just editing the Option --->
		<cfif rc.attribute.isNew() && not rc.attribute.hasErrors()>
			<button type="button" id="addAttributeButton" value="true">#rc.$.Slatwall.rbKey("admin.attribute.detailAttributeSet.addAttribute")#</button>
		</cfif>
		
		<div id="attributeInputs" <cfif rc.attribute.isNew() && not rc.attribute.hasErrors()>class="ui-helper-hidden"</cfif> >
			<strong>#rc.$.Slatwall.rbKey("admin.attribute.detailAttributeGroup.addAttribute")#</strong>
			<dl class="twoColumn">
				<cf_SlatwallPropertyDisplay object="#rc.attribute#" property="activeFlag" fieldName="attributes[1].activeFlag" edit="true" />
				<cf_SlatwallPropertyDisplay object="#rc.attribute#" property="attributeName" fieldName="attributes[1].attributeName" edit="true" />
				<cf_SlatwallPropertyDisplay object="#rc.attribute#" property="attributeCode" fieldName="attributes[1].attributeCode" edit="true" />
				<cf_SlatwallPropertyDisplay object="#rc.attribute#" property="attributeHint" fieldName="attributes[1].attributeHint" edit="true" />
				<cf_SlatwallPropertyDisplay object="#rc.attribute#" property="defaultValue" fieldName="attributes[1].defaultValue" edit="true" />
				<cf_SlatwallPropertyDisplay object="#rc.attribute#" property="requiredFlag" fieldName="attributes[1].requiredFlag" edit="true" />
				<cf_SlatwallPropertyDisplay object="#rc.attribute#" property="validationMessage" fieldName="attributes[1].validationMessage" edit="true"/>
				<cf_SlatwallPropertyDisplay object="#rc.attribute#" property="validationRegex" fieldName="attributes[1].validationRegex" edit="true"/>
			</dl>
			<cf_SlatwallPropertyDisplay object="#rc.attribute#" property="attributeDescription" fieldName="attributes[1].attributeDescription" edit="true" fieldType="wysiwyg" />
			
			<input type="hidden" name="attributes[1].attributeID" value="#rc.attribute.getAttributeID()#"/>
			<cfif rc.attribute.isNew() && not rc.attribute.hasErrors()>
				<input type="hidden" name="populateSubProperties" id="addOptionHidden" value="false"/>
			<cfelse>
				<input type="hidden" name="populateSubProperties" id="addOptionHidden" value="true"/>
			</cfif>
		</div>
		
		<br /><br />
		
	</cfif>
</cfoutput>