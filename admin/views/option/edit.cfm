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
<cfparam name="rc.create" type="boolean" default="false" />
<cfparam name="rc.newOption" type="any" default="" />
<cfparam name="rc.activeOption" type="any" default="" />
<cfparam name="rc.optionID" type="string" default="" />
<cfparam name="rc.optionGroup" type="any" />
<cfparam name="rc.newOptionFormOpen" type="boolean" default="false" />

<cfset local.options = rc.optionGroup.getOptions(sortby="sortOrder",sortType="numeric") />

<ul id="navTask">
	<cfif request.action eq "admin:option.edit">
	<cf_ActionCaller action="admin:option.create" querystring="optiongroupID=#rc.optiongroup.getoptiongroupid()#" type="list">
	</cfif>
    <cf_ActionCaller action="admin:option.list" type="list">
	<cf_ActionCaller action="admin:option.editoptiongroup" querystring="optiongroupID=#rc.optiongroup.getoptiongroupid()#" type="list">
</ul>

<cfoutput>

<cfif rc.create>
<cfset local.thisOpen = rc.newOptionFormOpen />

<div id="buttons">
<a class="button" id="newFrmopen" href="javascript:;" <cfif local.thisOpen>style="display:none;"</cfif> onclick="jQuery('##newFrmcontainer').slideDown();this.style.display='none';jQuery('##newFrmclose').show();return false;">#rc.$.Slatwall.rbKey('admin.option.addoption')#</a>
<a class="button" href="javascript:;" <cfif !local.thisOpen>style="display:none;"</cfif> id="newFrmclose" onclick="jQuery('##newFrmcontainer').slideUp();this.style.display='none';jQuery('##newFrmopen').show();return false;">#rc.$.Slatwall.rbKey('admin.option.closeform')#</a>
</div>

<div<cfif !local.thisOpen> style="display:none;"</cfif> id="newFrmcontainer">

<form id="newOptionForm" enctype="multipart/form-data" action="#buildURL('admin:option.save')#" method="post">
    <input type="hidden" name="optionGroupID" value="#rc.optionGroup.getOptionGroupID()#" />
	<input type="hidden" name="sortOrder" value="#arrayLen(local.options)+1#"
    <dl class="oneColumn">
        <cf_PropertyDisplay object="#rc.newOption#" property="optionname" edit="true">
		<cf_PropertyDisplay object="#rc.newOption#" property="optioncode" edit="true">
		<cf_PropertyDisplay object="#rc.newOption#" property="optionImage" edit="true" tooltip="true" editType="file">
		<cf_PropertyDisplay object="#rc.newOption#" property="optionDescription" edit="true" editType="wysiwyg" toggle="show">
    </dl>
	<a class="button" href="javascript:;" onclick="jQuery('##newFrmcontainer').slideUp();jQuery('##newFrmclose').hide();jQuery('##newFrmopen').show();return false;">#rc.$.Slatwall.rbKey('sitemanager.cancel')#</a>
	<cf_ActionCaller action="admin:option.save" type="submit" class="button">
</form>
</div>
</cfif>

<cfif arrayLen(local.options) gt 0>

<p>
<a href="##" style="display:none;" id="saveSort">[#rc.$.Slatwall.rbKey("admin.option.saveorder")#]</a>
<a href="##"  id="showSort">[#rc.$.Slatwall.rbKey('admin.option.reorder')#]</a>
</p>

<ul id="optionList" class="orderList">
<cfloop from="1" to="#arraylen(local.options)#" index="local.i">
<cfset local.thisOption = local.options[local.i] />
<!--- see if this is the option to be actively edited --->
<cfif isObject(rc.activeOption) and local.thisOption.getOptionID() eq rc.activeOption.getOptionID()>
	<cfset local.thisOption = rc.activeOption />
	<cfset local.thisOpen = true />
<cfelseif rc.optionID eq local.thisOption.getOptionID()>
	<cfset local.thisOpen = true />
<cfelse>
	<cfset local.thisOpen = false />
</cfif>
	<li optionID="#local.thisOption.getOptionID()#">
		<span id="handle#local.i#" class="handle" style="display:none;">[#rc.$.Slatwall.rbKey("admin.option.order.handle")#]</span>
		#local.thisOption.getOptionName()# 
		<a title="#rc.$.Slatwall.rbKey('sitemanager.edit')#" href="javascript:;" id="editFrm#local.i#open" <cfif local.thisOpen>style="display:none;"</cfif> onclick="jQuery('##editFrm#local.i#container').slideDown();this.style.display='none';jQuery('##editFrm#local.i#close').show();return false;">[#rc.$.Slatwall.rbKey("sitemanager.edit")#]</a> 
		<a title="#rc.$.Slatwall.rbKey('sitemanager.content.fields.close')#" href="javascript:;" id="editFrm#local.i#close" <cfif !local.thisOpen>style="display:none;"</cfif> onclick="jQuery('##editFrm#local.i#container').slideUp();this.style.display='none';jQuery('##editFrm#local.i#open').show();return false;">[#rc.$.Slatwall.rbKey("sitemanager.content.fields.close")#]</a>
		<cf_ActionCaller type="link" action="admin:option.delete" querystring="optionid=#local.thisOption.getOptionID()#" text="[#rc.$.Slatwall.rbKey("sitemanager.delete")#]" disabled="#local.thisOption.getAssignedFlag()#" confirmrequired="true">
		<div<cfif !local.thisOpen> style="display:none;"</cfif> id="editFrm#local.i#container">

		<form name="editFrm#local.i#" enctype="multipart/form-data" action="#buildURL('admin:option.save')#" method="post">
		    <input type="hidden" name="optionGroupID" value="#rc.optionGroup.getOptionGroupID()#" />
			<input type="hidden" name="optionID" value="#local.thisOption.getOptionID()#" />
			<input type="hidden" name="sortOrder" value="#local.thisOption.getSortOrder()#" />
		    <dl class="oneColumn">
		        <cf_PropertyDisplay id="optionname#local.i#" object="#local.thisOption#" property="optionname" edit="true">
				<cf_PropertyDisplay id="optioncode#local.i#" object="#local.thisOption#" property="optioncode" edit="true">
				<cf_PropertyDisplay id="optionimage#local.i#" object="#local.thisOption#" property="optionImage" edit="true" tooltip="true" editType="file">
		        <cfif local.thisOption.hasImage()>
		        <dd>
		            <a href="#local.thisOption.getImagePath()#">#local.thisOption.displayImage("40")#</a>
		            <input type="checkbox" name="removeImage" value="1" id="removeOptionImage#local.i#" /> <label for="removeOptionImage#local.i#">#rc.$.Slatwall.rbKey("admin.option.removeimage")#</label>
		        </dd>
		        </cfif>
				<cf_PropertyDisplay id="optiondescription#local.i#" object="#local.thisOption#" property="optionDescription" edit="true" editType="wysiwyg" toggle="show">
		    </dl>
			<a class="button" href="javascript:;" onclick="jQuery('##editFrm#local.i#container').slideUp();jQuery('##editFrm#local.i#open').show();jQuery('##editFrm#local.i#close').hide();return false;">#rc.$.Slatwall.rbKey('sitemanager.cancel')#</a>
			<cf_ActionCaller action="admin:option.save" type="submit" class="button">
		</form>  
		</div>
	</li>
</cfloop>
</ul>

<cfelse>
	<p><em>#rc.$.Slatwall.rbKey("admin.option.nooptionsingroup")#</em></p>
</cfif>

</cfoutput>
