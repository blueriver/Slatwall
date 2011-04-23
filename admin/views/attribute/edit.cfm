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
<cfparam name="rc.activeAttribute" type="any" default="" >
<cfparam name="rc.attributeSet" type="any" />
<cfparam name="rc.newAttributeFormOpen" type="boolean" default="false" />

<cfset local.attributes = rc.attributeSet.getAttributes(sortby="sortOrder",sortType="numeric") />

<ul id="navTask">
	<cfif request.action eq "admin:attribute.edit">
	<cf_ActionCaller action="admin:attribute.create" querystring="attributeSetID=#rc.attributeSet.getAttributeSetID()#" type="list">
	</cfif>
    <cf_ActionCaller action="admin:attribute.list" type="list">
	<cf_ActionCaller action="admin:attribute.editAttributeSet" querystring="attributeSetID=#rc.attributeSet.getAttributeSetID()#" type="list">
</ul>

<cfoutput>

<cfif rc.create>
<cfset local.thisOpen = rc.newAttributeFormOpen />

<div id="buttons">
<a class="button" id="newFrmopen" href="javascript:;" <cfif local.thisOpen>style="display:none;"</cfif> onclick="jQuery('##newFrmcontainer').slideDown();this.style.display='none';jQuery('##newFrmclose').show();return false;">#rc.$.Slatwall.rbKey('admin.attribute.addAttribute')#</a>
<a class="button" href="javascript:;" <cfif !local.thisOpen>style="display:none;"</cfif> id="newFrmclose" onclick="jQuery('##newFrmcontainer').slideUp();this.style.display='none';jQuery('##newFrmopen').show();return false;">#rc.$.Slatwall.rbKey('admin.attribute.closeform')#</a>
</div>

<div<cfif !local.thisOpen> style="display:none;"</cfif> id="newFrmcontainer">

<form id="newAttributeForm" enctype="multipart/form-data" action="#buildURL('admin:attribute.save')#" method="post">
    <input type="hidden" name="attributeSetID" value="#rc.attributeSet.getAttributeSetID()#" />
	<input type="hidden" name="sortOrder" value="#arrayLen(local.attributes)+1#"
    <dl class="oneColumn">
        <cf_PropertyDisplay object="#rc.newAttribute#" property="attributeName" edit="true">
		<cf_PropertyDisplay object="#rc.newAttribute#" property="attributeDescription" edit="true" editType="wysiwyg" />
		<cf_PropertyDisplay object="#rc.newAttribute#" property="attributeHint" edit="true">
		<cf_PropertyDisplay object="#rc.newAttribute#" property="attributeType" edit="true">
		<cf_PropertyDisplay object="#rc.newAttribute#" property="defaultValue" edit="true">
		<cf_PropertyDisplay object="#rc.newAttribute#" property="requiredFlag" edit="true">
		<cf_PropertyDisplay object="#rc.newAttribute#" property="validationType" edit="true">
		<cf_PropertyDisplay object="#rc.newAttribute#" property="validationRegex" edit="true">
		<cf_PropertyDisplay object="#rc.newAttribute#" property="validationMessage" edit="true">
		<!---<cf_PropertyDisplay object="#rc.newAttribute#" property="attributeOptions" edit="true">--->
		<cf_PropertyDisplay object="#rc.newAttribute#" property="activeFlag" edit="true">
    </dl>
	<a class="button" href="javascript:;" onclick="jQuery('##newFrmcontainer').slideUp();jQuery('##newFrmclose').hide();jQuery('##newFrmopen').show();return false;">#rc.$.Slatwall.rbKey('sitemanager.cancel')#</a>
	<cf_ActionCaller action="admin:attribute.save" type="submit">
</form>
</div>
</cfif>

<cfif arrayLen(local.attributes) gt 0>

<p>
<a href="##" style="display:none;" id="saveSort">[#rc.$.Slatwall.rbKey("admin.attribute.saveorder")#]</a>
<a href="##"  id="showSort">[#rc.$.Slatwall.rbKey('admin.attribute.reorder')#]</a>
</p>

<ul id="attributeList" class="orderList">
<cfloop from="1" to="#arraylen(local.attributes)#" index="local.i">
<cfset local.thisAttribute = local.attributes[local.i] />
<!--- see if this is the attribute to be actively edited --->
<cfif isObject(rc.activeAttribute) and local.thisAttribute.getAttributeID() eq rc.activeAttribute.getAttributeID()>
	<cfset local.thisAttribute = rc.activeAttribute />
	<cfset local.thisOpen = true />
<cfelse>
	<cfset local.thisOpen = false />
</cfif>
	<li id="#local.thisAttribute.getAttributeID()#">
		<span id="handle#local.i#" class="handle" style="display:none;">[#rc.$.Slatwall.rbKey("admin.attribute.order.handle")#]</span>
		#local.thisAttribute.getAttributeName()# 
		<a title="#rc.$.Slatwall.rbKey('sitemanager.edit')#" href="javascript:;" id="editFrm#local.i#open" <cfif local.thisOpen>style="display:none;"</cfif> onclick="jQuery('##editFrm#local.i#container').slideDown();this.style.display='none';jQuery('##editFrm#local.i#close').show();return false;">[#rc.$.Slatwall.rbKey("sitemanager.edit")#]</a> 
		<a title="#rc.$.Slatwall.rbKey('sitemanager.content.fields.close')#" href="javascript:;" id="editFrm#local.i#close" <cfif !local.thisOpen>style="display:none;"</cfif> onclick="jQuery('##editFrm#local.i#container').slideUp();this.style.display='none';jQuery('##editFrm#local.i#open').show();return false;">[#rc.$.Slatwall.rbKey("sitemanager.content.fields.close")#]</a>
		<cf_ActionCaller type="link" action="admin:attribute.delete" querystring="attributeid=#local.thisAttribute.getAttributeID()#" text="[#rc.$.Slatwall.rbKey("sitemanager.delete")#]" confirmrequired="true">
		<div<cfif !local.thisOpen> style="display:none;"</cfif> id="editFrm#local.i#container">

		<form name="editFrm#local.i#" enctype="multipart/form-data" action="#buildURL('admin:attribute.save')#" method="post">
		    <input type="hidden" name="attributeSetID" value="#rc.attributeSet.getAttributeSetID()#" />
			<input type="hidden" name="attributeID" value="#local.thisAttribute.getAttributeID()#" />
			<input type="hidden" name="sortOrder" value="#local.thisAttribute.getSortOrder()#" />
		    <dl class="oneColumn">
		        <cf_PropertyDisplay id="attributeName#local.i#" object="#local.thisAttribute#" property="attributeName" edit="true">
				<cf_PropertyDisplay id="attributeDescription#local.i#" object="#local.thisAttribute#" property="attributeDescription" edit="true" editType="wysiwyg" />
				<cf_PropertyDisplay id="attributeHint#local.i#" object="#local.thisAttribute#" property="attributeHint" edit="true">
				<cf_PropertyDisplay id="attributeType#local.i#" object="#local.thisAttribute#" property="attributeType" edit="true">
				<cf_PropertyDisplay id="defaultValue#local.i#" object="#local.thisAttribute#" property="defaultValue" edit="true">
				<cf_PropertyDisplay id="requiredFlag#local.i#" object="#local.thisAttribute#" property="requiredFlag" edit="true">
				<cf_PropertyDisplay id="validationType#local.i#" object="#local.thisAttribute#" property="validationType" edit="true">
				<cf_PropertyDisplay id="validationRegex#local.i#" object="#local.thisAttribute#" property="validationRegex" edit="true">
				<cf_PropertyDisplay id="validationMessage#local.i#" object="#local.thisAttribute#" property="validationMessage" edit="true">
				<!---<cf_PropertyDisplay id="attributeHint#local.i#" object="#local.thisAttribute#" property="attributeOptions" edit="true">--->
				<cf_PropertyDisplay id="activeFlag#local.i#" object="#local.thisAttribute#" property="activeFlag" edit="true">
		    </dl>
			<a class="button" href="javascript:;" onclick="jQuery('##editFrm#local.i#container').slideUp();jQuery('##editFrm#local.i#open').show();jQuery('##editFrm#local.i#close').hide();return false;">#rc.$.Slatwall.rbKey('sitemanager.cancel')#</a>
			<cf_ActionCaller action="admin:attribute.save" type="submit">
		</form>  
		</div>
	</li>
</cfloop>
</ul>

<cfelse>
	<p><em>#rc.$.Slatwall.rbKey("admin.attribute.noAttributesInSet")#</em></p>
</cfif>

</cfoutput>
