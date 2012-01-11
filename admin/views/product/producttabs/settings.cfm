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

<!--- set up options for setting select boxes --->
<cfset local.valueOptions = [{value="",name=rc.$.Slatwall.rbKey('setting.inherit')},{value="1",name=rc.$.Slatwall.rbKey('define.yes')},{value="0",name=rc.$.Slatwall.rbKey('define.no')}] />

<cfoutput>
	<table class="listing-grid stripe" id="productTypeSettings">
		<tr>
			<th class="varWidth">#rc.$.Slatwall.rbKey('admin.product.productsettings')#</th>
			<th>#rc.$.Slatwall.rbKey("entity.setting.settingValue")#</th>
			<th>#rc.$.Slatwall.rbKey('define.definedin')#</th>
		</tr>
		
		<!--- Start: First two settings can only be set in the product and can't inherit --->
		<tr>
			<td class="property varWidth">
				<a href="##" class="tooltip">
					#rc.$.Slatwall.rbKey("entity.product.activeFlag")#
					<span>#rc.$.Slatwall.rbKey("entity.Product.activeFlag_hint")#</span>
				</a>
			</td>
			<td>
				<cf_SlatwallPropertyDisplay object="#rc.Product#" property="activeFlag" edit="#rc.edit#" displayType="plain" fieldType="yesno">
			</td>
			<td>#rc.$.Slatwall.rbKey("define.na")#</td>
		</tr>
		<tr>
			<td class="property varWidth">
				<a href="##" class="tooltip">
					#rc.$.Slatwall.rbKey("entity.product.manufactureDiscontinuedFlag")#
					<span>#rc.$.Slatwall.rbKey("entity.Product.manufactureDiscontinuedFlag_hint")#</span>
				</a>
			</td>
			<td>
				<cf_SlatwallPropertyDisplay object="#rc.Product#" property="manufactureDiscontinuedFlag" edit="#rc.edit#" displayType="plain" fieldType="yesno">
			</td>
			<td>#rc.$.Slatwall.rbKey("define.na")#</td>	
		</tr>
		<!--- End: First Two Settings --->
			
		<!--- Allow Backorder Flag --->
		<tr>
			<td class="property varWidth">
				<a href="##" class="tooltip">
					#rc.$.Slatwall.rbKey("setting.product.allowBackorderFlag")#
					<span>#rc.$.Slatwall.rbKey("setting.product.allowBackorderFlag_hint")#</span>
				</a>
			</td>
			<td>
				<cfset local.valueOptions[1].name = "#rc.$.Slatwall.rbKey('setting.inherit')# (#yesNoFormat(rc.product.getInheritedSetting('allowBackorderFlag'))#)" />
				<cf_SlatwallPropertyDisplay object="#rc.Product#" property="allowBackorderFlag" edit="#rc.edit#" displayType="plain" fieldType="select" valueOptions="#local.valueOptions#">
			</td>
			<td>
				<cfset local.settingSource =  rc.Product.getWhereSettingDefined("allowBackorderFlag")>
				<cfif local.settingSource.type eq "global">
					<a href="#buildURL(action='admin:setting.detail')#">#rc.$.Slatwall.rbKey( "entity.setting.global" )#</a>
				<cfelseif local.settingSource.type eq "Product Type">
					<a href="#buildURL(action='admin:product.detailProductType', queryString='productTypeID=#local.settingSource.id#')#">#local.settingSource.name#</a>
				<cfelse>
					#rc.$.Slatwall.rbKey( "entity.product" )#
				</cfif>
			</td>	
		</tr>
		
		<!--- Allow Drop Ship Flag --->
		<tr>
			<td class="property varWidth">
				<a href="##" class="tooltip">
					#rc.$.Slatwall.rbKey("setting.product.allowDropShipFlag")#
					<span>#rc.$.Slatwall.rbKey("setting.product.allowDropshipFlag_hint")#</span>
				</a>
			</td>
			<td>
				<cfset local.valueOptions[1].name = "#rc.$.Slatwall.rbKey('setting.inherit')# (#yesNoFormat(rc.product.getInheritedSetting('allowDropShipFlag'))#)" />
				<cf_SlatwallPropertyDisplay object="#rc.Product#" property="allowDropShipFlag" edit="#rc.edit#" displayType="plain" fieldType="select" valueOptions="#local.valueOptions#">
			</td>
			<td>
				<cfset local.settingSource =  rc.Product.getWhereSettingDefined("allowDropShipFlag")>
				<cfif local.settingSource.type eq "global">
					<a href="#buildURL(action='admin:setting.detail')#">#rc.$.Slatwall.rbKey( "entity.setting.global" )#</a>
				<cfelseif local.settingSource.type eq "Product Type">
					<a href="#buildURL(action='admin:product.detailProductType', queryString='productTypeID=#local.settingSource.id#')#">#local.settingSource.name#</a>
				<cfelse>
					#rc.$.Slatwall.rbKey( "entity.product" )#
				</cfif>
			</td>		
		</tr>
		
		<!--- Allow Shipping Flag --->
		<tr>
			<td class="property varWidth">
				<a href="##" class="tooltip">
					#rc.$.Slatwall.rbKey("setting.product.allowShippingFlag")#
					<span>#rc.$.Slatwall.rbKey("setting.product.allowShippingFlag_hint")#</span>
				</a>
			</td>
			<td>
				<cfset local.valueOptions[1].name = "#rc.$.Slatwall.rbKey('setting.inherit')# (#yesNoFormat(rc.product.getInheritedSetting('allowShippingFlag'))#)" />
				<cf_SlatwallPropertyDisplay object="#rc.Product#" property="allowShippingFlag" edit="#rc.edit#" displayType="plain" fieldType="select" valueOptions="#local.valueOptions#">
			</td>
			<td>
				<cfset local.settingSource =  rc.Product.getWhereSettingDefined("allowShippingFlag")>
				<cfif local.settingSource.type eq "global">
					<a href="#buildURL(action='admin:setting.detail')#">#rc.$.Slatwall.rbKey( "entity.setting.global" )#</a>
				<cfelseif local.settingSource.type eq "Product Type">
					<a href="#buildURL(action='admin:product.detailProductType', queryString='productTypeID=#local.settingSource.id#')#">#local.settingSource.name#</a>
				<cfelse>
					#rc.$.Slatwall.rbKey( "entity.product" )#
				</cfif>
			</td>		
		</tr>
		
		<!--- Allow Pre-Order Flag --->
		<tr>
			<td class="property varWidth">
				<a href="##" class="tooltip">
					#rc.$.Slatwall.rbKey("setting.product.allowPreorderFlag")#
					<span>#rc.$.Slatwall.rbKey("setting.product.allowPreorderFlag_hint")#</span>
				</a>
			</td>
			<td>
				<cfset local.valueOptions[1].name = "#rc.$.Slatwall.rbKey('setting.inherit')# (#yesNoFormat(rc.product.getInheritedSetting('allowPreorderFlag'))#)" />
				<cf_SlatwallPropertyDisplay object="#rc.Product#" property="allowPreorderFlag" edit="#rc.edit#" displayType="plain" fieldType="select" valueOptions="#local.valueOptions#">
			</td>
			<td>
				<cfset local.settingSource =  rc.Product.getWhereSettingDefined("allowPreorderFlag")>
				<cfif local.settingSource.type eq "global">
					<a href="#buildURL(action='admin:setting.detail')#">#rc.$.Slatwall.rbKey( "entity.setting.global" )#</a>
				<cfelseif local.settingSource.type eq "Product Type">
					<a href="#buildURL(action='admin:product.detailProductType', queryString='productTypeID=#local.settingSource.id#')#">#local.settingSource.name#</a>
				<cfelse>
					#rc.$.Slatwall.rbKey( "entity.product" )#
				</cfif>
			</td>			
		</tr>
		
		<!--- Call To Order Flag --->
		<tr>
			<td class="property varWidth">
				<a href="##" class="tooltip">
					#rc.$.Slatwall.rbKey("setting.product.callToOrderFlag")#
					<span>#rc.$.Slatwall.rbKey("setting.product.callToOrderFlag_hint")#</span>
				</a>
			</td>
			<td>
				<cfset local.valueOptions[1].name = "#rc.$.Slatwall.rbKey('setting.inherit')# (#yesNoFormat(rc.product.getInheritedSetting('callToOrderFlag'))#)" />
				<cf_SlatwallPropertyDisplay object="#rc.Product#" property="callToOrderFlag" edit="#rc.edit#" displayType="plain" fieldType="select" valueOptions="#local.valueOptions#">
			</td>
			<td>
				<cfset local.settingSource =  rc.Product.getWhereSettingDefined("callToOrderFlag")>
				<cfif local.settingSource.type eq "global">
					<a href="#buildURL(action='admin:setting.detail')#">#rc.$.Slatwall.rbKey( "entity.setting.global" )#</a>
				<cfelseif local.settingSource.type eq "Product Type">
					<a href="#buildURL(action='admin:product.detailProductType', queryString='productTypeID=#local.settingSource.id#')#">#local.settingSource.name#</a>
				<cfelse>
					#rc.$.Slatwall.rbKey( "entity.product" )#
				</cfif>
			</td>			
		</tr>
		
		<!--- Display Template --->
		<tr>
			<td class="property varWidth">
				<a href="##" class="tooltip">
					#rc.$.Slatwall.rbKey("setting.product.displayTemplate")#
					<span>#rc.$.Slatwall.rbKey("setting.product.displayTemplate_hint")#</span>
				</a>
			</td>
			<td>
				<cf_SlatwallPropertyDisplay object="#rc.product#" property="displayTemplate" edit="#rc.edit#" displayType="plain" fieldType="select" valueOptions="#rc.product.getDisplayTemplateOptions()#">
			</td>
			<td>
				<cfset local.thisSettingSource = rc.product.getWhereSettingDefined("displayTemplate") />
				<cfif local.thisSettingSource.type eq "Global">
					<a href="#buildURL(action='admin:setting.detail')#">#rc.$.Slatwall.rbKey('entity.setting.global')#</a>
				<cfelseif local.thisSettingSource.type eq "Product Type">
					<a href="#buildURL(action='admin:product.detailProductType',queryString='productTypeID=#local.thisSettingSource.id#')#">#local.thisSettingSource.name#</a>
				<cfelse>
					#rc.$.Slatwall.rbKey( "entity.product" )#
				</cfif>
			</td>
		</tr>
		
		<!--- Track Inventory Flag --->
		<tr>
			<td class="property varWidth">
				<a href="##" class="tooltip">
					#rc.$.Slatwall.rbKey("setting.product.trackInventoryFlag")#
					<span>#rc.$.Slatwall.rbKey("setting.Product.trackInventoryFlag_hint")#</span>
				</a>
			</td>
			<td>
				<cfset local.valueOptions[1].name = "#rc.$.Slatwall.rbKey('setting.inherit')# (#yesNoFormat(rc.product.getInheritedSetting('trackInventoryFlag'))#)" />
				<cf_SlatwallPropertyDisplay object="#rc.Product#" property="trackInventoryFlag" edit="#rc.edit#" displayType="plain" fieldType="select" valueOptions="#local.valueOptions#">
			</td>
			<td>
				<cfset local.settingSource =  rc.Product.getWhereSettingDefined("trackInventoryFlag")>
				<cfif local.settingSource.type eq "global">
					<a href="#buildURL(action='admin:setting.detail')#">#rc.$.Slatwall.rbKey( "entity.setting.global" )#</a>
				<cfelseif local.settingSource.type eq "Product Type">
					<a href="#buildURL(action='admin:product.detailProductType', queryString='productTypeID=#local.settingSource.id#')#">#local.settingSource.name#</a>
				<cfelseif local.settingSource.type eq "Product">
					#rc.$.Slatwall.rbKey( "entity.product" )#
				</cfif>
			</td>	
		</tr>
		
		
		
		
	</table>
</cfoutput>