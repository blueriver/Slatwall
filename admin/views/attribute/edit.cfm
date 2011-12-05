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
<cfparam name="rc.create" type="boolean" default="false" >
<cfparam name="rc.newAttribute" type="any" default="" />
<cfparam name="rc.activeAttribute" type="any" default="" />
<cfparam name="rc.attributeID" type="string" default="" />
<cfparam name="rc.attributeSet" type="any" />
<cfparam name="rc.newAttributeFormOpen" type="boolean" default="false" />

<cfset local.attributes = rc.attributeSet.getAttributes() />

<ul id="navTask">
	<cfif request.action eq "admin:attribute.edit">
	<cf_SlatwallActionCaller action="admin:attribute.create" querystring="attributeSetID=#rc.attributeSet.getAttributeSetID()#" type="list">
	</cfif>
    <cf_SlatwallActionCaller action="admin:attribute.list" type="list">
	<cf_SlatwallActionCaller action="admin:attribute.editAttributeSet" querystring="attributeSetID=#rc.attributeSet.getAttributeSetID()#" type="list">
</ul>

<cfoutput>

<cfif rc.create>
<cfset local.thisOpen = rc.newAttributeFormOpen />

<div class="buttons">
<a class="button" id="newFrmopen" href="javascript:;" <cfif local.thisOpen>style="display:none;"</cfif> onclick="jQuery('##newFrmcontainer').slideDown();this.style.display='none';jQuery('##newFrmclose').show();return false;">#rc.$.Slatwall.rbKey('admin.attribute.addAttribute')#</a>
<a class="button" href="javascript:;" <cfif !local.thisOpen>style="display:none;"</cfif> id="newFrmclose" onclick="jQuery('##newFrmcontainer').slideUp();this.style.display='none';jQuery('##newFrmopen').show();return false;">#rc.$.Slatwall.rbKey('admin.attribute.closeform')#</a>
</div>

<div<cfif !local.thisOpen> style="display:none;"</cfif> id="newFrmcontainer">

<form id="newAttributeForm" enctype="multipart/form-data" action="#buildURL('admin:attribute.save')#" method="post">
    <input type="hidden" name="attributeSetID" value="#rc.attributeSet.getAttributeSetID()#" />
	<input type="hidden" name="sortOrder" value="#arrayLen(local.attributes)+1#" />
    <dl class="oneColumn">
        <cf_SlatwallPropertyDisplay object="#rc.newAttribute#" property="attributeName" edit="true">
		<cf_SlatwallPropertyDisplay object="#rc.newAttribute#" property="attributeCode" edit="true" tooltip="true" tooltipmessage="#$.slatwall.rbKey('entity.attribute.attributeCode_hint')#" />
		<cf_SlatwallPropertyDisplay object="#rc.newAttribute#" property="attributeDescription" edit="true" toggle="show" fieldType="wysiwygbasic" />
		<cf_SlatwallPropertyDisplay object="#rc.newAttribute#" property="attributeHint" edit="true">
		<cf_SlatwallPropertyDisplay object="#rc.newAttribute#" property="attributeType" propertyObject="Type" class="attributeType" defaultValue="Text Box" allowNullOption="false" edit="true">
		<div class="attributeOptions" style="display:none;">
		<dt>
			Attribute Options
		</dt>
		<dd>
			<table id="attribnew" class="attributeOptions">
				<thead>
					<tr>
						<th>#rc.$.Slatwall.rbKey("entity.attributeOption.sortOrder")#</th>
						<th>#rc.$.Slatwall.rbKey("entity.attributeOption.attributeOptionValue")#</th>
						<th>#rc.$.Slatwall.rbKey("entity.attributeOption.attributeOptionLabel")#</th>
					</tr>
				</thead>
				<tbody>
					<tr class="new">
						<td>
							<input type="text" class=sortOrder size="4" name="options[1].sortOrder" value="" />
						</td>
						<td>
							<input type="text" size="6" name="options[1].value" />
							<input type="hidden" name="options[1].attributeOptionID" value="" />
						</td>
						<td><input type="text" name="options[1].label" /></td>
					</tr>
                    <tr class="new">
                  		<td>
							<input type="text" class="sortOrder" size="4" name="options[2].sortOrder" value="" />
						</td>
                        <td>
                        	<input type="text" size="6" name="options[2].value" />
							<input type="hidden" name="options[2].attributeOptionID" value="" />
						</td>
                        <td><input type="text" name="options[2].label" /></td>
                    </tr>
				</tbody>
			</table>
			<a href="##" attribID="new" class="addOption">#rc.$.Slatwall.rbKey("admin.attribute.addOption")#</a>  <a href="##" attribID="new" class="remOption" style="display:none;">#rc.$.Slatwall.rbKey("admin.attribute.removeOption")#</a>
		</dd>
		</div>
		<cf_SlatwallPropertyDisplay object="#rc.newAttribute#" property="defaultValue" edit="true">
		<cf_SlatwallPropertyDisplay object="#rc.newAttribute#" property="requiredFlag" edit="true">
		<cf_SlatwallPropertyDisplay object="#rc.newAttribute#" property="validationType" propertyObject="Type" nullLabel="#rc.$.Slatwall.rbKey('sitemanager.content.none')#" edit="true">
		<cf_SlatwallPropertyDisplay object="#rc.newAttribute#" property="validationRegex" edit="true">
		<cf_SlatwallPropertyDisplay object="#rc.newAttribute#" property="validationMessage" edit="true">
		<cf_SlatwallPropertyDisplay object="#rc.newAttribute#" property="activeFlag" edit="true">
    </dl>
	<a class="button" href="javascript:;" onclick="jQuery('##newFrmcontainer').slideUp();jQuery('##newFrmclose').hide();jQuery('##newFrmopen').show();return false;">#rc.$.Slatwall.rbKey('sitemanager.cancel')#</a>
	<cf_SlatwallActionCaller action="admin:attribute.save" type="submit" class="button">
</form>
</div>
</cfif>

<cfif arrayLen(local.attributes) gt 0>
	
	<!--- only show reordering controls if there are more than one attributes --->
	<cfif arrayLen(local.attributes) gt 1>
		<p>
		<a href="##" style="display:none;" id="saveSort">[#rc.$.Slatwall.rbKey("admin.attribute.saveorder")#]</a>
		<a href="##"  id="showSort">[#rc.$.Slatwall.rbKey('admin.attribute.reorder')#]</a>
		</p>
	</cfif>

<ul id="attributeList" class="orderList">
<cfloop from="1" to="#arraylen(local.attributes)#" index="local.i">
<cfset local.thisAttribute = local.attributes[local.i] />
<cfset local.attributeOptions = local.thisAttribute.getAttributeOptions() />
<!--- see if this is the attribute to be actively edited --->
<cfif isObject(rc.activeAttribute) and local.thisAttribute.getAttributeID() eq rc.activeAttribute.getAttributeID()>
	<cfset local.thisAttribute = rc.activeAttribute />
	<cfset local.thisOpen = true />
<cfelseif rc.attributeID eq local.thisAttribute.getAttributeID()>
	<cfset local.thisOpen = true />
<cfelse>
	<cfset local.thisOpen = false />
</cfif>
	<cfif len(local.thisAttribute.getAttributeID())>
	<li id="#local.thisAttribute.getAttributeID()#">
		<span id="handle#local.i#" class="handle" style="display:none;">[#rc.$.Slatwall.rbKey("admin.attribute.order.handle")#]</span>
		#local.thisAttribute.getAttributeName()# 
		<a title="#rc.$.Slatwall.rbKey('sitemanager.edit')#" href="javascript:;" id="editFrm#local.i#open" <cfif local.thisOpen>style="display:none;"</cfif> onclick="jQuery('##editFrm#local.i#container').slideDown();this.style.display='none';jQuery('##editFrm#local.i#close').show();return false;">[#rc.$.Slatwall.rbKey("sitemanager.edit")#]</a> 
		<a title="#rc.$.Slatwall.rbKey('sitemanager.content.fields.close')#" href="javascript:;" id="editFrm#local.i#close" <cfif !local.thisOpen>style="display:none;"</cfif> onclick="jQuery('##editFrm#local.i#container').slideUp();this.style.display='none';jQuery('##editFrm#local.i#open').show();return false;">[#rc.$.Slatwall.rbKey("sitemanager.content.fields.close")#]</a>
		<cf_SlatwallActionCaller type="link" action="admin:attribute.delete" querystring="attributeid=#local.thisAttribute.getAttributeID()#" text="[#rc.$.Slatwall.rbKey("sitemanager.delete")#]" confirmrequired="true">
		<div<cfif !local.thisOpen> style="display:none;"</cfif> id="editFrm#local.i#container">

		<form name="editFrm#local.i#" enctype="multipart/form-data" action="#buildURL('admin:attribute.save')#" method="post">
		    <input type="hidden" name="attributeSetID" value="#rc.attributeSet.getAttributeSetID()#" />
			<input type="hidden" name="attributeID" value="#local.thisAttribute.getAttributeID()#" />
			<input type="hidden" name="sortOrder" value="#local.thisAttribute.getSortOrder()#" />
		    <dl class="oneColumn">
		        <cf_SlatwallPropertyDisplay object="#local.thisAttribute#" property="attributeName" edit="true">
				<cf_SlatwallPropertyDisplay object="#local.thisAttribute#" property="attributeCode" edit="true" tooltip="true" tooltipmessage="#$.slatwall.rbKey('entity.attribute.attributeCode_hint')#" />
				<cf_SlatwallPropertyDisplay id="attributeDescription#local.i#" object="#local.thisAttribute#" property="attributeDescription" toggle="show" edit="true" fieldType="wysiwygbasic" />
				<cf_SlatwallPropertyDisplay object="#local.thisAttribute#" property="attributeHint" edit="true">
				<cf_SlatwallPropertyDisplay class="attributeType" object="#local.thisAttribute#" property="attributeType" propertyObject="Type" defaultValue="#$.slatwall.rbKey('entity.attribute.attributetype.atTextBox')#" allowNullOption="false" edit="true">
				<div class="attributeOptions" style="display:none;">
				<dt>
					Attribute Options
				</dt>
				<dd>
					<table id="attrib#local.thisAttribute.getAttributeID()#" class="attributeOptions">
						<thead>
							<tr>
								<th>#rc.$.Slatwall.rbKey("entity.attributeOption.sortOrder")#</th>
								<th>#rc.$.Slatwall.rbKey("entity.attributeOption.attributeOptionValue")#</th>
								<th>#rc.$.Slatwall.rbKey("entity.attributeOption.attributeOptionLabel")#</th>
							</tr>
						</thead>
						<tbody>
							<cfset local.optionIndex = 0>
							<cfif arrayLen(local.attributeOptions)>
								<cfloop array="#local.AttributeOptions#" index="local.thisAttributeOption" >
								<cfset local.optionIndex++ />
								<tr class="#local.thisAttribute.getAttributeID()#" id="#local.thisAttributeOption.getAttributeOptionID()#">
									<td>
										<input type="text" size="4" class="sortOrder" name="options[#local.optionIndex#].sortOrder" value="#local.optionIndex#" />
									</td>
									<td>
										<input type="text" size="6" name="options[#local.optionIndex#].value" value="#local.thisAttributeOption.getAttributeOptionValue()#" />
										<input type="hidden" name="options[#local.optionIndex#].attributeOptionID" value="#local.thisAttributeOption.getAttributeOptionID()#" />
									</td>
									<td>
										<input type="text" name="options[#local.optionIndex#].label" value="#local.thisAttributeOption.getAttributeOptionLabel()#"/>
										<a href="#buildURL(action='admin:attribute.deleteAttributeOption',queryString='attributeOptionID=#local.thisAttributeOption.getAttributeOptionID()#')#" class="deleteAttributeOption" id="#local.thisAttributeOption.getAttributeOptionID()#" onclick="return btnConfirmAttributeOptionDelete('#rc.$.Slatwall.rbKey("admin.attribute.deleteAttributeOption_confirm")#',this);"><img src="#$.slatwall.getSlatwallRootPath()#/staticAssets/images/admin.ui.delete.png" height="16" width="16" alt="#rc.$.Slatwall.rbKey('admin.attribute.deleteAttributeOption')#" title="#rc.$.Slatwall.rbKey('admin.attribute.deleteAttributeOption')#" /></a>
										<div id="message#local.thisAttributeOption.getAttributeOptionID()#" class="formError" style="display:none;"></div>
									</td>
								</tr>
								</cfloop>
							<cfelse>
								<tr class="new">
									<td>
										<input type="text" class=sortOrder size="4" name="options[1].sortOrder" value="" />
									</td>
									<td>
										<input type="text" size="6" name="options[1].value" />
										<input type="hidden" name="options[1].attributeOptionID" value="" />
									</td>
									<td><input type="text" name="options[1].label" /></td>
								</tr>
			                    <tr class="new">
			                  		<td>
										<input type="text" class="sortOrder" size="4" name="options[2].sortOrder" value="" />
									</td>
			                        <td>
			                        	<input type="text" size="6" name="options[2].value" />
										<input type="hidden" name="options[2].attributeOptionID" value="" />
									</td>
			                        <td><input type="text" name="options[2].label" /></td>
			                    </tr>						
							</cfif>
						</tbody>
					</table>
					<a href="##" attribID="#local.thisAttribute.getAttributeID()#" class="addOption">#rc.$.Slatwall.rbKey("admin.attribute.addOption")#</a>  <a href="##" attribID="#local.thisAttribute.getAttributeID()#" class="remOption" style="display:none;">#rc.$.Slatwall.rbKey("admin.attribute.removeOption")#</a>				
				</dd>
				</div>
				<cf_SlatwallPropertyDisplay object="#local.thisAttribute#" property="defaultValue" edit="true">
				<cf_SlatwallPropertyDisplay object="#local.thisAttribute#" property="requiredFlag" edit="true">
				<cf_SlatwallPropertyDisplay object="#local.thisAttribute#" nullLabel="#rc.$.Slatwall.rbKey('sitemanager.content.none')#" property="validationType" propertyObject="Type" edit="true">
				<cf_SlatwallPropertyDisplay object="#local.thisAttribute#" property="validationRegex" edit="true">
				<cf_SlatwallPropertyDisplay object="#local.thisAttribute#" property="validationMessage" edit="true">
				<cf_SlatwallPropertyDisplay object="#local.thisAttribute#" property="activeFlag" edit="true">
		    </dl>
			<a class="button" href="javascript:;" onclick="jQuery('##editFrm#local.i#container').slideUp();jQuery('##editFrm#local.i#open').show();jQuery('##editFrm#local.i#close').hide();return false;">#rc.$.Slatwall.rbKey('sitemanager.cancel')#</a>
			<cf_SlatwallActionCaller action="admin:attribute.save" type="submit" class="button">
		</form>  
		</div>
	</li>
	</cfif>
</cfloop>
</ul>

<cfelse>
	<p><em>#rc.$.Slatwall.rbKey("admin.attribute.noAttributesInSet")#</em></p>
</cfif>

<table id="tableTemplate" class="hideElement">
	<tbody>
        <tr id="temp">
			<td>
				<input type="text" class="sortOrder" size="4" name="sortOrder" value="" />
			</td>
            <td>
            	<input type="text" size="6" name="value" />
				<input type="hidden" name="attributeOptionID" value="" />
			</td>
            <td><input type="text" name="label" /></td>
		</tr>
	</tbody>
</table>
</cfoutput>