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
					<cf_PropertyDisplay object="#rc.allSettings.product_urlKey#" title="#rc.$.Slatwall.rbKey('setting.product.urlKey')#" property="settingValue" fieldName="product_urlKey" edit="#rc.edit#" dataType="text" editType="text" displaytype="table">
					<tr class="spdproduct_defaulttemplate">
						<td class="property varWidth">#rc.$.Slatwall.rbKey('setting.product.defaultProductTemplate')#</td>
						<cfif rc.edit>
							<td id="spdproduct_defaulttemplate" class="value">
								<select name="product_defaulttemplate">
									<cfloop query="rc.productTemplateOptions">
										<option value="#rc.productTemplateOptions.name#" <cfif rc.allSettings.product_defaultTemplate.getSettingValue() eq rc.productTemplateOptions.name>selected="selected"</cfif>>#rc.productTemplateOptions.name#</option>
									</cfloop>
								</select>
							</td>
						<cfelse>
							<td id="spdproduct_defaulttemplate" class="value">#rc.allSettings.product_defaultTemplate.getSettingValue()#</td>	
						</cfif>
					</tr>
					<!--- Next Setting Here --->
				    <cf_PropertyDisplay object="#rc.allSettings.product_manufactureDiscontinued#" title="#rc.$.Slatwall.rbKey('setting.product.manufactureDiscontinued')#" property="settingValue" fieldName="product_manufactureDiscontinued" edit="#rc.edit#" dataType="boolean" editType="radioGroup" displaytype="table">
					<cf_PropertyDisplay object="#rc.allSettings.product_showOnWeb#" title="#rc.$.Slatwall.rbKey('setting.product.showOnWeb')#" property="settingValue" fieldName="product_showOnWeb" edit="#rc.edit#" dataType="boolean" editType="radiogroup" displaytype="table">
					<cf_PropertyDisplay object="#rc.allSettings.product_showOnWebWholesale#" title="#rc.$.Slatwall.rbKey('setting.product.showOnWebWholeSale')#" property="settingValue" fieldName="product_showOnWebWholeSale" edit="#rc.edit#" dataType="boolean" editType="radiogroup" displaytype="table">
				    <cf_PropertyDisplay object="#rc.allSettings.product_trackInventory#" title="#rc.$.Slatwall.rbKey('setting.product.trackInventory')#" property="settingValue" fieldName="product_nonInventory" edit="#rc.edit#" dataType="boolean" editType="radiogroup" displaytype="table">
				    <cf_PropertyDisplay object="#rc.allSettings.product_callToOrder#" title="#rc.$.Slatwall.rbKey('setting.product.callToOrder')#" property="settingValue" fieldName="product_callToOrder" edit="#rc.edit#" dataType="boolean" editType="radiogroup" displaytype="table">
				    <cf_PropertyDisplay object="#rc.allSettings.product_allowShipping#" title="#rc.$.Slatwall.rbKey('setting.product.allowShipping')#" property="settingValue" fieldName="product_allowShipping" edit="#rc.edit#" dataType="boolean" editType="radiogroup" displaytype="table">
				    <cf_PropertyDisplay object="#rc.allSettings.product_allowPreorder#" title="#rc.$.Slatwall.rbKey('setting.product.allowPreorder')#" property="settingValue" fieldName="product_allowPreorder" edit="#rc.edit#" dataType="boolean" editType="radiogroup" displaytype="table">
					<cf_PropertyDisplay object="#rc.allSettings.product_allowBackorder#" title="#rc.$.Slatwall.rbKey('setting.product.allowBackorder')#" property="settingValue" fieldName="product_allowBackorder" edit="#rc.edit#" dataType="boolean" editType="radiogroup" displaytype="table">
					<cf_PropertyDisplay object="#rc.allSettings.product_allowDropship#" title="#rc.$.Slatwall.rbKey('setting.product.allowDropship')#" property="settingValue" fieldName="product_allowDropship" edit="#rc.edit#" dataType="boolean" editType="radiogroup" displaytype="table">
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
				<cf_ActionCaller action="admin:setting.save" type="submit">
			</div>
		</form>
		</cfif>
	</div>
</cfoutput>