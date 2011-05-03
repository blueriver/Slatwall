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
<cfparam name="rc.edit" default="false" >
<cfparam name="rc.productType" type="any" />
<cfparam name="rc.parentProductTypeID" type="string" default="" />

<!--- set up options for setting select boxes 
<cfset local.Options = [{id="1",name=rc.$.Slatwall.rbKey('sitemanager.yes')},{id="0",name=rc.$.Slatwall.rbKey('sitemanager.no')}] />--->



<cfoutput>
	<ul id="navTask">
	    <cf_ActionCaller action="admin:product.listproducttypes" type="list">
		<cfif !rc.edit><cf_ActionCaller action="admin:product.editproducttype" querystring="productTypeID=#rc.productType.getProductTypeID()#" type="list"></cfif>
	</ul>
	
	<cfif rc.edit>
		<form name="ProductTypeForm" id="ProductTypeForm" action="#buildURL(action='admin:product.saveproducttype')#" method="post">
		<input type="hidden" id="productTypeID" name="productTypeID" value="#rc.productType.getProductTypeID()#" />
	</cfif>

    <dl class="twoColumn">
    	<cf_PropertyDisplay object="#rc.productType#" property="productTypeName" edit="#rc.edit#" first="true">
		<cfif rc.edit>
		<cfset local.tree = rc.productType.getProductTypeTree() />
		<dt>
			<label for="parentProductType_productTypeID">Parent Product Type</label>
		</dt>
		<dd>
		<select name="parentProductType" id="parentProductType_productTypeID" onchange="alertDialog('#$.Slatwall.rbKey("admin.product.changeParentProductType_confirm")#');">
            <option value=""<cfif isNull(rc.productType.getParentProductType())> selected</cfif>>None</option>
        <cfloop query="local.tree">
		    <cfif not listFind(local.tree.path,rc.productType.getProductTypeName())><!--- can't be child of itself or any of its children --->
            <cfset ThisDepth = local.tree.TreeDepth />
            <cfif ThisDepth><cfset bullet="-"><cfelse><cfset bullet=""></cfif>
            <option value="#local.tree.productTypeID#"<cfif (!isNull(rc.productType.getParentProductType()) and rc.productType.getParentProductType().getProductTypeID() eq local.tree.productTypeID) or rc.parentProductTypeID eq local.tree.productTypeID> selected="selected"</cfif>>
                #RepeatString("&nbsp;&nbsp;&nbsp;",ThisDepth)##bullet##local.tree.productTypeName#
            </option>
			</cfif>
        </cfloop>
        </select>	
		</dd>
		<cfelse>
			<cfset local.parentLink = rc.productType.hasParentProductType() ? buildURL(action='admin:product.detailProductType', queryString='productTypeID=#rc.productType.getParentProductType().getProductTypeID()#') : "" />
			<cf_PropertyDisplay object="#rc.productType#" property="parentProductType" propertyObject="productType" link="#local.parentLink#" nullValue="#rc.$.Slatwall.rbKey('admin.none')#" edit="false">
		</cfif>
	</dl>
	<div class="tabs initActiveTab ui-tabs ui-widget ui-widget-content ui-corner-all">
		<ul>
			<li><a href="##tabDescription" onclick="return false;"><span>#rc.$.Slatwall.rbKey('admin.product.detailProductType.tabDescription')#</span></a></li>
			<li><a href="##tabSettings" onclick="return false;"><span>#rc.$.Slatwall.rbKey('admin.product.detailProductType.tabSettings')#</span></a></li>	
			<li><a href="##tabAttributeSets" onclick="return false;"><span>#rc.$.Slatwall.rbKey('admin.product.detailProductType.tabAttributeSets')#</span></a></li>
		</ul>
		<div id="tabDescription">
			<cf_PropertyDisplay object="#rc.productType#" property="productTypeDescription" edit="#rc.edit#" editType="wysiwyg">
		</div>
		<div id="tabSettings">
			<table class="stripe" id="productTypeSettings">
				<tr>
					<th class="varWidth">#rc.$.Slatwall.rbKey('entity.setting.settingName')#</th>
					<th>#rc.$.Slatwall.rbKey('entity.setting.settingValue')#</th>
					<th>#rc.$.Slatwall.rbKey('admin.productType.settingDefinedIn')#</th>
				</tr>
				<tr>
					<td class="property varWidth">
						<a href="##" class="tooltip">
							#rc.$.Slatwall.rbKey("entity.productType.trackInventoryFlag")#
							<span>#rc.$.Slatwall.rbKey("entity.ProductType.trackInventoryFlag_hint")#</span>
						</a>
					</td>
					<td>
						<cf_PropertyDisplay object="#rc.productType#" property="trackInventoryFlag" edit="#rc.edit#" displayType="plain" editType="select" nullValue="#rc.$.Slatwall.rbKey('setting.inherit')# (#yesNoFormat(rc.productType.getInheritedSetting('trackInventoryFlag'))#)">
					</td>
					<cfset local.thisSettingSource = rc.ProductType.getWhereSettingDefined("trackInventoryFlag") />
					<td>
						<cfif local.thisSettingSource.type eq "Global">
							<a href="#buildURL(action='admin:setting.detail')#">#rc.$.Slatwall.rbKey('entity.setting.global')#</a>
						<cfelseif local.thisSettingSource.type eq "Product Type" and local.thisSettingSource.id neq rc.ProductType.getProductTypeID()>
							<a href="#buildURL(action='admin:product.detailProductType',queryString='productTypeID=#local.thisSettingSource.id#')#">#local.thisSettingSource.name#</a>
						<cfelse>
							#local.thisSettingSource.name#
						</cfif>
					</td>
				</tr>
				<tr>
					<td class="property varWidth">
						<a href="##" class="tooltip">
							#rc.$.Slatwall.rbKey("entity.productType.callToOrderFlag")#
							<span>#rc.$.Slatwall.rbKey("entity.ProductType.callToOrderFlag_hint")#</span>
						</a>
					</td>
					<td>
						<cf_PropertyDisplay object="#rc.productType#" property="callToOrderFlag" edit="#rc.edit#" displayType="plain" editType="select" nullValue="#rc.$.Slatwall.rbKey('setting.inherit')# (#yesNoFormat(rc.productType.getInheritedSetting('callToOrderFlag'))#)">
					</td>
					<cfset local.thisSettingSource = rc.ProductType.getWhereSettingDefined("callToOrderFlag") />
					<td>
						<cfif local.thisSettingSource.type eq "Global">
							<a href="#buildURL(action='admin:setting.detail')#">#rc.$.Slatwall.rbKey('entity.setting.global')#</a>
						<cfelseif local.thisSettingSource.type eq "Product Type" and local.thisSettingSource.id neq rc.ProductType.getProductTypeID()>
							<a href="#buildURL(action='admin:product.detailProductType',queryString='productTypeID=#local.thisSettingSource.id#')#">#local.thisSettingSource.name#</a>
						<cfelse>
							#local.thisSettingSource.name#
						</cfif>
					</td>
				</tr>
				<tr>
					<td class="property varWidth">
						<a href="##" class="tooltip">
							#rc.$.Slatwall.rbKey("entity.productType.allowShippingFlag")#
							<span>#rc.$.Slatwall.rbKey("entity.ProductType.allowShippingFlag_hint")#</span>
						</a>
					</td>
					<td>
						<cf_PropertyDisplay object="#rc.productType#" property="allowShippingFlag" edit="#rc.edit#" displayType="plain" editType="select" nullValue="#rc.$.Slatwall.rbKey('setting.inherit')# (#yesNoFormat(rc.productType.getInheritedSetting('allowShippingFlag'))#)">
					</td>
					<cfset local.thisSettingSource = rc.ProductType.getWhereSettingDefined("allowShippingFlag") />
					<td>
						<cfif local.thisSettingSource.type eq "Global">
							<a href="#buildURL(action='admin:setting.detail')#">#rc.$.Slatwall.rbKey('entity.setting.global')#</a>
						<cfelseif local.thisSettingSource.type eq "Product Type" and local.thisSettingSource.id neq rc.ProductType.getProductTypeID()>
							<a href="#buildURL(action='admin:product.detailProductType',queryString='productTypeID=#local.thisSettingSource.id#')#">#local.thisSettingSource.name#</a>
						<cfelse>
							#local.thisSettingSource.name#
						</cfif>
					</td>
				</tr>
				<tr>
					<td class="property varWidth">
						<a href="##" class="tooltip">
							#rc.$.Slatwall.rbKey("entity.productType.allowPreorderFlag")#
							<span>#rc.$.Slatwall.rbKey("entity.ProductType.allowPreorderFlag_hint")#</span>
						</a>
					</td>
					<td>
						<cf_PropertyDisplay object="#rc.productType#" property="allowPreorderFlag" edit="#rc.edit#" displayType="plain" editType="select" nullValue="#rc.$.Slatwall.rbKey('setting.inherit')# (#yesNoFormat(rc.productType.getInheritedSetting('allowPreorderFlag'))#)">
					</td>
					<cfset local.thisSettingSource = rc.ProductType.getWhereSettingDefined("allowPreorderFlag") />
					<td>
						<cfif local.thisSettingSource.type eq "Global">
							<a href="#buildURL(action='admin:setting.detail')#">#rc.$.Slatwall.rbKey('entity.setting.global')#</a>
						<cfelseif local.thisSettingSource.type eq "Product Type" and local.thisSettingSource.id neq rc.ProductType.getProductTypeID()>
							<a href="#buildURL(action='admin:product.detailProductType',queryString='productTypeID=#local.thisSettingSource.id#')#">#local.thisSettingSource.name#</a>
						<cfelse>
							#local.thisSettingSource.name#
						</cfif>
					</td>
				</tr>
				<tr>
					<td class="property varWidth">
						<a href="##" class="tooltip">
							#rc.$.Slatwall.rbKey("entity.productType.allowBackorderFlag")#
							<span>#rc.$.Slatwall.rbKey("entity.ProductType.allowBackorderFlag_hint")#</span>
						</a>
					</td>
					<td>
						<cf_PropertyDisplay object="#rc.productType#" property="allowBackorderFlag" edit="#rc.edit#" displayType="plain" editType="select" nullValue="#rc.$.Slatwall.rbKey('setting.inherit')# (#yesNoFormat(rc.productType.getInheritedSetting('allowBackorderFlag'))#)">
					</td>
					<cfset local.thisSettingSource = rc.ProductType.getWhereSettingDefined("allowBackorderFlag") />
					<td>
						<cfif local.thisSettingSource.type eq "Global">
							<a href="#buildURL(action='admin:setting.detail')#">#rc.$.Slatwall.rbKey('entity.setting.global')#</a>
						<cfelseif local.thisSettingSource.type eq "Product Type" and local.thisSettingSource.id neq rc.ProductType.getProductTypeID()>
							<a href="#buildURL(action='admin:product.detailProductType',queryString='productTypeID=#local.thisSettingSource.id#')#">#local.thisSettingSource.name#</a>
						<cfelse>
							#local.thisSettingSource.name#
						</cfif>
					</td>
				</tr>
				<tr>
					<td class="property varWidth">
						<a href="##" class="tooltip">
							#rc.$.Slatwall.rbKey("entity.productType.allowDropShipFlag")#
							<span>#rc.$.Slatwall.rbKey("entity.ProductType.allowDropshipFlag_hint")#</span>
						</a>
					</td>
					<td>
						<cf_PropertyDisplay object="#rc.productType#" property="allowDropShipFlag" edit="#rc.edit#" displayType="plain" editType="select" nullValue="#rc.$.Slatwall.rbKey('setting.inherit')# (#yesNoFormat(rc.productType.getInheritedSetting('allowDropshipFlag'))#)">
					</td>
					<cfset local.thisSettingSource = rc.ProductType.getWhereSettingDefined("allowDropShipFlag") />
					<td>
						<cfif local.thisSettingSource.type eq "Global">
							<a href="#buildURL(action='admin:setting.detail')#">#rc.$.Slatwall.rbKey('entity.setting.global')#</a>
						<cfelseif local.thisSettingSource.type eq "Product Type" and local.thisSettingSource.id neq rc.ProductType.getProductTypeID()>
							<a href="#buildURL(action='admin:product.detailProductType',queryString='productTypeID=#local.thisSettingSource.id#')#">#local.thisSettingSource.name#</a>
						<cfelse>
							#local.thisSettingSource.name#
						</cfif>
					</td>
				</tr>
			</table>
		</div>
		<div id="tabAttributeSets">
			<table id="AttributeSets" class="stripe">
				<tr>
					<th class="varWidth">#rc.$.Slatwall.rbKey('entity.attributeSet.attributeSetName')#</th>
					<th>#rc.$.Slatwall.rbKey('entity.attributeSet.attributeSetType')#</th>
					<th>#rc.$.Slatwall.rbKey('admin.product.detailProductType.attributeSetAssigned')#</th>	
				</tr>
				<!--- assigned attributeSetIDs --->
				<input type="hidden" name="attributeSetIDs" value="" />
				<cfset local.attributeSetIDs = "" />
				<cfloop array="#rc.productType.getAttributeSetAssignments()#" index="local.AttributeSetAssignment">
					<cfset local.attributeSetIDs = listAppend(local.attributeSetIDs,attributeSetAssignment.getAttributeSet().getAttributeSetID()) />
				</cfloop>	
				<cfloop array="#rc.attributeSets#" index="local.attributeSet">
					<tr>
						<td class="property varWidth">
							<cf_PropertyDisplay object="#attributeSet#" property="attributeSetName" edit="false" displaytype="plain">
						</td>
						<td>
							<cf_PropertyDisplay object="#attributeSet.getAttributeSetType()#" property="type" edit="false" displaytype="plain">
						</td>
						<td>
							<cfif attributeSet.getGlobalFlag()>
								#rc.$.Slatwall.rbKey('yes')# (#rc.$.Slatwall.rbKey('global')#)
							<cfelse>
								<cfset local.assignedFlag = listFind(attributeSetIDs,attributeSet.getAttributeSetID()) />
								<cfif rc.edit>
									<input type="checkbox" name="attributeSetIDs" value="#attributeSet.getAttributeSetID()#" <cfif assignedFlag>checked </cfif>>
								<cfelse>
									#yesNoFormat(assignedFlag)#
								</cfif>
							</cfif>
						</td>
					</tr>
				</cfloop>
			</table>
		</div>
	</div>
	<cfif rc.edit>
		<div id="actionButtons" class="clearfix">
			<cf_ActionCaller action="admin:product.listProductTypes" class="button" text="#rc.$.Slatwall.rbKey('sitemanager.cancel')#">
			<cfif !rc.productType.isNew() and !rc.productType.hasProduct() and !rc.productType.hasSubProductType()>
			<cf_ActionCaller action="admin:product.deleteproducttype" querystring="producttypeid=#rc.producttype.getproducttypeID()#" class="button" type="link" confirmrequired="true">
			</cfif>
			<cf_ActionCaller action="admin:product.saveproducttype" type="submit" class="button">
		</div>
	</form>
	</cfif>
</cfoutput>
