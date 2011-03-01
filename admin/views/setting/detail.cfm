<cfparam name="rc.edit" type="boolean" />
<cfparam name="rc.allSettings" type="struct" />
<cfparam name="rc.productTemplateOptions" type="any" /> 

<cfoutput>
	<div class="svoadminsettingdetail">
		<cfif rc.edit eq false>
			<cf_ActionCaller action="admin:setting.edit">
		<cfelse>
			<form action="#buildURL(action='admin:setting.save')#" method="post">
		</cfif>
		
		<div class="tabs initActiveTab ui-tabs ui-widget ui-widget-content ui-corner-all">
			<ul>
				<li><a href="##tabProduct" onclick="return false;"><span>Product</span></a></li>	
				<li><a href="##tabOrder" onclick="return false;"><span>Order</span></a></li>
				<li><a href="##tabAccount" onclick="return false;"><span>Account</span></a></li>
			</ul>
			<div id="tabProduct">
				<table id="ProductSettings" class="listtable stripe">
					<tr>
						<th class="varWidth">Setting</th>
						<th>Value</th>	
					</tr>
					<cf_PropertyDisplay object="#rc.allSettings.product_trackInventory#" title="Track Inventory" property="settingValue" fieldName="product_trackInventory" edit="#rc.edit#" dataType="boolean" editType="checkbox" displaytype="table">
					<cf_PropertyDisplay object="#rc.allSettings.product_urlKey#" class="alt" title="URL Key" property="settingValue" fieldName="product_urlKey" edit="#rc.edit#" dataType="text" editType="text" displaytype="table">
					<tr class="spdproduct_defaulttemplate">
						<td class="property varWidth">Default Product Template</td>
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
				</table>
			</div>
			<div id="tabOrder">
				<table id="OrderSettings" class="listtable stripe">
					<tr>
						<th class="varWidth">Setting</th>
						<th>Value</th>	
					</tr>
					<cf_PropertyDisplay object="#rc.allSettings.order_notificationEmailTo#" title="New Order Notification E-Mail To" property="settingValue" fieldName="order_notificationEmailTo" edit="#rc.edit#" dataType="text" editType="text" displaytype="table">
					<cf_PropertyDisplay object="#rc.allSettings.order_notificationEmailFrom#" class="alt" title="New Order Notification E-Mail From" property="settingValue" fieldName="order_notificationEmailFrom" edit="#rc.edit#" dataType="text" editType="text" displaytype="table">
				</table>
			</div>
			<div id="tabAccount">
				
			</div>
		</div>
		
		<cfif rc.edit eq true>
			<button type="submit">Save</button>
		</form>
		</cfif>
	</div>
</cfoutput>