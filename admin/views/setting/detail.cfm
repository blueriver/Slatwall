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

<cfoutput>
	<div class="svoadminsettingdetail">
		<cfif rc.edit eq false>
	        <ul id="navTask">
	            <cf_ActionCaller action="admin:setting.edit" type="list">
	        </ul>
		<cfelse>
			<form action="#buildURL(action='admin:setting.save')#" method="post">
		</cfif>
		<div class="tabs initActiveTab ui-tabs ui-widget ui-widget-content ui-corner-all">
			<ul>
				<li><a href="##tabProduct" onclick="return false;"><span>#rc.$.Slatwall.rbKey('setting.product')#</span></a></li>	
				<li><a href="##tabOrder" onclick="return false;"><span>#rc.$.Slatwall.rbKey('setting.order')#</span></a></li>
				<li><a href="##tabAccount" onclick="return false;"><span>#rc.$.Slatwall.rbKey('setting.account')#</span></a></li>
			</ul>
			<div id="tabProduct">
				<table id="ProductSettings" class="stripe">
					<tr>
						<th class="varWidth">#rc.$.Slatwall.rbKey('setting')#</th>
						<th>#rc.$.Slatwall.rbKey('setting.value')#</th>	
					</tr>
					<tr class="spdproduct_defaulttemplate">
						<td class="property varWidth">#rc.$.Slatwall.rbKey('setting.product.defaultProductTemplate')#</td>
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
					<cf_PropertyDisplay object="#rc.allSettings.product_urlKey#" title="#rc.$.Slatwall.rbKey('setting.product.urlKey')#" property="settingValue" fieldName="product_urlKey" edit="#rc.edit#" dataType="text" editType="text" displaytype="table">
					<cf_PropertyDisplay object="#rc.allSettings.product_imagewidthsmall#" title="#rc.$.Slatwall.rbKey('setting.product.imagewidthsmall')#" property="settingValue" fieldName="product_imagewidthsmall" edit="#rc.edit#" dataType="text" editType="text" displaytype="table">
					<cf_PropertyDisplay object="#rc.allSettings.product_imageheightsmall#" title="#rc.$.Slatwall.rbKey('setting.product.imageheightsmall')#" property="settingValue" fieldName="product_imageheightsmall" edit="#rc.edit#" dataType="text" editType="text" displaytype="table">
					<cf_PropertyDisplay object="#rc.allSettings.product_imagewidthmedium#" title="#rc.$.Slatwall.rbKey('setting.product.imagewidthmedium')#" property="settingValue" fieldName="product_imagewidthmedium" edit="#rc.edit#" dataType="text" editType="text" displaytype="table">
					<cf_PropertyDisplay object="#rc.allSettings.product_imageheightmedium#" title="#rc.$.Slatwall.rbKey('setting.product.imageheightmedium')#" property="settingValue" fieldName="product_imageheightmedium" edit="#rc.edit#" dataType="text" editType="text" displaytype="table">
					<cf_PropertyDisplay object="#rc.allSettings.product_imagewidthlarge#" title="#rc.$.Slatwall.rbKey('setting.product.imagewidthlarge')#" property="settingValue" fieldName="product_imagewidthlarge" edit="#rc.edit#" dataType="text" editType="text" displaytype="table">
					<cf_PropertyDisplay object="#rc.allSettings.product_imageheightlarge#" title="#rc.$.Slatwall.rbKey('setting.product.imageheightlarge')#" property="settingValue" fieldName="product_imageheightlarge" edit="#rc.edit#" dataType="text" editType="text" displaytype="table">
					<cf_PropertyDisplay object="#rc.allSettings.product_trackInventoryFlag#" title="#rc.$.Slatwall.rbKey('setting.product.trackInventoryFlag')#" property="settingValue" fieldName="product_trackInventoryFlag" edit="#rc.edit#" dataType="boolean" editType="radiogroup" displaytype="table">
				    <cf_PropertyDisplay object="#rc.allSettings.product_callToOrderFlag#" title="#rc.$.Slatwall.rbKey('setting.product.callToOrderFlag')#" property="settingValue" fieldName="product_callToOrderFlag" edit="#rc.edit#" dataType="boolean" editType="radiogroup" displaytype="table">
				    <cf_PropertyDisplay object="#rc.allSettings.product_allowShippingFlag#" title="#rc.$.Slatwall.rbKey('setting.product.allowShippingFlag')#" property="settingValue" fieldName="product_allowShippingFlag" edit="#rc.edit#" dataType="boolean" editType="radiogroup" displaytype="table">
				    <cf_PropertyDisplay object="#rc.allSettings.product_allowPreorderFlag#" title="#rc.$.Slatwall.rbKey('setting.product.allowPreorderFlag')#" property="settingValue" fieldName="product_allowPreorderFlag" edit="#rc.edit#" dataType="boolean" editType="radiogroup" displaytype="table">
					<cf_PropertyDisplay object="#rc.allSettings.product_allowBackorderFlag#" title="#rc.$.Slatwall.rbKey('setting.product.allowBackorderFlag')#" property="settingValue" fieldName="product_allowBackorderFlag" edit="#rc.edit#" dataType="boolean" editType="radiogroup" displaytype="table">
					<cf_PropertyDisplay object="#rc.allSettings.product_allowDropshipFlag#" title="#rc.$.Slatwall.rbKey('setting.product.allowDropshipFlag')#" property="settingValue" fieldName="product_allowDropshipFlag" edit="#rc.edit#" dataType="boolean" editType="radiogroup" displaytype="table">
				</table>
			</div>
			<div id="tabOrder">
				<table id="OrderSettings" class="stripe">
					<tr>
						<th class="varWidth">#rc.$.Slatwall.rbKey('setting')#</th>
						<th>#rc.$.Slatwall.rbKey('setting.value')#</th>	
					</tr>
					<cf_PropertyDisplay object="#rc.allSettings.order_notificationEmailTo#" title="#rc.$.Slatwall.rbKey('setting.order.newOrderNotifyTo')#" property="settingValue" fieldName="order_notificationEmailTo" edit="#rc.edit#" dataType="text" editType="text" displaytype="table">
					<cf_PropertyDisplay object="#rc.allSettings.order_notificationEmailFrom#" title="#rc.$.Slatwall.rbKey('setting.order.newOrderNotifyFrom')#" property="settingValue" fieldName="order_notificationEmailFrom" edit="#rc.edit#" dataType="text" editType="text" displaytype="table">
				</table>
			</div>
			<div id="tabAccount">
				
			</div>
		</div>
		
		<cfif rc.edit eq true>
			<div id="actionButtons" class="clearfix">
				<cf_actionCaller action="admin:setting.detail" type="link" class="button" text="#rc.$.Slatwall.rbKey('sitemanager.cancel')#">
				<cf_ActionCaller action="admin:setting.save" type="submit" class="button">
			</div>
		</form>
		</cfif>
	</div>
</cfoutput>
