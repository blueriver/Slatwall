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
			<th class="varWidth">#rc.$.Slatwall.rbKey('entity.setting.settingName')#</th>
			<th>#rc.$.Slatwall.rbKey('entity.setting.settingValue')#</th>
			<th>#rc.$.Slatwall.rbKey('admin.productType.settingDefinedIn')#</th>
		</tr>
		
		<!--- Allow Backorder Flag --->
		<tr>
			<td class="property varWidth">
				<a href="##" class="tooltip">
					#rc.$.Slatwall.rbKey("setting.product.allowBackorderFlag")#
					<span>#rc.$.Slatwall.rbKey("setting.product.allowBackorderFlag_hint")#</span>
				</a>
			</td>
			<td>
				<cfset local.valueOptions[1].name = "#rc.$.Slatwall.rbKey('setting.inherit')# ( #yesNoFormat(rc.productType.getInheritedSetting('allowBackorderFlag'))# )" />
				<cf_SlatwallPropertyDisplay object="#rc.productType#" property="allowBackorderFlag" edit="#rc.edit#" displayType="plain" fieldType="select" valueOptions="#local.valueOptions#">
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
		
		<!--- Allow Dropship Flag --->
		<tr>
			<td class="property varWidth">
				<a href="##" class="tooltip">
					#rc.$.Slatwall.rbKey("setting.product.allowDropShipFlag")#
					<span>#rc.$.Slatwall.rbKey("setting.product.allowDropshipFlag_hint")#</span>
				</a>
			</td>
			<td>
				<cfset local.valueOptions[1].name = "#rc.$.Slatwall.rbKey('setting.inherit')# ( #yesNoFormat(rc.productType.getInheritedSetting('allowDropShipFlag'))# )" />
				<cf_SlatwallPropertyDisplay object="#rc.productType#" property="allowDropShipFlag" edit="#rc.edit#" displayType="plain" fieldType="select" valueOptions="#local.valueOptions#">
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
		
		<!--- Allow Preorder Flag --->
		<tr>
			<td class="property varWidth">
				<a href="##" class="tooltip">
					#rc.$.Slatwall.rbKey("setting.product.allowPreorderFlag")#
					<span>#rc.$.Slatwall.rbKey("setting.product.allowPreorderFlag_hint")#</span>
				</a>
			</td>
			<td>
				<cfset local.valueOptions[1].name = "#rc.$.Slatwall.rbKey('setting.inherit')# ( #yesNoFormat(rc.productType.getInheritedSetting('allowPreorderFlag'))# )" />
				<cf_SlatwallPropertyDisplay object="#rc.productType#" property="allowPreorderFlag" edit="#rc.edit#" displayType="plain" fieldType="select" valueOptions="#local.valueOptions#">
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
		
		<!--- Allow Shipping Flag --->
		<tr>
			<td class="property varWidth">
				<a href="##" class="tooltip">
					#rc.$.Slatwall.rbKey("setting.product.allowShippingFlag")#
					<span>#rc.$.Slatwall.rbKey("setting.product.allowShippingFlag_hint")#</span>
				</a>
			</td>
			<td>
				<cfset local.valueOptions[1].name = "#rc.$.Slatwall.rbKey('setting.inherit')# ( #yesNoFormat(rc.productType.getInheritedSetting('allowShippingFlag'))# )" />
				<cf_SlatwallPropertyDisplay object="#rc.productType#" property="allowShippingFlag" edit="#rc.edit#" displayType="plain" fieldType="select" valueOptions="#local.valueOptions#">
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
		
		<!--- Call To Order Flag --->
		<tr>
			<td class="property varWidth">
				<a href="##" class="tooltip">
					#rc.$.Slatwall.rbKey("setting.product.callToOrderFlag")#
					<span>#rc.$.Slatwall.rbKey("setting.product.callToOrderFlag_hint")#</span>
				</a>
			</td>
			<td>
				<cfset local.valueOptions[1].name = "#rc.$.Slatwall.rbKey('setting.inherit')# ( #yesNoFormat(rc.productType.getInheritedSetting('callToOrderFlag'))# )" />
				<cf_SlatwallPropertyDisplay object="#rc.productType#" property="callToOrderFlag" edit="#rc.edit#" displayType="plain" fieldType="select" valueOptions="#local.valueOptions#">
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
		
		<!--- Product Display Template --->
		<tr>
			<td class="property varWidth">
				<a href="##" class="tooltip">
					#rc.$.Slatwall.rbKey("setting.product.productDisplayTemplate")#
					<span>#rc.$.Slatwall.rbKey("setting.product.productDisplayTemplate_hint")#</span>
				</a>
			</td>
			<td>
				<cfif rc.edit>
					<cf_SlatwallPropertyDisplay object="#rc.productType#" property="productDisplayTemplate" edit="true" displayType="plain" fieldType="select" valueOptions="#rc.productType.getProductDisplayTemplateOptions()#">
				<cfelse>
					#rc.Product.getInheritedSetting("displayTemplate")#
				</cfif>
			</td>
			<td>
				<cfset local.thisSettingSource = rc.ProductType.getWhereSettingDefined("productDisplayTemplate") />
				<cfif local.thisSettingSource.type eq "Global">
					<a href="#buildURL(action='admin:setting.detail')#">#rc.$.Slatwall.rbKey('entity.setting.global')#</a>
				<cfelseif local.thisSettingSource.type eq "Product Type" and local.thisSettingSource.id neq rc.ProductType.getProductTypeID()>
					<a href="#buildURL(action='admin:product.detailProductType',queryString='productTypeID=#local.thisSettingSource.id#')#">#local.thisSettingSource.name#</a>
				<cfelse>
					#local.thisSettingSource.name#
				</cfif>
			</td>
		</tr>
		
		<!--- Quantity Held Back --->
		<cfset local.thisSettingSource = rc.ProductType.getWhereSettingDefined("quantityHeldBack") />
		<cfif local.thisSettingSource.type eq "Product Type" and local.thisSettingSource.id eq rc.ProductType.getProductTypeID()>
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
				<cf_SlatwallPropertyDisplay object="#rc.productType#" property="quantityHeldBack" edit="#rc.edit#" displayType="plain" fieldType="text">
				<cfif rc.edit><input type="radio" name="inheritQuantityHeldBack" value="1" class="checkClear" data-checkClear=".quantityheldbackfield" <cfif not local.definedHere>checked="checked"</cfif>></cfif>
				#rc.$.Slatwall.rbKey('setting.inherit')# ( #rc.ProductType.getInheritedSetting("quantityHeldBack")# )
			</td>
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
		
		
		<!--- Quantity Minimum --->
		<cfset local.thisSettingSource = rc.ProductType.getWhereSettingDefined("quantityMinimum") />
		<cfif local.thisSettingSource.type eq "Product Type" and local.thisSettingSource.id eq rc.ProductType.getProductTypeID()>
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
				<cf_SlatwallPropertyDisplay object="#rc.productType#" property="quantityMinimum" edit="#rc.edit#" displayType="plain" fieldType="text">
				<cfif rc.edit><input type="radio" name="inheritQuantityMinimum" value="1" class="checkClear" data-checkClear=".quantityminimumfield" <cfif not local.definedHere>checked="checked"</cfif>></cfif>
				#rc.$.Slatwall.rbKey('setting.inherit')# ( #rc.ProductType.getInheritedSetting("quantityMinimum")# )
			</td>
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
		
		
		<!--- Quantity Maximum --->
		<cfset local.thisSettingSource = rc.ProductType.getWhereSettingDefined("quantityMaximum") />
		<cfif local.thisSettingSource.type eq "Product Type" and local.thisSettingSource.id eq rc.ProductType.getProductTypeID()>
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
					<cf_SlatwallPropertyDisplay object="#rc.productType#" property="quantityMaximum" edit="#rc.edit#" displayType="plain" fieldType="text">
				<cfif rc.edit><input type="radio" name="inheritQuantityMaximum" value="1" class="checkClear" data-checkClear=".quantitymaximumfield" <cfif not local.definedHere>checked="checked"</cfif>></cfif>
					#rc.$.Slatwall.rbKey('setting.inherit')# ( #rc.ProductType.getInheritedSetting("quantityMaximum")# )
			</td>
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
		
		
		<!--- Quantity Order Minimum --->
		<cfset local.thisSettingSource = rc.ProductType.getWhereSettingDefined("quantityOrderMinimum") />
		<cfif local.thisSettingSource.type eq "Product Type" and local.thisSettingSource.id eq rc.ProductType.getProductTypeID()>
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
				<cf_SlatwallPropertyDisplay object="#rc.productType#" property="quantityOrderMinimum" edit="#rc.edit#" displayType="plain" fieldType="text">
				<cfif rc.edit><input type="radio" name="inheritQuantityOrderMinimum" value="1" class="checkClear" data-checkClear=".quantityorderminimumfield" <cfif not local.definedHere>checked="checked"</cfif>></cfif>
				#rc.$.Slatwall.rbKey('setting.inherit')# ( #rc.ProductType.getInheritedSetting("quantityOrderMinimum")# )
			</td>
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
		
		
		<!--- Quantity Order Maximum --->
		<cfset local.thisSettingSource = rc.ProductType.getWhereSettingDefined("quantityOrderMaximum") />
		<cfif local.thisSettingSource.type eq "Product Type" and local.thisSettingSource.id eq rc.ProductType.getProductTypeID()>
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
				<cf_SlatwallPropertyDisplay object="#rc.productType#" property="quantityOrderMaximum" edit="#rc.edit#" displayType="plain" fieldType="text">
				<cfif rc.edit><input type="radio" name="inheritQuantityOrderMaximum" value="1" class="checkClear" data-checkClear=".quantityordermaximumfield" <cfif not local.definedHere>checked="checked"</cfif>></cfif>
				#rc.$.Slatwall.rbKey('setting.inherit')# ( #rc.ProductType.getInheritedSetting("quantityOrderMaximum")# )
			</td>
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
		
		
		<!--- Shipping Weight --->
		<cfset local.thisSettingSource = rc.ProductType.getWhereSettingDefined("shippingWeight") />
		<cfif local.thisSettingSource.type eq "Product Type" and local.thisSettingSource.id eq rc.ProductType.getProductTypeID()>
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
				<cf_SlatwallPropertyDisplay object="#rc.productType#" property="shippingWeight" edit="#rc.edit#" displayType="plain" fieldType="text">
				<cfif rc.edit><input type="radio" name="inheritShippingWeight" value="1" class="checkClear" data-checkClear=".shippingweightfield" <cfif not local.definedHere>checked="checked"</cfif>></cfif>
				#rc.$.Slatwall.rbKey('setting.inherit')# ( #rc.ProductType.getInheritedSetting("shippingWeight")# )
			</td>
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


		<!--- Shipping Weight Unit Code --->
		<tr>
			<td class="property varWidth">
				<a href="##" class="tooltip">
					#rc.$.Slatwall.rbKey("setting.product.shippingWeightUnitCode")#
					<span>#rc.$.Slatwall.rbKey("setting.product.shippingWeightUnitCode_hint")#</span>
				</a>
			</td>
			<td>
				<cfif rc.edit>
					<cf_SlatwallPropertyDisplay object="#rc.productType#" property="shippingWeightUnitCode" edit="true" displayType="plain" fieldType="select" valueOptions="#rc.productType.getShippingWeightUnitCodeOptions()#">
				<cfelse>
					#rc.productType.getInheritedSetting("shippingWeightUnitCode")#
				</cfif>
			</td>
			<td>
				<cfset local.thisSettingSource = rc.ProductType.getWhereSettingDefined("shippingWeightUnitCode") />
				<cfif local.thisSettingSource.type eq "Global">
					<a href="#buildURL(action='admin:setting.detail')#">#rc.$.Slatwall.rbKey('entity.setting.global')#</a>
				<cfelseif local.thisSettingSource.type eq "Product Type" and local.thisSettingSource.id neq rc.ProductType.getProductTypeID()>
					<a href="#buildURL(action='admin:product.detailProductType',queryString='productTypeID=#local.thisSettingSource.id#')#">#local.thisSettingSource.name#</a>
				<cfelse>
					#local.thisSettingSource.name#
				</cfif>
			</td>
		</tr>
		
		
		
		<!--- Track Inventory Flag --->
		<tr>
			<td class="property varWidth">
				<a href="##" class="tooltip">
					#rc.$.Slatwall.rbKey("setting.product.trackInventoryFlag")#
					<span>#rc.$.Slatwall.rbKey("setting.product.trackInventoryFlag_hint")#</span>
				</a>
			</td>
			<td>
				<cfset local.valueOptions[1].name = "#rc.$.Slatwall.rbKey('setting.inherit')# ( #yesNoFormat(rc.productType.getInheritedSetting('trackInventoryFlag'))# )" />
				<cf_SlatwallPropertyDisplay object="#rc.productType#" property="trackInventoryFlag" edit="#rc.edit#" displayType="plain" fieldType="select" valueOptions="#local.valueOptions#">
			</td>
			<td>
				<cfset local.thisSettingSource = rc.ProductType.getWhereSettingDefined("trackInventoryFlag") />
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
</cfoutput>