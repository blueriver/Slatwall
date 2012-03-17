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

<cfsilent>
	<cfset local.yesNoValueOptions = [{name=$.slatwall.rbKey('define.yes'), value=1},{name=$.slatwall.rbKey('define.no'), value=0}] />
	<cfset local.localeOptions = ['Chinese (China)','Chinese (Hong Kong)','Chinese (Taiwan)','Dutch (Belgian)','Dutch (Standard)','English (Australian)','English (Canadian)','English (New Zealand)','English (UK)','English (US)','French (Belgian)','French (Canadian)','French (Standard)','French (Swiss)','German (Austrian)','German (Standard)','German (Swiss)','Italian (Standard)',
									'Italian (Swiss)','Japanese','Korean','Norwegian (Bokmal)','Norwegian (Nynorsk)','Portuguese (Brazilian)','Portuguese (Standard)','Spanish (Mexican)','Spanish (Modern)','Spanish (Standard)','Swedish'] />
</cfsilent>

<cfoutput>
	<table class="table table-striped table-bordered">
		<tr>
			<th class="primary">#rc.$.Slatwall.rbKey('setting')#</th>
			<th>#rc.$.Slatwall.rbKey('setting.value')#</th>	
		</tr>
		<tr class="spdproduct_rootProductCategory">
			<td class="title primary">#rc.$.slatwall.rbKey('setting.product.rootProductCategory')#</td>
			<cfif rc.edit>
				<td class="value">
					<select name="product_rootProductCategory">
						<option value="0">#$.slatwall.rbKey("define.all")#</option>
						<cfloop query="rc.muraCategories">
							<option value="#rc.muraCategories.categoryID#" <cfif rc.allSettings.product_rootProductCategory.getSettingValue() eq rc.muraCategories.categoryID>selected="selected"</cfif>>#repeatString("&nbsp;&nbsp;&nbsp;",rc.muraCategories.treeDepth)#<cfif rc.muraCategories.treeDepth>&lfloor;</cfif>#rc.muraCategories.name#</option>
						</cfloop>
					</select>
				</td>
			<cfelse>
				<td class="value">#rc.rootCategory#</td>
			</cfif>
		</tr>
		<cf_SlatwallPropertyDisplay property="settingValue" edit="#rc.edit#" displaytype="table" titleClass="varWidth" object="#rc.allSettings.product_urlKey#" title="#rc.$.Slatwall.rbKey('setting.product.urlKey')#" fieldName="product_urlKey">
		<cf_SlatwallPropertyDisplay property="settingValue" edit="#rc.edit#" displaytype="table" titleClass="varWidth" object="#rc.allSettings.product_missingimagepath#" title="#rc.$.Slatwall.rbKey('setting.product.missingimagepath')#" fieldName="product_missingimagepath">
		<cf_SlatwallPropertyDisplay property="settingValue" edit="#rc.edit#" displaytype="table" titleClass="varWidth" object="#rc.allSettings.product_imageextension#" title="#rc.$.Slatwall.rbKey('setting.product.imageextension')#" fieldName="product_imageextension">
		<cf_SlatwallPropertyDisplay property="settingValue" edit="#rc.edit#" displaytype="table" titleClass="varWidth" object="#rc.allSettings.product_imagewidthsmall#" title="#rc.$.Slatwall.rbKey('setting.product.imagewidthsmall')#" fieldName="product_imagewidthsmall">
		<cf_SlatwallPropertyDisplay property="settingValue" edit="#rc.edit#" displaytype="table" titleClass="varWidth" object="#rc.allSettings.product_imageheightsmall#" title="#rc.$.Slatwall.rbKey('setting.product.imageheightsmall')#" fieldName="product_imageheightsmall">
		<cf_SlatwallPropertyDisplay property="settingValue" edit="#rc.edit#" displaytype="table" titleClass="varWidth" object="#rc.allSettings.product_imagewidthmedium#" title="#rc.$.Slatwall.rbKey('setting.product.imagewidthmedium')#" fieldName="product_imagewidthmedium">
		<cf_SlatwallPropertyDisplay property="settingValue" edit="#rc.edit#" displaytype="table" titleClass="varWidth" object="#rc.allSettings.product_imageheightmedium#" title="#rc.$.Slatwall.rbKey('setting.product.imageheightmedium')#" fieldName="product_imageheightmedium">
		<cf_SlatwallPropertyDisplay property="settingValue" edit="#rc.edit#" displaytype="table" titleClass="varWidth" object="#rc.allSettings.product_imagewidthlarge#" title="#rc.$.Slatwall.rbKey('setting.product.imagewidthlarge')#" fieldName="product_imagewidthlarge">
		<cf_SlatwallPropertyDisplay property="settingValue" edit="#rc.edit#" displaytype="table" titleClass="varWidth" object="#rc.allSettings.product_imageheightlarge#" title="#rc.$.Slatwall.rbKey('setting.product.imageheightlarge')#" fieldName="product_imageheightlarge">
		<cf_SlatwallPropertyDisplay property="settingValue" edit="#rc.edit#" displaytype="table" titleClass="varWidth" object="#rc.allSettings.product_titleString#" title="#rc.$.Slatwall.rbKey('setting.product.titleString')#" fieldName="product_titleString">
		<tr>
			<th colspan="2" class="varWidth">These settings can be overridden on a Product Type or Product Level</th>
		</tr>
		<!--- Settings that can be overridden start here --->
		<cf_SlatwallPropertyDisplay property="settingValue" edit="#rc.edit#" displaytype="table" titleClass="varWidth" object="#rc.allSettings.product_allowBackorderFlag#" title="#rc.$.Slatwall.rbKey('setting.product.allowBackorderFlag')#" fieldName="product_allowBackorderFlag" fieldType="radiogroup" valueOptions="#local.yesNoValueOptions#" valueFormatType="yesno">
		<cf_SlatwallPropertyDisplay property="settingValue" edit="#rc.edit#" displaytype="table" titleClass="varWidth" object="#rc.allSettings.product_allowDropshipFlag#" title="#rc.$.Slatwall.rbKey('setting.product.allowDropshipFlag')#" fieldName="product_allowDropshipFlag" fieldType="radiogroup" valueOptions="#local.yesNoValueOptions#" valueFormatType="yesno">
		<cf_SlatwallPropertyDisplay property="settingValue" edit="#rc.edit#" displaytype="table" titleClass="varWidth" object="#rc.allSettings.product_allowPreorderFlag#" title="#rc.$.Slatwall.rbKey('setting.product.allowPreorderFlag')#" fieldName="product_allowPreorderFlag" fieldType="radiogroup" valueOptions="#local.yesNoValueOptions#" valueFormatType="yesno">
		<cf_SlatwallPropertyDisplay property="settingValue" edit="#rc.edit#" displaytype="table" titleClass="varWidth" object="#rc.allSettings.product_allowShippingFlag#" title="#rc.$.Slatwall.rbKey('setting.product.allowShippingFlag')#" fieldName="product_allowShippingFlag" fieldType="radiogroup" valueOptions="#local.yesNoValueOptions#" valueFormatType="yesno">
	    <cf_SlatwallPropertyDisplay property="settingValue" edit="#rc.edit#" displaytype="table" titleClass="varWidth" object="#rc.allSettings.product_callToOrderFlag#" title="#rc.$.Slatwall.rbKey('setting.product.callToOrderFlag')#" fieldName="product_callToOrderFlag" fieldType="radiogroup" valueOptions="#local.yesNoValueOptions#" valueFormatType="yesno">
		<tr class="spdproduct_productdisplaytemplate">
			<td class="title varWidth">#rc.$.Slatwall.rbKey('setting.product.productDisplayTemplate')#</td>
			<cfif rc.edit>
				<td id="spdproduct_productdisplayttemplate" class="value">
					<select name="product_productDisplayTemplate">
						<cfloop array="#rc.productTemplateOptions#" index="local.dtOption">
							<option value="#local.dtOption.value#" <cfif rc.allSettings.product_productDisplayTemplate.getSettingValue() eq local.dtOption.value>selected="selected"</cfif>>#local.dtOption.name#</option>
						</cfloop>
					</select>
				</td>
			<cfelse>
				<td id="spdproduct_productdisplayttemplate" class="value">#rc.allSettings.product_productDisplayTemplate.getSettingValue()#</td>	
			</cfif>
		</tr>
		<cf_SlatwallPropertyDisplay property="settingValue" edit="#rc.edit#" displaytype="table" titleClass="varWidth" object="#rc.allSettings.product_quantityHeldBack#" title="#rc.$.Slatwall.rbKey('setting.product.quantityHeldBack')#" fieldName="product_quantityHeldBack">
		<cf_SlatwallPropertyDisplay property="settingValue" edit="#rc.edit#" displaytype="table" titleClass="varWidth" object="#rc.allSettings.product_quantityMinimum#" title="#rc.$.Slatwall.rbKey('setting.product.quantityMinimum')#" fieldName="product_quantityMinimum">
		<cf_SlatwallPropertyDisplay property="settingValue" edit="#rc.edit#" displaytype="table" titleClass="varWidth" object="#rc.allSettings.product_quantityMaximum#" title="#rc.$.Slatwall.rbKey('setting.product.quantityMaximum')#" fieldName="product_quantityMaximum">
		<cf_SlatwallPropertyDisplay property="settingValue" edit="#rc.edit#" displaytype="table" titleClass="varWidth" object="#rc.allSettings.product_quantityOrderMinimum#" title="#rc.$.Slatwall.rbKey('setting.product.quantityOrderMinimum')#" fieldName="product_quantityOrderMinimum">
		<cf_SlatwallPropertyDisplay property="settingValue" edit="#rc.edit#" displaytype="table" titleClass="varWidth" object="#rc.allSettings.product_quantityOrderMaximum#" title="#rc.$.Slatwall.rbKey('setting.product.quantityOrderMaximum')#" fieldName="product_quantityOrderMaximum">
		<cf_SlatwallPropertyDisplay property="settingValue" edit="#rc.edit#" displaytype="table" titleClass="varWidth" object="#rc.allSettings.product_shippingWeight#" title="#rc.$.Slatwall.rbKey('setting.product.shippingWeight')#" fieldName="product_shippingWeight">
		<tr class="spdproduct_shippingweightunitcode">
			<td class="title varWidth">#rc.$.Slatwall.rbKey('setting.product.shippingWeightUnitCode')#</td>
			<cfif rc.edit>
				<td id="spdproduct_shippingweightunitcode" class="value">
					<select name="product_shippingWeightUnitCode">
						<cfloop array="#rc.shippingWeightUnitCodeOptions#" index="local.option">
							<option value="#local.option['value']#" <cfif rc.allSettings.product_shippingWeightUnitCode.getSettingValue() eq local.option['value']>selected="selected"</cfif>>#local.option['name']#</option>
						</cfloop>
					</select>
				</td>
			<cfelse>
				<td id="spdproduct_shippingweightunitcode" class="value">#rc.allSettings.product_shippingWeightUnitCode.getSettingValue()#</td>	
			</cfif>
		</tr>
		<cf_SlatwallPropertyDisplay property="settingValue" edit="#rc.edit#" displaytype="table" titleClass="varWidth" object="#rc.allSettings.product_trackInventoryFlag#" title="#rc.$.Slatwall.rbKey('setting.product.trackInventoryFlag')#" fieldName="product_trackInventoryFlag" fieldType="radiogroup" valueOptions="#local.yesNoValueOptions#" valueFormatType="yesno">
	</table>
</cfoutput>