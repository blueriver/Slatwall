<cfoutput>
	<div class="svoadminsettingdetail">
		<cfif rc.edit eq false>
			<a href="#buildURL(action='admin:setting.edit')#">Edit Settings</a>
		<cfelse>
			<form action="?action=admin:setting.save" method="post">
				<input type="hidden" name="Test" value="Yest" />
		</cfif>
		
		<div class="tabs initActiveTab ui-tabs ui-widget ui-widget-content ui-corner-all">
			<ul>
				<li><a href="##tabProduct" onclick="return false;"><span>Product</span></a></li>	
				<li><a href="##tabOrder" onclick="return false;"><span>Order</span></a></li>
				<li><a href="##tabAccount" onclick="return false;"><span>Account</span></a></li>
			</ul>
			<div id="tabProduct">
				<cf_PropertyDisplay object="#rc.settingService.getBySettingName('product.trackInventory')#" title="Track Inventory" property="settingValue" fieldName="product_trackInventory" edit="#rc.edit#" dataType="boolean" editType="checkbox">
			</div>
			<div id="tabOrder">
				
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