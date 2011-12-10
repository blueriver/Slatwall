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
<cfparam name="rc.edit" type="boolean" />
<cfparam name="rc.allSettings" type="struct" />
<cfparam name="rc.productTemplateOptions" type="any" />

<cfsilent>
	<cfset local.yesNoValueOptions = [{name=$.slatwall.rbKey('define.yes'), value=1},{name=$.slatwall.rbKey('define.no'), value=0}] />
	<cfset local.localeOptions = ['Chinese (China)','Chinese (Hong Kong)','Chinese (Taiwan)','Dutch (Belgian)','Dutch (Standard)','English (Australian)','English (Canadian)','English (New Zealand)','English (UK)','English (US)','French (Belgian)','French (Canadian)','French (Standard)','French (Swiss)','German (Austrian)','German (Standard)','German (Swiss)','Italian (Standard)',
									'Italian (Swiss)','Japanese','Korean','Norwegian (Bokmal)','Norwegian (Nynorsk)','Portuguese (Brazilian)','Portuguese (Standard)','Spanish (Mexican)','Spanish (Modern)','Spanish (Standard)','Swedish'] />
</cfsilent>

<cfoutput>
	<div class="svoadminsettingdetail">
		<cfif rc.edit eq false>
	        <ul id="navTask">
	            <cf_SlatwallActionCaller action="admin:setting.edit" type="list">
	        </ul>
		<cfelse>
			<form action="#buildURL(action='admin:setting.save')#" method="post">
		</cfif>
		<div class="tabs initActiveTab ui-tabs ui-widget ui-widget-content ui-corner-all">
			<ul>
				<li><a href="##tabProduct" onclick="return false;"><span>#rc.$.Slatwall.rbKey('setting.product')#</span></a></li>	
				<li><a href="##tabOrder" onclick="return false;"><span>#rc.$.Slatwall.rbKey('setting.order')#</span></a></li>
				<li><a href="##tabAdvanced" onclick="return false;"><span>#rc.$.Slatwall.rbKey('setting.advanced')#</span></a></li>
			</ul>
			<div id="tabProduct">
				<table id="ProductSettings" class="listing-grid stripe">
					<tr>
						<th class="varWidth">#rc.$.Slatwall.rbKey('setting')#</th>
						<th>#rc.$.Slatwall.rbKey('setting.value')#</th>	
					</tr>
					<tr class="spdproduct_defaulttemplate">
						<td class="title varWidth">#rc.$.Slatwall.rbKey('setting.product.defaultProductTemplate')#</td>
						<cfif rc.edit>
							<td id="spdproduct_defaulttemplate" class="value">
								<select name="product_defaulttemplate">
									<cfloop query="rc.productTemplateOptions">
										<option value="#rc.productTemplateOptions.filename#" <cfif rc.allSettings.product_defaultTemplate.getSettingValue() eq rc.productTemplateOptions.filename>selected="selected"</cfif>>#rc.productTemplateOptions.menutitle#</option>
									</cfloop>
								</select>
							</td>
						<cfelse>
							<td id="spdproduct_defaulttemplate" class="value">#rc.allSettings.product_defaultTemplate.getSettingValue()#</td>	
						</cfif>
					</tr>
					<tr class="spdproduct_rootProductCategory">
						<td class="title varWidth">#rc.$.slatwall.rbKey('setting.product.rootProductCategory')#</td>
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
					<cf_SlatwallPropertyDisplay property="settingValue" edit="#rc.edit#" displaytype="table" titleClass="varWidth" object="#rc.allSettings.product_trackInventoryFlag#" title="#rc.$.Slatwall.rbKey('setting.product.trackInventoryFlag')#" fieldName="product_trackInventoryFlag" fieldType="radiogroup" valueOptions="#local.yesNoValueOptions#" valueFormatType="yesno">
				    <cf_SlatwallPropertyDisplay property="settingValue" edit="#rc.edit#" displaytype="table" titleClass="varWidth" object="#rc.allSettings.product_callToOrderFlag#" title="#rc.$.Slatwall.rbKey('setting.product.callToOrderFlag')#" fieldName="product_callToOrderFlag" fieldType="radiogroup" valueOptions="#local.yesNoValueOptions#" valueFormatType="yesno">
				    <cf_SlatwallPropertyDisplay property="settingValue" edit="#rc.edit#" displaytype="table" titleClass="varWidth" object="#rc.allSettings.product_allowShippingFlag#" title="#rc.$.Slatwall.rbKey('setting.product.allowShippingFlag')#" fieldName="product_allowShippingFlag" fieldType="radiogroup" valueOptions="#local.yesNoValueOptions#" valueFormatType="yesno">
				    <cf_SlatwallPropertyDisplay property="settingValue" edit="#rc.edit#" displaytype="table" titleClass="varWidth" object="#rc.allSettings.product_allowPreorderFlag#" title="#rc.$.Slatwall.rbKey('setting.product.allowPreorderFlag')#" fieldName="product_allowPreorderFlag" fieldType="radiogroup" valueOptions="#local.yesNoValueOptions#" valueFormatType="yesno">
					<cf_SlatwallPropertyDisplay property="settingValue" edit="#rc.edit#" displaytype="table" titleClass="varWidth" object="#rc.allSettings.product_allowBackorderFlag#" title="#rc.$.Slatwall.rbKey('setting.product.allowBackorderFlag')#" fieldName="product_allowBackorderFlag" fieldType="radiogroup" valueOptions="#local.yesNoValueOptions#" valueFormatType="yesno">
					<cf_SlatwallPropertyDisplay property="settingValue" edit="#rc.edit#" displaytype="table" titleClass="varWidth" object="#rc.allSettings.product_allowDropshipFlag#" title="#rc.$.Slatwall.rbKey('setting.product.allowDropshipFlag')#" fieldName="product_allowDropshipFlag" fieldType="radiogroup" valueOptions="#local.yesNoValueOptions#" valueFormatType="yesno">
				</table>
			</div>
			<div id="tabOrder">
				<table id="OrderSettings" class="listing-grid stripe">
					<tr>
						<th class="varWidth">#rc.$.Slatwall.rbKey('setting')#</th>
						<th>#rc.$.Slatwall.rbKey('setting.value')#</th>	
					</tr>
					<cf_SlatwallPropertyDisplay property="settingValue" edit="#rc.edit#" displaytype="table" titleClass="varWidth" object="#rc.allSettings.order_orderPlacedEmailFrom#" title="#rc.$.Slatwall.rbKey('setting.order.orderPlacedEmailFrom')#" fieldName="order_orderPlacedEmailFrom">
					<cf_SlatwallPropertyDisplay property="settingValue" edit="#rc.edit#" displaytype="table" titleClass="varWidth" object="#rc.allSettings.order_orderPlacedEmailCC#" title="#rc.$.Slatwall.rbKey('setting.order.orderPlacedEmailCC')#" fieldName="order_orderPlacedEmailCC">
					<cf_SlatwallPropertyDisplay property="settingValue" edit="#rc.edit#" displaytype="table" titleClass="varWidth" object="#rc.allSettings.order_orderPlacedEmailBCC#" title="#rc.$.Slatwall.rbKey('setting.order.orderPlacedEmailBCC')#" fieldName="order_orderPlacedEmailBCC">
					<cf_SlatwallPropertyDisplay property="settingValue" edit="#rc.edit#" displaytype="table" titleClass="varWidth" object="#rc.allSettings.order_orderPlacedEmailSubject#" title="#rc.$.Slatwall.rbKey('setting.order.orderPlacedEmailSubject')#" fieldName="order_orderPlacedEmailSubject">
				</table>
			</div>
			<div id="tabAdvanced">
				<table id="AdvancedSettings" class="listing-grid stripe">
					<tr>
						<th class="varWidth">#rc.$.Slatwall.rbKey('setting')#</th>
						<th>#rc.$.Slatwall.rbKey('setting.value')#</th>	
					</tr>
					<tr class="spdadvanced_logmessages">
						<td class="title varWidth">#rc.$.slatwall.rbKey('setting.advanced.logmessages')#</td>
						<cfif rc.edit>
							<td class="value">
								<select name="advanced_logmessages">
									<option value="None" <cfif rc.allSettings.advanced_logmessages.getSettingValue() eq "none">selected="selected"</cfif>>#$.slatwall.rbKey("define.none")#</option>
									<option value="General" <cfif rc.allSettings.advanced_logmessages.getSettingValue() eq "general">selected="selected"</cfif>>#$.slatwall.rbKey("define.general")#</option>
									<option value="Detail" <cfif rc.allSettings.advanced_logmessages.getSettingValue() eq "detail">selected="selected"</cfif>>#$.slatwall.rbKey("define.detail")#</option>
								</select>
							</td>
						<cfelse>
							<td class="value">#rc.allSettings.advanced_logMessages.getSettingValue()#</td>
						</cfif>
					</tr>
					<cf_SlatwallPropertyDisplay property="settingValue" edit="#rc.edit#" displaytype="table" titleClass="varWidth" object="#rc.allSettings.advanced_logExceptionsToDatabaseFlag#" title="#rc.$.Slatwall.rbKey('setting.advanced.logExceptionsToDatabaseFlag')#" fieldName="advanced_logExceptionsToDatabaseFlag" fieldType="radiogroup" valueOptions="#local.yesNoValueOptions#" valueFormatType="yesno">
					<cf_SlatwallPropertyDisplay property="settingValue" edit="#rc.edit#" displaytype="table" titleClass="varWidth" object="#rc.allSettings.advanced_logDatabaseClearAfterDays#" title="#rc.$.Slatwall.rbKey('setting.advanced.logDatabaseClearAfterDays')#" fieldName="advanced_logDatabaseClearAfterDays">
					<cf_SlatwallPropertyDisplay property="settingValue" edit="#rc.edit#" displaytype="table" titleClass="varWidth" object="#rc.allSettings.advanced_showRemoteIDFields#" title="#rc.$.Slatwall.rbKey('setting.advanced.showRemoteIDFields')#" fieldName="advanced_showRemoteIDFields" fieldType="radiogroup" valueOptions="#local.yesNoValueOptions#" valueFormatType="yesno">
					<cf_SlatwallPropertyDisplay property="settingValue" edit="#rc.edit#" displaytype="table" titleClass="varWidth" object="#rc.allSettings.advanced_dateFormat#" title="#rc.$.Slatwall.rbKey('setting.advanced.dateFormat')#" fieldName="advanced_dateFormat">
					<cf_SlatwallPropertyDisplay property="settingValue" edit="#rc.edit#" displaytype="table" titleClass="varWidth" object="#rc.allSettings.advanced_timeFormat#" title="#rc.$.Slatwall.rbKey('setting.advanced.timeFormat')#" fieldName="advanced_timeFormat">
					<cf_SlatwallPropertyDisplay property="settingValue" edit="#rc.edit#" displaytype="table" titleClass="varWidth" object="#rc.allSettings.advanced_currencyLocale#" title="#rc.$.Slatwall.rbKey('setting.advanced.currencyLocale')#" fieldName="advanced_currencyLocale" fieldType="select" valueOptions="#local.localeOptions#">
					<tr class="spdadvanced_currencyType">
						<td class="title varWidth">#rc.$.slatwall.rbKey('setting.advanced.currencyType')#</td>
						<cfif rc.edit>
							<td class="value">
								<select name="advanced_currencyType">
									<option value="None" <cfif rc.allSettings.advanced_currencyType.getSettingValue() eq "None">selected="selected"</cfif>>#$.slatwall.rbKey("define.none")#</option>
									<option value="Local" <cfif rc.allSettings.advanced_currencyType.getSettingValue() eq "Local">selected="selected"</cfif>>#$.slatwall.rbKey("define.local")#</option>
									<option value="International" <cfif rc.allSettings.advanced_currencyType.getSettingValue() eq "International">selected="selected"</cfif>>#$.slatwall.rbKey("define.international")#</option>
								</select>
							</td>
						<cfelse>
							<td class="value">#rc.allSettings.advanced_currencyType.getSettingValue()#</td>
						</cfif>
					</tr>
				</table>
			</div>
		</div>
		
		<cfif rc.edit eq true>
			<div id="actionButtons" class="clearfix">
				<cf_SlatwallActionCaller action="admin:setting.detail" type="link" class="button" text="#rc.$.Slatwall.rbKey('sitemanager.cancel')#">
				<cf_SlatwallActionCaller action="admin:setting.save" type="submit" class="button">
			</div>
		</form>
		</cfif>
	</div>
</cfoutput>
