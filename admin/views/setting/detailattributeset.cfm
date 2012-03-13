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
<cfparam name="rc.edit" default="false" />
<cfparam name="rc.attributeSet" type="any" />
 
<cfoutput>
	<ul id="navTask">
		<cf_SlatwallActionCaller action="admin:attribute.listAttributeSets" type="list">
		<cfif !rc.edit><cf_SlatwallActionCaller action="admin:attribute.editAttributeSet" querystring="attributeSetid=#rc.attributeSet.getAttributeSetID()#" type="list"></cfif>
	</ul>
	
	<cfif rc.edit>
		<form name="attributeSetForm" id="attributeSetForm" enctype="multipart/form-data" method="post">
			<input type="hidden" name="slatAction" value="admin:attribute.saveAttributeSet" />
			<input type="hidden" id="attributeSetID" name="attributeSetID" value="#rc.attributeSet.getAttributeSetID()#" />
	</cfif>
	
			<dl class="twoColumn attributeDetail">
				<cf_SlatwallPropertyDisplay object="#rc.attributeSet#" property="attributeSetName" edit="#rc.edit#" />
				<cf_SlatwallPropertyDisplay object="#rc.attributeSet#" property="attributeSetCode" edit="#rc.edit#" />
				<cf_SlatwallPropertyDisplay object="#rc.attributeSet#" property="globalFlag" edit="#rc.edit#" />
				<cf_SlatwallPropertyDisplay object="#rc.attributeSet#" property="attributeSetType" edit="#rc.edit#" />
			</dl>
	
			<div class="tabs initActiveTab ui-tabs ui-widget ui-widget-content ui-corner-all clear">
				<ul>
					<li><a href="##tabAttributes" onclick="return false;"><span>#rc.$.Slatwall.rbKey("entity.attributeSet.attributes")#</span></a></li>	
					<li><a href="##tabDescription" onclick="return false;"><span>#rc.$.Slatwall.rbKey("entity.attributeSet.attributeSetDescription")#</span></a></li>
				</ul>
			
				<div id="tabAttributes">
					#view("attribute/attributesettabs/attributes")#
				</div>
				<div id="tabDescription">
					<cf_SlatwallPropertyDisplay object="#rc.attributeSet#" property="attributeSetDescription" edit="#rc.edit#" fieldType="wysiwyg" displayType="plain">
				</div>
			</div>
	
	<cfif rc.edit>
		<div id="actionButtons" class="clearfix">
			<cf_SlatwallActionCaller action="admin:attribute.listAttributeSets" type="link" class="button" text="#rc.$.Slatwall.rbKey('sitemanager.cancel')#">
			<cf_SlatwallActionCaller action="admin:attribute.saveAttributeSet" type="submit"  class="button">
		</div>
		</form>
	</cfif>
</cfoutput>
