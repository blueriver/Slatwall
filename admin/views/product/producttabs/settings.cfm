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
				<cfset local.valueOptions[1].name = "#rc.$.Slatwall.rbKey('setting.inherit')# ( #yesNoFormat(rc.product.getInheritedSetting('allowBackorderFlag'))# )" />
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
				<cfset local.valueOptions[1].name = "#rc.$.Slatwall.rbKey('setting.inherit')# ( #yesNoFormat(rc.product.getInheritedSetting('allowDropShipFlag'))# )" />
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
				<cfset local.valueOptions[1].name = "#rc.$.Slatwall.rbKey('setting.inherit')# ( #yesNoFormat(rc.product.getInheritedSetting('allowShippingFlag'))# )" />
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
				<cfset local.valueOptions[1].name = "#rc.$.Slatwall.rbKey('setting.inherit')# ( #yesNoFormat(rc.product.getInheritedSetting('allowPreorderFlag'))# )" />
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
				<cfset local.valueOptions[1].name = "#rc.$.Slatwall.rbKey('setting.inherit')# ( #yesNoFormat(rc.product.getInheritedSetting('callToOrderFlag'))# )" />
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
				<cfif rc.edit>
					<cf_SlatwallPropertyDisplay object="#rc.product#" property="displayTemplate" edit="true" displayType="plain" fieldType="select" valueOptions="#rc.product.getDisplayTemplateOptions()#">
				<cfelse>
					#rc.Product.getInheritedSetting("displayTemplate")#
				</cfif>
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
		
		<!--- Quantity Held Back --->
		<cfset local.thisSettingSource = rc.Product.getWhereSettingDefined("quantityHeldBack") />
		<cfif local.thisSettingSource.type eq "Product">
			<cfset local.definedHere = true>
		<cfelse>
			<cfset local.definedHere = false>
		</cfif>
		<tr>
			<td class="property varWidth">
				<a href="##" class="tooltip">
					#rc.$.Slatwall.rbKey("setting.product.quantityHeldBack")#
					<span>#rc.$.Slatwall.rbKey("setting.product.quantityHeldBack_hint")#</span>
				</a>
			</td>
			<td>
				<cfif rc.edit><input type="radio" name="inheritQuantityHeldBack" value="0" <cfif local.definedHere>checked="checked"</cfif>></cfif>
				<cf_SlatwallPropertyDisplay object="#rc.Product#" property="quantityHeldBack" edit="#rc.edit#" displayType="plain" fieldType="text">
				<cfif rc.edit><input type="radio" name="inheritQuantityHeldBack" value="1" class="checkClear" data-checkClear=".quantityheldbackfield" <cfif not local.definedHere>checked="checked"</cfif>></cfif>
				#rc.$.Slatwall.rbKey('setting.inherit')# ( #rc.Product.getInheritedSetting("quantityHeldBack")# )
			</td>
			<td>
				<cfif local.thisSettingSource.type eq "Global">
					<a href="#buildURL(action='admin:setting.detail')#">#rc.$.Slatwall.rbKey('entity.setting.global')#</a>
				<cfelseif local.thisSettingSource.type eq "Product Type">
					<a href="#buildURL(action='admin:product.detailProductType',queryString='productTypeID=#local.thisSettingSource.id#')#">#local.thisSettingSource.name#</a>
				<cfelse>
					#rc.$.Slatwall.rbKey( "entity.product" )#
				</cfif>
			</td>
		</tr>
		
		
		<!--- Quantity Minimum --->
		<cfset local.thisSettingSource = rc.Product.getWhereSettingDefined("quantityMinimum") />
		<cfif local.thisSettingSource.type eq "Product">
			<cfset local.definedHere = true>
		<cfelse>
			<cfset local.definedHere = false>
		</cfif>
		<tr>
			<td class="property varWidth">
				<a href="##" class="tooltip">
					#rc.$.Slatwall.rbKey("setting.product.quantityMinimum")#
					<span>#rc.$.Slatwall.rbKey("setting.product.quantityMinimum_hint")#</span>
				</a>
			</td>
			<td>
				<cfif rc.edit><input type="radio" name="inheritQuantityMinimum" value="0" <cfif local.definedHere>checked="checked"</cfif>></cfif>
				<cf_SlatwallPropertyDisplay object="#rc.Product#" property="quantityMinimum" edit="#rc.edit#" displayType="plain" fieldType="text">
				<cfif rc.edit><input type="radio" name="inheritQuantityMinimum" value="1" class="checkClear" data-checkClear=".quantityminimumfield" <cfif not local.definedHere>checked="checked"</cfif>></cfif>
				#rc.$.Slatwall.rbKey('setting.inherit')# ( #rc.Product.getInheritedSetting("quantityMinimum")# )
			</td>
			<td>
				<cfif local.thisSettingSource.type eq "Global">
					<a href="#buildURL(action='admin:setting.detail')#">#rc.$.Slatwall.rbKey('entity.setting.global')#</a>
				<cfelseif local.thisSettingSource.type eq "Product Type">
					<a href="#buildURL(action='admin:product.detailProductType',queryString='productTypeID=#local.thisSettingSource.id#')#">#local.thisSettingSource.name#</a>
				<cfelse>
					#rc.$.Slatwall.rbKey( "entity.product" )#
				</cfif>
			</td>
		</tr>
		
		
		<!--- Quantity Maximum --->
		<cfset local.thisSettingSource = rc.Product.getWhereSettingDefined("quantityMaximum") />
		<cfif local.thisSettingSource.type eq "Product">
			<cfset local.definedHere = true>
		<cfelse>
			<cfset local.definedHere = false>
		</cfif>
		<tr>
			<td class="property varWidth">
				<a href="##" class="tooltip">
					#rc.$.Slatwall.rbKey("setting.product.quantityMaximum")#
					<span>#rc.$.Slatwall.rbKey("setting.product.quantityMaximum_hint")#</span>
				</a>
			</td>
			<td>
				<cfif rc.edit><input type="radio" name="inheritQuantityMaximum" value="0" <cfif local.definedHere>checked="checked"</cfif>></cfif>
				<cf_SlatwallPropertyDisplay object="#rc.Product#" property="quantityMaximum" edit="#rc.edit#" displayType="plain" fieldType="text">
				<cfif rc.edit><input type="radio" name="inheritQuantityMaximum" value="1" class="checkClear" data-checkClear=".quantitymaximumfield" <cfif not local.definedHere>checked="checked"</cfif>></cfif>
				#rc.$.Slatwall.rbKey('setting.inherit')# ( #rc.Product.getInheritedSetting("quantityMaximum")# )
			</td>
			<td>
				<cfif local.thisSettingSource.type eq "Global">
					<a href="#buildURL(action='admin:setting.detail')#">#rc.$.Slatwall.rbKey('entity.setting.global')#</a>
				<cfelseif local.thisSettingSource.type eq "Product Type">
					<a href="#buildURL(action='admin:product.detailProductType',queryString='productTypeID=#local.thisSettingSource.id#')#">#local.thisSettingSource.name#</a>
				<cfelse>
					#rc.$.Slatwall.rbKey( "entity.product" )#
				</cfif>
			</td>
		</tr>
		
		
		<!--- Quantity Order Minimum --->
		<cfset local.thisSettingSource = rc.Product.getWhereSettingDefined("quantityOrderMinimum") />
		<cfif local.thisSettingSource.type eq "Product">
			<cfset local.definedHere = true>
		<cfelse>
			<cfset local.definedHere = false>
		</cfif>
		<tr>
			<td class="property varWidth">
				<a href="##" class="tooltip">
					#rc.$.Slatwall.rbKey("setting.product.quantityOrderMinimum")#
					<span>#rc.$.Slatwall.rbKey("setting.product.quantityOrderMinimum_hint")#</span>
				</a>
			</td>
			<td>
				<cfif rc.edit><input type="radio" name="inheritQuantityOrderMinimum" value="0" <cfif local.definedHere>checked="checked"</cfif>></cfif>
				<cf_SlatwallPropertyDisplay object="#rc.Product#" property="quantityOrderMinimum" edit="#rc.edit#" displayType="plain" fieldType="text">
				<cfif rc.edit><input type="radio" name="inheritQuantityOrderMinimum" value="1" class="checkClear" data-checkClear=".quantityorderminimumfield" <cfif not local.definedHere>checked="checked"</cfif>></cfif>
				#rc.$.Slatwall.rbKey('setting.inherit')# ( #rc.Product.getInheritedSetting("quantityOrderMinimum")# )
			</td>
			<td>
				<cfif local.thisSettingSource.type eq "Global">
					<a href="#buildURL(action='admin:setting.detail')#">#rc.$.Slatwall.rbKey('entity.setting.global')#</a>
				<cfelseif local.thisSettingSource.type eq "Product Type">
					<a href="#buildURL(action='admin:product.detailProductType',queryString='productTypeID=#local.thisSettingSource.id#')#">#local.thisSettingSource.name#</a>
				<cfelse>
					#rc.$.Slatwall.rbKey( "entity.product" )#
				</cfif>
			</td>
		</tr>
		
		
		<!--- Quantity Order Maximum --->
		<cfset local.thisSettingSource = rc.Product.getWhereSettingDefined("quantityOrderMaximum") />
		<cfif local.thisSettingSource.type eq "Product">
			<cfset local.definedHere = true>
		<cfelse>
			<cfset local.definedHere = false>
		</cfif>
		<tr>
			<td class="property varWidth">
				<a href="##" class="tooltip">
					#rc.$.Slatwall.rbKey("setting.product.quantityOrderMaximum")#
					<span>#rc.$.Slatwall.rbKey("setting.product.quantityOrderMaximum_hint")#</span>
				</a>
			</td>
			<td>
				<cfif rc.edit><input type="radio" name="inheritQuantityOrderMaximum" value="0" <cfif local.definedHere>checked="checked"</cfif>></cfif>
				<cf_SlatwallPropertyDisplay object="#rc.Product#" property="quantityOrderMaximum" edit="#rc.edit#" displayType="plain" fieldType="text">
				<cfif rc.edit><input type="radio" name="inheritQuantityOrderMaximum" value="1" class="checkClear" data-checkClear=".quantityordermaximumfield" <cfif not local.definedHere>checked="checked"</cfif>></cfif>
				#rc.$.Slatwall.rbKey('setting.inherit')# ( #rc.Product.getInheritedSetting("quantityOrderMaximum")# )
			</td>
			<td>
				<cfif local.thisSettingSource.type eq "Global">
					<a href="#buildURL(action='admin:setting.detail')#">#rc.$.Slatwall.rbKey('entity.setting.global')#</a>
				<cfelseif local.thisSettingSource.type eq "Product Type">
					<a href="#buildURL(action='admin:product.detailProductType',queryString='productTypeID=#local.thisSettingSource.id#')#">#local.thisSettingSource.name#</a>
				<cfelse>
					#rc.$.Slatwall.rbKey( "entity.product" )#
				</cfif>
			</td>
		</tr>
		
		
		<!--- Shipping Weight --->
		<cfset local.thisSettingSource = rc.Product.getWhereSettingDefined("shippingWeight") />
		<cfif local.thisSettingSource.type eq "Product">
			<cfset local.definedHere = true>
		<cfelse>
			<cfset local.definedHere = false>
		</cfif>
		<tr>
			<td class="property varWidth">
				<a href="##" class="tooltip">
					#rc.$.Slatwall.rbKey("setting.product.shippingWeight")#
					<span>#rc.$.Slatwall.rbKey("setting.product.shippingWeight_hint")#</span>
				</a>
			</td>
			<td>
				<cfif rc.edit><input type="radio" name="inheritShippingWeight" value="0" <cfif local.definedHere>checked="checked"</cfif>></cfif>
				<cf_SlatwallPropertyDisplay object="#rc.Product#" property="shippingWeight" edit="#rc.edit#" displayType="plain" fieldType="text">
				<cfif rc.edit><input type="radio" name="inheritShippingWeight" value="1" class="checkClear" data-checkClear=".shippingweightfield" <cfif not local.definedHere>checked="checked"</cfif>></cfif>
				#rc.$.Slatwall.rbKey('setting.inherit')# ( #rc.Product.getInheritedSetting("shippingWeight")# )
			</td>
			<td>
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